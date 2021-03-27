local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")

function GladiusEx:GetSpecList()
	return {      
		-- WARRIOR
		[GladiusEx:SafeGetSpellName(12294)]	= "Arms", 			-- Mortal Strike
		[GladiusEx:SafeGetSpellName(46924)]	= "Arms",			   -- Bladestorm
		[GladiusEx:SafeGetSpellName(56638)]	= "Arms",			   -- Taste for Blood
		[GladiusEx:SafeGetSpellName(64976)]	= "Arms",			   -- Juggernaut
		[GladiusEx:SafeGetSpellName(23881)]	= "Fury",			   -- Bloodthirst
		[GladiusEx:SafeGetSpellName(29801)]	= "Fury",			   -- Rampage
		[GladiusEx:SafeGetSpellName(12809)]	= "Protection",		-- Concussion Blow
		[GladiusEx:SafeGetSpellName(23922)]	= "Protection",		-- Shield Slam
		[GladiusEx:SafeGetSpellName(50227)]	= "Protection",		-- Sword and Board
		-- PALADIN
		[GladiusEx:SafeGetSpellName(31935)]	= "Protection",		-- Avenger's Shield
		[GladiusEx:SafeGetSpellName(20473)]	= "Holy",			   -- Holy Shock
		[GladiusEx:SafeGetSpellName(68020)]	= "Retribution",		-- Seal of Command
		[GladiusEx:SafeGetSpellName(35395)]	= "Retribution",		-- Crusader Strike
		[GladiusEx:SafeGetSpellName(53385)]	= "Retribution",		-- Divine Storm
		[GladiusEx:SafeGetSpellName(20066)]	= "Retribution",		-- Repentance
		-- ROGUE
		[GladiusEx:SafeGetSpellName(1329)]	= "Assassination",	   -- Mutilate
		[GladiusEx:SafeGetSpellName(51690)]	= "Combat",			   -- Killing Spree
		[GladiusEx:SafeGetSpellName(13877)]	= "Combat",			   -- Blade Flurry
		[GladiusEx:SafeGetSpellName(13750)]	= "Combat",			   -- Adrenaline Rush
		[GladiusEx:SafeGetSpellName(16511)]	= "Subtlety",		   -- Hemorrhage
		[GladiusEx:SafeGetSpellName(36554)]	= "Subtlety",		   -- Shadowstep
		[GladiusEx:SafeGetSpellName(31223)]	= "Subtlety",		   -- Master of Subtlety
		[GladiusEx:SafeGetSpellName(51713)]	= "Subtlety",		   -- Shadow Dance
		-- PRIEST
		[GladiusEx:SafeGetSpellName(47540)]	= "Discipline",		-- Penance
		[GladiusEx:SafeGetSpellName(10060)]	= "Discipline",		-- Power Infusion
		[GladiusEx:SafeGetSpellName(33206)]	= "Discipline",		-- Pain Suppression
		[GladiusEx:SafeGetSpellName(52795)]	= "Discipline",		-- Borrowed Time
		[GladiusEx:SafeGetSpellName(57472)]	= "Discipline",		-- Renewed Hope
		[GladiusEx:SafeGetSpellName(47517)]	= "Discipline",		-- Grace
      [GladiusEx:SafeGetSpellName(34861)]	= "Holy",			   -- Circle of Healing
      [GladiusEx:SafeGetSpellName(14751)]	= "Holy",			   -- Chakra
		[GladiusEx:SafeGetSpellName(47788)]	= "Holy",			   -- Guardian Spirit
		[GladiusEx:SafeGetSpellName(15487)]	= "Shadow",			   -- Silence
		[GladiusEx:SafeGetSpellName(34914)]	= "Shadow",			   -- Vampiric Touch	
		[GladiusEx:SafeGetSpellName(15407)]	= "Shadow",			   -- Mind Flay		
		[GladiusEx:SafeGetSpellName(15473)]	= "Shadow",			   -- Shadowform
		[GladiusEx:SafeGetSpellName(15286)]	= "Shadow",			   -- Vampiric Embrace
		-- DEATHKNIGHT
		[GladiusEx:SafeGetSpellName(55050)]	= "Blood",			   -- Heart Strike
		[GladiusEx:SafeGetSpellName(49016)]	= "Blood",			   -- Hysteria
		[GladiusEx:SafeGetSpellName(53138)]	= "Blood",			   -- Abomination's Might
		[GladiusEx:SafeGetSpellName(49203)]	= "Frost",			   -- Hungering Cold
		[GladiusEx:SafeGetSpellName(49143)]	= "Frost",			   -- Frost Strike
		[GladiusEx:SafeGetSpellName(49184)]	= "Frost",			   -- Howling Blast
		[GladiusEx:SafeGetSpellName(55610)]	= "Frost",			   -- Imp. Icy Talons
		[GladiusEx:SafeGetSpellName(55090)]	= "Unholy",			   -- Scourge Strike
		[GladiusEx:SafeGetSpellName(49222)]	= "Unholy",			   -- Bone Shield	
		-- MAGE
		[GladiusEx:SafeGetSpellName(44425)]	= "Arcane",			   -- Arcane Barrage
		[GladiusEx:SafeGetSpellName(31583)]	= "Arcane",			   -- Arcane Empowerment
		[GladiusEx:SafeGetSpellName(44457)]	= "Fire",		   	-- Living Bomb
		[GladiusEx:SafeGetSpellName(31661)]	= "Fire",		   	-- Dragon's Breath
		[GladiusEx:SafeGetSpellName(11366)]	= "Fire",		   	-- Pyroblast
		[GladiusEx:SafeGetSpellName(11129)]	= "Fire",			   -- Combustion		
		[GladiusEx:SafeGetSpellName(44572)]	= "Frost",		   	-- Deep Freeze
		[GladiusEx:SafeGetSpellName(31687)]	= "Frost",		   	-- Summon Water Elemental
		[GladiusEx:SafeGetSpellName(11426)]	= "Frost",			   -- Ice Barrier		
		-- WARLOCK
		[GladiusEx:SafeGetSpellName(48181)]	= "Affliction",		-- Haunt
		[GladiusEx:SafeGetSpellName(30108)]	= "Affliction",		-- Unstable Affliction
		[GladiusEx:SafeGetSpellName(59672)]	= "Demonology",		-- Metamorphosis
		[GladiusEx:SafeGetSpellName(50769)]	= "Destruction",		-- Chaos Bolt
		[GladiusEx:SafeGetSpellName(30283)]	= "Destruction",		-- Shadowfury
		[GladiusEx:SafeGetSpellName(30299)]	= "Destruction",		-- Nether Protection
		[GladiusEx:SafeGetSpellName(17962)]	= "Destruction",		-- Conflagrate
		-- SHAMAN
		[GladiusEx:SafeGetSpellName(51490)]	= "Elemental",		   -- Thunderstorm
		[GladiusEx:SafeGetSpellName(16166)]	= "Elemental",		   -- Elemental Mastery
		[GladiusEx:SafeGetSpellName(51470)]	= "Elemental",		   -- Elemental Oath
		[GladiusEx:SafeGetSpellName(30802)]	= "Enhancement",		-- Unleashed Rage
		[GladiusEx:SafeGetSpellName(51533)]	= "Enhancement",		-- Feral Spirit
		[GladiusEx:SafeGetSpellName(30823)]	= "Enhancement",		-- Shamanistic Rage
		[GladiusEx:SafeGetSpellName(17364)]	= "Enhancement",		-- Stormstrike
		[GladiusEx:SafeGetSpellName(60103)]	= "Enhancement",		-- Lava Lash
		[GladiusEx:SafeGetSpellName(61295)]	= "Restoration",		-- Riptide
		[GladiusEx:SafeGetSpellName(51886)]	= "Restoration",		-- Cleanse Spirit
		[GladiusEx:SafeGetSpellName(974)]	   = "Restoration",		-- Earth Shield		
		-- HUNTER
		[GladiusEx:SafeGetSpellName(19577)]	= "Beast Mastery",	-- Intimidation
		[GladiusEx:SafeGetSpellName(20895)]	= "Beast Mastery",	-- Spirit Bond
		[GladiusEx:SafeGetSpellName(19506)]	= "Marksmanship",	   -- Trueshot Aura
		[GladiusEx:SafeGetSpellName(34490)]	= "Marksmanship",	   -- Silencing Shot
		[GladiusEx:SafeGetSpellName(53209)]	= "Marksmanship",	   -- Chimera Shot
		[GladiusEx:SafeGetSpellName(19434)]	= "Marksmanship",    -- Aimed Shot
		[GladiusEx:SafeGetSpellName(53301)]	= "Survival",		   -- Explosive Shot
		[GladiusEx:SafeGetSpellName(19386)]	= "Survival",		   -- Wyvern Sting
		-- DRUID
		[GladiusEx:SafeGetSpellName(48505)]	= "Balance",			-- Starfall
		[GladiusEx:SafeGetSpellName(50516)]	= "Balance",			-- Typhoon
		[GladiusEx:SafeGetSpellName(33831)]	= "Balance",			-- Force of Nature
		[GladiusEx:SafeGetSpellName(24907)]	= "Balance",			-- Moonkin Form
		[GladiusEx:SafeGetSpellName(33876)]	= "Feral",			   -- Mangle (Cat)
		[GladiusEx:SafeGetSpellName(33878)]	= "Feral",			   -- Mangle (Bear)
		[GladiusEx:SafeGetSpellName(24932)]	= "Feral",			   -- Leader of the Pack
		[GladiusEx:SafeGetSpellName(18562)]	= "Restoration",		-- Swiftmend
		[GladiusEx:SafeGetSpellName(48438)]	= "Restoration",		-- Wild Growth		
		[GladiusEx:SafeGetSpellName(33891)]	= "Restoration",		-- Tree of Life		
		[GladiusEx:SafeGetSpellName(65139)]	= "Restoration",		-- Tree of Life
	}
end