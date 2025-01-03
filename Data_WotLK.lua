-- RCE Cross-Expansion handling
if GetAccountExpansionLevel() ~= 2 then return end -- not WotLK

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

function GladiusEx:GetDefaultImportantAuras()
    return {
        -- Spell Name                           = Priority (higher = more priority)

        [GladiusEx:SafeGetSpellName(44166)] = 9.4, -- Refreshment
        [GladiusEx:SafeGetSpellName(46755)] = 9.4, -- Drink
        [GladiusEx:SafeGetSpellName(27089)] = 9.4, -- Drink
        [GladiusEx:SafeGetSpellName(27827)] = 9.3, -- Spirit of Redemption
        [GladiusEx:SafeGetSpellName(5384)] = 9.2, -- Feign Death
        [GladiusEx:SafeGetSpellName(66)] = 9.2, -- Invisibility
        [GladiusEx:SafeGetSpellName(32612)] = 9.2, -- Invisibility
        [GladiusEx:SafeGetSpellName(1784)] = 9.2, -- Stealth
        [GladiusEx:SafeGetSpellName(5215)] = 9.2, -- Prowl
        [GladiusEx:SafeGetSpellName(11327)] = 9.2, -- Vanish
        [GladiusEx:SafeGetSpellName(33786)] = 9.1, -- Cyclone
        [GladiusEx:SafeGetSpellName(20549)] = 9, -- War Stomp
        [GladiusEx:SafeGetSpellName(56)] = 9,   -- Stun
        [GladiusEx:SafeGetSpellName(25275)] = 9, -- Intercept
        [GladiusEx:SafeGetSpellName(28271)] = 9, -- Polymorph (Turtle)
        [GladiusEx:SafeGetSpellName(28272)] = 9, -- Polymorph (Pig)
        [GladiusEx:SafeGetSpellName(28445)] = 9, -- Improved Concussive Shot (Stun)
        [GladiusEx:SafeGetSpellName(37506)] = 9, -- Scatter Shot
        [GladiusEx:SafeGetSpellName(3355)] = 9, --  Freezing Trap Effect
        [GladiusEx:SafeGetSpellName(13327)] = 9, -- Reckless Charge
        [GladiusEx:SafeGetSpellName(30216)] = 9, -- Fel Iron Bomb
        [GladiusEx:SafeGetSpellName(67769)] = 9, -- Cobalt Frag Bomb
        [GladiusEx:SafeGetSpellName(30217)] = 9, -- Adamantite Grenade
        [GladiusEx:SafeGetSpellName(46968)] = 9, -- Shockwave
        [GladiusEx:SafeGetSpellName(5246)] = 9, -- Intimidating Shout
        [GladiusEx:SafeGetSpellName(20253)] = 9, -- Intercept
        [GladiusEx:SafeGetSpellName(6544)] = 9, -- Heroic Leap
        [GladiusEx:SafeGetSpellName(12809)] = 9, -- Concussion Blow
        [GladiusEx:SafeGetSpellName(100)] = 9, -- Charge (R1)
        [GladiusEx:SafeGetSpellName(7922)] = 9, -- Charge Stun
        [GladiusEx:SafeGetSpellName(30283)] = 9, -- Shadowfury
        [GladiusEx:SafeGetSpellName(6358)] = 9, -- Seduction
        [GladiusEx:SafeGetSpellName(5484)] = 9, -- Howl of Terror
        [GladiusEx:SafeGetSpellName(5782)] = 9, -- Fear
        [GladiusEx:SafeGetSpellName(54786)] = 9, -- Demon Leap
        [GladiusEx:SafeGetSpellName(6789)] = 9, -- Death Coil
        [GladiusEx:SafeGetSpellName(710)] = 9, -- Banish
        [GladiusEx:SafeGetSpellName(39796)] = 9, -- Stoneclaw Stun
        [GladiusEx:SafeGetSpellName(51514)] = 9, -- Hex
        [GladiusEx:SafeGetSpellName(61882)] = 9, -- Earthquake
        [GladiusEx:SafeGetSpellName(6770)] = 9, -- Sap
        [GladiusEx:SafeGetSpellName(408)] = 9, -- Kidney Shot
        [GladiusEx:SafeGetSpellName(1776)] = 9, -- Gouge
        [GladiusEx:SafeGetSpellName(1833)] = 9, -- Cheap Shot
        [GladiusEx:SafeGetSpellName(2094)] = 9, -- Blind
        [GladiusEx:SafeGetSpellName(9484)] = 9, -- Shackle Undead
        [GladiusEx:SafeGetSpellName(8122)] = 9, -- Psychic Scream
        [GladiusEx:SafeGetSpellName(64044)] = 9, -- Psychic Horror
        [GladiusEx:SafeGetSpellName(605)] = 9, -- Mind Control
        [GladiusEx:SafeGetSpellName(10326)] = 9, -- Turn Evil
        [GladiusEx:SafeGetSpellName(20066)] = 9, -- Repentance
        [GladiusEx:SafeGetSpellName(2812)] = 9, -- Holy Wrath
        [GladiusEx:SafeGetSpellName(853)] = 9, -- Hammer of Justice
        [GladiusEx:SafeGetSpellName(118)] = 9, -- Polymorph
        [GladiusEx:SafeGetSpellName(12355)] = 9, -- Impact
        [GladiusEx:SafeGetSpellName(31661)] = 9, -- Dragon's Breath
        [GladiusEx:SafeGetSpellName(44572)] = 9, -- Deep Freeze
        [GladiusEx:SafeGetSpellName(50519)] = 9, -- Sonic Blast
        [GladiusEx:SafeGetSpellName(19386)] = 9, -- Wyvern Sting
        [GladiusEx:SafeGetSpellName(19503)] = 9, -- Scatter Shot
        [GladiusEx:SafeGetSpellName(1513)] = 9, -- Scare Beast
        [GladiusEx:SafeGetSpellName(24394)] = 9, -- Intimidation
        [GladiusEx:SafeGetSpellName(14309)] = 9,  -- Freezing Trap
        [GladiusEx:SafeGetSpellName(60210)] = 9, -- Freezing Arrow Effect
        [GladiusEx:SafeGetSpellName(9005)] = 9, -- Pounce
        [GladiusEx:SafeGetSpellName(22570)] = 9, -- Maim
        [GladiusEx:SafeGetSpellName(2637)] = 9, -- Hibernate
        [GladiusEx:SafeGetSpellName(5211)] = 9, -- Bash
        [GladiusEx:SafeGetSpellName(49203)] = 9, -- Hungering Cold
        [GladiusEx:SafeGetSpellName(47481)] = 9, -- Gnaw
        [GladiusEx:SafeGetSpellName(45438)] = 8.9, -- Ice Block
        [GladiusEx:SafeGetSpellName(642)] = 8.9, -- Divine Shield
        [GladiusEx:SafeGetSpellName(47585)] = 8.9, -- Dispersion
        [GladiusEx:SafeGetSpellName(19263)] = 8.9, -- Deterrence
        [GladiusEx:SafeGetSpellName(46924)] = 8.9, -- Bladestorm
        [GladiusEx:SafeGetSpellName(19574)] = 8.9, -- Bestial Wrath
        [GladiusEx:SafeGetSpellName(34692)] = 8.9, -- The Beast Within
        [GladiusEx:SafeGetSpellName(6940)] = 8.8, -- Hand of Sacrifice
        [GladiusEx:SafeGetSpellName(23920)] = 8.7, -- Spell Reflection
        [GladiusEx:SafeGetSpellName(8178)] = 8.7, -- Grounding Totem Effect
        [GladiusEx:SafeGetSpellName(31224)] = 8.7, -- Cloak of Shadows
        [GladiusEx:SafeGetSpellName(48707)] = 8.7, -- Anti-Magic Shell
        [GladiusEx:SafeGetSpellName(48792)] = 8.6, -- Icebound Fortitude
        [GladiusEx:SafeGetSpellName(3411)] = 8.6, --  Intervene
        [GladiusEx:SafeGetSpellName(1022)] = 8.6, -- Hand of Protection
        [GladiusEx:SafeGetSpellName(49039)] = 8.4, -- Lichborne
        [GladiusEx:SafeGetSpellName(18499)] = 8.4, -- Berserker Rage
        [GladiusEx:SafeGetSpellName(5277)] = 8.2, -- Evasion
        [GladiusEx:SafeGetSpellName(38031)] = 8.2, -- Shield Block
        [GladiusEx:SafeGetSpellName(55021)] = 7, -- Silenced  Improved Counterspell
        [GladiusEx:SafeGetSpellName(25046)] = 7, -- Arcane Torrent
        [GladiusEx:SafeGetSpellName(18498)] = 7, -- Silenced  Gag Order
        [GladiusEx:SafeGetSpellName(31117)] = 7, -- Unstable Affliction
        [GladiusEx:SafeGetSpellName(24259)] = 7, -- Spell Lock
        [GladiusEx:SafeGetSpellName(18425)] = 7, -- Silenced  Improved Kick
        [GladiusEx:SafeGetSpellName(1330)] = 7, -- Garrote (Silence)
        [GladiusEx:SafeGetSpellName(15487)] = 7, -- Silence
        [GladiusEx:SafeGetSpellName(31935)] = 7, -- Avenger's Shield
        [GladiusEx:SafeGetSpellName(18469)] = 7, -- Silenced  (Improved Counterspell)
        [GladiusEx:SafeGetSpellName(34490)] = 7, -- Silencing Shot
        [GladiusEx:SafeGetSpellName(47476)] = 7, -- Strangulate
        [GladiusEx:SafeGetSpellName(27559)] = 7, -- Silence (UA Dispel)
        [GladiusEx:SafeGetSpellName(18708)] = 6, -- Fel Domination
        [GladiusEx:SafeGetSpellName(1044)] = 5.5, -- Hand of Freedom
        [GladiusEx:SafeGetSpellName(54216)] = 5.5, -- Master's Call
        [GladiusEx:SafeGetSpellName(16979)] = 5, -- Feral Charge - Bear
        [GladiusEx:SafeGetSpellName(16689)] = 5, -- Nature's Grasp
        [GladiusEx:SafeGetSpellName(13099)] = 5, -- NetoMatic
        [GladiusEx:SafeGetSpellName(55536)] = 5, -- Frostweave Net
        [GladiusEx:SafeGetSpellName(39965)] = 5, -- Frost Grenade
        [GladiusEx:SafeGetSpellName(23694)] = 5, -- Improved Hamstring
        [GladiusEx:SafeGetSpellName(63685)] = 5, -- Freeze
        [GladiusEx:SafeGetSpellName(64695)] = 5, -- Earthgrab
        [GladiusEx:SafeGetSpellName(122)] = 5, -- Frost Nova
        [GladiusEx:SafeGetSpellName(33395)] = 5, -- Freeze
        [GladiusEx:SafeGetSpellName(4167)] = 5, -- Web
        [GladiusEx:SafeGetSpellName(54706)] = 5, -- Venom Web Spray
        [GladiusEx:SafeGetSpellName(50245)] = 5, -- Pin
        [GladiusEx:SafeGetSpellName(19185)] = 5, -- Entrapment
        [GladiusEx:SafeGetSpellName(19306)] = 5, -- Counterattack
        [GladiusEx:SafeGetSpellName(45334)] = 5, -- Feral Charge Effect
        [GladiusEx:SafeGetSpellName(339)] = 5, -- Entangling Roots
        [GladiusEx:SafeGetSpellName(676)] = 4, -- Disarm
        [GladiusEx:SafeGetSpellName(53359)] = 4, -- Chimera Shot - Scorpid
        [GladiusEx:SafeGetSpellName(51722)] = 4, -- Dismantle
        [GladiusEx:SafeGetSpellName(64346)] = 4, -- Fiery Payback
        [GladiusEx:SafeGetSpellName(50541)] = 4, -- Snatch
        [GladiusEx:SafeGetSpellName(51271)] = 3, -- Pillar of Frost
        [GladiusEx:SafeGetSpellName(12043)] = 2.6, -- Presence of Mind
        [GladiusEx:SafeGetSpellName(12042)] = 2.5, -- Arcane Power
        [GladiusEx:SafeGetSpellName(14177)] = 2.6, -- Cold Blood
        [GladiusEx:SafeGetSpellName(16188)] = 2.6, -- Nature's Swiftness
        [GladiusEx:SafeGetSpellName(17116)] = 2.6, -- Nature's Swiftness
        [GladiusEx:SafeGetSpellName(1719)] = 2.6, -- Recklessness
        [GladiusEx:SafeGetSpellName(5217)] = 2.6, -- Tiger's Fury
        [GladiusEx:SafeGetSpellName(29977)] = 2.6, -- Combustion
        [GladiusEx:SafeGetSpellName(12292)] = 2.5, -- Death Wish
        [GladiusEx:SafeGetSpellName(12472)] = 2.5, -- Icy Veins
        [GladiusEx:SafeGetSpellName(13750)] = 2.5, -- Adrenaline Rush
        [GladiusEx:SafeGetSpellName(3045)] = 2.5, -- Rapid Fire
        [GladiusEx:SafeGetSpellName(53201)] = 2.5, -- Starfall
        [GladiusEx:SafeGetSpellName(51713)] = 2.5, -- Shadow Dance
        [GladiusEx:SafeGetSpellName(30823)] = 2.5, -- Shamanistic Rage
        [GladiusEx:SafeGetSpellName(31884)] = 2.5, -- Avenging Wrath
        [GladiusEx:SafeGetSpellName(33206)] = 2.5, -- Pain Suppression
        [GladiusEx:SafeGetSpellName(498)] = 2.5, -- Divine Protection
        [GladiusEx:SafeGetSpellName(12328)] = 2.4, -- Sweeping Strikes
        [GladiusEx:SafeGetSpellName(13877)] = 2.4, -- Blade Flurry
        [GladiusEx:SafeGetSpellName(32182)] = 0.4, -- Heroism
        [GladiusEx:SafeGetSpellName(2825)] = 0.4, -- Bloodlust
        [GladiusEx:SafeGetSpellName(22842)] = 2.1, -- Frenzied Regeneration
        [GladiusEx:SafeGetSpellName(10060)] = 2, -- Power Infusion
        [GladiusEx:SafeGetSpellName(12975)] = 2, -- Last Stand
        [GladiusEx:SafeGetSpellName(14751)] = 2, -- Inner Focus
        [GladiusEx:SafeGetSpellName(27273)] = 2, -- Sacrifice
        [GladiusEx:SafeGetSpellName(22812)] = 2, -- Barkskin
        [GladiusEx:SafeGetSpellName(871)] = 1.9, -- Shield Wall
        [GladiusEx:SafeGetSpellName(31842)] = 1.5, -- Divine Illumination
        [GladiusEx:SafeGetSpellName(3034)] = 1.5, -- Viper Sting
        [GladiusEx:SafeGetSpellName(29166)] = 1.5, -- Innervate
        [GladiusEx:SafeGetSpellName(54428)] = 1.5, -- Divine Plea
        [GladiusEx:SafeGetSpellName(45182)] = 1.5, -- Cheating Death
        [GladiusEx:SafeGetSpellName(6346)] = 1.4, -- Fear Ward
        [GladiusEx:SafeGetSpellName(2687)] = 1.1, -- Bloodrage
        [GladiusEx:SafeGetSpellName(12051)] = 1.1, -- Evocation
        [GladiusEx:SafeGetSpellName(5118)] = 1, -- Aspect of the Cheetah
        [GladiusEx:SafeGetSpellName(1850)] = 1, -- Dash
        [GladiusEx:SafeGetSpellName(2983)] = 1, -- Sprint
        [GladiusEx:SafeGetSpellName(31642)] = 1, -- Blazing Speed
        [GladiusEx:SafeGetSpellName(20578)] = 0.9, -- Cannibalize
        [GladiusEx:SafeGetSpellName(3043)] = 0.9, -- Scorpid Sting
        [GladiusEx:SafeGetSpellName(36554)] = 0.9, -- Shadowstep
        [GladiusEx:SafeGetSpellName(41425)] = 0.9, -- Hypothermia
        [GladiusEx:SafeGetSpellName(11426)] = 0.8, -- Ice Barrier
        [GladiusEx:SafeGetSpellName(1543)] = 0.8, -- Flare
        [GladiusEx:SafeGetSpellName(34709)] = 0.8, -- Shadow Sight
        [GladiusEx:SafeGetSpellName(2645)] = 0.5, -- Ghost Wolf
        --[33891]                            = 0.5, -- Tree of Life (cannot use SafeGetSpellName because there's another aura with the same name that everyone in the team gets)
        [GladiusEx:SafeGetSpellName(9634)] = 0.5, -- Dire Bear Form
        [GladiusEx:SafeGetSpellName(768)] = 0.5, -- Cat Form
        [GladiusEx:SafeGetSpellName(783)] = 0.5, -- Travel Form
        [GladiusEx:SafeGetSpellName(25771)] = 0.1, -- Forbearance
        [GladiusEx:SafeGetSpellName(12489)] = 0, -- Improved Cone of Cold
        [GladiusEx:SafeGetSpellName(29703)] = 0, -- Dazed
        [GladiusEx:SafeGetSpellName(12323)] = 0, -- Piercing Howl
        [GladiusEx:SafeGetSpellName(1715)] = 0, -- Hamstring
        [GladiusEx:SafeGetSpellName(63311)] = 0, -- Shadowsnare
        [GladiusEx:SafeGetSpellName(18223)] = 0, -- Curse of Exhaustion
        [GladiusEx:SafeGetSpellName(18118)] = 0, -- Aftermath
        [GladiusEx:SafeGetSpellName(8034)] = 0, -- Frostbrand Attack
        [GladiusEx:SafeGetSpellName(8056)] = 0, -- Frost Shock
        [GladiusEx:SafeGetSpellName(3600)] = 0, -- Earthbind
        [GladiusEx:SafeGetSpellName(26679)] = 0, -- Deadly Throw
        [GladiusEx:SafeGetSpellName(3409)] = 0, -- Crippling Poison
        [GladiusEx:SafeGetSpellName(31125)] = 0, -- Blade Twisting
        [GladiusEx:SafeGetSpellName(15407)] = 0, -- Mind Flay
        [GladiusEx:SafeGetSpellName(20170)] = 0, -- Seal of Justice
        [GladiusEx:SafeGetSpellName(63529)] = 0, -- Dazed  Avenger's Shield
        [GladiusEx:SafeGetSpellName(31589)] = 0, -- Slow
        [GladiusEx:SafeGetSpellName(44614)] = 0, -- Frostfire Bolt
        [GladiusEx:SafeGetSpellName(116)] = 0, -- Frostbolt
        [GladiusEx:SafeGetSpellName(120)] = 0, -- Cone of Cold
        [GladiusEx:SafeGetSpellName(6136)] = 0, -- Chilled
        [GladiusEx:SafeGetSpellName(11113)] = 0, -- Blast Wave
        [GladiusEx:SafeGetSpellName(50271)] = 0, -- Tendon Rip
        [GladiusEx:SafeGetSpellName(54644)] = 0, -- Froststorm Breath
        [GladiusEx:SafeGetSpellName(2974)] = 0, -- Wing Clip
        [GladiusEx:SafeGetSpellName(61394)] = 0, -- Glyph of Freezing Trap
        [GladiusEx:SafeGetSpellName(13810)] = 0, -- Frost Trap Aura
        [GladiusEx:SafeGetSpellName(5116)] = 0, -- Concussive Shot
        [GladiusEx:SafeGetSpellName(35101)] = 0, -- Concussive Barrage
        [GladiusEx:SafeGetSpellName(61391)] = 0, -- Typhoon
        [GladiusEx:SafeGetSpellName(58179)] = 0, -- Infected Wounds
        [GladiusEx:SafeGetSpellName(50040)] = 0, -- Chilblains
        [GladiusEx:SafeGetSpellName(55666)] = 0, -- Desecration
        [GladiusEx:SafeGetSpellName(45524)] = 0, -- Chains of Ice
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