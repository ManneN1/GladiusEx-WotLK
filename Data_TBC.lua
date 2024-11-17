-- RCE Cross-Expansion handling
if GetAccountExpansionLevel() ~= 1 then return end -- not TBC

local GladiusEx = _G.GladiusEx

GladiusEx.Data = {}

function GladiusEx.Data.GetDefaultSpells()
	return {
		{ -- group 1
			[28730] = true, -- BloodElf/Arcane Torrent
			[107079] = true, -- Pandaren/Quaking Palm
			[69070] = true, -- Goblin/Rocket Jump
			[7744] = true, -- Scourge/Will of the Forsaken
			[48707] = true, -- Death Knight/Anti-Magic Shell
			[42650] = true, -- Death Knight/Army of the Dead
			[108194] = true, -- Death Knight/Asphyxiate
			[49576] = true, -- Death Knight/Death Grip
			[48743] = true, -- Death Knight/Death Pact
			[108201] = true, -- Death Knight/Desecrated Ground
			[47568] = true, -- Death Knight/Empower Rune Weapon
			[48792] = true, -- Death Knight/Icebound Fortitude
			[49039] = true, -- Death Knight/Lichborne
			[47528] = true, -- Death Knight/Mind Freeze
			[51271] = true, -- Death Knight/Pillar of Frost
			[61999] = true, -- Death Knight/Raise Ally
			[108200] = true, -- Death Knight/Remorseless Winter
			[47476] = true, -- Death Knight/Strangulate
			[49206] = true, -- Death Knight/Summon Gargoyle
			[110570] = true, -- Druid/Anti-Magic Shell
			[22812] = true, -- Druid/Barkskin
			[122288] = true, -- Druid/Cleanse
			[110788] = true, -- Druid/Cloak of Shadows
			[33786] = true, -- Druid/Cyclone (feral)
			[112970] = true, -- Druid/Demonic Circle: Teleport
			[110617] = true, -- Druid/Deterrence
			[99] = true, -- Druid/Disorienting Roar
			[110715] = true, -- Druid/Dispersion
			[102280] = true, -- Druid/Displacer Beast
			[110700] = true, -- Druid/Divine Shield
			[110791] = true, -- Druid/Evasion
			[126456] = true, -- Druid/Fortifying Brew
			[110693] = true, -- Druid/Frost Nova
			[110698] = true, -- Druid/Hammer of Justice
			[108288] = true, -- Druid/Heart of the Wild
			[110696] = true, -- Druid/Ice Block
			[110575] = true, -- Druid/Icebound Fortitude
			[106731] = true, -- Druid/Incarnation
			[113004] = true, -- Druid/Intimidating Roar
			[102342] = true, -- Druid/Ironbark
			[110718] = true, -- Druid/Leap of Faith
			[102359] = true, -- Druid/Mass Entanglement
			[5211] = true, -- Druid/Mighty Bash
			[88423] = true, -- Druid/Nature's Cure
			[132158] = true, -- Druid/Nature's Swiftness
			[2782] = true, -- Druid/Remove Corruption
			[80964] = true, -- Druid/Skull Bash
			[78675] = true, -- Druid/Solar Beam
			[132469] = true, -- Druid/Typhoon
			[122291] = true, -- Druid/Unending Resolve
			[102793] = true, -- Druid/Ursol's Vortex
			[90337] = true, -- Hunter/Bad Manner
			[19574] = true, -- Hunter/Bestial Wrath
			[19263] = true, -- Hunter/Deterrence
			[781] = true, -- Hunter/Disengage
			[1499] = true, -- Hunter/Freezing Trap
			[19577] = true, -- Hunter/Intimidation
			[126246] = true, -- Hunter/Lullaby
			[50479] = true, -- Hunter/Nether Shock
			[126355] = true, -- Hunter/Paralyzing Quill
			[126423] = true, -- Hunter/Petrifying Gaze
			[26090] = true, -- Hunter/Pummel
			[23989] = true, -- Hunter/Readiness
			[19503] = true, -- Hunter/Scatter Shot
			[34490] = true, -- Hunter/Silencing Shot
			[50519] = true, -- Hunter/Sonic Blast
			[121818] = true, -- Hunter/Stampede
			[96201] = true, -- Hunter/Web Wrap
			[19386] = true, -- Hunter/Wyvern Sting
			[108843] = true, -- Mage/Blazing Speed
			[1953] = true, -- Mage/Blink
			[11958] = true, -- Mage/Cold Snap
			[2139] = true, -- Mage/Counterspell
			[44572] = true, -- Mage/Deep Freeze
			[122] = true, -- Mage/Frost Nova
			[102051] = true, -- Mage/Frostjaw
			[113074] = true, -- Mage/Healing Touch
			[45438] = true, -- Mage/Ice Block
			[115450] = true, -- Monk/Detox
			[122783] = true, -- Monk/Diffuse Magic
			[113656] = true, -- Monk/Fists of Fury
			[115203] = true, -- Monk/Fortifying Brew
			[119381] = true, -- Monk/Leg Sweep
			[116849] = true, -- Monk/Life Cocoon
			[137562] = true, -- Monk/Nimble Brew
			[115078] = true, -- Monk/Paralysis
			[115310] = true, -- Monk/Revival
			[116844] = true, -- Monk/Ring of Peace
			[116705] = true, -- Monk/Spear Hand Strike
			[116680] = true, -- Monk/Thunder Focus Tea
			[116841] = true, -- Monk/Tiger's Lust
			[122470] = true, -- Monk/Touch of Karma
			[115750] = true, -- Paladin/Blinding Light
			[4987] = true, -- Paladin/Cleanse
			[31821] = true, -- Paladin/Devotion Aura
			[642] = true, -- Paladin/Divine Shield
			[105593] = true, -- Paladin/Fist of Justice
			[86698] = true, -- Paladin/Guardian of Ancient Kings
			[86669] = true, -- Paladin/Guardian of Ancient Kings
			[853] = true, -- Paladin/Hammer of Justice
			[96231] = true, -- Paladin/Rebuke
			[20066] = true, -- Paladin/Repentance
			[19236] = true, -- Priest/Desperate Prayer
			[47585] = true, -- Priest/Dispersion
			[47788] = true, -- Priest/Guardian Spirit
			[96267] = true, -- Priest/Inner Focus
			[89485] = true, -- Priest/Inner Focus
			[73325] = true, -- Priest/Leap of Faith
			[33206] = true, -- Priest/Pain Suppression
			[8122] = true, -- Priest/Psychic Scream
			[108921] = true, -- Priest/Psyfiend
			[527] = true, -- Priest/Purify
			[15487] = true, -- Priest/Silence
			[112833] = true, -- Priest/Spectral Guise
			[108968] = true, -- Priest/Void Shift
			[108920] = true, -- Priest/Void Tendrils
			[13750] = true, -- Rogue/Adrenaline Rush
			[2094] = true, -- Rogue/Blind
			[31230] = true, -- Rogue/Cheat Death
			[31224] = true, -- Rogue/Cloak of Shadows
			[1766] = true, -- Rogue/Kick
			[137619] = true, -- Rogue/Marked for Death
			[14185] = true, -- Rogue/Preparation
			[121471] = true, -- Rogue/Shadow Blades
			[51713] = true, -- Rogue/Shadow Dance
			[76577] = true, -- Rogue/Smoke Bomb
			[1856] = true, -- Rogue/Vanish
			[79140] = true, -- Rogue/Vendetta
			[114049] = true, -- Shaman/Ascendance
			[51886] = true, -- Shaman/Cleanse Spirit
			[8177] = true, -- Shaman/Grounding Totem
			[108280] = true, -- Shaman/Healing Tide Totem
			[51514] = true, -- Shaman/Hex
			[16190] = true, -- Shaman/Mana Tide Totem
			[77130] = true, -- Shaman/Purify Spirit
			[30823] = true, -- Shaman/Shamanistic Rage
			[113286] = true, -- Shaman/Solar Beam
			[98008] = true, -- Shaman/Spirit Link Totem
			[79206] = true, -- Shaman/Spiritwalker's Grace
			[51490] = true, -- Shaman/Thunderstorm
			[8143] = true, -- Shaman/Tremor Totem
			[57994] = true, -- Shaman/Wind Shear
			[89766] = true, -- Warlock/Axe Toss
			[111397] = true, -- Warlock/Blood Horror
			[103967] = true, -- Warlock/Carrion Swarm
			[110913] = true, -- Warlock/Dark Bargain
			[108359] = true, -- Warlock/Dark Regeneration
			[113858] = true, -- Warlock/Dark Soul: Instability
			[113861] = true, -- Warlock/Dark Soul: Knowledge
			[113860] = true, -- Warlock/Dark Soul: Misery
			[48020] = true, -- Warlock/Demonic Circle: Teleport
			[5484] = true, -- Warlock/Howl of Terror
			[6789] = true, -- Warlock/Mortal Coil
			[115781] = true, -- Warlock/Optical Blast
			[30283] = true, -- Warlock/Shadowfury
			[89808] = true, -- Warlock/Singe Magic
			[19647] = true, -- Warlock/Spell Lock
			[6229] = true, -- Warlock/Twilight Ward
			[104773] = true, -- Warlock/Unending Resolve
			[107574] = true, -- Warrior/Avatar
			[118038] = true, -- Warrior/Die by the Sword
			[5246] = true, -- Warrior/Intimidating Shout
			[6552] = true, -- Warrior/Pummel
			[1719] = true, -- Warrior/Recklessness
			[871] = true, -- Warrior/Shield Wall
			[46968] = true, -- Warrior/Shockwave
			[23920] = true, -- Warrior/Spell Reflection
		},
		{ -- group 2
			[42292] = true, -- ITEMS/PvP Trinket
		}
	}
end

function GladiusEx.Data.GetDefaultImportantAuras()
    return {
		-- Higher Number is More Priority
		-- Priority List by Bibimapi
		-- Immunes I and Stealth (10)

		[GladiusEx:SafeGetSpellName(33786)]	= 10,	-- Cyclone
		[GladiusEx:SafeGetSpellName(605)]	  = 10,	-- Mind Control
		[GladiusEx:SafeGetSpellName(45438)]	= 10,	-- Ice Block 
		[GladiusEx:SafeGetSpellName(642)]	  = 10,	-- Divine Shield
		[GladiusEx:SafeGetSpellName(27827)]	= 10,	-- Spirit of Redemption
		[GladiusEx:SafeGetSpellName(34692)] = 10, -- The Beast Within

		[GladiusEx:SafeGetSpellName(5215)]	= 10,	-- Prowl
		[GladiusEx:SafeGetSpellName(32612)]	= 10,	-- Invisibility (main)
		[GladiusEx:SafeGetSpellName(1784)]	= 10,	-- Stealth 
		[GladiusEx:SafeGetSpellName(11327)]	= 10,	-- Vanish
		[GladiusEx:SafeGetSpellName(5384)]	= 10,	-- Feign Death

		[GladiusEx:SafeGetSpellName(44166)]	= 10,	-- Refreshment
		[GladiusEx:SafeGetSpellName(27089)]	= 10,	-- Drink1
		[GladiusEx:SafeGetSpellName(46755)]	= 10,	-- Drink2
		[GladiusEx:SafeGetSpellName(23920)] = 10,	-- Spell Reflection
		[GladiusEx:SafeGetSpellName(31224)]	= 10,	-- Cloak of Shadows


		-- Breakable CC (9)

		[GladiusEx:SafeGetSpellName(2637)]  	= 9,	-- Hibernate 
		[GladiusEx:SafeGetSpellName(3355)]  	= 9,	-- Freezing Trap 
		[GladiusEx:SafeGetSpellName(37506)]  	= 9,	-- Scatter Shot
		[GladiusEx:SafeGetSpellName(118)]  	  = 9.1,	-- Polymorph
		[GladiusEx:SafeGetSpellName(28272)]  	= 9.1,	-- Polymorph (pig)
		[GladiusEx:SafeGetSpellName(28271)]  	= 9.1,	-- Polymorph (turtle
		[GladiusEx:SafeGetSpellName(20066)]  	= 9,	-- Repentance
		[GladiusEx:SafeGetSpellName(1776)]  	= 9,	-- Gouge
		[GladiusEx:SafeGetSpellName(6770)]  	= 9.1,	-- Sap
		[GladiusEx:SafeGetSpellName(1513)]  	= 9,	-- Scare Beast
		[GladiusEx:SafeGetSpellName(31661)]  	= 9,	-- Dragon's Breath 
		[GladiusEx:SafeGetSpellName(8122)]  	= 9,	-- Psychic Scream 
		[GladiusEx:SafeGetSpellName(2094)]  	= 9,	-- Blind 
		[GladiusEx:SafeGetSpellName(5782)]  	= 9,	-- Fear
		[GladiusEx:SafeGetSpellName(5484)]  	= 9,	-- Howl of Terror
		[GladiusEx:SafeGetSpellName(6358)]  	= 9,	-- Seduction
		[GladiusEx:SafeGetSpellName(5246)]  	= 9,	-- Intimidating Shout 
		[GladiusEx:SafeGetSpellName(22570)]  	= 9,	-- Maim
		[GladiusEx:SafeGetSpellName(19386)]   = 9,  -- Wyvern Sting


		-- Stuns (8)

		[GladiusEx:SafeGetSpellName(5211)]  = 8,	-- Bash 
		[GladiusEx:SafeGetSpellName(24394)] = 8,	-- Intimidation 
		[GladiusEx:SafeGetSpellName(853)]  	= 8,	-- Hammer of Justice
		[GladiusEx:SafeGetSpellName(1833)] 	= 8,	-- Cheap Shot 
		[GladiusEx:SafeGetSpellName(408)]  	= 8,	-- Kidney Shot 
		[GladiusEx:SafeGetSpellName(30283)] = 8,	-- Shadowfury 
		[GladiusEx:SafeGetSpellName(20549)] = 8,	-- War Stomp
		[GladiusEx:SafeGetSpellName(835)]   = 8,     -- Tidal Charm
		[GladiusEx:SafeGetSpellName(12809)] = 8,   -- Concussion Blow
		[GladiusEx:SafeGetSpellName(100)]   = 8,   -- Charge
		[GladiusEx:SafeGetSpellName(25275)] = 8,   -- Intercept
		[GladiusEx:SafeGetSpellName(28445)] = 8,  -- Concussive Shot

		-- Immunes II (7)

		[GladiusEx:SafeGetSpellName(1022)]  	= 7,	-- Blessing of Protection
		[GladiusEx:SafeGetSpellName(33206)]   = 7, -- Pain Suppression
		[GladiusEx:SafeGetSpellName(5277)]  	= 7,	-- Evasion


		-- Defensives I (6.5)
		[GladiusEx:SafeGetSpellName(3411)]    = 6.5,   -- Intervene
		[GladiusEx:SafeGetSpellName(45182)]	 	= 6.5,	 -- Cheat Death
		[GladiusEx:SafeGetSpellName(19263)]   = 6.5,   -- Deterrence

		-- Immunes III (6)

		[GladiusEx:SafeGetSpellName(18499)]  	= 6,	-- Berserker Rage

		-- Unbreakable CC and Roots (5)

		[GladiusEx:SafeGetSpellName(6789)]  	= 5,	-- Death Coil 
		[GladiusEx:SafeGetSpellName(15487)]  	= 5,	-- Silence
		[GladiusEx:SafeGetSpellName(27559)]  	= 3,	-- Silencing shot (3 second silence)
		[GladiusEx:SafeGetSpellName(1330)]  	= 5,	-- Garrote
		[GladiusEx:SafeGetSpellName(339)]  	  = 5,	-- Entangling Roots
		[GladiusEx:SafeGetSpellName(122)]   	= 5,	-- Frost Nova
		[GladiusEx:SafeGetSpellName(33395)]  	= 5,	-- Freeze (Water Elemental)
		[GladiusEx:SafeGetSpellName(676)]   	= 5,	-- Disarm 
		[GladiusEx:SafeGetSpellName(16979)]  	= 5,	-- Feral Charge
		[GladiusEx:SafeGetSpellName(44047)]   = 5,  -- Chastise
		[GladiusEx:SafeGetSpellName(26177)]   = 5,  -- Pet Charge

		-- Defensives II (4.5)

		[GladiusEx:SafeGetSpellName(6940)] 	= 4.5,	-- Blessing of Sacrifice
		[GladiusEx:SafeGetSpellName(871)]  	= 4.5,	-- Shield Wall



		-- Important II (4)

		[GladiusEx:SafeGetSpellName(29166)]  	= 4,	-- Innervate
		[GladiusEx:SafeGetSpellName(31842)]  	= 4,	-- Divine Illumination
		[GladiusEx:SafeGetSpellName(17116)]  	= 4,	-- Nature's Swiftness (Druid)
		[GladiusEx:SafeGetSpellName(16188)]  	= 4,	-- Nature's Swiftness (Shaman)
		[GladiusEx:SafeGetSpellName(16166)]  	= 4,	-- Elemental Mastery
		[GladiusEx:SafeGetSpellName(1044)]		= 4,	-- Blessing of Freedom
		[GladiusEx:SafeGetSpellName(34709)]  	= 4,	-- Shadow Sight (eye in arena)
		[GladiusEx:SafeGetSpellName(14751)]  	= 4,	-- Inner Focus

		-- Offensives I (3)

		[GladiusEx:SafeGetSpellName(19574)]  	= 3,	-- Bestial Wrath
		[GladiusEx:SafeGetSpellName(12042)]  	= 3,	-- Arcane Power
		[GladiusEx:SafeGetSpellName(12472)]  	= 3,	-- Icy Veins 
		[GladiusEx:SafeGetSpellName(29977)]  	= 3,	-- Combustion
		[GladiusEx:SafeGetSpellName(31884)]  	= 3,	-- Avenging Wrath
		[GladiusEx:SafeGetSpellName(13750)]  	= 3,	-- Adrenaline Rush 
		[GladiusEx:SafeGetSpellName(32182)]  	= 3,	-- Heroism  
		[GladiusEx:SafeGetSpellName(2825)]  	= 3,	-- Bloodlust
		[GladiusEx:SafeGetSpellName(13877)]  	= 3,	-- Blade Flurry 
		[GladiusEx:SafeGetSpellName(1719)]  	= 3,	-- Recklessness
		[GladiusEx:SafeGetSpellName(12292)]  	= 3,	-- Death Wish
		[GladiusEx:SafeGetSpellName(3045)]  	= 3,	-- Rapid Fire

		-- Defensives III (2.5)

		[GladiusEx:SafeGetSpellName(22812)]  	= 2.5,	-- Barkskin
		[GladiusEx:SafeGetSpellName(16689)]   = 2.5,   -- Nature's Grasp
		[GladiusEx:SafeGetSpellName(2651)]    = 2.5,    -- Elune's Grace
		[GladiusEx:SafeGetSpellName(22842)]  	= 2.5,	-- Frenzied Regen
		[GladiusEx:SafeGetSpellName(498)]  	  = 2.5,	-- Divine Protection
		[GladiusEx:SafeGetSpellName(12975)]  	= 2.5,	-- Last Stand
		[GladiusEx:SafeGetSpellName(38031)]  	= 2.5,	-- Shield Block
		[GladiusEx:SafeGetSpellName(66)]	   	= 2.5,	-- Invisibility (initial)
		[GladiusEx:SafeGetSpellName(20578)]  	= 2.5,	-- Cannibalize
		[GladiusEx:SafeGetSpellName(8178)]  	= 2.5,	-- Grounding Totem Effect
		[GladiusEx:SafeGetSpellName(8145)]    = 2.5,   -- Tremor Totem Passive
		[GladiusEx:SafeGetSpellName(6346)]    = 2.5,   -- Fear Ward
		[GladiusEx:SafeGetSpellName(30823)]   = 2.5,   -- Shamanistic Rage
		[GladiusEx:SafeGetSpellName(27273)]   = 2.5,     -- Sacrifice

		-- Offensives II (2)

		[GladiusEx:SafeGetSpellName(5217)]  	= 2,	-- Tiger's Fury
		[GladiusEx:SafeGetSpellName(12043)]  	= 2,	-- Presence of Mind
		[GladiusEx:SafeGetSpellName(10060)]  	= 2,	-- Power Infusion
		[GladiusEx:SafeGetSpellName(14177)]  	= 2,	-- Cold Blood
		[GladiusEx:SafeGetSpellName(12328)]  	= 2,	-- Sweeping Strikes

		-- Misc (1)

		[GladiusEx:SafeGetSpellName(2645)]		= 1,	-- Ghost Wolf
		[GladiusEx:SafeGetSpellName(12051)]   = 1,  -- Evocation
		[GladiusEx:SafeGetSpellName(16190)]  	= 1,	-- Mana Tide Totem
		[GladiusEx:SafeGetSpellName(18708)]  	= 1,	-- Fel Domination
		[GladiusEx:SafeGetSpellName(1850)]  	= 1,	-- Dash
		[GladiusEx:SafeGetSpellName(5118)]  	= 1,	-- Aspect of the Cheetah
		[GladiusEx:SafeGetSpellName(2983)]  	= 1,	-- Sprint
		[GladiusEx:SafeGetSpellName(36554)]  	= 1,	-- Shadowstep
		[GladiusEx:SafeGetSpellName(41425)]  	= 1,	-- Hypothermia
		[GladiusEx:SafeGetSpellName(25771)]  	= 1,	-- Forbearance
		[GladiusEx:SafeGetSpellName(3034)]  	= 1,	-- Viper Sting
		[GladiusEx:SafeGetSpellName(3043)]  	= 1,	-- Scorpid Sting
		[GladiusEx:SafeGetSpellName(25467)]  	= 1,	-- Devouring Plague
		[GladiusEx:SafeGetSpellName(2687)]  	= 1,	-- Bloodrage
		[GladiusEx:SafeGetSpellName(11426)]   = 1,  -- Ice Barrier
		[GladiusEx:SafeGetSpellName(1543)]    = 1,  -- Flare
  }
end

GladiusEx.Data.SPECIALIZATION_ICONS = {
    [250] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
    [251] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
    [252] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
    [102] = "Interface\\Icons\\Spell_Nature_StarFall",
    [103] = "Interface\\Icons\\Ability_Druid_CatForm",
    [105] = "Interface\\Icons\\Spell_Nature_HealingTouch",
    [253] = "Interface\\Icons\\Ability_Hunter_BeastTaming",
    [254] = "Interface\\Icons\\Ability_Marksmanship",
    [255] = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
    [62]  = "Interface\\Icons\\Spell_Holy_MagicalSentry",
    [63]  = "Interface\\Icons\\Spell_Fire_FlameBolt",
    [64]  = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    [65]  = "Interface\\Icons\\Spell_Holy_HolyBolt",
    [66]  = "Interface\\Icons\\Spell_Holy_DevotionAura",
    [70]  = "Interface\\Icons\\Spell_Holy_AuraOfLight",
    [256] = "Interface\\Icons\\Spell_Holy_WordFortitude",
    [257] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
    [258] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
    [259] = "Interface\\Icons\\Ability_Rogue_ShadowStrikes",
    [260] = "Interface\\Icons\\Ability_BackStab",
    [261] = "Interface\\Icons\\Ability_Stealth",
    [262] = "Interface\\Icons\\Spell_Nature_Lightning",
    [263] = "Interface\\Icons\\Spell_Nature_LightningShield",
    [264] = "Interface\\Icons\\Spell_Nature_MagicImmunity",
    [265] = "Interface\\Icons\\Spell_Shadow_DeathCoil",
    [266] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
    [267] = "Interface\\Icons\\Spell_Shadow_RainOfFire",
    [71]  = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
    [72]  = "Interface\\Icons\\Ability_Warrior_Bladestorm",
    [73]  = "Interface\\Icons\\Ability_Warrior_InnerRage",
}

GladiusEx.Data.specIDToName = {
    [250] = "Blood",
    [251] = "Frost",
    [252] = "Unholy",
    [102] = "Balance",
    [103] = "Feral",
    [105] = "Restoration",
    [253] = "Beast Mastery",
    [254] = "Marksmanship",
    [255] = "Survival",
    [62] = "Arcane",
    [63] = "Fire",
    [64] = "Frost",
    [65] = "Holy",
    [66] = "Protection",
    [70] = "Retribution",
    [256] = "Discipline",
    [257] = "Holy",
    [258] = "Shadow",
    [259] = "Assassination",
    [260] = "Combat",
    [261] = "Subtlety",
    [262] = "Elemental",
    [263] = "Enhancement",
    [264] = "Restoration",
    [265] = "Affliction",
    [266] = "Demonology",
    [267] = "Destruction",
    [71] = "Arms",
    [72] = "Fury",
    [73] = "Protection"
}

GladiusEx.Data.classIDByClassName = {
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["DEATHKNIGHT"] = 6,
    ["SHAMAN"] = 7,
    ["MAGE"] = 8,
    ["WARLOCK"] = 9,
    ["MONK"] = 10,
    ["DRUID"] = 11
}

GladiusEx.Data.specIDToClassID = {
    [250] = 6, -- Blood DK
    [251] = 6, -- Frost DK
    [252] = 6, -- Unholy DK
    [102] = 11, -- Balance Druid
    [103] = 11, -- Feral Druid
    [105] = 11, -- Restoration Druid
    [253] = 3, -- Beast Mastery Hunter
    [254] = 3, -- Marksmanship Hunter
    [255] = 3, -- Survival Hunter
    [62] = 8, -- Arcane Mage
    [63] = 8, -- Fire Mage
    [64] = 8, -- Frost Mage
    [65] = 2, -- Holy Paladin
    [66] = 2, -- Protection Paladin
    [70] = 2, -- Retribution Paladin
    [256] = 5, -- Discipline Priest
    [257] = 5, -- Holy Priest
    [258] = 5, -- Shadow Priest
    [259] = 4, -- Assassination Rogue
    [260] = 4, -- Combat Rogue
    [261] = 4, -- Subtlety Rogue
    [262] = 7, -- Elemental Shaman
    [263] = 7, -- Enhancement Shaman
    [264] = 7, -- Restoration Shaman
    [265] = 9, -- Affliction Warlock
    [266] = 9, -- Demonology Warlock
    [267] = 9, -- Destruction Warlock
    [71] = 1, -- Arms Warrior
    [72] = 1, -- Fury Warrior
    [73] = 1 -- Protection Warrior
}

GladiusEx.Data.classNamesByID = {
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

GladiusEx.Data.auraTypesByID = {
    [0] = "None", 
    [1] = "Magic",
    [2] = "Curse",
    [3] = "Disease",
    [4] = "Poison",
    ["none"] = "None",
    ["unknown"] = nil,
    ["None"] = "None",
    ["Magic"] = "Magic",
    ["Curse"] = "Curse",
    ["Disease"] = "Disease",
    ["Poison"] = "Poison",
}

GladiusEx.Data.powerTypesByID = {
	[0] = "MANA",
	[1] = "RAGE",
	[2] = "FOCUS",
	[3] = "ENERGY",
	[4] = "COMBO_POINTS",
	[5] = "RUNES",
	[6] = "RUNIC_POWER",
}

GladiusEx.Data.factionsByRaceIDs = {
	[1] = "Alliance", -- Human
	[2] = "Horde", -- Orc
	[3] = "Alliance", -- Dward
	[4] = "Alliance", -- Night Elf
	[5] = "Horde", -- Undead
	[6] = "Horde", -- Tauren
	[7] = "Alliance", -- Gnome
	[8] = "Horde", -- Troll
	[9] = "Horde", -- Goblin
	[10] = "Horde", -- Blood Elf
	[11] = "Alliance", -- Draenei
}

GladiusEx.Data.raceNamesByID = {
    [1] = "Human",
    [2] = "Orc",
    [3] = "Dwarf",
    [4] = "Night Elf",
    [5] = "Undead",
    [6] = "Tauren",
    [7] = "Gnome",
    [8] = "Troll",
    [9] = "Goblin",
    [10] = "Blood Elf",
    [11] = "Draenei",
    ["Human"] = 1,
    ["Orc"] = 2,
    ["Dwarf"] = 3,
    ["NightElf"] = 4,
    ["Undead"] = 5,
    ["Tauren"] = 6,
    ["Gnome"] = 7,
    ["Troll"] = 8,
    ["Goblin"] = 9,
    ["BloodElf"] = 10,
    ["Draenei"] = 11,
}

GladiusEx.Data.raceIDsByRacialTraits = {
    [59752] = 1, -- EMFH
    [20589] = 7, -- Escape Artist
    [7744] = 5, -- WotF
    [59542] = 11, -- Gift of the Naaru
    [20594] = 3, -- Stoneform
    [58984] = 4, -- Shadowmeld
    [20549] = 6, -- War Stomp
    [33702] = 2, -- Blood Fury (Orc)
    [26297] = 8, -- Berserking (Troll)
    [28730 ] = 10, -- Arcane Torrent (Blood Elf)
}

GladiusEx.Data.auraImmunities = {
    [54748] = true, -- Burning Determination (Fire talent)
    [31821] = true, -- Aura Mastery (Pala talent - only works on targets which also have Concentration Aura)
    [19746] = true, -- Concentration Aura (Pala aura - only works on targets which also have Aura Mastery)
}

-- K: This is used to assess whether a DR has (dynamically) reset early
-- WotLK: Leaving this empty for now, need to sit down and go through all the auras in DRList-1.0
-- There's some guidance available in LibAuras, but it doesn't account for things like
-- talents and most importantly combo points (Maim/Kidney Shot), so some extra care is needed
GladiusEx.Data.auraDurations = { 
  --[408] = 6,     -- Kidney Shot (varies)
  --[22570] = 5,   -- Maim (varies)
}