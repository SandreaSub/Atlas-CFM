---
--- Spells.lua - Spell and enchantment data tables
---
--- This module contains comprehensive spell data for Atlas-CFM including
--- enchantments, buffs, abilities, and magical effects. It provides
--- spell information for item tooltips and effect descriptions.
---
--- Features:
--- • Complete enchantment database
--- • Spell effect definitions
--- • Buff and debuff information
--- • Magical item effects
--- • Spell ID mappings
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}

local L = AtlasCFM.Localization.UI
local LF = AtlasCFM.Localization.Factions
local LS = AtlasCFM.Localization.Spells
local LMD = AtlasCFM.Localization.MapData

local Colors = AtlasCFM.Colors

AtlasCFM.SpellDB = {
	enchants = {
		[5169] = { --Defias Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Defias Disguise"],
			tools = { 7997 },
			reagents = {
				{ 2589 },
			},
		},
		[5264] = { --South Seas Pirate Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["South Seas Pirate Disguise"],
			tools = { 5107 },
			reagents = {
				{ 2589 },
			},
		},
		[5265] = { --Stonesplinter Trogg Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Stonesplinter Trogg Disguise"],
			tools = { 5109 },
			reagents = {
				{ 2589 },
			},
		},
		[5266] = { --Syndicate Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Syndicate Disguise"],
			tools = { 5113 },
			reagents = {
				{ 2592 },
			},
		},
		[5267] = { --Dalaran Wizard Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Dalaran Wizard Disguise"],
			tools = { 5110 },
			reagents = {
				{ 2589 },
			},
		},
		[5268] = { --Dark Iron Dwarf Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Dark Iron Dwarf Disguise"],
			tools = { 5108 },
			reagents = {
				{ 2592 },
			},
		},
		[5668] = { --Peasant Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Peasant Disguise"],
			extra = LF["Horde"],
			reagents = {
				{ 2589 },
			},
		},
		[5669] = { --Peon Disguise
			icon = "Ability_Rogue_Disguise",
			name = LS["Peon Disguise"],
			extra = LF["Alliance"],
			reagents = {
				{ 2589 },
			},
		},
		[7418] = {
			name = LS["Enchant Bracer - Minor Health"],
			tools = { 6218 },
			reagents = {
				{ 10940 },
			},
		},
		[7420] = {
			name = LS["Enchant Chest - Minor Health"],
			tools = { 6218 },
			reagents = {
				{ 10940 },
			},
		},
		[7421] = { --Runed Copper Rod
			item = 6218,
			reagents = {
				{ 6217 },
				{ 10940 },
				{ 10938 },
			},
		},
		[7426] = {
			name = LS["Enchant Chest - Minor Absorption"],
			tools = { 6218 },
			reagents = {
				{ 10940, 2 },
				{ 10938 },
			},
		},
		[7428] = {
			name = LS["Enchant Bracer - Minor Deflect"],
			tools = { 6218 },
			reagents = {
				{ 10938 },
				{ 10940 },
			},
		},
		[7443] = {
			name = LS["Enchant Chest - Minor Mana"],
			tools = { 6218 },
			reagents = {
				{ 10938 },
			},
		},
		[7454] = {
			name = LS["Enchant Cloak - Minor Resistance"],
			tools = { 6218 },
			reagents = {
				{ 10940 },
				{ 10938, 2 },
			},
		},
		[7457] = {
			name = LS["Enchant Bracer - Minor Stamina"],
			tools = { 6218 },
			reagents = {
				{ 10940, 3 },
			},
		},
		[7745] = {
			name = LS["Enchant 2H Weapon - Minor Impact"],
			tools = { 6218 },
			reagents = {
				{ 10940, 4 },
				{ 10978 },
			},
		},
		[7748] = {
			name = LS["Enchant Chest - Lesser Health"],
			tools = { 6218 },
			reagents = {
				{ 10940, 2 },
				{ 10938, 2 },
			},
		},
		[7766] = {
			name = LS["Enchant Bracer - Minor Spirit"],
			tools = { 6218 },
			reagents = {
				{ 10938, 2 },
			},
		},
		[7771] = {
			name = LS["Enchant Cloak - Minor Protection"],
			tools = { 6218 },
			reagents = {
				{ 10940, 3 },
				{ 10939 },
			},
		},
		[7776] = {
			name = LS["Enchant Chest - Lesser Mana"],
			tools = { 6218 },
			reagents = {
				{ 10939 },
				{ 10938 },
			},
		},
		[7779] = {
			name = LS["Enchant Bracer - Minor Agility"],
			tools = { 6218 },
			reagents = {
				{ 10940, 2 },
				{ 10939 },
			},
		},
		[7782] = {
			name = LS["Enchant Bracer - Minor Strength"],
			tools = { 6218 },
			reagents = {
				{ 10940, 5 },
			},
		},
		[7786] = {
			name = LS["Enchant Weapon - Minor Beastslayer"],
			tools = { 6218 },
			reagents = {
				{ 10940, 4 },
				{ 10939, 2 },
			},
		},
		[7788] = {
			name = LS["Enchant Weapon - Minor Striking"],
			tools = { 6218 },
			reagents = {
				{ 10940, 2 },
				{ 10939 },
				{ 10978 },
			},
		},
		[7793] = {
			name = LS["Enchant 2H Weapon - Lesser Intellect"],
			tools = { 6218 },
			reagents = {
				{ 10939, 3 },
			},
		},
		[7795] = { --Runed Silver Rod
			item = 6339,
			reagents = {
				{ 6338 },
				{ 10940, 6 },
				{ 10939, 3 },
				{ 1210 },
			},
		},
		[7857] = {
			name = LS["Enchant Chest - Health"],
			tools = { 6339 },
			reagents = {
				{ 10940, 4 },
				{ 10998 },
			},
		},
		[7859] = {
			name = LS["Enchant Bracer - Lesser Spirit"],
			tools = { 6339 },
			reagents = {
				{ 10998, 2 },
			},
		},
		[7861] = {
			name = LS["Enchant Cloak - Lesser Fire Resistance"],
			tools = { 6339 },
			reagents = {
				{ 6371 },
				{ 10998 },
			},
		},
		[7863] = {
			name = LS["Enchant Boots - Minor Stamina"],
			tools = { 6339 },
			reagents = {
				{ 10940, 8 },
			},
		},
		[7867] = {
			name = LS["Enchant Boots - Minor Agility"],
			tools = { 6339 },
			reagents = {
				{ 10940, 6 },
				{ 10998, 2 },
			},
		},
		[13378] = {
			name = LS["Enchant Shield - Minor Stamina"],
			tools = { 6218 },
			reagents = {
				{ 10998 },
				{ 10940, 2 },
			},
		},
		[13380] = {
			name = LS["Enchant 2H Weapon - Lesser Spirit"],
			tools = { 6218 },
			reagents = {
				{ 10998 },
				{ 10940, 6 },
			},
		},
		[13419] = {
			name = LS["Enchant Cloak - Minor Agility"],
			tools = { 6339 },
			reagents = {
				{ 10998 },
			},
		},
		[13421] = {
			name = LS["Enchant Cloak - Lesser Protection"],
			tools = { 6218 },
			reagents = {
				{ 10940, 6 },
				{ 10978 },
			},
		},
		[13464] = {
			name = LS["Enchant Shield - Lesser Protection"],
			tools = { 6339 },
			reagents = {
				{ 10998 },
				{ 10940 },
				{ 10978 },
			},
		},
		[13485] = {
			name = LS["Enchant Shield - Lesser Spirit"],
			tools = { 6339 },
			reagents = {
				{ 10998, 2 },
				{ 10940, 4 },
			},
		},
		[13501] = {
			name = LS["Enchant Bracer - Lesser Stamina"],
			tools = { 6339 },
			reagents = {
				{ 11083, 2 },
			},
		},
		[13503] = {
			name = LS["Enchant Weapon - Lesser Striking"],
			tools = { 6339 },
			reagents = {
				{ 11083, 2 },
				{ 11084 },
			},
		},
		[13522] = {
			name = LS["Enchant Cloak - Lesser Shadow Resistance"],
			tools = { 6339 },
			reagents = {
				{ 11082 },
				{ 6048 },
			},
		},
		[13529] = {
			name = LS["Enchant 2H Weapon - Lesser Impact"],
			tools = { 6339 },
			reagents = {
				{ 11083, 3 },
				{ 11084 },
			},
		},
		[13536] = {
			name = LS["Enchant Bracer - Lesser Strength"],
			tools = { 6339 },
			reagents = {
				{ 11083, 2 },
			},
		},
		[13538] = {
			name = LS["Enchant Chest - Lesser Absorption"],
			tools = { 6339 },
			reagents = {
				{ 10940, 2 },
				{ 11082 },
				{ 11084 },
			},
		},
		[13607] = {
			name = LS["Enchant Chest - Mana"],
			tools = { 6339 },
			reagents = {
				{ 11082 },
				{ 10998, 2 },
			},
		},
		[13612] = {
			name = LS["Enchant Gloves - Mining"],
			tools = { 6339 },
			reagents = {
				{ 11083 },
				{ 2772, 3 },
			},
		},
		[13617] = {
			name = LS["Enchant Gloves - Herbalism"],
			tools = { 6339 },
			reagents = {
				{ 11083 },
				{ 3356, 3 },
			},
		},
		[13620] = {
			name = LS["Enchant Gloves - Fishing"],
			tools = { 6339 },
			reagents = {
				{ 11083 },
				{ 6370, 3 },
			},
		},
		[13622] = {
			name = LS["Enchant Bracer - Lesser Intellect"],
			tools = { 6339 },
			reagents = {
				{ 11082, 2 },
			},
		},
		[13626] = {
			name = LS["Enchant Chest - Minor Stats"],
			tools = { 6339 },
			reagents = {
				{ 11082 },
				{ 11083 },
				{ 11084 },
			},
		},
		[13628] = { --Runed Golden Rod
			item = 11130,
			reagents = {
				{ 11128 },
				{ 5500 },
				{ 11082, 2 },
				{ 11083, 2 },
			},
		},
		[13631] = {
			name = LS["Enchant Shield - Lesser Stamina"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 11083 },
			},
		},
		[13635] = {
			name = LS["Enchant Cloak - Defense"],
			tools = { 11130 },
			reagents = {
				{ 11138 },
				{ 11083, 3 },
			},
		},
		[13637] = {
			name = LS["Enchant Boots - Lesser Agility"],
			tools = { 11130 },
			reagents = {
				{ 11083 },
				{ 11134 },
			},
		},
		[13640] = {
			name = LS["Enchant Chest - Greater Health"],
			tools = { 11130 },
			reagents = {
				{ 11083, 3 },
			},
		},
		[13642] = {
			name = LS["Enchant Bracer - Spirit"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
			},
		},
		[13644] = {
			name = LS["Enchant Boots - Lesser Stamina"],
			tools = { 11130 },
			reagents = {
				{ 11083, 4 },
			},
		},
		[13646] = {
			name = LS["Enchant Bracer - Lesser Deflection"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 11083, 2 },
			},
		},
		[13648] = {
			name = LS["Enchant Bracer - Stamina"],
			tools = { 11130 },
			reagents = {
				{ 11083, 6 },
			},
		},
		[13653] = {
			name = LS["Enchant Weapon - Lesser Beastslayer"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 5637, 2 },
				{ 11138 },
			},
		},
		[13655] = {
			name = LS["Enchant Weapon - Lesser Elemental Slayer"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 7067 },
				{ 11138 },
			},
		},
		[13657] = {
			name = LS["Enchant Cloak - Fire Resistance"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 7068 },
			},
		},
		[13659] = {
			name = LS["Enchant Shield - Spirit"],
			tools = { 11130 },
			reagents = {
				{ 11135 },
				{ 11137 },
			},
		},
		[13661] = {
			name = LS["Enchant Bracer - Strength"],
			tools = { 11130 },
			reagents = {
				{ 11137 },
			},
		},
		[13663] = {
			name = LS["Enchant Chest - Greater Mana"],
			tools = { 11130 },
			reagents = {
				{ 11135 },
			},
		},
		[13687] = {
			name = LS["Enchant Boots - Lesser Spirit"],
			tools = { 11130 },
			reagents = {
				{ 11135 },
				{ 11134, 2 },
			},
		},
		[13689] = {
			name = LS["Enchant Shield - Lesser Block"],
			tools = { 11130 },
			reagents = {
				{ 11135, 2 },
				{ 11137, 2 },
				{ 11139 },
			},
		},
		[13693] = {
			name = LS["Enchant Weapon - Striking"],
			tools = { 11130 },
			reagents = {
				{ 11135, 2 },
				{ 11139 },
			},
		},
		[13695] = {
			name = LS["Enchant 2H Weapon - Impact"],
			tools = { 11130 },
			reagents = {
				{ 11137, 4 },
				{ 11139 },
			},
		},
		[13698] = {
			name = LS["Enchant Gloves - Skinning"],
			tools = { 11130 },
			reagents = {
				{ 11137 },
				{ 7392, 3 },
			},
		},
		[13700] = {
			name = LS["Enchant Chest - Lesser Stats"],
			tools = { 11130 },
			reagents = {
				{ 11135, 2 },
				{ 11137, 2 },
				{ 11139 },
			},
		},
		[13702] = { --Runed Truesilver Rod
			item = 11145,
			reagents = {
				{ 11144 },
				{ 7971 },
				{ 11135, 2 },
				{ 11137, 2 },
			},
		},
		[13746] = {
			name = LS["Enchant Cloak - Greater Defense"],
			tools = { 11145 },
			reagents = {
				{ 11137, 3 },
			},
		},
		[13794] = {
			name = LS["Enchant Cloak - Resistance"],
			tools = { 11145 },
			reagents = {
				{ 11174 },
			},
		},
		[13815] = {
			name = LS["Enchant Gloves - Agility"],
			tools = { 11145 },
			reagents = {
				{ 11174 },
				{ 11137 },
			},
		},
		[13817] = {
			name = LS["Enchant Shield - Stamina"],
			tools = { 11145 },
			reagents = {
				{ 11137, 5 },
			},
		},
		[13822] = {
			name = LS["Enchant Bracer - Intellect"],
			tools = { 11145 },
			reagents = {
				{ 11174, 2 },
			},
		},
		[13836] = {
			name = LS["Enchant Boots - Stamina"],
			tools = { 11145 },
			reagents = {
				{ 11137, 5 },
			},
		},
		[13841] = {
			name = LS["Enchant Gloves - Advanced Mining"],
			tools = { 11145 },
			reagents = {
				{ 11137, 3 },
				{ 6037,  3 },
			},
		},
		[13846] = {
			name = LS["Enchant Bracer - Greater Spirit"],
			tools = { 11145 },
			reagents = {
				{ 11174, 3 },
				{ 11137 },
			},
		},
		[13858] = {
			name = LS["Enchant Chest - Superior Health"],
			tools = { 11145 },
			reagents = {
				{ 11137, 6 },
			},
		},
		[13868] = {
			name = LS["Enchant Gloves - Advanced Herbalism"],
			tools = { 11145 },
			reagents = {
				{ 11137, 3 },
				{ 8838,  3 },
			},
		},
		[13882] = {
			name = LS["Enchant Cloak - Lesser Agility"],
			tools = { 11145 },
			reagents = {
				{ 11174, 2 },
			},
		},
		[13887] = {
			name = LS["Enchant Gloves - Strength"],
			tools = { 11145 },
			reagents = {
				{ 11174, 2 },
				{ 11137, 3 },
			},
		},
		[13890] = {
			name = LS["Enchant Boots - Minor Speed"],
			tools = { 11145 },
			reagents = {
				{ 11177 },
				{ 7909 },
				{ 11174 },
			},
		},
		[13898] = {
			name = LS["Enchant Weapon - Fiery Weapon"],
			tools = { 11145 },
			reagents = {
				{ 11177, 4 },
				{ 7078 },
			},
		},
		[13905] = {
			name = LS["Enchant Shield - Greater Spirit"],
			tools = { 11145 },
			reagents = {
				{ 11175 },
				{ 11176, 2 },
			},
		},
		[13915] = {
			name = LS["Enchant Weapon - Demonslaying"],
			tools = { 11145 },
			reagents = {
				{ 11177 },
				{ 11176, 2 },
				{ 9224 },
			},
		},
		[13917] = {
			name = LS["Enchant Chest - Superior Mana"],
			tools = { 11145 },
			reagents = {
				{ 11175 },
				{ 11174, 2 },
			},
		},
		[13931] = {
			name = LS["Enchant Bracer - Deflection"],
			tools = { 11145 },
			reagents = {
				{ 11175 },
				{ 11176, 2 },
			},
		},
		[13933] = {
			name = LS["Enchant Shield - Frost Resistance"],
			tools = { 11145 },
			reagents = {
				{ 11178 },
				{ 3829 },
			},
		},
		[13935] = {
			name = LS["Enchant Boots - Agility"],
			tools = { 11145 },
			reagents = {
				{ 11175, 2 },
			},
		},
		[13937] = {
			name = LS["Enchant 2H Weapon - Greater Impact"],
			tools = { 11145 },
			reagents = {
				{ 11178, 2 },
				{ 11176, 2 },
			},
		},
		[13939] = {
			name = LS["Enchant Bracer - Greater Strength"],
			tools = { 11145 },
			reagents = {
				{ 11176, 2 },
				{ 11175 },
			},
		},
		[13941] = {
			name = LS["Enchant Chest - Stats"],
			tools = { 11145 },
			reagents = {
				{ 11178 },
				{ 11176, 3 },
				{ 11175, 2 },
			},
		},
		[13943] = {
			name = LS["Enchant Weapon - Greater Striking"],
			tools = { 11145 },
			reagents = {
				{ 11178, 2 },
				{ 11175, 2 },
			},
		},
		[13945] = {
			name = LS["Enchant Bracer - Greater Stamina"],
			tools = { 11145 },
			reagents = {
				{ 11176, 5 },
			},
		},
		[13947] = {
			name = LS["Enchant Gloves - Riding Skill"],
			tools = { 11145 },
			reagents = {
				{ 11178, 2 },
				{ 11176, 3 },
			},
		},
		[13948] = {
			name = LS["Enchant Gloves - Minor Haste"],
			tools = { 11145 },
			reagents = {
				{ 11178, 2 },
				{ 8153,  2 },
			},
		},
		[14293] = { --Lesser Magic Wand
			tools = { 6218 },
			item = 11287,
			reagents = {
				{ 4470 },
				{ 10938 },
			},
		},
		[14807] = { --Greater Magic Wand
			tools = { 6218 },
			item = 11288,
			reagents = {
				{ 4470 },
				{ 10939 },
			},
		},
		[14809] = { --Lesser Mystic Wand
			tools = { 11130 },
			item = 11289,
			reagents = {
				{ 11291 },
				{ 11134 },
				{ 11083 },
			},
			reagents_TURTLE = {
				{ 42007 },
				{ 11134 },
				{ 11083 },
			},
		},
		[14810] = { --Greater Mystic Wand
			tools = { 11130 },
			item = 11290,
			reagents = {
				{ 11291 },
				{ 11135 },
				{ 11137 },
			},
			reagents_TURTLE = {
				{ 42007 },
				{ 11135 },
				{ 11137 },
			},
		},
		[15596] = { --Smoking Heart of the Mountain
			item = 11811,
			reagents = {
				{ 11382 },
				{ 7078 },
				{ 14343, 3 },
			},
			reagents_VANILLA_PLUS = {
				{ 11382 },
				{ 14344, 10 },
				{ 7078,  12 },
				{ 7076,  12 },
			},
		},
		[17180] = { --Enchanted Thorium
			tools = { 11145 },
			item = 12655,
			reagents = {
				{ 12359 },
				{ 11176, 3 },
			},
			reagents_TURTLE = {
				{ 12359 },
				{ 16204, 3 },
			},
		},
		[17181] = { --Enchanted Leather
			tools = { 11145 },
			item = 12810,
			reagents = {
				{ 8170 },
				{ 16202 },
			},
		},
		[20008] = {
			name = LS["Enchant Bracer - Greater Intellect"],
			tools = { 11145 },
			reagents = {
				{ 16202, 3 },
			},
		},
		[20009] = {
			name = LS["Enchant Bracer - Superior Spirit"],
			tools = { 11145 },
			reagents = {
				{ 16202, 3 },
				{ 11176, 10 },
			},
		},
		[20010] = {
			name = LS["Enchant Bracer - Superior Strength"],
			tools = { 11145 },
			reagents = {
				{ 16204, 6 },
				{ 16203, 6 },
			},
		},
		[20011] = {
			name = LS["Enchant Bracer - Superior Stamina"],
			tools = { 11145 },
			reagents = {
				{ 16204, 15 },
			},
		},
		[20012] = {
			name = LS["Enchant Gloves - Greater Agility"],
			tools = { 11145 },
			reagents = {
				{ 16202, 3 },
				{ 16204, 3 },
			},
		},
		[20013] = {
			name = LS["Enchant Gloves - Greater Strength"],
			tools = { 11145 },
			reagents = {
				{ 16203, 4 },
				{ 16204, 4 },
			},
		},
		[20014] = {
			name = LS["Enchant Cloak - Greater Resistance"],
			tools = { 11145 },
			reagents = {
				{ 16202, 2 },
				{ 7077 },
				{ 7075 },
				{ 7079 },
				{ 7081 },
				{ 7972 },
			},
		},
		[20015] = {
			name = LS["Enchant Cloak - Superior Defense"],
			tools = { 11145 },
			reagents = {
				{ 16204, 8 },
			},
		},
		[20016] = {
			name = LS["Enchant Shield - Superior Spirit"],
			tools = { 11145 },
			reagents = {
				{ 16203, 2 },
				{ 16204, 4 },
			},
		},
		[20017] = {
			name = LS["Enchant Shield - Greater Stamina"],
			tools = { 11145 },
			reagents = {
				{ 11176, 10 },
			},
		},
		[20020] = {
			name = LS["Enchant Boots - Greater Stamina"],
			tools = { 11145 },
			reagents = {
				{ 11176, 10 },
			},
		},
		[20023] = {
			name = LS["Enchant Boots - Greater Agility"],
			tools = { 11145 },
			reagents = {
				{ 16203, 8 },
			},
		},
		[20024] = {
			name = LS["Enchant Boots - Spirit"],
			tools = { 11145 },
			reagents = {
				{ 16203, 2 },
				{ 16202 },
			},
		},
		[20025] = {
			name = LS["Enchant Chest - Greater Stats"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 16204, 15 },
				{ 16203, 10 },
			},
		},
		[20026] = {
			name = LS["Enchant Chest - Major Health"],
			tools = { 11145 },
			reagents = {
				{ 16204, 6 },
				{ 14343 },
			},
		},
		[20028] = {
			name = LS["Enchant Chest - Major Mana"],
			tools = { 11145 },
			reagents = {
				{ 16203, 3 },
				{ 14343 },
			},
		},
		[20029] = {
			name = LS["Enchant Weapon - Icy Chill"],
			tools = { 11145 },
			reagents = {
				{ 14343, 4 },
				{ 7080 },
				{ 7082 },
				{ 13467 },
			},
		},
		[20030] = {
			name = LS["Enchant 2H Weapon - Superior Impact"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 16204, 10 },
			},
		},
		[20031] = {
			name = LS["Enchant Weapon - Superior Striking"],
			tools = { 16207 },
			reagents = {
				{ 14344, 2 },
				{ 16203, 10 },
			},
		},
		[20032] = {
			name = LS["Enchant Weapon - Lifestealing"],
			tools = { 16207 },
			reagents = {
				{ 14344, 6 },
				{ 12808, 6 },
				{ 12803, 6 },
			},
		},
		[20033] = {
			name = LS["Enchant Weapon - Unholy Weapon"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 12808, 4 },
			},
		},
		[20034] = {
			name = LS["Enchant Weapon - Crusader"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 12811, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14344, 10 },
				{ 12811, 4 },
			},
		},
		[20035] = {
			name = LS["Enchant 2H Weapon - Major Spirit"],
			tools = { 16207 },
			reagents = {
				{ 16203, 12 },
				{ 14344, 2 },
			},
		},
		[20036] = {
			name = LS["Enchant 2H Weapon - Major Intellect"],
			tools = { 16207 },
			reagents = {
				{ 16203, 12 },
				{ 14344, 2 },
			},
		},
		[20051] = { --Runed Arcanite Rod
			item = 16207,
			reagents = {
				{ 16206 },
				{ 13926 },
				{ 16204, 10 },
				{ 16203, 4 },
				{ 14343, 4 },
				{ 14344, 2 },
			},
		},
		[21931] = {
			name = LS["Enchant Weapon - Winter's Might"],
			tools = { 11130 },
			reagents = {
				{ 11135, 3 },
				{ 11137, 3 },
				{ 11139 },
				{ 3819,  2 },
			},
		},
		[22749] = {
			name = LS["Enchant  Weapon - Spell Power"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 16203, 12 },
				{ 7078,  4 },
				{ 7080,  4 },
				{ 7082,  4 },
				{ 13926, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 2 },
				{ 14344, 15 },
				{ 16203, 12 },
				{ 7078,  14 },
				{ 7080,  14 },
				{ 7082,  14 },
				{ 13926, 2 },
			},
		},
		[22750] = {
			name = LS["Enchant  Weapon - Healing Power"],
			tools = { 16207 },
			reagents = {
				{ 14344, 4 },
				{ 16203, 8 },
				{ 12803, 6 },
				{ 7080,  6 },
				{ 12811 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 2 },
				{ 14344, 12 },
				{ 16203, 12 },
				{ 12803, 10 },
				{ 7080,  10 },
				{ 12811, 2 },
			},
		},
		[23799] = {
			name = LS["Enchant Weapon - Strength"],
			tools = { 16207 },
			reagents = {
				{ 14344, 6 },
				{ 16203, 6 },
				{ 16204, 4 },
				{ 7076,  2 },
			},
		},
		[23800] = {
			name = LS["Enchant Weapon - Agility"],
			tools = { 16207 },
			reagents = {
				{ 14344, 6 },
				{ 16203, 6 },
				{ 16204, 4 },
				{ 7082,  2 },
			},
		},
		[23801] = {
			name = LS["Enchant Bracer - Mana Regeneration"],
			tools = { 16207 },
			reagents = {
				{ 16204, 16 },
				{ 16203, 4 },
				{ 7080,  2 },
			},
		},
		[23802] = {
			name = LS["Enchant Bracer - Healing Power"],
			tools = { 16207 },
			reagents = {
				{ 14344, 2 },
				{ 16204, 20 },
				{ 16203, 4 },
				{ 12803, 6 },
			},
		},
		[23803] = {
			name = LS["Enchant Weapon - Mighty Spirit"],
			tools = { 16207 },
			reagents = {
				{ 14344, 10 },
				{ 16203, 8 },
				{ 16204, 15 },
			},
		},
		[23804] = {
			name = LS["Enchant Weapon - Mighty Intellect"],
			tools = { 16207 },
			reagents = {
				{ 14344, 15 },
				{ 16203, 12 },
				{ 16204, 20 },
			},
		},
		[25072] = {
			name = LS["Enchant Gloves - Threat"],
			tools = { 16207 },
			reagents = {
				{ 20725, 4 },
				{ 14344, 6 },
				{ 18512, 8 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 4 },
				{ 14344, 6 },
				{ 18512, 14 },
			},
		},
		[25073] = {
			name = LS["Enchant Gloves - Shadow Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 10 },
				{ 12808, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 3 },
				{ 14344, 15 },
				{ 12808, 15 },
			},
		},
		[25074] = {
			name = LS["Enchant Gloves - Frost Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 10 },
				{ 7080,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 3 },
				{ 14344, 15 },
				{ 7080,  12 },
			},
		},
		[25078] = {
			name = LS["Enchant Gloves - Fire Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 10 },
				{ 7078,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 3 },
				{ 14344, 15 },
				{ 7078,  12 },
			},
		},
		[25079] = {
			name = LS["Enchant Gloves - Healing Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 12811 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 12811, 2 },
			},
		},
		[25080] = {
			name = LS["Enchant Gloves - Superior Agility"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 7082,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 7082,  15 },
			},
		},
		[25081] = {
			name = LS["Enchant Cloak - Greater Fire Resistance"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 7078,  4 },
			},
		},
		[25082] = {
			name = LS["Enchant Cloak - Greater Nature Resistance"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 8 },
				{ 12803, 4 },
			},
		},
		[25083] = {
			name = LS["Enchant Cloak - Stealth"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 13468, 2 },
			},
		},
		[25084] = {
			name = LS["Enchant Cloak - Subtlety"],
			tools = { 16207 },
			reagents = {
				{ 20725, 4 },
				{ 14344, 6 },
				{ 11754, 2 },
			},
		},
		[25086] = {
			name = LS["Enchant Cloak - Dodge"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 8 },
				{ 12809, 8 },
			},
		},
		[25124] = { --Minor Wizard Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 6218 },
			item = 20744,
			reagents = {
				{ 10940, 2 },
				{ 17034 },
				{ 3371 },
			},
		},
		[25125] = { --Minor Mana Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 6339 },
			item = 20745,
			reagents = {
				{ 11083, 3 },
				{ 17034, 2 },
				{ 3372 },
			},
		},
		[25126] = { --Lesser Wizard Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 11130 },
			item = 20746,
			reagents = {
				{ 11137, 3 },
				{ 17035, 2 },
				{ 3372 },
			},
		},
		[25127] = { --Lesser Mana Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 11145 },
			item = 20747,
			reagents = {
				{ 11176, 3 },
				{ 8831,  2 },
				{ 8925 },
			},
		},
		[25128] = { --Wizard Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 11145 },
			item = 20750,
			reagents = {
				{ 16204, 3 },
				{ 4625,  2 },
				{ 8925 },
			},
		},
		[25129] = { --Brilliant Wizard Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 16207 },
			item = 20749,
			reagents = {
				{ 14344, 2 },
				{ 4625,  3 },
				{ 18256 },
			},
		},
		[25130] = { --Brilliant Mana Oil
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 16207 },
			item = 20748,
			reagents = {
				{ 14344, 2 },
				{ 8831,  3 },
				{ 18256 },
			},
		},
		[27837] = {
			name = LS["Enchant 2H Weapon - Agility"],
			tools = { 16207 },
			reagents = {
				{ 14344, 10 },
				{ 16203, 6 },
				{ 16204, 14 },
				{ 7082,  4 },
			},
		},
		[34347] = {
			name = LS["Enchant Gloves - Living Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 15 },
				{ 12803, 12 },
			},
		},
		[34350] = {
			name = LS["Enchant Gloves - Arcane Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 14344, 15 },
				{ 12363 },
				{ 16203, 8 },
			},
		},
		[34628] = {
			name = LS["Enchant 2H Weapon - Savagery"],
			tools = { 16207 },
			reagents = {
				{ 16204, 40 },
				{ 16203, 10 },
				{ 14344, 4 },
				{ 8146,  20 },
				{ 5631,  5 },
			},
		},
		[34632] = {
			name = LS["Enchant Weapon - Spellblasting"],
			tools = { 16207 },
			reagents = {
				{ 16204, 20 },
				{ 16203, 5 },
				{ 14343, 5 },
				{ 12804, 5 },
			},
		},
		[45071] = {
			name = LS["Enchant 2H Weapon - Minor Intellect"],
			tools = { 6218 },
			reagents = {
				{ 10940, 4 },
				{ 10939, 2 },
			},
		},
		[46086] = {
			name = LS["Enchant Gloves - Major Strength"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 4 },
				{ 7076,  4 },
				{ 7077,  4 },
			},
		},
		[46601] = {
			name = LS["Enchant Gloves - Arcane Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 10 },
				{ 16203, 4 },
			},
		},
		[46602] = {
			name = LS["Enchant Gloves - Nature Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 10 },
				{ 7082,  2 },
				{ 7076,  2 },
			},
		},
		[46603] = {
			name = LS["Enchant Gloves - Holy Power"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 10 },
				{ 12811, 4 },
			},
		},
		[57028] = {
			name = LS["Enchant Bracer - Spell Power"],
			tools = { 16207 },
			reagents = {
				{ 14344, 2 },
				{ 16204, 10 },
				{ 7076,  3 },
				{ 7082,  3 },
			},
		},
		[57030] = {
			name = LS["Enchant Bracer - Greater Agility"],
			tools = { 11145 },
			reagents = {
				{ 14344, 3 },
				{ 16203 },
				{ 7082,  2 },
				{ 7076,  2 },
			},
		},
		[57032] = {
			name = LS["Enchant Bracer - Spell Penetration"],
			tools = { 11145 },
			item = 3007,
			reagents = {
				{ 14344, 2 },
				{ 16203, 2 },
				{ 7082 },
				{ 7076 },
				{ 7078 },
				{ 7080 },
				{ 12803 },
				{ 12808 },
			},
		},
		[57034] = {
			name = LS["Enchant Bracer - Greater Spell Penetration"],
			tools = { 11145 },
			item = 3008,
			reagents = {
				{ 20725, 2 },
				{ 16203 },
				{ 7082,  2 },
				{ 7076,  2 },
				{ 7078,  2 },
				{ 7080,  2 },
				{ 12803, 2 },
				{ 12808, 2 },
			},
		},
		[57036] = {
			name = LS["Enchant Bracer - Superior Spell Penetration"],
			tools = { 11145 },
			item = 3009,
			reagents = {
				{ 20725, 3 },
				{ 16203, 8 },
				{ 7082,  4 },
				{ 7076,  4 },
				{ 7078,  4 },
				{ 7080,  4 },
				{ 12803, 4 },
				{ 12808, 4 },
			},
		},
		[57117] = {
			name = LS["Enchant Cloak - Greater Arcane Resistance"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 6 },
				{ 16204, 20 },
			},
		},
		[57119] = {
			name = LS["Enchant Chest - Mighty Mana"],
			tools = { 16207 },
			reagents = {
				{ 14344, 6 },
				{ 16204, 40 },
			},
		},
		[57127] = {
			name = LS["Enchant Boots - Superior Stamina"],
			tools = { 16207 },
			reagents = {
				{ 16203, 6 },
				{ 8846,  2 },
			},
		},
		[57142] = {
			name = LS["Enchant Boots - Greater Spirit"],
			tools = { 16207 },
			reagents = {
				{ 16203, 5 },
			},
		},
		[57144] = {
			name = LS["Enchant Bracer - Greater Deflection"],
			tools = { 16207 },
			reagents = {
				{ 14344 },
				{ 61673, 2 },
				{ 7076,  2 },
				{ 16203, 4 },
			},
		},
		[57146] = {
			name = LS["Enchant Bracer - Vampirism"],
			tools = { 11130 },
			reagents = {
				{ 11135 },
				{ 5637, 2 },
			},
		},
		[57148] = {
			name = LS["Enchant Boots - Vampirism"],
			tools = { 16207 },
			reagents = {
				{ 19933, 8 },
				{ 12808, 4 },
				{ 14344, 4 },
				{ 16204, 10 },
			},
		},
		[44] = {
			name = LS["Enchant Bracer - Agility"],
			tools = { 11130 },
			reagents = {
				{ 11134 },
				{ 7067 },
			},
		},
		[48] = {
			name = LS["Enchant Boots - Lesser Intellect"],
			tools = { 11130 },
			reagents = {
				{ 11083, 3 },
				{ 11137 },
			},
		},
		[36942] = {
			name = LS["Enchant Weapon - Rift Tear"],
			tools = { 16207 },
			reagents = {
				{ 16204, 30 },
				{ 42001, 4 },
				{ 14343, 8 },
				{ 20725 },
			},
		},
		[49016] = {
			name = LS["Enchant Cloak - Agility"],
			tools = { 16207 },
			reagents = {
				{ 20725, 2 },
				{ 14344, 6 },
				{ 7082,  2 },
			},
		},
		[49018] = {
			name = LS["Enchant Cloak - Greater Shadow Resistance"],
			tools = { 16207 },
			reagents = {
				{ 20725, 3 },
				{ 16204, 8 },
				{ 20520, 2 },
			},
		},
		[49020] = {
			name = LS["Enchant 2H Weapon - Nature Damage"],
			tools = { 16207 },
			reagents = {
				{ 16203, 8 },
				{ 14344, 2 },
				{ 12803, 6 },
			},
		},
		[49022] = {
			name = LS["Enchant 2H Weapon - Shadow Damage"],
			tools = { 16207 },
			reagents = {
				{ 16203, 8 },
				{ 14344, 2 },
				{ 12808, 6 },
			},
		},
		[56543] = {
			name = LS["Enchant Boots - Major Intellect"],
			tools = { 11145 },
			reagents = {
				{ 16204, 15 },
				{ 16203, 4 },
				{ 14344, 2 },
				{ 20725 },
			},
		},
	},
	craftspells = {
		[818] = {
			name = LS["Basic Campfire"],
			icon = "Spell_Fire_Fire",
			text = LS["Builds a campfire that increases the spirits of those nearby by 4 and allows cooking."],
			tools = { 4471 },
			reagents = {
				{ 4470 },
			},
		},
		[2149] = { --Handstitched Leather Boots
			item = 2302,
			reagents = {
				{ 2318, 2 },
				{ 2320 },
			},
		},
		[2152] = { --Light Armor Kit
			item = 2304,
			reagents = {
				{ 2318 },
			},
		},
		[2153] = { --Handstitched Leather Pants
			item = 2303,
			reagents = {
				{ 2318, 4 },
				{ 2320 },
			},
		},
		[2156] = { --Light Winter Cloak
			item = 2305,
			reagents = {
				{ 2318, 8 },
				{ 2320, 2 },
			},
		},
		[2157] = { --Light Winter Boots
			item = 2306,
			reagents = {
				{ 2318, 6 },
				{ 2320, 2 },
			},
		},
		[2158] = { --Fine Leather Boots
			item = 2307,
			reagents = {
				{ 2318, 7 },
				{ 2320, 2 },
			},
		},
		[2159] = { --Fine Leather Cloak
			item = 2308,
			reagents = {
				{ 2318, 10 },
				{ 2321, 2 },
			},
		},
		[2160] = { --Embossed Leather Vest
			item = 2300,
			reagents = {
				{ 2318, 8 },
				{ 2320, 4 },
			},
		},
		[2161] = { --Embossed Leather Boots
			item = 2309,
			reagents = {
				{ 2318, 8 },
				{ 2320, 5 },
			},
		},
		[2162] = { --Embossed Leather Cloak
			item = 2310,
			reagents = {
				{ 2318, 5 },
				{ 2320, 2 },
			},
		},
		[2163] = { --White Leather Jerkin
			item = 2311,
			reagents = {
				{ 2318, 8 },
				{ 2320, 2 },
				{ 2324 },
			},
		},
		[2164] = { --Fine Leather Gloves
			item = 2312,
			reagents = {
				{ 4231 },
				{ 2318, 4 },
				{ 2320, 2 },
			},
		},
		[2165] = { --Medium Armor Kit
			item = 2313,
			reagents = {
				{ 2319, 4 },
				{ 2320 },
			},
		},
		[2166] = { --Toughened Leather Armor
			item = 2314,
			reagents = {
				{ 2319, 10 },
				{ 4231, 2 },
				{ 2321, 2 },
			},
		},
		[2167] = { --Dark Leather Boots
			item = 2315,
			reagents = {
				{ 2319, 4 },
				{ 2321, 2 },
				{ 4340 },
			},
		},
		[2168] = { --Dark Leather Cloak
			item = 2316,
			reagents = {
				{ 2319, 8 },
				{ 2321 },
				{ 4340 },
			},
		},
		[2169] = { --Dark Leather Tunic
			item = 2317,
			reagents = {
				{ 2319, 6 },
				{ 2321 },
				{ 4340 },
			},
		},
		[2329] = { --Elixir of Lion's Strength
			item = 2454,
			reagents = {
				{ 2449 },
				{ 765 },
				{ 3371 },
			},
		},
		[2330] = { --Minor Healing Potion
			item = 118,
			reagents = {
				{ 2447 },
				{ 765 },
				{ 3371 },
			},
		},
		[2331] = { --Minor Mana Potion
			item = 2455,
			reagents = {
				{ 785 },
				{ 765 },
				{ 3371 },
			},
		},
		[2332] = { --Minor Rejuvenation Potion
			item = 2456,
			reagents = {
				{ 785, 2 },
				{ 2447 },
				{ 3371 },
			},
		},
		[2333] = { --Elixir of Lesser Agility
			item = 3390,
			reagents = {
				{ 3355 },
				{ 2452 },
				{ 3372 },
			},
		},
		[2334] = { --Elixir of Minor Fortitude
			item = 2458,
			reagents = {
				{ 2449, 2 },
				{ 2447 },
				{ 3371 },
			},
		},
		[2335] = { --Swiftness Potion
			item = 2459,
			reagents = {
				{ 2452 },
				{ 2450 },
				{ 3371 },
			},
		},
		[2336] = { --Elixir of Tongues
			item = 2460,
			reagents = {
				{ 2449, 2 },
				{ 785,  2 },
				{ 3371 },
			},
		},
		[2337] = { --Lesser Healing Potion
			item = 858,
			reagents = {
				{ 118 },
				{ 2450 },
			},
		},
		[2385] = { --Brown Linen Vest
			item = 2568,
			reagents = {
				{ 2996 },
				{ 2320 },
			},
		},
		[2386] = { --Linen Boots
			item = 2569,
			reagents = {
				{ 2996, 3 },
				{ 2320 },
				{ 2318 },
			},
		},
		[2387] = { --Linen Cloak
			item = 2570,
			reagents = {
				{ 2996 },
				{ 2320 },
			},
		},
		[2389] = { --Red Linen Robe
			item = 2572,
			reagents = {
				{ 2996, 3 },
				{ 2320, 2 },
				{ 2604, 2 },
			},
		},
		[2392] = { --Red Linen Shirt
			item = 2575,
			reagents = {
				{ 2996, 2 },
				{ 2320 },
				{ 2604 },
			},
		},
		[2393] = { --White Linen Shirt
			item = 2576,
			reagents = {
				{ 2996 },
				{ 2320 },
				{ 2324 },
			},
		},
		[2394] = { --Blue Linen Shirt
			item = 2577,
			reagents = {
				{ 2996, 2 },
				{ 2320 },
				{ 6260 },
			},
		},
		[2395] = { --Barbaric Linen Vest
			item = 2578,
			reagents = {
				{ 2996, 4 },
				{ 2318 },
				{ 2321 },
			},
		},
		[2396] = { --Green Linen Shirt
			item = 2579,
			reagents = {
				{ 2996, 3 },
				{ 2321 },
				{ 2605 },
			},
		},
		[2397] = { --Reinforced Linen Cape
			item = 2580,
			reagents = {
				{ 2996, 2 },
				{ 2320, 3 },
			},
		},
		[2399] = { --Green Woolen Vest
			item = 2582,
			reagents = {
				{ 2997, 2 },
				{ 2321, 2 },
				{ 2605 },
			},
		},
		[2401] = { --Woolen Boots
			item = 2583,
			reagents = {
				{ 2997, 4 },
				{ 2321, 2 },
				{ 2318, 2 },
			},
		},
		[2402] = { --Woolen Cape
			item = 2584,
			reagents = {
				{ 2997 },
				{ 2321 },
			},
		},
		[2403] = { --Gray Woolen Robe
			item = 2585,
			reagents = {
				{ 2997, 4 },
				{ 2321, 3 },
				{ 4340 },
			},
		},
		[2406] = { --Gray Woolen Shirt
			item = 2587,
			reagents = {
				{ 2997, 2 },
				{ 2321 },
				{ 4340 },
			},
		},
		[2538] = { --Charred Wolf Meat
			requires = L["Cooking Fire"],
			item = 2679,
			reagents = {
				{ 2672 },
			},
		},
		[2539] = { --Spiced Wolf Meat
			requires = L["Cooking Fire"],
			item = 2680,
			reagents = {
				{ 2672 },
				{ 2678 },
			},
		},
		[2540] = { --Roasted Boar Meat
			requires = L["Cooking Fire"],
			item = 2681,
			reagents = {
				{ 769 },
			},
		},
		[2541] = { --Coyote Steak
			requires = L["Cooking Fire"],
			item = 2684,
			reagents = {
				{ 2673 },
			},
		},
		[2542] = { --Goretusk Liver Pie
			requires = L["Cooking Fire"],
			item = 724,
			reagents = {
				{ 723 },
				{ 2678 },
			},
		},
		[2543] = { --Westfall Stew
			requires = L["Cooking Fire"],
			item = 733,
			reagents = {
				{ 729 },
				{ 730 },
				{ 731 },
			},
		},
		[2544] = { --Crab Cake
			requires = L["Cooking Fire"],
			item = 2683,
			reagents = {
				{ 2674 },
				{ 2678 },
			},
		},
		[2545] = { --Cooked Crab Claw
			requires = L["Cooking Fire"],
			item = 2682,
			reagents = {
				{ 2675 },
				{ 2678 },
			},
		},
		[2546] = { --Dry Pork Ribs
			requires = L["Cooking Fire"],
			item = 2687,
			reagents = {
				{ 2677 },
				{ 2678 },
			},
		},
		[2547] = { --Redridge Goulash
			requires = L["Cooking Fire"],
			item = 1082,
			reagents = {
				{ 1081 },
				{ 1080 },
			},
		},
		[2548] = { --Succulent Pork Ribs
			requires = L["Cooking Fire"],
			item = 2685,
			reagents = {
				{ 2677, 2 },
				{ 2692 },
			},
		},
		[2549] = { --Seasoned Wolf Kabob
			requires = L["Cooking Fire"],
			item = 1017,
			reagents = {
				{ 1015, 2 },
				{ 2665 },
			},
		},
		[2657] = { --Smelt Copper
			name = LS["Smelting: Smelt Copper"],
			requires = L["Forge"],
			item = 2840,
			reagents = {
				{ 2770 },
			},
		},
		[2658] = { --Smelt Silver
			name = LS["Smelting: Smelt Silver"],
			requires = L["Forge"],
			item = 2842,
			reagents = {
				{ 2775 },
			},
		},
		[2659] = { --Smelt Bronze
			name = LS["Smelting: Smelt Bronze"],
			requires = L["Forge"],
			item = 2841,
			reagents = {
				{ 2840 },
				{ 3576 },
			},
		},
		[2660] = { --Rough Sharpening Stone
			item = 2862,
			reagents = {
				{ 2835 },
			},
		},
		[2661] = { --Copper Chain Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2851,
			reagents = {
				{ 2840, 6 },
			},
		},
		[2662] = { --Copper Chain Pants
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2852,
			reagents = {
				{ 2840, 4 },
			},
		},
		[2663] = { --Copper Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2853,
			reagents = {
				{ 2840, 2 },
			},
		},
		[2664] = { --Runed Copper Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2854,
			reagents = {
				{ 2840, 10 },
				{ 3470, 3 },
			},
		},
		[2665] = { --Coarse Sharpening Stone
			item = 2863,
			reagents = {
				{ 2836 },
			},
		},
		[2666] = { --Runed Copper Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2857,
			reagents = {
				{ 2840, 10 },
			},
		},
		[2667] = { --Runed Copper Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2864,
			reagents = {
				{ 2840, 12 },
				{ 1210 },
				{ 3470, 2 },
			},
		},
		[2668] = { --Rough Bronze Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2865,
			reagents = {
				{ 2841, 6 },
			},
		},
		[2670] = { --Rough Bronze Cuirass
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2866,
			reagents = {
				{ 2841, 7 },
			},
		},
		[2671] = { --Rough Bronze Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2867,
			reagents = {
				{ 2841, 4 },
			},
		},
		[2672] = { --Patterned Bronze Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2868,
			reagents = {
				{ 2841, 5 },
				{ 3478, 2 },
			},
		},
		[2673] = { --Silvered Bronze Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2869,
			reagents = {
				{ 2841, 10 },
				{ 2842, 2 },
				{ 3478, 2 },
				{ 1705 },
			},
		},
		[2674] = { --Heavy Sharpening Stone
			item = 2871,
			reagents = {
				{ 2838 },
			},
		},
		[2675] = { --Shining Silver Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2870,
			reagents = {
				{ 2841, 20 },
				{ 1206, 2 },
				{ 1705, 2 },
				{ 5500, 2 },
				{ 2842, 4 },
			},
		},
		[2737] = { --Copper Mace
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2844,
			reagents = {
				{ 2840, 6 },
				{ 2880 },
				{ 2589, 2 },
			},
		},
		[2738] = { --Copper Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2845,
			reagents = {
				{ 2840, 6 },
				{ 2880 },
				{ 2589, 2 },
			},
		},
		[2739] = { --Copper Shortsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2847,
			reagents = {
				{ 2840, 6 },
				{ 2880 },
				{ 2589, 2 },
			},
		},
		[2740] = { --Bronze Mace
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2848,
			reagents = {
				{ 2841, 6 },
				{ 2880, 4 },
				{ 2319 },
			},
		},
		[2741] = { --Bronze Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2849,
			reagents = {
				{ 2841, 7 },
				{ 2880, 4 },
				{ 2319 },
			},
		},
		[2742] = { --Bronze Shortsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2850,
			reagents = {
				{ 2841, 5 },
				{ 2880, 4 },
				{ 2319, 2 },
			},
		},
		[2795] = { --Beer Basted Boar Ribs
			requires = L["Cooking Fire"],
			item = 2888,
			reagents = {
				{ 2886 },
				{ 2894 },
			},
		},
		[2835] = {
			item = 2892,
			reagents = {
				{ 5173 },
				{ 3372 },
			},
		},
		[2837] = {
			item = 2893,
			reagents = {
				{ 5173, 2 },
				{ 3372 },
			},
		},
		[2881] = { --Light Leather
			item = 2318,
			reagents = {
				{ 2934, 3 },
			},
		},
		[2963] = { --Bolt of Linen Cloth
			item = 2996,
			reagents = {
				{ 2589, 2 },
			},
		},
		[2964] = { --Bolt of Woolen Cloth
			item = 2997,
			reagents = {
				{ 2592, 3 },
			},
		},
		[3115] = { --Rough Weightstone
			item = 3239,
			reagents = {
				{ 2835 },
				{ 2589 },
			},
		},
		[3116] = { --Coarse Weightstone
			item = 3240,
			reagents = {
				{ 2836 },
				{ 2592 },
			},
		},
		[3117] = { --Heavy Weightstone
			item = 3241,
			reagents = {
				{ 2838 },
				{ 2592 },
			},
		},
		[3170] = { --Weak Troll's Blood Potion
			item = 3382,
			reagents = {
				{ 2447 },
				{ 2449, 2 },
				{ 3371 },
			},
		},
		[3171] = { --Elixir of Wisdom
			item = 3383,
			reagents = {
				{ 785 },
				{ 2450, 2 },
				{ 3371 },
			},
		},
		[3172] = { --Minor Magic Resistance Potion
			item = 3384,
			reagents = {
				{ 785, 3 },
				{ 3355 },
				{ 3371 },
			},
		},
		[3173] = { --Lesser Mana Potion
			item = 3385,
			reagents = {
				{ 785 },
				{ 3820 },
				{ 3371 },
			},
		},
		[3174] = { --Elixir of Poison Resistance
			item = 3386,
			reagents = {
				{ 1288 },
				{ 2453 },
				{ 3372 },
			},
		},
		[3175] = { --Limited Invulnerability Potion
			item = 3387,
			reagents = {
				{ 8839, 2 },
				{ 8845 },
				{ 8925 },
			},
		},
		[3176] = { --Strong Troll's Blood Potion
			item = 3388,
			reagents = {
				{ 2453, 2 },
				{ 2450, 2 },
				{ 3372 },
			},
		},
		[3177] = { --Elixir of Defense
			item = 3389,
			reagents = {
				{ 3355 },
				{ 3820 },
				{ 3372 },
			},
		},
		[3188] = { --Elixir of Ogre's Strength
			item = 3391,
			reagents = {
				{ 2449 },
				{ 3356 },
				{ 3372 },
			},
		},
		[3230] = { --Elixir of Minor Agility
			item = 2457,
			reagents = {
				{ 2452 },
				{ 765 },
				{ 3371 },
			},
		},
		[3275] = { --Linen Bandage
			item = 1251,
			reagents = {
				{ 2589 },
			},
		},
		[3276] = { --Heavy Linen Bandage
			item = 2581,
			reagents = {
				{ 2589, 2 },
			},
		},
		[3277] = { --Wool Bandage
			item = 3530,
			reagents = {
				{ 2592 },
			},
		},
		[3278] = { --Heavy Wool Bandage
			item = 3531,
			reagents = {
				{ 2592, 2 },
			},
		},
		[3292] = { --Heavy Copper Broadsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3487,
			reagents = {
				{ 2840, 14 },
				{ 2880, 2 },
				{ 818,  2 },
				{ 2319, 2 },
			},
		},
		[3293] = { --Copper Battle Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3488,
			reagents = {
				{ 2840, 12 },
				{ 2880, 2 },
				{ 774,  2 },
				{ 3470, 2 },
				{ 2318, 2 },
			},
		},
		[3294] = { --Thick War Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3489,
			reagents = {
				{ 2840, 10 },
				{ 2880, 2 },
				{ 2842, 2 },
				{ 3470, 2 },
				{ 2318, 2 },
			},
		},
		[3295] = { --Deadly Bronze Poniard
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3490,
			reagents = {
				{ 2841, 4 },
				{ 3466 },
				{ 2459 },
				{ 1210, 2 },
				{ 3478, 2 },
				{ 2319, 2 },
			},
		},
		[3296] = { --Heavy Bronze Mace
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3491,
			reagents = {
				{ 2841, 8 },
				{ 3466 },
				{ 1206 },
				{ 1210 },
				{ 3478, 2 },
				{ 2319, 2 },
			},
		},
		[3297] = { --Mighty Iron Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3492,
			reagents = {
				{ 3575, 6 },
				{ 3466, 2 },
				{ 3391 },
				{ 1705, 2 },
				{ 3478, 2 },
				{ 2319, 2 },
			},
		},
		[3304] = { --Smelt Tin
			name = LS["Smelting: Smelt Tin"],
			requires = L["Forge"],
			item = 3576,
			reagents = {
				{ 2771 },
			},
		},
		[3307] = { --Smelt Iron
			name = LS["Smelting: Smelt Iron"],
			requires = L["Forge"],
			item = 3575,
			reagents = {
				{ 2772 },
			},
		},
		[3308] = { --Smelt Gold
			name = LS["Smelting: Smelt Gold"],
			requires = L["Forge"],
			item = 3577,
			reagents = {
				{ 2776 },
			},
		},
		[3319] = { --Copper Chain Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3469,
			reagents = {
				{ 2840, 8 },
			},
		},
		[3320] = { --Rough Grinding Stone
			item = 3470,
			reagents = {
				{ 2835, 2 },
			},
		},
		[3321] = { --Copper Chain Vest
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3471,
			reagents = {
				{ 2840, 8 },
				{ 774 },
				{ 3470, 2 },
			},
		},
		[3323] = { --Runed Copper Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3472,
			reagents = {
				{ 2840, 8 },
				{ 3470, 2 },
			},
		},
		[3324] = { --Runed Copper Pants
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3473,
			reagents = {
				{ 2840, 8 },
				{ 2321, 2 },
				{ 3470, 3 },
			},
		},
		[3325] = { --Gemmed Copper Gauntlets
			requires = L["Anvil"],
			extra = Colors.GREEN .. L["<Random enchantment>"],
			tools = { 5956 },
			item = 3474,
			reagents = {
				{ 2840, 8 },
				{ 818 },
				{ 774 },
			},
		},
		[3326] = { --Coarse Grinding Stone
			item = 3478,
			reagents = {
				{ 2836, 2 },
			},
		},
		[3328] = { --Rough Bronze Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3480,
			reagents = {
				{ 2841, 5 },
				{ 1210 },
				{ 3478 },
			},
		},
		[3330] = { --Silvered Bronze Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3481,
			reagents = {
				{ 2841, 8 },
				{ 2842, 2 },
				{ 3478, 2 },
			},
		},
		[3331] = { --Silvered Bronze Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3482,
			reagents = {
				{ 2841, 6 },
				{ 2842 },
				{ 3478, 2 },
			},
		},
		[3333] = { --Silvered Bronze Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3483,
			reagents = {
				{ 2841, 8 },
				{ 2842 },
				{ 3478, 2 },
			},
		},
		[3334] = { --Green Iron Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3484,
			reagents = {
				{ 3575, 4 },
				{ 1705, 2 },
				{ 3478, 2 },
				{ 2605 },
			},
		},
		[3336] = { --Green Iron Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3485,
			reagents = {
				{ 3575, 4 },
				{ 5498, 2 },
				{ 3478, 2 },
				{ 2605 },
			},
		},
		[3337] = { --Heavy Grinding Stone
			item = 3486,
			reagents = {
				{ 2838, 3 },
			},
		},
		[3370] = { --Crocolisk Steak
			requires = L["Cooking Fire"],
			item = 3662,
			reagents = {
				{ 2924 },
				{ 2678 },
			},
		},
		[3371] = { --Blood Sausage
			requires = L["Cooking Fire"],
			item = 3220,
			reagents = {
				{ 3173 },
				{ 3172 },
				{ 3174 },
			},
		},
		[3372] = { --Murloc Fin Soup
			requires = L["Cooking Fire"],
			item = 3663,
			reagents = {
				{ 1468, 2 },
				{ 2692 },
			},
		},
		[3373] = { --Crocolisk Gumbo
			requires = L["Cooking Fire"],
			item = 3664,
			reagents = {
				{ 3667 },
				{ 2692 },
			},
		},
		[3376] = { --Curiously Tasty Omelet
			requires = L["Cooking Fire"],
			item = 3665,
			reagents = {
				{ 3685 },
				{ 2692 },
			},
		},
		[3377] = { --Gooey Spider Cake
			requires = L["Cooking Fire"],
			item = 3666,
			reagents = {
				{ 2251, 2 },
				{ 2692 },
			},
		},
		[3397] = { --Big Bear Steak
			requires = L["Cooking Fire"],
			item = 3726,
			reagents = {
				{ 3730 },
				{ 2692 },
			},
		},
		[3398] = { --Hot Lion Chops
			requires = L["Cooking Fire"],
			item = 3727,
			reagents = {
				{ 3731 },
				{ 2692 },
			},
		},
		[3399] = { --Tasty Lion Steak
			requires = L["Cooking Fire"],
			item = 3728,
			reagents = {
				{ 3731, 2 },
				{ 3713 },
			},
		},
		[3400] = { --Soothing Turtle Bisque
			requires = L["Cooking Fire"],
			item = 3729,
			reagents = {
				{ 3712 },
				{ 3713 },
			},
		},
		[3420] = {
			item = 3775,
			reagents = {
				{ 2930 },
				{ 3371 },
			},
		},
		[3421] = {
			item = 3776,
			reagents = {
				{ 8923, 3 },
				{ 8925 },
			},
		},
		[3447] = { --Healing Potion
			item = 929,
			reagents = {
				{ 2453 },
				{ 2450 },
				{ 3372 },
			},
		},
		[3448] = { --Lesser Invisibility Potion
			item = 3823,
			reagents = {
				{ 3818 },
				{ 3355 },
				{ 3372 },
			},
		},
		[3449] = { --Shadow Oil
			item = 3824,
			reagents = {
				{ 3818, 4 },
				{ 3369, 4 },
				{ 3372 },
			},
			reagents_TURTLE1 = {
				{ 3818, 4 },
				{ 3369, 2 },
				{ 3372 },
			},
		},
		[3450] = { --Elixir of Fortitude
			item = 3825,
			reagents = {
				{ 3355 },
				{ 3821 },
				{ 3372 },
			},
		},
		[3451] = { --Mighty Troll's Blood Potion
			item = 3826,
			reagents = {
				{ 3357 },
				{ 2453 },
				{ 3372 },
			},
		},
		[3452] = { --Mana Potion
			item = 3827,
			reagents = {
				{ 3820 },
				{ 3356 },
				{ 3372 },
			},
		},
		[3453] = { --Elixir of Detect Lesser Invisibility
			item = 3828,
			reagents = {
				{ 3358 },
				{ 3818 },
				{ 3372 },
			},
		},
		[3454] = { --Frost Oil
			item = 3829,
			reagents = {
				{ 3358, 4 },
				{ 3819, 2 },
				{ 3372 },
			},
		},
		[3491] = { --Big Bronze Knife
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3848,
			reagents = {
				{ 2841, 6 },
				{ 2880, 4 },
				{ 3470, 2 },
				{ 818 },
				{ 2319 },
			},
		},
		[3492] = { --Hardened Iron Shortsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3849,
			reagents = {
				{ 3575, 6 },
				{ 3466, 2 },
				{ 3486 },
				{ 1705, 2 },
				{ 4234, 3 },
			},
		},
		[3493] = { --Jade Serpentblade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3850,
			reagents = {
				{ 3575, 8 },
				{ 3466, 2 },
				{ 3486, 2 },
				{ 1529, 2 },
				{ 4234, 3 },
			},
		},
		[3494] = { --Solid Iron Maul
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3851,
			reagents = {
				{ 3575, 8 },
				{ 3466, 2 },
				{ 3486 },
				{ 2842, 4 },
				{ 4234, 2 },
			},
		},
		[3495] = { --Golden Iron Destroyer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3852,
			reagents = {
				{ 3575, 10 },
				{ 3577, 4 },
				{ 1705, 2 },
				{ 3466, 2 },
				{ 4234, 2 },
				{ 3486, 2 },
			},
		},
		[3496] = { --Moonsteel Broadsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3853,
			reagents = {
				{ 3859, 8 },
				{ 3466, 2 },
				{ 3486, 2 },
				{ 1705, 3 },
				{ 4234, 3 },
			},
		},
		[3497] = { --Frost Tiger Blade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3854,
			reagents = {
				{ 3859, 8 },
				{ 3466, 2 },
				{ 3486, 2 },
				{ 1529, 2 },
				{ 3829 },
				{ 4234, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 3859, 12 },
				{ 3466, 4 },
				{ 3486, 8 },
				{ 1529, 4 },
				{ 3829, 2 },
				{ 4234, 5 },
			},
		},
		[3498] = { --Massive Iron Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3855,
			reagents = {
				{ 3575, 14 },
				{ 3466, 2 },
				{ 3486, 2 },
				{ 3577, 4 },
				{ 4234, 2 },
			},
		},
		[3500] = { --Shadow Crescent Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3856,
			reagents = {
				{ 3859, 10 },
				{ 3466, 2 },
				{ 3486, 3 },
				{ 3864, 2 },
				{ 3824 },
				{ 4234, 3 },
			},
		},
		[3501] = { --Green Iron Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3835,
			reagents = {
				{ 3575, 6 },
				{ 2605 },
			},
		},
		[3502] = { --Green Iron Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3836,
			reagents = {
				{ 3575, 12 },
				{ 3864 },
				{ 2605 },
			},
		},
		[3503] = { --Golden Scale Coif
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3837,
			reagents = {
				{ 3859, 8 },
				{ 3577, 2 },
				{ 3486, 2 },
			},
		},
		[3504] = { --Green Iron Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3840,
			reagents = {
				{ 3575, 7 },
				{ 3486 },
				{ 2605 },
			},
		},
		[3505] = { --Golden Scale Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3841,
			reagents = {
				{ 3859, 6 },
				{ 3577, 2 },
				{ 3486 },
			},
		},
		[3506] = { --Green Iron Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3842,
			reagents = {
				{ 3575, 8 },
				{ 3486 },
				{ 2605 },
			},
		},
		[3507] = { --Golden Scale Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3843,
			reagents = {
				{ 3575, 10 },
				{ 3577, 2 },
				{ 3486 },
			},
		},
		[3508] = { --Green Iron Hauberk
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3844,
			reagents = {
				{ 3575, 20 },
				{ 3486, 4 },
				{ 1529, 2 },
				{ 1206, 2 },
				{ 4255 },
			},
		},
		[3511] = { --Golden Scale Cuirass
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3845,
			reagents = {
				{ 3859, 12 },
				{ 3577, 2 },
				{ 3486, 4 },
				{ 1529, 2 },
			},
		},
		[3513] = { --Polished Steel Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3846,
			reagents = {
				{ 3859, 8 },
				{ 3864 },
				{ 1705 },
				{ 3486, 2 },
			},
		},
		[3515] = { --Golden Scale Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 3847,
			reagents = {
				{ 3859, 10 },
				{ 3577, 4 },
				{ 3486, 4 },
				{ 3864 },
			},
		},
		[3569] = { --Smelt Steel
			name = LS["Smelting: Smelt Steel"],
			requires = L["Forge"],
			item = 3859,
			reagents = {
				{ 3575 },
				{ 3857 },
			},
		},
		[3753] = { --Handstitched Leather Belt
			item = 4237,
			reagents = {
				{ 2318, 6 },
				{ 2320 },
			},
		},
		[3755] = { --Linen Bag
			item = 4238,
			reagents = {
				{ 2996, 3 },
				{ 2320, 3 },
			},
		},
		[3756] = { --Embossed Leather Gloves
			item = 4239,
			reagents = {
				{ 2318, 3 },
				{ 2320, 2 },
			},
		},
		[3757] = { --Woolen Bag
			item = 4240,
			reagents = {
				{ 2997, 3 },
				{ 2321 },
			},
		},
		[3758] = { --Green Woolen Bag
			item = 4241,
			reagents = {
				{ 2997, 4 },
				{ 2605 },
				{ 2321 },
			},
		},
		[3759] = { --Embossed Leather Pants
			item = 4242,
			reagents = {
				{ 4231 },
				{ 2318, 6 },
				{ 2320, 2 },
			},
		},
		[3760] = { --Hillman's Cloak
			item = 3719,
			reagents = {
				{ 4234, 5 },
				{ 2321, 2 },
			},
		},
		[3761] = { --Fine Leather Tunic
			item = 4243,
			reagents = {
				{ 4231, 3 },
				{ 2318, 6 },
				{ 2320, 4 },
			},
		},
		[3762] = { --Hillman's Leather Vest
			item = 4244,
			reagents = {
				{ 4243 },
				{ 4231, 2 },
				{ 2320, 2 },
			},
		},
		[3763] = { --Fine Leather Belt
			item = 4246,
			reagents = {
				{ 2318, 6 },
				{ 2320, 2 },
			},
		},
		[3764] = { --Hillman's Leather Gloves
			item = 4247,
			reagents = {
				{ 2319, 14 },
				{ 2321, 4 },
			},
		},
		[3765] = { --Dark Leather Gloves
			item = 4248,
			reagents = {
				{ 2312 },
				{ 4233 },
				{ 2321 },
				{ 4340 },
			},
		},
		[3766] = { --Dark Leather Belt
			item = 4249,
			reagents = {
				{ 4246 },
				{ 4233 },
				{ 2321, 2 },
				{ 4340 },
			},
		},
		[3767] = { --Hillman's Belt
			item = 4250,
			reagents = {
				{ 2319, 8 },
				{ 3383 },
				{ 2321, 2 },
			},
		},
		[3768] = { --Hillman's Shoulders
			item = 4251,
			reagents = {
				{ 4233 },
				{ 2319, 4 },
				{ 2321 },
			},
		},
		[3769] = { --Dark Leather Shoulders
			item = 4252,
			reagents = {
				{ 2319, 12 },
				{ 3390 },
				{ 4340 },
				{ 2321, 2 },
			},
		},
		[3770] = { --Toughened Leather Gloves
			item = 4253,
			reagents = {
				{ 2319, 4 },
				{ 4233, 2 },
				{ 3389, 2 },
				{ 3182, 2 },
				{ 2321, 2 },
			},
		},
		[3771] = { --Barbaric Gloves
			item = 4254,
			reagents = {
				{ 4234, 6 },
				{ 5637, 2 },
				{ 2321 },
			},
		},
		[3772] = { --Green Leather Armor
			item = 4255,
			reagents = {
				{ 4234, 9 },
				{ 2605, 2 },
				{ 2321, 4 },
			},
		},
		[3773] = { --Guardian Armor
			item = 4256,
			reagents = {
				{ 4236, 2 },
				{ 4234, 12 },
				{ 3824 },
				{ 2321, 2 },
			},
		},
		[3774] = { --Green Leather Belt
			item = 4257,
			reagents = {
				{ 4236 },
				{ 4234, 5 },
				{ 2321 },
				{ 2605 },
				{ 7071 },
			},
		},
		[3775] = { --Guardian Belt
			item = 4258,
			reagents = {
				{ 4236, 2 },
				{ 4234, 4 },
				{ 2321 },
				{ 7071 },
			},
		},
		[3776] = { --Green Leather Bracers
			item = 4259,
			reagents = {
				{ 4236, 2 },
				{ 4234, 6 },
				{ 2605 },
				{ 2321 },
			},
		},
		[3777] = { --Guardian Leather Bracers
			item = 4260,
			reagents = {
				{ 4234, 6 },
				{ 4236, 2 },
				{ 4291 },
			},
		},
		[3778] = { --Gem-studded Leather Belt
			item = 4262,
			reagents = {
				{ 4236, 4 },
				{ 5500, 2 },
				{ 1529, 2 },
				{ 3864 },
				{ 2321 },
			},
		},
		[3779] = { --Barbaric Belt
			item = 4264,
			reagents = {
				{ 4234, 6 },
				{ 4236, 2 },
				{ 4096, 2 },
				{ 5633 },
				{ 4291 },
				{ 7071 },
			},
		},
		[3780] = { --Heavy Armor Kit
			item = 4265,
			reagents = {
				{ 4234, 5 },
				{ 2321 },
			},
		},
		[3813] = { --Small Silk Pack
			item = 4245,
			reagents = {
				{ 4305, 3 },
				{ 4234, 2 },
				{ 2321, 3 },
			},
		},
		[3816] = { --Cured Light Hide
			item = 4231,
			reagents = {
				{ 783 },
				{ 4289 },
			},
		},
		[3817] = { --Cured Medium Hide
			item = 4233,
			reagents = {
				{ 4232 },
				{ 4289 },
			},
		},
		[3818] = { --Cured Heavy Hide
			item = 4236,
			reagents = {
				{ 4235 },
				{ 4289, 3 },
			},
		},
		[3839] = { --Bolt of Silk Cloth
			item = 4305,
			reagents = {
				{ 4306, 4 },
			},
		},
		[3840] = { --Heavy Linen Gloves
			item = 4307,
			reagents = {
				{ 2996, 2 },
				{ 2320 },
			},
		},
		[3841] = { --Green Linen Bracers
			item = 4308,
			reagents = {
				{ 2996, 3 },
				{ 2320, 2 },
				{ 2605 },
			},
		},
		[3842] = { --Handstitched Linen Britches
			item = 4309,
			reagents = {
				{ 2996, 4 },
				{ 2321, 2 },
			},
		},
		[3843] = { --Heavy Woolen Gloves
			item = 4310,
			reagents = {
				{ 2997, 3 },
				{ 2321 },
			},
		},
		[3844] = { --Heavy Woolen Cloak
			item = 4311,
			reagents = {
				{ 2997, 3 },
				{ 2321, 2 },
				{ 5498, 2 },
			},
		},
		[3845] = { --Soft-soled Linen Boots
			item = 4312,
			reagents = {
				{ 2996, 5 },
				{ 2318, 2 },
				{ 2321 },
			},
		},
		[3847] = { --Red Woolen Boots
			item = 4313,
			reagents = {
				{ 2997, 4 },
				{ 2318, 2 },
				{ 2321 },
				{ 2604, 2 },
			},
		},
		[3848] = { --Double-stitched Woolen Shoulders
			item = 4314,
			reagents = {
				{ 2997, 3 },
				{ 2321, 2 },
			},
		},
		[3849] = { --Reinforced Woolen Shoulders
			item = 4315,
			reagents = {
				{ 2997, 6 },
				{ 2319, 2 },
				{ 2321, 2 },
			},
		},
		[3850] = { --Heavy Woolen Pants
			item = 4316,
			reagents = {
				{ 2997, 5 },
				{ 2321, 4 },
			},
		},
		[3851] = { --Phoenix Pants
			item = 4317,
			reagents = {
				{ 2997, 6 },
				{ 5500 },
				{ 2321, 3 },
			},
		},
		[3852] = { --Gloves of Meditation
			item = 4318,
			reagents = {
				{ 2997, 4 },
				{ 2321, 3 },
				{ 3383 },
			},
		},
		[3854] = { --Azure Silk Gloves
			item = 4319,
			reagents = {
				{ 4305, 3 },
				{ 4234, 2 },
				{ 6260, 2 },
				{ 2321, 2 },
			},
		},
		[3855] = { --Spidersilk Boots
			item = 4320,
			reagents = {
				{ 4305, 2 },
				{ 2319, 4 },
				{ 3182, 4 },
				{ 5500, 2 },
			},
		},
		[3856] = { --Spider Silk Slippers
			item = 4321,
			reagents = {
				{ 4305, 3 },
				{ 3182 },
				{ 2321, 2 },
			},
		},
		[3857] = { --Enchanter's Cowl
			item = 4322,
			reagents = {
				{ 4305, 3 },
				{ 2321, 2 },
				{ 4337, 2 },
			},
		},
		[3858] = { --Shadow Hood
			item = 4323,
			reagents = {
				{ 4305, 4 },
				{ 4291 },
				{ 3824 },
			},
		},
		[3859] = { --Azure Silk Vest
			item = 4324,
			reagents = {
				{ 4305, 5 },
				{ 6260, 4 },
			},
		},
		[3860] = { --Boots of the Enchanter
			item = 4325,
			reagents = {
				{ 4305, 4 },
				{ 4291 },
				{ 4337, 2 },
			},
		},
		[3861] = { --Long Silken Cloak
			item = 4326,
			reagents = {
				{ 4305, 4 },
				{ 3827 },
				{ 4291 },
			},
		},
		[3862] = { --Icy Cloak
			item = 4327,
			reagents = {
				{ 4339, 3 },
				{ 4291, 2 },
				{ 3829 },
				{ 4337, 2 },
			},
		},
		[3863] = { --Spider Belt
			item = 4328,
			reagents = {
				{ 4305, 4 },
				{ 4337, 2 },
				{ 7071 },
			},
		},
		[3864] = { --Star Belt
			item = 4329,
			reagents = {
				{ 4339, 4 },
				{ 4234, 4 },
				{ 3864 },
				{ 7071 },
				{ 4291 },
			},
		},
		[3865] = { --Bolt of Mageweave
			item = 4339,
			reagents = {
				{ 4338, 5 },
			},
		},
		[3866] = { --Stylish Red Shirt
			item = 4330,
			reagents = {
				{ 2997, 3 },
				{ 2604, 2 },
				{ 2321 },
			},
		},
		[3868] = { --Phoenix Gloves
			item = 4331,
			reagents = {
				{ 2997, 4 },
				{ 5500 },
				{ 2321, 4 },
				{ 2324, 2 },
			},
		},
		[3869] = { --Bright Yellow Shirt
			item = 4332,
			reagents = {
				{ 4305 },
				{ 4341 },
				{ 2321 },
			},
		},
		[3870] = { --Dark Silk Shirt
			item = 4333,
			reagents = {
				{ 4305, 2 },
				{ 4340, 2 },
				{ 2321 },
			},
		},
		[3871] = { --Formal White Shirt
			item = 4334,
			reagents = {
				{ 4305, 3 },
				{ 2324, 2 },
				{ 2321 },
			},
		},
		[3872] = { --Rich Purple Silk Shirt
			item = 4335,
			reagents = {
				{ 4305, 4 },
				{ 4342 },
				{ 4291 },
			},
		},
		[3873] = { --Black Swashbuckler's Shirt
			item = 4336,
			reagents = {
				{ 4305, 5 },
				{ 2325 },
				{ 4291 },
			},
		},
		[3914] = { --Brown Linen Pants
			item = 4343,
			reagents = {
				{ 2996, 2 },
				{ 2320 },
			},
		},
		[3915] = { --Brown Linen Shirt
			item = 4344,
			reagents = {
				{ 2996 },
				{ 2320 },
			},
		},
		[3918] = { --Rough Blasting Powder
			item = 4357,
			reagents = {
				{ 2835 },
			},
		},
		[3919] = { --Rough Dynamite
			item = 4358,
			reagents = {
				{ 4357, 2 },
				{ 2589 },
			},
		},
		[3920] = { --Crafted Light Shot
			item = 8067,
			reagents = {
				{ 4357 },
				{ 2840 },
			},
		},
		[3921] = { --Deprecated Solid Shot
			item = 2518,
			reagents = {
				{ 4357, 2 },
				{ 2840 },
			},
		},
		[3922] = { --Handful of Copper Bolts
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4359,
			reagents = {
				{ 2840 },
			},
		},
		[3923] = { --Rough Copper Bomb
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4360,
			reagents = {
				{ 2840 },
				{ 4359 },
				{ 4357, 2 },
				{ 2589 },
			},
		},
		[3924] = { --Copper Tube
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4361,
			reagents = {
				{ 2840, 2 },
				{ 2880 },
			},
		},
		[3925] = { --Rough Boomstick
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4362,
			reagents = {
				{ 4361 },
				{ 4359 },
				{ 4399 },
			},
		},
		[3926] = { --Copper Modulator
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4363,
			reagents = {
				{ 4359, 2 },
				{ 2840 },
				{ 2589, 2 },
			},
		},
		[3928] = { --Mechanical Squirrel
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4401,
			reagents = {
				{ 4363 },
				{ 4359 },
				{ 2840 },
				{ 774, 2 },
			},
		},
		[3929] = { --Coarse Blasting Powder
			item = 4364,
			reagents = {
				{ 2836 },
			},
		},
		[3930] = { --Crafted Heavy Shot
			item = 8068,
			reagents = {
				{ 4364 },
				{ 2840 },
			},
		},
		[3931] = { --Coarse Dynamite
			item = 4365,
			reagents = {
				{ 4364, 3 },
				{ 2589 },
			},
		},
		[3932] = { --Target Dummy
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4366,
			reagents = {
				{ 4363 },
				{ 4359, 2 },
				{ 2841 },
				{ 2592 },
			},
		},
		[3933] = { --Small Seaforium Charge
			item = 4367,
			reagents = {
				{ 4364, 2 },
				{ 4363 },
				{ 2318 },
				{ 159 },
			},
		},
		[3934] = { --Flying Tiger Goggles
			tools = { 6219 },
			item = 4368,
			reagents = {
				{ 2318, 6 },
				{ 818,  2 },
			},
		},
		[3936] = { --Deadly Blunderbuss
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4369,
			reagents = {
				{ 4361, 2 },
				{ 4359, 4 },
				{ 4399 },
				{ 2319, 2 },
			},
		},
		[3937] = { --Large Copper Bomb
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4370,
			reagents = {
				{ 2840, 3 },
				{ 4364, 4 },
				{ 4404 },
			},
		},
		[3938] = { --Bronze Tube
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4371,
			reagents = {
				{ 2841, 2 },
				{ 2880 },
			},
		},
		[3939] = { --Lovingly Crafted Boomstick
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4372,
			reagents = {
				{ 4371, 2 },
				{ 4359, 2 },
				{ 4400 },
				{ 1206, 3 },
			},
		},
		[3940] = { --Shadow Goggles
			item = 4373,
			reagents = {
				{ 2319, 4 },
				{ 1210, 2 },
			},
		},
		[3941] = { --Small Bronze Bomb
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4374,
			reagents = {
				{ 4364, 4 },
				{ 2841, 2 },
				{ 4404 },
				{ 2592 },
			},
		},
		[3942] = { --Whirring Bronze Gizmo
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4375,
			reagents = {
				{ 2841, 2 },
				{ 2592 },
			},
		},
		[3944] = { --Flame Deflector
			requires = L["Anvil"],
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 4376,
			reagents = {
				{ 4375 },
				{ 4402 },
			},
		},
		[3945] = { --Heavy Blasting Powder
			item = 4377,
			reagents = {
				{ 2838 },
			},
		},
		[3946] = { --Heavy Dynamite
			item = 4378,
			reagents = {
				{ 4377, 2 },
				{ 2592 },
			},
		},
		[3947] = { --Crafted Solid Shot
			item = 8069,
			reagents = {
				{ 4377 },
				{ 2841 },
			},
		},
		[3949] = { --Silver-plated Shotgun
			requires = L["Anvil"],
			item = 4379,
			reagents = {
				{ 4371, 2 },
				{ 4375, 2 },
				{ 4400 },
				{ 2842, 3 },
			},
		},
		[3950] = { --Big Bronze Bomb
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4380,
			reagents = {
				{ 4377, 2 },
				{ 2841, 3 },
				{ 4404 },
			},
		},
		[3952] = { --Minor Recombobulator
			extra = Colors.WHITE .. "10 " .. L["Charges"],
			item = 4381,
			reagents = {
				{ 4371 },
				{ 4375, 2 },
				{ 2319, 2 },
				{ 1206 },
			},
		},
		[3953] = { --Bronze Framework
			item = 4382,
			reagents = {
				{ 2841, 2 },
				{ 2319 },
				{ 2592 },
			},
		},
		[3954] = { --Moonsight Rifle
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4383,
			reagents = {
				{ 4371, 3 },
				{ 4375, 3 },
				{ 4400 },
				{ 1705, 2 },
			},
		},
		[3955] = { --Explosive Sheep
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4384,
			reagents = {
				{ 4382 },
				{ 4375 },
				{ 4377, 2 },
				{ 2592, 2 },
			},
		},
		[3956] = { --Green Tinted Goggles
			tools = { 6219 },
			item = 4385,
			reagents = {
				{ 2319, 4 },
				{ 1206, 2 },
				{ 4368 },
			},
		},
		[3957] = { --Ice Deflector
			requires = L["Anvil"],
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 4386,
			reagents = {
				{ 4375 },
				{ 3829 },
			},
		},
		[3958] = { --Iron Strut
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4387,
			reagents = {
				{ 3575, 2 },
			},
		},
		[3959] = { --Discombobulator Ray
			requires = L["Anvil"],
			extra = Colors.WHITE .. "5 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 4388,
			reagents = {
				{ 4375, 3 },
				{ 4306, 2 },
				{ 1529 },
				{ 4371 },
			},
		},
		[3960] = { --Portable Bronze Mortar
			requires = L["Anvil"],
			extra = Colors.WHITE .. "8 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 4403,
			reagents = {
				{ 4371, 4 },
				{ 4387 },
				{ 4377, 4 },
				{ 2319, 4 },
			},
		},
		[3961] = { --Gyrochronatom
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4389,
			reagents = {
				{ 3575 },
				{ 10558 },
			},
		},
		[3962] = { --Iron Grenade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 4390,
			reagents = {
				{ 3575 },
				{ 4377 },
				{ 4306 },
			},
		},
		[3963] = { --Compact Harvest Reaper Kit
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4391,
			reagents = {
				{ 4387, 2 },
				{ 4382 },
				{ 4389, 2 },
				{ 4234, 4 },
			},
		},
		[3964] = { --Deprecated BKP \"Impact\" Shot
			item = 3034,
			reagents = {
				{ 4377, 2 },
				{ 3575 },
			},
		},
		[3965] = { --Advanced Target Dummy
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4392,
			reagents = {
				{ 4387 },
				{ 4382 },
				{ 4389 },
				{ 4234, 4 },
			},
		},
		[3966] = { --Craftsman's Monocle
			tools = { 6219, 10498 },
			item = 4393,
			reagents = {
				{ 4234, 6 },
				{ 3864, 2 },
			},
		},
		[3967] = { --Big Iron Bomb
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4394,
			reagents = {
				{ 3575, 3 },
				{ 4377, 3 },
				{ 4404 },
			},
		},
		[3968] = { --Goblin Land Mine
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4395,
			reagents = {
				{ 4377, 3 },
				{ 3575, 2 },
				{ 4389 },
			},
		},
		[3969] = { --Mechanical Dragonling
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4396,
			reagents = {
				{ 4382 },
				{ 4387, 4 },
				{ 4389, 4 },
				{ 3864, 2 },
				{ 7191 },
			},
		},
		[3971] = { --Gnomish Cloaking Device
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 4397,
			reagents = {
				{ 4389, 4 },
				{ 1529, 2 },
				{ 1705, 2 },
				{ 3864, 2 },
				{ 7191 },
			},
		},
		[3972] = { --Large Seaforium Charge
			item = 4398,
			reagents = {
				{ 10505, 2 },
				{ 4234,  2 },
				{ 159 },
			},
		},
		[3973] = { --Silver Contact
			item = 4404,
			reagents = {
				{ 2842 },
			},
		},
		[3977] = { --Crude Scope
			tools = { 6219 },
			item = 4405,
			reagents = {
				{ 4361 },
				{ 774 },
				{ 4359 },
			},
		},
		[3978] = { --Standard Scope
			tools = { 6219 },
			item = 4406,
			reagents = {
				{ 4371 },
				{ 1206 },
			},
		},
		[3979] = { --Accurate Scope
			tools = { 6219, 10498 },
			item = 4407,
			reagents = {
				{ 4371 },
				{ 1529 },
				{ 3864 },
			},
		},
		[4094] = { --Barbecued Buzzard Wing
			requires = L["Cooking Fire"],
			item = 4457,
			reagents = {
				{ 3404 },
				{ 2692 },
			},
		},
		[4096] = { --Raptor Hide Harness
			item = 4455,
			reagents = {
				{ 4461, 6 },
				{ 4234, 4 },
				{ 2321, 2 },
			},
		},
		[4097] = { --Raptor Hide Belt
			item = 4456,
			reagents = {
				{ 4461, 4 },
				{ 4234, 4 },
				{ 2321, 2 },
			},
		},
		[4508] = { --Discolored Healing Potion
			item = 4596,
			reagents = {
				{ 3164 },
				{ 2447 },
				{ 3371 },
			},
		},
		[4942] = { --Lesser Stoneshield Potion
			item = 4623,
			reagents = {
				{ 3858 },
				{ 3821 },
				{ 3372 },
			},
		},
		[5244] = { --Kodo Hide Bag
			item = 5081,
			reagents = {
				{ 5082, 3 },
				{ 2318, 4 },
				{ 2320 },
			},
		},
		[5763] = {
			item = 5237,
			reagents = {
				{ 2928 },
				{ 2930 },
				{ 3371 },
			},
		},
		[6310] = { --Divining Scroll Spell
			item = 5455,
			reagents = {
				{ 12220, 5 },
			},
		},
		[6412] = { --Kaldorei Spider Kabob
			requires = L["Cooking Fire"],
			item = 5472,
			reagents = {
				{ 5465 },
			},
		},
		[6413] = { --Scorpid Surprise
			requires = L["Cooking Fire"],
			item = 5473,
			reagents = {
				{ 5466 },
			},
		},
		[6414] = { --Roasted Kodo Meat
			requires = L["Cooking Fire"],
			item = 5474,
			reagents = {
				{ 5467 },
				{ 2678 },
			},
		},
		[6415] = { --Fillet of Frenzy
			requires = L["Cooking Fire"],
			item = 5476,
			reagents = {
				{ 5468 },
				{ 2678 },
			},
		},
		[6416] = { --Strider Stew
			requires = L["Cooking Fire"],
			item = 5477,
			reagents = {
				{ 5469 },
				{ 4536 },
			},
		},
		[6417] = { --Dig Rat Stew
			requires = L["Cooking Fire"],
			item = 5478,
			reagents = {
				{ 5051 },
			},
		},
		[6418] = { --Crispy Lizard Tail
			requires = L["Cooking Fire"],
			item = 5479,
			reagents = {
				{ 5470 },
				{ 2692 },
			},
		},
		[6419] = { --Lean Venison
			requires = L["Cooking Fire"],
			item = 5480,
			reagents = {
				{ 5471 },
				{ 2678, 4 },
			},
		},
		[6458] = { --Ornate Spyglass
			item = 5507,
			reagents = {
				{ 4371, 2 },
				{ 4375, 2 },
				{ 4363 },
				{ 1206 },
			},
		},
		[6470] = { --Tiny Bronze Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 5517,
			reagents = {
				{ 2841 },
			},
		},
		[6471] = { --Tiny Iron Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 5518,
			reagents = {
				{ 3575 },
			},
		},
		[6499] = { --Boiled Clams
			requires = L["Cooking Fire"],
			item = 5525,
			reagents = {
				{ 5503 },
				{ 159 },
			},
		},
		[6500] = { --Goblin Deviled Clams
			requires = L["Cooking Fire"],
			item = 5527,
			reagents = {
				{ 5504 },
				{ 2692 },
			},
		},
		[6501] = { --Clam Chowder
			requires = L["Cooking Fire"],
			item = 5526,
			reagents = {
				{ 5503 },
				{ 1179 },
				{ 2678 },
			},
		},
		[6510] = { --Blinding Powder
			item = 5530,
			reagents = {
				{ 3818 },
			},
		},
		[6517] = { --Pearl-handled Dagger
			requires = L["Anvil"],
			tools = { 5956 },
			item = 5540,
			reagents = {
				{ 2841, 6 },
				{ 3466 },
				{ 5498, 2 },
				{ 3478, 2 },
			},
		},
		[6518] = { --Iridescent Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 5541,
			reagents = {
				{ 2841, 10 },
				{ 3466 },
				{ 5500 },
				{ 3478, 2 },
				{ 2319, 2 },
			},
		},
		[6521] = { --Pearl-clasped Cloak
			item = 5542,
			reagents = {
				{ 2997, 3 },
				{ 2321, 2 },
				{ 5498 },
			},
		},
		[6617] = { --Rage Potion
			item = 5631,
			reagents = {
				{ 5635 },
				{ 2450 },
				{ 3371 },
			},
		},
		[6618] = { --Great Rage Potion
			item = 5633,
			reagents = {
				{ 5637 },
				{ 3356 },
				{ 3372 },
			},
		},
		[6624] = { --Free Action Potion
			item = 5634,
			reagents = {
				{ 6370, 2 },
				{ 3820 },
				{ 3372 },
			},
		},
		[6661] = { --Barbaric Harness
			item = 5739,
			reagents = {
				{ 4234, 14 },
				{ 2321, 2 },
				{ 7071 },
			},
		},
		[6686] = { --Red Linen Bag
			item = 5762,
			reagents = {
				{ 2996, 4 },
				{ 2321 },
				{ 2604 },
			},
		},
		[6688] = { --Red Woolen Bag
			item = 5763,
			reagents = {
				{ 2997, 4 },
				{ 2604 },
				{ 2321 },
			},
		},
		[6690] = { --Lesser Wizard's Robe
			item = 5766,
			reagents = {
				{ 4305, 2 },
				{ 2321, 2 },
				{ 3182, 2 },
			},
		},
		[6692] = { --Robes of Arcana
			item = 5770,
			reagents = {
				{ 4305, 4 },
				{ 2321, 2 },
				{ 3182, 2 },
			},
		},
		[6693] = { --Green Silk Pack
			item = 5764,
			reagents = {
				{ 4305, 4 },
				{ 4234, 3 },
				{ 2321, 3 },
				{ 2605 },
			},
		},
		[6695] = { --Black Silk Pack
			item = 5765,
			reagents = {
				{ 4305, 5 },
				{ 2325 },
				{ 2321, 4 },
			},
		},
		[6702] = { --Murloc Scale Belt
			item = 5780,
			reagents = {
				{ 5784, 8 },
				{ 2318, 6 },
				{ 2321 },
			},
		},
		[6703] = { --Murloc Scale Breastplate
			item = 5781,
			reagents = {
				{ 5784, 12 },
				{ 4231 },
				{ 2318, 8 },
				{ 2321 },
			},
		},
		[6704] = { --Thick Murloc Armor
			item = 5782,
			reagents = {
				{ 5785, 12 },
				{ 4236 },
				{ 4234, 10 },
				{ 2321, 3 },
			},
		},
		[6705] = { --Murloc Scale Bracers
			item = 5783,
			reagents = {
				{ 5785, 16 },
				{ 4236 },
				{ 4234, 14 },
				{ 4291 },
			},
		},
		[7126] = { --Handstitched Leather Vest
			item = 5957,
			reagents = {
				{ 2318, 3 },
				{ 2320 },
			},
		},
		[7133] = { --Fine Leather Pants
			item = 5958,
			reagents = {
				{ 2319, 8 },
				{ 2997 },
				{ 2321 },
			},
		},
		[7135] = { --Dark Leather Pants
			item = 5961,
			reagents = {
				{ 2319, 12 },
				{ 4340 },
				{ 2321 },
			},
		},
		[7147] = { --Guardian Pants
			item = 5962,
			reagents = {
				{ 4234, 12 },
				{ 4305, 2 },
				{ 2321, 2 },
			},
		},
		[7149] = { --Barbaric Leggings
			item = 5963,
			reagents = {
				{ 4234, 10 },
				{ 2321, 2 },
				{ 1206 },
			},
		},
		[7151] = { --Barbaric Shoulders
			item = 5964,
			reagents = {
				{ 4234, 8 },
				{ 4236 },
				{ 2321, 2 },
			},
		},
		[7153] = { --Guardian Cloak
			item = 5965,
			reagents = {
				{ 4234, 14 },
				{ 4305, 2 },
				{ 4291, 2 },
			},
		},
		[7156] = { --Guardian Gloves
			item = 5966,
			reagents = {
				{ 4234, 4 },
				{ 4236 },
				{ 4291 },
			},
			reagents_VANILLA_PLUS = {
				{ 4234, 8 },
				{ 4236, 2 },
				{ 4291 },
				{ 11139 },
			},
		},
		[7179] = { --Elixir of Water Breathing
			item = 5996,
			reagents = {
				{ 3820 },
				{ 6370, 2 },
				{ 3371 },
			},
		},
		[7181] = { --Greater Healing Potion
			item = 1710,
			reagents = {
				{ 3357 },
				{ 3356 },
				{ 3372 },
			},
		},
		[7183] = { --Elixir of Minor Defense
			item = 5997,
			reagents = {
				{ 765, 2 },
				{ 3371 },
			},
		},
		[7213] = { --Giant Clam Scorcho
			requires = L["Cooking Fire"],
			item = 6038,
			reagents = {
				{ 4655 },
				{ 2692 },
			},
		},
		[7221] = { --Iron Shield Spike
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6042,
			reagents = {
				{ 3575, 6 },
				{ 3478, 4 },
			},
		},
		[7222] = { --Iron Counterweight
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6043,
			reagents = {
				{ 3575, 4 },
				{ 3478, 2 },
				{ 1705 },
			},
		},
		[7223] = { --Golden Scale Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6040,
			reagents = {
				{ 3859, 5 },
				{ 3486, 2 },
			},
		},
		[7224] = { --Steel Weapon Chain
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6041,
			reagents = {
				{ 3859, 8 },
				{ 3486, 2 },
				{ 4234, 4 },
			},
		},
		[7255] = { --Holy Protection Potion
			item = 6051,
			reagents = {
				{ 2453 },
				{ 2452 },
				{ 3371 },
			},
		},
		[7256] = { --Shadow Protection Potion
			item = 6048,
			reagents = {
				{ 3369 },
				{ 3356 },
				{ 3372 },
			},
		},
		[7257] = { --Fire Protection Potion
			item = 6049,
			reagents = {
				{ 4402 },
				{ 6371 },
				{ 3372 },
			},
		},
		[7258] = { --Frost Protection Potion
			item = 6050,
			reagents = {
				{ 3819 },
				{ 3821 },
				{ 3372 },
			},
		},
		[7259] = { --Nature Protection Potion
			item = 6052,
			reagents = {
				{ 3357 },
				{ 3820 },
				{ 3372 },
			},
		},
		[7408] = { --Heavy Copper Maul
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6214,
			reagents = {
				{ 2840, 12 },
				{ 2880, 2 },
				{ 2318, 2 },
			},
		},
		[7430] = { --Arclight Spanner
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6219,
			reagents = {
				{ 2840, 6 },
			},
		},
		[7623] = { --Brown Linen Robe
			item = 6238,
			reagents = {
				{ 2996, 3 },
				{ 2320 },
			},
		},
		[7624] = { --White Linen Robe
			item = 6241,
			reagents = {
				{ 2996, 3 },
				{ 2320 },
				{ 2324 },
			},
		},
		[7629] = { --Red Linen Vest
			item = 6239,
			reagents = {
				{ 2996, 3 },
				{ 2320 },
				{ 2604 },
			},
		},
		[7630] = { --Blue Linen Vest
			item = 6240,
			reagents = {
				{ 2996, 3 },
				{ 2320 },
				{ 6260 },
			},
		},
		[7633] = { --Blue Linen Robe
			item = 6242,
			reagents = {
				{ 2996, 4 },
				{ 2320, 2 },
				{ 6260, 2 },
			},
		},
		[7636] = { --Green Woolen Robe
			item = 6243,
			reagents = {
				{ 2997, 3 },
				{ 2321, 2 },
				{ 2605 },
			},
		},
		[7639] = { --Blue Overalls
			item = 6263,
			reagents = {
				{ 2997, 4 },
				{ 2321, 2 },
				{ 6260, 2 },
			},
		},
		[7643] = { --Greater Adept's Robe
			item = 6264,
			reagents = {
				{ 2997, 5 },
				{ 2321, 3 },
				{ 2604, 3 },
			},
		},
		[7751] = { --Brilliant Smallfish
			requires = L["Cooking Fire"],
			item = 6290,
			reagents = {
				{ 6291 },
			},
		},
		[7752] = { --Slitherskin Mackerel
			requires = L["Cooking Fire"],
			item = 787,
			reagents = {
				{ 6303 },
			},
		},
		[7753] = { --Longjaw Mud Snapper
			requires = L["Cooking Fire"],
			item = 4592,
			reagents = {
				{ 6289 },
			},
		},
		[7754] = { --Loch Frenzy Delight
			requires = L["Cooking Fire"],
			item = 6316,
			reagents = {
				{ 6317 },
				{ 2678 },
			},
		},
		[7755] = { --Bristle Whisker Catfish
			requires = L["Cooking Fire"],
			item = 4593,
			reagents = {
				{ 6308 },
			},
		},
		[7817] = { --Rough Bronze Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6350,
			reagents = {
				{ 2841, 6 },
				{ 3470, 6 },
			},
		},
		[7818] = { --Silver Rod
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6338,
			reagents = {
				{ 2842 },
				{ 3470, 2 },
			},
		},
		[7827] = { --Rainbow Fin Albacore
			requires = L["Cooking Fire"],
			item = 5095,
			reagents = {
				{ 6361 },
			},
		},
		[7828] = { --Rockscale Cod
			requires = L["Cooking Fire"],
			item = 4594,
			reagents = {
				{ 6362 },
			},
		},
		[7836] = { --Blackmouth Oil
			item = 6370,
			reagents = {
				{ 6358, 2 },
				{ 3371 },
			},
		},
		[7837] = { --Fire Oil
			item = 6371,
			reagents = {
				{ 6359, 2 },
				{ 3371 },
			},
		},
		[7841] = { --Swim Speed Potion
			item = 6372,
			reagents = {
				{ 2452 },
				{ 6370 },
				{ 3371 },
			},
		},
		[7845] = { --Elixir of Firepower
			item = 6373,
			reagents = {
				{ 6371, 2 },
				{ 3356 },
				{ 3372 },
			},
		},
		[7892] = { --Stylish Blue Shirt
			item = 6384,
			reagents = {
				{ 2997, 4 },
				{ 6260, 2 },
				{ 4340 },
				{ 2321 },
			},
		},
		[7893] = { --Stylish Green Shirt
			item = 6385,
			reagents = {
				{ 2997, 4 },
				{ 2605, 2 },
				{ 4340 },
				{ 2321 },
			},
		},
		[7928] = { --Silk Bandage
			item = 6450,
			reagents = {
				{ 4306 },
			},
		},
		[7929] = { --Heavy Silk Bandage
			item = 6451,
			reagents = {
				{ 4306, 2 },
			},
		},
		[7934] = { --Anti-Venom
			item = 6452,
			reagents = {
				{ 1475 },
			},
		},
		[7935] = { --Strong Anti-Venom
			item = 6453,
			reagents = {
				{ 1288 },
			},
		},
		[7953] = { --Deviate Scale Cloak
			item = 6466,
			reagents = {
				{ 6470, 8 },
				{ 4231 },
				{ 2321 },
			},
		},
		[7954] = { --Deviate Scale Gloves
			item = 6467,
			reagents = {
				{ 6471, 2 },
				{ 6470, 6 },
				{ 2321, 2 },
			},
		},
		[7955] = { --Deviate Scale Belt
			item = 6468,
			reagents = {
				{ 6471, 10 },
				{ 6470, 10 },
				{ 2321, 2 },
			},
		},
		[8238] = { --Savory Deviate Delight
			requires = L["Cooking Fire"],
			item = 6657,
			reagents = {
				{ 6522 },
				{ 2678 },
			},
		},
		[8240] = { --Elixir of Giant Growth
			item = 6662,
			reagents = {
				{ 6522 },
				{ 2449 },
				{ 3371 },
			},
		},
		[8243] = { --Flash Bomb
			item = 4852,
			reagents = {
				{ 4611 },
				{ 4377 },
				{ 4306 },
			},
		},
		[8322] = { --Moonglow Vest
			item = 6709,
			reagents = {
				{ 2318, 6 },
				{ 4231 },
				{ 2320, 4 },
				{ 5498 },
			},
		},
		[8334] = { --Practice Lock
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6712,
			reagents = {
				{ 2841 },
				{ 4359, 2 },
				{ 2880 },
			},
		},
		[8339] = { --EZ-Thro Dynamite
			item = 6714,
			reagents = {
				{ 4364, 4 },
				{ 2592 },
			},
		},
		[8366] = { --Ironforge Chain
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6730,
			reagents = {
				{ 2840, 12 },
				{ 774,  2 },
				{ 3470, 2 },
			},
		},
		[8367] = { --Ironforge Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6731,
			reagents = {
				{ 2840, 16 },
				{ 818,  2 },
				{ 3470, 3 },
			},
		},
		[8368] = { --Ironforge Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 6733,
			reagents = {
				{ 2841, 8 },
				{ 1210, 3 },
				{ 3478, 4 },
			},
		},
		[8465] = { --Simple Dress
			item = 6786,
			reagents = {
				{ 2996, 2 },
				{ 2320 },
				{ 6260 },
				{ 2324 },
			},
		},
		[8467] = { --White Woolen Dress
			item = 6787,
			reagents = {
				{ 2997, 3 },
				{ 2324, 4 },
				{ 2321 },
			},
		},
		[8483] = { --White Swashbuckler's Shirt
			item = 6795,
			reagents = {
				{ 4305, 3 },
				{ 2324, 2 },
				{ 4291 },
			},
		},
		[8489] = { --Red Swashbuckler's Shirt
			item = 6796,
			reagents = {
				{ 4305, 3 },
				{ 2604, 2 },
				{ 4291 },
			},
		},
		[8604] = { --Herb Baked Egg
			requires = L["Cooking Fire"],
			item = 6888,
			reagents = {
				{ 6889 },
				{ 2678 },
			},
		},
		[8607] = { --Smoked Bear Meat
			requires = L["Cooking Fire"],
			item = 6890,
			reagents = {
				{ 3173 },
			},
		},
		[8681] = {
			item = 6947,
			reagents = { { 2928 },
				{ 3371 }, },
		},
		[8687] = {
			item = 6949,
			reagents = {
				{ 2928, 3 },
				{ 3372 },
			},
		},
		[8691] = {
			item = 6950,
			reagents = {
				{ 8924 },
				{ 3372 },
			},
		},
		[8694] = {
			item = 6951,
			reagents = {
				{ 2928, 4 },
				{ 2930, 4 },
				{ 3372 },
			},
		},
		[8758] = { --Azure Silk Pants
			item = 7046,
			reagents = {
				{ 4305, 4 },
				{ 6260, 2 },
				{ 2321, 3 },
			},
		},
		[8760] = { --Azure Silk Hood
			item = 7048,
			reagents = {
				{ 4305, 2 },
				{ 6260, 2 },
				{ 2321 },
			},
		},
		[8762] = { --Silk Headband
			item = 7050,
			reagents = {
				{ 4305, 3 },
				{ 2321, 2 },
			},
		},
		[8764] = { --Earthen Vest
			item = 7051,
			reagents = {
				{ 4305, 3 },
				{ 7067 },
				{ 2321, 2 },
			},
		},
		[8766] = { --Azure Silk Belt
			item = 7052,
			reagents = {
				{ 4305, 4 },
				{ 7070 },
				{ 6260, 2 },
				{ 2321, 2 },
				{ 7071 },
			},
		},
		[8768] = { --Iron Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7071,
			reagents = {
				{ 3575 },
			},
		},
		[8770] = { --Robe of Power
			item = 7054,
			reagents = {
				{ 4339, 2 },
				{ 7067, 2 },
				{ 7070, 2 },
				{ 7068, 2 },
				{ 7069, 2 },
				{ 4291, 2 },
			},
		},
		[8772] = { --Crimson Silk Belt
			item = 7055,
			reagents = {
				{ 4305, 4 },
				{ 7071 },
				{ 2604, 2 },
				{ 4291 },
			},
		},
		[8774] = { --Green Silken Shoulders
			item = 7057,
			reagents = {
				{ 4305, 5 },
				{ 4291, 2 },
			},
		},
		[8776] = { --Linen Belt
			item = 7026,
			reagents = {
				{ 2996 },
				{ 2320 },
			},
		},
		[8778] = { --Boots of Darkness
			item = 7027,
			reagents = {
				{ 4305, 3 },
				{ 2319, 2 },
				{ 6048 },
				{ 2321, 2 },
			},
		},
		[8780] = { --Hands of Darkness
			item = 7047,
			reagents = {
				{ 4305, 3 },
				{ 4234, 2 },
				{ 6048, 2 },
				{ 2321, 2 },
			},
		},
		[8782] = { --Truefaith Gloves
			item = 7049,
			reagents = {
				{ 4305, 3 },
				{ 4234, 2 },
				{ 929,  4 },
				{ 2321 },
			},
		},
		[8784] = { --Green Silk Armor
			item = 7065,
			reagents = {
				{ 4305, 5 },
				{ 2605, 2 },
				{ 4291 },
			},
		},
		[8786] = { --Azure Silk Cloak
			item = 7053,
			reagents = {
				{ 4305, 3 },
				{ 6260, 2 },
				{ 2321, 2 },
			},
		},
		[8789] = { --Crimson Silk Cloak
			item = 7056,
			reagents = {
				{ 4305, 5 },
				{ 2604, 2 },
				{ 6371, 2 },
				{ 4291 },
			},
		},
		[8791] = { --Crimson Silk Vest
			item = 7058,
			reagents = {
				{ 4305, 4 },
				{ 2604, 2 },
				{ 2321, 2 },
			},
		},
		[8793] = { --Crimson Silk Shoulders
			item = 7059,
			reagents = {
				{ 4305, 5 },
				{ 6371, 2 },
				{ 2604, 2 },
				{ 4291, 2 },
			},
		},
		[8795] = { --Azure Shoulders
			item = 7060,
			reagents = {
				{ 4305, 6 },
				{ 7072, 2 },
				{ 6260, 2 },
				{ 4291, 2 },
			},
		},
		[8797] = { --Earthen Silk Belt
			item = 7061,
			reagents = {
				{ 4305, 5 },
				{ 7067, 4 },
				{ 4234, 4 },
				{ 7071 },
				{ 4291, 2 },
			},
		},
		[8799] = { --Crimson Silk Pantaloons
			item = 7062,
			reagents = {
				{ 4305, 4 },
				{ 2604, 2 },
				{ 4291, 2 },
			},
		},
		[8802] = { --Crimson Silk Robe
			item = 7063,
			reagents = {
				{ 4305, 8 },
				{ 7068, 4 },
				{ 3827, 2 },
				{ 2604, 4 },
				{ 4291 },
			},
		},
		[8804] = { --Crimson Silk Gloves
			item = 7064,
			reagents = {
				{ 4305, 6 },
				{ 7068, 2 },
				{ 6371, 2 },
				{ 4304, 2 },
				{ 2604, 4 },
				{ 4291, 2 },
			},
		},
		[8880] = { --Copper Dagger
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7166,
			reagents = {
				{ 2840, 6 },
				{ 2880 },
				{ 3470 },
				{ 2318 },
			},
		},
		[8895] = { --Goblin Rocket Boots
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 7189,
			reagents = {
				{ 10026 },
				{ 10559, 2 },
				{ 4234,  4 },
				{ 9061,  2 },
				{ 10560 },
			},
		},
		[9058] = { --Handstitched Leather Cloak
			item = 7276,
			reagents = {
				{ 2318, 2 },
				{ 2320 },
			},
		},
		[9059] = { --Handstitched Leather Bracers
			item = 7277,
			reagents = {
				{ 2318, 2 },
				{ 2320, 3 },
			},
		},
		[9060] = { --Light Leather Quiver
			item = 7278,
			reagents = {
				{ 2318, 4 },
				{ 2320, 2 },
			},
		},
		[9062] = { --Small Leather Ammo Pouch
			item = 7279,
			reagents = {
				{ 2318, 3 },
				{ 2320, 4 },
			},
		},
		[9064] = { --Rugged Leather Pants
			item = 7280,
			reagents = {
				{ 2318, 5 },
				{ 2320, 5 },
			},
		},
		[9065] = { --Light Leather Bracers
			item = 7281,
			reagents = {
				{ 2318, 6 },
				{ 2320, 4 },
			},
		},
		[9068] = { --Light Leather Pants
			item = 7282,
			reagents = {
				{ 2318, 10 },
				{ 4231 },
				{ 2321 },
			},
		},
		[9070] = { --Black Whelp Cloak
			item = 7283,
			reagents = {
				{ 7286, 12 },
				{ 2319, 4 },
				{ 2321 },
			},
		},
		[9072] = { --Red Whelp Gloves
			item = 7284,
			reagents = {
				{ 7287, 6 },
				{ 2319, 4 },
				{ 2321 },
			},
		},
		[9074] = { --Nimble Leather Gloves
			item = 7285,
			reagents = {
				{ 2457 },
				{ 2319, 6 },
				{ 2321 },
			},
		},
		[9145] = { --Fletcher's Gloves
			item = 7348,
			reagents = {
				{ 2319, 8 },
				{ 5116, 4 },
				{ 2321, 2 },
			},
		},
		[9146] = { --Herbalist's Gloves
			item = 7349,
			reagents = {
				{ 2319, 8 },
				{ 3356, 4 },
				{ 2321, 2 },
			},
		},
		[9147] = { --Earthen Leather Shoulders
			item = 7352,
			reagents = {
				{ 2319, 6 },
				{ 7067 },
				{ 2321, 2 },
			},
		},
		[9148] = { --Pilferer's Gloves
			item = 7358,
			reagents = {
				{ 2319, 10 },
				{ 5373, 2 },
				{ 2321, 2 },
			},
		},
		[9149] = { --Heavy Earthen Gloves
			item = 7359,
			reagents = {
				{ 2319, 12 },
				{ 7067, 2 },
				{ 2997, 2 },
				{ 2321, 2 },
			},
		},
		[9193] = { --Heavy Quiver
			item = 7371,
			reagents = {
				{ 4234, 8 },
				{ 2321, 2 },
			},
		},
		[9194] = { --Heavy Leather Ammo Pouch
			item = 7372,
			reagents = {
				{ 4234, 8 },
				{ 2321, 2 },
			},
		},
		[9195] = { --Dusky Leather Leggings
			item = 7373,
			reagents = {
				{ 4234, 10 },
				{ 2325 },
				{ 2321, 2 },
			},
		},
		[9196] = { --Dusky Leather Armor
			item = 7374,
			reagents = {
				{ 4234, 10 },
				{ 3824 },
				{ 2321, 2 },
			},
		},
		[9197] = { --Green Whelp Armor
			item = 7375,
			reagents = {
				{ 7392, 4 },
				{ 4234, 10 },
				{ 2321, 2 },
			},
		},
		[9198] = { --Frost Leather Cloak
			item = 7377,
			reagents = {
				{ 4234, 6 },
				{ 7067, 2 },
				{ 7070, 2 },
				{ 2321, 2 },
			},
		},
		[9201] = { --Dusky Bracers
			item = 7378,
			reagents = {
				{ 4234, 16 },
				{ 2325 },
				{ 4291, 2 },
			},
		},
		[9202] = { --Green Whelp Bracers
			item = 7386,
			reagents = {
				{ 7392, 6 },
				{ 4234, 8 },
				{ 4291, 2 },
			},
		},
		[9206] = { --Dusky Belt
			item = 7387,
			reagents = {
				{ 4234, 10 },
				{ 4305, 2 },
				{ 2325, 2 },
				{ 7071 },
			},
		},
		[9207] = { --Dusky Boots
			item = 7390,
			reagents = {
				{ 4234, 8 },
				{ 7428, 2 },
				{ 3824 },
				{ 4291, 2 },
			},
		},
		[9208] = { --Swift Boots
			item = 7391,
			reagents = {
				{ 4234, 10 },
				{ 2459, 2 },
				{ 4337, 2 },
				{ 4291 },
			},
		},
		[9269] = { --Gnomish Universal Remote
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 7506,
			reagents = {
				{ 2841, 6 },
				{ 4375 },
				{ 814,  2 },
				{ 818 },
				{ 774 },
			},
		},
		[9271] = { --Aquadynamic Fish Attractor
			item = 6533,
			reagents = {
				{ 2841, 2 },
				{ 6530 },
				{ 4364 },
			},
		},
		[9273] = { --Goblin Jumper Cables
			item = 7148,
			reagents = {
				{ 3575, 6 },
				{ 4375, 2 },
				{ 814,  2 },
				{ 4306, 2 },
				{ 1210, 2 },
				{ 7191 },
			},
		},
		[9513] = { --Thistle Tea
			requires = L["Cooking Fire"],
			item = 7676,
			reagents = {
				{ 2452 },
				{ 159 },
			},
		},
		[9811] = { --Barbaric Iron Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7913,
			reagents = {
				{ 3575, 8 },
				{ 5635, 4 },
				{ 1210, 2 },
				{ 3486, 2 },
			},
		},
		[9813] = { --Barbaric Iron Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7914,
			reagents = {
				{ 3575, 20 },
				{ 3486, 4 },
			},
		},
		[9814] = { --Barbaric Iron Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7915,
			reagents = {
				{ 3575, 10 },
				{ 5637, 2 },
				{ 5635, 2 },
			},
		},
		[9818] = { --Barbaric Iron Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7916,
			reagents = {
				{ 3575, 12 },
				{ 5637, 4 },
				{ 818,  4 },
				{ 3486, 2 },
			},
		},
		[9820] = { --Barbaric Iron Gloves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7917,
			reagents = {
				{ 3575, 14 },
				{ 3486, 3 },
				{ 5637, 2 },
			},
		},
		[9916] = { --Steel Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7963,
			reagents = {
				{ 3859, 16 },
				{ 3486, 3 },
			},
		},
		[9918] = { --Solid Sharpening Stone
			item = 7964,
			reagents = {
				{ 7912 },
			},
		},
		[9920] = { --Solid Grinding Stone
			item = 7966,
			reagents = {
				{ 7912, 4 },
			},
		},
		[9921] = { --Solid Weightstone
			item = 7965,
			reagents = {
				{ 7912 },
				{ 4306 },
			},
		},
		[9926] = { --Heavy Mithril Shoulder
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7918,
			reagents = {
				{ 3860, 8 },
				{ 4234, 6 },
			},
		},
		[9928] = { --Heavy Mithril Gauntlet
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7919,
			reagents = {
				{ 3860, 6 },
				{ 4338, 4 },
			},
		},
		[9931] = { --Mithril Scale Pants
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7920,
			reagents = {
				{ 3860, 12 },
			},
		},
		[9933] = { --Heavy Mithril Pants
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7921,
			reagents = {
				{ 3860, 10 },
				{ 1705, 2 },
			},
		},
		[9935] = { --Steel Plate Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7922,
			reagents = {
				{ 3859, 14 },
				{ 7966 },
			},
			reagents_VANILLA_PLUS = {
				{ 3859, 18 },
				{ 7966 },
				{ 4234, 8 },
			},
		},
		[9937] = { --Mithril Scale Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7924,
			reagents = {
				{ 3860, 8 },
				{ 3864, 2 },
			},
		},
		[9939] = { --Mithril Shield Spike
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7967,
			reagents = {
				{ 3860, 4 },
				{ 6037, 2 },
				{ 7966, 4 },
			},
		},
		[9942] = { --Mithril Scale Gloves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7925,
			reagents = {
				{ 3860, 8 },
				{ 4234, 6 },
				{ 4338, 4 },
			},
		},
		[9945] = { --Ornate Mithril Pants
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7926,
			reagents = {
				{ 3860, 12 },
				{ 6037 },
				{ 7966 },
				{ 7909 },
			},
		},
		[9950] = { --Ornate Mithril Gloves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7927,
			reagents = {
				{ 3860, 10 },
				{ 4338, 6 },
				{ 6037 },
				{ 7966 },
			},
		},
		[9952] = { --Ornate Mithril Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7928,
			reagents = {
				{ 3860, 12 },
				{ 6037 },
				{ 4304, 6 },
			},
		},
		[9954] = { --Truesilver Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7938,
			reagents = {
				{ 3860, 10 },
				{ 6037, 8 },
				{ 7909, 3 },
				{ 3864, 3 },
				{ 5966 },
				{ 7966, 2 },
			},
		},
		[9957] = { --Orcish War Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7929,
			reagents = {
				{ 3860, 12 },
				{ 7067 },
			},
		},
		[9959] = { --Heavy Mithril Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7930,
			reagents = {
				{ 3860, 16 },
			},
		},
		[9961] = { --Mithril Coif
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7931,
			reagents = {
				{ 3860, 10 },
				{ 4338, 6 },
			},
		},
		[9964] = { --Mithril Spurs
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7969,
			reagents = {
				{ 3860, 4 },
				{ 7966, 3 },
			},
		},
		[9966] = { --Mithril Scale Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7932,
			reagents = {
				{ 3860, 14 },
				{ 4304, 4 },
				{ 3864, 4 },
			},
		},
		[9968] = { --Heavy Mithril Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7933,
			reagents = {
				{ 3860, 14 },
				{ 4304, 4 },
			},
		},
		[9970] = { --Heavy Mithril Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7934,
			reagents = {
				{ 3860, 14 },
				{ 7909 },
			},
		},
		[9972] = { --Ornate Mithril Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7935,
			reagents = {
				{ 3860, 16 },
				{ 6037, 6 },
				{ 7077 },
				{ 7966 },
			},
		},
		[9974] = { --Truesilver Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7939,
			reagents = {
				{ 3860, 12 },
				{ 6037, 24 },
				{ 7910, 4 },
				{ 7971, 4 },
				{ 7966, 2 },
			},
		},
		[9979] = { --Ornate Mithril Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7936,
			reagents = {
				{ 3860, 14 },
				{ 6037, 2 },
				{ 4304, 4 },
				{ 7966 },
				{ 7909 },
			},
		},
		[9980] = { --Ornate Mithril Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7937,
			reagents = {
				{ 3860, 16 },
				{ 6037, 2 },
				{ 7971 },
				{ 7966 },
			},
		},
		[9983] = { --Copper Claymore
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7955,
			reagents = {
				{ 2840, 10 },
				{ 2880, 2 },
				{ 3470 },
				{ 2318 },
			},
		},
		[9985] = { --Bronze Warhammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7956,
			reagents = {
				{ 2841, 8 },
				{ 3466 },
				{ 2319 },
			},
		},
		[9986] = { --Bronze Greatsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7957,
			reagents = {
				{ 2841, 12 },
				{ 3466, 2 },
				{ 2319, 2 },
			},
		},
		[9987] = { --Bronze Battle Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7958,
			reagents = {
				{ 2841, 14 },
				{ 3466 },
				{ 2319, 2 },
			},
		},
		[9993] = { --Heavy Mithril Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7941,
			reagents = {
				{ 3860, 12 },
				{ 3864, 2 },
				{ 7966 },
				{ 4234, 4 },
			},
		},
		[9995] = { --Blue Glittering Axe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7942,
			reagents = {
				{ 3860, 16 },
				{ 7909, 2 },
				{ 7966 },
				{ 4304, 4 },
			},
		},
		[9997] = { --Wicked Mithril Blade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7943,
			reagents = {
				{ 3860, 14 },
				{ 6037, 4 },
				{ 7966 },
				{ 4304, 2 },
			},
		},
		[10001] = { --Big Black Mace
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7945,
			reagents = {
				{ 3860, 16 },
				{ 7971 },
				{ 1210, 4 },
				{ 7966 },
				{ 4304, 2 },
			},
		},
		[10003] = { --The Shatterer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7954,
			reagents = {
				{ 3860, 24 },
				{ 7075, 4 },
				{ 6037, 6 },
				{ 3864, 5 },
				{ 1529, 5 },
				{ 7966, 4 },
				{ 4304, 4 },
			},
		},
		[10005] = { --Dazzling Mithril Rapier
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7944,
			reagents = {
				{ 3860, 14 },
				{ 7909 },
				{ 1705, 2 },
				{ 1206, 2 },
				{ 7966 },
				{ 4338, 2 },
			},
		},
		[10007] = { --Phantom Blade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7961,
			reagents = {
				{ 3860, 28 },
				{ 7081, 6 },
				{ 6037, 8 },
				{ 3823, 2 },
				{ 7909, 6 },
				{ 7966, 4 },
				{ 4304, 2 },
			},
		},
		[10009] = { --Runed Mithril Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7946,
			reagents = {
				{ 3860, 18 },
				{ 7075, 2 },
				{ 7966 },
				{ 4304, 4 },
			},
		},
		[10011] = { --Blight
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7959,
			reagents = {
				{ 3860, 28 },
				{ 7972, 10 },
				{ 6037, 10 },
				{ 7966, 6 },
				{ 4304, 6 },
			},
		},
		[10013] = { --Ebon Shiv
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7947,
			reagents = {
				{ 3860, 12 },
				{ 6037, 6 },
				{ 7910, 2 },
				{ 7966 },
				{ 4304, 2 },
			},
		},
		[10015] = { --Truesilver Champion
			requires = L["Anvil"],
			tools = { 5956 },
			item = 7960,
			reagents = {
				{ 3860, 30 },
				{ 6037, 16 },
				{ 7910, 6 },
				{ 7081, 4 },
				{ 7966, 8 },
				{ 4304, 6 },
			},
		},
		[10097] = { --Smelt Mithril
			name = LS["Smelting: Smelt Mithril"],
			requires = L["Forge"],
			item = 3860,
			reagents = {
				{ 3858 },
			},
		},
		[10098] = { --Smelt Truesilver
			name = LS["Smelting: Smelt Truesilver"],
			requires = L["Forge"],
			item = 6037,
			reagents = {
				{ 7911 },
			},
		},
		[10482] = { --Cured Thick Hide
			item = 8172,
			reagents = {
				{ 8169 },
				{ 8150 },
			},
		},
		[10487] = { --Thick Armor Kit
			item = 8173,
			reagents = {
				{ 4304, 5 },
				{ 4291 },
			},
		},
		[10490] = { --Comfortable Leather Hat
			item = 8174,
			reagents = {
				{ 4234, 12 },
				{ 4236, 2 },
				{ 4291, 2 },
			},
		},
		[10499] = { --Nightscape Tunic
			item = 8175,
			reagents = {
				{ 4304, 7 },
				{ 4291, 2 },
			},
		},
		[10507] = { --Nightscape Headband
			item = 8176,
			reagents = {
				{ 4304, 5 },
				{ 4291, 2 },
			},
		},
		[10509] = { --Turtle Scale Gloves
			item = 8187,
			reagents = {
				{ 4304, 6 },
				{ 8167, 8 },
				{ 8343 },
			},
		},
		[10511] = { --Turtle Scale Breastplate
			item = 8189,
			reagents = {
				{ 4304, 6 },
				{ 8167, 12 },
				{ 8343 },
			},
		},
		[10516] = { --Nightscape Shoulders
			item = 8192,
			reagents = {
				{ 4304, 8 },
				{ 4338, 6 },
				{ 4291, 3 },
			},
		},
		[10518] = { --Turtle Scale Bracers
			item = 8198,
			reagents = {
				{ 4304, 8 },
				{ 8167, 12 },
				{ 8343 },
			},
		},
		[10520] = { --Big Voodoo Robe
			item = 8200,
			reagents = {
				{ 4304, 10 },
				{ 8151, 4 },
				{ 8343 },
			},
		},
		[10525] = { --Tough Scorpid Breastplate
			item = 8203,
			reagents = {
				{ 4304, 12 },
				{ 8154, 12 },
				{ 4291, 4 },
			},
		},
		[10529] = { --Wild Leather Shoulders
			item = 8210,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 10 },
				{ 8153 },
				{ 8172 },
			},
		},
		[10531] = { --Big Voodoo Mask
			item = 8201,
			reagents = {
				{ 4304, 8 },
				{ 8151, 6 },
				{ 8343 },
			},
		},
		[10533] = { --Tough Scorpid Bracers
			item = 8205,
			reagents = {
				{ 4304, 10 },
				{ 8154, 4 },
				{ 4291, 2 },
			},
		},
		[10542] = { --Tough Scorpid Gloves
			item = 8204,
			reagents = {
				{ 4304, 6 },
				{ 8154, 8 },
				{ 4291, 2 },
			},
		},
		[10544] = { --Wild Leather Vest
			item = 8211,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 12 },
				{ 8153, 2 },
				{ 8172 },
			},
		},
		[10546] = { --Wild Leather Helmet
			item = 8214,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 10 },
				{ 8153, 2 },
				{ 8172 },
			},
		},
		[10548] = { --Nightscape Pants
			item = 8193,
			reagents = {
				{ 4304, 14 },
				{ 4291, 4 },
			},
		},
		[10550] = { --Nightscape Cloak
			item = 8195,
			reagents = {
				{ 4304, 12 },
				{ 4291, 4 },
			},
		},
		[10552] = { --Turtle Scale Helm
			item = 8191,
			reagents = {
				{ 4304, 14 },
				{ 8167, 24 },
				{ 8343 },
			},
		},
		[10554] = { --Tough Scorpid Boots
			item = 8209,
			reagents = {
				{ 4304, 12 },
				{ 8154, 12 },
				{ 4291, 6 },
			},
		},
		[10556] = { --Turtle Scale Leggings
			item = 8185,
			reagents = {
				{ 4304, 14 },
				{ 8167, 28 },
				{ 8343 },
			},
		},
		[10558] = { --Nightscape Boots
			item = 8197,
			reagents = {
				{ 4304, 16 },
				{ 8343, 2 },
			},
		},
		[10560] = { --Big Voodoo Pants
			item = 8202,
			reagents = {
				{ 4304, 10 },
				{ 8152, 6 },
				{ 8343, 2 },
			},
		},
		[10562] = { --Big Voodoo Cloak
			item = 8216,
			reagents = {
				{ 4304, 14 },
				{ 8152, 4 },
				{ 8343, 2 },
			},
		},
		[10564] = { --Tough Scorpid Shoulders
			item = 8207,
			reagents = {
				{ 4304, 12 },
				{ 8154, 16 },
				{ 8343, 2 },
			},
		},
		[10566] = { --Wild Leather Boots
			item = 8213,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 14 },
				{ 8153, 4 },
				{ 8172, 2 },
			},
		},
		[10568] = { --Tough Scorpid Leggings
			item = 8206,
			reagents = {
				{ 4304, 14 },
				{ 8154, 8 },
				{ 8343, 2 },
			},
		},
		[10570] = { --Tough Scorpid Helm
			item = 8208,
			reagents = {
				{ 4304, 10 },
				{ 8154, 20 },
				{ 8343, 2 },
			},
		},
		[10572] = { --Wild Leather Leggings
			item = 8212,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 16 },
				{ 8153, 6 },
				{ 8172, 2 },
			},
		},
		[10574] = { --Wild Leather Cloak
			item = 8215,
			extra = Colors.GREEN .. L["<Random enchantment>"],
			reagents = {
				{ 4304, 16 },
				{ 8153, 6 },
				{ 8172, 2 },
			},
		},
		[10619] = { --Dragonscale Gauntlets
			item = 8347,
			reagents = {
				{ 4304, 24 },
				{ 8165, 12 },
				{ 8343, 4 },
				{ 8172, 2 },
			},
		},
		[10621] = { --Wolfshead Helm
			item = 8345,
			reagents = {
				{ 4304, 18 },
				{ 8368, 2 },
				{ 8146, 8 },
				{ 8343, 4 },
				{ 8172, 2 },
			},
		},
		[10630] = { --Gauntlets of the Sea
			item = 8346,
			reagents = {
				{ 4304, 20 },
				{ 7079, 8 },
				{ 7075, 2 },
				{ 8172 },
				{ 8343, 4 },
			},
		},
		[10632] = { --Helm of Fire
			item = 8348,
			reagents = {
				{ 4304, 40 },
				{ 7077, 8 },
				{ 7075, 4 },
				{ 8172, 2 },
				{ 8343, 4 },
			},
		},
		[10647] = { --Feathered Breastplate
			item = 8349,
			reagents = {
				{ 4304, 40 },
				{ 8168, 40 },
				{ 7971, 2 },
				{ 8172, 4 },
				{ 8343, 4 },
			},
		},
		[10650] = { --Dragonscale Breastplate
			item = 8367,
			reagents = {
				{ 4304, 40 },
				{ 8165, 30 },
				{ 8343, 4 },
				{ 8172, 4 },
			},
		},
		[10840] = { --Mageweave Bandage
			item = 8544,
			reagents = {
				{ 4338 },
			},
		},
		[10841] = { --Heavy Mageweave Bandage
			item = 8545,
			reagents = {
				{ 4338, 2 },
			},
		},
		[10844] = { --Powerful Smelling Salts
			item = 8546,
			reagents = {
				{ 8150, 4 },
			},
			reagents_TURTLE1 = {
				{ 8150, 4 },
				{ 7078, 2 },
				{ 18512 },
			},
		},
		[11017] = { --Summon Witherbark Felhunter
			reagents = {
				{ 6265 },
			},
		},
		[11341] = {
			item = 8926,
			reagents = {
				{ 8924, 2 },
				{ 8925 },
			},
		},
		[11342] = {
			item = 8927,
			reagents = {
				{ 8924, 3 },
				{ 8925 },
			},
		},
		[11343] = {
			item = 8928,
			reagents = {
				{ 8924, 4 },
				{ 8925 },
			},
		},
		[11357] = {
			item = 8984,
			reagents = {
				{ 5173, 3 },
				{ 8925 },
			},
		},
		[11358] = {
			item = 8985,
			reagents = {
				{ 5173, 5 },
				{ 8925 },
			},
		},
		[11400] = {
			item = 9186,
			reagents = {
				{ 8924, 2 },
				{ 8923, 2 },
				{ 8925 },
			},
		},
		[11447] = { --Elixir of Waterwalking
			item = 8827,
			reagents = {
				{ 6370 },
				{ 3357 },
				{ 3372 },
			},
		},
		[11448] = { --Greater Mana Potion
			item = 6149,
			reagents = {
				{ 3358 },
				{ 3821 },
				{ 3372 },
			},
		},
		[11449] = { --Elixir of Agility
			item = 8949,
			reagents = {
				{ 3820 },
				{ 3821 },
				{ 3372 },
			},
		},
		[11450] = { --Elixir of Greater Defense
			item = 8951,
			reagents = {
				{ 3355 },
				{ 3821 },
				{ 3372 },
			},
		},
		[11451] = { --Oil of Immolation
			item = 8956,
			reagents = {
				{ 4625 },
				{ 3821 },
				{ 8925 },
			},
		},
		[11452] = { --Restorative Potion
			item = 9030,
			reagents = {
				{ 7067 },
				{ 3821 },
				{ 8925 },
			},
		},
		[11453] = { --Magic Resistance Potion
			item = 9036,
			reagents = {
				{ 3358 },
				{ 8831 },
				{ 8925 },
			},
		},
		[11454] = { --Inlaid Mithril Cylinder
			requires = L["Anvil"],
			tools = { 5956 },
			item = 9060,
			reagents = {
				{ 3860, 5 },
				{ 3577 },
				{ 6037 },
			},
		},
		[11456] = { --Goblin Rocket Fuel
			item = 9061,
			reagents = {
				{ 4625 },
				{ 9260 },
				{ 3372 },
			},
		},
		[11457] = { --Superior Healing Potion
			item = 3928,
			reagents = {
				{ 8838 },
				{ 3358 },
				{ 8925 },
			},
		},
		[11458] = { --Wildvine Potion
			item = 9144,
			reagents = {
				{ 8153 },
				{ 8831 },
				{ 8925 },
			},
		},
		[11459] = { --Philosophers' Stone
			item = 9149,
			reagents = {
				{ 3575, 4 },
				{ 9262 },
				{ 8831, 4 },
				{ 4625, 4 },
			},
		},
		[11460] = { --Elixir of Detect Undead
			item = 9154,
			reagents = {
				{ 8836 },
				{ 8925 },
			},
		},
		[11461] = { --Arcane Elixir
			item = 9155,
			reagents = {
				{ 8839 },
				{ 3821 },
				{ 8925 },
			},
		},
		[11464] = { --Invisibility Potion
			item = 9172,
			reagents = {
				{ 8845 },
				{ 8838 },
				{ 8925 },
			},
		},
		[11465] = { --Elixir of Greater Intellect
			item = 9179,
			reagents = {
				{ 8839 },
				{ 3358 },
				{ 8925 },
			},
		},
		[11466] = { --Gift of Arthas
			item = 9088,
			reagents = {
				{ 8836 },
				{ 8839 },
				{ 8925 },
			},
		},
		[11467] = { --Elixir of Greater Agility
			item = 9187,
			reagents = {
				{ 8838 },
				{ 3821 },
				{ 8925 },
			},
		},
		[11468] = { --Elixir of Dream Vision
			item = 9197,
			reagents = {
				{ 8831, 3 },
				{ 8925 },
			},
		},
		[11472] = { --Elixir of Giants
			item = 9206,
			reagents = {
				{ 8838 },
				{ 8846 },
				{ 8925 },
			},
		},
		[11473] = { --Ghost Dye
			item = 9210,
			reagents = {
				{ 8845, 2 },
				{ 4342 },
				{ 8925 },
			},
		},
		[11476] = { --Elixir of Shadow Power
			item = 9264,
			reagents = {
				{ 8845, 3 },
				{ 8925 },
			},
		},
		[11477] = { --Elixir of Demonslaying
			item = 9224,
			reagents = {
				{ 8846 },
				{ 8845 },
				{ 8925 },
			},
		},
		[11478] = { --Elixir of Detect Demon
			item = 9233,
			reagents = {
				{ 8846, 2 },
				{ 8925 },
			},
		},
		[11479] = { --Transmute: Iron to Gold
			tools = { 9149 },
			item = 3577,
			reagents = {
				{ 3575 },
			},
			reagents_VANILLA_PLUS = {
				{ 3575 },
				{ 11137 },
			},
		},
		[11480] = { --Transmute: Mithril to Truesilver
			tools = { 9149 },
			item = 6037,
			reagents = {
				{ 3860 },
			},
			reagents_VANILLA_PLUS = {
				{ 3860 },
				{ 11176 },
			},
		},
		[11643] = { --Golden Scale Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 9366,
			reagents = {
				{ 3859, 10 },
				{ 3577, 4 },
				{ 3486, 4 },
				{ 3864 },
			},
		},
		[11923] = { --Repair the Blade of Heroes
			requires = L["Anvil"],
			tools = { 5956 },
			item = 9718,
			reagents = {
				{ 9719 },
				{ 3859, 4 },
				{ 3466, 4 },
				{ 7068, 2 },
				{ 3486, 2 },
			},
		},
		[12044] = { --Simple Linen Pants
			item = 10045,
			reagents = {
				{ 2996 },
				{ 2320 },
			},
		},
		[12045] = { --Simple Linen Boots
			item = 10046,
			reagents = {
				{ 2996, 2 },
				{ 2318 },
				{ 2320 },
			},
		},
		[12046] = { --Simple Kilt
			item = 10047,
			reagents = {
				{ 2996, 4 },
				{ 2321 },
			},
		},
		[12047] = { --Colorful Kilt
			item = 10048,
			reagents = {
				{ 2997, 5 },
				{ 2604, 3 },
				{ 2321 },
			},
		},
		[12048] = { --Black Mageweave Vest
			item = 9998,
			reagents = {
				{ 4339, 2 },
				{ 4291, 3 },
			},
		},
		[12049] = { --Black Mageweave Leggings
			item = 9999,
			reagents = {
				{ 4339, 2 },
				{ 4291, 3 },
			},
		},
		[12050] = { --Black Mageweave Robe
			item = 10001,
			reagents = {
				{ 4339, 3 },
				{ 8343 },
			},
		},
		[12052] = { --Shadoweave Pants
			item = 10002,
			reagents = {
				{ 4339,  3 },
				{ 10285, 2 },
				{ 8343 },
			},
		},
		[12053] = { --Black Mageweave Gloves
			item = 10003,
			reagents = {
				{ 4339, 2 },
				{ 8343, 2 },
			},
		},
		[12055] = { --Shadoweave Robe
			item = 10004,
			reagents = {
				{ 4339,  3 },
				{ 10285, 2 },
				{ 8343 },
			},
		},
		[12056] = { --Red Mageweave Vest
			item = 10007,
			reagents = {
				{ 4339, 3 },
				{ 2604, 2 },
				{ 8343 },
			},
		},
		[12059] = { --White Bandit Mask
			item = 10008,
			reagents = {
				{ 4339 },
				{ 2324 },
				{ 8343 },
			},
		},
		[12060] = { --Red Mageweave Pants
			item = 10009,
			reagents = {
				{ 4339, 3 },
				{ 2604, 2 },
				{ 8343 },
			},
		},
		[12061] = { --Orange Mageweave Shirt
			item = 10056,
			reagents = {
				{ 4339 },
				{ 6261 },
				{ 8343 },
			},
		},
		[12062] = { --Stormcloth Pants
			item = 10010,
			reagents = {
				{ 4339, 4 },
				{ 7079, 2 },
				{ 8343, 2 },
			},
		},
		[12063] = { --Stormcloth Gloves
			item = 10011,
			reagents = {
				{ 4339, 3 },
				{ 7079, 2 },
				{ 8343, 2 },
			},
		},
		[12064] = { --Orange Martial Shirt
			item = 10052,
			reagents = {
				{ 4339, 2 },
				{ 6261, 2 },
				{ 8343 },
			},
		},
		[12065] = { --Mageweave Bag
			item = 10050,
			reagents = {
				{ 4339, 4 },
				{ 4291, 2 },
			},
		},
		[12066] = { --Red Mageweave Gloves
			item = 10018,
			reagents = {
				{ 4339, 3 },
				{ 2604, 2 },
				{ 8343, 2 },
			},
		},
		[12067] = { --Dreamweave Gloves
			item = 10019,
			reagents = {
				{ 4339,  4 },
				{ 8153,  4 },
				{ 10286, 2 },
				{ 8343,  2 },
			},
		},
		[12068] = { --Stormcloth Vest
			item = 10020,
			reagents = {
				{ 4339, 5 },
				{ 7079, 3 },
				{ 8343, 2 },
			},
		},
		[12069] = { --Cindercloth Robe
			item = 10042,
			reagents = {
				{ 4339, 5 },
				{ 7077, 2 },
				{ 8343, 2 },
			},
		},
		[12070] = { --Dreamweave Vest
			item = 10021,
			reagents = {
				{ 4339,  6 },
				{ 8153,  6 },
				{ 10286, 2 },
				{ 8343,  2 },
			},
		},
		[12071] = { --Shadoweave Gloves
			item = 10023,
			reagents = {
				{ 4339,  5 },
				{ 10285, 5 },
				{ 8343,  2 },
			},
		},
		[12072] = { --Black Mageweave Headband
			item = 10024,
			reagents = {
				{ 4339, 3 },
				{ 8343, 2 },
			},
		},
		[12073] = { --Black Mageweave Boots
			item = 10026,
			reagents = {
				{ 4339, 3 },
				{ 8343, 2 },
				{ 4304, 2 },
			},
		},
		[12074] = { --Black Mageweave Shoulders
			item = 10027,
			reagents = {
				{ 4339, 3 },
				{ 8343, 2 },
			},
		},
		[12075] = { --Lavender Mageweave Shirt
			item = 10054,
			reagents = {
				{ 4339, 2 },
				{ 4342, 2 },
				{ 8343, 2 },
			},
		},
		[12076] = { --Shadoweave Shoulders
			item = 10028,
			reagents = {
				{ 4339,  5 },
				{ 10285, 4 },
				{ 8343,  2 },
			},
		},
		[12077] = { --Simple Black Dress
			item = 10053,
			reagents = {
				{ 4339, 3 },
				{ 2325 },
				{ 8343 },
				{ 2324 },
			},
		},
		[12078] = { --Red Mageweave Shoulders
			item = 10029,
			reagents = {
				{ 4339, 4 },
				{ 2604, 2 },
				{ 8343, 3 },
			},
		},
		[12079] = { --Red Mageweave Bag
			item = 10051,
			reagents = {
				{ 4339, 4 },
				{ 2604, 2 },
				{ 8343, 2 },
			},
		},
		[12080] = { --Pink Mageweave Shirt
			item = 10055,
			reagents = {
				{ 4339, 3 },
				{ 10290 },
				{ 8343 },
			},
		},
		[12081] = { --Admiral's Hat
			item = 10030,
			reagents = {
				{ 4339, 3 },
				{ 4589, 6 },
				{ 8343, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 4339, 5 },
				{ 4589, 15 },
				{ 8343, 2 },
			},
		},
		[12082] = { --Shadoweave Boots
			item = 10031,
			reagents = {
				{ 4339,  6 },
				{ 10285, 6 },
				{ 8343,  3 },
				{ 4304,  2 },
			},
		},
		[12083] = { --Stormcloth Headband
			item = 10032,
			reagents = {
				{ 4339, 4 },
				{ 7079, 4 },
				{ 8343, 2 },
			},
		},
		[12084] = { --Red Mageweave Headband
			item = 10033,
			reagents = {
				{ 4339, 4 },
				{ 2604, 2 },
				{ 8343, 2 },
			},
		},
		[12085] = { --Tuxedo Shirt
			item = 10034,
			reagents = {
				{ 4339, 4 },
				{ 8343, 2 },
			},
		},
		[12086] = { --Shadoweave Mask
			item = 10025,
			reagents = {
				{ 4339,  2 },
				{ 10285, 8 },
				{ 8343,  2 },
			},
		},
		[12087] = { --Stormcloth Shoulders
			item = 10038,
			reagents = {
				{ 4339, 5 },
				{ 7079, 6 },
				{ 8343, 3 },
			},
		},
		[12088] = { --Cindercloth Boots
			item = 10044,
			reagents = {
				{ 4339, 5 },
				{ 7077 },
				{ 8343, 3 },
				{ 4304, 2 },
			},
		},
		[12089] = { --Tuxedo Pants
			item = 10035,
			reagents = {
				{ 4339, 4 },
				{ 8343, 3 },
			},
		},
		[12090] = { --Stormcloth Boots
			item = 10039,
			reagents = {
				{ 4339, 6 },
				{ 7079, 6 },
				{ 8343, 3 },
				{ 4304, 2 },
			},
		},
		[12091] = { --White Wedding Dress
			item = 10040,
			reagents = {
				{ 4339, 5 },
				{ 8343, 3 },
				{ 2324 },
			},
		},
		[12092] = { --Dreamweave Circlet
			item = 10041,
			reagents = {
				{ 4339,  8 },
				{ 8153,  4 },
				{ 10286, 2 },
				{ 8343,  3 },
				{ 6037 },
				{ 1529 },
			},
		},
		[12093] = { --Tuxedo Jacket
			item = 10036,
			reagents = {
				{ 4339, 5 },
				{ 8343, 3 },
			},
		},
		[12259] = { --Silvered Bronze Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 10423,
			reagents = {
				{ 2841, 12 },
				{ 2842, 4 },
				{ 3478, 2 },
			},
		},
		[12260] = { --Rough Copper Vest
			requires = L["Anvil"],
			tools = { 5956 },
			item = 10421,
			reagents = {
				{ 2840, 4 },
			},
		},
		[12332] = { --Lathoric the Black
			reagents = {
				{ 7970 },
			},
		},
		[12584] = { --Gold Power Core
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10558,
			reagents = {
				{ 3577 },
			},
		},
		[12585] = { --Solid Blasting Powder
			item = 10505,
			reagents = {
				{ 7912, 2 },
			},
		},
		[12586] = { --Solid Dynamite
			item = 10507,
			reagents = {
				{ 10505 },
				{ 4306 },
			},
		},
		[12587] = { --Bright-Eye Goggles
			tools = { 6219, 10498 },
			item = 10499,
			reagents = {
				{ 4234, 6 },
				{ 3864, 2 },
			},
		},
		[12589] = { --Mithril Tube
			requires = L["Anvil"],
			tools = { 5956 },
			item = 10559,
			reagents = {
				{ 3860, 3 },
			},
		},
		[12590] = { --Gyromatic Micro-Adjustor
			requires = L["Anvil"],
			tools = { 5956 },
			item = 10498,
			reagents = {
				{ 3859, 4 },
			},
		},
		[12591] = { --Unstable Trigger
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10560,
			reagents = {
				{ 3860 },
				{ 4338 },
				{ 10505 },
			},
		},
		[12594] = { --Fire Goggles
			tools = { 6219, 10498 },
			item = 10500,
			reagents = {
				{ 4385 },
				{ 3864, 2 },
				{ 7068, 2 },
				{ 4234, 4 },
			},
		},
		[12595] = { --Mithril Blunderbuss
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10508,
			reagents = {
				{ 10559 },
				{ 10560 },
				{ 4400 },
				{ 3860, 4 },
				{ 7068, 2 },
			},
		},
		[12596] = { --Hi-Impact Mithril Slugs
			tools = { 5956 },
			item = 10512,
			reagents = {
				{ 3860 },
				{ 10505 },
			},
		},
		[12597] = { --Deadly Scope
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10546,
			reagents = {
				{ 10559 },
				{ 7909, 2 },
				{ 4304, 2 },
			},
		},
		[12599] = { --Mithril Casing
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10561,
			reagents = {
				{ 3860, 3 },
			},
		},
		[12603] = { --Mithril Frag Bomb
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10514,
			reagents = {
				{ 10561 },
				{ 10560 },
				{ 10505 },
			},
		},
		[12607] = { --Catseye Ultra Goggles
			tools = { 6219, 10498 },
			item = 10501,
			reagents = {
				{ 4304, 4 },
				{ 7909, 2 },
				{ 10592 },
			},
		},
		[12609] = { --Catseye Elixir
			item = 10592,
			reagents = {
				{ 3821 },
				{ 3818 },
				{ 3372 },
			},
		},
		[12614] = { --Mithril Heavy-bore Rifle
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10510,
			reagents = {
				{ 10559, 2 },
				{ 10560 },
				{ 4400 },
				{ 3860,  6 },
				{ 3864,  2 },
			},
		},
		[12615] = { --Spellpower Goggles Xtreme
			tools = { 6219, 10498 },
			item = 10502,
			reagents = {
				{ 4304, 4 },
				{ 7910, 2 },
			},
		},
		[12616] = { --Parachute Cloak
			tools = { 6219, 10498 },
			item = 10518,
			reagents = {
				{ 4339,  4 },
				{ 10285, 2 },
				{ 10560 },
				{ 10505, 4 },
			},
		},
		[12617] = { --Deepdive Helmet
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10506,
			reagents = {
				{ 3860, 8 },
				{ 10561 },
				{ 6037 },
				{ 818,  4 },
				{ 774,  4 },
			},
		},
		[12618] = { --Rose Colored Goggles
			tools = { 6219, 10498 },
			item = 10503,
			reagents = {
				{ 4304, 6 },
				{ 7910, 2 },
			},
		},
		[12619] = { --Hi-Explosive Bomb
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10562,
			reagents = {
				{ 10561, 2 },
				{ 10560 },
				{ 10505, 2 },
			},
		},
		[12620] = { --Sniper Scope
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10548,
			reagents = {
				{ 10559 },
				{ 7910 },
				{ 6037, 2 },
			},
		},
		[12621] = { --Mithril Gyro-Shot
			requires = L["Anvil"],
			tools = { 5956 },
			item = 10513,
			reagents = {
				{ 3860,  2 },
				{ 10505, 2 },
			},
		},
		[12622] = { --Green Lens
			extra = Colors.GREEN .. L["<Random enchantment>"],
			tools = { 6219, 10498 },
			item = 10504,
			reagents = {
				{ 4304,  8 },
				{ 1529,  3 },
				{ 7909,  3 },
				{ 10286, 2 },
				{ 8153,  2 },
			},
		},
		[12624] = { --Mithril Mechanical Dragonling
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10576,
			reagents = {
				{ 3860, 14 },
				{ 7077, 4 },
				{ 6037, 4 },
				{ 9060, 2 },
				{ 9061, 2 },
				{ 7910, 2 },
			},
		},
		[12715] = { --Goblin Rocket Fuel Recipe
			item = 10644,
			reagents = {
				{ 10648 },
				{ 10647 },
			},
		},
		[12716] = { --Goblin Mortar
			requires = L["Anvil"],
			extra = Colors.WHITE .. "6 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 10577,
			reagents = {
				{ 10559, 2 },
				{ 3860,  4 },
				{ 10505, 5 },
				{ 10558 },
				{ 7068 },
			},
		},
		[12717] = { --Goblin Mining Helmet
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10542,
			reagents = {
				{ 3860, 8 },
				{ 3864 },
				{ 7067, 4 },
			},
		},
		[12718] = { --Goblin Construction Helmet
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10543,
			reagents = {
				{ 3860, 8 },
				{ 3864 },
				{ 7068, 4 },
			},
		},
		[12719] = { --Explosive Arrow
			tools = { 6219, 10498 },
			item = 10579,
			reagents = {
				{ 3030,  100 },
				{ 10505, 2 },
				{ 3860,  2 },
			},
		},
		[12720] = { --Goblin \"Boom\" Box
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10580,
			reagents = {
				{ 10561 },
				{ 10505, 2 },
				{ 10558 },
				{ 3860,  2 },
			},
		},
		[12722] = { --Goblin Radio
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10585,
			reagents = {
				{ 10561 },
				{ 3860, 2 },
				{ 4389 },
				{ 10560 },
			},
		},
		[12754] = { --The Big One
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10586,
			reagents = {
				{ 10561 },
				{ 9061 },
				{ 10507, 6 },
				{ 10560 },
			},
		},
		[12755] = { --Goblin Bomb Dispenser
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10587,
			reagents = {
				{ 10561, 2 },
				{ 10505, 4 },
				{ 6037,  6 },
				{ 10560 },
				{ 4407,  2 },
			},
		},
		[12758] = { --Goblin Rocket Helmet
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10588,
			reagents = {
				{ 10543 },
				{ 9061, 4 },
				{ 3860, 4 },
				{ 10560 },
			},
		},
		[12759] = { --Gnomish Death Ray
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10645,
			reagents = {
				{ 10559, 2 },
				{ 10560 },
				{ 12808 },
				{ 7972,  4 },
				{ 9060 },
			},
		},
		[12760] = { --Goblin Sapper Charge
			item = 10646,
			reagents = {
				{ 4338 },
				{ 10505, 3 },
				{ 10560 },
			},
		},
		[12895] = { --Inlaid Mithril Cylinder Plans
			item = 10713,
			reagents = {
				{ 10648 },
				{ 10647 },
			},
		},
		[12897] = { --Gnomish Goggles
			tools = { 6219, 10498 },
			item = 10545,
			reagents = {
				{ 10500 },
				{ 10559 },
				{ 10558, 2 },
				{ 8151,  2 },
				{ 4234,  2 },
			},
		},
		[12899] = { --Gnomish Shrink Ray
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10716,
			reagents = {
				{ 10559 },
				{ 10560 },
				{ 3860, 4 },
				{ 8151, 4 },
				{ 1529, 2 },
			},
		},
		[12900] = { --Mobile Alarm
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10719,
			reagents = {
				{ 10559 },
				{ 10560 },
				{ 3860, 4 },
			},
		},
		[12902] = { --Gnomish Net-o-Matic Projector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10720,
			reagents = {
				{ 10559 },
				{ 10285, 2 },
				{ 4337,  4 },
				{ 10505, 2 },
				{ 3860,  4 },
			},
		},
		[12903] = { --Gnomish Harm Prevention Belt
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10721,
			reagents = {
				{ 7387 },
				{ 3860, 4 },
				{ 6037, 2 },
				{ 10560 },
				{ 7909, 2 },
			},
		},
		[12904] = { --Gnomish Ham Radio
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10723,
			reagents = {
				{ 10561 },
				{ 3860, 2 },
				{ 4389 },
				{ 10560 },
			},
		},
		[12905] = { --Gnomish Rocket Boots
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10724,
			reagents = {
				{ 10026 },
				{ 10559, 2 },
				{ 4234,  4 },
				{ 10505, 8 },
				{ 4389,  4 },
			},
		},
		[12906] = { --Gnomish Battle Chicken
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10725,
			reagents = {
				{ 10561 },
				{ 6037, 6 },
				{ 3860, 6 },
				{ 9060, 2 },
				{ 10558 },
				{ 1529, 2 },
			},
		},
		[12907] = { --Gnomish Mind Control Cap
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10726,
			reagents = {
				{ 3860, 10 },
				{ 6037, 4 },
				{ 10558 },
				{ 7910, 2 },
				{ 4338, 4 },
			},
		},
		[12908] = { --Goblin Dragon Gun
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 10727,
			reagents = {
				{ 10559, 2 },
				{ 9061,  4 },
				{ 3860,  6 },
				{ 6037,  6 },
				{ 10560 },
			},
		},
		[13028] = { --Goldthorn Tea
			requires = L["Cooking Fire"],
			item = 10841,
			reagents = {
				{ 3821 },
				{ 159 },
			},
		},
		[13220] = {
			item = 10918,
			reagents = {
				{ 2930 },
				{ 5173 },
				{ 3372 },
			},
		},
		[13228] = {
			item = 10920,
			reagents = {
				{ 2930 },
				{ 5173, 2 },
				{ 3372 },
			},
		},
		[13229] = {
			item = 10921,
			reagents = {
				{ 8923 },
				{ 5173, 2 },
				{ 8925 },
			},
		},
		[13230] = {
			item = 10922,
			reagents = {
				{ 8923, 2 },
				{ 5173, 2 },
				{ 8925 },
			},
		},
		[13240] = { --The Mortar: Reloaded
			requires = L["Anvil"],
			text = LS["Reloads an empty Goblin mortar."],
			extra = Colors.WHITE .. "6 " .. L["Charges"],
			tools = { 5956, 6219 },
			item = 10577,
			reagents = {
				{ 10577 },
				{ 3860 },
				{ 10505, 3 },
			},
		},
		[14379] = { --Golden Rod
			requires = L["Anvil"],
			tools = { 5956 },
			item = 11128,
			reagents = {
				{ 3577 },
				{ 3478, 2 },
			},
		},
		[14380] = { --Truesilver Rod
			requires = L["Anvil"],
			tools = { 5956 },
			item = 11144,
			reagents = {
				{ 6037 },
				{ 3486 },
			},
		},
		[14891] = { --Smelt Dark Iron
			name = LS["Smelting: Smelt Dark Iron"],
			requires = L["Black Forge"],
			item = 11371,
			reagents = {
				{ 11370, 8 },
			},
		},
		[14930] = { --Quickdraw Quiver
			item = 8217,
			reagents = {
				{ 4304, 12 },
				{ 8172 },
				{ 8949 },
				{ 4291, 4 },
			},
		},
		[14932] = { --Thick Leather Ammo Pouch
			item = 8218,
			reagents = {
				{ 4304, 10 },
				{ 8172 },
				{ 8951 },
				{ 4291, 6 },
			},
		},
		[15255] = { --Mechanical Repair Kit
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 11590,
			reagents = {
				{ 3860 },
				{ 4338 },
				{ 10505 },
			},
		},
		[15292] = { --Dark Iron Pulverizer
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 11608,
			reagents = {
				{ 11371, 18 },
				{ 7077,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 18 },
				{ 7077,  6 },
				{ 7067,  6 },
			},
		},
		[15293] = { --Dark Iron Mail
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 11606,
			reagents = {
				{ 11371, 10 },
				{ 7077,  2 },
			},
		},
		[15294] = { --Dark Iron Sunderer
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 11607,
			reagents = {
				{ 11371, 26 },
				{ 7077,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 26 },
				{ 7077,  6 },
				{ 12644, 6 },
				{ 6043 },
			},
		},
		[15295] = { --Dark Iron Shoulders
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 11605,
			reagents = {
				{ 11371, 6 },
				{ 7077 },
			},
		},
		[15296] = { --Dark Iron Plate
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 11604,
			reagents = {
				{ 11371, 20 },
				{ 7077,  8 },
			},
		},
		[15628] = { --Pet Bombling
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 11825,
			reagents = {
				{ 4394 },
				{ 7077 },
				{ 7191 },
				{ 3860, 6 },
			},
		},
		[15633] = { --Lil' Smoky
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 11826,
			reagents = {
				{ 7075 },
				{ 4389, 2 },
				{ 7191 },
				{ 3860, 2 },
				{ 6037 },
			},
		},
		[15833] = { --Dreamless Sleep Potion
			item = 12190,
			reagents = {
				{ 8831, 3 },
				{ 8925 },
			},
		},
		[15853] = { --Lean Wolf Steak
			requires = L["Cooking Fire"],
			item = 12209,
			reagents = {
				{ 1015 },
				{ 2678 },
			},
		},
		[15855] = { --Roast Raptor
			requires = L["Cooking Fire"],
			item = 12210,
			reagents = {
				{ 12184 },
				{ 2692 },
			},
		},
		[15856] = { --Hot Wolf Ribs
			requires = L["Cooking Fire"],
			item = 13851,
			reagents = {
				{ 12203 },
				{ 2692 },
			},
		},
		[15861] = { --Jungle Stew
			requires = L["Cooking Fire"],
			item = 12212,
			reagents = {
				{ 12202 },
				{ 159 },
				{ 4536, 2 },
			},
		},
		[15863] = { --Carrion Surprise
			requires = L["Cooking Fire"],
			item = 12213,
			reagents = {
				{ 12037 },
				{ 2692 },
			},
		},
		[15865] = { --Mystery Stew
			requires = L["Cooking Fire"],
			item = 12214,
			reagents = {
				{ 12037 },
				{ 2596 },
			},
		},
		[15906] = { --Dragonbreath Chili
			requires = L["Cooking Fire"],
			item = 12217,
			reagents = {
				{ 12037 },
				{ 4402 },
				{ 2692 },
			},
		},
		[15910] = { --Heavy Kodo Stew
			requires = L["Cooking Fire"],
			item = 12215,
			reagents = {
				{ 12204, 2 },
				{ 3713 },
				{ 159 },
			},
		},
		[15915] = { --Spiced Chili Crab
			requires = L["Cooking Fire"],
			item = 12216,
			reagents = {
				{ 12206 },
				{ 2692, 2 },
			},
		},
		[15933] = { --Monster Omelet
			requires = L["Cooking Fire"],
			item = 12218,
			reagents = {
				{ 12207 },
				{ 3713, 2 },
			},
		},
		[15935] = { --Crispy Bat Wing
			requires = L["Cooking Fire"],
			item = 12224,
			reagents = {
				{ 12223 },
				{ 2678 },
			},
		},
		[15972] = { --Glinting Steel Dagger
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12259,
			reagents = {
				{ 3859, 10 },
				{ 3466, 2 },
				{ 1206 },
				{ 7067 },
				{ 4234 },
			},
		},
		[15973] = { --Searing Golden Blade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12260,
			reagents = {
				{ 3859, 10 },
				{ 3577, 4 },
				{ 7068, 2 },
				{ 4234, 2 },
			},
		},
		[16153] = { --Smelt Thorium
			name = LS["Smelting: Smelt Thorium"],
			requires = L["Forge"],
			item = 12359,
			reagents = {
				{ 10620 },
			},
		},
		[16639] = { --Dense Grinding Stone
			item = 12644,
			reagents = {
				{ 12365, 4 },
			},
		},
		[16640] = { --Dense Weightstone
			item = 12643,
			reagents = {
				{ 12365 },
				{ 14047 },
			},
		},
		[16641] = { --Dense Sharpening Stone
			item = 12404,
			reagents = {
				{ 12365 },
			},
		},
		[16642] = { --Thorium Armor
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12405,
			reagents = {
				{ 12359, 16 },
				{ 12361 },
				{ 11188, 4 },
			},
		},
		[16643] = { --Thorium Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12406,
			reagents = {
				{ 12359, 12 },
				{ 11186, 4 },
			},
		},
		[16644] = { --Thorium Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12408,
			reagents = {
				{ 12359, 12 },
				{ 11184, 4 },
			},
		},
		[16645] = { --Radiant Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12416,
			reagents = {
				{ 12359, 10 },
				{ 7077,  2 },
			},
		},
		[16646] = { --Imperial Plate Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12428,
			reagents = {
				{ 12359, 24 },
				{ 8170,  6 },
				{ 3864,  2 },
			},
		},
		[16647] = { --Imperial Plate Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12424,
			reagents = {
				{ 12359, 22 },
				{ 8170,  6 },
				{ 7909 },
			},
		},
		[16648] = { --Radiant Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12415,
			reagents = {
				{ 12359, 18 },
				{ 7077,  2 },
				{ 7910 },
			},
		},
		[16649] = { --Imperial Plate Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12425,
			reagents = {
				{ 12359, 20 },
				{ 7910 },
			},
		},
		[16650] = { --Wildthorn Mail
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12624,
			reagents = {
				{ 12359, 40 },
				{ 12655, 2 },
				{ 12803, 4 },
				{ 8153,  4 },
				{ 12364 },
			},
		},
		[16651] = { --Thorium Shield Spike
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12645,
			reagents = {
				{ 12359, 4 },
				{ 12644, 4 },
				{ 7076,  2 },
			},
		},
		[16652] = { --Thorium Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12409,
			reagents = {
				{ 12359, 20 },
				{ 8170,  8 },
				{ 11185, 4 },
			},
		},
		[16653] = { --Thorium Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12410,
			reagents = {
				{ 12359, 24 },
				{ 7910 },
				{ 11188, 4 },
			},
		},
		[16654] = { --Radiant Gloves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12418,
			reagents = {
				{ 12359, 18 },
				{ 7077,  4 },
			},
		},
		[16655] = { --Fiery Plate Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12631,
			reagents = {
				{ 12359, 20 },
				{ 12655, 6 },
				{ 7078,  2 },
				{ 7910,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 20 },
				{ 12655, 20 },
				{ 7078,  12 },
				{ 13457, 12 },
				{ 7910,  5 },
			},
		},
		[16656] = { --Radiant Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12419,
			reagents = {
				{ 12359, 14 },
				{ 7077,  4 },
			},
		},
		[16657] = { --Imperial Plate Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12426,
			reagents = {
				{ 12359, 34 },
				{ 7910 },
				{ 7909 },
			},
		},
		[16658] = { --Imperial Plate Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12427,
			reagents = {
				{ 12359, 34 },
				{ 7910,  2 },
			},
		},
		[16659] = { --Radiant Circlet
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12417,
			reagents = {
				{ 12359, 18 },
				{ 7077,  4 },
			},
		},
		[16660] = { --Dawnbringer Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12625,
			reagents = {
				{ 12359, 20 },
				{ 12360, 4 },
				{ 12364, 2 },
				{ 7080,  2 },
			},
		},
		[16661] = { --Storm Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12632,
			reagents = {
				{ 12359, 20 },
				{ 12655, 4 },
				{ 7080,  4 },
				{ 12361, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 20 },
				{ 12655, 10 },
				{ 7080,  5 },
				{ 7076,  5 },
				{ 12803, 5 },
				{ 12361, 6 },
			},
		},
		[16662] = { --Thorium Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12414,
			reagents = {
				{ 12359, 26 },
				{ 11186, 4 },
			},
		},
		[16663] = { --Imperial Plate Chest
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12422,
			reagents = {
				{ 12359, 40 },
				{ 7910,  2 },
			},
		},
		[16664] = { --Runic Plate Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12610,
			reagents = {
				{ 12359, 20 },
				{ 12360, 2 },
				{ 3577,  6 },
			},
		},
		[16665] = { --Runic Plate Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12611,
			reagents = {
				{ 12359, 20 },
				{ 12360, 2 },
				{ 2842,  10 },
			},
		},
		[16667] = { --Demon Forged Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12628,
			reagents = {
				{ 12359, 40 },
				{ 12662, 10 },
				{ 12361, 4 },
				{ 7910,  4 },
			},
		},
		[16724] = { --Whitesoul Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12633,
			reagents = {
				{ 12359, 20 },
				{ 12655, 4 },
				{ 6037,  6 },
				{ 3577,  6 },
				{ 12800, 2 },
			},
		},
		[16725] = { --Radiant Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12420,
			reagents = {
				{ 12359, 20 },
				{ 7077,  4 },
			},
		},
		[16726] = { --Runic Plate Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12612,
			reagents = {
				{ 12359, 30 },
				{ 12360, 2 },
				{ 6037,  2 },
				{ 12364 },
			},
		},
		[16728] = { --Helm of the Great Chief
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12636,
			reagents = {
				{ 12359, 40 },
				{ 12655, 4 },
				{ 8168,  60 },
				{ 12799, 6 },
				{ 12364, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 40 },
				{ 12655, 10 },
				{ 8168,  60 },
				{ 12799, 6 },
				{ 12364, 4 },
				{ 12809, 3 },
			},
		},
		[16729] = { --Lionheart Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12640,
			reagents = {
				{ 12359, 80 },
				{ 12360, 12 },
				{ 8146,  40 },
				{ 12361, 10 },
				{ 12800, 4 },
			},
		},
		[16730] = { --Imperial Plate Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12429,
			reagents = {
				{ 12359, 44 },
				{ 7910,  2 },
			},
		},
		[16731] = { --Runic Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12613,
			reagents = {
				{ 12359, 40 },
				{ 12360, 2 },
				{ 7910 },
			},
		},
		[16732] = { --Runic Plate Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12614,
			reagents = {
				{ 12359, 40 },
				{ 12360, 2 },
				{ 7910 },
			},
		},
		[16741] = { --Stronghold Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12639,
			reagents = {
				{ 12360, 15 },
				{ 12655, 20 },
				{ 7076,  10 },
				{ 12361, 4 },
				{ 12799, 4 },
			},
		},
		[16742] = { --Enchanted Thorium Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12620,
			reagents = {
				{ 12360, 6 },
				{ 12655, 16 },
				{ 7076,  6 },
				{ 12799, 2 },
				{ 12800 },
			},
		},
		[16744] = { --Enchanted Thorium Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12619,
			reagents = {
				{ 12360, 10 },
				{ 12655, 20 },
				{ 7080,  6 },
				{ 12361, 2 },
				{ 12364 },
			},
		},
		[16745] = { --Enchanted Thorium Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12618,
			reagents = {
				{ 12360, 8 },
				{ 12655, 24 },
				{ 7076,  4 },
				{ 7080,  4 },
				{ 12364, 2 },
				{ 12800, 2 },
			},
		},
		[16746] = { --Invulnerable Mail
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12641,
			reagents = {
				{ 12360, 30 },
				{ 12655, 30 },
				{ 12364, 6 },
				{ 12800, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 30 },
				{ 12655, 40 },
				{ 12364, 8 },
				{ 12800, 8 },
				{ 12809, 5 },
			},
			reagents_TURTLE1 = {
				{ 12360, 20 },
				{ 12655, 20 },
				{ 12364, 6 },
				{ 12800, 6 },
			},
		},
		[16960] = { --Thorium Greatsword
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12764,
			reagents = {
				{ 12359, 16 },
				{ 12644, 2 },
				{ 8170,  4 },
			},
		},
		[16965] = { --Bleakwood Hew
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12769,
			reagents = {
				{ 12359, 30 },
				{ 12803, 6 },
				{ 8153,  6 },
				{ 12799, 6 },
				{ 12644, 2 },
				{ 8170,  8 },
			},
		},
		[16967] = { --Inlaid Thorium Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12772,
			reagents = {
				{ 12359, 30 },
				{ 3577,  4 },
				{ 6037,  2 },
				{ 12361, 2 },
				{ 8170,  4 },
			},
		},
		[16969] = { --Ornate Thorium Handaxe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12773,
			reagents = {
				{ 12359, 20 },
				{ 12799, 2 },
				{ 12644, 2 },
				{ 8170,  4 },
			},
		},
		[16970] = { --Dawn's Edge
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12774,
			reagents = {
				{ 12359, 30 },
				{ 12655, 4 },
				{ 7910,  4 },
				{ 12361, 4 },
				{ 12644, 2 },
				{ 8170,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 25 },
				{ 12655, 10 },
				{ 7910,  4 },
				{ 12361, 4 },
				{ 12644, 6 },
				{ 8170,  6 },
			},
		},
		[16971] = { --Huge Thorium Battleaxe
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12775,
			reagents = {
				{ 12359, 40 },
				{ 12644, 6 },
				{ 8170,  6 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 100 },
				{ 12644, 10 },
				{ 8170,  8 },
				{ 12799, 4 },
			},
		},
		[16973] = { --Enchanted Battlehammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12776,
			reagents = {
				{ 12359, 20 },
				{ 12655, 6 },
				{ 12364, 2 },
				{ 12804, 4 },
				{ 8170,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 20 },
				{ 12655, 12 },
				{ 12364, 3 },
				{ 12804, 6 },
				{ 8170,  4 },
			},
		},
		[16978] = { --Blazing Rapier
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12777,
			reagents = {
				{ 12655, 10 },
				{ 7078,  4 },
				{ 7077,  4 },
				{ 12800, 2 },
				{ 12644, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12655, 20 },
				{ 15407 },
				{ 7078,  8 },
				{ 7077,  8 },
				{ 12800, 4 },
				{ 12644, 4 },
			},
		},
		[16980] = { --Rune Edge
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12779,
			reagents = {
				{ 12359, 30 },
				{ 12799, 2 },
				{ 12644, 2 },
				{ 8170,  4 },
			},
		},
		[16983] = { --Serenity
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12781,
			reagents = {
				{ 12655, 6 },
				{ 12360, 2 },
				{ 12804, 4 },
				{ 12799, 2 },
				{ 12361, 2 },
				{ 12364 },
			},
			reagents_VANILLA_PLUS = {
				{ 12655, 10 },
				{ 12360 },
				{ 12804, 6 },
				{ 12799, 2 },
				{ 12361, 2 },
				{ 12364, 2 },
			},
		},
		[16984] = { --Volcanic Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12792,
			reagents = {
				{ 12359, 30 },
				{ 7077,  4 },
				{ 7910,  4 },
				{ 8170,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 40 },
				{ 7077,  8 },
				{ 7910,  4 },
				{ 8170,  6 },
				{ 11382 },
			},
		},
		[16985] = { --Corruption
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12782,
			reagents = {
				{ 12359, 40 },
				{ 12360, 2 },
				{ 12662, 16 },
				{ 12808, 8 },
				{ 12361, 2 },
				{ 12644, 2 },
				{ 8170,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 40 },
				{ 12360, 2 },
				{ 12662, 16 },
				{ 12808, 16 },
				{ 7972,  16 },
				{ 12361, 2 },
				{ 8170,  6 },
			},
		},
		[16986] = { --Blood Talon
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12795,
			reagents = {
				{ 12655, 10 },
				{ 12360, 10 },
				{ 12662, 8 },
				{ 7910,  10 },
				{ 12644, 2 },
			},
		},
		[16987] = { --Darkspear
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12802,
			reagents = {
				{ 12655, 20 },
				{ 12804, 20 },
				{ 12364, 2 },
				{ 12800, 2 },
				{ 12644, 2 },
			},
		},
		[16988] = { --Hammer of the Titans
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12796,
			reagents = {
				{ 12359, 50 },
				{ 12360, 15 },
				{ 12809, 4 },
				{ 12810, 6 },
				{ 7076,  10 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 80 },
				{ 12360, 12 },
				{ 12809, 8 },
				{ 12810, 8 },
				{ 7076,  15 },
			},
		},
		[16990] = { --Arcanite Champion
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12790,
			reagents = {
				{ 12360, 15 },
				{ 12800, 8 },
				{ 12811 },
				{ 12799, 4 },
				{ 12810, 8 },
				{ 12644, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 15 },
				{ 12800, 8 },
				{ 12811, 4 },
				{ 13180, 10 },
				{ 12799, 8 },
				{ 12810, 8 },
				{ 12644, 4 },
			},
			reagents_TURTLE1 = {
				{ 12360, 10 },
				{ 12800, 8 },
				{ 12811 },
				{ 12799, 4 },
				{ 12810, 8 },
				{ 12644, 2 },
			},
		},
		[16991] = { --Annihilator
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12798,
			reagents = {
				{ 12359, 40 },
				{ 12360, 12 },
				{ 12808, 10 },
				{ 12364, 8 },
				{ 12644, 2 },
				{ 12810, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12359, 40 },
				{ 12360, 12 },
				{ 12808, 15 },
				{ 12364, 8 },
				{ 12644, 4 },
				{ 12810, 8 },
			},
		},
		[16992] = { --Frostguard
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12797,
			reagents = {
				{ 12360, 18 },
				{ 12361, 8 },
				{ 12800, 8 },
				{ 7080,  4 },
				{ 12644, 2 },
				{ 12810, 4 },
			},
		},
		[16993] = { --Masterwork Stormhammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12794,
			reagents = {
				{ 12655, 20 },
				{ 12364, 8 },
				{ 12799, 8 },
				{ 7076,  6 },
				{ 12810, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12655, 40 },
				{ 12364, 8 },
				{ 12799, 8 },
				{ 7076,  15 },
				{ 7080,  15 },
				{ 12810, 6 },
			},
		},
		[16994] = { --Arcanite Reaper
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12784,
			reagents = {
				{ 12360, 20 },
				{ 12810, 6 },
				{ 12644, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 20 },
				{ 12810, 10 },
				{ 12644, 10 },
				{ 13453, 5 },
			},
			reagents_TURTLE1 = {
				{ 12360, 14 },
				{ 12810, 6 },
				{ 12644, 2 },
			},
		},
		[16995] = { --Heartseeker
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12783,
			reagents = {
				{ 12360, 10 },
				{ 12655, 10 },
				{ 12810, 2 },
				{ 7910,  6 },
				{ 12800, 6 },
				{ 12799, 6 },
				{ 12644, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 10 },
				{ 12655, 10 },
				{ 12810, 4 },
				{ 7910,  6 },
				{ 12800, 6 },
				{ 12799, 6 },
				{ 12644, 4 },
			},
		},
		[17187] = { --Transmute: Arcanite
			tools = { 9149 },
			item = 12360,
			reagents = {
				{ 12359 },
				{ 12363 },
			},
		},
		[17527] = { --Mighty Rage Potion
			item = 5633,
			reagents = {
				{ 5637 },
				{ 3356 },
				{ 3372 },
			},
		},
		[17551] = { --Stonescale Oil
			item = 13423,
			reagents = {
				{ 13422 },
				{ 3372 },
			},
		},
		[17552] = { --Mighty Rage Potion
			item = 13442,
			reagents = {
				{ 8846, 3 },
				{ 8925 },
			},
		},
		[17553] = { --Superior Mana Potion
			item = 13443,
			reagents = {
				{ 8838, 2 },
				{ 8839, 2 },
				{ 8925 },
			},
		},
		[17554] = { --Elixir of Superior Defense
			item = 13445,
			reagents = {
				{ 13423, 2 },
				{ 8838 },
				{ 8925 },
			},
		},
		[17555] = { --Elixir of the Sages
			item = 13447,
			reagents = {
				{ 13463 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[17556] = { --Major Healing Potion
			item = 13446,
			reagents = {
				{ 13464, 2 },
				{ 13465 },
				{ 8925 },
			},
		},
		[17557] = { --Elixir of Brute Force
			item = 13453,
			reagents = {
				{ 8846,  2 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[17559] = { --Transmute: Air to Fire
			tools = { 9149 },
			item = 7078,
			reagents = {
				{ 7082 },
			},
			reagents_VANILLA_PLUS = {
				{ 7082 },
				{ 16204 },
			},
		},
		[17560] = { --Transmute: Fire to Earth
			tools = { 9149 },
			item = 7076,
			reagents = {
				{ 7078 },
			},
			reagents_VANILLA_PLUS = {
				{ 7078 },
				{ 16204 },
			},
		},
		[17561] = { --Transmute: Earth to Water
			tools = { 9149 },
			item = 7080,
			reagents = {
				{ 7076 },
			},
			reagents_VANILLA_PLUS = {
				{ 7076 },
				{ 16204 },
			},
		},
		[17562] = { --Transmute: Water to Air
			tools = { 9149 },
			item = 7082,
			reagents = {
				{ 7080 },
			},
			reagents_VANILLA_PLUS = {
				{ 7080 },
				{ 16204 },
			},
		},
		[17563] = { --Transmute: Undeath to Water
			tools = { 9149 },
			item = 7080,
			reagents = {
				{ 12808 },
			},
			reagents_VANILLA_PLUS = {
				{ 12808 },
				{ 16204 },
			},
		},
		[17564] = { --Transmute: Water to Undeath
			tools = { 9149 },
			item = 12808,
			reagents = {
				{ 7080 },
			},
			reagents_VANILLA_PLUS = {
				{ 7080 },
				{ 16204 },
			},
		},
		[17565] = { --Transmute: Life to Earth
			tools = { 9149 },
			item = 7076,
			reagents = {
				{ 12803 },
			},
			reagents_VANILLA_PLUS = {
				{ 12803 },
				{ 16204 },
			},
		},
		[17566] = { --Transmute: Earth to Life
			tools = { 9149 },
			item = 12803,
			reagents = {
				{ 7076 },
			},
			reagents_VANILLA_PLUS = {
				{ 7076 },
				{ 16204 },
			},
		},
		[17570] = { --Greater Stoneshield Potion
			item = 13455,
			reagents = {
				{ 13423, 3 },
				{ 10620 },
				{ 8925 },
			},
		},
		[17571] = { --Elixir of the Mongoose
			item = 13452,
			reagents = {
				{ 13465, 2 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[17572] = { --Purification Potion
			item = 13462,
			reagents = {
				{ 13467, 2 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[17573] = { --Greater Arcane Elixir
			item = 13454,
			reagents = {
				{ 13463, 3 },
				{ 13465 },
				{ 8925 },
			},
		},
		[17574] = { --Greater Fire Protection Potion
			item = 13457,
			reagents = {
				{ 7068 },
				{ 13463 },
				{ 8925 },
			},
			reagents_TURTLE1 = {
				{ 7068 },
				{ 4625 },
				{ 8925 },
			},
		},
		[17575] = { --Greater Frost Protection Potion
			item = 13456,
			reagents = {
				{ 7070 },
				{ 13463 },
				{ 8925 },
			},
			reagents_TURTLE1 = {
				{ 7070 },
				{ 13467 },
				{ 8925 },
			},
		},
		[17576] = { --Greater Nature Protection Potion
			item = 13458,
			reagents = {
				{ 7067 },
				{ 13463 },
				{ 8925 },
			},
		},
		[17577] = { --Greater Arcane Protection Potion
			item = 13461,
			reagents = {
				{ 11176 },
				{ 13463 },
				{ 8925 },
			},
		},
		[17578] = { --Greater Shadow Protection Potion
			item = 13459,
			reagents = {
				{ 3824 },
				{ 13463 },
				{ 8925 },
			},
			reagents_TURTLE1 = {
				{ 3824 },
				{ 8836, 2 },
				{ 8925 },
			},
		},
		[17579] = { --Greater Holy Protection Potion
			item = 13460,
			reagents = {
				{ 7069 },
				{ 13463 },
				{ 8925 },
			},
			reagents_TURTLE1 = {
				{ 7069 },
				{ 13464 },
				{ 8925 },
			},
		},
		[17580] = { --Major Mana Potion
			item = 13444,
			reagents = {
				{ 13463, 3 },
				{ 13467, 2 },
				{ 8925 },
			},
			reagents_TURTLE1 = {
				{ 13463, 2 },
				{ 13467, 2 },
				{ 8925 },
			},
		},
		[17632] = { --Alchemist's Stone
			item = 13503,
			reagents = {
				{ 7078,  8 },
				{ 7076,  8 },
				{ 7082,  8 },
				{ 7080,  8 },
				{ 12803, 8 },
				{ 9262,  2 },
				{ 13468, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 7078,  16 },
				{ 7076,  16 },
				{ 7082,  16 },
				{ 7080,  16 },
				{ 12803, 16 },
				{ 9262,  8 },
				{ 13468, 6 },
			},
		},
		[17634] = { --Flask of Petrification
			tools = { 9149 },
			item = 13506,
			reagents = {
				{ 13423, 30 },
				{ 13465, 10 },
				{ 13468 },
				{ 8925 },
			},
		},
		[17635] = { --Flask of the Titans
			item = 13510,
			tools_VANILLA_PLUS = { 9149 },
			reagents = {
				{ 8846,  30 },
				{ 13423, 10 },
				{ 13468 },
				{ 8925 },
			},
			reagents_TURTLE = {
				{ 13464, 30 },
				{ 13423, 10 },
				{ 13468 },
				{ 8925 },
			},
		},
		[17636] = { --Flask of Distilled Wisdom
			item = 13511,
			tools_VANILLA_PLUS = { 9149 },
			reagents = {
				{ 13463, 30 },
				{ 13467, 10 },
				{ 13468 },
				{ 8925 },
			},
			reagents_TURTLE = {
				{ 8838,  30 },
				{ 13467, 10 },
				{ 13468 },
				{ 8925 },
			},
		},
		[17637] = { --Flask of Supreme Power
			item = 13512,
			reagents = {
				{ 13463, 30 },
				{ 13465, 10 },
				{ 13468 },
				{ 8925 },
			},
			tools_VANILLA_PLUS = { 9149 },
		},
		[17638] = { --Flask of Chromatic Resistance
			item = 13513,
			reagents = {
				{ 13467, 30 },
				{ 13465, 10 },
				{ 13468 },
				{ 8925 },
			},
			tools_VANILLA_PLUS = { 9149 },
		},
		[18238] = { --Spotted Yellowtail
			requires = L["Cooking Fire"],
			item = 6887,
			reagents = {
				{ 4603 },
			},
		},
		[18239] = { --Cooked Glossy Mightfish
			requires = L["Cooking Fire"],
			item = 13927,
			reagents = {
				{ 13754 },
				{ 3713 },
			},
		},
		[18240] = { --Grilled Squid
			requires = L["Cooking Fire"],
			item = 13928,
			reagents = {
				{ 13755 },
				{ 3713 },
			},
		},
		[18241] = { --Filet of Redgill
			requires = L["Cooking Fire"],
			item = 13930,
			reagents = {
				{ 13758 },
			},
		},
		[18242] = { --Hot Smoked Bass
			requires = L["Cooking Fire"],
			item = 13929,
			reagents = {
				{ 13756 },
				{ 2692, 2 },
			},
		},
		[18243] = { --Nightfin Soup
			requires = L["Cooking Fire"],
			item = 13931,
			reagents = {
				{ 13759 },
				{ 159 },
			},
		},
		[18244] = { --Poached Sunscale Salmon
			requires = L["Cooking Fire"],
			item = 13932,
			reagents = {
				{ 13760 },
			},
		},
		[18245] = { --Lobster Stew
			requires = L["Cooking Fire"],
			item = 13933,
			reagents = {
				{ 13888 },
				{ 159 },
			},
		},
		[18246] = { --Mightfish Steak
			requires = L["Cooking Fire"],
			item = 13934,
			reagents = {
				{ 13893 },
				{ 2692 },
				{ 3713 },
			},
		},
		[18247] = { --Baked Salmon
			requires = L["Cooking Fire"],
			item = 13935,
			reagents = {
				{ 13889 },
				{ 3713 },
			},
		},
		[18401] = { --Bolt of Runecloth
			item = 14048,
			reagents = {
				{ 14047, 5 },
			},
		},
		[18402] = { --Runecloth Belt
			item = 13856,
			reagents = {
				{ 14048, 3 },
				{ 14341 },
			},
		},
		[18403] = { --Frostweave Tunic
			item = 13869,
			reagents = {
				{ 14048, 5 },
				{ 7079,  2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 5 },
				{ 7079,  4 },
				{ 14341 },
			},
		},
		[18404] = { --Frostweave Robe
			item = 13868,
			reagents = {
				{ 14048, 5 },
				{ 7079,  2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 5 },
				{ 7079,  4 },
				{ 14341 },
			},
		},
		[18405] = { --Runecloth Bag
			item = 14046,
			reagents = {
				{ 14048, 5 },
				{ 8170,  2 },
				{ 14341 },
			},
		},
		[18406] = { --Runecloth Robe
			item = 13858,
			reagents = {
				{ 14048, 5 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18407] = { --Runecloth Tunic
			item = 13857,
			reagents = {
				{ 14048, 5 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18408] = { --Cindercloth Vest
			item = 14042,
			reagents = {
				{ 14048, 5 },
				{ 7077,  3 },
				{ 14341 },
			},
		},
		[18409] = { --Runecloth Cloak
			item = 13860,
			reagents = {
				{ 14048, 4 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18410] = { --Ghostweave Belt
			item = 14143,
			reagents = {
				{ 14048, 3 },
				{ 9210,  2 },
				{ 14227 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 4 },
				{ 9210,  2 },
				{ 14227, 2 },
				{ 14341 },
			},
		},
		[18411] = { --Frostweave Gloves
			item = 13870,
			reagents = {
				{ 14048, 3 },
				{ 7080 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 3 },
				{ 7080,  2 },
				{ 14341 },
			},
		},
		[18412] = { --Cindercloth Gloves
			item = 14043,
			reagents = {
				{ 14048, 4 },
				{ 7077,  3 },
				{ 14341 },
			},
		},
		[18413] = { --Ghostweave Gloves
			item = 14142,
			reagents = {
				{ 14048, 4 },
				{ 9210,  2 },
				{ 14227 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 6 },
				{ 9210,  3 },
				{ 14227, 2 },
				{ 14341 },
			},
		},
		[18414] = { --Brightcloth Robe
			item = 14100,
			reagents = {
				{ 14048, 5 },
				{ 3577,  2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 5 },
				{ 3577,  4 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18415] = { --Brightcloth Gloves
			item = 14101,
			reagents = {
				{ 14048, 4 },
				{ 3577,  2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 4 },
				{ 3577,  4 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18416] = { --Ghostweave Vest
			item = 14141,
			reagents = {
				{ 14048, 6 },
				{ 9210,  4 },
				{ 14227 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 9210,  6 },
				{ 14227, 2 },
				{ 14341, 2 },
			},
		},
		[18417] = { --Runecloth Gloves
			item = 13863,
			reagents = {
				{ 14048, 4 },
				{ 8170,  4 },
				{ 14341 },
			},
		},
		[18418] = { --Cindercloth Cloak
			item = 14044,
			reagents = {
				{ 14048, 5 },
				{ 7078 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 5 },
				{ 7078,  3 },
				{ 14341 },
			},
		},
		[18419] = { --Felcloth Pants
			item = 14107,
			reagents = {
				{ 14048, 5 },
				{ 14256, 4 },
				{ 14341 },
			},
		},
		[18420] = { --Brightcloth Cloak
			item = 14103,
			reagents = {
				{ 14048, 4 },
				{ 3577,  2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 4 },
				{ 3577,  4 },
				{ 14227 },
				{ 14341 },
			},
		},
		[18421] = { --Wizardweave Leggings
			item = 14132,
			reagents = {
				{ 14048, 6 },
				{ 11176 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 11176, 15 },
				{ 12804, 8 },
				{ 14341, 2 },
			},
		},
		[18422] = { --Cloak of Fire
			item = 14134,
			reagents = {
				{ 14048, 6 },
				{ 7078,  4 },
				{ 7077,  4 },
				{ 7068,  4 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 7078,  8 },
				{ 7077,  8 },
				{ 7068,  8 },
				{ 14341, 2 },
			},
		},
		[18423] = { --Runecloth Boots
			item = 13864,
			reagents = {
				{ 14048, 4 },
				{ 14227, 2 },
				{ 8170,  4 },
				{ 14341 },
			},
		},
		[18424] = { --Frostweave Pants
			item = 13871,
			reagents = {
				{ 14048, 6 },
				{ 7080 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 6 },
				{ 7080,  2 },
				{ 14341 },
			},
		},
		[18434] = { --Cindercloth Pants
			item = 14045,
			reagents = {
				{ 14048, 6 },
				{ 7078 },
				{ 14341 },
			},
		},
		[18436] = { --Robe of Winter Night
			item = 14136,
			reagents = {
				{ 14048, 10 },
				{ 14256, 12 },
				{ 12808, 4 },
				{ 7080,  4 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 12 },
				{ 14256, 12 },
				{ 12808, 16 },
				{ 7080,  16 },
				{ 13467, 10 },
				{ 14341, 2 },
			},
		},
		[18437] = { --Felcloth Boots
			item = 14108,
			reagents = {
				{ 14048, 6 },
				{ 14256, 4 },
				{ 8170,  4 },
				{ 14341 },
			},
		},
		[18438] = { --Runecloth Pants
			item = 13865,
			reagents = {
				{ 14048, 6 },
				{ 14227, 2 },
				{ 14341 },
			},
		},
		[18439] = { --Brightcloth Pants
			item = 14104,
			reagents = {
				{ 14048, 6 },
				{ 3577,  4 },
				{ 14227 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 6 },
				{ 3577,  8 },
				{ 14227, 2 },
				{ 14341 },
			},
		},
		[18440] = { --Mooncloth Leggings
			item = 14137,
			reagents = {
				{ 14048, 6 },
				{ 14342, 4 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 14342, 4 },
				{ 12811, 2 },
				{ 14341, 2 },
			},
		},
		[18441] = { --Ghostweave Pants
			item = 14144,
			reagents = {
				{ 14048, 6 },
				{ 9210,  4 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 9210,  6 },
				{ 14227, 2 },
				{ 14341, 3 },
			},
		},
		[18442] = { --Felcloth Hood
			item = 14111,
			reagents = {
				{ 14048, 5 },
				{ 14256, 4 },
				{ 14341 },
			},
		},
		[18444] = { --Runecloth Headband
			item = 13866,
			reagents = {
				{ 14048, 4 },
				{ 14227, 2 },
				{ 14341 },
			},
		},
		[18445] = { --Mooncloth Bag
			item = 14155,
			reagents = {
				{ 14048, 4 },
				{ 14342 },
				{ 14341 },
			},
		},
		[18446] = { --Wizardweave Robe
			item = 14128,
			reagents = {
				{ 14048, 8 },
				{ 11176, 2 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 10 },
				{ 11176, 20 },
				{ 12804, 8 },
				{ 14341, 3 },
			},
		},
		[18447] = { --Mooncloth Vest
			item = 14138,
			reagents = {
				{ 14048, 6 },
				{ 14342, 4 },
				{ 14341 },
			},
		},
		[18448] = { --Mooncloth Shoulders
			item = 14139,
			reagents = {
				{ 14048, 5 },
				{ 14342, 5 },
				{ 14341 },
			},
		},
		[18449] = { --Runecloth Shoulders
			item = 13867,
			reagents = {
				{ 14048, 7 },
				{ 14227, 2 },
				{ 8170,  4 },
				{ 14341 },
			},
		},
		[18450] = { --Wizardweave Turban
			item = 14130,
			reagents = {
				{ 14048, 6 },
				{ 11176, 4 },
				{ 7910 },
				{ 14341 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 6 },
				{ 11176, 10 },
				{ 12804, 8 },
				{ 14341 },
				{ 7910 },
			},
		},
		[18451] = { --Felcloth Robe
			item = 14106,
			reagents = {
				{ 14048, 8 },
				{ 14256, 8 },
				{ 12662, 4 },
				{ 14341, 2 },
			},
		},
		[18452] = { --Mooncloth Circlet
			item = 14140,
			reagents = {
				{ 14048, 4 },
				{ 14342, 6 },
				{ 12800 },
				{ 12810, 2 },
				{ 14341, 2 },
			},
		},
		[18453] = { --Felcloth Shoulders
			item = 14112,
			reagents = {
				{ 14048, 7 },
				{ 14256, 6 },
				{ 12662, 4 },
				{ 8170,  4 },
				{ 14341, 2 },
			},
		},
		[18454] = { --Gloves of Spell Mastery
			item = 14146,
			reagents = {
				{ 14048, 10 },
				{ 14342, 10 },
				{ 9210,  10 },
				{ 13926, 6 },
				{ 12364, 6 },
				{ 12810, 8 },
				{ 14341, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 12 },
				{ 14342, 12 },
				{ 9210,  10 },
				{ 13926, 10 },
				{ 20725 },
				{ 12364, 8 },
				{ 14341, 8 },
			},
		},
		[18455] = { --Bottomless Bag
			item = 14156,
			reagents = {
				{ 14048, 8 },
				{ 14342, 12 },
				{ 14344, 2 },
				{ 17012, 2 },
				{ 14341, 2 },
			},
		},
		[18456] = { --Truefaith Vestments
			item = 14154,
			reagents = {
				{ 14048, 12 },
				{ 14342, 10 },
				{ 12811, 4 },
				{ 13926, 4 },
				{ 9210,  10 },
				{ 14341, 2 },
			},
		},
		[18457] = { --Robe of the Archmage
			item = 14152,
			reagents = {
				{ 14048, 12 },
				{ 7078,  10 },
				{ 7082,  10 },
				{ 7076,  10 },
				{ 7080,  10 },
				{ 14341, 2 },
			},
		},
		[18458] = { --Robe of the Void
			item = 14153,
			reagents = {
				{ 14048, 12 },
				{ 12662, 20 },
				{ 14256, 40 },
				{ 7078,  12 },
				{ 12808, 12 },
				{ 14341, 2 },
			},
		},
		[18560] = { --Mooncloth
			requires = L["Moonwell"],
			item = 14342,
			reagents = {
				{ 14256, 2 },
			},
		},
		[18629] = { --Runecloth Bandage
			item = 14529,
			reagents = {
				{ 14047 },
			},
		},
		[18630] = { --Heavy Runecloth Bandage
			item = 14530,
			reagents = {
				{ 14047, 2 },
			},
		},
		[19047] = { --Cured Rugged Hide
			item = 15407,
			reagents = {
				{ 8171 },
				{ 15409 },
			},
		},
		[19048] = { --Heavy Scorpid Bracers
			item = 15077,
			reagents = {
				{ 8170,  4 },
				{ 15408, 4 },
				{ 14341 },
			},
		},
		[19049] = { --Wicked Leather Gauntlets
			item = 15083,
			reagents = {
				{ 8170, 8 },
				{ 2325 },
				{ 14341 },
			},
		},
		[19050] = { --Green Dragonscale Breastplate
			item = 15045,
			reagents = {
				{ 8170,  20 },
				{ 15412, 25 },
				{ 14341, 2 },
			},
		},
		[19051] = { --Heavy Scorpid Vest
			item = 15076,
			reagents = {
				{ 8170,  6 },
				{ 15408, 6 },
				{ 14341 },
			},
		},
		[19052] = { --Wicked Leather Bracers
			item = 15084,
			reagents = {
				{ 8170, 8 },
				{ 2325 },
				{ 14341 },
			},
		},
		[19053] = { --Chimeric Gloves
			item = 15074,
			reagents = {
				{ 8170,  6 },
				{ 15423, 6 },
				{ 14341 },
			},
		},
		[19054] = { --Red Dragonscale Breastplate
			item = 15047,
			reagents = {
				{ 8170,  40 },
				{ 15414, 30 },
				{ 14341 },
			},
		},
		[19055] = { --Runic Leather Gauntlets
			item = 15091,
			reagents = {
				{ 8170,  10 },
				{ 14047, 6 },
				{ 14341 },
			},
		},
		[19058] = { --Rugged Armor Kit
			item = 15564,
			reagents = {
				{ 8170, 5 },
			},
		},
		[19059] = { --Volcanic Leggings
			item = 15054,
			reagents = {
				{ 8170, 6 },
				{ 7078 },
				{ 7075 },
				{ 14341 },
			},
		},
		[19060] = { --Green Dragonscale Leggings
			item = 15046,
			reagents = {
				{ 8170,  20 },
				{ 15412, 25 },
				{ 14341 },
			},
		},
		[19061] = { --Living Shoulders
			item = 15061,
			reagents = {
				{ 8170,  12 },
				{ 12803, 4 },
				{ 14341 },
			},
		},
		[19062] = { --Ironfeather Shoulders
			item = 15067,
			reagents = {
				{ 8170,  24 },
				{ 15420, 80 },
				{ 1529,  2 },
				{ 14341 },
			},
		},
		[19063] = { --Chimeric Boots
			item = 15073,
			reagents = {
				{ 8170,  4 },
				{ 15423, 8 },
				{ 14341 },
			},
		},
		[19064] = { --Heavy Scorpid Gauntlets
			item = 15078,
			reagents = {
				{ 8170,  6 },
				{ 15408, 8 },
				{ 14341 },
			},
		},
		[19065] = { --Runic Leather Bracers
			item = 15092,
			reagents = {
				{ 8170,  6 },
				{ 7971 },
				{ 14047, 6 },
				{ 14341 },
			},
		},
		[19066] = { --Frostsaber Boots
			item = 15071,
			reagents = {
				{ 8170,  4 },
				{ 15422, 6 },
				{ 14341 },
			},
		},
		[19067] = { --Stormshroud Pants
			item = 15057,
			reagents = {
				{ 8170, 16 },
				{ 7080, 2 },
				{ 7082, 2 },
				{ 14341 },
			},
		},
		[19068] = { --Warbear Harness
			item = 15064,
			reagents = {
				{ 8170,  28 },
				{ 15419, 12 },
				{ 14341 },
			},
		},
		[19070] = { --Heavy Scorpid Belt
			item = 15082,
			reagents = {
				{ 8170,  6 },
				{ 15408, 8 },
				{ 14341 },
			},
		},
		[19071] = { --Wicked Leather Headband
			item = 15086,
			reagents = {
				{ 8170, 12 },
				{ 2325 },
				{ 14341 },
			},
		},
		[19072] = { --Runic Leather Belt
			item = 15093,
			reagents = {
				{ 8170,  12 },
				{ 14047, 10 },
				{ 14341 },
			},
		},
		[19073] = { --Chimeric Leggings
			item = 15072,
			reagents = {
				{ 8170,  8 },
				{ 15423, 8 },
				{ 14341 },
			},
		},
		[19074] = { --Frostsaber Leggings
			item = 15069,
			reagents = {
				{ 8170,  6 },
				{ 15422, 8 },
				{ 14341 },
			},
		},
		[19075] = { --Heavy Scorpid Leggings
			item = 15079,
			reagents = {
				{ 8170,  8 },
				{ 15408, 12 },
				{ 14341 },
			},
		},
		[19076] = { --Volcanic Breastplate
			item = 15053,
			reagents = {
				{ 8170, 8 },
				{ 7078 },
				{ 7076 },
				{ 14341 },
			},
		},
		[19077] = { --Blue Dragonscale Breastplate
			item = 15048,
			reagents = {
				{ 8170,  28 },
				{ 15415, 30 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19078] = { --Living Leggings
			item = 15060,
			reagents = {
				{ 8170,  16 },
				{ 12803, 6 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19079] = { --Stormshroud Armor
			item = 15056,
			reagents = {
				{ 8170, 16 },
				{ 7080, 3 },
				{ 7082, 3 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19080] = { --Warbear Woolies
			item = 15065,
			reagents = {
				{ 8170,  24 },
				{ 15419, 14 },
				{ 14341 },
			},
		},
		[19081] = { --Chimeric Vest
			item = 15075,
			reagents = {
				{ 8170,  10 },
				{ 15423, 10 },
				{ 14341 },
			},
		},
		[19082] = { --Runic Leather Headband
			item = 15094,
			reagents = {
				{ 8170,  14 },
				{ 14047, 10 },
				{ 14341 },
			},
		},
		[19083] = { --Wicked Leather Pants
			item = 15087,
			reagents = {
				{ 8170, 16 },
				{ 15407 },
				{ 2325, 3 },
				{ 14341 },
			},
		},
		[19084] = { --Devilsaur Gauntlets
			item = 15063,
			reagents = {
				{ 8170,  30 },
				{ 15417, 8 },
				{ 14341 },
			},
		},
		[19085] = { --Black Dragonscale Breastplate
			item = 15050,
			reagents = {
				{ 8170,  40 },
				{ 15416, 60 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19086] = { --Ironfeather Breastplate
			item = 15066,
			reagents = {
				{ 8170,  40 },
				{ 15420, 120 },
				{ 1529 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19087] = { --Frostsaber Gloves
			item = 15070,
			reagents = {
				{ 8170,  6 },
				{ 15422, 10 },
				{ 14341 },
			},
		},
		[19088] = { --Heavy Scorpid Helm
			item = 15080,
			reagents = {
				{ 8170,  8 },
				{ 15408, 12 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19089] = { --Blue Dragonscale Shoulders
			item = 15049,
			reagents = {
				{ 8170,  28 },
				{ 15415, 30 },
				{ 12810, 2 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19090] = { --Stormshroud Shoulders
			item = 15058,
			reagents = {
				{ 8170,  12 },
				{ 7080,  3 },
				{ 7082,  3 },
				{ 12810, 2 },
				{ 14341 },
			},
		},
		[19091] = { --Runic Leather Pants
			item = 15095,
			reagents = {
				{ 8170,  18 },
				{ 14047, 12 },
				{ 12810, 2 },
				{ 14341 },
			},
		},
		[19092] = { --Wicked Leather Belt
			item = 15088,
			reagents = {
				{ 8170,  14 },
				{ 2325,  2 },
				{ 14341, 2 },
			},
		},
		[19093] = { --Onyxia Scale Cloak
			item = 15138,
			reagents = {
				{ 15410 },
				{ 14044 },
				{ 14341 },
			},
		},
		[19094] = { --Black Dragonscale Shoulders
			item = 15051,
			reagents = {
				{ 8170,  44 },
				{ 15416, 45 },
				{ 12810, 2 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19095] = { --Living Breastplate
			item = 15059,
			reagents = {
				{ 8170,  16 },
				{ 12803, 8 },
				{ 14342, 2 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19097] = { --Devilsaur Leggings
			item = 15062,
			reagents = {
				{ 8170,  30 },
				{ 15417, 14 },
				{ 15407 },
				{ 14341 },
			},
		},
		[19098] = { --Wicked Leather Armor
			item = 15085,
			reagents = {
				{ 8170,  20 },
				{ 15407, 2 },
				{ 14256, 6 },
				{ 2325,  4 },
				{ 14341, 2 },
			},
		},
		[19100] = { --Heavy Scorpid Shoulders
			item = 15081,
			reagents = {
				{ 8170,  14 },
				{ 15408, 14 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19101] = { --Volcanic Shoulders
			item = 15055,
			reagents = {
				{ 8170,  10 },
				{ 7078 },
				{ 7076 },
				{ 14341, 2 },
			},
		},
		[19102] = { --Runic Leather Armor
			item = 15090,
			reagents = {
				{ 8170,  22 },
				{ 12810, 4 },
				{ 14047, 16 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19103] = { --Runic Leather Shoulders
			item = 15096,
			reagents = {
				{ 8170,  16 },
				{ 12810, 4 },
				{ 14047, 18 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19104] = { --Frostsaber Tunic
			item = 15068,
			reagents = {
				{ 8170,  12 },
				{ 15422, 12 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19106] = { --Onyxia Scale Breastplate
			item = 15141,
			reagents = {
				{ 8170,  40 },
				{ 15410, 12 },
				{ 15416, 60 },
				{ 14341, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 8170,  80 },
				{ 15407, 12 },
				{ 15410, 12 },
				{ 15416, 60 },
				{ 14341, 10 },
			},
		},
		[19107] = { --Black Dragonscale Leggings
			item = 15052,
			reagents = {
				{ 8170,  40 },
				{ 15416, 60 },
				{ 12810, 4 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[19435] = { --Mooncloth Boots
			item = 15802,
			reagents = {
				{ 14048, 6 },
				{ 14342, 4 },
				{ 7971,  2 },
				{ 14341 },
			},
		},
		[19566] = { --Salt Shaker
			item = 15409,
			reagents = {
				{ 8150 },
			},
		},
		[19567] = { --Salt Shaker
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15846,
			reagents = {
				{ 10561 },
				{ 12359, 6 },
				{ 10558 },
				{ 10560, 4 },
			},
		},
		[19666] = { --Silver Skeleton Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15869,
			reagents = {
				{ 2842 },
				{ 3470 },
			},
		},
		[19667] = { --Golden Skeleton Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15870,
			reagents = {
				{ 3577 },
				{ 3486 },
			},
		},
		[19668] = { --Truesilver Skeleton Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15871,
			reagents = {
				{ 6037 },
				{ 7966 },
			},
		},
		[19669] = { --Arcanite Skeleton Key
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15872,
			reagents = {
				{ 12360 },
				{ 12644 },
			},
		},
		[19788] = { --Dense Blasting Powder
			item = 15992,
			reagents = {
				{ 12365, 2 },
			},
		},
		[19790] = { --Thorium Grenade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15993,
			reagents = {
				{ 15994 },
				{ 12359, 3 },
				{ 15992, 3 },
				{ 14047, 3 },
			},
		},
		[19791] = { --Thorium Widget
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 15994,
			reagents = {
				{ 12359, 3 },
				{ 14047 },
			},
		},
		[19792] = { --Thorium Rifle
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 15995,
			reagents = {
				{ 10559, 2 },
				{ 10561, 2 },
				{ 15994, 2 },
				{ 12359, 4 },
				{ 10546 },
			},
		},
		[19793] = { --Lifelike Mechanical Toad
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 15996,
			reagents = {
				{ 12803 },
				{ 15994, 4 },
				{ 10558 },
				{ 8170 },
			},
		},
		[19794] = { --Spellpower Goggles Xtreme Plus
			tools = { 6219, 10498 },
			item = 15999,
			reagents = {
				{ 10502 },
				{ 7910,  4 },
				{ 12810, 2 },
				{ 14047, 8 },
			},
		},
		[19795] = { --Thorium Tube
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16000,
			reagents = {
				{ 12359, 6 },
			},
		},
		[19796] = { --Dark Iron Rifle
			requires = L["Black Anvil"],
			tools = { 5956, 6219 },
			item = 16004,
			reagents = {
				{ 16000, 2 },
				{ 11371, 6 },
				{ 10546, 2 },
				{ 12361, 2 },
				{ 12799, 2 },
				{ 8170,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 16000, 2 },
				{ 11371, 10 },
				{ 10546, 2 },
				{ 12361, 2 },
				{ 12799, 2 },
				{ 8170,  8 },
			},
		},
		[19799] = { --Dark Iron Bomb
			requires = L["Anvil"],
			tools = { 5956 },
			item = 16005,
			reagents = {
				{ 15994, 2 },
				{ 11371 },
				{ 15992, 3 },
				{ 14047, 3 },
			},
		},
		[19800] = { --Thorium Shells
			requires = L["Anvil"],
			tools = { 5956 },
			item = 15997,
			reagents = {
				{ 12359, 2 },
				{ 15992 },
			},
		},
		[19814] = { --Masterwork Target Dummy
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16023,
			reagents = {
				{ 10561 },
				{ 16000 },
				{ 15994, 2 },
				{ 6037 },
				{ 8170,  2 },
				{ 14047, 4 },
			},
		},
		[19815] = { --Delicate Arcanite Converter
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16006,
			reagents = {
				{ 12360 },
				{ 14227 },
			},
		},
		[19819] = { --Voice Amplification Modulator
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16009,
			reagents = {
				{ 16006, 2 },
				{ 10558 },
				{ 15994 },
				{ 12799 },
			},
			reagents_VANILLA_PLUS = {
				{ 16006, 4 },
				{ 10558, 4 },
				{ 15994, 2 },
				{ 7191,  2 },
				{ 12800, 4 },
				{ 12799, 4 },
			},
		},
		[19825] = { --Master Engineer's Goggles
			tools = { 6219, 10498 },
			item = 16008,
			reagents = {
				{ 10500 },
				{ 12364, 2 },
				{ 12810, 4 },
			},
		},
		[19830] = { --Arcanite Dragonling
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16022,
			reagents = {
				{ 10576 },
				{ 16006, 8 },
				{ 12655, 10 },
				{ 15994, 6 },
				{ 10558, 4 },
				{ 12810, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 10576 },
				{ 16006, 8 },
				{ 12655, 12 },
				{ 15994, 6 },
				{ 10558, 12 },
				{ 12810, 12 },
			},
		},
		[19831] = { --Arcane Bomb
			requires = L["Anvil"],
			tools = { 5956 },
			item = 16040,
			reagents = {
				{ 16006 },
				{ 12359, 3 },
				{ 14047 },
			},
		},
		[19833] = { --Flawless Arcanite Rifle
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 16007,
			reagents = {
				{ 12360, 10 },
				{ 16000, 2 },
				{ 7078,  2 },
				{ 7076,  2 },
				{ 12800, 2 },
				{ 12810, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 10 },
				{ 16000, 2 },
				{ 7078,  12 },
				{ 7076,  12 },
				{ 12800, 4 },
				{ 12810, 10 },
				{ 8168,  6 },
			},
		},
		[20039] = { --Greater Eternal Essence
			item = 16203,
			reagents = {
				{ 16202, 2 },
			},
		},
		[20201] = { --Arcanite Rod
			requires = L["Anvil"],
			tools = { 5956 },
			item = 16206,
			reagents = {
				{ 12360, 3 },
				{ 12644 },
			},
		},
		[20626] = { --Undermine Clam Chowder
			requires = L["Cooking Fire"],
			item = 16766,
			reagents = {
				{ 7974, 2 },
				{ 2692 },
				{ 1179 },
			},
		},
		[20648] = { --Medium Leather
			item = 2319,
			reagents = {
				{ 2318, 4 },
			},
		},
		[20649] = { --Heavy Leather
			item = 4234,
			reagents = {
				{ 2319, 5 },
			},
		},
		[20650] = { --Thick Leather
			item = 4304,
			reagents = {
				{ 4234, 6 },
			},
		},
		[20848] = { --Flarecore Mantle
			item = 16980,
			reagents = {
				{ 14048, 12 },
				{ 17010, 4 },
				{ 17011, 4 },
				{ 12810, 6 },
				{ 14341, 2 },
			},
			reagents_TURTLE1 = {
				{ 14342, 6 },
				{ 17010, 4 },
				{ 17011, 4 },
				{ 12810, 6 },
				{ 14341, 2 },
			},
		},
		[20849] = { --Flarecore Gloves
			item = 16979,
			reagents = {
				{ 14048, 8 },
				{ 17010, 6 },
				{ 7078,  4 },
				{ 12810, 2 },
				{ 14341, 2 },
			},
			reagents_TURTLE1 = {
				{ 14342, 4 },
				{ 17010, 6 },
				{ 7078,  4 },
				{ 12810, 2 },
				{ 14341, 2 },
			},
		},
		[20853] = { --Corehound Boots
			item = 16982,
			reagents = {
				{ 17012, 20 },
				{ 17010, 6 },
				{ 17011, 2 },
				{ 14341, 2 },
			},
		},
		[20854] = { --Molten Helm
			item = 16983,
			reagents = {
				{ 17012, 15 },
				{ 17010, 3 },
				{ 17011, 6 },
				{ 14341, 2 },
			},
		},
		[20855] = { --Black Dragonscale Boots
			item = 16984,
			reagents = {
				{ 12810, 6 },
				{ 15416, 30 },
				{ 17010, 4 },
				{ 17011, 3 },
				{ 14341, 2 },
			},
		},
		[20872] = { --Fiery Chain Girdle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 16989,
			reagents = {
				{ 11371, 6 },
				{ 17010, 3 },
				{ 17011, 3 },
			},
		},
		[20873] = { --Fiery Chain Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 16988,
			reagents = {
				{ 11371, 16 },
				{ 17010, 4 },
				{ 17011, 5 },
			},
			reagents_TURTLE1 = {
				{ 11371, 10 },
				{ 17010, 4 },
				{ 17011, 3 },
			},
		},
		[20874] = { --Dark Iron Bracers
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 17014,
			reagents = {
				{ 11371, 4 },
				{ 17010, 2 },
				{ 17011, 2 },
			},
		},
		[20876] = { --Dark Iron Leggings
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 17013,
			reagents = {
				{ 11371, 16 },
				{ 17010, 4 },
				{ 17011, 6 },
			},
		},
		[20890] = { --Dark Iron Reaver
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 17015,
			reagents = {
				{ 11371, 16 },
				{ 17010, 12 },
				{ 11382, 2 },
				{ 12810, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 22 },
				{ 17010, 12 },
				{ 11382, 4 },
				{ 12810, 2 },
			},
			reagents_TURTLE1 = {
				{ 11371, 10 },
				{ 17010, 6 },
				{ 11382, 2 },
				{ 12810, 2 },
			},
		},
		[20897] = { --Dark Iron Destroyer
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 17016,
			reagents = {
				{ 11371, 18 },
				{ 17011, 12 },
				{ 11382, 2 },
				{ 12810, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 22 },
				{ 17011, 12 },
				{ 11382, 4 },
				{ 12810, 6 },
			},
			reagents_TURTLE1 = {
				{ 11371, 10 },
				{ 17011, 6 },
				{ 11382, 2 },
				{ 12810, 2 },
			},
		},
		[20916] = { --Mithril Headed Trout
			requires = L["Cooking Fire"],
			item = 8364,
			reagents = {
				{ 8365 },
			},
		},
		[21029] = { --Thaumaturgy Channel
			item = 7867,
			reagents = {
				{ 7866 },
			},
		},
		[21143] = { --Gingerbread Cookie
			requires = L["Cooking Fire"],
			item = 17197,
			reagents = {
				{ 6889 },
				{ 17194 },
			},
		},
		[21144] = { --Egg Nog
			requires = L["Cooking Fire"],
			item = 17198,
			reagents = {
				{ 6889 },
				{ 1179 },
				{ 17196 },
				{ 17194 },
			},
		},
		[21161] = { --Sulfuron Hammer
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 17193,
			reagents = {
				{ 17203, 8 },
				{ 11371, 20 },
				{ 12360, 50 },
				{ 7078,  25 },
				{ 11382, 10 },
				{ 17011, 10 },
				{ 17010, 10 },
			},
		},
		[21175] = { --Spider Sausage
			requires = L["Cooking Fire"],
			item = 17222,
			reagents = {
				{ 12205, 2 },
			},
		},
		[21913] = { --Edge of Winter
			requires = L["Anvil"],
			tools = { 5956 },
			item = 17704,
			reagents = {
				{ 3859, 10 },
				{ 3829 },
				{ 7070, 2 },
				{ 7069, 2 },
				{ 4234, 2 },
			},
		},
		[21923] = { --Elixir of Frost Power
			item = 17708,
			reagents = {
				{ 3819, 2 },
				{ 3358 },
				{ 3372 },
			},
		},
		[21940] = { --SnowMaster 9000
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 17716,
			reagents = {
				{ 3860,  8 },
				{ 4389,  4 },
				{ 17202, 4 },
				{ 3829 },
			},
		},
		[21943] = { --Gloves of the Greatfather
			item = 17721,
			reagents = {
				{ 4234, 8 },
				{ 7067, 4 },
				{ 4291 },
			},
		},
		[21945] = { --Green Holiday Shirt
			item = 17723,
			reagents = {
				{ 4305, 5 },
				{ 2605, 4 },
				{ 4291 },
			},
		},
		[22331] = { --Rugged Leather
			item = 8170,
			reagents = {
				{ 4304, 6 },
			},
		},
		[22430] = { --Refined Scale of Onyxia
			tools = { 9149 },
			item = 17967,
			reagents = {
				{ 15410 },
			},
		},
		[22434] = { --Charged Scale of Onyxia
			item = 17968,
			reagents = {
				{ 17967 },
				{ 16204, 2 },
				{ 16203, 2 },
			},
		},
		[22480] = { --Tender Wolf Steak
			requires = L["Cooking Fire"],
			item = 18045,
			reagents = {
				{ 12208 },
				{ 3713 },
			},
		},
		[22704] = { --Field Repair Bot 74A
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18232,
			reagents = {
				{ 12359, 12 },
				{ 8170,  4 },
				{ 7191 },
				{ 7067,  2 },
				{ 7068 },
			},
			reagents_TURTLE1 = {
				{ 12359, 12 },
				{ 7191,  2 },
				{ 10558 },
			},
		},
		[22711] = { --Shadowskin Gloves
			item = 18238,
			reagents = {
				{ 4304, 6 },
				{ 7428, 8 },
				{ 7971, 2 },
				{ 4236, 2 },
				{ 1210, 4 },
				{ 8343 },
			},
		},
		[22727] = { --Core Armor Kit
			item = 18251,
			reagents = {
				{ 17012, 3 },
				{ 14341, 2 },
			},
		},
		[22732] = { --Major Rejuvenation Potion
			item = 18253,
			reagents = {
				{ 10286 },
				{ 13464, 4 },
				{ 13463, 4 },
				{ 18256 },
			},
			reagents_TURTLE1 = {
				{ 10286 },
				{ 13464, 3 },
				{ 13463, 3 },
				{ 18256 },
			},
		},
		[22757] = { --Elemental Sharpening Stone
			item = 18262,
			reagents = {
				{ 7067,  2 },
				{ 12365, 3 },
			},
		},
		[22759] = { --Flarecore Wraps
			item = 18263,
			reagents = {
				{ 14342, 6 },
				{ 17010, 8 },
				{ 7078,  2 },
				{ 12810, 6 },
				{ 14341, 4 },
			},
		},
		[22761] = { --Runn Tum Tuber Surprise
			requires = L["Cooking Fire"],
			item = 18254,
			reagents = {
				{ 18255 },
				{ 3713 },
			},
		},
		[22793] = { --Biznicks 247x128 Accurascope
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18283,
			reagents = {
				{ 17011, 2 },
				{ 7076,  2 },
				{ 16006, 4 },
				{ 11371, 6 },
				{ 16000 },
			},
			reagents_VANILLA_PLUS = {
				{ 17011, 4 },
				{ 7076,  10 },
				{ 16006, 4 },
				{ 11371, 10 },
				{ 16000 },
			},
		},
		[22795] = { --Core Marksman Rifle
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18282,
			reagents = {
				{ 17010, 4 },
				{ 17011, 2 },
				{ 12360, 6 },
				{ 16006, 2 },
				{ 16000, 2 },
			},
		},
		[22797] = { --Force Reactive Disk
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18168,
			reagents = {
				{ 12360, 6 },
				{ 16006, 2 },
				{ 7082,  8 },
				{ 12803, 12 },
				{ 7076,  8 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 8 },
				{ 16006, 4 },
				{ 7082,  16 },
				{ 12803, 12 },
				{ 7076,  16 },
				{ 13757, 10 },
			},
		},
		[22808] = { --Elixir of Greater Water Breathing
			item = 18294,
			reagents = {
				{ 7972 },
				{ 8831, 2 },
				{ 8925 },
			},
		},
		[22813] = { --Gordok Ogre Suit
			item = 18258,
			reagents = {
				{ 14048, 2 },
				{ 8170,  4 },
				{ 18240 },
				{ 14341 },
			},
		},
		[22815] = { --Gordok Ogre Suit
			item = 18258,
			reagents = {
				{ 8170,  4 },
				{ 14048, 2 },
				{ 18240 },
				{ 14341 },
			},
		},
		[22866] = { --Belt of the Archmage
			item = 18405,
			reagents = {
				{ 14048, 16 },
				{ 9210,  10 },
				{ 14342, 10 },
				{ 7080,  12 },
				{ 7078,  12 },
				{ 14344, 6 },
				{ 14341, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 16 },
				{ 9210,  16 },
				{ 14342, 10 },
				{ 7080,  15 },
				{ 7078,  15 },
				{ 14344, 12 },
				{ 14341, 6 },
			},
		},
		[22867] = { --Felcloth Gloves
			item = 18407,
			reagents = {
				{ 14048, 12 },
				{ 14256, 20 },
				{ 12662, 6 },
				{ 12808, 8 },
				{ 14341, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 12 },
				{ 14256, 20 },
				{ 12662, 6 },
				{ 12808, 10 },
				{ 14341, 2 },
			},
		},
		[22868] = { --Inferno Gloves
			item = 18408,
			reagents = {
				{ 14048, 12 },
				{ 7078,  10 },
				{ 7910,  2 },
				{ 14341, 2 },
			},
		},
		[22869] = { --Mooncloth Gloves
			item = 18409,
			reagents = {
				{ 14048, 12 },
				{ 14342, 6 },
				{ 13926, 2 },
				{ 14341, 2 },
			},
		},
		[22870] = { --Cloak of Warding
			item = 18413,
			reagents = {
				{ 14048, 12 },
				{ 12809, 4 },
				{ 12360 },
				{ 14341, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 15 },
				{ 12809, 8 },
				{ 12360 },
				{ 14341, 2 },
			},
		},
		[22902] = { --Mooncloth Robe
			item = 18486,
			reagents = {
				{ 14048, 6 },
				{ 14342, 4 },
				{ 13926, 2 },
				{ 14341, 2 },
			},
		},
		[22921] = { --Girdle of Insight
			item = 18504,
			reagents = {
				{ 8170,  12 },
				{ 12804, 12 },
				{ 15407, 2 },
				{ 14341, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 8170,  12 },
				{ 12804, 15 },
				{ 15407, 4 },
				{ 14341, 4 },
			},
		},
		[22922] = { --Mongoose Boots
			item = 18506,
			reagents = {
				{ 8170,  12 },
				{ 7082,  6 },
				{ 11754, 4 },
				{ 15407, 2 },
				{ 14341, 4 },
			},
		},
		[22923] = { --Swift Flight Bracers
			item = 18508,
			reagents = {
				{ 8170,  12 },
				{ 18512, 8 },
				{ 15420, 60 },
				{ 15407, 4 },
				{ 14341, 4 },
			},
		},
		[22926] = { --Chromatic Cloak
			item = 18509,
			reagents = {
				{ 8170,  30 },
				{ 12607, 12 },
				{ 15416, 30 },
				{ 15414, 30 },
				{ 15407, 5 },
				{ 14341, 8 },
			},
		},
		[22927] = { --Hide of the Wild
			item = 18510,
			reagents = {
				{ 8170,  30 },
				{ 12803, 12 },
				{ 7080,  10 },
				{ 18512, 8 },
				{ 15407, 3 },
				{ 14341, 8 },
			},
		},
		[22928] = { --Shifting Cloak
			item = 18511,
			reagents = {
				{ 8170,  30 },
				{ 7082,  12 },
				{ 12753, 4 },
				{ 12809, 8 },
				{ 15407, 4 },
				{ 14341, 8 },
			},
			reagents_VANILLA_PLUS = {
				{ 8170,  40 },
				{ 7082,  15 },
				{ 12753, 8 },
				{ 12809, 8 },
				{ 15407, 5 },
				{ 14341, 8 },
			},
		},
		[22967] = { --Smelt Elementium
			name = LS["Smelting: Smelt Elementium"],
			requires = L["Forge"],
			item = 17771,
			reagents = {
				{ 18562 },
				{ 12360, 10 },
				{ 17010 },
				{ 18567, 3 },
			},
			reagents_VANILLA_PLUS = {
				{ 18562 },
				{ 12360, 10 },
				{ 17010 },
				{ 18567, 5 },
			},
		},
		[23028] = { --Arcane Brilliance
			reagents = {
				{ 17020 },
			},
		},
		[23066] = { --Red Firework
			item = 9318,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[23067] = { --Blue Firework
			item = 9312,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[23068] = { --Green Firework
			item = 9313,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[23069] = { --EZ-Thro Dynamite II
			item = 18588,
			reagents = {
				{ 10505 },
				{ 4338, 2 },
			},
		},
		[23070] = { --Dense Dynamite
			item = 18641,
			reagents = {
				{ 15992, 2 },
				{ 14047, 3 },
			},
		},
		[23071] = { --Truesilver Transformer
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18631,
			reagents = {
				{ 6037, 2 },
				{ 7067, 2 },
				{ 7069 },
			},
		},
		[23077] = { --Gyrofreeze Ice Reflector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18634,
			reagents = {
				{ 15994, 6 },
				{ 18631, 2 },
				{ 12361, 2 },
				{ 7078,  4 },
				{ 3829,  2 },
				{ 13467, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 15994, 6 },
				{ 18631, 6 },
				{ 12361, 8 },
				{ 7078,  12 },
				{ 3829,  5 },
				{ 13467, 12 },
			},
		},
		[23078] = { --Goblin Jumper Cables XL
			item = 18587,
			reagents = {
				{ 15994, 2 },
				{ 18631, 2 },
				{ 7191,  2 },
				{ 14227, 2 },
				{ 7910,  2 },
			},
		},
		[23079] = { --Major Recombobulator
			extra = Colors.WHITE .. "10 " .. L["Charges"],
			item = 18637,
			reagents = {
				{ 16000, 2 },
				{ 18631 },
				{ 14047, 2 },
			},
		},
		[23080] = { --Powerful Seaforium Charge
			item = 18594,
			reagents = {
				{ 15994, 2 },
				{ 15992, 3 },
				{ 8170,  2 },
				{ 159 },
			},
		},
		[23081] = { --Hyper-Radiant Flame Reflector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18638,
			reagents = {
				{ 11371, 4 },
				{ 18631, 3 },
				{ 7080,  6 },
				{ 7910,  4 },
				{ 12800, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 10 },
				{ 18631, 4 },
				{ 7080,  12 },
				{ 13457, 4 },
				{ 7910,  10 },
				{ 12800, 4 },
			},
		},
		[23082] = { --Ultra-Flash Shadow Reflector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18639,
			reagents = {
				{ 11371, 8 },
				{ 18631, 4 },
				{ 12803, 6 },
				{ 12808, 4 },
				{ 12800, 2 },
				{ 12799, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 11371, 14 },
				{ 18631, 4 },
				{ 12803, 10 },
				{ 12808, 15 },
				{ 12800, 4 },
				{ 12799, 4 },
			},
		},
		[23096] = { --Alarm-O-Bot
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18645,
			reagents = {
				{ 12359, 4 },
				{ 15994, 2 },
				{ 8170,  4 },
				{ 7910 },
				{ 7191 },
			},
		},
		[23129] = { --World Enlarger
			requires = L["Anvil"],
			tools = { 5956 },
			item = 18660,
			reagents = {
				{ 10561 },
				{ 15994, 2 },
				{ 10558 },
				{ 10560 },
				{ 3864 },
			},
		},
		[23190] = { --Heavy Leather Ball
			item = 18662,
			reagents = {
				{ 4234, 2 },
				{ 2321 },
			},
		},
		[23399] = { --Barbaric Bracers
			item = 18948,
			reagents = {
				{ 4234, 8 },
				{ 4236, 2 },
				{ 5498, 4 },
				{ 4461 },
				{ 5637, 4 },
			},
		},
		[23486] = { --Dimensional Ripper - Everlook
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18984,
			reagents = {
				{ 3860, 10 },
				{ 18631 },
				{ 7077, 4 },
				{ 7910, 2 },
				{ 10586 },
			},
		},
		[23489] = { --Ultrasafe Transporter - Gadgetzan
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 18986,
			reagents = {
				{ 3860,  12 },
				{ 18631, 2 },
				{ 7075,  4 },
				{ 7079,  2 },
				{ 7909,  4 },
				{ 9060 },
			},
		},
		[23507] = { --Snake Burst Firework
			item = 19026,
			reagents = {
				{ 15992, 2 },
				{ 14047, 2 },
				{ 8150 },
			},
		},
		[23628] = { --Heavy Timbermaw Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19043,
			reagents = {
				{ 12359, 12 },
				{ 7076,  3 },
				{ 12803, 3 },
			},
		},
		[23629] = { --Heavy Timbermaw Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19048,
			reagents = {
				{ 12360, 4 },
				{ 7076,  6 },
				{ 12803, 6 },
			},
		},
		[23632] = { --Girdle of the Dawn
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19051,
			reagents = {
				{ 12359, 8 },
				{ 6037,  6 },
				{ 12811 },
			},
		},
		[23633] = { --Gloves of the Dawn
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19057,
			reagents = {
				{ 12360, 2 },
				{ 6037,  10 },
				{ 12811 },
			},
		},
		[23636] = { --Dark Iron Helm
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 19148,
			reagents = {
				{ 17011, 4 },
				{ 17010, 2 },
				{ 11371, 4 },
			},
		},
		[23637] = { --Dark Iron Gauntlets
			requires = L["Black Anvil"],
			tools = { 5956 },
			item = 19164,
			reagents = {
				{ 17011, 3 },
				{ 17010, 5 },
				{ 17012, 4 },
				{ 11371, 4 },
				{ 11382, 2 },
			},
		},
		[23638] = { --Black Amnesty
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19166,
			reagents = {
				{ 17011, 3 },
				{ 17010, 6 },
				{ 12360, 12 },
				{ 11382 },
				{ 11371, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 17011, 4 },
				{ 17010, 6 },
				{ 12360, 12 },
				{ 11382, 3 },
				{ 11371, 8 },
			},
		},
		[23639] = { --Blackfury
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19167,
			reagents = {
				{ 17011, 5 },
				{ 17010, 2 },
				{ 12360, 16 },
				{ 11371, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 17011, 5 },
				{ 17010, 5 },
				{ 12360, 16 },
				{ 11371, 20 },
				{ 8146,  20 },
				{ 13442, 5 },
			},
		},
		[23650] = { --Ebon Hand
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19170,
			reagents = {
				{ 17011, 4 },
				{ 17010, 7 },
				{ 12360, 12 },
				{ 11371, 8 },
				{ 12800, 4 },
			},
		},
		[23652] = { --Blackguard
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19168,
			reagents = {
				{ 17011, 6 },
				{ 17010, 6 },
				{ 12360, 10 },
				{ 11371, 6 },
				{ 12809, 12 },
			},
			reagents_VANILLA_PLUS = {
				{ 17011, 8 },
				{ 17010, 8 },
				{ 12360, 15 },
				{ 11371, 15 },
				{ 12809, 12 },
			},
		},
		[23653] = { --Nightfall
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19169,
			reagents = {
				{ 17011, 8 },
				{ 17010, 5 },
				{ 12360, 10 },
				{ 11371, 12 },
				{ 12364, 4 },
			},
		},
		[23662] = { --Wisdom of the Timbermaw
			item = 19047,
			reagents = {
				{ 14048, 8 },
				{ 7076,  3 },
				{ 12803, 3 },
				{ 14227, 2 },
			},
		},
		[23663] = { --Mantle of the Timbermaw
			item = 19050,
			reagents = {
				{ 14342, 5 },
				{ 7076,  5 },
				{ 12803, 5 },
				{ 14227, 2 },
			},
		},
		[23664] = { --Argent Boots
			item = 19056,
			reagents = {
				{ 14048, 6 },
				{ 12810, 4 },
				{ 13926, 2 },
				{ 12809, 2 },
				{ 14227, 2 },
			},
		},
		[23665] = { --Argent Shoulders
			item = 19059,
			reagents = {
				{ 14342, 5 },
				{ 12809, 2 },
				{ 14227, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14342, 5 },
				{ 12809, 4 },
				{ 14227, 5 },
			},
		},
		[23666] = { --Flarecore Robe
			item = 19156,
			reagents = {
				{ 14342, 10 },
				{ 17010, 2 },
				{ 17011, 3 },
				{ 7078,  6 },
				{ 14227, 4 },
			},
		},
		[23667] = { --Flarecore Leggings
			item = 19165,
			reagents = {
				{ 14342, 8 },
				{ 17010, 5 },
				{ 17011, 3 },
				{ 7078,  10 },
				{ 14227, 4 },
			},
		},
		[23677] = { --Beasts Deck
			item = 19228,
			reagents = {
				{ 19227 },
				{ 19230 },
				{ 19231 },
				{ 19232 },
				{ 19233 },
				{ 19234 },
				{ 19235 },
				{ 19236 },
			},
		},
		[23678] = { --Warlord Deck
			item = 19257,
			reagents = {
				{ 19258 },
				{ 19259 },
				{ 19260 },
				{ 19261 },
				{ 19262 },
				{ 19263 },
				{ 19264 },
				{ 19265 },
			},
		},
		[23679] = { --Elementals Deck
			item = 19267,
			reagents = {
				{ 19268 },
				{ 19269 },
				{ 19270 },
				{ 19271 },
				{ 19272 },
				{ 19273 },
				{ 19274 },
				{ 19275 },
			},
		},
		[23680] = { --Portals Deck
			item = 19277,
			reagents = {
				{ 19276 },
				{ 19278 },
				{ 19279 },
				{ 19280 },
				{ 19281 },
				{ 19282 },
				{ 19283 },
				{ 19284 },
			},
		},
		[23683] = { --Twisting Nether
			reagents = {
				{ 17030 },
			},
		},
		[23703] = { --Might of the Timbermaw
			item = 19044,
			reagents = {
				{ 8170,  30 },
				{ 12804, 2 },
				{ 12803, 4 },
				{ 15407, 2 },
				{ 14341, 2 },
			},
		},
		[23704] = { --Timbermaw Brawlers
			item = 19049,
			reagents = {
				{ 12810, 8 },
				{ 12804, 6 },
				{ 12803, 6 },
				{ 15407, 2 },
				{ 14227, 2 },
			},
		},
		[23705] = { --Dawn Treaders
			item = 19052,
			reagents = {
				{ 8170,  30 },
				{ 12809, 2 },
				{ 7080,  4 },
				{ 15407, 2 },
				{ 14341, 2 },
			},
		},
		[23706] = { --Golden Mantle of the Dawn
			item = 19058,
			reagents = {
				{ 12810, 8 },
				{ 12803, 4 },
				{ 12809, 4 },
				{ 15407, 2 },
				{ 14341, 2 },
			},
		},
		[23707] = { --Lava Belt
			item = 19149,
			reagents = {
				{ 17011, 5 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[23708] = { --Chromatic Gauntlets
			item = 19157,
			reagents = {
				{ 17010, 5 },
				{ 17011, 2 },
				{ 17012, 4 },
				{ 12607, 4 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[23709] = { --Corehound Belt
			item = 19162,
			reagents = {
				{ 17010, 8 },
				{ 17012, 12 },
				{ 12810, 10 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[23710] = { --Molten Belt
			item = 19163,
			reagents = {
				{ 17010, 2 },
				{ 17011, 7 },
				{ 7076,  6 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[23787] = { --Powerful Anti-Venom
			item = 19440,
			reagents = {
				{ 19441 },
			},
		},
		[24091] = { --Bloodvine Vest
			item = 19682,
			reagents = {
				{ 14342, 3 },
				{ 19726, 5 },
				{ 12804, 4 },
				{ 14048, 4 },
				{ 14227, 2 },
			},
		},
		[24092] = { --Bloodvine Leggings
			item = 19683,
			reagents = {
				{ 14342, 4 },
				{ 19726, 4 },
				{ 12804, 4 },
				{ 14048, 4 },
				{ 14227, 2 },
			},
		},
		[24093] = { --Bloodvine Boots
			item = 19684,
			reagents = {
				{ 14342, 3 },
				{ 19726, 3 },
				{ 12810, 4 },
				{ 14048, 4 },
				{ 14227, 4 },
			},
		},
		[24121] = { --Primal Batskin Jerkin
			item = 19685,
			reagents = {
				{ 19767, 14 },
				{ 15407, 5 },
				{ 12803, 4 },
				{ 14341, 4 },
			},
		},
		[24122] = { --Primal Batskin Gloves
			item = 19686,
			reagents = {
				{ 19767, 10 },
				{ 15407, 4 },
				{ 12803, 4 },
				{ 14341, 3 },
			},
		},
		[24123] = { --Primal Batskin Bracers
			item = 19687,
			reagents = {
				{ 19767, 8 },
				{ 15407, 3 },
				{ 12803, 4 },
				{ 14341, 3 },
			},
		},
		[24124] = { --Blood Tiger Breastplate
			item = 19688,
			reagents = {
				{ 19768, 35 },
				{ 19726, 2 },
				{ 15407, 3 },
				{ 14341, 3 },
			},
			reagents_VANILLA_PLUS = {
				{ 19768, 35 },
				{ 19726, 5 },
				{ 15407, 5 },
				{ 14341, 5 },
			},
		},
		[24125] = { --Blood Tiger Shoulders
			item = 19689,
			reagents = {
				{ 19768, 25 },
				{ 19726, 2 },
				{ 15407, 3 },
				{ 14341, 3 },
			},
			reagents_VANILLA_PLUS = {
				{ 19768, 25 },
				{ 19726, 5 },
				{ 15407, 3 },
				{ 14341, 3 },
			},
		},
		[24136] = { --Bloodsoul Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19690,
			reagents = {
				{ 12359, 20 },
				{ 19774, 10 },
				{ 19726, 2 },
				{ 7910,  2 },
			},
		},
		[24137] = { --Bloodsoul Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19691,
			reagents = {
				{ 12359, 16 },
				{ 19774, 8 },
				{ 19726, 2 },
				{ 7910 },
			},
		},
		[24138] = { --Bloodsoul Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19692,
			reagents = {
				{ 12359, 12 },
				{ 19774, 6 },
				{ 19726, 2 },
				{ 12810, 4 },
			},
		},
		[24139] = { --Darksoul Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19693,
			reagents = {
				{ 12359, 20 },
				{ 19774, 14 },
				{ 12799, 2 },
			},
		},
		[24140] = { --Darksoul Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19694,
			reagents = {
				{ 12359, 18 },
				{ 19774, 12 },
				{ 12799, 2 },
			},
		},
		[24141] = { --Darksoul Shoulders
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19695,
			reagents = {
				{ 12359, 16 },
				{ 19774, 10 },
				{ 12799 },
			},
		},
		[24245] = { --String Together Heads
			item = 19880,
			reagents = {
				{ 19881, 5 },
			},
		},
		[24266] = { --Gurubashi Mojo Madness
			item = 19931,
			reagents = {
				{ 12938 },
				{ 19943 },
				{ 12804, 6 },
				{ 13468 },
			},
			tools_VANILLA_PLUS = { 9149 },
		},
		[24356] = { --Bloodvine Goggles
			tools = { 10498, 6219 },
			item = 19999,
			reagents = {
				{ 19726, 4 },
				{ 19774, 5 },
				{ 16006, 2 },
				{ 12804, 8 },
				{ 12810, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 19726, 8 },
				{ 19774, 8 },
				{ 16006, 2 },
				{ 12804, 10 },
				{ 12810, 8 },
			},
		},
		[24357] = { --Bloodvine Lens
			tools = { 10498, 6219 },
			item = 19998,
			reagents = {
				{ 19726, 5 },
				{ 19774, 5 },
				{ 16006 },
				{ 12804, 8 },
				{ 12810, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 10501 },
				{ 19726, 8 },
				{ 19774, 8 },
				{ 16006, 2 },
				{ 12804, 10 },
				{ 12810, 12 },
			},
		},
		[24365] = { --Mageblood Potion
			item = 20007,
			reagents = {
				{ 13463 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[24366] = { --Greater Dreamless Sleep Potion
			item = 20002,
			reagents = {
				{ 13463, 2 },
				{ 13464 },
				{ 8925 },
			},
		},
		[24367] = { --Living Action Potion
			item = 20008,
			reagents = {
				{ 13467, 2 },
				{ 13465, 2 },
				{ 10286, 2 },
				{ 8925 },
			},
			reagents_VANILLA_PLUS = {
				{ 13467, 3 },
				{ 13465, 3 },
				{ 10286, 3 },
				{ 8925 },
			},
		},
		[24368] = { --Major Troll's Blood Potion
			item = 20004,
			reagents = {
				{ 8846 },
				{ 13466, 2 },
				{ 8925 },
			},
		},
		[24399] = { --Dark Iron Boots
			requires = L["Black Anvil"],
			extra = Colors.GREEN .. L["<Random enchantment>"],
			tools = { 5956 },
			item = 20039,
			reagents = {
				{ 17011, 3 },
				{ 17010, 3 },
				{ 17012, 4 },
				{ 11371, 6 },
			},
		},
		[24418] = { --Heavy Crocolisk Stew
			requires = L["Cooking Fire"],
			item = 20074,
			reagents = {
				{ 3667, 2 },
				{ 3713 },
			},
		},
		[24654] = { --Blue Dragonscale Leggings
			item = 20295,
			reagents = {
				{ 8170,  28 },
				{ 15415, 36 },
				{ 15407, 2 },
				{ 14341, 2 },
			},
		},
		[24655] = { --Green Dragonscale Gauntlets
			item = 20296,
			reagents = {
				{ 8170,  20 },
				{ 15412, 30 },
				{ 15407 },
				{ 14341, 2 },
			},
		},
		[24703] = { --Dreamscale Breastplate
			item = 20380,
			reagents = {
				{ 12810, 12 },
				{ 20381, 6 },
				{ 12803, 4 },
				{ 15407, 4 },
				{ 14227, 6 },
			},
			reagents_VANILLA_PLUS = {
				{ 12810, 40 },
				{ 20381, 6 },
				{ 12803, 10 },
				{ 15407, 12 },
				{ 14227, 10 },
			},
		},
		[24801] = { --Smoked Desert Dumplings
			requires = L["Cooking Fire"],
			item = 20452,
			reagents = {
				{ 20424 },
				{ 3713 },
			},
		},
		[24846] = { --Spitfire Bracers
			item = 20481,
			reagents = {
				{ 20500 },
				{ 20498, 20 },
				{ 7078,  2 },
			},
		},
		[24847] = { --Spitfire Gauntlets
			item = 20480,
			reagents = {
				{ 20500, 2 },
				{ 20498, 30 },
				{ 7078,  2 },
				{ 15407 },
			},
		},
		[24848] = { --Spitfire Breastplate
			item = 20479,
			reagents = {
				{ 20500, 3 },
				{ 20498, 40 },
				{ 7078,  2 },
				{ 15407, 2 },
			},
		},
		[24849] = { --Sandstalker Bracers
			item = 20476,
			reagents = {
				{ 20501 },
				{ 20498, 20 },
				{ 18512, 2 },
			},
		},
		[24850] = { --Sandstalker Gauntlets
			item = 20477,
			reagents = {
				{ 20501, 2 },
				{ 20498, 30 },
				{ 18512, 2 },
				{ 15407 },
			},
		},
		[24851] = { --Sandstalker Breastplate
			item = 20478,
			reagents = {
				{ 20501, 3 },
				{ 20498, 40 },
				{ 18512, 2 },
				{ 15407, 2 },
			},
		},
		[24901] = { --Runed Stygian Leggings
			item = 20538,
			reagents = {
				{ 14048, 6 },
				{ 20520, 8 },
				{ 14256, 6 },
				{ 14227, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 8 },
				{ 20520, 16 },
				{ 14256, 12 },
				{ 14227, 8 },
			},
		},
		[24902] = { --Runed Stygian Belt
			item = 20539,
			reagents = {
				{ 14048, 2 },
				{ 20520, 6 },
				{ 14256, 2 },
				{ 12810, 2 },
				{ 14227, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 4 },
				{ 20520, 12 },
				{ 14256, 4 },
				{ 12810, 4 },
				{ 14227, 8 },
			},
		},
		[24903] = { --Runed Stygian Boots
			item = 20537,
			reagents = {
				{ 14048, 4 },
				{ 20520, 6 },
				{ 14256, 4 },
				{ 12810, 2 },
				{ 14227, 2 },
			},
			reagents_VANILLA_PLUS = {
				{ 14048, 6 },
				{ 20520, 12 },
				{ 14256, 8 },
				{ 12810, 4 },
				{ 14227, 8 },
			},
		},
		[24912] = { --Darkrune Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 20549,
			reagents = {
				{ 12359, 12 },
				{ 20520, 6 },
				{ 6037,  6 },
				{ 12810, 2 },
			},
		},
		[24913] = { --Darkrune Helm
			requires = L["Anvil"],
			tools = { 5956 },
			item = 20551,
			reagents = {
				{ 12359, 16 },
				{ 20520, 8 },
				{ 6037,  8 },
				{ 11754 },
			},
		},
		[24914] = { --Darkrune Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 20550,
			reagents = {
				{ 12359, 20 },
				{ 20520, 10 },
				{ 6037,  10 },
			},
		},
		[24940] = { --Black Whelp Tunic
			item = 20575,
			reagents = {
				{ 2319, 8 },
				{ 7286, 8 },
				{ 4231 },
				{ 2321, 2 },
			},
		},
		[25146] = { --Transmute: Elemental Fire
			tools = { 9149 },
			item = 7068,
			reagents = {
				{ 7077 },
			},
		},
		[25347] = {
			item = 20844,
			reagents = {
				{ 5173, 7 },
				{ 8925 },
			},
		},
		[25659] = { --Dirge's Kickin' Chimaerok Chops
			requires = L["Cooking Fire"],
			item = 21023,
			reagents = {
				{ 2692 },
				{ 9061 },
				{ 8150 },
				{ 21024 },
			},
		},
		[25704] = { --Smoked Sagefish
			requires = L["Cooking Fire"],
			item = 21072,
			reagents = {
				{ 21071 },
				{ 2678 },
			},
		},
		[25954] = { --Sagefish Delight
			requires = L["Cooking Fire"],
			item = 21217,
			reagents = {
				{ 21153 },
				{ 2692 },
			},
		},
		[26011] = { --Tranquil Mechanical Yeti
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 21277,
			reagents = {
				{ 15407 },
				{ 15994, 4 },
				{ 7079,  2 },
				{ 18631, 2 },
				{ 10558 },
			},
		},
		[26085] = { --Soul Pouch
			item = 21340,
			reagents = {
				{ 14048, 6 },
				{ 8170,  4 },
				{ 7972,  2 },
				{ 14341 },
			},
		},
		[26086] = { --Felcloth Bag
			item = 21341,
			reagents = {
				{ 14256, 12 },
				{ 12810, 6 },
				{ 20520, 2 },
				{ 14227, 4 },
			},
		},
		[26087] = { --Core Felcloth Bag
			item = 21342,
			reagents = {
				{ 14256, 20 },
				{ 17012, 16 },
				{ 19726, 8 },
				{ 7078,  4 },
				{ 14227, 4 },
			},
		},
		[26277] = { --Elixir of Greater Firepower
			item = 21546,
			reagents = {
				{ 6371, 3 },
				{ 4625, 3 },
				{ 8925 },
			},
		},
		[26279] = { --Stormshroud Gloves
			item = 21278,
			reagents = {
				{ 12810, 6 },
				{ 7080,  4 },
				{ 7082,  4 },
				{ 15407, 2 },
				{ 14227, 2 },
			},
		},
		[26403] = { --Festive Red Dress
			item = 21154,
			reagents = {
				{ 14048, 4 },
				{ 4625,  2 },
				{ 2604,  2 },
				{ 14341 },
			},
		},
		[26407] = { --Festive Red Pant Suit
			item = 21542,
			reagents = {
				{ 14048, 4 },
				{ 4625,  2 },
				{ 2604,  2 },
				{ 14341 },
			},
		},
		[26416] = { --Small Blue Rocket
			item = 21558,
			reagents = {
				{ 4364 },
				{ 2319 },
			},
		},
		[26417] = { --Small Green Rocket
			item = 21559,
			reagents = {
				{ 4364 },
				{ 2319 },
			},
		},
		[26418] = { --Small Red Rocket
			item = 21557,
			reagents = {
				{ 4364 },
				{ 2319 },
			},
		},
		[26420] = { --Large Blue Rocket
			item = 21589,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[26421] = { --Large Green Rocket
			item = 21590,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[26422] = { --Large Red Rocket
			item = 21592,
			reagents = {
				{ 4377 },
				{ 4234 },
			},
		},
		[26423] = { --Blue Rocket Cluster
			item = 21571,
			reagents = {
				{ 10505 },
				{ 4304 },
			},
		},
		[26424] = { --Green Rocket Cluster
			item = 21574,
			reagents = {
				{ 10505 },
				{ 4304 },
			},
		},
		[26425] = { --Red Rocket Cluster
			item = 21576,
			reagents = {
				{ 10505 },
				{ 4304 },
			},
		},
		[26426] = { --Large Blue Rocket Cluster
			item = 21714,
			reagents = {
				{ 15992 },
				{ 8170 },
			},
		},
		[26427] = { --Large Green Rocket Cluster
			item = 21716,
			reagents = {
				{ 15992 },
				{ 8170 },
			},
		},
		[26428] = { --Large Red Rocket Cluster
			item = 21718,
			reagents = {
				{ 15992 },
				{ 8170 },
			},
		},
		[26442] = { --Firework Launcher
			item = 21569,
			reagents = {
				{ 9060 },
				{ 9061 },
				{ 10560 },
				{ 10561 },
			},
		},
		[26443] = { --Firework Cluster Launcher
			item = 21570,
			reagents = {
				{ 9060,  4 },
				{ 9061,  4 },
				{ 18631, 2 },
				{ 10561 },
			},
		},
		[27585] = { --Heavy Obsidian Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22197,
			reagents = {
				{ 22202, 14 },
				{ 12655, 4 },
				{ 7076,  2 },
			},
			reagents_VANILLA_PLUS = {
				{ 12360, 5 },
				{ 22202, 20 },
				{ 12655, 30 },
				{ 7076,  10 },
			},
		},
		[27586] = { --Jagged Obsidian Shield
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22198,
			reagents = {
				{ 22203, 8 },
				{ 22202, 24 },
				{ 12655, 8 },
				{ 7076,  4 },
			},
			reagents_VANILLA_PLUS = {
				{ 22203, 10 },
				{ 22202, 30 },
				{ 12360, 10 },
				{ 12655, 20 },
				{ 7076,  10 },
			},
		},
		[27587] = { --Thick Obsidian Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22196,
			reagents = {
				{ 22203, 18 },
				{ 22202, 40 },
				{ 12655, 12 },
				{ 7076,  10 },
				{ 12364, 4 },
			},
		},
		[27588] = { --Light Obsidian Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22195,
			reagents = {
				{ 22202, 14 },
				{ 12810, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 12655, 24 },
				{ 22202, 20 },
				{ 12810, 10 },
				{ 7082,  10 },
			},
		},
		[27589] = { --Black Grasp of the Destroyer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22194,
			reagents = {
				{ 22203, 8 },
				{ 22202, 24 },
				{ 12810, 8 },
				{ 13512 },
			},
		},
		[27590] = { --Obsidian Mail Tunic
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22191,
			reagents = {
				{ 22203, 15 },
				{ 22202, 36 },
				{ 12810, 12 },
				{ 12809, 10 },
				{ 12800, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 22203, 20 },
				{ 22202, 40 },
				{ 12810, 20 },
				{ 12809, 12 },
				{ 12800, 8 },
				{ 12364, 8 },
			},
		},
		[27658] = { --Enchanted Mageweave Pouch
			item = 22246,
			reagents = {
				{ 4339,  4 },
				{ 11137, 4 },
				{ 8343,  2 },
			},
		},
		[27659] = { --Enchanted Runecloth Bag
			item = 22248,
			reagents = {
				{ 14048, 5 },
				{ 16203, 2 },
				{ 14341, 2 },
			},
		},
		[27660] = { --Big Bag of Enchantment
			item = 22249,
			reagents = {
				{ 14048, 6 },
				{ 14344, 4 },
				{ 12810, 4 },
				{ 14227, 4 },
			},
		},
		[27724] = { --Cenarion Herb Bag
			item = 22251,
			reagents = {
				{ 14048, 5 },
				{ 8831,  10 },
				{ 11040, 8 },
				{ 14341, 2 },
			},
		},
		[27725] = { --Satchel of Cenarius
			item = 22252,
			reagents = {
				{ 14048, 6 },
				{ 14342, 2 },
				{ 13468 },
				{ 14227, 4 },
			},
		},
		[27829] = { --Titanic Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22385,
			reagents = {
				{ 12360, 12 },
				{ 12655, 20 },
				{ 7076,  10 },
				{ 13510, 2 },
			},
		},
		[27830] = { --Persuader
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22384,
			reagents = {
				{ 12360, 15 },
				{ 11371, 10 },
				{ 12808, 20 },
				{ 20520, 20 },
				{ 15417, 10 },
				{ 12753, 2 },
			},
		},
		[27832] = { --Sageblade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22383,
			reagents = {
				{ 12360, 12 },
				{ 20725, 2 },
				{ 13512, 2 },
				{ 12810, 4 },
			},
		},
		[28205] = { --Glacial Gloves
			item = 22654,
			reagents = {
				{ 22682, 5 },
				{ 14048, 4 },
				{ 7080,  4 },
				{ 14227, 4 },
			},
		},
		[28207] = { --Glacial Vest
			item = 22652,
			reagents = {
				{ 22682, 7 },
				{ 14048, 8 },
				{ 7080,  6 },
				{ 14227, 8 },
			},
		},
		[28208] = { --Glacial Cloak
			item = 22658,
			reagents = {
				{ 22682, 5 },
				{ 14048, 4 },
				{ 7080,  2 },
				{ 14227, 4 },
			},
		},
		[28209] = { --Glacial Wrists
			item = 22655,
			reagents = {
				{ 22682, 4 },
				{ 14048, 2 },
				{ 7080,  2 },
				{ 14227, 4 },
			},
		},
		[28210] = { --Gaea's Embrace
			item = 22660,
			reagents = {
				{ 19726 },
				{ 14342, 2 },
				{ 12803, 4 },
				{ 14227, 4 },
			},
			reagents_VANILLA_PLUS = {
				{ 19726, 3 },
				{ 14342, 3 },
				{ 12803, 8 },
				{ 14227, 4 },
			},
		},
		[28219] = { --Polar Tunic
			item = 22661,
			reagents = {
				{ 22682, 7 },
				{ 12810, 16 },
				{ 7080,  2 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[28220] = { --Polar Gloves
			item = 22662,
			reagents = {
				{ 22682, 5 },
				{ 12810, 12 },
				{ 7080,  2 },
				{ 15407, 3 },
				{ 14227, 4 },
			},
		},
		[28221] = { --Polar Bracers
			item = 22663,
			reagents = {
				{ 22682, 4 },
				{ 12810, 12 },
				{ 7080,  2 },
				{ 15407, 2 },
				{ 14227, 4 },
			},
		},
		[28222] = { --Icy Scale Breastplate
			item = 22664,
			reagents = {
				{ 22682, 7 },
				{ 15408, 24 },
				{ 7080,  2 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[28223] = { --Icy Scale Gauntlets
			item = 22666,
			reagents = {
				{ 22682, 5 },
				{ 15408, 16 },
				{ 7080,  2 },
				{ 15407, 3 },
				{ 14227, 4 },
			},
		},
		[28224] = { --Icy Scale Bracers
			item = 22665,
			reagents = {
				{ 22682, 4 },
				{ 15408, 16 },
				{ 7080,  2 },
				{ 15407, 2 },
				{ 14227, 4 },
			},
		},
		[28242] = { --Icebane Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22669,
			reagents = {
				{ 22682, 7 },
				{ 12359, 16 },
				{ 12360, 2 },
				{ 7080,  4 },
			},
		},
		[28243] = { --Icebane Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22670,
			reagents = {
				{ 22682, 5 },
				{ 12359, 12 },
				{ 12360, 2 },
				{ 7080,  2 },
			},
		},
		[28244] = { --Icebane Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22671,
			reagents = {
				{ 22682, 4 },
				{ 12359, 12 },
				{ 12360, 2 },
				{ 7080,  2 },
			},
		},
		[28327] = { --Steam Tonk Controller
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 22728,
			reagents = {
				{ 15994, 2 },
				{ 10561 },
				{ 10558 },
			},
		},
		[28461] = { --Ironvine Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22762,
			reagents = {
				{ 12655, 12 },
				{ 19726, 2 },
				{ 12360, 2 },
				{ 12803, 2 },
			},
		},
		[28462] = { --Ironvine Gloves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22763,
			reagents = {
				{ 12655, 8 },
				{ 19726 },
				{ 12803, 2 },
			},
		},
		[28463] = { --Ironvine Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22764,
			reagents = {
				{ 12655, 6 },
				{ 12803, 2 },
			},
		},
		[28472] = { --Bramblewood Helm
			item = 22759,
			reagents = {
				{ 12810, 12 },
				{ 19726, 2 },
				{ 12803, 2 },
				{ 15407, 2 },
			},
		},
		[28473] = { --Bramblewood Boots
			item = 22760,
			reagents = {
				{ 12810, 6 },
				{ 18512, 2 },
				{ 12803, 2 },
				{ 15407, 2 },
			},
		},
		[28474] = { --Bramblewood Belt
			item = 22761,
			reagents = {
				{ 12810, 4 },
				{ 12803, 2 },
				{ 15407 },
			},
		},
		[28480] = { --Sylvan Vest
			item = 22756,
			reagents = {
				{ 14048, 4 },
				{ 19726, 2 },
				{ 12803, 2 },
				{ 14227, 2 },
			},
		},
		[28481] = { --Sylvan Crown
			item = 22757,
			reagents = {
				{ 14048, 4 },
				{ 14342, 2 },
				{ 12803, 2 },
				{ 14227, 2 },
			},
		},
		[28482] = { --Sylvan Shoulders
			item = 22758,
			reagents = {
				{ 14048, 2 },
				{ 12803, 4 },
				{ 14227, 2 },
			},
		},
		[30021] = { --Magic Infused Bandage
			item = 23684,
			reagents = {
				{ 14047, 3 },
				{ 16204 },
			},
		},
		[34324] = { --Flask of Indomitable Might
			tools = { 9149 },
			item = 34323,
			reagents = {
				{ 8846,  30 },
				{ 13466, 10 },
				{ 13468 },
				{ 8925 },
			},
		},
		[34326] = { --Lunar Crescent
			requires = L["Anvil"],
			tools = { 5956 },
			item = 19169,
			reagents = {
				{ 12360, 12 },
				{ 12644, 25 },
				{ 12655, 16 },
				{ 12359, 12 },
				{ 1705,  6 },
				{ 14342, 3 },
			},
		},
		[34327] = { --Lionheart Blade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12790,
			reagents = {
				{ 12360, 14 },
				{ 12644, 8 },
				{ 12811, 4 },
				{ 12359, 25 },
				{ 15419, 8 },
				{ 13459, 2 },
			},
		},
		[34328] = { --Thunder
			requires = L["Anvil"],
			tools = { 5956 },
			item = 12796,
			reagents = {
				{ 12360, 12 },
				{ 12359, 50 },
				{ 7082,  8 },
				{ 7080,  8 },
				{ 7081,  12 },
				{ 7079,  12 },
				{ 15417, 8 },
			},
		},
		[34329] = { --Lionheart
			requires = L["Anvil"],
			tools = { 5956 },
			item = 22198,
			reagents = {
				{ 12360, 15 },
				{ 12359, 80 },
				{ 12811, 5 },
				{ 3577,  12 },
				{ 12809, 12 },
				{ 12799, 6 },
			},
		},
		[35679] = { --Vital Devilsaur Hide
			item = 83123,
			reagents = {
				{ 83166, 2 },
				{ 4096,  30 },
				{ 8146,  15 },
				{ 19933, 15 },
			},
		},
		[100000] = {
			name = LS["Mining: Copper Vein"], --1+
			tools = { 2901 },
			item = 2770,
			quantity = { 2, 4 },
		},
		[100001] = {
			name = LS["Mining: Incendicite Mineral Vein"], --65+
			tools = { 2901 },
			item = 3340,
			quantity = { 1, 2 },
		},
		[100002] = {
			name = LS["Mining: Tin Vein"], --65+
			tools = { 2901 },
			item = 2771,
			quantity = { 2, 4 },
		},
		[100003] = {
			name = LS["Mining: Silver Vein"], --75+
			tools = { 2901 },
			item = 2775,
			quantity = { 2, 4 },
		},
		[100004] = {
			name = LS["Mining: Ooze Covered Silver Vein"], --75+
			tools = { 2901 },
			item = 2775,
			quantity = { 2, 4 },
		},
		[100005] = {
			name = LS["Mining: Lesser Bloodstone Deposit"], --75+
			tools = { 2901 },
			item = 4278,
			quantity = { 1, 3 },
		},
		[100006] = {
			name = LS["Mining: Iron Deposit"], --125+
			tools = { 2901 },
			item = 2772,
			quantity = { 2, 4 },
		},
		[100007] = {
			name = LS["Mining: Ooze Covered Iron Deposit"], --125+
			tools = { 2901 },
			item = 2772,
			quantity = { 2, 4 },
		},
		[100008] = {
			name = LS["Mining: Indurium Mineral Vein"], --125+
			tools = { 2901 },
			item = 5833,
		},
		[100009] = {
			name = LS["Mining: Gold Vein"], --155+
			tools = { 2901 },
			item = 2776,
			quantity = { 2, 4 },
		},
		[100010] = {
			name = LS["Mining: Ooze Covered Gold Vein"], --155+
			tools = { 2901 },
			item = 2776,
			quantity = { 2, 4 },
		},
		[100011] = {
			name = LS["Mining: Mithril Deposit"], --175+
			tools = { 2901 },
			item = 3858,
			quantity = { 2, 4 },
		},
		[100012] = {
			name = LS["Mining: Ooze Covered Mithril Deposit"], --175+
			tools = { 2901 },
			item = 3858,
			quantity = { 2, 4 },
		},
		[100013] = {
			name = LS["Mining: Truesilver Deposit"], --230+
			tools = { 2901 },
			item = 7911,
			quantity = { 2, 4 },
		},
		[100014] = {
			name = LS["Mining: Ooze Covered Truesilver Deposit"], --230+
			tools = { 2901 },
			item = 7911,
			quantity = { 2, 4 },
		},
		[100015] = {
			name = LS["Mining: Dark Iron Deposit"], --230+
			tools = { 2901 },
			item = 11370,
			quantity = { 2, 4 },
		},
		[100016] = {
			name = LS["Mining: Small Thorium Vein"], --245+
			tools = { 2901 },
			item = 10620,
			quantity = { 2, 3 },
		},
		[100017] = {
			name = LS["Mining: Ooze Covered Thorium Vein"], --245+
			tools = { 2901 },
			item = 10620,
			quantity = { 2, 3 },
		},
		[100018] = {
			name = LS["Mining: Rich Thorium Vein"], --275+
			tools = { 2901 },
			item = 10620,
			quantity = { 4, 5 },
		},
		[100019] = {
			name = LS["Mining: Ooze Covered Rich Thorium Vein"], --275+
			tools = { 2901 },
			item = 10620,
			quantity = { 4, 5 },
		},
		[100020] = {
			name = LS["Mining: Hakkari Thorium Vein"], --275+
			tools = { 2901 },
			item = 10620,
			quantity = { 4, 5 },
		},
		[100021] = {
			name = LS["Mining: Small Obsidian Chunk"], --305+
			tools = { 2901 },
			item = 22202,
		},
		[100022] = {
			name = LS["Mining: Large Obsidian Chunk"], --305+
			tools = { 2901 },
			item = 22203,
			quantity = { 1, 3 },
		},
		[100023] = {
			name = LS["Mining: Gemstone Deposit"], --310+
			tools = { 2901 },
			item = 55252,
		},
		[45054] = { --Maritime Gumbo
			requires = L["Cooking Fire"],
			item = 30818,
			reagents = {
				{ 2674 },
				{ 159 },
			},
		},
		[45057] = { --Unstable Mining Dynamite
			item = 51268,
			reagents = {
				{ 4359, 4 },
				{ 2589, 2 },
				{ 4357, 2 },
			},
		},
		[45061] = { --Volatile Concoction
			item = 51262,
			reagents = {
				{ 814 },
				{ 730 },
				{ 3371 },
			},
		},
		[45063] = { --Blast Shield
			requires = L["Anvil"],
			tools = { 5956 },
			item = 51264,
			reagents = {
				{ 2840, 12 },
				{ 3470, 2 },
				{ 818,  2 },
			},
		},
		[45066] = { --Gloves of Manathirst
			item = 51256,
			reagents = {
				{ 2996, 3 },
				{ 2321, 2 },
				{ 6260, 3 },
			},
		},
		[45069] = { --Lynxstep Boots
			item = 51284,
			reagents = {
				{ 2318, 8 },
				{ 2321, 2 },
				{ 4231 },
				{ 818 },
			},
		},
		[45407] = { --Ritual of Refreshment
			reagents = {
				{ 17020, 2 },
			},
		},
		[45451] = { --Smelt Dreamsteel
			item = 61216,
			reagents = {
				{ 61198 },
				{ 3859 },
				{ 20381 },
			},
			requires_TURTLE = L["Forge"],
		},
		[45453] = { --Dreamthread
			item = 61230,
			reagents = {
				{ 61198 },
				{ 14341 },
				{ 20381 },
			},
		},
		[45455] = { --Dreamhide
			item = 61229,
			reagents = {
				{ 61198 },
				{ 8170 },
				{ 20381 },
			},
		},
		[45457] = { --Dreamthread Mantle
			item = 61360,
			reagents = {
				{ 61230, 20 },
				{ 14342, 6 },
				{ 12810, 4 },
				{ 14048, 40 },
				{ 7082,  6 },
				{ 12803, 6 },
			},
		},
		[45459] = { --Dreamthread Kilt
			item = 61361,
			reagents = {
				{ 61230, 14 },
				{ 14342, 4 },
				{ 14048, 24 },
				{ 7082,  4 },
				{ 7080,  4 },
				{ 12803, 4 },
			},
		},
		[45461] = { --Dreamthread Bracers
			item = 61362,
			reagents = {
				{ 61230, 8 },
				{ 14342, 2 },
				{ 7080,  2 },
				{ 7082,  2 },
			},
		},
		[45463] = { --Dreamthread Gloves
			item = 61363,
			reagents = {
				{ 61230, 8 },
				{ 14342, 4 },
				{ 14048, 12 },
				{ 7082,  4 },
				{ 12803, 4 },
			},
		},
		[45465] = { --Dreamsteel Mantle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61364,
			reagents = {
				{ 61216, 20 },
				{ 12810, 12 },
				{ 12360, 8 },
				{ 12799, 8 },
				{ 12644, 8 },
				{ 12800, 2 },
			},
		},
		[45467] = { --Dreamsteel Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61365,
			reagents = {
				{ 61216, 14 },
				{ 12810, 8 },
				{ 12655, 8 },
				{ 12364, 8 },
			},
		},
		[45469] = { --Dreamsteel Bracers
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61366,
			reagents = {
				{ 61216, 8 },
				{ 12810, 4 },
				{ 12655, 4 },
				{ 12644, 4 },
			},
		},
		[45471] = { --Dreamsteel Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61367,
			reagents = {
				{ 61216, 8 },
				{ 12810, 8 },
				{ 12655, 8 },
				{ 12644, 2 },
				{ 12800, 2 },
			},
		},
		[45473] = { --Dreamhide Mantle
			item = 61356,
			reagents = {
				{ 61229, 22 },
				{ 12810, 20 },
				{ 15407, 6 },
				{ 12803, 6 },
			},
		},
		[45475] = { --Dreamhide Bracers
			item = 61357,
			reagents = {
				{ 61229, 8 },
				{ 12810, 6 },
				{ 15407 },
				{ 12803, 2 },
			},
		},
		[45477] = { --Dreamhide Leggings
			item = 61358,
			reagents = {
				{ 61229, 12 },
				{ 12810, 12 },
				{ 15407, 4 },
				{ 12803, 6 },
				{ 7082,  6 },
			},
		},
		[45479] = { --Dreamhide Belt
			item = 61359,
			reagents = {
				{ 61229, 8 },
				{ 12810, 12 },
				{ 15407, 2 },
				{ 14341, 8 },
				{ 7082,  8 },
			},
		},
		[45481] = { --Intricate Gyroscope Goggles
			requires = L["Anvil"],
			tools = { 10498, 6219 },
			item = 61187,
			reagents = {
				{ 16006, 8 },
				{ 12810, 10 },
				{ 12655, 8 },
				{ 15994, 6 },
				{ 10548, 2 },
				{ 12800 },
			},
		},
		[45483] = { --Inscribed Runic Bracers
			item = 61188,
			reagents = {
				{ 12810, 12 },
				{ 15407, 4 },
				{ 12803, 4 },
				{ 7076,  8 },
				{ 14341, 8 },
			},
		},
		[45485] = { --Gloves of Unwinding Mystery
			item = 61186,
			reagents = {
				{ 14048, 14 },
				{ 9210,  10 },
				{ 14344 },
				{ 12810 },
				{ 8846,  24 },
			},
		},
		[45487] = { --Dawnstone Hammer
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61185,
			reagents = {
				{ 12360, 16 },
				{ 12811, 6 },
				{ 12800, 6 },
				{ 12810, 6 },
				{ 13926, 6 },
				{ 12644, 10 },
			},
		},
		[45503] = { --Big Bad Voodoo
			reagents = {
				{ 12804 },
			},
		},
		[45566] = { --Summon Champion
			reagents = {
				{ 17028, 5 },
			},
		},
		[45607] = { --Flashbang
			reagents = {
				{ 5140 },
			},
		},
		[45625] = { --Le Fishe Au Chocolat
			requires = L["Cooking Fire"],
			item = 84040,
			reagents = {
				{ 13889 },
				{ 3713 },
				{ 61173 },
				{ 13464 },
			},
		},
		[45627] = { --Gilneas Hot Stew
			requires = L["Cooking Fire"],
			item = 84041,
			reagents = {
				{ 12203 },
				{ 12205 },
				{ 159 },
			},
		},
		[45989] = { --Elixir of Greater Nature Power
			item = 50237,
			reagents = {
				{ 10286, 3 },
				{ 13464 },
				{ 8838 },
				{ 8925 },
			},
		},
		[46064] = { --Dim Torch
			item = 6182,
			reagents = {
				{ 6183 },
			},
		},
		[46066] = { --Murloc's Flippers
			item = 65028,
			reagents = {
				{ 5785, 16 },
				{ 4234, 8 },
				{ 8343, 2 },
				{ 6370, 3 },
				{ 6372 },
			},
			reagents_TURTLE = {
				{ 2319,  4 },
				{ 2321,  2 },
				{ 5784,  8 },
				{ 6372 },
				{ 17058, 2 },
			},
		},
		[46068] = { --Cleaning Cloth
			item = 60001,
			reagents = {
				{ 4306, 2 },
				{ 9260 },
			},
		},
		[46072] = { --Traveler's Tent
			item = 51283,
			reagents = {
				{ 4470, 5 },
				{ 2589, 10 },
				{ 50231 },
			},
		},
		[46073] = { --Fishing Boat
			tools = { 42004 },
			item = 51282,
			reagents = {
				{ 4470,  20 },
				{ 4359,  10 },
				{ 17058, 2 },
			},
		},
		[46074] = { --Simple Wooden Planter
			item = 51705,
			reagents = {
				{ 4470, 10 },
				{ 4359, 4 },
			},
		},
		[46075] = { --Iron Lantern
			requires = L["Anvil"],
			tools = { 5956 },
			item = 2714,
			reagents = {
				{ 3575, 2 },
				{ 814,  4 },
				{ 2592, 5 },
			},
			reagents_TURTLE = {
				{ 3575, 4 },
				{ 2592, 8 },
				{ 814,  4 },
			},
		},
		[46077] = { --Repaired Electro-Lantern
			item = 65030,
			reagents = {
				{ 1630,  5 },
				{ 10561 },
				{ 4359 },
				{ 4375 },
				{ 4404,  2 },
				{ 10558, 2 },
			},
		},
		[46085] = { --Gurubashi Gumbo
			requires = L["Cooking Fire"],
			item = 53015,
			reagents = {
				{ 3667 },
				{ 12202 },
				{ 12037, 2 },
				{ 2692 },
				{ 3713 },
				{ 159 },
			},
		},
		[46600] = { --Lordaeron Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 46600,
			reagents = {
				{ 2840, 16 },
				{ 818,  2 },
				{ 3470, 3 },
			},
		},
		[46608] = { --Hypertech Battery Pack
			requires = L["Anvil"],
			tools = { 6219, 10498 },
			item = 60098,
			reagents = {
				{ 10558, 2 },
				{ 10561 },
				{ 4404,  4 },
			},
			reagents_TURTLE = {
				{ 10558 },
				{ 10561 },
				{ 4404 },
			},
		},
		[46610] = { --Battery-Powered Crowd Pummeler
			requires = L["Anvil"],
			tools = { 10498, 5956 },
			item = 60099,
			reagents = {
				{ 9449 },
				{ 60098, 5 },
				{ 814,   2 },
				{ 7191,  4 },
				{ 3829 },
				{ 4375,  6 },
				{ 18631 },
			},
			reagents_TURTLE = {
				{ 9449 },
				{ 60098 },
				{ 814,  2 },
				{ 7191 },
				{ 3829 },
				{ 4375, 6 },
				{ 18631 },
			},
		},
		[46612] = { --Remote Mail Terminal
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 60097,
			reagents = {
				{ 4382 },
				{ 4359,  2 },
				{ 10558, 3 },
				{ 7191 },
			},
		},
		[46616] = { --Drums of Battle
			requires = L["Anvil"],
			item = 60097,
			reagents = {
				{ 15407, 3 },
				{ 12810, 8 },
				{ 3470,  3 },
				{ 7082,  4 },
				{ 7076,  4 },
				{ 7078,  4 },
				{ 19768, 10 },
				{ 14341, 3 },
			},
		},
		[46620] = { --Grifter's Boots
			item = 83405,
			reagents = {
				{ 4304, 7 },
				{ 4291, 3 },
			},
		},
		[46621] = { --Grifter's Gauntlets
			item = 83404,
			reagents = {
				{ 4304, 6 },
				{ 4291, 2 },
			},
		},
		[46622] = { --Grifter's Belt
			item = 83403,
			reagents = {
				{ 4234, 10 },
				{ 4291 },
				{ 4236 },
			},
		},
		[46623] = { --Grifter's Leggings
			item = 83402,
			reagents = {
				{ 4304, 10 },
				{ 4234, 2 },
				{ 4291, 3 },
				{ 2605 },
			},
		},
		[46624] = { --Grifter's Tunic
			item = 83401,
			reagents = {
				{ 4304, 12 },
				{ 3575, 2 },
				{ 4291, 4 },
				{ 2605, 2 },
			},
		},
		[46625] = { --Grifter's Cover
			item = 83400,
			reagents = {
				{ 4304, 8 },
				{ 4338, 4 },
				{ 4291, 2 },
				{ 2605 },
			},
		},
		[46626] = { --Steel Plate Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83410,
			reagents = {
				{ 3859, 14 },
				{ 7966, 2 },
			},
		},
		[46627] = { --Steel Plate Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83411,
			reagents = {
				{ 3859, 16 },
				{ 7966, 4 },
			},
		},
		[46628] = { --Steel Plate Legguards
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83412,
			reagents = {
				{ 3859, 18 },
				{ 7966, 2 },
				{ 3864 },
			},
		},
		[46629] = { --Steel Plate Armor
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83413,
			reagents = {
				{ 3859, 20 },
				{ 7966, 4 },
				{ 3864 },
				{ 1705 },
			},
		},
		[46630] = { --Steel Plate Pauldrons
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83414,
			reagents = {
				{ 3859, 20 },
				{ 7966, 3 },
				{ 3864 },
				{ 6037 },
			},
		},
		[46631] = { --Steel Plate Barbute
			requires = L["Anvil"],
			tools = { 5956 },
			item = 83415,
			reagents = {
				{ 3859, 10 },
				{ 6037, 8 },
				{ 3864, 4 },
				{ 7966, 3 },
				{ 7909, 2 },
				{ 7922 },
			},
		},
		[46633] = { --Diviner's Pantaloons
			item = 83280,
			reagents = {
				{ 4339, 4 },
				{ 8343, 2 },
				{ 2842 },
				{ 2324 },
			},
		},
		[46634] = { --Diviner's Robes
			item = 83281,
			reagents = {
				{ 4339, 10 },
				{ 8343, 4 },
				{ 2842, 2 },
				{ 2324 },
				{ 17028 },
				{ 5500 },
			},
		},
		[46635] = { --Diviner's Cowl
			item = 83282,
			reagents = {
				{ 4339, 4 },
				{ 8343 },
				{ 2842 },
				{ 2324 },
			},
		},
		[46636] = { --Diviner's Boots
			item = 83283,
			reagents = {
				{ 4339, 3 },
				{ 8343, 3 },
				{ 2324 },
				{ 4304, 2 },
			},
		},
		[46637] = { --Diviner's Mitts
			item = 83284,
			reagents = {
				{ 4339, 3 },
				{ 8343, 2 },
				{ 2324 },
				{ 6048 },
			},
		},
		[46638] = { --Diviner's Epaulets
			item = 83285,
			reagents = {
				{ 4339, 6 },
				{ 8343, 2 },
				{ 2842 },
				{ 17028 },
				{ 2324 },
			},
		},
		[46639] = { --Augerer's Hat
			item = 83286,
			reagents = {
				{ 4339, 3 },
				{ 8343 },
				{ 6260 },
				{ 7070 },
				{ 3827, 2 },
			},
		},
		[46640] = { --Augerer's Robe
			item = 83287,
			reagents = {
				{ 4339, 6 },
				{ 8343 },
				{ 6260, 2 },
				{ 7070, 2 },
				{ 1705, 2 },
				{ 20746 },
			},
		},
		[46641] = { --Augerer's Trousers
			item = 83291,
			reagents = {
				{ 4339, 4 },
				{ 8343 },
				{ 6260 },
				{ 7070 },
				{ 3827, 2 },
			},
		},
		[46642] = { --Augerer's Mantle
			item = 83290,
			reagents = {
				{ 4339, 3 },
				{ 8343 },
				{ 6260 },
				{ 7070 },
				{ 6149, 2 },
			},
		},
		[46643] = { --Augerer's Gloves
			item = 83289,
			reagents = {
				{ 4339, 3 },
				{ 8343, 2 },
				{ 6260 },
				{ 6373 },
				{ 9036 },
			},
		},
		[46644] = { --Augerer's Boots
			item = 83288,
			reagents = {
				{ 4339, 2 },
				{ 8343 },
				{ 6260 },
				{ 7070 },
				{ 4234, 3 },
			},
		},
		[46645] = { --Pillager's Hood
			item = 83292,
			reagents = {
				{ 14048, 5 },
				{ 7068,  2 },
				{ 14341 },
			},
		},
		[46646] = { --Pillager's Amice
			item = 83293,
			reagents = {
				{ 14048, 4 },
				{ 7068 },
				{ 14341, 3 },
				{ 4625 },
			},
		},
		[46647] = { --Pillager's Robe
			item = 83294,
			reagents = {
				{ 14048, 8 },
				{ 7068,  3 },
				{ 14341, 4 },
				{ 7078,  2 },
				{ 4625,  4 },
				{ 6037,  2 },
			},
		},
		[46648] = { --Pillager's Grips
			item = 83295,
			reagents = {
				{ 14048, 2 },
				{ 7077,  4 },
				{ 14341 },
			},
		},
		[46649] = { --Pillager's Shoes
			item = 83296,
			reagents = {
				{ 14048, 2 },
				{ 8170,  2 },
				{ 14341 },
				{ 6371 },
			},
		},
		[46650] = { --Pillager's Pantaloons
			item = 83297,
			reagents = {
				{ 14048, 4 },
				{ 7077,  4 },
				{ 14341, 2 },
				{ 4625 },
			},
		},
		[46651] = { --Bloodstone Warblade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60294,
			reagents = {
				{ 3860, 14 },
				{ 4278, 10 },
				{ 7966, 4 },
				{ 3864, 2 },
			},
		},
		[46652] = { --Untempered Runeblade
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60293,
			reagents = {
				{ 12655, 25 },
				{ 12808, 10 },
				{ 20520, 8 },
				{ 12810, 2 },
				{ 12644, 6 },
				{ 12364 },
			},
		},
		[46653] = { --Red Dragonscale Leggings
			item = 65000,
			reagents = {
				{ 8170,  35 },
				{ 15414, 40 },
				{ 12810, 4 },
				{ 12803, 6 },
				{ 14341, 2 },
			},
		},
		[46654] = { --Red Dragonscale Shoulders
			item = 65001,
			reagents = {
				{ 8170,  30 },
				{ 15414, 30 },
				{ 12810, 3 },
				{ 12803, 4 },
				{ 14341 },
			},
		},
		[46655] = { --Red Dragonscale Boots
			item = 65002,
			reagents = {
				{ 8170,  30 },
				{ 15414, 25 },
				{ 12810, 2 },
				{ 12803, 4 },
				{ 14341, 2 },
			},
		},
		[46656] = { --Robe of Sacrifice
			item = 65003,
			reagents = {
				{ 14048, 12 },
				{ 14256, 20 },
				{ 12662, 20 },
				{ 10285, 8 },
				{ 7971,  4 },
				{ 14341 },
				{ 20520, 10 },
			},
		},
		[46657] = { --Ornate Bloodstone Dagger
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65004,
			reagents = {
				{ 12360, 14 },
				{ 3577,  6 },
				{ 12938 },
				{ 11752 },
				{ 8846,  10 },
				{ 11382, 2 },
				{ 12644, 4 },
				{ 4278,  10 },
			},
			reagents_TURTLE = {
				{ 12360, 14 },
				{ 3577,  6 },
				{ 12938 },
				{ 11752 },
				{ 8846,  10 },
				{ 11382, 2 },
				{ 12644, 4 },
			},
		},
		[46658] = { --Bloodletter Razor
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65005,
			reagents = {
				{ 3860, 24 },
				{ 6037, 10 },
				{ 7910, 8 },
				{ 4304, 4 },
				{ 7966, 6 },
			},
		},
		[46659] = { --Stormscale Leggings
			item = 65006,
			reagents = {
				{ 8170,  30 },
				{ 12810, 16 },
				{ 20295 },
				{ 15407, 4 },
				{ 15415, 40 },
				{ 7082,  12 },
			},
		},
		[46660] = { --Imperial Plate Gauntlets
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65007,
			reagents = {
				{ 12359, 24 },
				{ 7910 },
				{ 8170,  4 },
			},
		},
		[46661] = { --Dream's Herald
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65008,
			reagents = {
				{ 12360, 14 },
				{ 20002, 10 },
				{ 9197,  20 },
				{ 12803, 10 },
				{ 12364, 10 },
				{ 12644, 4 },
			},
		},
		[46662] = { --Shadowskin Boots
			item = 65009,
			reagents = {
				{ 4304, 8 },
				{ 7428, 8 },
				{ 7971, 2 },
				{ 4236, 4 },
				{ 1210, 6 },
				{ 8343, 2 },
			},
		},
		[46663] = { --Copper Knuckles
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65010,
			reagents = {
				{ 2840, 8 },
				{ 3470, 2 },
			},
		},
		[46664] = { --Sharpened Claw
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65011,
			reagents = {
				{ 2840, 8 },
				{ 3470, 4 },
				{ 2880, 4 },
			},
		},
		[46665] = { --Bronze Bruiser
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65012,
			reagents = {
				{ 2841, 6 },
				{ 1705, 2 },
				{ 3466, 2 },
				{ 3478, 4 },
				{ 3391, 2 },
			},
		},
		[46666] = { --Frostbound Slasher
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65013,
			reagents = {
				{ 3859, 10 },
				{ 3486, 4 },
				{ 3466, 4 },
				{ 3829, 2 },
				{ 7070, 4 },
			},
		},
		[46667] = { --Pauldron of Deflection
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65014,
			reagents = {
				{ 11371, 10 },
				{ 12360, 10 },
				{ 12809, 8 },
				{ 22203, 4 },
				{ 7076,  6 },
			},
		},
		[46668] = { --Scroll of Spirit
			item = 1181,
			reagents = {
				{ 10648 },
				{ 765,  2 },
				{ 10940 },
			},
		},
		[46669] = { --Scroll of Protection
			item = 3013,
			reagents = {
				{ 10648, 12 },
				{ 2449,  6 },
				{ 10940, 10 },
			},
		},
		[46670] = { --Scroll of Intellect
			item = 955,
			reagents = {
				{ 10648 },
				{ 765,  2 },
				{ 10938 },
			},
		},
		[46671] = { --Scroll of Stamina
			item = 1181,
			reagents = {
				{ 10648 },
				{ 2449, 2 },
				{ 10938 },
			},
		},
		[46672] = { --Scroll of Strength
			item = 954,
			reagents = {
				{ 10648 },
				{ 765,  2 },
				{ 2449 },
			},
		},
		[46673] = { --Scroll of Agility
			item = 3012,
			reagents = {
				{ 10648 },
				{ 2452,  2 },
				{ 10938, 2 },
			},
		},
		[46674] = { --Scroll of Thorns
			item = 65019,
			reagents = {
				{ 10648 },
				{ 765,  2 },
				{ 10939 },
			},
		},
		[46675] = { --Scroll of Empowered Protection
			item = 65017,
			reagents = {
				{ 10648 },
				{ 1478 },
				{ 3355 },
				{ 2453 },
				{ 11082 },
			},
		},
		[46676] = { --Scroll of Protection II
			item = 1478,
			reagents = {
				{ 10648 },
				{ 3355 },
				{ 11083 },
			},
		},
		[46677] = { --Scroll of Spirit II
			item = 1712,
			reagents = {
				{ 10648 },
				{ 3356, 2 },
				{ 11083 },
			},
		},
		[46678] = { --Scroll of Intellect II
			item = 2290,
			reagents = {
				{ 10648 },
				{ 3356 },
				{ 11082 },
			},
		},
		[46679] = { --Scroll of Stamina II
			item = 1711,
			reagents = {
				{ 10648 },
				{ 3357 },
				{ 11082 },
			},
		},
		[46680] = { --Scroll of Strength II
			item = 2289,
			reagents = {
				{ 10648 },
				{ 3821 },
				{ 11082 },
			},
		},
		[46681] = { --Scroll of Agility II
			item = 1477,
			reagents = {
				{ 10648 },
				{ 3818 },
				{ 11082 },
			},
		},
		[46682] = { --Scroll of Magical Warding
			item = 65018,
			reagents = {
				{ 10648 },
				{ 3358, 2 },
				{ 3356 },
				{ 11082 },
			},
		},
		[46683] = { --Scroll of Protection III
			item = 4421,
			reagents = {
				{ 10648 },
				{ 8831 },
				{ 11137 },
			},
		},
		[46684] = { --Scroll of Spirit III
			item = 4424,
			reagents = {
				{ 10648 },
				{ 10286, 2 },
				{ 11137, 2 },
			},
		},
		[46685] = { --Scroll of Intellect III
			item = 4419,
			reagents = {
				{ 10648 },
				{ 8836,  2 },
				{ 11134, 2 },
			},
		},
		[46686] = { --Scroll of Stamina III
			item = 4422,
			reagents = {
				{ 10648 },
				{ 8838,  2 },
				{ 11134, 2 },
			},
		},
		[46687] = { --Scroll of Strength III
			item = 4426,
			reagents = {
				{ 10648 },
				{ 8846 },
				{ 11174 },
			},
		},
		[46688] = { --Scroll of Agility III
			item = 4425,
			reagents = {
				{ 10648 },
				{ 8839, 2 },
				{ 11174 },
			},
		},
		[46689] = { --Scroll of Protection IV
			item = 10305,
			reagents = {
				{ 10648 },
				{ 13464, 2 },
				{ 16204, 4 },
			},
		},
		[46690] = { --Scroll of Spirit IV
			item = 10306,
			reagents = {
				{ 10648 },
				{ 13464, 2 },
				{ 16204, 4 },
			},
		},
		[46691] = { --Scroll of Intellect IV
			item = 10308,
			reagents = {
				{ 10648 },
				{ 13465, 2 },
				{ 16203 },
			},
		},
		[46692] = { --Scroll of Stamina IV
			item = 10307,
			reagents = {
				{ 10648 },
				{ 8845, 2 },
				{ 16203 },
			},
		},
		[46693] = { --Scroll of Strength IV
			item = 10310,
			reagents = {
				{ 10648 },
				{ 13466 },
				{ 16203 },
			},
		},
		[46694] = { --Scroll of Agility IV
			item = 10309,
			reagents = {
				{ 10648 },
				{ 13467, 2 },
				{ 16203 },
			},
		},
		[46695] = { --Dragonscale Leggings
			item = 65019,
			reagents = {
				{ 4304, 30 },
				{ 8165, 25 },
				{ 8343, 4 },
				{ 8172, 3 },
			},
		},
		[46696] = { --Haste
			reagents = {
				{ 60098 },
			},
		},
		[47000] = { --Cauldron of Major Arcane Protection
			item = 25901,
			reagents = {
				{ 13461, 20 },
				{ 20725, 2 },
				{ 16203 },
			},
		},
		[47003] = { --Cauldron of Major Fire Protection
			item = 25902,
			reagents = {
				{ 13457, 20 },
				{ 20725, 2 },
				{ 7078 },
			},
		},
		[47006] = { --Cauldron of Major Frost Protection
			item = 25903,
			reagents = {
				{ 13456, 20 },
				{ 20725, 2 },
				{ 7080 },
			},
		},
		[47009] = { --Cauldron of Major Shadow Protection
			item = 25904,
			reagents = {
				{ 17578, 20 },
				{ 20725, 2 },
				{ 12808 },
			},
		},
		[47012] = { --Cauldron of Major Nature Protection
			item = 25905,
			reagents = {
				{ 17576, 20 },
				{ 20725, 2 },
				{ 7076 },
			},
		},
		[47015] = { --Primalist's Gloves
			item = 81061,
			reagents = {
				{ 8170,  6 },
				{ 14047, 4 },
				{ 14341 },
			},
		},
		[47016] = { --Primalist's Shoulders
			item = 81062,
			reagents = {
				{ 8170, 12 },
				{ 12803 },
				{ 14341 },
			},
		},
		[47017] = { --Primalist's Headdress
			item = 81063,
			reagents = {
				{ 8170, 10 },
				{ 7080 },
				{ 12803 },
				{ 14341 },
			},
		},
		[47018] = { --Primalist's Pants
			item = 81064,
			reagents = {
				{ 8170, 12 },
				{ 8343, 2 },
				{ 14341 },
			},
		},
		[47019] = { --Primalist's Vest
			item = 81066,
			reagents = {
				{ 8170,  24 },
				{ 12803, 4 },
				{ 15407 },
				{ 14341 },
			},
		},
		[47020] = { --Primalist's Boots
			item = 81065,
			reagents = {
				{ 8170,  8 },
				{ 14047, 4 },
				{ 14341 },
			},
		},
		[47021] = { --Rune-Etched Greaves
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60288,
			reagents = {
				{ 12359, 20 },
				{ 12655, 2 },
				{ 20520, 2 },
				{ 12810 },
				{ 12361 },
			},
		},
		[47022] = { --Rune-Etched Legplates
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60289,
			reagents = {
				{ 12359, 24 },
				{ 12655, 6 },
				{ 20520, 4 },
				{ 12810, 2 },
				{ 12800 },
			},
		},
		[47023] = { --Rune-Etched Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60290,
			reagents = {
				{ 12359, 24 },
				{ 12655, 4 },
				{ 20520, 4 },
				{ 12810, 2 },
				{ 12644 },
			},
			reagents_TURTLE = {
				{ 12359, 24 },
				{ 12655, 4 },
				{ 20520, 4 },
				{ 12810, 2 },
				{ 12644 },
				{ 7910 },
			},
		},
		[47024] = { --Rune-Etched Crown
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60291,
			reagents = {
				{ 12359, 16 },
				{ 12655, 2 },
				{ 20520, 2 },
				{ 7080 },
			},
		},
		[47025] = { --Rune-Etched Mantle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60292,
			reagents = {
				{ 12359, 14 },
				{ 12655, 2 },
				{ 20520, 3 },
				{ 12810 },
				{ 7076 },
			},
		},
		[47026] = { --Rune-Etched Grips
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60287,
			reagents = {
				{ 12359, 12 },
				{ 12655, 2 },
				{ 20520, 2 },
				{ 12810, 2 },
			},
		},
		[47027] = { --Portable Wormhole Generator - Stormwind
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 51312,
			reagents = {
				{ 1206 },
				{ 4375, 2 },
				{ 2841, 2 },
				{ 10998 },
			},
		},
		[47028] = { --Portable Wormhole Generator - Orgrimmar
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 51313,
			reagents = {
				{ 1206 },
				{ 4375, 2 },
				{ 2841, 2 },
				{ 10998 },
			},
		},
		[47029] = { --Hateforge Helmet
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60573,
			reagents = {
				{ 12359, 16 },
				{ 11371 },
				{ 11754, 6 },
				{ 7078 },
			},
		},
		[47030] = { --Hateforge Cuirass
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60574,
			reagents = {
				{ 12359, 24 },
				{ 11371 },
				{ 11754, 12 },
				{ 8170,  6 },
				{ 20520, 2 },
				{ 7078,  2 },
			},
		},
		[47031] = { --Hateforge Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60575,
			reagents = {
				{ 12359, 20 },
				{ 11371 },
				{ 11754, 8 },
				{ 7078,  2 },
				{ 8170,  4 },
			},
		},
		[47032] = { --Hateforge Belt
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60576,
			reagents = {
				{ 12359, 12 },
				{ 7078,  2 },
				{ 11754, 5 },
				{ 12810 },
			},
		},
		[47033] = { --Hateforge Grips
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60577,
			reagents = {
				{ 12359, 40 },
				{ 11371, 8 },
				{ 11754, 18 },
				{ 12810, 8 },
				{ 7078,  8 },
			},
		},
		[47034] = { --Hateforge Boots
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60578,
			reagents = {
				{ 12359, 12 },
				{ 7077,  7 },
				{ 11754, 5 },
				{ 12810, 3 },
				{ 7078,  2 },
			},
		},
		[47035] = { --Verdant Dreamer's Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65021,
			reagents = {
				{ 8211 },
				{ 12810, 16 },
				{ 20002, 10 },
				{ 12803, 20 },
				{ 15407, 4 },
				{ 14227, 4 },
			},
		},
		[54001] = { --Blue Dragonscale Boots
			item = 65015,
			reagents = {
				{ 8170,  24 },
				{ 15415, 25 },
				{ 15407 },
				{ 14341 },
			},
		},
		[54003] = { --Fury of the Timbermaw
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61648,
			reagents = {
				{ 12359, 16 },
				{ 7076,  3 },
				{ 7078,  3 },
			},
		},
		[54005] = { --Pauldrons of the Timbermaw
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61649,
			reagents = {
				{ 12655, 12 },
				{ 12360, 2 },
				{ 7076,  6 },
				{ 7078,  6 },
			},
		},
		[54007] = { --Corehound Gloves
			item = 65038,
			reagents = {
				{ 17010, 9 },
				{ 17012, 12 },
				{ 12810, 12 },
				{ 12607, 6 },
				{ 15407, 5 },
				{ 14227, 4 },
			},
		},
		[54009] = { --Fiery Chain Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 65039,
			reagents = {
				{ 11371, 14 },
				{ 17010, 6 },
				{ 17011, 5 },
			},
		},
		[54011] = { --Flarecore Boots
			item = 65035,
			reagents = {
				{ 14342, 6 },
				{ 17010, 5 },
				{ 17011, 4 },
				{ 7078,  10 },
				{ 14227, 4 },
			},
		},
		[54013] = { --Chromatic Leggings
			item = 65036,
			reagents = {
				{ 17012, 6 },
				{ 17010, 5 },
				{ 17011, 3 },
				{ 12607, 6 },
				{ 15407, 5 },
				{ 14227, 4 },
			},
		},
		[54015] = { --Molten Leggings
			item = 65037,
			reagents = {
				{ 17011, 6 },
				{ 17010, 3 },
				{ 14227, 4 },
				{ 7076,  6 },
				{ 12607, 6 },
				{ 15407, 4 },
			},
		},
		[56530] = { --Merge the Flames
			item = 83558,
			reagents = {
				{ 83550 },
				{ 83554 },
			},
		},
		[56531] = { --Mold the Stones
			item = 83559,
			reagents = {
				{ 83551 },
				{ 83555 },
			},
		},
		[56532] = { --Combine the Winds
			item = 83560,
			reagents = {
				{ 83553 },
				{ 83556 },
			},
		},
		[56533] = { --Shape the Waters
			item = 83561,
			reagents = {
				{ 83552 },
				{ 83557 },
			},
		},
		[57008] = { --Breastplate of the Earth
			item = 65022,
			reagents = {
				{ 4304, 40 },
				{ 7075, 12 },
				{ 8172, 3 },
				{ 8343, 4 },
			},
		},
		[57010] = { --Boots of the Wind
			item = 65023,
			reagents = {
				{ 4304, 20 },
				{ 7081, 10 },
				{ 8172 },
				{ 8343, 4 },
			},
		},
		[57012] = { --Earthguard Tunic
			item = 65024,
			reagents = {
				{ 8170,  20 },
				{ 15419, 20 },
				{ 15407, 6 },
				{ 7076,  20 },
				{ 12809, 10 },
				{ 13455, 5 },
				{ 8343,  2 },
			},
		},
		[57014] = { --Flamewrath Leggings
			item = 65025,
			reagents = {
				{ 8170,  20 },
				{ 15417, 15 },
				{ 15407, 5 },
				{ 7078,  25 },
				{ 11751, 2 },
				{ 21546, 5 },
				{ 8343,  2 },
			},
		},
		[57016] = { --Depthstalker Helmet
			item = 65026,
			reagents = {
				{ 8170,  15 },
				{ 15422, 20 },
				{ 15407, 5 },
				{ 7080,  20 },
				{ 12457, 10 },
				{ 18294, 10 },
				{ 8343,  2 },
			},
		},
		[57018] = { --Windwalker Boots
			item = 65027,
			reagents = {
				{ 8170,  10 },
				{ 15423, 20 },
				{ 15407, 6 },
				{ 7082,  20 },
				{ 12753, 6 },
				{ 2459,  10 },
				{ 8343,  2 },
			},
		},
		[57020] = { --Dustguider Sash
			item = 60909,
			reagents = {
				{ 14048, 10 },
				{ 12810, 6 },
				{ 7076,  6 },
				{ 14344 },
			},
		},
		[57022] = { --Centaur Battle Harness
			item = 60910,
			reagents = {
				{ 8170,  20 },
				{ 12810, 8 },
				{ 7082,  2 },
				{ 7076 },
			},
		},
		[57024] = { --Windbinder Gloves
			item = 60907,
			reagents = {
				{ 14048, 10 },
				{ 14344, 2 },
				{ 7069,  16 },
				{ 7082,  6 },
			},
		},
		[57026] = { --Mantle of Centaur Authority
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60908,
			reagents = {
				{ 12359, 40 },
				{ 12810, 6 },
				{ 7082,  6 },
				{ 7076,  6 },
				{ 3577,  2 },
			},
		},
		[57047] = { --Danonzo's Tel'Abim Surprise
			requires = L["Cooking Fire"],
			item = 60976,
			reagents = {
				{ 60955 },
				{ 3713 },
				{ 10286 },
			},
		},
		[57049] = { --Danonzo's Tel'Abim Delight
			requires = L["Cooking Fire"],
			item = 60977,
			reagents = {
				{ 60955 },
				{ 3713 },
				{ 13467 },
			},
		},
		[57051] = { --Danonzo's Tel'Abim Medley
			requires = L["Cooking Fire"],
			item = 60978,
			reagents = {
				{ 60955 },
				{ 3713 },
				{ 13464, 2 },
			},
		},
		[57108] = { --Emerald Blessing
			reagents = {
				{ 61199 },
			},
		},
		[57111] = { --Potion of Quickness
			item = 61181,
			reagents = {
				{ 8846 },
				{ 13465, 2 },
				{ 2459 },
				{ 8925 },
			},
		},
		[57113] = { --Thorium Spurs
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61182,
			reagents = {
				{ 7081 },
				{ 12359, 8 },
				{ 12644, 2 },
				{ 61673 },
			},
		},
		[57115] = { --Enchanted Armor Kit
			item = 61183,
			reagents = {
				{ 12810, 3 },
				{ 61673, 3 },
				{ 14341, 2 },
			},
		},
		[57121] = { --Dreamsteel
			item = 61216,
			reagents = {
				{ 61199 },
				{ 3859 },
				{ 20381 },
			},
		},
		[57123] = { --Dreamthread
			item = 61227,
			reagents = {
				{ 61199 },
				{ 14341 },
				{ 20381 },
			},
		},
		[57125] = { --Dreamhide
			item = 61229,
			reagents = {
				{ 61199 },
				{ 8170 },
			},
		},
		[57129] = { --Lucidity Potion
			item = 61225,
			reagents = {
				{ 730 },
				{ 13463 },
				{ 8831 },
				{ 8925 },
			},
		},
		[57131] = { --Dreamshard Elixir
			item = 61224,
			reagents = {
				{ 8925 },
				{ 11176 },
				{ 61198 },
			},
		},
		[57163] = { --Copper Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61779,
			reagents = {
				{ 2840, 8 },
				{ 2880 },
				{ 3470, 2 },
			},
		},
		[57166] = { --Bronze Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61780,
			reagents = {
				{ 2841, 8 },
				{ 2880 },
				{ 3478, 2 },
			},
		},
		[57169] = { --Iron Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61781,
			reagents = {
				{ 3575, 8 },
				{ 7071 },
				{ 3486, 2 },
			},
		},
		[57172] = { --Mithril Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61782,
			reagents = {
				{ 3860, 8 },
				{ 7071 },
				{ 7966, 2 },
				{ 6037 },
			},
		},
		[57175] = { --Thorium Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61783,
			reagents = {
				{ 12359, 8 },
				{ 7071 },
				{ 12644, 2 },
				{ 6037 },
			},
		},
		[57178] = { --Arcanite Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61784,
			reagents = {
				{ 12360, 2 },
				{ 7071 },
				{ 12644, 2 },
				{ 11754 },
				{ 12361 },
			},
		},
		[57181] = { --Dreamsteel Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61785,
			reagents = {
				{ 61216, 2 },
				{ 12644, 2 },
				{ 7076 },
				{ 12803 },
			},
		},
		[57187] = { --Towerforge Crown
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60007,
			reagents = {
				{ 12655, 12 },
				{ 12360, 14 },
				{ 11371, 10 },
				{ 61673, 6 },
				{ 3824,  8 },
			},
		},
		[57189] = { --Towerforge Breastplate
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60008,
			reagents = {
				{ 12655, 12 },
				{ 12360, 12 },
				{ 11371, 12 },
				{ 61673, 6 },
				{ 22202, 6 },
			},
		},
		[57191] = { --Towerforge Pauldrons
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60009,
			reagents = {
				{ 12655, 10 },
				{ 12360, 10 },
				{ 11371, 8 },
				{ 61673, 4 },
				{ 12800, 4 },
			},
		},
		[57193] = { --Towerforge Demolisher
			requires = L["Anvil"],
			tools = { 5956 },
			item = 60010,
			reagents = {
				{ 12655, 12 },
				{ 12360, 14 },
				{ 11371, 14 },
				{ 61673, 8 },
				{ 22203, 2 },
				{ 18335 },
			},
		},
		[57196] = { --Bloody Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 61810,
			reagents = {
				{ 12359, 10 },
				{ 19933, 6 },
				{ 8846,  6 },
			},
		},
		[57518] = { --Eternal Dreamstone Shard
			item = 61732,
			reagents = {
				{ 61197, 5 },
				{ 61673, 25 },
				{ 61199, 25 },
				{ 20725, 10 },
				{ 13468, 5 },
				{ 12803, 80 },
			},
		},
		[37] = { --Harness of the High Thane
			item = 55043,
			reagents = {
				{ 15407, 6 },
				{ 12810, 12 },
				{ 7081,  20 },
				{ 7082,  8 },
				{ 5117,  15 },
				{ 4480,  10 },
				{ 14341, 4 },
			},
		},
		[55] = { --Dragonmaw Armor Kit
			item = 65,
			reagents = {
				{ 7287, 5 },
				{ 6371 },
				{ 2321, 2 },
			},
		},
		[57] = { --Steel Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 131,
			reagents = {
				{ 3859, 8 },
				{ 7071 },
				{ 7966 },
			},
		},
		[69] = { --Gold Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 66,
			reagents = {
				{ 3577, 8 },
				{ 7071 },
				{ 3486, 2 },
			},
		},
		[70] = { --Dragonmaw Gloves
			item = 58112,
			reagents = {
				{ 4234,  14 },
				{ 7287,  4 },
				{ 4236,  2 },
				{ 5637,  2 },
				{ 4402,  2 },
				{ 55249, 2 },
			},
		},
		[74] = { --Dragonscale Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 67,
			reagents = {
				{ 12359, 4 },
				{ 7071 },
				{ 8165,  14 },
				{ 7966 },
			},
		},
		[83] = { --Stormreaver Gloves
			item = 58134,
			reagents = {
				{ 4305, 8 },
				{ 3824, 3 },
				{ 7068, 3 },
				{ 3864, 3 },
				{ 4342 },
				{ 4291, 2 },
			},
		},
		[85] = { --Dark Iron Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 82,
			reagents = {
				{ 11371, 2 },
				{ 7071 },
				{ 7078 },
				{ 12644, 2 },
			},
		},
		[90] = { --Truesilver Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 151,
			reagents = {
				{ 6037, 8 },
				{ 7071 },
				{ 7966, 2 },
			},
		},
		[93] = { --Refined Dwarven Necklace
			tools = { 55155, 41326 },
			item = 156,
			reagents = {
				{ 3860,  12 },
				{ 55249, 3 },
				{ 6371,  3 },
				{ 3466,  2 },
				{ 55152, 2 },
			},
		},
		[95] = { --Enchanted Thorium Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 87,
			reagents = {
				{ 12655, 2 },
				{ 7071 },
				{ 61673, 2 },
				{ 12644 },
			},
		},
		[102] = { --Obsidian Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 103,
			reagents = {
				{ 22203, 2 },
				{ 7071 },
				{ 7076 },
				{ 7082 },
				{ 12644, 2 },
			},
		},
		[104] = { --Ancient Dwarven Gemstone
			tools = { 55155, 41326 },
			item = 56112,
			reagents = {
				{ 3860 },
				{ 55249 },
				{ 55247 },
			},
		},
		[115] = { --Elixir of Rapid Growth
			item = 56113,
			reagents = {
				{ 4625 },
				{ 7068 },
				{ 3372 },
			},
		},
		[1207] = { --Fried Strider with a Side of Berries
			requires = L["Cooking Fire"],
			item = 68513,
			reagents = {
				{ 42010 },
				{ 42000 },
				{ 2692, 2 },
			},
		},
		[13909] = { --Create Elemental Totem
			item = 11522,
			reagents = {
				{ 11172, 11 },
				{ 11173 },
			},
		},
		[20635] = { --Silken Cloth
			item = 56081,
			reagents = {
				{ 56080 },
				{ 56078 },
			},
		},
		[20636] = { --Thegren's Gritting Paper
			item = 56082,
			reagents = {
				{ 56081 },
				{ 56079 },
			},
		},
		[20639] = { --Ancient Idol of Cla'ckora
			item = 56088,
			reagents = {
				{ 56083 },
				{ 56084 },
				{ 56085 },
			},
		},
		[26265] = { --Elune's Lantern
			item = 21536,
			reagents = {
				{ 7912 },
			},
		},
		[27949] = { --Binding Advanced Jewelcrafting XI: Hard as Diamonds
			item = 56099,
			reagents = {
				{ 56097 },
				{ 56098 },
			},
		},
		[29728] = { --Rough Gritted Paper
			item = 55150,
			reagents = {
				{ 2589 },
				{ 2835 },
			},
		},
		[29730] = { --Rough Copper Ring
			tools = { 55155 },
			item = 55156,
			reagents = {
				{ 2840, 2 },
			},
		},
		[29732] = { --Copper Bangle
			tools = { 55155 },
			item = 55157,
			reagents = {
				{ 2840, 4 },
			},
		},
		[29950] = { --Advanced Goldsmithing I
			item = 56110,
			reagents = {
				{ 56100 },
				{ 56101 },
			},
		},
		[29951] = { --Advanced Goldsmithing II
			item = 56111,
			reagents = {
				{ 56102 },
				{ 56103 },
			},
		},
		[29952] = { --Advanced Gemology I
			item = 56109,
			reagents = {
				{ 56104 },
				{ 56105 },
			},
		},
		[29953] = { --Advanced Gemology II
			item = 56108,
			reagents = {
				{ 56106 },
				{ 56107 },
			},
		},
		[30004] = { --Slowing Bolas
			item = 106,
			reagents = {
				{ 2838,  3 },
				{ 50231, 2 },
			},
		},
		[30006] = { --Edged Machete
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42108,
			reagents = {
				{ 3575, 8 },
				{ 4234, 2 },
				{ 50231 },
				{ 42007 },
			},
		},
		[30008] = { --Iron Spear
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42109,
			reagents = {
				{ 3575, 8 },
				{ 3486, 2 },
				{ 50231 },
				{ 4234, 2 },
			},
		},
		[30010] = { --Reinforced Fishing Rod
			tools = { 42004 },
			item = 42110,
			reagents = {
				{ 3575,  2 },
				{ 42008, 8 },
				{ 42006 },
				{ 4359,  10 },
			},
		},
		[30013] = { --Water Trudgers
			item = 42111,
			reagents = {
				{ 4234,  12 },
				{ 17057, 20 },
				{ 4340,  2 },
				{ 5500,  4 },
			},
		},
		[30015] = { --Bundle of Shade Wood Sticks
			tools = { 42004 },
			item = 42151,
			reagents = {
				{ 42008, 4 },
			},
		},
		[30017] = { --Sharpened Herb Sickle
			tools = { 42004 },
			item = 42112,
			reagents = {
				{ 3575, 2 },
				{ 3577 },
				{ 42008 },
				{ 4234, 2 },
				{ 4359, 4 },
			},
		},
		[30022] = { --Lined Wintercloak
			item = 42113,
			reagents = {
				{ 4236, 2 },
				{ 4234, 8 },
				{ 4340, 2 },
				{ 4306, 6 },
				{ 4291, 4 },
			},
		},
		[30024] = { --Sleek Pinewood Bow
			tools = { 42004 },
			item = 42114,
			reagents = {
				{ 42008, 8 },
				{ 42006 },
				{ 3577,  2 },
				{ 5116,  6 },
			},
		},
		[30027] = { --Superior Healing Salve
			item = 42127,
			reagents = {
				{ 42005, 6 },
				{ 3357 },
				{ 42143, 4 },
			},
		},
		[30029] = { --Savory Fishing Lure
			item = 133,
			reagents = {
				{ 7974 },
				{ 3713, 2 },
			},
		},
		[30031] = { --Smooth Ironfeather Arrows
			tools = { 42004 },
			item = 42200,
			reagents = {
				{ 42152 },
				{ 15420 },
				{ 12359 },
			},
		},
		[30033] = { --Heavy Duty Machete
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42120,
			reagents = {
				{ 12359, 6 },
				{ 8170,  4 },
				{ 12644, 2 },
			},
		},
		[30035] = { --Thorium Edged Machete
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42121,
			reagents = {
				{ 12359, 10 },
				{ 8170,  4 },
				{ 12644, 2 },
				{ 55154, 2 },
				{ 7910 },
			},
		},
		[30037] = { --Thorium Spear
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42122,
			reagents = {
				{ 12359, 4 },
				{ 8170,  4 },
				{ 42009, 6 },
				{ 55154, 2 },
			},
		},
		[30039] = { --Razor-sharp Skinning Knife
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42124,
			reagents = {
				{ 7005 },
				{ 12404, 4 },
				{ 12655, 8 },
				{ 7910,  6 },
				{ 7068,  8 },
				{ 7078,  4 },
			},
		},
		[30042] = { --Bundle of Star Wood Sticks
			tools = { 42004 },
			item = 42153,
			reagents = {
				{ 11291, 5 },
			},
		},
		[30045] = { --Mastercraft Fishing Rod
			tools = { 42004 },
			item = 42123,
			reagents = {
				{ 12359, 8 },
				{ 8170,  4 },
				{ 42009, 10 },
				{ 42006, 2 },
				{ 16000, 4 },
				{ 7080,  4 },
			},
		},
		[30050] = { --Miner’s Rucksack
			item = 33375,
			reagents = {
				{ 8170,  24 },
				{ 8172,  3 },
				{ 42153, 10 },
				{ 2901 },
				{ 7071,  4 },
				{ 14341, 6 },
			},
		},
		[30052] = { --Herbalist’s Knapsack
			item = 33376,
			reagents = {
				{ 8170,  22 },
				{ 8172,  4 },
				{ 42153, 10 },
				{ 42095 },
				{ 7071,  4 },
				{ 14341, 4 },
			},
		},
		[30054] = { --Skinner’s Carryall
			item = 33378,
			reagents = {
				{ 8170,  28 },
				{ 12810, 6 },
				{ 15407, 2 },
				{ 33372 },
				{ 7071,  4 },
				{ 14341, 6 },
			},
		},
		[30057] = { --Cooling Rations Bag
			item = 33379,
			reagents = {
				{ 8170,  18 },
				{ 12810, 8 },
				{ 15407, 2 },
				{ 7080,  4 },
				{ 7071,  4 },
				{ 14341, 6 },
			},
		},
		[30061] = { --Starfeather Arrows
			tools = { 42004 },
			item = 42201,
			reagents = {
				{ 42153 },
				{ 15420, 4 },
			},
		},
		[30063] = { --Major Healing Salve
			item = 42129,
			reagents = {
				{ 42005, 10 },
				{ 10286 },
				{ 42146, 4 },
			},
		},
		[30065] = { --Fisherman's Backpack
			item = 33377,
			reagents = {
				{ 8170,  20 },
				{ 8172,  6 },
				{ 42153, 10 },
				{ 42123 },
				{ 7071,  4 },
				{ 14341, 6 },
			},
		},
		[30067] = { --Starfeather Arrows
			tools = { 42004 },
			item = 42201,
			reagents = {
				{ 42153 },
				{ 15420, 4 },
				{ 12655 },
			},
		},
		[30069] = { --Oil-Powered Cooker
			item = 36701,
			reagents = {
				{ 10561, 8 },
				{ 15994, 6 },
				{ 10558, 6 },
				{ 814,   10 },
				{ 7078,  2 },
				{ 12655, 4 },
			},
		},
		[30071] = { --Blackmouth Fishing Trap
			item = 42329,
			reagents = {
				{ 42150, 2 },
				{ 114 },
				{ 42154 },
			},
		},
		[30073] = { --Rugged Mining Sack
			item = 42294,
			reagents = {
				{ 4234, 8 },
				{ 4233, 3 },
				{ 4341, 2 },
				{ 4291, 4 },
				{ 4306, 14 },
			},
		},
		[30078] = { --Snap Trap
			item = 42328,
			reagents = {
				{ 4387, 4 },
				{ 4359, 8 },
			},
		},
		[30084] = { --Firefin Fishing Trap
			tools = { 42004 },
			item = 42330,
			reagents = {
				{ 42151, 2 },
				{ 125 },
				{ 42154 },
			},
		},
		[30086] = { --Stonescale Fishing Trap
			tools = { 42004 },
			item = 42331,
			reagents = {
				{ 42153, 2 },
				{ 145 },
				{ 42154, 2 },
			},
		},
		[30239] = { --Sea Turtle Shell
			item = 49991,
			reagents = {
				{ 49992, 2 },
			},
		},
		[32310] = { --Enchanted Thorium Shells
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42202,
			reagents = {
				{ 12655, 2 },
				{ 15992 },
			},
		},
		[32313] = { --Squid Eel Skewer
			requires = L["Cooking Fire"],
			item = 42163,
			reagents = {
				{ 13755 },
				{ 13757 },
				{ 2692, 2 },
			},
		},
		[32314] = { --Deep Sea Stew
			requires = L["Cooking Fire"],
			item = 42164,
			reagents = {
				{ 13760 },
				{ 13890 },
				{ 3713, 2 },
			},
		},
		[33447] = { --Upgrade Arcanite Reaper
			item = 33093,
			reagents = {
				{ 33083 },
			},
		},
		[33448] = { --Upgrade Arcanite Champion
			item = 33094,
			reagents = {
				{ 33083 },
			},
		},
		[33449] = { --Upgrade Spellpower Goggles Xtreme Plus
			item = 33095,
			reagents = {
				{ 33085 },
			},
		},
		[33450] = { --Upgrade Chromatic Cloak
			item = 33096,
			reagents = {
				{ 33084 },
			},
		},
		[34758] = { --Kodoheart Necklace
			tools = { 55155 },
			item = 42205,
			reagents = {
				{ 2841, 6 },
				{ 3827 },
				{ 7069, 4 },
				{ 1705, 2 },
				{ 2842, 2 },
			},
		},
		[34760] = { --Grimtotem Bracers
			item = 42204,
			reagents = {
				{ 2319, 10 },
				{ 4233, 2 },
				{ 5116, 8 },
				{ 5373, 4 },
				{ 4340, 2 },
			},
		},
		[34762] = { --Ceremonial Belt Buckle
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42203,
			reagents = {
				{ 3575, 4 },
				{ 2319, 4 },
				{ 5116, 2 },
				{ 5373 },
			},
		},
		[36579] = { --Timberheart Dreamcatcher
			tools = { 16207 },
			item = 42196,
			reagents = {
				{ 16203, 8 },
				{ 11291, 8 },
				{ 12364, 4 },
				{ 12803, 4 },
				{ 7082,  2 },
				{ 7076,  2 },
			},
		},
		[36581] = { --Ceremonial Furbolg Pendant
			tools = { 41328, 41327 },
			item = 42195,
			reagents = {
				{ 12360, 4 },
				{ 3577,  32 },
				{ 8168,  12 },
				{ 7080,  4 },
				{ 55154, 8 },
				{ 55248, 2 },
			},
		},
		[36583] = { --Deeproot Sash
			item = 42194,
			reagents = {
				{ 14048, 16 },
				{ 14256, 6 },
				{ 7971,  4 },
				{ 20520, 12 },
				{ 12808, 12 },
				{ 14341, 2 },
			},
		},
		[36585] = { --Timberclaw Bracers
			item = 42193,
			reagents = {
				{ 8170,  28 },
				{ 8146,  40 },
				{ 15407 },
				{ 7076,  4 },
				{ 7080,  4 },
				{ 14341, 2 },
			},
		},
		[36587] = { --Witherhide Gloves
			item = 42192,
			reagents = {
				{ 15419, 20 },
				{ 15407, 4 },
				{ 12808, 6 },
				{ 12753, 6 },
				{ 14341, 2 },
			},
		},
		[36589] = { --Mixologist Stone
			item = 42184,
			reagents = {
				{ 12808, 8 },
				{ 18335, 4 },
				{ 20520, 2 },
				{ 61673, 2 },
				{ 13468 },
			},
		},
		[36591] = { --Crystalized Topaz
			tools = { 41326, 41328 },
			item = 42191,
			reagents = {
				{ 55252, 2 },
				{ 12800 },
				{ 55248 },
			},
		},
		[36593] = { --Denwatcher
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42183,
			reagents = {
				{ 12655, 30 },
				{ 12803, 8 },
				{ 7080,  8 },
				{ 13463, 4 },
				{ 12644, 4 },
			},
		},
		[36747] = { --Jungle Remedy
			item = 2633,
			reagents = {
				{ 42005, 4 },
				{ 42143, 2 },
				{ 4595 },
			},
		},
		[36749] = { --Spirited Precision Sickle
			item = 42231,
			reagents = {
				{ 42112 },
				{ 19726, 8 },
				{ 18262, 2 },
				{ 12803, 8 },
				{ 10286, 8 },
			},
		},
		[36751] = { --Prospector’s Magnifying Lens
			item = 42232,
			reagents = {
				{ 55252, 2 },
				{ 16000, 4 },
				{ 55154, 5 },
				{ 12655, 8 },
				{ 12361, 3 },
				{ 12364, 3 },
			},
		},
		[36753] = { --Hydracoil Trousers
			item = 33366,
			reagents = {
				{ 42215, 20 },
				{ 12810, 8 },
				{ 15407, 2 },
				{ 7078,  6 },
				{ 7077,  4 },
				{ 42001, 2 },
				{ 14341, 6 },
			},
		},
		[36755] = { --Hydracoil Gauntlets
			item = 33367,
			reagents = {
				{ 42215, 16 },
				{ 12810, 6 },
				{ 8170,  24 },
				{ 7076,  4 },
				{ 7075,  4 },
				{ 42001 },
				{ 14341, 4 },
			},
		},
		[36757] = { --Hydracoil Spaulders
			item = 33368,
			reagents = {
				{ 42215, 18 },
				{ 12810, 4 },
				{ 8170,  20 },
				{ 15407 },
				{ 7080,  3 },
				{ 7079,  4 },
				{ 42001, 3 },
			},
		},
		[36765] = { --Bundle of Simple Sticks
			tools = { 42004 },
			item = 42149,
			reagents = {
				{ 4470, 2 },
			},
		},
		[36766] = { --Crude Walking Stick
			tools = { 42004 },
			item = 42089,
			reagents = {
				{ 4470, 4 },
			},
		},
		[36767] = { --Crude Machete
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42090,
			reagents = {
				{ 4470 },
				{ 2840, 3 },
			},
		},
		[36768] = { --Crude Hatchet
			item = 42091,
			reagents = {
				{ 4470 },
				{ 2840, 3 },
			},
		},
		[36769] = { --Crude Hunting Bow
			tools = { 42004 },
			item = 42092,
			reagents = {
				{ 4470,  3 },
				{ 42006, 2 },
			},
		},
		[36770] = { --Copper Lantern
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42093,
			reagents = {
				{ 6182 },
				{ 2840, 3 },
			},
		},
		[36771] = { --Simple Slingshot
			tools = { 42004 },
			item = 42229,
			reagents = {
				{ 51708, 4 },
				{ 42149, 2 },
				{ 42006 },
			},
		},
		[36772] = { --Simple Herbalist’s Backpack
			item = 33369,
			reagents = {
				{ 2318, 6 },
				{ 2320, 4 },
				{ 4231, 2 },
				{ 2447, 12 },
			},
		},
		[36773] = { --Makeshift Rations Bag
			item = 33370,
			reagents = {
				{ 2318, 4 },
				{ 2320, 6 },
				{ 4231 },
				{ 4289, 4 },
			},
		},
		[36774] = { --Weak Healing Salve
			item = 42233,
			reagents = {
				{ 159 },
				{ 42005, 2 },
				{ 42142 },
			},
		},
		[36785] = { --Makeshift Knife
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42094,
			reagents = {
				{ 4470 },
				{ 2840, 3 },
				{ 2318, 2 },
			},
		},
		[36786] = { --Gardening Gloves
			item = 42095,
			reagents = {
				{ 2318, 4 },
				{ 2320, 2 },
				{ 2447, 6 },
			},
		},
		[36787] = { --Crude Fishing Rod
			tools = { 42004 },
			item = 42096,
			reagents = {
				{ 4470, 8 },
				{ 2321 },
			},
		},
		[36788] = { --Hunting Spear
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42097,
			reagents = {
				{ 2841, 8 },
				{ 2318, 4 },
				{ 2321, 2 },
				{ 4470, 12 },
			},
		},
		[36789] = { --Gardening Broom
			tools = { 42004 },
			item = 42098,
			reagents = {
				{ 4470,  6 },
				{ 42149, 8 },
				{ 2321 },
				{ 2319 },
			},
		},
		[36795] = { --Nutritious Rations
			item = 42155,
			reagents = {
				{ 51712, 2 },
				{ 51711, 2 },
				{ 51710, 2 },
			},
		},
		[36796] = { --Shade Wood Arrows
			tools = { 42004 },
			item = 42199,
			reagents = {
				{ 42151 },
				{ 5636 },
				{ 3860 },
			},
		},
		[36797] = { --Vine Cutter
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42115,
			reagents = {
				{ 3860, 10 },
				{ 7966, 2 },
				{ 4304, 4 },
				{ 42151 },
			},
		},
		[36798] = { --Hiking Staff
			tools = { 42004 },
			item = 42116,
			reagents = {
				{ 42008, 10 },
				{ 50231, 4 },
				{ 7966,  2 },
			},
		},
		[36799] = { --Tree Hatchet
			requires = L["Anvil"],
			tools = { 5956 },
			item = 42117,
			reagents = {
				{ 3860,  10 },
				{ 7966,  4 },
				{ 55153, 2 },
				{ 42151 },
			},
		},
		[36800] = { --Bundle of Tropical Sticks
			tools = { 42004 },
			item = 42152,
			reagents = {
				{ 42009, 5 },
			},
		},
		[36801] = { --Sunshade Hat
			item = 42118,
			reagents = {
				{ 4304, 12 },
				{ 6049, 2 },
				{ 7068, 4 },
				{ 8150, 6 },
				{ 4402, 5 },
			},
		},
		[36802] = { --Thick Rations Bag
			item = 33374,
			reagents = {
				{ 4304, 12 },
				{ 8172, 2 },
				{ 8343, 4 },
				{ 4338, 10 },
				{ 8150, 5 },
			},
		},
		[36803] = { --Warped Recurve Bow
			tools = { 42004 },
			item = 42119,
			reagents = {
				{ 42009, 10 },
				{ 4304,  4 },
				{ 42006, 2 },
				{ 5117,  6 },
				{ 7081,  4 },
			},
		},
		[36804] = { --Spiced Berries
			item = 42130,
			reagents = {
				{ 51711 },
				{ 42005 },
				{ 2692, 2 },
			},
		},
		[36805] = { --Aromatic Berries
			item = 42131,
			reagents = {
				{ 51714 },
				{ 42005 },
				{ 3713, 2 },
			},
		},
		[36806] = { --Advanced Camouflage
			item = 42230,
			reagents = {
				{ 11018, 2 },
				{ 42152, 2 },
				{ 42145, 10 },
			},
		},
		[36807] = { --Emergency Parachute
			item = 42156,
			reagents = {
				{ 50231, 4 },
				{ 14047, 5 },
				{ 42154 },
			},
		},
		[36808] = { --Stabilizing Healing Salve
			item = 42128,
			reagents = {
				{ 42005, 8 },
				{ 8831 },
				{ 42145, 4 },
			},
		},
		[36809] = { --Premium Fishing Lure
			item = 145,
			reagents = {
				{ 7974, 2 },
				{ 18288 },
			},
		},
		[36842] = { --Oakwood Bow
			tools = { 42004 },
			item = 42099,
			reagents = {
				{ 4470,  12 },
				{ 2324,  2 },
				{ 42006, 2 },
				{ 2319 },
			},
		},
		[36843] = { --Simple Fishing Lure
			item = 114,
			reagents = {
				{ 5503 },
				{ 42005 },
			},
		},
		[36844] = { --Healing Salve
			item = 42125,
			reagents = {
				{ 42142, 4 },
				{ 42005, 2 },
				{ 3174 },
			},
		},
		[36845] = { --Fishing Bag
			item = 33371,
			reagents = {
				{ 2319, 8 },
				{ 2321, 4 },
				{ 4231, 4 },
				{ 4289, 6 },
			},
		},
		[36846] = { --Skinner’s Pack
			item = 33372,
			reagents = {
				{ 2319, 6 },
				{ 2321, 2 },
				{ 4231, 4 },
				{ 7005 },
			},
		},
		[36847] = { --Gardening Pitchfork
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42100,
			reagents = {
				{ 2841, 10 },
				{ 4470, 10 },
				{ 2319, 4 },
			},
		},
		[36848] = { --Murloc Scale Coat
			item = 42101,
			reagents = {
				{ 2319, 6 },
				{ 2321, 2 },
				{ 5784, 10 },
				{ 6372, 2 },
			},
		},
		[36849] = { --Bundle of Bright Wood Sticks
			tools = { 42004 },
			item = 42150,
			reagents = {
				{ 42007, 3 },
			},
		},
		[36850] = { --Sturdy Net
			item = 42154,
			reagents = {
				{ 50231, 4 },
			},
		},
		[36851] = { --Sturdy Cane
			tools = { 42004 },
			item = 42102,
			reagents = {
				{ 42007, 12 },
				{ 2319,  2 },
				{ 2321 },
			},
		},
		[36852] = { --Sturdy Knife
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42103,
			reagents = {
				{ 42007, 2 },
				{ 2319,  2 },
				{ 2841,  6 },
				{ 1206 },
				{ 55151, 2 },
			},
		},
		[36853] = { --Sturdy Blade
			requires = L["Anvil"],
			tools = { 42004, 5956 },
			item = 42104,
			reagents = {
				{ 42007, 2 },
				{ 2319 },
				{ 2841,  8 },
				{ 1206 },
				{ 3478,  2 },
			},
		},
		[36854] = { --Reliable Fishing Rod
			tools = { 42004 },
			item = 42105,
			reagents = {
				{ 42007, 6 },
				{ 2321 },
				{ 2841,  2 },
			},
		},
		[36855] = { --Throwable Net
			item = 42132,
			reagents = {
				{ 42154 },
				{ 2836, 4 },
			},
		},
		[36856] = { --Hat of the Junior Chef
			item = 42106,
			reagents = {
				{ 4305, 6 },
				{ 2324, 8 },
				{ 4291, 4 },
				{ 2692, 5 },
				{ 3713, 5 },
				{ 3182, 5 },
			},
		},
		[36857] = { --Treasure Compass
			item = 42107,
			reagents = {
				{ 4404, 4 },
				{ 4382, 6 },
				{ 4359, 20 },
				{ 1529, 2 },
				{ 4375, 6 },
			},
		},
		[36858] = { --Bright Wood Arrows
			tools = { 42004 },
			item = 42198,
			reagents = {
				{ 42150 },
				{ 5116 },
				{ 3575 },
			},
		},
		[36859] = { --Studded Rations Bag
			item = 33373,
			reagents = {
				{ 4234, 8 },
				{ 4233, 3 },
				{ 4341, 2 },
				{ 4291, 4 },
				{ 6370, 6 },
				{ 4289, 8 },
			},
		},
		[36860] = { --Potent Healing Salve
			item = 42126,
			reagents = {
				{ 42005, 4 },
				{ 34001, 3 },
				{ 159 },
			},
		},
		[36861] = { --Spicy Fishing Lure
			item = 125,
			reagents = {
				{ 5504 },
				{ 2692 },
			},
		},
		[36901] = { --Elixir of Greater Frost Power
			item = 55046,
			reagents = {
				{ 13467, 3 },
				{ 8925 },
			},
		},
		[36903] = { --Elixir of Greater Arcane Power
			item = 55048,
			reagents = {
				{ 8831, 3 },
				{ 8925 },
			},
		},
		[36905] = { --Grandstaff of the Shen'dralar Elder
			tools = { 41328, 41326 },
			item = 55060,
			reagents = {
				{ 55252, 4 },
				{ 12360, 2 },
				{ 12655, 16 },
				{ 20725, 4 },
				{ 11291, 20 },
				{ 12800, 6 },
				{ 55248, 4 },
			},
		},
		[36907] = { --Rune-Inscribed Plate Leggings
			requires = L["Anvil"],
			tools = { 5956 },
			item = 55058,
			reagents = {
				{ 12360, 3 },
				{ 12655, 12 },
				{ 12799, 4 },
				{ 13926, 4 },
				{ 14341, 8 },
				{ 7080,  6 },
			},
		},
		[36909] = { --Essence Infused Leather Gloves
			item = 55050,
			reagents = {
				{ 12810, 10 },
				{ 61673, 4 },
				{ 16203, 4 },
				{ 14341, 6 },
			},
		},
		[36911] = { --Prismatic Scale Barbute
			item = 55054,
			reagents = {
				{ 8165,  20 },
				{ 15414, 5 },
				{ 15415, 5 },
				{ 15412, 5 },
				{ 15416, 5 },
				{ 8170,  30 },
			},
		},
		[36913] = { --Astronomer Raiments
			item = 55052,
			reagents = {
				{ 14048, 12 },
				{ 12361, 2 },
				{ 55048, 5 },
				{ 9210,  5 },
			},
		},
		[36915] = { --Spellwoven Nobility Drape
			item = 55056,
			reagents = {
				{ 14342, 3 },
				{ 14048, 8 },
				{ 20725 },
				{ 16204, 40 },
				{ 14341, 4 },
				{ 9210,  10 },
			},
		},
		[36929] = { --Concoction of the Emerald Mongoose
			item = 47410,
			reagents = {
				{ 13452 },
				{ 61224 },
				{ 18256 },
			},
		},
		[36932] = { --Concoction of the Arcane Giant
			item = 47412,
			reagents = {
				{ 9206 },
				{ 13454 },
				{ 18256 },
			},
		},
		[36935] = { --Concoction of the Dreamwater
			item = 47414,
			reagents = {
				{ 12820 },
				{ 61423 },
				{ 18256 },
			},
		},
		[36946] = { --Facetted Crystal Scope
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 33146,
			reagents = {
				{ 12655, 10 },
				{ 16006, 4 },
				{ 61673, 2 },
				{ 16000 },
				{ 42001, 2 },
			},
		},
		[36948] = { --Bulwark of Unshaken Earth
			requires = L["Anvil"],
			tools = { 5956 },
			item = 33135,
			reagents = {
				{ 12360, 2 },
				{ 12655, 12 },
				{ 7076,  6 },
				{ 7075,  4 },
				{ 7067,  8 },
				{ 18567 },
			},
		},
		[41001] = { --Bright Copper Ring
			tools = { 55155 },
			item = 55158,
			reagents = {
				{ 55156 },
				{ 55245 },
			},
		},
		[41003] = { --Malachite Ring
			tools = { 55155 },
			item = 81030,
			reagents = {
				{ 55156 },
				{ 774 },
				{ 55150 },
			},
		},
		[41005] = { --Sturdy Copper Ring
			tools = { 55155 },
			item = 55159,
			reagents = {
				{ 55156 },
				{ 2840 },
				{ 55150, 2 },
			},
		},
		[41007] = { --Inlaid Copper Ring
			tools = { 55155 },
			item = 55160,
			reagents = {
				{ 55156 },
				{ 55245 },
				{ 55150, 4 },
				{ 818 },
			},
		},
		[41009] = { --Copper Staff
			tools = { 55155 },
			item = 81092,
			reagents = {
				{ 2840, 4 },
				{ 55245 },
			},
		},
		[41011] = { --Encrusted Copper Bangle
			tools = { 55155 },
			item = 55161,
			reagents = {
				{ 2840,  4 },
				{ 55245, 2 },
				{ 774 },
			},
		},
		[41013] = { --Lesser Fortification Ring
			tools = { 55155 },
			item = 55162,
			reagents = {
				{ 55156 },
				{ 5997 },
				{ 774 },
			},
		},
		[41015] = { --Tigercrest Ring
			tools = { 55155 },
			item = 55163,
			reagents = {
				{ 55156 },
				{ 55150 },
				{ 55245 },
				{ 818 },
			},
		},
		[41017] = { --Small Pearlstone Staff
			tools = { 55155 },
			item = 55165,
			reagents = {
				{ 2840,  10 },
				{ 55150, 4 },
				{ 5498,  2 },
			},
		},
		[41019] = { --Amber Ring
			tools = { 55155 },
			item = 55166,
			reagents = {
				{ 55156 },
				{ 55150 },
				{ 81094 },
			},
		},
		[41021] = { --Azure Ring
			tools = { 55155 },
			item = 55167,
			reagents = {
				{ 55156 },
				{ 55245 },
				{ 1210 },
				{ 159,  5 },
			},
		},
		[41023] = { --Bright Copper Necklace
			tools = { 55155 },
			item = 81031,
			reagents = {
				{ 2840, 6 },
				{ 774,  2 },
				{ 55245 },
			},
		},
		[41025] = { --Softglow Ring
			tools = { 55155 },
			item = 55168,
			reagents = {
				{ 55156 },
				{ 774 },
				{ 2880 },
				{ 818 },
			},
		},
		[41027] = { --Topaz Studded Ring
			tools = { 55155 },
			item = 55170,
			reagents = {
				{ 55156 },
				{ 81094, 2 },
				{ 2880 },
				{ 55150 },
			},
		},
		[41029] = { --Coarse Gritted Paper
			tools = { 55155 },
			item = 55151,
			reagents = {
				{ 2592, 2 },
				{ 2836, 2 },
			},
		},
		[41031] = { --Rough Gemstone Cluster
			tools = { 55155 },
			item = 81032,
			reagents = {
				{ 55150 },
				{ 2770 },
			},
		},
		[41033] = { --Lavish Gemmed Necklace
			tools = { 55155 },
			item = 55171,
			reagents = {
				{ 2840, 8 },
				{ 81094 },
				{ 818 },
				{ 2880 },
				{ 1210 },
			},
		},
		[41035] = { --Amberstone Pendant
			tools = { 55155 },
			item = 55172,
			reagents = {
				{ 2840,  6 },
				{ 81094, 3 },
				{ 55245 },
				{ 55150, 4 },
			},
		},
		[41037] = { --Deepmist Choker
			tools = { 55155 },
			item = 55173,
			reagents = {
				{ 2840,  8 },
				{ 5498 },
				{ 818 },
				{ 2880 },
				{ 55150, 2 },
			},
		},
		[41039] = { --Rough Bronze Ring
			tools = { 55155 },
			item = 55174,
			reagents = {
				{ 2841, 2 },
			},
		},
		[41041] = { --Shimmering Bronze Ring
			tools = { 55155 },
			item = 41308,
			reagents = {
				{ 55174 },
				{ 55246 },
				{ 2880,  2 },
				{ 55151, 2 },
			},
		},
		[41043] = { --Amber Orb
			tools = { 55155 },
			item = 41309,
			reagents = {
				{ 2841,  2 },
				{ 81094, 3 },
				{ 55150, 4 },
				{ 55245 },
			},
		},
		[41045] = { --Encrusted Bronze Staff
			tools = { 55155 },
			item = 55175,
			reagents = {
				{ 2841,  8 },
				{ 1210 },
				{ 81094 },
				{ 55151, 4 },
				{ 55245, 2 },
			},
		},
		[41047] = { --Earthrock Loop
			tools = { 55155 },
			item = 55176,
			reagents = {
				{ 55174 },
				{ 2449, 3 },
				{ 2836, 6 },
				{ 2880, 4 },
			},
		},
		[41049] = { --Bronze Cuffed Bangles
			tools = { 55155 },
			item = 41310,
			reagents = {
				{ 2841,  6 },
				{ 2880,  2 },
				{ 55245, 2 },
			},
		},
		[41051] = { --Shadowgem Band
			tools = { 55155 },
			item = 41311,
			reagents = {
				{ 55174 },
				{ 1210, 2 },
				{ 55246 },
			},
		},
		[41053] = { --Bronze Scepter
			tools = { 55155 },
			item = 41313,
			reagents = {
				{ 2841,  6 },
				{ 55246 },
				{ 55151, 4 },
			},
		},
		[41055] = { --Pendant of Midnight
			tools = { 55155 },
			item = 41312,
			reagents = {
				{ 2841, 6 },
				{ 1210, 3 },
				{ 785 },
				{ 55246 },
			},
		},
		[41057] = { --Agatestone Crown
			tools = { 55155 },
			item = 41314,
			reagents = {
				{ 2841,  6 },
				{ 1206 },
				{ 3466,  2 },
				{ 55151, 2 },
			},
		},
		[41059] = { --Moonlight Staff
			tools = { 55155 },
			item = 41315,
			reagents = {
				{ 2841, 8 },
				{ 1705, 3 },
				{ 3466 },
				{ 55246 },
			},
		},
		[41061] = { --Binding Signet
			tools = { 55155 },
			item = 41316,
			reagents = {
				{ 55174 },
				{ 1705, 2 },
				{ 3385 },
			},
		},
		[41063] = { --Enchanted Bracelets
			tools = { 55155 },
			item = 41318,
			reagents = {
				{ 2842, 3 },
				{ 10998 },
				{ 1210 },
			},
		},
		[41065] = { --Coarse Gemstone Cluster
			tools = { 55155 },
			item = 41320,
			reagents = {
				{ 2771,  2 },
				{ 55151, 2 },
			},
		},
		[41067] = { --Rough Silver Ring
			tools = { 55155 },
			item = 41319,
			reagents = {
				{ 2842, 2 },
			},
		},
		[41069] = { --Silver Medallion
			tools = { 55155, 41326 },
			item = 41325,
			reagents = {
				{ 2842,  5 },
				{ 3466 },
				{ 55246, 2 },
				{ 55151, 2 },
			},
		},
		[41071] = { --Ring of Purified Silver
			tools = { 55155, 41326 },
			item = 41329,
			reagents = {
				{ 41319 },
				{ 3466,  2 },
				{ 55246, 4 },
				{ 55151, 8 },
				{ 55249, 3 },
				{ 1206,  3 },
			},
		},
		[41073] = { --Jewelry Lens
			tools = { 6219, 5956 },
			item = 41326,
			reagents = {
				{ 2841, 2 },
				{ 4371, 2 },
				{ 2319 },
				{ 4404 },
				{ 1705 },
			},
		},
		[41075] = { --Jewelry Scope
			tools = { 6219, 5956 },
			item = 41327,
			reagents = {
				{ 10559, 2 },
				{ 4389 },
				{ 10561, 4 },
				{ 3864 },
				{ 7191 },
			},
		},
		[41077] = { --Precision Jewelry Kit
			tools = { 6219, 5956 },
			item = 41328,
			reagents = {
				{ 4389 },
				{ 4387 },
				{ 4382, 3 },
				{ 4375, 3 },
				{ 55155 },
			},
		},
		[41081] = { --Rough Iron Ring
			tools = { 55155 },
			item = 41332,
			reagents = {
				{ 3575, 2 },
			},
		},
		[41083] = { --Rough Gold Ring
			tools = { 55155 },
			item = 41331,
			reagents = {
				{ 3577, 2 },
			},
		},
		[41085] = { --Emberstone Studded Ring
			tools = { 41328, 41326 },
			item = 41323,
			reagents = {
				{ 41322 },
				{ 7077 },
				{ 55250, 4 },
				{ 55247, 2 },
			},
		},
		[41087] = { --Rough Thorium Ring
			tools = { 41328, 41327 },
			item = 41321,
			reagents = {
				{ 12359, 2 },
			},
		},
		[41089] = { --Mithril Blackstone Necklace
			tools = { 41328, 41326 },
			item = 41324,
			reagents = {
				{ 3860, 10 },
				{ 7971, 3 },
				{ 7909 },
				{ 55247 },
			},
		},
		[41091] = { --Dense Gritted Paper
			tools = { 41328 },
			item = 55154,
			reagents = {
				{ 14047, 3 },
				{ 12365, 3 },
			},
		},
		[41093] = { --Radiant Thorium Twilight
			tools = { 41328, 41327 },
			item = 55256,
			reagents = {
				{ 41321 },
				{ 3466,  2 },
				{ 55251, 3 },
				{ 55153, 3 },
			},
		},
		[41095] = { --Glyph Codex
			tools = { 41328, 41327 },
			item = 55269,
			reagents = {
				{ 12359, 8 },
				{ 55251, 5 },
				{ 55247 },
			},
		},
		[41097] = { --Spellweaver Rod
			tools = { 41328, 41327 },
			item = 55271,
			reagents = {
				{ 12359, 12 },
				{ 6037,  6 },
				{ 7910,  3 },
				{ 7909,  3 },
				{ 3466 },
			},
		},
		[41099] = { --Quicksilver Whirl
			tools = { 41328, 41327 },
			item = 55268,
			reagents = {
				{ 6037,  4 },
				{ 12361, 2 },
				{ 55247, 2 },
				{ 7069,  4 },
			},
		},
		[41101] = { --Crystalweft Bracers
			tools = { 41328, 41327 },
			item = 55273,
			reagents = {
				{ 12359, 14 },
				{ 55154, 4 },
				{ 3864,  3 },
				{ 55246 },
			},
		},
		[41103] = { --Ethereal Frostspark Crown
			tools = { 41328, 41327 },
			item = 55267,
			reagents = {
				{ 12359, 12 },
				{ 55154, 6 },
				{ 12361 },
				{ 3829 },
			},
		},
		[41105] = { --Pendant of Arcane Radiance
			tools = { 41328, 41327 },
			item = 41330,
			reagents = {
				{ 12359, 6 },
				{ 13454 },
				{ 12363 },
			},
		},
		[41201] = { --Heavy Gritted Paper
			tools = { 55155 },
			item = 55152,
			reagents = {
				{ 4306, 3 },
				{ 2838, 3 },
			},
		},
		[41203] = { --Heavy Gemstone Cluster
			tools = { 55155 },
			item = 41344,
			reagents = {
				{ 2772,  3 },
				{ 55152, 3 },
			},
		},
		[41205] = { --Goldfire Crystal Bracelet
			tools = { 55155 },
			item = 55144,
			reagents = {
				{ 2841, 6 },
				{ 3577 },
				{ 55249 },
				{ 2880 },
			},
		},
		[41207] = { --Quartz Halo
			tools = { 55155, 41326 },
			item = 55142,
			reagents = {
				{ 41332 },
				{ 55249, 2 },
				{ 55151, 2 },
				{ 55246 },
			},
		},
		[41209] = { --Staff of Blossomed Jade
			tools = { 55155, 41326 },
			item = 55148,
			reagents = {
				{ 3575, 12 },
				{ 1529, 2 },
				{ 1705, 2 },
				{ 3357, 2 },
				{ 55247 },
			},
		},
		[41211] = { --Jade Harmony Circlet
			tools = { 55155, 41326 },
			item = 55143,
			reagents = {
				{ 41331 },
				{ 1529 },
				{ 55246, 2 },
				{ 55152, 2 },
			},
		},
		[41213] = { --Goldenshade Quartz Crown
			tools = { 55155 },
			item = 55145,
			reagents = {
				{ 3575,  8 },
				{ 3577,  2 },
				{ 55249, 2 },
			},
		},
		[41215] = { --The Golden Goblet
			tools = { 55155 },
			item = 55146,
			reagents = {
				{ 3577, 5 },
				{ 4234, 2 },
				{ 3466, 2 },
				{ 3825 },
			},
		},
		[41217] = { --Powerful Citrine Pendant
			tools = { 55155, 41326 },
			item = 55147,
			reagents = {
				{ 3575, 12 },
				{ 3577, 4 },
				{ 3864, 4 },
				{ 1206, 2 },
				{ 55247 },
				{ 11135 },
			},
		},
		[41219] = { --Rough Mithril Ring
			tools = { 55155 },
			item = 41322,
			reagents = {
				{ 3860, 2 },
			},
		},
		[41221] = { --Ironsun Citrine Ring
			tools = { 55155, 41326 },
			item = 55141,
			reagents = {
				{ 41332 },
				{ 3577, 2 },
				{ 3864, 4 },
				{ 55246 },
			},
		},
		[41223] = { --Shimmering Gold Necklace
			tools = { 55155, 41326 },
			item = 41340,
			reagents = {
				{ 3577,  8 },
				{ 55246, 3 },
				{ 55152, 3 },
			},
		},
		[41225] = { --Ironbloom Ring
			tools = { 55155, 41326 },
			item = 41342,
			reagents = {
				{ 41332 },
				{ 3575,  2 },
				{ 2838,  6 },
				{ 3355 },
				{ 55152, 2 },
			},
		},
		[41227] = { --Ornate Mithril Scepter
			tools = { 41328 },
			item = 41343,
			reagents = {
				{ 3860,  8 },
				{ 4234,  2 },
				{ 55152, 2 },
			},
		},
		[41229] = { --Solid Gritted Paper
			tools = { 41328 },
			item = 55153,
			reagents = {
				{ 4338, 3 },
				{ 7912, 3 },
			},
		},
		[41231] = { --Minor Trollblood Ring
			tools = { 55155 },
			item = 55164,
			reagents = {
				{ 55156 },
				{ 3382 },
				{ 55245 },
			},
		},
		[41233] = { --Rough Truesilver Ring
			tools = { 41328 },
			item = 41341,
			reagents = {
				{ 7911, 2 },
				{ 6037, 2 },
			},
		},
		[41235] = { --Aquamarine Pendant
			tools = { 41328 },
			item = 55196,
			reagents = {
				{ 3860,  8 },
				{ 7909,  2 },
				{ 55152, 2 },
			},
		},
		[41237] = { --Solid Gemstone Cluster
			tools = { 41328 },
			item = 56020,
			reagents = {
				{ 3858,  3 },
				{ 55153, 3 },
			},
		},
		[41239] = { --Greater Binding Signet
			tools = { 41328, 41326 },
			item = 41346,
			reagents = {
				{ 41322 },
				{ 55251 },
				{ 7909 },
				{ 6149, 2 },
				{ 55247 },
			},
		},
		[41241] = { --Royal Gemstone Staff
			tools = { 41328, 41326 },
			item = 41345,
			reagents = {
				{ 3860,  14 },
				{ 3577,  4 },
				{ 55251, 2 },
				{ 7909,  2 },
				{ 55153, 4 },
			},
		},
		[41243] = { --Emberstone Idol
			tools = { 41328, 41326 },
			item = 41349,
			reagents = {
				{ 55250, 5 },
				{ 6371,  3 },
				{ 7077 },
				{ 7068 },
			},
		},
		[41245] = { --Runed Truesilver Ring
			tools = { 41328, 41326 },
			item = 41347,
			reagents = {
				{ 41341 },
				{ 7067 },
				{ 7075 },
				{ 55153, 2 },
			},
		},
		[41247] = { --Small Pearl Ring
			tools = { 55155 },
			item = 55169,
			reagents = {
				{ 55156 },
				{ 5498 },
				{ 55150, 2 },
				{ 55245 },
			},
		},
		[41249] = { --Bulky Copper Ring
			tools = { 55155 },
			item = 81093,
			reagents = {
				{ 55156 },
				{ 2880 },
				{ 55245 },
			},
		},
		[41251] = { --Blue Starfire
			tools = { 41328, 41327 },
			item = 55258,
			reagents = {
				{ 41321 },
				{ 12361 },
				{ 55251 },
				{ 55247 },
			},
		},
		[41253] = { --Emerald Monarch's Glow
			tools = { 41328, 41327 },
			item = 55265,
			reagents = {
				{ 41321 },
				{ 12655, 4 },
				{ 12364, 2 },
				{ 55154, 2 },
				{ 55247 },
			},
		},
		[41255] = { --Sapphire Luminescence
			tools = { 41328, 41327 },
			item = 55259,
			reagents = {
				{ 41341 },
				{ 12655, 5 },
				{ 12361, 5 },
				{ 7076 },
				{ 55154, 8 },
				{ 55247, 3 },
			},
		},
		[41257] = { --Arcanum Baton
			tools = { 41328, 41327 },
			item = 55259,
			reagents = {
				{ 41341 },
				{ 12655, 5 },
				{ 12361, 5 },
				{ 7076 },
				{ 55150, 8 },
				{ 55247, 3 },
			},
		},
		[41259] = { --Arcanum Baton
			tools = { 41328, 41327 },
			item = 55272,
			reagents = {
				{ 12359, 28 },
				{ 3577,  4 },
				{ 7082,  2 },
				{ 61673, 2 },
				{ 55154, 8 },
			},
		},
		[41261] = { --Sunburst Tiara
			tools = { 41328, 41326 },
			item = 55266,
			reagents = {
				{ 12359, 20 },
				{ 7910,  2 },
				{ 55250, 2 },
				{ 3466,  2 },
				{ 55246, 4 },
			},
		},
		[41263] = { --Ocean's Gaze
			tools = { 55155, 41326 },
			item = 56023,
			reagents = {
				{ 41322 },
				{ 7909,  3 },
				{ 6372,  3 },
				{ 55152, 3 },
			},
		},
		[41265] = { --Starry Thorium Band
			tools = { 41328, 41327 },
			item = 55260,
			reagents = {
				{ 41321 },
				{ 7910,  2 },
				{ 55246, 4 },
				{ 55247 },
			},
		},
		[41267] = { --Ruby Ring of Ruin
			tools = { 41328, 41327 },
			item = 56032,
			reagents = {
				{ 56033 },
				{ 7910,  12 },
				{ 55250, 12 },
				{ 7078,  8 },
				{ 7077,  12 },
				{ 55248, 8 },
			},
		},
		[41269] = { --Encrusted Gemstone Ring
			tools = { 41328, 41327 },
			item = 56031,
			reagents = {
				{ 56033 },
				{ 55252 },
				{ 12364, 5 },
				{ 7910,  5 },
				{ 12361, 5 },
				{ 55248, 5 },
			},
		},
		[41271] = { --Pure Gold Ring
			tools = { 41328, 41326 },
			item = 56033,
			reagents = {
				{ 3577,  8 },
				{ 12360, 2 },
				{ 3466,  2 },
			},
		},
		[41273] = { --Prism Amulet
			tools = { 41328, 41326 },
			item = 55199,
			reagents = {
				{ 12359, 8 },
				{ 12799, 2 },
				{ 55154, 2 },
				{ 55247 },
			},
		},
		[41275] = { --Gemmed Citrine Pendant
			tools = { 55155, 41326 },
			item = 55202,
			reagents = {
				{ 3575,  6 },
				{ 3577 },
				{ 55249, 2 },
				{ 3864,  2 },
			},
		},
		[41277] = { --Starforge Amulet
			tools = { 55155, 41326 },
			item = 55197,
			reagents = {
				{ 3860,  6 },
				{ 7910,  2 },
				{ 55249, 2 },
				{ 55153, 4 },
			},
		},
		[41279] = { --Voidheart Charm
			tools = { 41328, 41327 },
			item = 55200,
			reagents = {
				{ 12359, 5 },
				{ 12655 },
				{ 55249, 4 },
				{ 12808, 2 },
				{ 55154, 2 },
			},
		},
		[41281] = { --Runebound Amulet
			tools = { 41328, 41326 },
			item = 55204,
			reagents = {
				{ 6037,  12 },
				{ 7075,  4 },
				{ 7067,  4 },
				{ 7068,  4 },
				{ 55153, 8 },
			},
		},
		[41283] = { --Astral Amulet
			tools = { 55155, 41326 },
			item = 55195,
			reagents = {
				{ 3575,  6 },
				{ 3864,  2 },
				{ 55249, 2 },
				{ 55152, 3 },
			},
		},
		[41285] = { --Shimmering Moonstone Tablet
			tools = { 55155, 41326 },
			item = 56034,
			reagents = {
				{ 55251, 2 },
				{ 1705,  8 },
				{ 55246, 2 },
				{ 55152, 4 },
			},
		},
		[41287] = { --Stormcloud Sigil
			tools = { 41328, 41327 },
			item = 56035,
			reagents = {
				{ 12655, 3 },
				{ 7082,  3 },
				{ 7069,  5 },
				{ 7081,  5 },
			},
		},
		[41303] = { --Massive Jewel Circlet
			tools = { 41328, 41327 },
			item = 55264,
			reagents = {
				{ 41321 },
				{ 12364 },
				{ 55154, 3 },
				{ 55247 },
			},
		},
		[41305] = { --Golden Scepter of Authority
			tools = { 41328, 41326 },
			item = 56036,
			reagents = {
				{ 3577,  8 },
				{ 3860,  2 },
				{ 4304,  2 },
				{ 55246, 6 },
			},
		},
		[41307] = { --Gemkeeper's Folio
			tools = { 41328, 41326 },
			item = 55243,
			reagents = {
				{ 3860,  18 },
				{ 55249, 3 },
				{ 55251, 3 },
				{ 3864,  3 },
				{ 55152, 6 },
			},
		},
		[41309] = { --Stellar Ruby Ring
			tools = { 41328, 41326 },
			item = 55261,
			reagents = {
				{ 41321 },
				{ 7910,  5 },
				{ 55154, 3 },
				{ 55247 },
			},
		},
		[41311] = { --Stellar Gemguards
			tools = { 41328, 41326 },
			item = 55178,
			reagents = {
				{ 3860, 8 },
				{ 55249 },
				{ 55251 },
				{ 55250 },
			},
		},
		[41313] = { --Garnet Guardian Staff
			tools = { 41328, 41326 },
			item = 55241,
			reagents = {
				{ 12359, 24 },
				{ 12800, 2 },
				{ 12799, 2 },
				{ 7075,  2 },
				{ 55154, 4 },
			},
		},
		[41315] = { --Moonlit Charm
			tools = { 41328, 41326 },
			item = 55198,
			reagents = {
				{ 3860,  12 },
				{ 55251, 4 },
				{ 55247 },
			},
		},
		[41317] = { --Twilight Opal Cascade
			tools = { 41328, 41326 },
			item = 55263,
			reagents = {
				{ 56033 },
				{ 12799, 3 },
				{ 20520, 3 },
				{ 55248, 2 },
			},
		},
		[41321] = { --Gleaming Chain
			tools = { 55155 },
			item = 56037,
			reagents = {
				{ 2840,  5 },
				{ 55245, 2 },
				{ 55150, 2 },
			},
		},
		[41323] = { --Talisman of Stone
			tools = { 55155 },
			item = 56038,
			reagents = {
				{ 2841,  8 },
				{ 2836,  4 },
				{ 55151, 2 },
			},
		},
		[41325] = { --Medallion of Flame
			tools = { 55155 },
			item = 56039,
			reagents = {
				{ 2841, 6 },
				{ 2880 },
				{ 10940 },
			},
		},
		[41327] = { --Gleaming Silver Necklace
			tools = { 55155 },
			item = 56040,
			reagents = {
				{ 2842,  4 },
				{ 55249 },
				{ 55246, 2 },
				{ 55245, 2 },
			},
		},
		[41329] = { --Ring of The Turtle
			tools = { 55155, 41326 },
			item = 56041,
			reagents = {
				{ 41331 },
				{ 1206, 2 },
				{ 3389 },
			},
		},
		[41331] = { --Gem Encrusted Choker
			tools = { 55155, 41326 },
			item = 56042,
			reagents = {
				{ 3575, 5 },
				{ 1206 },
				{ 55249 },
				{ 1705 },
			},
		},
		[41333] = { --Goldcrest Amulet
			tools = { 55155, 41326 },
			item = 56043,
			reagents = {
				{ 3577,  8 },
				{ 3466 },
				{ 55152, 2 },
			},
		},
		[41335] = { --Shining Copper Cuffs
			tools = { 55155 },
			item = 56044,
			reagents = {
				{ 2840, 6 },
				{ 818 },
				{ 55246 },
			},
		},
		[41337] = { --Dawnbright Cuffs
			tools = { 55155 },
			item = 56045,
			reagents = {
				{ 2841,  5 },
				{ 81094, 2 },
				{ 55245 },
			},
		},
		[41339] = { --Circlet of Dampening
			tools = { 55155 },
			item = 56046,
			reagents = {
				{ 2841,  4 },
				{ 2842,  2 },
				{ 3384 },
				{ 55151, 3 },
			},
		},
		[41341] = { --Eternal Jade Crown
			tools = { 55155, 41326 },
			item = 56047,
			reagents = {
				{ 3575, 4 },
				{ 1529, 2 },
				{ 3357, 2 },
				{ 55246 },
			},
		},
		[41348] = { --Crystalfire Armlets
			tools = { 41328, 41326 },
			item = 55180,
			reagents = {
				{ 12359, 8 },
				{ 55249, 4 },
				{ 8956,  2 },
				{ 55153, 2 },
			},
		},
		[41350] = { --Cinderfall Band
			tools = { 41328, 41326 },
			item = 55228,
			reagents = {
				{ 41321 },
				{ 55250 },
				{ 7910 },
				{ 7077 },
				{ 55247 },
			},
		},
		[41352] = { --Opaline Illuminator
			tools = { 41328, 41326 },
			item = 55242,
			reagents = {
				{ 3860,  24 },
				{ 3864,  6 },
				{ 55249, 6 },
				{ 7075,  2 },
				{ 55246, 4 },
			},
		},
		[41354] = { --Skyfire Jewel
			tools = { 41328, 41326 },
			item = 55255,
			reagents = {
				{ 41321 },
				{ 55251, 3 },
				{ 7069,  3 },
			},
		},
		[41356] = { --Gemstone Compendium
			tools = { 55155 },
			item = 55244,
			reagents = {
				{ 8170,  12 },
				{ 10648, 20 },
				{ 16203, 2 },
				{ 12655, 2 },
				{ 7076,  3 },
			},
		},
		[41541] = { --Dazzling Aquamarine Loop
			tools = { 55155, 41326 },
			item = 56048,
			reagents = {
				{ 41322 },
				{ 7909,  4 },
				{ 55246, 2 },
				{ 55152, 2 },
			},
		},
		[41546] = { --Alluring Citrine Choker
			tools = { 41328, 55155 },
			item = 56049,
			reagents = {
				{ 3860, 12 },
				{ 3864, 2 },
			},
		},
		[41548] = { --Elaborate Golden Bracelets
			tools = { 41326, 55155 },
			item = 56050,
			reagents = {
				{ 3577,  10 },
				{ 4234,  4 },
				{ 55251, 2 },
			},
		},
		[41550] = { --Heart of the Sea
			tools = { 41326, 55155 },
			item = 56051,
			reagents = {
				{ 3860, 4 },
				{ 7070, 4 },
				{ 7909 },
				{ 55246 },
			},
		},
		[41552] = { --Staff of Gallitrea
			tools = { 41326, 55155 },
			item = 56052,
			reagents = {
				{ 3860,  18 },
				{ 55249, 3 },
				{ 7070,  2 },
				{ 55153, 6 },
			},
		},
		[41554] = { --Golden Jade Ring
			tools = { 41328, 41326 },
			item = 56053,
			reagents = {
				{ 41331 },
				{ 3577,  2 },
				{ 1529,  6 },
				{ 3821,  6 },
				{ 55247, 2 },
			},
		},
		[41556] = { --Delicate Mithril Amulet
			tools = { 55155, 41326 },
			item = 56054,
			reagents = {
				{ 3860,  10 },
				{ 3466,  2 },
				{ 55152, 4 },
			},
		},
		[41558] = { --Draenethyst Baton
			tools = { 41328, 41326 },
			item = 56055,
			reagents = {
				{ 3860, 4 },
				{ 10593 },
				{ 55246 },
			},
		},
		[41560] = { --Ebon Ring
			tools = { 55155 },
			item = 55316,
			reagents = {
				{ 55156 },
				{ 2880,  3 },
				{ 55150, 2 },
			},
		},
		[41562] = { --The King's Conviction
			tools = { 55155 },
			item = 55317,
			reagents = {
				{ 55156 },
				{ 2880 },
				{ 2447, 4 },
			},
		},
		[41564] = { --Shadowfall Jewel
			tools = { 55155 },
			item = 55318,
			reagents = {
				{ 55174 },
				{ 1210 },
				{ 81094 },
				{ 55150 },
			},
		},
		[41566] = { --Ocean's Wrath
			tools = { 55155 },
			item = 55319,
			reagents = {
				{ 55174 },
				{ 5498 },
				{ 2880 },
			},
		},
		[41568] = { --Dazzling Moonstone Band
			tools = { 55155, 41326 },
			item = 55320,
			reagents = {
				{ 55174 },
				{ 1705, 3 },
				{ 55245 },
			},
		},
		[41570] = { --Harpy Talon Ring
			tools = { 55155, 41326 },
			item = 55321,
			reagents = {
				{ 55174 },
				{ 5635,  4 },
				{ 55151, 2 },
			},
		},
		[41572] = { --Centaur Hoof Circlet
			tools = { 55155, 41326 },
			item = 55322,
			reagents = {
				{ 41332 },
				{ 7067 },
				{ 3466 },
				{ 55151, 2 },
			},
		},
		[41574] = { --Ogre Bone Band
			tools = { 55155, 41326 },
			item = 55323,
			reagents = {
				{ 41332 },
				{ 55249, 4 },
				{ 3864,  4 },
				{ 3391 },
				{ 3466,  2 },
			},
		},
		[41577] = { --Malachite Ring
			tools = { 55155 },
			item = 81030,
			reagents = {
				{ 55156 },
				{ 774 },
			},
		},
		[41579] = { --Marine's Demise
			tools = { 55155, 41326 },
			item = 55325,
			reagents = {
				{ 41322 },
				{ 7909, 2 },
				{ 1210, 2 },
				{ 55246 },
			},
		},
		[41581] = { --Serpent's Coil Staff
			tools = { 55155 },
			item = 55326,
			reagents = {
				{ 2841, 10 },
				{ 1210, 2 },
				{ 2453, 2 },
			},
		},
		[41583] = { --Farraki Ceremony Totem
			tools = { 55155, 41326 },
			item = 55327,
			reagents = {
				{ 2841,  12 },
				{ 3575,  6 },
				{ 7069,  2 },
				{ 7068,  2 },
				{ 3388,  2 },
				{ 55151, 4 },
			},
		},
		[41585] = { --Sphinx's Wisdom Staff
			tools = { 55155, 41326 },
			item = 55328,
			reagents = {
				{ 3575, 18 },
				{ 2838, 2 },
				{ 3864, 2 },
			},
		},
		[41587] = { --Gloomweed Bindings
			tools = { 55155 },
			item = 55329,
			reagents = {
				{ 2840, 6 },
				{ 2447, 2 },
				{ 55245 },
			},
		},
		[41589] = { --Crystal Earring
			tools = { 55155, 41326 },
			item = 56047,
			reagents = {
				{ 3575,  4 },
				{ 55249, 5 },
				{ 3466,  2 },
				{ 55152, 2 },
			},
		},
		[41591] = { --Specter's Shade Ring
			tools = { 55155, 41326 },
			item = 55324,
			reagents = {
				{ 41332 },
				{ 11135 },
				{ 55152 },
				{ 3577, 2 },
			},
		},
		[41601] = { --Sharpened Citrine Gemstone
			tools = { 41328, 41326 },
			item = 56002,
			reagents = {
				{ 3864 },
				{ 55152, 4 },
				{ 55247 },
			},
		},
		[41603] = { --Radiant Ember Gemstone
			tools = { 41328, 41326 },
			item = 56004,
			reagents = {
				{ 55250 },
				{ 55152, 4 },
				{ 55247 },
			},
		},
		[41605] = { --Glowing Ruby Gemstone
			tools = { 41328, 41326 },
			item = 56006,
			reagents = {
				{ 7910 },
				{ 55152 },
				{ 11134 },
				{ 55247 },
			},
		},
		[41607] = { --Shimmering Aqua Gemstone
			tools = { 41328, 41326 },
			item = 56003,
			reagents = {
				{ 7909 },
				{ 55152 },
				{ 55246, 2 },
				{ 55247 },
			},
		},
		[41609] = { --Azerothian Ruby Gemstone
			tools = { 41328, 41326 },
			item = 56015,
			reagents = {
				{ 12800 },
				{ 7910 },
				{ 16203 },
				{ 55154, 2 },
				{ 55247 },
			},
		},
		[41611] = { --Gloomy Diamond Gemstone
			tools = { 41328, 41326 },
			item = 56012,
			reagents = {
				{ 11754 },
				{ 55153, 5 },
				{ 55247 },
			},
		},
		[41613] = { --Flawless Black Gemstone
			tools = { 41328, 41326 },
			item = 56013,
			reagents = {
				{ 18335 },
				{ 16202 },
				{ 55154, 2 },
				{ 55248 },
			},
		},
		[41615] = { --Arcane Emerald Gemstone
			tools = { 41328, 41326 },
			item = 56016,
			reagents = {
				{ 12363 },
				{ 12364 },
				{ 14344 },
				{ 55154, 2 },
				{ 55248 },
			},
		},
		[41617] = { --Tempered Azerothian Gemstone
			tools = { 41328, 41326 },
			item = 56017,
			reagents = {
				{ 12800, 2 },
				{ 55154 },
				{ 55247 },
			},
		},
		[41619] = { --Stunning Imperial Gemstone
			tools = { 41328, 41326 },
			item = 56014,
			reagents = {
				{ 55252 },
				{ 14344 },
				{ 8831, 4 },
				{ 7075 },
				{ 55248 },
			},
		},
		[41621] = { --Enchanted Emerald Gemstone
			tools = { 41328, 41326 },
			item = 56018,
			reagents = {
				{ 12364 },
				{ 7081, 3 },
				{ 55152 },
				{ 55247 },
			},
		},
		[41623] = { --Pure Shining Moonstone
			tools = { 41328, 41326 },
			item = 56058,
			reagents = {
				{ 55251 },
				{ 55152, 5 },
				{ 55247 },
			},
		},
		[41625] = { --Beautiful Diamond Gemstone
			tools = { 41328, 41326 },
			item = 56010,
			reagents = {
				{ 12800, 2 },
				{ 55152, 2 },
				{ 55247 },
			},
		},
		[41627] = { --Pristine Crystal Gemstone
			tools = { 55155, 41326 },
			item = 56000,
			reagents = {
				{ 55249 },
				{ 55151 },
				{ 55247 },
			},
		},
		[41629] = { --Gleaming Jade Gemstone
			tools = { 55155, 41326 },
			item = 56001,
			reagents = {
				{ 1529 },
				{ 11135 },
				{ 55247 },
			},
		},
		[41631] = { --Illuminated Gemstone
			tools = { 41328, 41326 },
			item = 56005,
			reagents = {
				{ 55251 },
				{ 11082 },
				{ 55247 },
				{ 55152 },
			},
		},
		[41633] = { --Burning Star Gemstone
			tools = { 41328, 41326 },
			item = 56056,
			reagents = {
				{ 7910 },
				{ 7068, 2 },
				{ 55247 },
			},
		},
		[41635] = { --Brilliant Opal Gemstone
			tools = { 41328, 41326 },
			item = 56008,
			reagents = {
				{ 12799, 2 },
				{ 55153 },
				{ 55247 },
			},
		},
		[41637] = { --Elegant Emerald Gemstone
			tools = { 41328, 41326 },
			item = 56009,
			reagents = {
				{ 12364 },
				{ 55153, 2 },
				{ 55247, 2 },
			},
		},
		[41639] = { --Shining Sapphire Gemstone
			tools = { 41328, 41326 },
			item = 56007,
			reagents = {
				{ 12361 },
				{ 16203 },
				{ 55247 },
			},
		},
		[41641] = { --Unstable Arcane Gemstone
			tools = { 41328, 41326 },
			item = 56011,
			reagents = {
				{ 12363 },
				{ 61673 },
				{ 55247 },
			},
		},
		[41643] = { --Glittering Sapphire Gemstone
			tools = { 41328, 41326 },
			item = 56057,
			reagents = {
				{ 12361 },
				{ 3819, 4 },
				{ 7070 },
				{ 55247 },
			},
		},
		[41696] = { --Shimmering Diamond Band
			tools = { 41326, 41328 },
			item = 56059,
			reagents = {
				{ 56033 },
				{ 6037,  8 },
				{ 12800, 10 },
				{ 3466,  6 },
				{ 55154, 6 },
				{ 55247, 6 },
			},
		},
		[41698] = { --Crown of Molten Ascension
			tools = { 41326, 41328 },
			item = 56060,
			reagents = {
				{ 12360, 8 },
				{ 55250, 12 },
				{ 7078,  6 },
				{ 7077,  6 },
				{ 7068,  6 },
				{ 55248, 2 },
			},
		},
		[41700] = { --Embergem Cuffs
			tools = { 41326, 41328 },
			item = 56061,
			reagents = {
				{ 12360, 4 },
				{ 12655, 12 },
				{ 7910,  8 },
				{ 7078,  4 },
				{ 7068,  12 },
				{ 55247, 6 },
			},
		},
		[41702] = { --Blackwing Signet of Command
			tools = { 41326, 41328 },
			item = 56062,
			reagents = {
				{ 12360, 6 },
				{ 3577,  28 },
				{ 15416, 32 },
				{ 17010, 4 },
				{ 55154, 8 },
				{ 7078,  6 },
			},
		},
		[41704] = { --Talisman of Hinderance
			tools = { 41326, 41328 },
			item = 56063,
			reagents = {
				{ 12655, 20 },
				{ 7082,  8 },
				{ 7080,  8 },
				{ 7076,  8 },
				{ 7078,  8 },
				{ 12803, 8 },
			},
		},
		[41706] = { --Mastercrafted Diamond Crown
			tools = { 41326, 41328 },
			item = 56064,
			reagents = {
				{ 12360, 8 },
				{ 6037,  8 },
				{ 12800, 12 },
				{ 61673, 4 },
				{ 55154, 12 },
				{ 55248, 4 },
			},
		},
		[41708] = { --Opalstone Circle
			tools = { 41326, 41328 },
			item = 56065,
			reagents = {
				{ 41321 },
				{ 12799, 6 },
				{ 7076,  6 },
				{ 3356,  6 },
				{ 55154, 8 },
				{ 55247, 3 },
			},
		},
		[41710] = { --Deep Sapphire Circlet
			tools = { 41326, 41328 },
			item = 56066,
			reagents = {
				{ 56033 },
				{ 12361, 5 },
				{ 7080,  2 },
				{ 55247 },
			},
		},
		[41712] = { --Dark Iron Signet Ring
			tools = { 41326, 41328 },
			item = 56067,
			reagents = {
				{ 11371, 4 },
				{ 7077,  8 },
				{ 11382, 2 },
			},
		},
		[41714] = { --Opal Guided Bangles
			tools = { 41326, 41328 },
			item = 56068,
			reagents = {
				{ 12359, 8 },
				{ 12799, 4 },
				{ 7081,  6 },
				{ 9187 },
				{ 55153, 4 },
			},
		},
		[41716] = { --Crown of Elegance
			tools = { 41326, 41328 },
			item = 56069,
			reagents = {
				{ 3860,  20 },
				{ 7971,  2 },
				{ 55249, 4 },
				{ 55251, 4 },
				{ 3466,  8 },
			},
		},
		[41718] = { --Ornate Mithril Bracelets
			tools = { 41326, 41328 },
			item = 56070,
			reagents = {
				{ 3860,  8 },
				{ 3466,  6 },
				{ 3864,  4 },
				{ 55152, 4 },
				{ 55246, 4 },
			},
		},
		[41720] = { --Regal Twilight Staff
			tools = { 41326, 41328 },
			item = 56071,
			reagents = {
				{ 3860,  12 },
				{ 6037,  8 },
				{ 7971,  4 },
				{ 8839,  2 },
				{ 55251, 4 },
				{ 55153, 8 },
			},
		},
		[41722] = { --Pendant of Instability
			tools = { 41326, 41328 },
			item = 56072,
			reagents = {
				{ 12655, 12 },
				{ 12363, 4 },
				{ 61673, 8 },
				{ 16203, 2 },
				{ 55248, 2 },
			},
		},
		[41724] = { --Ornament of Restraint
			tools = { 41326, 41328 },
			item = 56073,
			reagents = {
				{ 12359, 8 },
				{ 7971,  2 },
				{ 11175, 2 },
				{ 7067,  4 },
				{ 55153, 4 },
			},
		},
		[41726] = { --Hydrathorn Bracers
			tools = { 55155 },
			item = 55330,
			reagents = {
				{ 3576,  8 },
				{ 2450,  2 },
				{ 55151, 2 },
			},
		},
		[41728] = { --Blackrock Ironclamps
			tools = { 55155, 41326 },
			item = 55331,
			reagents = {
				{ 3575, 10 },
				{ 1210, 2 },
				{ 5500 },
				{ 5635, 8 },
				{ 3466, 2 },
			},
		},
		[41730] = { --Monastery Emberbrace
			tools = { 55155, 41326 },
			item = 55332,
			reagents = {
				{ 3859, 6 },
				{ 4306, 2 },
				{ 3864, 2 },
			},
		},
		[41732] = { --Shadowmoon Orb
			tools = { 55155 },
			item = 55333,
			reagents = {
				{ 2840,  5 },
				{ 81094, 2 },
				{ 55150, 2 },
			},
		},
		[41734] = { --Fangclaw Relic
			tools = { 55155 },
			item = 55334,
			reagents = {
				{ 2842,  4 },
				{ 1206,  4 },
				{ 55246, 2 },
				{ 55151, 2 },
				{ 3390 },
				{ 5635,  8 },
			},
		},
		[41736] = { --Netherbane Rod
			tools = { 55155, 41326 },
			item = 55335,
			reagents = {
				{ 3575,  6 },
				{ 3864,  4 },
				{ 55246, 2 },
			},
		},
		[41738] = { --Marine Root
			tools = { 55155, 41326 },
			item = 55336,
			reagents = {
				{ 3860, 2 },
				{ 3357, 2 },
				{ 7909, 2 },
			},
		},
		[41740] = { --Mistwood Tiara
			tools = { 55155 },
			item = 55337,
			reagents = {
				{ 2841, 10 },
				{ 1206, 2 },
				{ 55245 },
			},
		},
		[41742] = { --Venomspire Diadem
			tools = { 55155, 41326 },
			item = 55338,
			reagents = {
				{ 3575,  10 },
				{ 1529,  2 },
				{ 55245, 2 },
				{ 1288,  6 },
				{ 3466,  2 },
			},
		},
		[41744] = { --Bloodfire Circlet
			tools = { 55155, 41326 },
			item = 55339,
			reagents = {
				{ 3859,  7 },
				{ 55250, 2 },
				{ 55245, 2 },
			},
		},
		[41746] = { --Shadowforged Eye
			tools = { 55155 },
			item = 55340,
			reagents = {
				{ 2840, 2 },
				{ 774 },
				{ 818 },
				{ 81094 },
				{ 1210 },
			},
		},
		[41748] = { --Totem of Self Preservation
			tools = { 55155 },
			item = 55341,
			reagents = {
				{ 2842,  2 },
				{ 5498,  2 },
				{ 55249, 4 },
				{ 55246, 2 },
				{ 55151, 2 },
			},
		},
		[41750] = { --Facetted Moonstone Brooch
			tools = { 55155 },
			item = 55210,
			reagents = {
				{ 3859,  3 },
				{ 1705,  2 },
				{ 55152, 2 },
			},
		},
		[41752] = { --Obsidian Brooch
			tools = { 55155 },
			item = 55211,
			reagents = {
				{ 3859,  4 },
				{ 1529,  2 },
				{ 55152, 2 },
			},
		},
		[41754] = { --Smoldering Brooch
			tools = { 55155 },
			item = 55212,
			reagents = {
				{ 3860,  3 },
				{ 55250, 2 },
				{ 55153, 2 },
			},
		},
		[41756] = { --Vitriol Brooch
			tools = { 55155 },
			item = 55213,
			reagents = {
				{ 3860,  3 },
				{ 9262,  2 },
				{ 55153, 2 },
			},
		},
		[41758] = { --Enchanted Gemstone Oil
			tools = { 11145 },
			item = 55248,
			reagents = {
				{ 55247 },
				{ 16203 },
				{ 11175 },
			},
		},
		[41760] = { --Graceful Agate Gemstone
			tools = { 55155, 41326 },
			item = 56074,
			reagents = {
				{ 1206 },
				{ 55151, 2 },
				{ 55246, 2 },
			},
		},
		[41762] = { --Dreary Opal Gemstone
			tools = { 41327, 41328 },
			item = 56075,
			reagents = {
				{ 12799 },
				{ 13466 },
				{ 55247, 2 },
			},
		},
		[41764] = { --Resurged Topaz Gemstone
			tools = { 41327, 41328 },
			item = 56077,
			reagents = {
				{ 55252 },
				{ 61673, 3 },
				{ 55248, 3 },
			},
		},
		[41768] = { --Resilient Arcane Gemstone
			tools = { 41327, 41328 },
			item = 56076,
			reagents = {
				{ 55252 },
				{ 12363 },
				{ 7076, 2 },
				{ 55248 },
			},
		},
		[41770] = { --Dense Gemstone Cluster
			tools = { 41328 },
			item = 56019,
			reagents = {
				{ 10620, 3 },
				{ 55154, 3 },
			},
		},
		[41774] = { --Spellweaver Pendant
			tools = { 41328, 41327 },
			item = 56090,
			reagents = {
				{ 12359, 6 },
				{ 6037,  3 },
				{ 7910 },
				{ 7909 },
			},
		},
		[41776] = { --Ring of Midnight
			tools = { 55155, 41326 },
			item = 56091,
			reagents = {
				{ 55174 },
				{ 1210, 2 },
				{ 785 },
				{ 55246 },
			},
		},
		[41778] = { --Stormcloud Shackles
			tools = { 41328, 41327 },
			item = 56092,
			reagents = {
				{ 12655, 2 },
				{ 7082 },
				{ 7081,  3 },
				{ 55154, 3 },
			},
		},
		[41780] = { --Stormcloud Signet
			tools = { 41328, 41327 },
			item = 56093,
			reagents = {
				{ 41321 },
				{ 12655, 6 },
				{ 7082,  3 },
				{ 7081,  6 },
				{ 55154, 4 },
				{ 55247, 4 },
			},
		},
		[41782] = { --Golden Runed Ring
			tools = { 41328, 41327 },
			item = 56094,
			reagents = {
				{ 56033 },
				{ 12360, 2 },
				{ 12655, 6 },
				{ 20520, 12 },
				{ 7075,  20 },
				{ 55248, 3 },
			},
		},
		[41784] = { --Mana Binding Signet
			tools = { 41328, 41326 },
			item = 56095,
			reagents = {
				{ 41341 },
				{ 55251, 8 },
				{ 7079,  8 },
				{ 7070,  12 },
				{ 3358,  12 },
				{ 55247, 4 },
			},
		},
		[41786] = { --Ornate Mithril Crown
			tools = { 41328, 41326 },
			item = 56089,
			reagents = {
				{ 3860,  16 },
				{ 55152, 4 },
				{ 3466 },
				{ 55246, 4 },
			},
		},
		[41788] = { --Blazefury Circlet
			tools = { 41328, 41326 },
			item = 55359,
			reagents = {
				{ 56033 },
				{ 55252, 2 },
				{ 12364, 8 },
				{ 12799, 10 },
				{ 55248, 4 },
				{ 7078,  6 },
			},
		},
		[41790] = { --Ring of Unleashed Potential
			tools = { 41328, 41326 },
			item = 55360,
			reagents = {
				{ 56033 },
				{ 55252 },
				{ 12803, 16 },
				{ 18335, 4 },
				{ 12799, 6 },
				{ 55248, 4 },
			},
		},
		[41792] = { --Empowered Domination Rod
			tools = { 41328, 41326 },
			item = 55361,
			reagents = {
				{ 12360, 6 },
				{ 12359, 12 },
				{ 55252 },
				{ 13926, 4 },
				{ 12800, 8 },
				{ 55248, 2 },
			},
		},
		[41794] = { --Orb of Clairvoyance
			tools = { 41328, 41326 },
			item = 55362,
			reagents = {
				{ 12359, 16 },
				{ 5116,  12 },
				{ 12361, 6 },
				{ 12799, 6 },
				{ 55247, 2 },
			},
		},
		[41796] = { --Grail of Forgotten Memories
			tools = { 41328, 41326 },
			item = 55363,
			reagents = {
				{ 3577,  24 },
				{ 55252 },
				{ 7080,  8 },
				{ 7076,  8 },
				{ 12800, 6 },
				{ 55248, 4 },
			},
		},
		[41798] = { --Guardbreaker Charm
			tools = { 41328, 41326 },
			item = 55364,
			reagents = {
				{ 3577,  32 },
				{ 7082,  8 },
				{ 12800, 8 },
				{ 8152,  8 },
				{ 55247, 6 },
			},
		},
		[41800] = { --Rudeus' Focusing Cane
			tools = { 41328, 41326 },
			item = 55365,
			reagents = {
				{ 12359, 28 },
				{ 55252, 2 },
				{ 12364, 12 },
				{ 7077,  8 },
				{ 61673, 8 },
				{ 18567 },
				{ 55248, 6 },
			},
		},
		[41802] = { --Spire of Channeled Power
			tools = { 41328, 41326 },
			item = 55366,
			reagents = {
				{ 12359, 18 },
				{ 12360, 2 },
				{ 12799, 10 },
				{ 61673, 6 },
				{ 55154, 6 },
				{ 55247, 2 },
			},
		},
		[41804] = { --Bindings of Luminance
			tools = { 41328, 41326 },
			item = 55367,
			reagents = {
				{ 3577,  26 },
				{ 55252 },
				{ 17011, 2 },
				{ 12799, 8 },
				{ 55248, 2 },
			},
		},
		[41806] = { --Crown of the Illustrious Queen
			tools = { 41328, 41326 },
			item = 55368,
			reagents = {
				{ 3577,  32 },
				{ 55252 },
				{ 12364, 6 },
				{ 12800, 8 },
				{ 3466,  6 },
				{ 55248, 4 },
			},
		},
		[41808] = { --Mastercrafted Diamond Bangles
			tools = { 41328, 41326 },
			item = 56096,
			reagents = {
				{ 12360, 6 },
				{ 6037,  6 },
				{ 12800, 8 },
				{ 61673, 4 },
				{ 55154, 6 },
				{ 55248, 4 },
			},
		},
		[41821] = { --Gorgeous Mountain Gemstone
			tools = { 41328, 41326 },
			item = 61818,
			reagents = {
				{ 11382 },
				{ 7077,  6 },
				{ 55248 },
				{ 55154, 2 },
			},
		},
		[42029] = { --Create True Band of Sulfuras
			item = 58088,
			reagents = {
				{ 19138 },
				{ 17203 },
			},
		},
		[45611] = {
			item = 65032,
			reagents = {
				{ 2931, 2 },
				{ 3372 },
			},
		},
		[45878] = { --Dissolvent Poison
			item = 54009,
			reagents = {
				{ 8924, 2 },
				{ 2931, 3 },
				{ 8925 },
			},
		},
		[45882] = { --Dissolvent Poison II
			item = 54010,
			reagents = {
				{ 8924, 3 },
				{ 2931, 4 },
				{ 8925 },
			},
		},
		[51924] = { --Corrosive Poison
			item = 47408,
			reagents = {
				{ 8924, 3 },
				{ 5173, 3 },
				{ 8925 },
			},
		},
		[52576] = { --Corrosive Poison II
			item = 47409,
			reagents = {
				{ 8924, 3 },
				{ 5173, 3 },
				{ 8925 },
			},
		},
		[45999] = { --Honeycomb Delight
			requires = L["Cooking Fire"],
			item = 42186,
			reagents = {
				{ 42293 },
				{ 42016 },
			},
		},
		[47101] = { --Survivalist's Skinning Knife
			item = 7009,
			reagents = {
				{ 2835, 2 },
				{ 2320 },
				{ 2318 },
			},
		},
		[47103] = { --Driftwood Fishing Pole
			tools = { 42004 },
			item = 7010,
			reagents = {
				{ 2320, 2 },
				{ 7011 },
				{ 4470, 2 },
			},
		},
		[47105] = { --Liferoot Healing Brew
			item = 7012,
			reagents = {
				{ 3357, 5 },
				{ 159 },
				{ 3818, 3 },
				{ 2318, 2 },
			},
		},
		[49551] = { --Empowering Herbal Salad
			item = 83309,
			reagents = {
				{ 36668 },
				{ 22529 },
				{ 42000, 2 },
			},
		},
		[52747] = { --Voltage-Neutralizing Nature Reflector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 58304,
			reagents = {
				{ 11371, 8 },
				{ 18631, 4 },
				{ 61673, 3 },
				{ 12364, 4 },
				{ 12800, 2 },
			},
		},
		[52749] = { --Giga-Charged Arcane Reflector
			requires = L["Anvil"],
			tools = { 5956, 6219 },
			item = 58305,
			reagents = {
				{ 11371, 8 },
				{ 18631, 4 },
				{ 7910,  4 },
				{ 12803, 6 },
				{ 12363, 2 },
				{ 7076,  4 },
			},
		},
		[57555] = { --Transmute: Elemental Earth
			tools = { 9149 },
			item = 7067,
			reagents = {
				{ 7075 },
			},
		},
		[57557] = { --Transmute: Elemental Water
			tools = { 9149 },
			item = 7070,
			reagents = {
				{ 7079 },
			},
		},
		[57601] = { --Cosmic Headdress
			item = 55518,
			reagents = {
				{ 14342, 2 },
				{ 61673, 5 },
				{ 14048, 6 },
				{ 14227, 3 },
			},
		},
		[57603] = { --Cosmic Mantle
			item = 55519,
			reagents = {
				{ 14342, 2 },
				{ 61673, 4 },
				{ 14048, 3 },
				{ 14227, 4 },
			},
		},
		[57605] = { --Cosmic Vest
			item = 55520,
			reagents = {
				{ 14342, 3 },
				{ 61673, 7 },
				{ 14048, 8 },
				{ 14227, 2 },
			},
		},
		[57607] = { --Cosmic Leggings
			item = 55521,
			reagents = {
				{ 14342, 3 },
				{ 61673, 7 },
				{ 14048, 6 },
				{ 14227, 2 },
			},
		},
		[57609] = { --Ethereal Helmet
			item = 55522,
			reagents = {
				{ 15407, 2 },
				{ 12810, 8 },
				{ 61673, 5 },
				{ 14227 },
			},
		},
		[57611] = { --Ethereal Shoulder Pads
			item = 55523,
			reagents = {
				{ 15407, 2 },
				{ 12810, 7 },
				{ 61673, 4 },
				{ 14227, 2 },
			},
		},
		[57613] = { --Ethereal Tunic
			item = 55524,
			reagents = {
				{ 15407, 4 },
				{ 12810, 12 },
				{ 61673, 8 },
				{ 14227 },
			},
		},
		[57615] = { --Ethereal Leggings
			item = 55525,
			reagents = {
				{ 15407, 3 },
				{ 12810, 13 },
				{ 61673, 6 },
				{ 14227, 2 },
			},
		},
		[57617] = { --Otherworldly Coif
			tools = { 5956 },
			item = 55526,
			reagents = {
				{ 15407 },
				{ 12360 },
				{ 61673, 6 },
				{ 12607 },
			},
		},
		[57619] = { --Otherworldly Spaulders
			tools = { 5956 },
			item = 55527,
			reagents = {
				{ 15407 },
				{ 12360 },
				{ 61673, 5 },
				{ 12607, 3 },
			},
		},
		[57621] = { --Otherworldly Breastplate
			tools = { 5956 },
			item = 55528,
			reagents = {
				{ 15407, 2 },
				{ 12360 },
				{ 61673, 6 },
				{ 12607, 2 },
			},
		},
		[57623] = { --Otherworldly Leggings
			tools = { 5956 },
			item = 55529,
			reagents = {
				{ 15407, 2 },
				{ 12360 },
				{ 61673, 7 },
				{ 12607, 2 },
			},
		},
		[57625] = { --Reflective Helmet
			tools = { 5956 },
			item = 55530,
			reagents = {
				{ 12360, 2 },
				{ 12655, 7 },
				{ 61673, 6 },
			},
		},
		[57627] = { --Reflective Pauldrons
			tools = { 5956 },
			item = 55531,
			reagents = {
				{ 12360, 2 },
				{ 12655, 9 },
				{ 61673, 7 },
			},
		},
		[57629] = { --Reflective Breastplate
			tools = { 5956 },
			item = 55532,
			reagents = {
				{ 12360, 2 },
				{ 12655, 10 },
				{ 61673, 5 },
			},
		},
		[57631] = { --Reflective Leggings
			tools = { 5956 },
			item = 55533,
			reagents = {
				{ 12360, 2 },
				{ 12655, 12 },
				{ 61673, 7 },
			},
		},
		[57633] = { --Ley-Kissed Drape
			item = 55534,
			reagents = {
				{ 14342, 2 },
				{ 61673, 4 },
				{ 14227, 4 },
				{ 14048, 6 },
				{ 13926 },
			},
		},
		[58044] = { --Ambersap Glazed Boar Ribs
			requires = L["Cooking Fire"],
			item = 41674,
			reagents = {
				{ 41675 },
				{ 2677 },
				{ 2692 },
			},
		},
		[58046] = { --Crawford Apple Tarte
			requires = L["Cooking Fire"],
			item = 41673,
			reagents = {
				{ 4539 },
				{ 41677 },
				{ 1179 },
			},
		},
	},
}
