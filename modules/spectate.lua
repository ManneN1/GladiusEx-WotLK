local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local LSM = LibStub("LibSharedMedia-3.0")
local fn = LibStub("LibFunctional-1.0")
local CT = LibStub("LibCooldownTracker-1.0")
local LibAuraInfo = LibStub("LibAuraInfo-1.0")

-- global functions
local strfind = string.find
local select, pairs, unpack = select, pairs, unpack
local UnitExists, UnitIsUnit, UnitClass = UnitExists, UnitIsUnit, UnitClass
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

local defaults = {
    useServerData = false, -- Warmane doesn't send the data consistently so it's not possible to use
}

Spectate = Spectate and Spectate or GladiusEx:NewGladiusExModule("Spectate", nil, defaults)

local arena_units = {
    ["arena1"] = true,
    ["arena2"] = true,
    ["arena3"] = true,
    ["arena4"] = true,
    ["arena5"] = true,
    ["arenapet1"] = true,
    ["arenapet2"] = true,
    ["arenapet3"] = true,
    ["arenapet4"] = true,
    ["arenapet5"] = true,
}

Spectate.methodsByModule = {
    ["HealthBar"] = {
        ["UNIT_HEALTH"] = "UpdateHealthEvent",
        ["UNIT_MAXHEALTH"] = "UpdateHealthEvent",
    },
    ["Tags"] = {
        ["GLADIUSEX_SPEC_UPDATE"] = "OnEvent",
        ["UNIT_HEALTH"] = "OnEvent",
        ["UNIT_HEALTH_FREQUENT"] = "OnEvent",
        ["UNIT_MAXHEALTH"] = "OnEvent",
        ["UNIT_ABSORB_AMOUNT_CHANGED"] = "OnEvent",
        ["UNIT_MANA"] = "OnEvent",
        ["UNIT_ENERGY"] = "OnEvent",
        ["UNIT_RAGE"] = "OnEvent",
        ["UNIT_RUNIC"] = "OnEvent",
        ["GLADIUSEX_UNIT_POWER_FREQUENT"] = "OnEvent",
        ["UNIT_DISPLAYPOWER"] = "OnEvent",
        ["UNIT_MAXMANA"] = "OnEvent",
        ["UNIT_MAXENERGY"] = "OnEvent",
        ["UNIT_MAXRAGE"] = "OnEvent",
        ["UNIT_MAXRUNIC_POWER"] = "OnEvent",
        ["UNIT_NAME_UPDATE"] = "OnEvent",
    },
    ["PowerBar"] = {
        ["UNIT_DISPLAYPOWER"] = "UpdateColorEvent",
        ["UNIT_MAXMANA"] = "UpdatePowerEvent",
        ["UNIT_MAXRAGE"] = "UpdatePowerEvent",
        ["UNIT_MAXRUNIC_POWER"] = "UpdatePowerEvent",
        ["UNIT_MAXENERGY"] = "UpdatePowerEvent",
        ["UNIT_MAXMANA"] = "UpdatePowerEvent",
        ["UNIT_ENERGY"] = "UpdatePowerEvent",
        ["UNIT_RAGE"] = "UpdatePowerEvent",
        ["UNIT_RUNIC_POWER"] = "UpdatePowerEvent",
    },
    ["DRTracker"] = false,
    ["CastBar"] = {
        ["UNIT_SPELLCAST_INTERRUPTED"] = "UNIT_SPELLCAST_STOP",
        ["UNIT_SPELLCAST_CHANNEL_STOP"] = "UNIT_SPELLCAST_STOP",
        ["UNIT_SPELLCAST_CHANNEL_UPDATE"] = "UNIT_SPELLCAST_DELAYED",
    },
    ["TargetBar"] = {
        ["UNIT_TARGET"] = "UNIT_TARGET_SPECTATE",
    },
    ["Auras"] = {
        ["UNIT_AURA"] = "UpdateUnitAuras",
    },
}


-- INIT / SETUP


function Spectate:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
end

function Spectate:OnDisable()
    self:UnregisterAllEvents()
    self:UnregisterAllMessages()
end

function Spectate:OnProfileChanged()
    self.super.OnProfileChanged(self)
end

function Spectate:FireEventForAllModules(unit, event, ...)
	for n, m in GladiusEx:IterateModules() do
        if m ~= self and GladiusEx:IsModuleEnabled(unit, n) then
            local mName = m:GetName()

            if self.methodsByModule[mName] ~= nil then

                local data = Spectate.methodsByModule[mName]
                
                if data then
                    if data[event] and m[data[event]] then
                        m[data[event]](m, event, ...)
                    elseif m[event] and type(m[event]) == "function" then
                        m[event](m, event, ...)
                    end
                end
            elseif m[event] and type(m[event]) == "function" then
                m[event](m, event, ...)
            end
        end
    end

	if GladiusEx[event] and type(GladiusEx[event]) == "function" then
		GladiusEx[event](GladiusEx, event, ...)
	end
end

function Spectate:IsSpectating()
	return self.isSpectating ~= nil and self.isSpectating or false
end

function Spectate:StartSpectate()
    self.isSpectating = true
    self.units = {}
    self.initUnits = {}
    self.foundUnits = {}
    
    GladiusEx.buttons["player"].class = nil
    GladiusEx.buttons["player"].specID = nil
    
    GladiusEx.knownSpecs = nil
    
	local alerts = GladiusEx:GetModule("Alert", true)
	if alert then alert:OnDisable() end
	
	local announcements = GladiusEx:GetModule("Announcement", true)
	if announcements then announcements:OnDisable() end
    
    local highlight = GladiusEx:GetModule("Highlight", true)
	if highlight then highlight:OnDisable() end

    if not self.db["player"].useServerData then
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED")
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_REFRESH")
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED_DOSE")
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_REMOVED")
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_CLEAR")
        LibAuraInfo.RegisterCallback(self, "LibAuraInfo_AURA_UPDATE_REAL")
    end

    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self:RegisterEvent("UNIT_TARGET")
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    
    Spectate.spectatorFunctions["REMAUR"] = Spectate.db["player"].useServerData and Spectate.RemoveUnitAura or false
    
	GladiusEx:UpdateFrames()
end

function Spectate:StopSpectate()
    self.isSpectating = false
    self.units = nil
    self.initUnits = {}

    LibAuraInfo.UnregisterAllCallbacks(self)

    CT.UnregisterAllCallbacks(self)

    self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self:UnregisterEvent("UNIT_TARGET")
    self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function Spectate:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, ...)
    if Spectate[eventType] then
        Spectate[eventType](self, ...)
    end
end



-- INTERNAL SUPPORT


function Spectate:HasSpectatorUnit(guid)
	return self.units[guid] ~= nil
end

function Spectate:IsArenaUnit(unit)
    return arena_units[unit]
end

function Spectate:GetUnitIdByGUID(guid)
    if not self:IsSpectating() then return GladiusEx:GetUnitIdByGUID(guid) end
    return self.units and self.units[guid] or nil
end

function Spectate:AddUnit(guid)
	
	for i=1,5 do
		local aUnit = "arena"..i
		if UnitExists(aUnit) and UnitGUID(aUnit) == guid then
			return nil -- don't add enemy units (they're automatically tracked anyway)
		end
	end
	
    if self.units[guid] then return nil end -- unit already exists
    
	for i=1,5 do -- get the first available not already used player/party unitID
		local unit = i == 1 and "player" or "party"..(i-1)
		local exists = self.units[unit]

		if exists == nil then
			self.units[unit] = { GUID = guid, classID = nil, name = nil, currentHP = 1, maxHP = 1, currentPower = 1, maxPower = 1, powerType = 1, buffs = {}, debuffs = {}, pet = { id = nil, currentHP = 1 } }
			self.units[guid] = unit

			GladiusEx:UpdateUnit(unit)
			GladiusEx:ShowUnit(unit)
			return unit
		end
	end
	
	return nil
end


-- GAME SUPPORT


function Spectate:IsInterruptImmune(unit)
    local hasOther = false
    local t = GetTime()
    for i = 1, 40 do
        local _, _, _, _, _, _, expirationTime, _, _, _, spellID = self.UnitBuff(unit, i)
        
        
        if (not expirationTime or expirationTime > t) and GladiusEx.Data.auraImmunities[spellID] then
            if spellID == 31821 or spellID == 19746 then -- Concentration Aura + Aura Mastery
                if hasOther then
                    return true
                else
                    hasOther = true
                end
            else
                return true
            end
        end
    end

    return false
end


-- SERVER DATA PARSING


-- Graciously borrowed some code from the AzerothCore arena-spectator: https://github.com/azerothcore/arena-spectator/blob/master/SunwellAS.lua
Spectate.initUnits = {}
local THRESHOLD_DELAY_INIT_DATA = 0.002
function Spectate:ParseSpectatorServerData(data)
    local pos = 1
    local stop = 1
    local targetGUID = nil
    
    if data:find(';AUR=') then
        local targetGUID, preData = strsplit(";", data)

        if not self:HasSpectatorUnit(targetGUID) then
            local addedUnit = self:AddUnit(targetGUID)
			if not addedUnit then
				return
			end
        end

        local _, preData = strsplit("=", preData)
        local prefix, stacks, expiration, duration, spellID, auraType, isDebuff, casterGUID = strsplit(",", preData)
		
		local unit = self:GetUnitIdByGUID(targetGUID)
        
        
        local t = GetTime()

        if not self.db[unit].useServerData then
            if self.initUnits[unit] then
                if t > self.initUnits[unit] then
                    return
                end
            else
                self.initUnits[unit] = t + THRESHOLD_DELAY_INIT_DATA
                self.initUnits.count = self.initUnits.count and self.initUnits.count + 1 or 1
            end
        end
		
        local actualPrefix = prefix == "0" and "ADDAUR" or "REMAUR"
        
        local fnction = self.spectatorFunctions[actualPrefix]
        
        if fnction then
            stacks = tonumber(stacks)
            expiration = t + tonumber(expiration) / 1000
            duration = tonumber(duration) / 1000
            spellID = tonumber(spellID)
            auraType = tonumber(auraType)
            isDebuff = tonumber(isDebuff) == 0 and true or false
            
            fnction(self, unit, stacks, expiration, duration, spellID, auraType, isDebuff, casterGUID)
            
            if not self.db[unit].useServerData then
                
            end
            
            self:FireEventForAllModules(unit, "UNIT_AURA", unit)
        end

        return
    end

    stop = strfind(data, ";", pos)
    targetGUID = strsub(data, 1, stop - 1)
    pos = stop + 1
	
	
	if not self:HasSpectatorUnit(targetGUID) then
		local addedUnit = self:AddUnit(targetGUID)
		if not addedUnit then
			return
		end
	end
	
	local unit = self:GetUnitIdByGUID(targetGUID)
	
    repeat
        stop = strfind(data, ";", pos)
        if (stop ~= nil) then
            local command = strsub(data, pos, stop - 1)
            pos = stop + 1

            local prefix = strsub(command, 1, strfind(command, "=") - 1)
            local value = strsub(command, strfind(command, "=") + 1)
            
            local spectatorFunction = self.spectatorFunctions[prefix]
            
            if spectatorFunction and type(spectatorFunction) == "function" then
                if value and strfind(value, ",") then
					spectatorFunction(self, unit, strsplit(",", value))
				else
					spectatorFunction(self, unit, value)
				end
			elseif spectatorFunction == nil then
                print("Unsupported Spectator Prefix:", prefix, value)
            end
        end
    until stop == nil
end

function Spectate:CHAT_MSG_ADDON(event, prefix, text, channel, sender)
    local _, instanceType = IsInInstance()
	
	if instanceType ~= "arena" then return end
	
	
	if (event == "CHAT_MSG_ADDON") and (prefix == "ARENASPEC") and (channel == "WHISPER") and (sender == "") then
        if not self:IsSpectating() then
            self:StartSpectate()
        end
        self:ParseSpectatorServerData(text)
    end
end


-- CHECKERS VIA TARGET/MOUSEOVER

Spectate.foundUnits = {}
function Spectate:UNIT_TARGET(event, unit, recursive)
    
    if not unit or not self.units then return end
    
    
    if UnitIsUnit(unit, "player") then
        unit = ""
    end

    local target = unit == "mouseover" and unit or unit.."target"

    if UnitExists(target) then
        self:CheckUnitRace(target)
        self:CheckUnitName(target)
        self:CheckUnitPower(target)
        self:CheckUnitClass(target)
        self:CheckUnitHealth(target)
    end
    
    -- check if we've found all units (if we found a new unit we need to add it)
    if UnitIsPlayer(target) then
        local guid = UnitGUID(target)
        local actual_unit = self:GetUnitIdByGUID(guid)
        if not actual_unit then
            actual_unit = self:AddUnit(guid)
        end

        if actual_unit and not self.foundUnits[actual_unit] then
            self.foundUnits[actual_unit] = true
            self.foundUnits.count = self.foundUnits.count and self.foundUnits.count + 1 or 1

            local num = GladiusEx:GetArenaSize()

            if self.foundUnits.count and self.foundUnits.count >= num then
                self:UnregisterEvent("UNIT_TARGET")
                self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
                return
            end
        end
    end
    
        
    local targetof = target.."target"
    
    if UnitExists(targetof) then
        actual_unit = self:GetUnitIdByGUID(UnitGUID(targetof))
        
        if actual_unit and (not recursive or not recursive[actual_unit]) then
            recursive = recursive and recursive or {}
            recursive[actual_unit] = true
        
            self:UNIT_TARGET(event, target, recursive)
        end
    end
end

function Spectate:UPDATE_MOUSEOVER_UNIT(event)
    self:UNIT_TARGET("UNIT_TARGET", "mouseover")
end

function Spectate:CheckUnitClass(unit)
    local guid = UnitGUID(unit)
    
    local actual_unit = self:GetUnitIdByGUID(guid)
    if not actual_unit or not self.units or not self.units[actual_unit] or self.units[actual_unit].classID then return end
    
    local _, className = UnitClass(unit)
    
    local classID = GladiusEx.Data.classIDByClassName[className]

    self:SetUnitClass(actual_unit, classID)
end

function Spectate:CheckUnitName(unit)
    local guid = UnitGUID(unit)
    
    local actual_unit = self:GetUnitIdByGUID(guid)
    if not actual_unit or not self.units or not self.units[actual_unit] or self.units[actual_unit].name then return end
    
    local name = UnitName(unit)
    
    if name:find("Replay") then
        name = strreplace(name, " (Replay)", "")
    end
    
    self:SetUnitName(actual_unit, name)
end

function Spectate:CheckUnitRace(unit)
    local guid = UnitGUID(unit)
    
    local actual_unit = self:GetUnitIdByGUID(guid)
    if not actual_unit or not self.units or not self.units[actual_unit] or self.units[actual_unit].raceID then return end
    
    race, enRace = UnitRace(unit)
    
    local raceID = GladiusEx.Data.raceNamesByID[enRace]

    if raceID then
        self:SetUnitRace(actual_unit, raceID)
    end
end

function Spectate:CheckUnitHealth(unit)
    local guid = UnitGUID(unit)
    
    local actual_unit = self:GetUnitIdByGUID(guid)
    if not actual_unit or not self.units or not self.units[actual_unit] or self.units[actual_unit].maxHP ~= 1 then return end
    
    self:SetUnitMaxHP(actual_unit, UnitHealthMax(unit))
    self:SetUnitCurrentHP(actual_unit, UnitHealth(unit))
end

function Spectate:CheckUnitPower(unit)
    local guid = UnitGUID(unit)
    
    local actual_unit = self:GetUnitIdByGUID(guid)
    if not actual_unit or not self.units or not self.units[actual_unit] or self.units[actual_unit].maxPower ~= 1 then return end
    
    self:SetUnitPowerType(actual_unit, UnitPowerType(unit))
    self:SetUnitMaxPower(actual_unit, UnitPowerMax(unit))
    self:SetUnitCurrentPower(actual_unit, UnitPower(unit))
end


-- SETTERS & ACTIVATORS

-- AURAS

function Spectate.LibAuraInfo_AURA_UPDATE_REAL(self, event, dstGUID, filterType)
    if not dstGUID then return end


    local unit = self:GetUnitIdByGUID(dstGUID)
    if not unit or not self.units or not self.units[unit] then return end
    
    local container = filterType == "HARMFUL" and self.units[unit].debuffs or self.units[unit].buffs
    
    local auras = {}
    
    -- get rid of all auras
    container = {}
    if filterType == "HARMFUL" then
        self.units[unit].debuffs = container
    else
        self.units[unit].buffs = container
    end
    
    -- add all auras from LibAuraInfo into the container again
    for i = 1, LibAuraInfo:GetNumGUIDAuras(dstGUID) do
        local hasAura, stacks, _, duration, expiration, isDebuff, casterGUID, spellID = LibAuraInfo:GUIDAura(dstGUID, i)
        
        if not hasAura then break end
        
        if (filterType == "HARMFUL" and isDebuff) or (filterType == "HELPFUL" and not isDebuff) then
            
            local name, rank, icon = GetSpellInfo(spellID)
            local auraType = GladiusEx.Data.auraTypesByID[LibAuraInfo:GetDebuffType(spellID)]
            
            local casterUnit = self:GetUnitIdByGUID(casterGUID) and self:GetUnitIdByGUID(casterGUID) or GladiusEx:GetUnitIdByGUID(casterGUID)
       
            local aura = {
                name,
                rank,
                icon,
                stacks, 
                auraType,
                duration,
                expiration,
                casterUnit,
                0,
                0,
                spellID,
                casterGUID,
                true, -- these are all from LibAuraInfo
            }
           
            table.insert(container, aura)
        end
    end
end

function Spectate.LibAuraInfo_AURA_APPLIED(self, event, dstGUID, spellID, srcGUID, spellSchool)
    
    if not srcGUID then return end

    local unit = self:GetUnitIdByGUID(dstGUID) -- self.units[destGUID] = unitID, self.units[unitID] = { ... data .. }

    if not unit or not self.units or not self.units[unit] then return end
        
    local name, _, icon = GetSpellInfo(spellID)
    
    local _, count, _, duration, expiration, isDebuff = LibAuraInfo:GUIDAuraID(dstGUID, spellID, srcGUID)
    
    local auraType = GladiusEx.Data.auraTypesByID[LibAuraInfo:GetDebuffType(spellID)]

    self:AddUnitAura(unit, count, expiration, duration, spellID, auraType, isDebuff, srcGUID, true)
end

function Spectate.LibAuraInfo_AURA_REFRESH(self, event, dstGUID, spellID, srcGUID, spellSchool, auraType, fromDose)

    if not srcGUID then return end

    local unit = self:GetUnitIdByGUID(dstGUID)

    if not unit or not self.units or not self.units[unit] then return end
    
    local name, _, icon = GetSpellInfo(spellID)
    local _, count, _, duration, expirationTime, isDebuff = LibAuraInfo:GUIDAuraID(dstGUID, spellID, srcGUID)
    
    local casterUnit = self:GetUnitIdByGUID(srcGUID) and self:GetUnitIdByGUID(srcGUID) or GladiusEx:GetUnitIdByGUID(srcGUID)
    
    auraType = GladiusEx.Data.auraTypesByID[LibAuraInfo:GetDebuffType(spellID)]
    
    local container = isDebuff and self.units[unit].debuffs or self.units[unit].buffs
    
    local auras = {}

    for i, aura in pairs(container) do
        if aura[11] == spellID then
            if (not aura[7] and not expirationTime) or (aura[7] and not expirationTime) or (aura[7] and expirationTime and aura[7] <= expirationTime) then
                if aura[12] and aura[12] == srcGUID then
                    auras = { [1] = aura }
                    break
                elseif #auras == 0 then
                    table.insert(auras, aura)
                end
            end
        end
    end

    if #auras ~= 0 then
        local aura = auras[1]
        aura[6] = duration
        aura[4] = count
        aura[7] = expirationTime
        aura[12] = aura[12] and aura[12] or srcGUID
         
        if aura.timer then
            GladiusEx:CancelTimer(aura.timer)
            aura.timer = GladiusEx:ScheduleTimer(self.RemoveUnitAura, expirationTime - GetTime() - 0.05, self, unit, count, expirationTime, duration, spellID, auraType, isDebuff, srcGUID, true)
        end
    end
    
    if #auras == 0 then
        self:AddUnitAura(unit, count, expirationTime, duration, spellID, auraType, isDebuff, srcGUID, true)
    else
        self:FireEventForAllModules(unit, "UNIT_AURA", unit)
    end
end

function Spectate.LibAuraInfo_AURA_APPLIED_DOSE(self, event, dstGUID, spellID, srcGUID, spellSchool, auraType, stackCount, expirationTime)
    if not srcGUID then return end

    local unit = self:GetUnitIdByGUID(dstGUID)

    if not unit or not self.units or not self.units[unit] then return end

    self.LibAuraInfo_AURA_REFRESH(self, event, dstGUID, spellID, srcGUID, spellSchool, auraType, true)
end

function Spectate.LibAuraInfo_AURA_REMOVED(self, event, dstGUID, spellID, srcGUID, spellSchool, auraType, isDebuff, duration, expirationTime, stackCount)
    
    local unit = self:GetUnitIdByGUID(dstGUID)
    local name = GetSpellInfo(spellID)

    
    if not srcGUID then return end

    if not unit or not self.units or not self.units[unit] then return end
    
    auraType = GladiusEx.Data.auraTypesByID[LibAuraInfo:GetDebuffType(spellID)]
    
    self:RemoveUnitAura(unit, stackCount, expirationTime, duration, spellID, auraType, isDebuff, srcGUID, true)
end

function Spectate.LibAuraInfo_AURA_CLEAR(self, event, dstGUID)
    
    if not dstGUID then return end

    local unit = self:GetUnitIdByGUID(dstGUID)

    if not unit or not self.units or not self.units[unit] then return end
    
    self:ResetUnitAuras(unit, true)
end

function Spectate:AddUnitAura(unit, stacks, expiration, duration, spellID, auraType, isDebuff, casterGUID, isFake)
    if not casterGUID or not self.units or not self.units[unit] then return end
	
	local container = isDebuff and self.units[unit].debuffs or self.units[unit].buffs
	
	local name, rank, icon = GetSpellInfo(spellID)
	
    local t = GetTime()
    if expiration - t < 1 then
        expiration = 0
        duration = 0
    end
    
    local casterUnit = self:GetUnitIdByGUID(casterGUID) and self:GetUnitIdByGUID(casterGUID) or GladiusEx:GetUnitIdByGUID(casterGUID)
    
    local wasInterruptImmune = self:IsInterruptImmune(unit)
    
	local aura = { 
		name,
		rank,
		icon,
		stacks, 
		GladiusEx.Data.auraTypesByID[auraType],
		duration,
		expiration,
		casterUnit,
		0,
		0,
		spellID,
        casterGUID,
        isFake,
	}
    
    if not isFake and not self.db[unit].useServerData and expiration ~= 0 then
        local timer = GladiusEx:ScheduleTimer(self.RemoveUnitAura, expiration - t - 0.05, self, unit, stacks, expiration, duration, spellID, auraType, isDebuff, casterGUID)
        aura.timer = timer
    end
    
    table.insert(container, aura)

	self:FireEventForAllModules(unit, "UNIT_AURA", unit)

    
    local isInterruptImmune = self:IsInterruptImmune(unit)
    
    if not wasInterruptImmune ~= isInterruptImmune then
        local event = isInterruptImmune and "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" or "UNIT_SPELLCAST_INTERRUPTIBLE"
        self:FireEventForAllModules(unit, event, unit)
    end
end

function Spectate:RemoveUnitAura(unit, stacks, expirationTime, duration, spellID, auraType, isDebuff, casterGUID, isFake)

    if not casterGUID or not self.units or not self.units[unit] then return end
	
	local container = isDebuff and self.units[unit].debuffs or self.units[unit].buffs
    local name = GetSpellInfo(spellID)
	
    local auras = {}
    for i, aura in pairs(container) do
        if aura[11] == spellID then
            if (not aura[7] and not expirationTime) or (aura[7] and not expirationTime) or (aura[7] and expirationTime and aura[7] == expirationTime) then
                if aura[12] and aura[12] == srcGUID then
                    auras = { [1] = { aura = aura, index = i } }
                    break
                elseif #auras == 0 then
                    table.insert(auras, { aura = aura, index = i })
                end
            end
        end
    end

    if #auras ~= 0 then
        local aura = auras[1].aura
        local index = auras[1].index
        
        if aura.timer then
            GladiusEx:CancelTimer(aura.timer)
        end

        table.remove(container, index)

        self:FireEventForAllModules(unit, "UNIT_AURA", unit)
    end
end

function Spectate:ResetUnitAuras(unit, isFake)
	if not self.units or not self.units[unit] then return end
	
    if not isFake then
        self.units[unit].debuffs = {}
        self.units[unit].buffs = {}
	else
        local guid = self:UnitGUID(unit)
        
        -- get rid of all non-server auras
        for c=1,2 do 
            local container = i == 1 and self.units[unit].buffs or self.units[unit].debuffs
            for i=1, 40 do
                local name, _, _, _, _, _, _, _, _, _, _, _, isFake = container[i]
                if not name then break end
                
                if isFake then
                    table.remove(container, i)
                end
            end
        end
        
        -- re-add all non-server auras that are (now) valid
        for i=1, LibAuraInfo:GetNumGUIDAuras(guid) do
            local hasAura, stacks, auraType, duration, expiration, isDebuff, srcGUID, spellID = LibAuraInfo:GUIDAura(guid, i)
            if not hasAura then break end
            
            local casterUnit = self:GetUnitIdByGUID(srcGUID) and self:GetUnitIdByGUID(srcGUID) or GladiusEx:GetUnitIdByGUID(srcGUID)
            
            local name, rank, icon = GetSpellInfo(spellID)
            
            local container = isDebuff and self.units[unit].debuffs or self.units[unit].buffs
            
            local aura = { 
                name,
                rank,
                icon,
                stacks, 
                GladiusEx.Data.auraTypesByID[auraType],
                duration,
                expiration,
                casterUnit,
                0,
                0,
                spellID,
                srcGUID,
                true,
            }
            table.insert(container, aura)
        end
    end
	self:FireEventForAllModules(unit, "UNIT_AURA", unit)
end

-- CASTING

function Spectate:SetUnitCasting(unit, spellID, castTime)
	
    if not self.units or not self.units[unit] then return end
	
	castTime = castTime and tonumber(castTime) or nil
	spellID = spellID and tonumber(spellID) or nil
	
	if spellID == 5019 or spellID == 75 then return end -- Shoot (Wand) or Auto Shot (Hunter)
	
	local castingData = self.units[unit].casting
	
	local isInterrupt = castTime and castTime == 99999 or false
	local isStop = castTime and castTime == 99998 or false
	local isInstant = castTime and castTime == 0 or false
	local isChannel = castTime and castTime < 0 or false
	
	if isChannel then
		castTime = -castTime
	end
    
    castTime = castTime
	
	local t = GetTime() * 1000
    
    if isInterrupt then -- cast got interrupted
        local castingData = self.units[unit].casting
        
        if castingData then
            GladiusEx:CancelTimer(castingData.timer)
            self.units[unit].casting = nil
            self:FireEventForAllModules(unit, "UNIT_SPELLCAST_INTERRUPTED", unit, castingData.name)
        end        

	elseif isStop then -- cancelled the cast
        local castingData = self.units[unit].casting
        if castingData then
            GladiusEx:CancelTimer(castingData.timer)
            self.units[unit].casting = nil
            local event = castingData and castingData.isChannel and "UNIT_SPELLCAST_CHANNEL_STOP" or "UNIT_SPELLCAST_STOP"
            self:FireEventForAllModules(unit, event, unit, castingData.name)
        end        

	elseif not isInstant and castingData and castingData.endCastTime > t then -- delayed due to melee hit
        castingData.endCastTime = castingData.startCastTime + castTime
        
        GladiusEx:CancelTimer(castingData.timer)
        
        castingData.timer = GladiusEx:ScheduleTimer(self.SetUnitCasting, castTime / 1000, self, unit, spellID, 99998)

		local event = castingData.isChannel and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_DELAYED"

		self:FireEventForAllModules(unit, event, unit)

	elseif not isInstant then -- new casted/channeled spell

		local name, rank, icon = GetSpellInfo(spellID)

        local timer = GladiusEx:ScheduleTimer(self.SetUnitCasting, castTime / 1000 + 0.001, self, unit, spellID, 99998)

		self.units[unit].casting = { startCastTime = t, endCastTime = t + castTime, icon = icon, isChannel = isChannel, rank = rank, minRange = minRange, maxRange = maxRange, name = name, timer = timer }
		
        local event = isChannel and "UNIT_SPELLCAST_CHANNEL_START" or "UNIT_SPELLCAST_START"
		
		self:FireEventForAllModules(unit, event, unit, spellID)
	elseif isInstant then -- new instant cast
		self.units[unit].casting = nil
        
        self:FireEventForAllModules(unit, "UNIT_SPELLCAST_SUCCEEDED", unit, spellID)
	end
end

function Spectate:SetUnitTarget(unit, targetGUID)
	if not self.units or not self.units[unit] then return end
	
	local currTarget = self.units[unit].target
    local currGUID = self:UnitGUID(currTarget)

    if (currGUID and targetGUID and currGUID == targetGUID) or (not currGUID and not targetGUID) then return end
    
    local newTarget
	if targetGUID ~= nil then
		newTarget = self:GetUnitIdByGUID(targetGUID) -- check for fake player/party units

		if not newTarget then
			newTarget = GladiusEx:GetUnitIdByGUID(targetGUID) -- check for arena units as well
			if not newTarget then
				for i = 1, 5 do
					local aUnit = "arenapet"..i -- check for arena pets
					if (UnitExists(aUnit) and UnitGUID(aUnit) == targetGUID) then
						newTarget = aUnit
                        break
					end
				end
			end
		end
	end

	-- if we didn't find a valid target we just have to assume it was a clear target (even though it could've been an unknown pet)
	self.units[unit].target = newTarget
	self:FireEventForAllModules(unit, "UNIT_TARGET", unit) 
end

-- POWER

function Spectate:SetUnitPowerType(unit, powerType)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].powerType = tonumber(powerType)
	
	self:FireEventForAllModules(unit, "UNIT_DISPLAYPOWER", unit)
end

function Spectate:SetUnitMaxPower(unit, power)
	if not self.units or not self.units[unit] then return end
	
	
	self.units[unit].maxPower = tonumber(power)
	
	local powerType = self.units[unit].powerType
	local name = GladiusEx.Data.powerTypesByID[powerType]
	
    self:FireEventForAllModules(unit, "UNIT_DISPLAYPOWER", unit)
    
    if not name then return end
    
	self:FireEventForAllModules(unit, "UNIT_MAX" .. name, unit)
end

function Spectate:SetUnitCurrentPower(unit, power)
	if not self.units or not self.units[unit] then return end
	
	
	self.units[unit].currentPower = tonumber(power)
	
	local powerType = self.units[unit].powerType
	local name = GladiusEx.Data.powerTypesByID[powerType]
	
    self:FireEventForAllModules(unit, "UNIT_DISPLAYPOWER", unit)
    
    if not name then return end
    
	self:FireEventForAllModules(unit, "UNIT_" .. name, unit)
end

-- HP

function Spectate:SetUnitMaxHP(unit, hp)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].maxHP = tonumber(hp)
    
	self:FireEventForAllModules(unit, "UNIT_MAXHEALTH", unit)
end

function Spectate:SetUnitCurrentHP(unit, hp)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].currentHP = tonumber(hp)
	
	self:FireEventForAllModules(unit, "UNIT_HEALTH", unit)
end

-- NAME / CLASS / RACE / STATUS

function Spectate:SPELL_CAST_SUCCESS(srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID)
    local unit = self:GetUnitIdByGUID(srcGUID)
    if not unit or not self.units or not self.units[unit] or self.units[unit].raceID then return end
    
    local raceID = GladiusEx.Data.raceIDsByRacialTraits[spellID]
    if raceID then
        self:SetUnitRace(unit, raceID)
    end
end

function Spectate:SetUnitName(unit, name)
    if not self.units or not self.units[unit] then return end
	
	self.units[unit].name = name
	
	self:FireEventForAllModules(unit, "UNIT_NAME_UPDATE", unit)
end

function Spectate:SetUnitClass(unit, classID)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].classID = tonumber(classID)
	
	self:FireEventForAllModules(unit, "UNIT_NAME_UPDATE", unit)
end

function Spectate:SetUnitRace(unit, raceID)
    if not self.units or not self.units[unit] then return end
    
    self.units[unit].raceID = raceID
    
    self:FireEventForAllModules(unit, "UNIT_NAME_UPDATE", unit)
end

function Spectate:SetUnitStatus(unit, status)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].status = tonumber(status)
	
	self:FireEventForAllModules(unit, "UNIT_HEALTH", unit)
end

-- PET

function Spectate:SetUnitPetHP(unit, health)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].pet.currentHP = tonumber(health)
	
	self:FireEventForAllModules(unit, "UNIT_HEALTH_PET", unit, health)
end

function Spectate:SetUnitPet(unit, petID)
	if not self.units or not self.units[unit] then return end
	
	self.units[unit].pet.id = tonumber(petID)
	
	self:FireEventForAllModules(unit, "UNIT_PET", unit)
end

function Spectate:UNIT_DIED(srcGUID, srcName, srcFlags, dstGUID)
    local unit = self:GetUnitIdByGUID(srcGUID)
    if not unit or not self.units or not self.units[unit] then return end
    
    Spectate:ResetUnitAuras(unit, false)
end


-- ABILITY

function Spectate:AddUnitAbilityCooldown(unit, spellID, cooldownStart, cooldownDuration)
    if not self.units or not self.units[unit] then return end
	
    spellID = tonumber(spellID)
    
    -- TODO: I could hack into LibCooldownTracker and set the exact cooldowns
    -- but this event is never really fired by most private servers
    
	local guid = Spectate.UnitGUID(unit)
	
    if CT:GetCooldownData(spellID) then
        self:FireEventForAllModules(unit, "LCT_CooldownUsedByGUID", guid, spellID)
    end
end

function Spectate:ResetUnitAbilityCooldown(unit, spellID)
    if true then return false end -- not supported (handled by LCT)
end

function Spectate:ResetUnitAbilityCooldowns(unit)
    if not self.units or not self.units[unit] then return end

    local data = CT.tracked_players[unit]
    if data and data.timer then
        data.timer:Cancel()
    end
    
    local guid = self:GetUnitIdByGUID(unit)
    local unit = CT.tracked_players[unit] and unit or guid
    
    if CT.tracked_players[unit] then
        CT.tracked_players[unit] = nil
    end
        
	self:FireEventForAllModules(unit, "LCT_CooldownReset",  unit)
end

function Spectate:UpdateCooldownInfo(unit, spellID)
    if not self.units or not self.units[unit] then return end

    spellID = tonumber(spellID)
    
    if not CT:GetCooldownData(spellID) then return end
    
    local guid = self.UnitGUID(unit)
    
    local tpu = CT.tracked_players[guid]
    
    if not self.GetUnitCooldownInfo(unit, spellID) then
        CT:CooldownEvent("UNIT_SPELLCAST_SUCCEEDED", guid, spellID, true)
        CT:CooldownEvent("SPELL_AURA_REMOVED", guid, spellID, true)
        
        self:FireEventForAllModules(unit, "LCT_CooldownUsed", unit)
    end
end

-- REPLACEMENT FUNCTIONS


function Spectate.UnitAura(unit, index, ...)
	local rank, filter = ...
    
    if index and type(index) == "number" then
        filter = rank
    end
    
    local self = Spectate
    
    if not self:IsSpectating() or self:IsArenaUnit(unit) then return UnitAura(unit, index, ...) end
    
	if not self.units or not self.units[unit] then return end
	
    local isBuff = (not filter or strfind(filter, "HELPFUL")) and true or false
    
    local container = isBuff and self.units[unit].buffs or self.units[unit].debuffs
    
    local allAuras = (not filter or not strfind(filter, "PLAYER")) and true or false
    
    local auraData
    if index and type(index) == "number" then
        auraData = container[index]
    elseif index and type(index) == "string" then
        for i, data in pairs(container) do
            if v[1] == index and (allAuras or (not allAuras and v[8] == "player")) then -- [1] is name, [8] is casterUnit
                auraData = v
                break
            end
        end
        
	end

	if auraData then return unpack(auraData) end
end

function Spectate.UnitBuff(unit, index, ...)
	local self = Spectate
    
    if not self:IsSpectating() or self:IsArenaUnit(unit) then return UnitBuff(unit, index, ...) end

	if not self.units or not self.units[unit] then return end
	
    local auraData
    if index and type(index) == "number" then
        auraData = self.units[unit].buffs[index]
    elseif index and type(index) == "string" then
        for i, data in pairs(self.units[unit].buffs) do
            if v[1] == index then -- [1] is name
                auraData = v
                break
            end
        end
        
	end

	if auraData then return unpack(auraData) end
end

function Spectate.UnitDebuff(unit, index, ...)
	local self = Spectate

    if not self:IsSpectating() or self:IsArenaUnit(unit) then return UnitDebuff(unit, index, ...) end

	if not self.units or not self.units[unit] then return end
	
    local auraData
    if index and type(index) == "number" then
        auraData = self.units[unit].debuffs[index]
    elseif index and type(index) == "string" then
        for i, data in pairs(self.units[unit].debuffs) do
            if v[1] == index then -- [1] is name
                auraData = v
                break
            end
        end
        
	end

	if auraData then return unpack(auraData) end
end

function Spectate.UnitHealth(unit)
    if not unit then return 1 end
	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitHealth(unit) end

    if unit == "pet" then
        local pet = Spectate.units["player"] and Spectate.units["player"].pet or nil
        return pet and pet.currentHP or 0
    elseif unit:find("pet") then
        local actual_unit = strreplace(unit, "pet", "")
        local pet = Spectate.units[actual_unit] and Spectate.units[actual_unit].pet or nil
        return pet and pet.currentHP or 0
    elseif unit == "target" then
        local target = Spectate.units["player"] and Spectate.units["player"].target or nil
        return Spectate.UnitHealth(target)
    elseif unit:find("target") then
        local actual_unit = strreplace(unit, "target", "")
        local target = Spectate.units[actual_unit] and Spectate.units[actual_unit].target or nil
        return Spectate.UnitHealth(target)
    end

	if not Spectate.units or not Spectate.units[unit] then return 1 end
	
	return Spectate.units[unit].currentHP or 1
end

function Spectate.UnitHealthMax(unit)
    if not unit then return 1 end
	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitHealthMax(unit) end

    if unit == "pet" then
        local pet = Spectate.units["player"] and Spectate.units["player"].pet or nil
        return pet and 100 or 0
    elseif unit:find("pet") then
        local actual_unit = strreplace(unit, "pet", "")
        local pet = Spectate.units[actual_unit] and Spectate.units[actual_unit].pet or nil
        return (pet and pet.id) and 100 or 0
    elseif unit == "target" then
        local target = Spectate.units["player"] and Spectate.units["player"].target or nil
        return Spectate.UnitHealthMax(target)
    elseif unit:find("target") then
        local actual_unit = strreplace(unit, "target", "")
        local target = Spectate.units[actual_unit] and Spectate.units[actual_unit].target or nil
        return Spectate.UnitHealthMax(target)
    end

	if not Spectate.units or not Spectate.units[unit] then return 1 end
	
	return Spectate.units[unit].maxHP or 1
end

function Spectate.UnitPower(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitPower(unit) end

	if not Spectate.units or not Spectate.units[unit] then return 1 end
	
	return Spectate.units[unit].currentPower or 1
end

function Spectate.UnitPowerType(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitPowerType(unit) end

	if not Spectate.units or not Spectate.units[unit] then return 0, "MANA" end
	
    local powerType = Spectate.units[unit].powerType 
    
	return (powerType and powerType or 0), GladiusEx.Data.powerTypesByID[(powerType and powerType or 0)]
end

function Spectate.UnitPowerMax(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitPowerMax(unit) end

	if not Spectate.units or not Spectate.units[unit] then return 1 end
	
	return Spectate.units[unit].maxPower
end

function Spectate.UnitCastingInfo(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitCastingInfo(unit) end
	
	if not Spectate.units or not Spectate.units[unit] then return end
	
	local castingData = Spectate.units[unit].casting
	
	if not castingData then return end
	
	local notInterruptible = Spectate:IsInterruptImmune(unit)

	return castingData.name, castingData.rank, castingData.name, castingData.icon, castingData.startCastTime, castingData.endCastTime, false, 0, notInterruptible
end

function Spectate.UnitChannelInfo(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitChannelInfo(unit) end
	
	if not Spectate.units or not Spectate.units[unit] then return end
	
	local castingData = Spectate.units[unit].casting
	
	if not castingData or not castingData.isChannel then return end
	
	return Spectate.UnitCastingInfo(unit)
end

function Spectate.UnitName(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitName(unit) end

	if not Spectate.units or not Spectate.units[unit] then return "" end
	
	return Spectate.units[unit].name
end

function Spectate.UnitGUID(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitGUID(unit) end
	
	if unit == "focus" or unit == "target" then return nil end

    if not Spectate.units or not Spectate.units[unit] then return end
	
	return Spectate.units[unit].GUID
end

function Spectate.UnitClass(unit)
	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitClass(unit) end

	if not Spectate.units then return end

	if strfind(unit, "pet") then
        unit = unit == "pet" and "player" or strreplace(unit, "pet", "")
		return nil, nil, nil -- Spectate.units[unit] and Spectate.units[unit].name or "", Spectate.unit[unit].classID
	elseif unit == "target" then
        local actual_unit = Spectate.units["player"] and Spectate.units["player"].target
        return Spectate.UnitClass(actual_unit)
    elseif strfind(unit, "target") then
        local actual_unit = strreplace(unit, "target", "")
        actual_unit =  Spectate.units[actual_unit] and Spectate.units[actual_unit].target or nil
        
        if strfind(actual_unit, "pet") then
            return nil, nil, nil
        end
        
        return Spectate.UnitClass(actual_unit)
    end
	
    if not Spectate.units[unit] then return end
    
	local classID = Spectate.units[unit].classID
	
	if not classID then return end

	local className = GladiusEx.Data.classNamesByID[classID]
	return L[className], className, classID
end

function Spectate.UnitRace(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitRace(unit) end
	
	if not Spectate.units or not Spectate.units[unit] or not Spectate.units[unit].raceID then return L["Human"], "Human" end

    local raceID = Spectate.units[unit].raceID
    local race = raceID and GladiusEx.Data.raceNamesByID[raceID] or "Human"
    local enRace = L[race]
    
	return race, enRace
end

function Spectate.UnitFactionGroup(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitFactionGroup(unit) end
	
	if not Spectate.units or not Spectate.units[unit] then return end

	local raceID = Spectate.units[unit].raceID
	
	return raceID and GladiusEx.Data.factionsByRaceIDs[raceID] or "Alliance" -- just pretend everyone's Alliance
end

function Spectate.UnitExists(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitExists(unit) end
	
	if not Spectate.units then return end
    
    if unit == "target" then return Spectate.units["player"] and Spectate.units["player"].target ~= nil or false end
    if unit == "pet" then return Spectate.units["player"] and (Spectate.units["player"].pet.id ~= nil and Spectate.units["player"].pet.id ~= 0) or false end
    
    
    if unit:find("target") then
        local actual_unit = strreplace(unit, "target", "")
        return Spectate.units[actual_unit] and Spectate.units[actual_unit].target ~= nil or false
    elseif unit:find("pet") then
        local actual_unit = strreplace(unit, "pet", "")
        return Spectate.units[actual_unit] and (Spectate.units[actual_unit].pet.id ~= nil and Spectate.units[actual_unit].pet.id ~= 0) or false
    end
    
	return true
end

function Spectate.UnitIsVisible(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitIsVisible(unit) end
		
	return true
end

function Spectate.UnitIsConnected(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitIsConnected(unit) end
	
	return true
end

function Spectate.UnitIsDeadOrGhost(unit)

	if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then return UnitIsDeadOrGhost(unit) end
	
	if not Spectate.units or not Spectate.units[unit] then return end
	
	return Spectate.units[unit].status == 0
end

function Spectate.UnitIsUnit(unit, otherUnit)

	if not Spectate:IsSpectating() or (Spectate:IsArenaUnit(unit) and Spectate:IsArenaUnit(otherUnit)) then return UnitIsUnit(unit, otherUnit) end
	
    if (not unit and not otherUnit) or (unit ~= nil and otherUnit ~= nil and unit == otherUnit) then return true end
    
	if not Spectate.units then return end
    
	return Spectate:UnitGUID(unit) == Spectate:UnitGUID(otherUnit)
end

function Spectate.GetUnitCooldownInfo(unit, spellID)

    if not Spectate:IsSpectating() or Spectate:IsArenaUnit(unit) then 
        return CT:GetUnitCooldownInfo(unit, spellID) 
    end


    local guid = Spectate.UnitGUID(unit)
    return CT:GetCooldownInfoByGUID(Spectate.UnitGUID(unit), spellID)
end


-- OPTIONS


function Spectate:GetOptions(unit)
    if GladiusEx:IsArenaUnit(unit) then 
        return {
            general = {
                type = "group",
                name = L["General"],
                order = 1,
                args = {
                    sep2 = {
                        type = "description",
                        name = "There are no configuration options for Arena units. See 'Party' for configuration options.",
                        width = "full",
                        order = 1,
                    },
                }
            }
        } 
    end

	return {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
                useServerData = {
                    type = "toggle",
                    name = L["Use Server Data to Track Auras"],
                    desc = L["Track friendly unit auras (buffs/debuffs) using the server spectator data (which is bugged and not working on most/many servers) instead of LibAuraInfo (which is also not perfect, and guesses auras based on COMBAT_LOG events and by polling the UnitAuras of the arena-targets). Requires UI reload."],
                    width = "double",
                    set = function(info, value) 
                        Spectate.spectatorFunctions["REMAUR"] = value and Spectate.RemoveUnitAura or false
                        self.db[unit].useServerData = value
                    end,
                    disabled = function() return not self:IsUnitEnabled(unit) end,
                    order = 1,
                },
                sep = {
                    type = "description",
                    name = "",
                    width = "double",
                    order = 2,
                },
                txt = {
                    type = "description",
                    name = 
[[There are many known issues with the Spectator functionality server side (on most servers). They are listed below:  

- For casted spells (e.g., Fear, Cyclone) the COMBAT_LOG_EVENT_UNFILTERED sub-event SPELL_AURA_REFRESH is fired immediately and for no reason right after SPELL_AURA_APPLIED is sent, this causes DRTrackers to go haywire (showing 1/4th DR immediately instead of 1/2). A work-around is implemented but it may screw up in very rare situations.

- Server data for aura removals is never sent, i.e. buffs are never* removed and it is therefore not possible to rely on the server to provide accurate and timely aura data, instead guesstimates based on the combat log and polling of "arenaXtarget" buffs (when available) has to be used to approximate the auras on the unit.

*never = not until the unit dies, at which point a "remove all buffs, the unit died" message is sent by the server

- Server data for new casts/channels and stop casts/channels are not always sent, this means that some casts are entirely missed and/or not stopped correctly (This can be partly fixed by utilizing the combat log subEvents related to casts but is not yet implemented)

- Unit frames do not fade based on range while spectating, this is because of an API limtation with tracking the distance to friendly units.

Other relevant information:

- The spectator functionality supports /reload. GladiusEx will fill up all the information about the units over time. However, you can target or mouseover the "friendly" units to speed up the process. 
Note: Reloading will lose the cooldown data of all units.

- Announcments and Alerts are disabled while spectating (to be implemented).

- Targeting and focusing units does not trigger the target/focus highlight. This is because it because it's very confusing - should the player target be highlighted, or the target of the target? Might change this functionality in the future if there's enough demand.

- It is not possible to target the party/player units by clicking on the frames. This is yet to be implemented.


Feel free to provide your feedback as an issue at https://github.com/ManneN1/GladiusEx-WotLK/issues.

]],
                    width = "double",
                    order = 3,
                },
            },
        },
    }
end

Spectate.spectatorFunctions = {
    ["CHP"] = Spectate.SetUnitCurrentHP,
    ["MHP"] = Spectate.SetUnitMaxHP,
    ["CPW"] = Spectate.SetUnitCurrentPower,
    ["MPW"] = Spectate.SetUnitMaxPower,
    ["PWT"] = Spectate.SetUnitPowerType,
    ["CD"]  = false, -- Spectate.UpdateCooldownInfo, 
    ["TEM"] = false,
    ["STA"] = Spectate.SetUnitStatus, 
    ["TRG"] = Spectate.SetUnitTarget, 
    ["CLA"] = Spectate.SetUnitClass,
    ["SPE"] = Spectate.SetUnitCasting,
    ["ACD"] = false,
    ["RCD"] = false,
    ["CDC"] = false,
    ["RES"] = false,
    ["ADDAUR"] = Spectate.AddUnitAura,
    ["REMAUR"] = Spectate.RemoveUnitAura,
    ["TIM"] = false,
    ["NME"] = Spectate.SetUnitName,
    ["PHP"] = Spectate.SetUnitPetHP, -- Input is the current HP of the pet in % (0 == dead)
    ["PET"] = Spectate.SetUnitPet, -- input is a number 0-46 which maps to a table of pet IDs https://github.com/azerothcore/arena-spectator/blob/master/SunwellAS.lua#L1933
}

