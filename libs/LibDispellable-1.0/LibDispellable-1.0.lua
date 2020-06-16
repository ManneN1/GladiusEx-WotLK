--[[
LibDispellable-1.0 - Test whether the player can really dispell a buff or debuff, given its talents.
Copyright (C) 2009-2010 Adirelle

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Redistribution of a stand alone version is strictly prohibited without
      prior written authorization from the LibDispellable project manager.
    * Neither the name of the LibDispellable authors nor the names of its contributors
      may be used to endorse or promote products derived from this software without
      specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

local MAJOR, MINOR = "LibDispellable-1.0", 9
--[===[@debug@
MINOR = 999999999
--@end-debug@]===]
assert(LibStub, MAJOR.." requires LibStub")
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

-- ----------------------------------------------------------------------------
-- Event dispatcher
-- ----------------------------------------------------------------------------

if not lib.eventFrame then
	lib.eventFrame = CreateFrame("Frame")
	lib.eventFrame:SetScript('OnEvent', function() return lib:UpdateSpells() end)
	lib.eventFrame:RegisterEvent('SPELLS_CHANGED')
	lib.eventFrame:RegisterEvent('PLAYER_TALENT_UPDATE')
end

-- ----------------------------------------------------------------------------
-- Data
-- ----------------------------------------------------------------------------

lib.defensive = lib.defensive or {}
lib.enrageEffectIDs = wipe(lib.enrageEffectIDs or {})

for _, id in ipairs({
	-- Datamined using fetchEnrageList.sh (see source)
	134, 256, 772, 4146, 8599, 12880, 14201, 14202, 14203, 14204, 15061, 15716,
	18501, 19451, 19812, 22428, 23128, 23257, 23342, 24689, 25503, 26041, 26051,
	28371, 29131, 29340, 30485, 31540, 31915, 32714, 33958, 34392, 34670, 37605,
	37648, 37975, 38046, 38166, 38664, 39031, 39575, 40076, 40601, 41254, 41364,
	41447, 42705, 42745, 43139, 43292, 43664, 47399, 48138, 48142, 48193, 48391,
	48702, 49029, 50420, 50636, 51170, 51513, 51662, 52071, 52262, 52309, 52461,
	52470, 52537, 53361, 54356, 54427, 54475, 54508, 54781, 55285, 55462, 56646,
	56729, 56769, 57514, 57516, 57518, 57519, 57520, 57521, 57522, 57733, 58942,
	59465, 59694, 59697, 59707, 59828, 60075, 60177, 60430, 61369, 62071, 63147,
	63227, 63848, 66092, 66759, 67233, 67657, 67658, 67659, 68541, 69052, 70371,
	72143, 72146, 72147, 72148, 72203, 75998, 76100, 76487, 76691, 76816, 76862,
	77238, 78722, 78943, 79420, 80084, 80158, 80467, 81706, 81772, 82033, 82759,
	86736, 90045, 90872, 91668, 92946, 95436, 95459,
}) do lib.enrageEffectIDs[id] = true end

-- ----------------------------------------------------------------------------
-- Detect available dispel skiils
-- ----------------------------------------------------------------------------

local function CheckSpell(spellID, pet)
	return IsSpellKnown(spellID, pet) and spellID or nil
end

local function CheckTalent(tab, index)
	return (select(5, GetTalentInfo(tab, index)) or 0) >= 1
end

function lib:UpdateSpells()
	wipe(self.defensive)
	self.offensive = nil

	local _, class = UnitClass("player")

	if class == "HUNTER" then
		self.offensive = CheckSpell(19801) -- Tranquilizing Shot
		self.tranquilize = self.offensive

	elseif class == "SHAMAN" then
		self.offensive = CheckSpell(370) -- Purge
		if IsSpellKnown(51886) then -- Cleanse Spirit
			self.defensive.Curse = 51886
			if CheckTalent(3, 12) then -- Improved Cleanse Spirit
				self.defensive.Magic = 51886
			end
		end

	elseif class == "WARLOCK" then
		self.offensive = CheckSpell(19505, true) -- Devour Magic (Felhunter)
		self.defensive.Magic = CheckSpell(89808, true) -- Singe Magic (Imp)

	elseif class == "MAGE" then
		self.defensive.Curse = CheckSpell(475) -- Remove Curse

	elseif class == "PRIEST" then
		self.offensive = CheckSpell(527) -- Dispel Magic
		self.defensive.Magic = self.offensive -- Dispel Magic
		self.defensive.Disease = CheckSpell(528) -- Cure Disease

	elseif class == "DRUID" then
		if IsSpellKnown(2782) then  -- Remove Corruption
			self.defensive.Curse = 2782
			self.defensive.Poison = 2782
			if CheckTalent(3, 17) then -- Nature's Cure
				self.defensive.Magic = 2782
			end
		end
		self.tranquilize = CheckSpell(2908) -- Soothe

	elseif class == "ROGUE" then
		self.tranquilize = CheckSpell(5938) -- Shiv

	elseif class == "PALADIN" then
		if IsSpellKnown(4987) then -- Cleanse
			self.defensive.Poison = 4987
			self.defensive.Disease = 4987
			if CheckTalent(1, 14) then -- Sacred Cleansing
				self.defensive.Magic = 4987
			end
		end
	end
end

-- ----------------------------------------------------------------------------
-- Enrage test method
-- ----------------------------------------------------------------------------

--- Test if the specified spell is an enrage effect
-- @name LibDispellable:IsEnrageEffect
-- @param spellID (number) The spell ID
-- @return isEnrage (boolean) true if the passed spell ID 
function lib:IsEnrageEffect(spellID)
	return spellID and lib.enrageEffectIDs[spellID]
end

-- ----------------------------------------------------------------------------
-- Simple query method
-- ----------------------------------------------------------------------------

--- Test if the player can dispel the given (de)buff on the given unit.
-- @name LibDispellable:CanDispel
-- @param unit (string) The unit id.
-- @param offensive (boolean) True to test offensive dispel, i.e. enemy buffs.
-- @param dispelType (string) The dispel mechanism, as returned by UnitAura.
-- @param spellID (number, optional) The buff spell ID, as returned by UnitAura, used to test enrage effects.
-- @return canDispel, spellID (boolean, number) Whether this kind of spell can be dispelled and the spell to use to do so.
function lib:CanDispel(unit, offensive, dispelType, spellID)
	local spell
	if offensive and UnitCanAttack("player", unit) then
		spell = (dispelType == "Magic" and self.offensive) or (self:IsEnrageEffect(spellID) and self.tranquilize)
	elseif not offensive and UnitCanAssist("player", unit) then
		spell = dispelType and self.defensive[dispelType]
	end
	return not not spell, spell or nil
end

-- ----------------------------------------------------------------------------
-- Iterators
-- ----------------------------------------------------------------------------

local function noop() end

local function buffIterator(unit, index)
	repeat
		index = index + 1
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura = UnitBuff(unit, index)
		local dispel = (dispelType == "Magic" and lib.offensive) or (spellID and lib.enrageEffectIDs[spellID] and lib.tranquilize)
		if dispel then
			return index, dispel, name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura
		end
	until not name
end

local function debuffIterator(unit, index)
	repeat
		index = index + 1
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitDebuff(unit, index)
		local spell = name and dispelType and lib.defensive[dispelType]
		if spell then
			return index, spell, name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff
		end
	until not name
end

--- Iterate through unit (de)buffs that can be dispelled by the player.
-- @name LibDispellable:IterateDispellableAuras
-- @param unit (string) The unit to scan.
-- @param offensive (boolean) true to test buffs instead of debuffs (offensive dispel).
-- @return A triplet usable in the "in" part of a for ... in ... do loop.
-- @usage
--   for index, spellID, name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff in LibDispellable:IterateDispellableAuras("target", true) do
--     print("Can dispel", name, "on target using", GetSpellInfo(spellID))
--   end
function lib:IterateDispellableAuras(unit, offensive)
	if offensive and UnitCanAttack("player", unit) and (self.offensive or self.tranquilize) then
		return buffIterator, unit, 0
	elseif not offensive and UnitCanAssist("player", unit) and next(self.defensive) then
		return debuffIterator, unit, 0
	else
		return noop
	end
end

-- Initialization
if IsLoggedIn() then
	lib:UpdateSpells()
end

