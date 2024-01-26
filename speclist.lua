local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")

function GladiusEx:GetSpecList()
	return {      
		-- WARRIOR
		[GladiusEx:SafeGetSpellName(12294)]	= 71, 		-- Mortal Strike
		[GladiusEx:SafeGetSpellName(46924)]	= 71,		-- Bladestorm
		[GladiusEx:SafeGetSpellName(56638)]	= 71,		-- Taste for Blood
		[GladiusEx:SafeGetSpellName(64976)]	= 71,		-- Juggernaut
		[GladiusEx:SafeGetSpellName(23881)]	= 72,		-- Bloodthirst
		[GladiusEx:SafeGetSpellName(29801)]	= 72,		-- Rampage
		[GladiusEx:SafeGetSpellName(12809)]	= 66,		-- Concussion Blow
		[GladiusEx:SafeGetSpellName(23922)]	= 66,		-- Shield Slam
		[GladiusEx:SafeGetSpellName(50227)]	= 66,		-- Sword and Board
		-- PALADIN
		[GladiusEx:SafeGetSpellName(31935)]	= 66,		-- Avenger's Shield
		[GladiusEx:SafeGetSpellName(20473)]	= 65,		-- Holy Shock
		[GladiusEx:SafeGetSpellName(68020)]	= 70,		-- Seal of Command
		[GladiusEx:SafeGetSpellName(35395)]	= 70,		-- Crusader Strike
		[GladiusEx:SafeGetSpellName(53385)]	= 70,		-- Divine Storm
		[GladiusEx:SafeGetSpellName(20066)]	= 70,		-- Repentance
		-- ROGUE
		[GladiusEx:SafeGetSpellName(1329)]	= 259,	    -- Mutilate
		[GladiusEx:SafeGetSpellName(51690)]	= 260,	    -- Killing Spree
		[GladiusEx:SafeGetSpellName(13877)]	= 260,	    -- Blade Flurry
		[GladiusEx:SafeGetSpellName(13750)]	= 260,	    -- Adrenaline Rush
		[GladiusEx:SafeGetSpellName(16511)]	= 261,	    -- Hemorrhage
		[GladiusEx:SafeGetSpellName(36554)]	= 261,	    -- Shadowstep
		[GladiusEx:SafeGetSpellName(31223)]	= 261,	    -- Master of Subtlety
		[GladiusEx:SafeGetSpellName(51713)]	= 261,	    -- Shadow Dance
		-- PRIEST
		[GladiusEx:SafeGetSpellName(47540)]	= 256,		-- Penance
		[GladiusEx:SafeGetSpellName(10060)]	= 256,		-- Power Infusion
		[GladiusEx:SafeGetSpellName(33206)]	= 256,		-- Pain Suppression
		[GladiusEx:SafeGetSpellName(52795)]	= 256,		-- Borrowed Time
		[GladiusEx:SafeGetSpellName(57472)]	= 256,		-- Renewed Hope
		[GladiusEx:SafeGetSpellName(47517)]	= 256,		-- Grace
		[GladiusEx:SafeGetSpellName(34861)]	= 257,		-- Circle of Healing
		[GladiusEx:SafeGetSpellName(14751)]	= 257,		-- Chakra
		[GladiusEx:SafeGetSpellName(47788)]	= 257,		-- Guardian Spirit
		[GladiusEx:SafeGetSpellName(15487)]	= 258,		-- Silence
		[GladiusEx:SafeGetSpellName(34914)]	= 258,		-- Vampiric Touch	
		[GladiusEx:SafeGetSpellName(15407)]	= 258,		-- Mind Flay		
		[GladiusEx:SafeGetSpellName(15473)]	= 258,		-- Shadowform
		[GladiusEx:SafeGetSpellName(15286)]	= 258,		-- Vampiric Embrace
		-- DEATHKNIGHT                                  
		[GladiusEx:SafeGetSpellName(55050)]	= 250,		-- Heart Strike
		[GladiusEx:SafeGetSpellName(49016)]	= 250,		-- Hysteria
		[GladiusEx:SafeGetSpellName(53138)]	= 250,		-- Abomination's Might
		[GladiusEx:SafeGetSpellName(49203)]	= 251,		-- Hungering Cold
		[GladiusEx:SafeGetSpellName(49143)]	= 251,		-- Frost Strike
		[GladiusEx:SafeGetSpellName(49184)]	= 251,		-- Howling Blast
		[GladiusEx:SafeGetSpellName(55610)]	= 251,		-- Imp. Icy Talons
		[GladiusEx:SafeGetSpellName(55090)]	= 252,		-- Scourge Strike
		[GladiusEx:SafeGetSpellName(49222)]	= 252,		-- Bone Shield	
		-- MAGE                                         
		[GladiusEx:SafeGetSpellName(44425)]	= 62,		-- Arcane Barrage
		[GladiusEx:SafeGetSpellName(31583)]	= 62,		-- Arcane Empowerment
		[GladiusEx:SafeGetSpellName(44457)]	= 63,		-- Living Bomb
		[GladiusEx:SafeGetSpellName(31661)]	= 63,		-- Dragon's Breath
		[GladiusEx:SafeGetSpellName(11366)]	= 63,		-- Pyroblast
		[GladiusEx:SafeGetSpellName(11129)]	= 63,		-- Combustion		
		[GladiusEx:SafeGetSpellName(44572)]	= 251,		-- Deep Freeze
		[GladiusEx:SafeGetSpellName(31687)]	= 251,		-- Summon Water Elemental
		[GladiusEx:SafeGetSpellName(11426)]	= 251,		-- Ice Barrier		
		-- WARLOCK                                     
		[GladiusEx:SafeGetSpellName(48181)]	= 265,		-- Haunt
		[GladiusEx:SafeGetSpellName(30108)]	= 265,		-- Unstable Affliction
		[GladiusEx:SafeGetSpellName(59672)]	= 266,		-- Metamorphosis
		[GladiusEx:SafeGetSpellName(50769)]	= 267,		-- Chaos Bolt
		[GladiusEx:SafeGetSpellName(30283)]	= 267,		-- Shadowfury
		[GladiusEx:SafeGetSpellName(30299)]	= 267,		-- Nether Protection
		[GladiusEx:SafeGetSpellName(17962)]	= 267,		-- Conflagrate
		-- SHAMAN                                       
		[GladiusEx:SafeGetSpellName(51490)]	= 262,		-- Thunderstorm
		[GladiusEx:SafeGetSpellName(16166)]	= 262,		-- Elemental Mastery
		[GladiusEx:SafeGetSpellName(51470)]	= 262,		-- Elemental Oath
		[GladiusEx:SafeGetSpellName(30802)]	= 263,		-- Unleashed Rage
		[GladiusEx:SafeGetSpellName(51533)]	= 263,		-- Feral Spirit
		[GladiusEx:SafeGetSpellName(30823)]	= 263,		-- Shamanistic Rage
		[GladiusEx:SafeGetSpellName(17364)]	= 263,		-- Stormstrike
		[GladiusEx:SafeGetSpellName(60103)]	= 263,		-- Lava Lash
		[GladiusEx:SafeGetSpellName(61295)]	= 264,		-- Riptide
		[GladiusEx:SafeGetSpellName(51886)]	= 264,		-- Cleanse Spirit
		[GladiusEx:SafeGetSpellName(974)]	= 264,		-- Earth Shield		
		-- HUNTER
		[GladiusEx:SafeGetSpellName(19577)]	= 253,		-- Intimidation
		[GladiusEx:SafeGetSpellName(20895)]	= 253,		-- Spirit Bond
		[GladiusEx:SafeGetSpellName(19506)]	= 254,	   	-- Trueshot Aura
		[GladiusEx:SafeGetSpellName(34490)]	= 254,	   	-- Silencing Shot
		[GladiusEx:SafeGetSpellName(53209)]	= 254,	   	-- Chimera Shot
		[GladiusEx:SafeGetSpellName(19434)]	= 254,    	-- Aimed Shot
		[GladiusEx:SafeGetSpellName(53301)]	= 255,		-- Explosive Shot
		[GladiusEx:SafeGetSpellName(19386)]	= 255,		-- Wyvern Sting
		-- DRUID
		[GladiusEx:SafeGetSpellName(48505)]	= 102,		-- Starfall
		[GladiusEx:SafeGetSpellName(50516)]	= 102,		-- Typhoon
		[GladiusEx:SafeGetSpellName(33831)]	= 102,		-- Force of Nature
		[GladiusEx:SafeGetSpellName(24907)]	= 102,		-- Moonkin Form
		[GladiusEx:SafeGetSpellName(33876)]	= 103,		-- Mangle (Cat)
		[GladiusEx:SafeGetSpellName(33878)]	= 103,		-- Mangle (Bear)
		[GladiusEx:SafeGetSpellName(24932)]	= 103,		-- Leader of the Pack
		[GladiusEx:SafeGetSpellName(18562)]	= 105,		-- Swiftmend
		[GladiusEx:SafeGetSpellName(48438)]	= 105,		-- Wild Growth		
		[GladiusEx:SafeGetSpellName(33891)]	= 105,		-- Tree of Life		
		--[GladiusEx:SafeGetSpellName(65139)]	= 105,		-- Tree of Life
	}
end