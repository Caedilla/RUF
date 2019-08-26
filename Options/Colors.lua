local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')

function RUF_Options.Colors()
	local Reactions = {
		[1] = L['Hated'],
		[2] = L['Hostile'],
		[3] = L['Unfriendly'],
		[4] = L['Neutral'],
		[5] = L['Friendly'],
		[6] = L['Honored'],
		[7] = L['Revered'],
		[8] = L['Exalted'],
		--[9] = L['Paragon'],
		[10] = L['Friendly Pet'],
	}
	local Difficulties = {
		[0] = L['Very Hard'],
		[1] = L['Hard'],
		[2] = L['Normal'],
		[3] = L['Easy'],
		[4] = L['Trivial'],
	}
	local Powers = {}
	if RUF.Client == 1 then
		Powers = {
			[0] = _G['MANA'] or MANA,
			[1] = _G['RAGE'] or RAGE,
			[2] = _G['FOCUS'] or FOCUS,
			[3] = _G['ENERGY'] or ENERGY,
			[4] = _G['COMBO_POINTS'] or COMBO_POINTS,
			--[5] = _G['RUNES'] or RUNES,
			[6] = _G['RUNIC_POWER'] or RUNIC_POWER,
			[7] = _G['SOUL_SHARDS'] or SOUL_SHARDS,
			[8] = _G['LUNAR_POWER'] or LUNAR_POWER,
			[9] = _G['HOLY_POWER'] or HOLY_POWER,
			--[10] = 'Alternate Power',
			[11] = _G['MAELSTROM'] or MAELSTROM,
			[12] = _G['CHI'] or CHI,
			[13] = _G['INSANITY'] or INSANITY,
			--[14] = _G['UNUSED'] or UNUSED,
			--[15] = _G['UNUSED'] or UNUSED,
			[16] = _G['ARCANE_CHARGES'] or ARCANE_CHARGES,
			[17] = _G['FURY'] or FURY,
			[18] = _G['PAIN'] or PAIN,
			[50] = L['Runes - Blood'],
			[51] = L['Runes - Frost'],
			[52] = L['Runes - Unholy'],
			[75] = L['Stagger - Low'],
			[76] = L['Stagger - Medium'],
			[77] = L['Stagger - High'],
		}
	else
		Powers = {
			[0] = _G['MANA'] or MANA,
			[1] = _G['RAGE'] or RAGE,
			[2] = _G['FOCUS'] or FOCUS,
			[3] = _G['ENERGY'] or ENERGY,
			[4] = _G['COMBO_POINTS'] or COMBO_POINTS,
		}
	end
	local classData = {
		[0] = C_CreatureInfo.GetClassInfo(6), -- Death Knight
		[1] = C_CreatureInfo.GetClassInfo(12), -- Demon Hunter
		[2] = C_CreatureInfo.GetClassInfo(11), -- Druid
		[3] = C_CreatureInfo.GetClassInfo(3), -- Hunter
		[4] = C_CreatureInfo.GetClassInfo(8), -- Mage
		[5] = C_CreatureInfo.GetClassInfo(10), -- Monk
		[6] = C_CreatureInfo.GetClassInfo(2), -- Paladin
		[7] = C_CreatureInfo.GetClassInfo(5), -- Priest
		[8] = C_CreatureInfo.GetClassInfo(4), -- Rogue
		[9] = C_CreatureInfo.GetClassInfo(7), -- Shaman
		[10] = C_CreatureInfo.GetClassInfo(9), -- Warlock
		[11] = C_CreatureInfo.GetClassInfo(1), -- Warrior
	}
	local Colors = {
		name = L['Colors'],
		type = 'group',
		order = 0,
		args = {
			Class = {
				name = L['Class Colors'],
				type = 'header',
				order = 00,
			},
			ClassColors_UseAddon = {
				order = 0.01,
				type = 'toggle',
				name = L['Use colors from the Class Colors addon'],
				width = 'double',
				get = function(info)
					if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
						for classToken, color in next, CUSTOM_CLASS_COLORS do
							RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
						end
					end
					return RUF.db.profile.Appearance.Colors.UseClassColors
				end,
				set = function(info, value)
					RUF.db.profile.Appearance.Colors.UseClassColors = value
					if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
						for classToken, color in next, CUSTOM_CLASS_COLORS do
							RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
						end
					end
					RUF:OptionsUpdateAllBars()
				end,
			},
			UseBlizz_CC = {
				order = 0.011,
				type = 'execute',
				name = L['Set Blizard Default'],
				desc = L['Set class colors to the default Blizzard colors.'],
				width = 'double',
				func = function(info, value)
					RUF.db.profile.Appearance.Colors.UseClassColors = false
					for classToken, color in next, RAID_CLASS_COLORS  do
						RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}
					end
					RUF:OptionsUpdateAllBars()
				end,
			},
			Spacer_CC = {
				name = '',
				type = 'description',
				order = 0.012,
				width = 'full',
			},
			Misc = {
				name = L['Misc Colors'],
				type = 'header',
				order = 9,
			},
			Disconnected = {
				name = L['Disconnected'],
				type = 'color',
				order = 9.01,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Disconnected)
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.MiscColors.Disconnected = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			},
			Tapped = {
				name = L['Tapped'],
				type = 'color',
				order = 9.02,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.MiscColors.Tapped = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			},
			Power = {
				name = L['Power Colors'],
				type = 'header',
				order = 10,
			},
			Reaction = {
				name = L['Reaction Colors'],
				type = 'header',
				order = 20,
			},
			Difficulty = {
				name = L['Difficulty Colors'],
				type = 'header',
				order = 30,
			},
		},
	}
	for i=0,11 do
		if classData[i] then
			Colors.args[classData[i]['classFile']] = {
				name = classData[i]['className'],
				type = 'color',
				order = 0 + ((i)+2)/100,
				disabled = function()
					if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then
						return true
					end
				end, -- !ClassColors takes precedent.
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ClassColors[classData[i]['classFile']])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.ClassColors[classData[i]['classFile']] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	for i=0,#Powers do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = 'color',
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	for i=50,52 do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = 'color',
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	for i=75,77 do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = 'color',
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	for i=1,#Reactions do
		if Reactions[i] then
			Colors.args[Reactions[i]] = {
				name = Reactions[i],
				type = 'color',
				order = 20 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ReactionColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.ReactionColors[i] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	for i=0,#Difficulties do
		if Difficulties[i] then
			Colors.args[Difficulties[i]] = {
				name = Difficulties[i],
				type = 'color',
				order = 30 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.DifficultyColors[i] = {r,g,b}
					RUF:OptionsUpdateAllBars()
				end,
			}
		end
	end
	return Colors
end