local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local fn = LibStub("LibFunctional-1.0")
local timer



-- V: heavily inspired by Jaxington's Gladius-With-Interrupts
-- K: Improved

local defaults = {
	interruptPrio = 3.0,
}

local Interrupt = GladiusEx:NewGladiusExModule("Interrupts", defaults, defaults)
	
INTERRUPTS = {
	["Pummel"] = {duration=4},    				-- [Warrior] Pummel
	["Avenger's Shield"] = {duration=3},  		-- [Paladin] Avengers Shield
	["Kick"] = {duration=5},    				-- [Rogue] Kick
	["Mind Freeze"] = {duration=3},   			-- [DK] Mind Freeze
	["Wind Shear"] = {duration=3},   			-- [Shaman] Wind Shear
	["Optical Blast"] = {duration=6},  			-- [Warlock] Optical Blast
	["Spell Lock"] = {duration=6},   			-- [Warlock] Spell Lock
	["Counterspell"] 			= {duration=6}, -- [Mage] Counterspell
	["Feral Charge - Bear"] = {duration=4}, -- [Feral] Skull Bash
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
	local name = select(10, ...)
    local spellid = select(9, ...)

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
	
	if INTERRUPTS[name] == nil then return end
	local duration = INTERRUPTS[name].duration
   	if not duration then return end


   	self:UpdateInterrupt(unit, name, duration)
   	
end

function Interrupt:UpdateInterrupt(unit, name, duration)
	local t = GetTime()

	-- new interrupt
	if name and duration then
		if self.interrupts[unit] == nil then self.interrupts[unit] = {} end
		self.interrupts[unit][name] = {started = t, duration = duration}
	-- old interrupt expiring
	elseif name and duration == nil then
		if self.interrupts[unit] and self.interrupts[unit][name] and
				t > self.interrupts[unit][name].started + self.interrupts[unit][name].duration then
			self.interrupts[unit][name] = nil
		end
	end
	
	-- force update now, rather than at next AURA_UNIT event
	-- K: sending message is more modular than calling the function directly
	self:SendMessage("GLADIUSEX_INTERRUPT", unit)
	
	-- K: Clears the interrupt after end of duration
	if duration then
		GladiusEx:ScheduleTimer(self.UpdateInterrupt, duration+0.1, self, unit, name)
	end
end

function Interrupt:GetInterruptFor(unit)
	local interrupts = self.interrupts[unit]
	if interrupts == nil then return end
	
	local name, icon, duration, endsAt
	
	-- iterate over all interrupt spellids to find the one of highest duration
	for iname, intdata in pairs(interrupts) do
		local tmpstartedAt = intdata.started
		local dur = intdata.duration
		local tmpendsAt = tmpstartedAt + dur
		if GetTime() > tmpendsAt then
			self.interrupts[unit][iname] = nil
		elseif endsAt == nil or tmpendsAt > endsAt then
			endsAt = tmpendsAt
			duration = dur
			name, _, icon = GetSpellInfo(iname)
		end
	end
	
	if name then
		return name, icon, duration, endsAt, self.db[unit].interruptPrio
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