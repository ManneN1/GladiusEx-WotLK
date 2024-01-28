local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local LSM = LibStub("LibSharedMedia-3.0")
local fn = LibStub("LibFunctional-1.0")

-- global functions
local strfind = string.find
local select, pairs, unpack = select, pairs, unpack
local UnitExists, UnitIsUnit, UnitClass = UnitExists, UnitIsUnit, UnitClass
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

local Spectate = GladiusEx:NewGladiusExModule("Spectate")

Spectate.ClassNamesByID = {
    [1] =  "WARRIOR",
    [2] =  "PALADIN", 
    [3] =  "HUNTER",
    [4] =  "ROGUE", 
    [5] =  "PRIEST",
    [6] =  "DEATHKNIGHT",
    [7] =  "SHAMAN",
    [8] =  "MAGE",
    [9] =  "WARLOCK",
    [11] = "DRUID",
}

function Spectate:GetClassInfo(classID)
	local name = self.ClassNamesByID[classID]
	if not name then return end
	return name, LOCALIZED_CLASS_NAMES_MALE[name], classID
end

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

function Spectate:HasSpectatorUnit(guid)
	return self.units[guid] ~= nil
end

function Spectate:GetUnitByID(unitID)
	if not self.units or not self.units[unitID] then return end
	
	return self.units[unitID]
end

function Spectate:GetUnitIdByGUID(guid)
	return self.units and self.units[guid] or nil
end

function Spectate:AddUnit(guid)
	
	
	for i=1,5 do
		local aUnit = "arena"..i
		if UnitExists(aUnit) and UnitGUID(aUnit) == guid then
			return false -- don't add enemy units (they're automatically tracked anyway)
		end
	end
	
    if self.units[guid] then return false end -- unit already exists
    
	for i=1,5 do -- get the first available not already used player/party unitID
		local unit = i == 1 and "player" or "party"..(i-1)
		local exists = self.units[unit]

		if exists == nil then
			self.units[unit] = { GUID = guid, classID = nil, name = nil, currentHP = 1, maxHP = 1, currentPower = 1, maxPower = 1, powerType = 1, buffs = {}, debuffs = {}, pet = { id = nil, currentHP = 1 } }
			self.units[guid] = unit

			GladiusEx:UpdateUnit(unit)
			GladiusEx:ShowUnit(unit)
			return true
		end
	end
	
	return false
end

function Spectate:FireEventForAllModules(unit, event, ...)
	for n, m in GladiusEx:IterateModules() do
		if GladiusEx:IsModuleEnabled(unit, n) and m[event] and type(m[event]) == "function" then
            m[event](m, event, ...)
        end
    end
end

function Spectate:SetUnitName(unit, name)
    self.units[unit].name = name
	
	-- TODO: Send to all modules which may be interested
	self:FireEventForAllModules(unit, "UNIT_NAME_UPDATE", unit)
end


function Spectate:SetUnitClass(unit, classID)
	self.units[unit].classID = class
	
	self:FireEventForAllModules(unit, "UNIT_NAME_UPDATE", unit)
end

-- Graciously borrowed code from the AzerothCore arena-spectator: https://github.com/azerothcore/arena-spectator/blob/master/SunwellAS.lua
function Spectate:ParseSpectatorServerData(data)
    local pos = 1
    local stop = 1
    local targetGUID = nil
    
    if data:find(';AUR=') then
        local targetGUID, preData = strsplit(";", data)
        
        local _, data = strsplit("=", preData)
        local prefix, stacks, expiration, duration, spellID, debufftype, isDebuff, casterGUID = strsplit(",", data)
        
        if not self:HasSpectatorUnit(targetGUID) then
            local addedUnit = self:AddUnit(targetGUID)
			if not addedUnit then
				return
			end
        end
		
		local unit = self:GetUnitIdByGUID(guid)
		
        prefix = prefix == 0 and "ADDAUR" or "REMAUR"

        local fn = self.spectatorFunctions[prefix]
        
        if fn then
            fn(unit, tonumber(stacks), tonumber(expiration), tonumber(duration), tonumber(spellID), debuffType, tonumber(isDebuff), casterGUID)
        end
        
		-- TODO: Fire for all GladiusEx sub-modules that may be interested
        GladiusEx:UNIT_AURA(nil, unit)
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

            if spectatorFunction then
                spectatorFunction(self, unit, value)
            else
                -- print("Unsupported Spectator Prefix:", prefix)
            end
        end
    until stop == nil
end


function Spectate:CHAT_MSG_ADDON(event, prefix, text, channel, sender)
    local _, instanceType = IsInInstance()
	
	if instanceType ~= "arena" then return end
	
	if not self:IsSpectating() then
		self:StartSpectate()
	end
	
	if (event == "CHAT_MSG_ADDON") and (prefix == "ARENASPEC") and (channel == "WHISPER") and (sender == "") then
        self:ParseSpectatorServerData(text)
    end
end

function Spectate:IsSpectating()
	return self.isSpectating ~= nil and self.isSpectating or false
end

function Spectate:StartSpectate()
    self.isSpectating = true
    self.units = {}
    
	print("Started Spectating")
	GladiusEx:UpdateFrames()
end

function Spectate:StopSpectate()
    self.isSpectating = false
    self.units = nil
    print("Stopped Spectating")
end


function Spectate:GetOptions()
	return {}
end

Spectate.spectatorFunctions = {
    ["CHP"] = Spectate.SetUnitCurrentHP,
    ["MHP"] = Spectate.SetUnitMaxHP,
    ["CPW"] = Spectate.SetUnitCurrentPower,
    ["MPW"] = Spectate.SetUnitMaxPower,
    ["PWT"] = Spectate.SetUnitPowerType,
    ["TEM"] = Spectate.SetUnitTeam,
    ["STA"] = Spectate.SetUnitStatus, -- input is unit dead/alive/stealth status
    ["TRG"] = Spectate.SetUnitTarget,
    ["CLA"] = Spectate.SetUnitClass,
    ["SPE"] = Spectate.SetUnitCasting,
    ["ACD"] = Spectate.AddUnitAbilityCooldown,
    ["RCD"] = Spectate.RemoveUnitAbilityCooldown,
    ["CDC"] = Spectate.ResetUnitAbilityCooldown,
    ["RES"] = Spectate.ResetUnitAuras,
    ["ADDAUR"] = Spectate.AddUnitAura,
    ["REMAUR"] = Spectate.RemoveUnitAura,
    -- ["TIM"] = Spectate.SetArenaEndTime,
    ["NME"] = Spectate.SetUnitName,
    ["PHP"] = Spectate.SetUnitPetHealth, -- input is the current HP of the pet
    ["PET"] = Spectate.SetUnitPetTexture, -- input is a number 0-46 which maps to a table of pet IDs https://github.com/azerothcore/arena-spectator/blob/master/SunwellAS.lua#L1933
}