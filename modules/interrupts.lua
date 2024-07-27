local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local fn = LibStub("LibFunctional-1.0")
local timer



-- V: heavily inspired by Jaxington's Gladius-With-Interrupts
-- K: Improved

local defaults = {
    interruptPrio = 3.0,
}

local Interrupt = GladiusEx:NewGladiusExModule("InterruptsEx", defaults, defaults)
    
local INTERRUPTS = {   
    [6552]  = { duration = 4 }, -- [Warrior] Pummel
    [48827] = { duration = 3 }, -- [Paladin] Avenger's Shield
    [1766] = { duration = 5 }, -- [Rogue] Kick
    [47528] = { duration = 3 }, -- [DK] Mind Freeze
    [57994] = { duration = 3 }, -- [Shaman] Wind Shear
    [19647] = { duration = 6 }, -- [Warlock] Spell Lock
    [2139]  = { duration = 6 }, -- [Mage] Counterspell
    [16979] = { duration = 4 }, -- [Feral] Feral Charge - Bear
}

function Interrupt:OnEnable()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    if not self.frame then
        self.frame = {}
    end
    self.interrupts = {}
end

function Interrupt:OnDisable()
    self:UnregisterAllEvents()
    for unit in pairs(self.frame) do
        self.frame[unit]:SetAlpha(0)
    end
end

function Interrupt:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
    local subEvent = select(2, ...)
    local destGUID = select(6, ...)
    local spellID = select(9, ...)

    local unit = GladiusEx:GetUnitIdByGUID(destGUID)
    if not unit then return end
    local button = GladiusEx.buttons[unit]
       if not button then return end


    if subEvent ~= "SPELL_CAST_SUCCESS" and subEvent ~= "SPELL_INTERRUPT" then
        return
    end
    -- it is necessary to check ~= false, as if the unit isn't casting a channeled spell, it will be nil
    if subEvent == "SPELL_CAST_SUCCESS" and select(8, UnitChannelInfo(unit)) ~= false then
        -- not interruptible
        return
    end
    
    if INTERRUPTS[spellID] == nil then return end
    local duration = INTERRUPTS[spellID].duration
       if not duration then return end


       self:UpdateInterrupt(unit, spellID, duration)
       
end

function Interrupt:UpdateInterrupt(unit, spellID, duration)
    local t = GetTime()

    -- new interrupt
    if spellID and duration then
        if self.interrupts[unit] == nil then self.interrupts[unit] = {} end
        self.interrupts[unit][spellID] = {started = t, duration = duration}
    -- old interrupt expiring
    elseif spellID and duration == nil then
        if self.interrupts[unit] and self.interrupts[unit][spellID] and
                t > self.interrupts[unit][spellID].started + self.interrupts[unit][spellID].duration then
            self.interrupts[unit][spellID] = nil
        end
    end
    
    -- force update now, rather than at next AURA_UNIT event
    -- K: sending message is more modular than calling the function directly
    self:SendMessage("GLADIUSEX_INTERRUPT", unit)
    
    -- K: Clears the interrupt after end of duration
    if duration then
        GladiusEx:ScheduleTimer(self.UpdateInterrupt, duration+0.1, self, unit, spellID)
    end
end

function Interrupt:GetInterruptFor(unit)
    local interrupts = self.interrupts[unit]
    if interrupts == nil then return end
    
    local aSpellID, icon, duration, endsAt
    
    -- iterate over all interrupt spellIDs to find the one of highest duration
    for spellID, intdata in pairs(interrupts) do
        local tmpstartedAt = intdata.started
        local dur = intdata.duration
        local tmpendsAt = tmpstartedAt + dur
        if GetTime() > tmpendsAt then
            self.interrupts[unit][spellID] = nil
        elseif endsAt == nil or tmpendsAt > endsAt then
            endsAt = tmpendsAt
            duration = dur
            aSpellID, _, icon = GetSpellInfo(spellID)
        end
    end
    
    if aSpellID then
        return aSpellID, icon, duration, endsAt, self.db[unit].interruptPrio
    end
end

function Interrupt:GetOptions(unit)
    -- TODO: enable/disable INTERRUPT_SPEC_MODIFIER, since they are talents, we're just guessing
    return {
        general = {
            type = "group",
            name = L["General"],
            order = 1,
            args = {
                sep2 = {
                    type = "description",
                    name = "This module shows interrupt durations over the Arena Enemy Class Icons when they are interrupted.",
                    width = "full",
                    order = 17,
                },
                interruptPrio = {
                    type = "range",
                    name = "InterruptPrio",
                    desc = "Sets the priority of interrupts (as compared to regular Class Icon auras)",
                    disabled = function() return not self:IsUnitEnabled(unit) end,
                    softMin = 0.0, softMax = 10, step = 0.1,
                    order = 19,
                },
            },
        },
    }
end
