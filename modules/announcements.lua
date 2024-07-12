local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")

-- global functions
local strfind = string.find
local GetTime, UnitName, UnitClass, UnitAura = GetTime, UnitName, UnitClass, UnitAura
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local SendChatMessage = SendChatMessage
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local GetSpellInfo = GetSpellInfo
local GetRealNumPartyMembers, GetRealNumRaidMembers, IsRaidLeader, IsRaidOfficer = GetRealNumPartyMembers, GetRealNumRaidMembers, IsRaidLeader, IsRaidOfficer

local Announcements = GladiusEx:NewGladiusExModule("Announcements", {
        drinks = true,
        health = true,
        resurrect = true,
        spec = true,
        sapped = true,
        bg = true,
        healthThreshold = 25,
        dest = "party",
    })

function Announcements:OnEnable()
    -- register events
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_HEALTH_FREQUENT", "UNIT_HEALTH")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("UNIT_SPELLCAST_START")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- register messages
    self:RegisterMessage("GLADIUSEX_SPEC_UPDATE")

    -- table holding messages to throttle
    self.throttled = {}
end

function Announcements:PLAYER_ENTERING_WORLD()
    self.throttled = {}
end

function Announcements:OnDisable()
    self:UnregisterAllEvents()
end

local handled_units = {}

function Announcements:Reset(unit)
    handled_units[unit] = false
end

function Announcements:Show(unit)
    handled_units[unit] = true
end

function Announcements:IsHandledUnit(unit)
    return handled_units[unit]
end

function Announcements:GLADIUSEX_SPEC_UPDATE(event, unit)
    if not self:IsHandledUnit(unit) or not self.db[unit].spec then return end

    if GladiusEx.buttons[unit].specID then
        local class = UnitClass(unit) or LOCALIZED_CLASS_NAMES_MALE[GladiusEx.buttons[unit].class] or "??"
        local spec = GladiusEx.specIDToName[GladiusEx.buttons[unit].specID]
        self:Send(string.format(L["Enemy spec: %s (%s/%s)"], UnitName(unit) or unit, class, spec), 15, unit)
    end
end

function Announcements:UNIT_HEALTH(event, unit)
    if not self:IsHandledUnit(unit) or not self.db[unit].health then return end

    local healthPercent = math.floor((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
    if healthPercent < self.db[unit].healthThreshold then
        self:Send(string.format(L["LOW HEALTH: %s (%s)"], UnitName(unit), UnitClass(unit)), 10, unit)
    end
end

local DRINK_SPELL = GetSpellInfo(57073)
local SAP_SPELL = GetSpellInfo(51724
)
function Announcements:UNIT_AURA(event, unit)
    if not self:IsHandledUnit(unit) or not self.db[unit].drinks then return end

    if UnitAura(unit, DRINK_SPELL) then
        self:Send(string.format(L["DRINKING: %s (%s)"], UnitName(unit), UnitClass(unit)), 2, unit)
    end

    if UnitAura(unit, SAP_SPELL) then
        if unit == "player" then
            self:Send("IM SAPPED", 2, unit)
        elseif UnitIsFriend(unit, "player") then
            self:Send(string.format("FRIEND %s SAPPED", UnitName(unit)), 2, unit)
        elseif not UnitIsFriend(unit, "player") then
            self:Send(string.format("ENEMY %s (%s) SAPPED", UnitName(unit), UnitClass(unit)), 2, unit)
        end
    end
end

local RES_SPELLS = {
    [GladiusEx:SafeGetSpellName(2008)] = true,   -- Ancestral Spirit (shaman)
    [GladiusEx:SafeGetSpellName(8342)] = true,   -- Defibrillate (item: Goblin Jumper Cables)
    [GladiusEx:SafeGetSpellName(22999)] = true,  -- Defibrillate (item: Goblin Jumper Cables XL)
    [GladiusEx:SafeGetSpellName(54732)] = true,  -- Defibrillate (item: Gnomish Army Knife)
    [GladiusEx:SafeGetSpellName(61999)] = true,  -- Raise Ally (death knight)
    [GladiusEx:SafeGetSpellName(20484)] = true,  -- Rebirth (druid)
    [GladiusEx:SafeGetSpellName(7328)] = true,   -- Redemption (paladin)
    [GladiusEx:SafeGetSpellName(2006)] = true,   -- Resurrection (priest)
    [GladiusEx:SafeGetSpellName(50769)] = true,  -- Revive (druid)
    [GladiusEx:SafeGetSpellName(982)] = true,    -- Revive Pet (hunter)
    [GladiusEx:SafeGetSpellName(20707)] = true,  -- Soulstone (warlock)
}

function Announcements:UNIT_SPELLCAST_START(event, unit, spell, rank)
    if not self:IsHandledUnit(unit) or not self.db[unit].resurrect then return end

    if RES_SPELLS[spell] then
        self:Send(string.format(L["RESURRECTING: %s (%s)"], UnitName(unit), UnitClass(unit)), 2, unit)
    end
end

-- Sends an announcement
-- Param unit is only used for class coloring of messages
function Announcements:Send(msg, throttle, unit)
    -- only send announcements inside arenas and battlegrounds
    if select(2, IsInInstance()) ~= "arena" or select(2, IsInInstance()) ~= "pvp" then return end

    -- throttling
    if not self.throttled then
        self.throttled = {}
    end

    if throttle and throttle > 0 then
        if not self.throttled[msg] then
            self.throttled[msg] = GetTime() + throttle
        elseif self.throttled[msg] < GetTime() then
            self.throttled[msg] = nil
        else
            return
        end
    end

    local color = unit and RAID_CLASS_COLORS[UnitClass(unit)] or { r = 0, g = 1, b = 0 }
    local dest = self.db[unit].dest
    if dest == "self" then
        GladiusEx:Print(msg)
    end

    -- change destination to party if not raid leader/officer.
    if dest == "rw" and not IsRaidLeader() and not IsRaidOfficer() and GetNumGroupMembers() > 0 then
        dest = "party"
    end

    -- if in a battleground send messages to battleground
    if select(2, IsInInstance()) == "pvp" and self.db[unit].bg then
        dest = "battleground"
        SendChatMessage(msg, "BATTLEGROUND")
    end

    -- party chat
    -- Not checking for party size > 0 due to 1v1 skirmishes being a thng on private realms
    if (dest == "party") then
        SendChatMessage(msg, "PARTY")

    -- say
    elseif dest == "say" then
        SendChatMessage(msg, "SAY")

    -- raid warning
    elseif dest == "rw" then
        SendChatMessage(msg, "RAID_WARNING")

    -- floating combat text
    elseif dest == "fct" and IsAddOnLoaded("Blizzard_CombatText") then
        CombatText_AddMessage(msg, COMBAT_TEXT_SCROLL_FUNCTION, color.r, color.g, color.b)

    -- MikScrollingBattleText
    elseif dest == "msbt" and IsAddOnLoaded("MikScrollingBattleText") then
        MikSBT.DisplayMessage(msg, MikSBT.DISPLAYTYPE_NOTIFICATION, false, color.r * 255, color.g * 255, color.b * 255)

    -- Scrolling Combat Text
    elseif dest == "sct" and IsAddOnLoaded("sct") then
        SCT:DisplayText(msg, color, nil, "event", 1)

    -- Parrot
    elseif dest == "parrot" and IsAddOnLoaded("parrot") then
        Parrot:ShowMessage(msg, "Notification", false, color.r, color.g, color.b)
    end
end

function Announcements:GetOptions(unit)
    local destValues = {
        ["self"] = L["Self"],
        ["party"] = L["Party"],
        ["say"] = L["Say"],
        ["rw"] = L["Raid Warning"],
        ["sct"] = L["Scrolling Combat Text"],
        ["msbt"] = L["MikScrollingBattleText"],
        ["fct"] = L["Blizzard's Floating Combat Text"],
        ["parrot"] = L["Parrot"]
    }

    return {
        general = {
            type = "group",
            name = L["General"],
            order = 1,
            args = {
                options = {
                    type = "group",
                    name = L["Options"],
                    inline = true,
                    order = 1,
                    args = {
                        dest = {
                            type = "select",
                            name = L["Destination"],
                            desc = L["Choose how your announcements are displayed"],
                            values = destValues,
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 5,
                        },
                        healthThreshold = {
                            type = "range",
                            name = L["Low health threshold"],
                            desc = L["Choose how low an enemy must be before low health is announced"],
                            disabled = function() return not self:IsUnitEnabled(unit) or not self.db[unit].health end,
                            min = 1,
                            max = 100,
                            step = 1,
                            order = 10,
                        },
                        bg = {
                            type = "toggle",
                            name = L["Announce in battlegrounds"],
                            desc = L["Announces when in battlegrounds"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 20,
                        },
                    },
                },
                announcements = {
                    type = "group",
                    name = L["Announcement toggles"],
                    inline = true,
                    order = 5,
                    args = {
                        drinks = {
                            type = "toggle",
                            name = L["Drinking"],
                            desc = L["Announces when enemies sit down to drink"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 20,
                        },
                        health = {
                            type = "toggle",
                            name = L["Low health"],
                            desc = L["Announces when an enemy drops below a certain health threshold"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 30,
                        },
                        resurrect = {
                            type = "toggle",
                            name = L["Resurrection"],
                            desc = L["Announces when an enemy tries to resurrect a teammate"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 40,
                        },
                        spec = {
                            type = "toggle",
                            name = L["Spec detection"],
                            desc = L["Announces when the spec of an enemy was detected"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 40,
                        },
                        sapped = {
                            type = "toggle",
                            name = "Sap",
                            desc = "Announces when a player is sapped",
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 40,
                        },
                    },
                },
            },
        }
    }
end
    
