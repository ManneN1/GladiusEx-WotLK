local major = "DRData-1.0"
local minor = 1049
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)
if( not Data ) then return end

local L = {
	["Banish"] = "Banish",
	["Charge"] = "Charge",
	["Cheap Shot"] = "Cheap Shot",
	["Controlled stuns"] = "Controlled stuns",
	["Cyclone"] = "Cyclone",
	["Disarms"] = "Disarms",
	["Disorients"] = "Disorients",
	["Entrapment"] = "Entrapment",
	["Fears"] = "Fears",
	["Horrors"] = "Horrors",
	["Mind Control"] = "Mind Control",
	["Random roots"] = "Random roots",
	["Random stuns"] = "Random stuns",
	["Controlled roots"] = "Controlled roots",
	["Scatter Shot"] = "Scatter Shot",
	["Silences"] = "Silences",
	["Hibernate"] = "Hibernate",
	["Taunts"] = "Taunts",
}

if GetLocale() == "frFR" then
	L["Banish"] = "Bannissement"
	L["Charge"] = "Charge"
	L["Cheap Shot"] = "Coup bas"
	L["Controlled stuns"] = "Etourdissements contrôlés"
	L["Cyclone"] = "Cyclone"
	L["Disarms"] = "Désarmements"
	L["Disorients"] = "Désorientations"
	L["Entrapment"] = "Piège"
	L["Fears"] = "Peurs"
	L["Horrors"] = "Horreurs"
	L["Mind Control"] = "Contrôle mental"
	L["Random roots"] = "Immobilisations aléatoires"
	L["Random stuns"] = "Etourdissemensts aléatoires"
	L["Controlled roots"] = "Immobilisations contrôlées"
	L["Scatter Shot"] = "Flèche de dispersion"
	L["Silences"] = "Silences"
	L["Hibernate"] = "Hibernation"
	L["Taunts"] = "Provocations"
end

-- How long before DR resets ?
Data.resetTimes = {
	default   = 20,
}
Data.RESET_TIME = Data.resetTimes.default

-- Successives diminished durations
Data.diminishedDurations = {
	-- Decreases by 50%, immune at the 4th application
	default   = { 0.50, 0.25 },
}

-- Spells and providers by categories
--[[ Generic format:
	category = {
		-- When the debuff and the spell that applies it are the same:
		debuffId = true
		-- When the debuff and the spell that applies it differs:
		debuffId = spellId
		-- When several spells apply the debuff:
		debuffId = {spellId1, spellId2, ...}
	}
--]]

-- See http://eu.battle.net/wow/en/forum/topic/11267997531
-- or http://blue.mmo-champion.com/topic/326364-diminishing-returns-in-warlords-of-draenor/
local spellsAndProvidersByCategory = {

	--[[ TAUNT ]]--
	taunt = {
		-- Taunt (Warrior)
		[355] = true,
		-- Taunt (Pet)
		[53477] = true,
		-- Mocking Blow
		[694] = true,
		-- Growl (Druid)
		[6795] = true,
		-- Dark Command
		[56222] = true,
		-- Hand of Reckoning
		[62124] = true,
		-- Righteous Defense
		[31790] = true,
		-- Distracting Shot
		[20736] = true,
		-- Challenging Shout
		[1161] = true,
		-- Challenging Roar
		[5209] = true,
		-- Death Grip
		[49560] = true,
		-- Challenging Howl
		[59671] = true,
		-- Angered Earth
		[36213] = true,
	},
	disorient = {
		--[[ DISORIENTS ]]--
		-- Dragon's Breath
		[31661] = true,
		[33041] = true,
		[33042] = true,
		[33043] = true,
		[42949] = true,
		[42950] = true,
		
		-- Hungering Cold
		[49203] = true,
		
		-- Sap
		[6770] = true,
		[2070] = true,
		[11297] = true,
		[51724] = true,
		
		-- Gouge
		[1776] = true,
			
		-- Hex (Guessing)
		[51514] = true,
		
		-- Shackle
		[9484] = true,
		[9485] = true,
		[10955] = true,
		
		-- Polymorph
		[118] = true,
		[12824] = true,
		[12825] = true,
		[28272] = true,
		[28271] = true,
		[12826] = true,
		[61305] = true,
		[61025] = true,
		[61721] = true,
		[61780] = true,
		
		-- Freezing Trap
		[3355] = true,
		[14308] = true,
		[14309] = true,
		
		-- Freezing Arrow
		[60210] = true,

		-- Wyvern Sting
		[19386] = true,
		[24132] = true,
		[24133] = true,
		[27068] = true,
		[49011] = true,
		[49012] = true,
		
		-- Repentance
		[20066] = true,
	},
	--[[ SILENCES ]]--
	silence = {
		-- Nether Shock
		[53588] = true,
		[53589] = true,
		[62347] = true,
		
		-- Garrote
		[1330] = true,
		
		-- Arcane Torrent (Energy version)
		[25046] = true,
		
		-- Arcane Torrent (Mana version)
		[28730] = true,
		
		-- Arcane Torrent (Runic power version)
		[50613] = true,
		
		-- Silence
		[15487] = true,

		-- Silencing Shot
		[34490] = true,

		-- Improved Kick
		[18425] = true,

		-- Improved Counterspell
		[18469] = true,
		
		-- Spell Lock
		[19244] = true,
		[19647] = true,
		[24259] = true,
		
		-- Shield of the Templar
		[63529] = true,
		
		-- Strangulate
		[47476] = true,
		[49913] = true,
		[49914] = true,
		[49915] = true,
		[49916] = true,
		
		-- Gag Order (Warrior talent)
		[18498] = true,
	},
	disarm = {
		--[[ DISARMS ]]--
		-- Snatch
		[53542] = true,
		[53543] = true,
		
		-- Dismantle
		[51722] = true,
		
		-- Disarm
		[676] = true,
		
		-- Chimera Shot - Scorpid
		[53359] = true,
		
		-- Psychic Horror (Disarm effect)
		[64058] = true,
	},
	fear = {
		--[[ FEARS ]]--
			-- Blind
		[2094] = true,

		-- Fear (Warlock)
		[5782] = true,
		[6213] = true,
		[6215] = true,
		
		-- Seduction (Pet)
		[6358] = true,
		
		-- Howl of Terror
		[5484] = true,
		[17928] = true,

		-- Psychic scream
		[8122] = true,
		[8124] = true,
		[10888] = true,
		[10890] = true,
		
		-- Scare Beast
		[1513] = true,
		[14326] = true,
		[14327] = true,
		
		-- Turn Evil
		[10326] = true,
		
		-- Intimidating Shout
		[5246] = true,
		[20511] = true,
	},
	ctrlstun = {
		--[[ CONTROL STUNS ]]--
		-- Intercept (Felguard)
		[30153] = true,
		[30195] = true,
		[30197] = true,
		[47995] = true,
		
		-- Ravage
		[50518] = true,
		[53558] = true,
		[53559] = true,
		[53560] = true,
		[53561] = true,
		[53562] = true,
		
		-- Sonic Blast
		[50519] = true,
		[53564] = true,
		[53565] = true,
		[53566] = true,
		[53567] = true,
		[53568] = true,
		
		-- Concussion Blow
		[12809] = true,
		
		-- Shockwave
		[46968] = true,
		
		-- Hammer of Justice
		[853] = true,
		[5588] = true,
		[5589] = true,
		[10308] = true,

		-- Bash
		[5211] = true,
		[6798] = true,
		[8983] = true,
		
		-- Intimidation
		[19577] = true,
		[24394] = true,

		-- Maim
		[22570] = true,
		[49802] = true,

		-- Kidney Shot
		[408] = true,
		[8643] = true,

		-- War Stomp
		[20549] = true,

		-- Intercept
		[20252] = true,
		[20253] = true,
		
		-- Deep Freeze
		[44572] = true,
				
		-- Shadowfury
		[30283] = true, 
		[30413] = true,
		[30414] = true,
		
		-- Holy Wrath
		[2812] = true,
		
		-- Inferno Effect
		[22703] = true,
		
		-- Demon Charge
		[60995] = true,
		
		-- Gnaw (Ghoul)
		[47481] = true,
	},
	rndstun = {
		--[[ RANDOM STUNS ]]--
		-- Impact
		[12355] = true,

		-- Stoneclaw Stun
		[39796] = true,
		
		-- Seal of Justice
		[20170] = true,
		
		-- Revenge Stun
		[12798] = true,
	},
	cyclone = {
		--[[ CYCLONE ]]--
		-- Cyclone
		[33786] = true,
	},
	ctrlroot = {
		--[[ ROOTS ]]--
		-- Freeze (Water Elemental)
		[33395] = true,
		
		-- Pin (Crab)
		[50245] = true,
		[53544] = true,
		[53545] = true,
		[53546] = true,
		[53547] = true,
		[53548] = true,	
		
		-- Frost Nova
		[122] = true,
		[865] = true,
		[6131] = true,
		[10230] = true,
		[27088] = true,
		[42917] = true,
		
		-- Entangling Roots
		[339] = true,
		[1062] = true,
		[5195] = true,
		[5196] = true,
		[9852] = true,
		[9853] = true,
		[26989] = true,
		[53308] = true,
		
		-- Nature's Grasp (Uses different spellIDs than Entangling Roots for the same spell)
		[19970] = true,
		[19971] = true,
		[19972] = true,
		[19973] = true,
		[19974] = true,
		[19975] = true,
		[27010] = true,
		[53313] = true,
		
		-- Earthgrab (Storm, Earth and Fire talent)
		[8377] = true,
		[31983] = true,

		-- Web (Spider)
		[4167] = true,
		
		-- Venom Web Spray (Silithid)
		[54706] = true,
		[55505] = true,
		[55506] = true,
		[55507] = true,
		[55508] = true,
		[55509] = true,
	},
	rndroot = {
		--[[ RANDOM ROOTS ]]--
		-- Improved Hamstring
		[23694] = true,
		
		-- Frostbite
		[12494] = true,

		-- Shattered Barrier
		[55080] = true
	},
	sleep = {
		--[[ SLEEPS ]]--
		-- Hibernate
		[2637] = true,
		[18657] = true,
		[18658] = true,
	},
	horror = {
			--[[ HORROR ]]--
		-- Death Coil
		[6789] = true,
		[17925] = true,
		[17926] = true,
		[27223] = true,
		[47859] = true,
		[47860] = true,
		
		-- Psychic Horror
		[64044] = true,
	},
	scatter = {
		[19503] = true,
		[37506] = true,
	},
	cheapshot = {
		-- Cheap Shot
		[1833] = true,

		-- Pounce
		[9005] =  true,
		[9823] =  true,
		[9827] =  true,
		[27006] = true,
		[49803] = true,
	},
	charge = {
		[7922] = true,
	},
	mc = {
		[605] = true,
	},
	banish = {
		[710] = true,
		[18647] = true,
	},
	entrapment = {
		-- Entrapment
		[64804] = true,
		[19185] = true,
	},
} 

Data.categoryNames = {
	banish 		= L["Banish"],
	charge 		= L["Charge"],
	cheapshot 	= L["Cheap Shot"],
	ctrlstun 	= L["Controlled stuns"],
	cyclone 	= L["Cyclone"],
	disarm 		= L["Disarms"],
	disorient 	= L["Disorients"],
	entrapment 	= L["Entrapment"],
	fear 		= L["Fears"],
	horror 		= L["Horrors"],
	mc 			= L["Mind Control"],
	rndroot 	= L["Random roots"],
	rndstun 	= L["Random stuns"],
	ctrlroot 	= L["Controlled roots"],
	scatter 	= L["Scatter Shot"],
	silence 	= L["Silences"],
	sleep 		= L["Hibernate"],
	taunt 		= L["Taunts"],
}

Data.pveDR = {
	ctrlstun	= true,
	rndstun  	= true,
	taunt    	= true,
	cyclone		= true,
}

--- List of spellID -> DR category
Data.spells = {}

--- List of spellID => ProviderID
Data.providers = {}

-- Dispatch the spells in the final tables
for category, spells in pairs(spellsAndProvidersByCategory) do

	local i = 1
	for spell, provider in pairs(spells) do
		Data.spells[spell] = category
		if provider == true then -- "== true" is really needed
			Data.providers[spell] = spell
			spells[spell] = spell
		else
			Data.providers[spell] = provider
		end
		i = i + 1
	end
end

-- Get the number of spells in a given category
-- Pass "nil" to iterate through all spells.
function Data:GetNumSpellsInCategory(category)
	if category and spellsAndProvidersByCategory[category] then
        local r = 0
        for k,v in pairs(spellsAndProvidersByCategory[category]) do
            r = r + 1
        end
        return r
	end
    return nil
end

-- Public APIs
-- Category name in something usable
function Data:GetCategoryName(cat)
	return cat and Data.categoryNames[cat] or nil
end

-- Spell list
function Data:GetSpells()
	return Data.spells
end

-- Provider list
function Data:GetProviders()
	return Data.providers
end

-- Seconds before DR resets
function Data:GetResetTime(category)
	return Data.resetTimes[category or "default"] or Data.resetTimes.default
end

-- Get the category of the spellID
function Data:GetSpellCategory(spellID)
	return spellID and Data.spells[spellID] or nil
end

-- Does this category DR in PvE?
function Data:IsPVE(cat)
	return cat and Data.pveDR[cat] or nil
end

-- List of categories
function Data:GetCategories()
	return Data.categoryNames
end

-- Next DR
function Data:NextDR(diminished, category)
	local durations = Data.diminishedDurations[category or "default"] or Data.diminishedDurations.default
	for i = 1, #durations do
		if diminished > durations[i] then
			return durations[i]
		end
	end
	return 0
end

-- Iterate through the spells of a given category.
-- Pass "nil" to iterate through all spells.
do
	local function categoryIterator(id, category)
		local newCat
		repeat
			id, newCat = next(Data.spells, id)
			if id and newCat == category then
				return id, category
			end
		until not id
	end

	function Data:IterateSpells(category)
		if category then
			return categoryIterator, category
		else
			return next, Data.spells
		end
	end
end

-- Iterate through the spells and providers of a given category.
-- Pass "nil" to iterate through all spells.
function Data:IterateProviders(category)
	if category then
		return next, spellsAndProvidersByCategory[category] or {}
	else
		return next, Data.providers
	end
end

--[[ EXAMPLES ]]--
-- This is how you would track DR easily, you're welcome to do whatever you want with the below functions

--[[
local trackedPlayers = {}
local function debuffGained(spellID, destName, destGUID, isEnemy, isPlayer)
	-- Not a player, and this category isn't diminished in PVE, as well as make sure we want to track NPCs
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	-- See if we should reset it back to undiminished
	local tracked = trackedPlayers[destGUID][drCat]
	if( tracked and tracked.reset <= GetTime() ) then
		tracked.diminished = 1.0
	end
end

local function debuffFaded(spellID, destName, destGUID, isEnemy, isPlayer)
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	if( not trackedPlayers[destGUID][drCat] ) then
		trackedPlayers[destGUID][drCat] = { reset = 0, diminished = 1.0 }
	end

	local time = GetTime()
	local tracked = trackedPlayers[destGUID][drCat]

	tracked.reset = time + DRData:GetResetTime(drCat)
	tracked.diminished = DRData:NextDR(tracked.diminished, drCat)

	-- Diminishing returns changed, now you can do an update
end

local function resetDR(destGUID)
	-- Reset the tracked DRs for this person
	if( trackedPlayers[destGUID] ) then
		for cat in pairs(trackedPlayers[destGUID]) do
			trackedPlayers[destGUID][cat].reset = 0
			trackedPlayers[destGUID][cat].diminished = 1.0
		end
	end
end

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER

local eventRegistered = {["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true, ["PARTY_KILL"] = true, ["UNIT_DIED"] = true}
local function COMBAT_LOG_EVENT_UNFILTERED(self, event, timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, auraType)
	if( not eventRegistered[eventType] ) then
		return
	end

	-- Enemy gained a debuff
	if( eventType == "SPELL_AURA_APPLIED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffGained(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
	elseif( eventType == "SPELL_AURA_REFRESH" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			local isHostile = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
			debuffFaded(spellID, destName, destGUID, isHostile, isPlayer)
			debuffGained(spellID, destName, destGUID, isHostile, isPlayer)
		end

	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffFaded(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
	elseif( ( eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena" ) or eventType == "PARTY_KILL" ) then
		resetDR(destGUID)
	end
end]]