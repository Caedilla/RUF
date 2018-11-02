local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
RUF.Layout = {}
local cfg = {
	global = {
		TestModeShowUnits = true,
	},
	char = {
		Nickname = "",
	},
	profile = {
		Appearance = {
			Border = {
				Debuff = {
					Enabled = true,
				},
				Style = {
					edgeFile = "RUF Pixel", -- Pixel Border settings. 
					edgeSize = 1,
				},
				Offset = 0,
				Color = {0,0,0},
				Alpha = 1,
			},
			Bars = {
				Health = {
					Texture = "RUF 5",
					Animate = true,
					Color = {
						BaseColor = {25/255, 25/255, 25/255},
						--colorHealth -- Set in Core to true automatically		
						Class = false,
						Disconnected = true,					
						Percentage = true,
						PercentageGradient = {
							1,0,55/255, -- 0% HP: Magenta
							35/255,35/255,35/255, -- 50% HP: Grey
							35/255,35/255,35/255 -- 100% HP: Grey
						},
						Reaction = false,
						Tapped = true,
					},
					Background = {
						UseBarColor = false, -- Use Bar Color or Custom Color
						CustomColor = {0,0,0}, -- Custom Color Value
						Multiplier = 0.25, -- Reduce Bar Background Color brightness by this multiplier
						Alpha = 0.5,
					},
				},
				Absorb = { 
					Type = 1, -- 1 Health Overlay = 0, 2 Bar  If 1 then use Frame.Bars.Absorb.Alpha      If 2 then use Unit.Player.Bars.Absorb.Position and Order and Alpha
					Texture = "RUF 5",
					Animate = true,
					Color = {
						BaseColor = {1, 1, 0},
						Class = true,
						Reaction = true,
						Alpha = 0.25,
						Multiplier = 1,
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings. 
							edgeSize = 1,
						},
						Color = {0,0,0},
						Alpha = 1,
					},
					Background = {
						UseBarColor = false,
						CustomColor = {0,0,0},
						Multiplier = 0.25,
						Alpha = 0.5,
					},
				},
				Class = {
					Texture = "RUF 1",
					Animate = true,
					Color = {
						BaseColor = {100/255, 100/255, 100/255},
						Class = false,
						PowerType = true, -- Use Resource's Color					
						Multiplier = 10, -- Make the bars increase in brightness by this multiplier
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings. 
							edgeSize = 1,
						},
						Color = {0,0,0},
						Alpha = 1,
					},
					Background = {
						UseBarColor = true,
						CustomColor = {0,0,0},
						Multiplier = 0.25,
						Alpha = 0.5,
					},
				},
				Power = {
					Texture = "RUF 1",
					Animate = true,
					Color = {					
						BaseColor = {50/255, 50/255, 50/255},
						Class = false,
						Disconnected = false,
						Percentage = false,					
						PercentageGradient = {
							1,1,1,
							25/255,25/255,25/255,
							25/255,25/255,25/255
						},
						Reaction = false,
						Tapped = false,
						PowerType = true,
					},
					Border = {
						Style = {
							edgeFile = "RUF Pixel", -- Pixel Border settings. 
							edgeSize = 1,
						},
						Color = {0,0,0},
						Alpha = 1,
					},
					Background = {
						UseBarColor = true,
						CustomColor = {0,0,0},
						Multiplier = 0.25,
						Alpha = 0.5,
					},
				},
			},
			Aura = {
				Buff = true,
				Debuff = true,
				OnlyDispellable = true,
				Border = {
					Style = {
						edgeFile = "RUF Glow", -- Pixel Border settings. 
						edgeSize = 6,
					},
					Offset = -1,
				},
				Pixel = {
					Enabled = true,
					Style = {
						edgeFile = "RUF Pixel", -- Pixel Border settings. 
						edgeSize = 1,
					},
					Offset = 0,
				},
			},
			Colors = { 
				UseClassColors = true, -- Use ClassColors Addon
				ClassColors = { -- !ClassColors Addon Overrides these values.
					DEATHKNIGHT = {196/255,31/255,59/255},
					DEMONHUNTER = {163/255,48/255,201/255},
					DRUID = {1,125/255,10/255},
					HUNTER = {171/255,212/255,115/255},
					MAGE = {64/255,199/255,235/255},
					MONK = {0,1,150/255},
					PALADIN = {245/255,140/255,186/255},
					PRIEST = {1,1,1},
					ROGUE = {1,245/255,105/255},
					SHAMAN = {0,112/255,222/255},
					WARLOCK = {135/255,135/255,237/255},
					WARRIOR = {199/255,156/255,110/255},
				},
				MiscColors = {
					Tapped = {100/255,100/255,100/255},
					Disconnected = {1,1,1},
				},
				Aura = {
					DefaultBuff = {0,0,0,0},
					DefaultDebuff = {180/255,0,20/255,1},
					Pixel = {0,0,0,1},
					Magic = {0,158/255,1,1},
					Disease = {1,156/255,0,1},
					Curse = {84/255,43/255,189/255,1},
					Poison = {145/255,190/255,15/255,1},
					Enrage = {1,0,143/255,1},
				},
				DifficultyColors = {
					[0] = {1,0.1,0.1}, -- Impossible
					[1] = {1,0.5,0.25}, -- Hard
					[2] = {1,0.82,0}, -- Normal
					[3] = {0.25,0.75,0.25}, -- Easy
					[4] = {0.5,0.5,0.5}, -- Trivial
				},
				PowerColors = {
					[0] = {0,158/255,1}, -- Mana
					[1] = {1,0,55/255}, -- Rage
					[2] = {1,128/255,64/255}, -- Focus
					[3] = {1,1,0}, -- Energy
					[4] = {1,245/255,105/255}, -- Combo Points
					[5] = {128/255,128/255,128/255}, -- Runes
					[6] = {0,211/255,1}, -- Runic Power
					[7] = {150/255,119/255,229/255}, -- Soul Shards
					[8] = {77/255,133/255,230/255}, -- Astral Power
					[9] = {242/255,230/255,153/255}, -- Holy Power
					[10] = {0,158/255,1}, -- Alternate Power
					[11] = {0,128/255,1}, -- Maelstrom
					[12] = {0,247/255,202/255}, -- Chi
					[13] = {102/255,0,204/255}, -- Insanity
					[14] = {0,158/255,1}, -- Unused
					[15] = {0,158/255,1}, -- Unused
					[16] = {0,178/255,250/255}, -- Arcane Charges
					[17] = {200/255,66/255,252/255}, -- Fury
					[18] = {1,156/255,0}, -- Pain
					[50] = {180/255,0,20/255}, -- Blood Runes
					[51] = {60/255,205/255,1}, -- Frost Runes
					[52] = {145/255,190/255,15/255}, -- Unholy Runes
					[75] = {132/255,1,132/255}, -- Stagger Low (Green)
					[76] = {1, 250/255, 184/255}, -- Stagger Medium (Yellow)
					[77] = {1, 107/255, 107/255}, -- Stagger High (Red)
				},
				ReactionColors = {
					[1] = {230/255,77/255,56/255}, -- Hated
					[2] = {230/255,77/255,56/255}, -- Hostile Also Enemy Players and NPCs
					[3] = {191/255,69/255,0}, -- Unfriendly
					[4] = {230/255,179/255,0}, -- Neutral
					[5] = {0,153/255,26/255}, -- Friendly Also Allied Players
					[6] = {0,153/255,26/255}, -- Honored
					[7] = {0,153/255,26/255}, -- Revered
					[8] = {0,153/255,26/255}, -- Exalted
					[9] = {56/255,77/255,230/255}, -- Paragon
					[10] = {56/255,77/255,230/255}, -- Friendly Pet
				},
			},
			Text = { 				
				CurHPPerc = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = false,	
					},
				},
				CurHP = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = false,	
					},
				},
				HPPerc = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = true, -- Below 100%
						PercentageAtMax = true,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = false,	
					},
				},
				CurManaPerc = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true,
						Reaction = false,					
					},
				},
				CurMana = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true,
						Reaction = false,					
					},
				},
				ManaPerc = {
					Enabled = 1,
					HideWhenPrimaryIsMana = true,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true,
						Reaction = false,					
					},
				},				
				Name = {
					CharLimit = 18,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = true,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = true,					
					},
				},				
				CurPowerPerc = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true,
						Reaction = false,					
					},
				},
				CurPower = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true,
						Reaction = false,					
					},
				},
				PowerPerc = {
					Enabled = 1,
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = true, -- Always Mana if tag is Raeli:Mana
						Reaction = false,					
					},
				},
				Level = {
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					HideSameLevel = false,
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = true,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = false,					
					},
				},
				AFKDND = {
					Case = 1, -- 0,1,2 0 == Default, 1 == Uppercase, 2 == Lowercase
					Color = {
						BaseColor = {1,1,1},
						Class = false,
						Level = false,
						Percentage = false, -- Below 100%
						PercentageAtMax = false,
						PercentageGradient = {
							1,0,0,
							1,1,0,
							0,1,0,
						},
						PowerType = false,
						Reaction = false,					
					},
				},
			},
		},
		Filters = {
			Selected = "Blacklist",
			Lists = {
				["Blacklist"] = {
					227723,
				},
				["WhiteList"] = {
					253331,
				},
			},
		},
		unit =  {
		},
	},
}

local function LargeLeftUnits()
	local UnitOptions = {
		Enabled = true,
		Frame = {
			RangeFading = {
				Enabled = true,
				Alpha = 0.5,
			},
			Size = {
				Height = 60,
				Width = 300,
			},
			Bars = {
				Health = { -- Doesn't need options. Health Height is Height -2, Position is filling the frame aside from Power bars for the Health BG.
					Fill = "STANDARD",
				},
				Absorb = {
					Enabled = 1,
					Fill = "STANDARD", -- Use Health Fill if Enabled == 1
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 1, -- If 2 bars are at bottom, then order determines which comes first (closest to anchor)
					}, 
				},
				Class = { -- Class or Mana on Additional Mana units.
					Enabled = true,
					Fill = "STANDARD", 
					Height = 8,
					Position = {
						Anchor = "TOP",
					},
				},
				Power = { -- Primary Power or Class on Additional Mana units.
					Enabled = 1, -- 0 Hidden, 1 Show above 0, 2 Always Show
					Fill = "STANDARD",
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 0,
					},
				},
			},
			Text = {
				Health = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurHPPerc]",
					Enabled = true, -- Boolean
					Size = 28,
					Width = 150,
					Position = {
						x = -4,
						y = 4,
						AnchorFrame = "Frame",
						Anchor = "RIGHT",
					},
				},
				Level = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Level]",
					Enabled = true, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 4,
						y = 3,
						AnchorFrame = "Frame",
						Anchor = "BOTTOMLEFT",
					},
				},
				Power = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurPowerPerc]",
					Enabled = true, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = -4,
						y = 3,
						AnchorFrame = "Frame",
						Anchor = "BOTTOMRIGHT",
					},
				},
				Name = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Name]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = 4,
						y = 4,
						AnchorFrame = "Frame",
						Anchor = "LEFT",
					},
				},
				AFKDND = {
					Outline = "OUTLINE",
					Shadow = 0,
					Font = "RUF",
					Position = {
						y = 1,
						x = -2,
						Anchor = "RIGHT",
						AnchorFrame = "Name",
						
					},
					Width = 100,
					Size = 21,
					Enabled = true,
					Tag = "[RUF:AFKDND]",
				},
			},
			Indicators = {
				Assist = {
					Enabled = true,
					Style = "RUF",
					Size = 14,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Honor = {
					Badge = false,
					AlwaysShow = false,
					Enabled = false,
					Size = 32,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				InCombat = {
					Enabled = true,
					Style = "RUF",
					Size = 20,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Lead = {
					Enabled = true,
					Style = "RUF",
					Size = 14,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPRIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				MainTankAssist = {
					Enabled = true,
					Style = "RUF",
					Size = 12,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				Phased = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				PvPCombat = {
					Enabled = true,
					Style = "RUF",
					Size = 28,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				Objective = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				Ready = {
					Enabled = true,
					Style = "RUF",
					Size = 36,
					Position = {
						x = 10,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
				Rest = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPRIGHT",
						AnchorFrom = "BOTTOMLEFT",								
					},
				},
				Role = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "InCombat", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				TargetMark = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "InCombat", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
			},
		},
		Buffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 28,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPRIGHT",
					AnchorFrom = "TOPLEFT",
					x = 1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = 1,
				},
			},
		},
		Debuffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 28,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "DOWN",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "BOTTOMRIGHT",
					AnchorFrom = "BOTTOMLEFT",
					x = 1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = -1,
				},
			},
		},		
	}
	return UnitOptions
end

local function MediumLeftUnits()
	local UnitOptions = {
		Enabled = true,
		Frame = {
			RangeFading = {
				Enabled = true,
				Alpha = 0.5,
			},
			Size = {
				Height = 30,
				Width = 300,
			},
			Bars = {
				Health = { -- Doesn't need options. Health Height is Height -2, Position is filling the frame aside from Power bars for the Health BG.
					Fill = "STANDARD",
				},
				Absorb = {
					Enabled = 1,
					Fill = "STANDARD", -- Use Health Fill if Enabled == 1
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 1, -- If 2 bars are at bottom, then order determines which comes first (closest to anchor)
					}, 
				},
				Class = { -- Class or Mana on Additional Mana units.
					Enabled = false,
					Fill = "STANDARD", 
					Height = 4,
					Position = {
						Anchor = "TOP",
					},
				},
				Power = { -- Primary Power or Class on Additional Mana units.
					Enabled = 1, -- 0 Hidden, 1 Show above 0, 2 Always Show
					Fill = "STANDARD",
					Height = 4,
					Position = {
						Anchor = "BOTTOM",
						Order = 0,
					},
				},
			},
			Text = {
				Health = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurHPPerc]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 150,
					Position = {
						x = -4,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "RIGHT",
					},
				},
				Level = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Level]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Power = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurPowerPerc]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Name = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Name]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = 4,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "LEFT",
					},
				},
			},
			Indicators = {
				Assist = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Honor = {
					Badge = false,
					AlwaysShow = false,
					Enabled = false,
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "PvPCombat", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Lead = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPRIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				MainTankAssist = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				Phased = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				PvPCombat = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "BOTTOMRIGHT",
						AnchorFrom = "BOTTOM",								
					},
				},
				Objective = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "BOTTOMRIGHT",
						AnchorFrom = "BOTTOM",								
					},
				},
				Ready = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = -50,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Role = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = 50,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				TargetMark = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
			},
		},
		Buffs = {
			Bars = {
			},
			Icons =  {
				Enabled = false,
				Size = 30,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPRIGHT",
					AnchorFrom = "TOPLEFT",
					x = 1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = -1,
					y = 1,
				},
			},
		},
		Debuffs = {
			Bars = {
			},
			Icons =  {
				Enabled = false,
				Size = 30,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "DOWN",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "BOTTOMRIGHT",
					AnchorFrom = "BOTTOMLEFT",
					x = 1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = -1,
				},
			},
		},
	}
	return UnitOptions
end

local function LargeRightUnits()
	local UnitOptions = {
		Enabled = true,
		Frame = {
			RangeFading = {
				Enabled = true,
				Alpha = 0.5,
			},
			Size = {
				Height = 60,
				Width = 300,
			},
			Bars = {
				Health = { -- Doesn't need options. Health Height is Height -2, Position is filling the frame aside from Power bars for the Health BG.
					Fill = "REVERSE",
				},
				Absorb = {
					Enabled = 1,
					Fill = "REVERSE", -- Use Health Fill if Enabled == 1
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 1, -- If 2 bars are at bottom, then order determines which comes first (closest to anchor)
					}, 
				},
				Class = { -- Class or Mana on Additional Mana units.
					Enabled = true,
					Fill = "REVERSE", 
					Height = 8,
					Position = {
						Anchor = "TOP",
					},
				},
				Power = { -- Primary Power or Class on Additional Mana units.
					Enabled = 1, -- 0 Hidden, 1 Show above 0, 2 Always Show
					Fill = "REVERSE",
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 0,
					},
				},
			},
			Text = {
				Health = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurHPPerc]",
					Enabled = true, -- Boolean
					Size = 28,
					Width = 150,
					Position = {
						x = 4,
						y = 4,
						AnchorFrame = "Frame",
						Anchor = "LEFT",
					},
				},
				Level = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Level]",
					Enabled = true, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = -4,
						y = 3,
						AnchorFrame = "Frame",
						Anchor = "BOTTOMRIGHT",
					},
				},
				Power = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurPowerPerc]",
					Enabled = true, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 4,
						y = 3,
						AnchorFrame = "Frame",
						Anchor = "BOTTOMLEFT",
					},
				},
				Name = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Name]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = -4,
						y = 4,
						AnchorFrame = "Frame",
						Anchor = "RIGHT",
					},
				},
				AFKDND = {
					Outline = "OUTLINE",
					Shadow = 0,
					Font = "RUF",
					Position = {
						y = 1,
						x = 2,
						Anchor = "LEFT",
						AnchorFrame = "Name",
					},
					Width = 100,
					Size = 21,
					Enabled = true,
					Tag = "[RUF:AFKDND]",
				},				
			},
			Indicators = {
				Assist = {
					Enabled = true,
					Style = "RUF",
					Size = 14,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Honor = {
					Badge = false,
					AlwaysShow = false,
					Enabled = false,
					Size = 32,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "CENTER",								
					},
				},
				Lead = {
					Enabled = true,
					Style = "RUF",
					Size = 14,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPLEFT",
						AnchorFrom = "CENTER",								
					},
				},
				MainTankAssist = {
					Enabled = true,
					Style = "RUF",
					Size = 12,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
				Phased = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				PvPCombat = {
					Enabled = true,
					Style = "RUF",
					Size = 28,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "CENTER",								
					},
				},
				Objective = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "CENTER",								
					},
				},
				Ready = {
					Enabled = true,
					Style = "RUF",
					Size = 36,
					Position = {
						x = -10,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				Rest = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Role = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Phased", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				TargetMark = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Phased", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
			},
		},
		Buffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 28,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "LEFT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPLEFT",
					AnchorFrom = "TOPRIGHT",
					x = -1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = 1,
				},
			},
		},
		Debuffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 28,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "LEFT",
					y = "DOWN",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "BOTTOMLEFT",
					AnchorFrom = "BOTTOMRIGHT",
					x = -1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = -1,
				},
			},
		},
	}
	return UnitOptions
end

local function MediumRightUnits()
	local UnitOptions = {
		Enabled = true,
		Frame = {
			RangeFading = {
				Enabled = true,
				Alpha = 0.5,
			},
			Size = {
				Height = 30,
				Width = 300,
			},
			Bars = {
				Health = { -- Doesn't need options. Health Height is Height -2, Position is filling the frame aside from Power bars for the Health BG.
					Fill = "REVERSE",
				},
				Absorb = {
					Enabled = 1,
					Fill = "REVERSE", -- Use Health Fill if Enabled == 1
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 1, -- If 2 bars are at bottom, then order determines which comes first (closest to anchor)
					}, 
				},
				Class = { -- Class or Mana on Additional Mana units.
					Enabled = false,
					Fill = "REVERSE", 
					Height = 4,
					Position = {
						Anchor = "TOP",
					},
				},
				Power = { -- Primary Power or Class on Additional Mana units.
					Enabled = 1, -- 0 Hidden, 1 Show above 0, 2 Always Show
					Fill = "REVERSE",
					Height = 4,
					Position = {
						Anchor = "BOTTOM",
						Order = 0,
					},
				},
			},
			Text = {
				Health = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurHPPerc]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 150,
					Position = {
						x = 4,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "LEFT",
					},
				},
				Level = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Level]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Power = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurPowerPerc]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Name = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Name]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = -4,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "RIGHT",
					},
				},					
			},
			Indicators = {
				Assist = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Honor = {
					Badge = false,
					AlwaysShow = false,
					Enabled = false,
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "PvPCombat", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Lead = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPLEFT",
						AnchorFrom = "CENTER",								
					},
				},
				MainTankAssist = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
				Phased = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				PvPCombat = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "BOTTOMLEFT",
						AnchorFrom = "BOTTOM",								
					},
				},
				Objective = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "BOTTOMLEFT",
						AnchorFrom = "BOTTOM",								
					},
				},
				Ready = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 50,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Role = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = -50,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				TargetMark = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
			},
		},
		Buffs = {
			Bars = {
			},
			Icons =  {
				Enabled = false,
				Size = 30,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "LEFT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPLEFT",
					AnchorFrom = "TOPRIGHT",
					x = -1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = 1,
				},
			},
		},
		Debuffs = {
			Bars = {
			},
			Icons =  {
				Enabled = false,
				Size = 30,
				Rows = 1,
				Columns = 5,
				Max = 5,
				ClickThrough = false,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = false,
					},
				},
				Growth = {
					x = "LEFT",
					y = "DOWN",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "BOTTOMLEFT",
					AnchorFrom = "BOTTOMRIGHT",
					x = -1, -- Offset.
					y = 0,
				},
				Spacing = {
					x = 1,
					y = -1,
				},
			},
		},
	}
	return UnitOptions
end

local function SmallUnits()
	local UnitOptions = {
		Enabled = true,
		Frame = {
			RangeFading = {
				Enabled = true,
				Alpha = 0.5,
			},
			Size = {
				Height = 30,
				Width = 125,
			},
			Bars = {
				Health = { -- Doesn't need options. Health Height is Height -2, Position is filling the frame aside from Power bars for the Health BG.
					Fill = "STANDARD",
				},
				Absorb = {
					Enabled = 1,
					Fill = "STANDARD", -- Use Health Fill if Enabled == 1
					Height = 8,
					Position = {
						Anchor = "BOTTOM",
						Order = 1, -- If 2 bars are at bottom, then order determines which comes first (closest to anchor)
					}, 
				},
				Class = { -- Class or Mana on Additional Mana units.
					Enabled = false,
					Fill = "STANDARD", 
					Height = 8,
					Position = {
						Anchor = "TOP",
					},
				},
				Power = { -- Primary Power or Class on Additional Mana units.
					Enabled = 1, -- 0 Hidden, 1 Show above 0, 2 Always Show
					Fill = "STANDARD",
					Height = 4,
					Position = {
						Anchor = "BOTTOM",
						Order = 0,
					},
				},
			},
			Text = {
				Health = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurHPPerc]",
					Enabled = false, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = 0,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Level = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Level]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Power = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:CurPowerPerc]",
					Enabled = false, -- Boolean
					Size = 18,
					Width = 100,
					Position = {
						x = 0,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},
				Name = {
					Font = "RUF",
					Outline = "OUTLINE",
					Shadow = 0,
					Tag = "[RUF:Name]",
					Enabled = true, -- Boolean
					Size = 21,
					Width = 100,
					Position = {
						x = 0,
						y = 1,
						AnchorFrame = "Frame",
						Anchor = "CENTER",
					},
				},					
			},
			Indicators = {
				Assist = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				Honor = {
					Badge = false,
					AlwaysShow = false,
					Enabled = false,
					Size = 18,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "PvPCombat", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPRIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				Lead = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "TOPRIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				MainTankAssist = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Lead", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				Phased = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = -2,
						y = -1,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "RIGHT",								
					},
				},
				PvPCombat = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "CENTER",								
					},
				},
				Objective = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "TargetMark", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "RIGHT",
						AnchorFrom = "LEFT",								
					},
				},
				Ready = {
					Enabled = false,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 0,
						y = 0,
						AnchorFrame = "Phased", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "RIGHT",								
					},
				},
				Role = {
					Enabled = false,
					Style = "RUF",
					Size = 18,
					Position = {
						x = 0,
						y = -2,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "CENTER",
						AnchorFrom = "CENTER",								
					},
				},
				TargetMark = {
					Enabled = true,
					Style = "RUF",
					Size = 26,
					Position = {
						x = 2,
						y = -1,
						AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
						AnchorTo = "LEFT",
						AnchorFrom = "LEFT",								
					},
				},
			},
		},
		Buffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 32,
				Rows = 2,
				Columns = 5,
				Max = 12,
				ClickThrough = true,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = true,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPLEFT",
					AnchorFrom = "BOTTOMLEFT",
					x = 0, -- Offset.
					y = 0,
				},
				Spacing = {
					x = -1,
					y = 2,
				},
			},
		},
		Debuffs = {
			Bars = {
			},
			Icons =  {
				Enabled = true,
				Size = 32,
				Rows = 2,
				Columns = 5,
				Max = 12,
				ClickThrough = true,
				CooldownSpiral = true,
				Sort = {
					SortBy = "Remaining", -- Duration, Time Remaining, Player, Alphabetically, Index
					Direction = "Descending",
				},
				Filter = {
					Time = {
						Unlimited = false,
						Min = 0,
						Max = 0,
					},
					BlackOrWhite = "Black", -- Use Lists as Blacklist, Whitelist or None. Values "Black", "White", "None"
					Dispellable = false,
					Lists = {
					},
					Caster = {
						Player = true,
						Unit = true,
						Group = false,
						Other = true,
					},
				},
				Growth = {
					x = "RIGHT",
					y = "UP",
				},
				Position = {
					AnchorFrame = "Frame",
					AnchorTo = "TOPRIGHT",
					AnchorFrom = "BOTTOMRIGHT",
					x = 0, -- Offset.
					y = 0,
				},
				Spacing = {
					x = -1,
					y = 2,
				},
			},
		},
	}
	return UnitOptions
end

do
	cfg.profile.unit.player = LargeLeftUnits()
	cfg.profile.unit.focus = LargeLeftUnits()	
	cfg.profile.unit.party = LargeLeftUnits()
	
	cfg.profile.unit.pet = MediumLeftUnits()
	cfg.profile.unit.focustarget = MediumLeftUnits()

	cfg.profile.unit.target = LargeRightUnits()
	cfg.profile.unit.boss = LargeRightUnits()
	cfg.profile.unit.arena = LargeRightUnits()

	cfg.profile.unit.targettarget = MediumRightUnits()

	cfg.profile.unit.pettarget = SmallUnits()
	cfg.profile.unit.partytarget = SmallUnits()	
	cfg.profile.unit.bosstarget = SmallUnits()
	cfg.profile.unit.arenatarget = SmallUnits()

	cfg.profile.unit.player.Frame.Position = {
		x = -390,
		y = -200,
		AnchorFrame = "UIParent", -- UIParent
		AnchorTo = "CENTER", -- The area we anchor to on the UIParent
		AnchorFrom = "CENTER", -- The area on the unitframe we anchor from
	}

	cfg.profile.unit.player.Frame.Text.Mana = {
		Font = "RUF",
		Outline = "OUTLINE",
		Shadow = 0,
		Tag = "[RUF:CurMana]",
		Enabled = true, -- Boolean
		Size = 18,
		Width = 100,
		Position = {
			x = 0,
			y = 0,
			AnchorFrame = "Power",
			Anchor = "LEFT",
		},
	}


	
	cfg.profile.unit.player.Buffs.Icons.Max = 15
	cfg.profile.unit.player.Debuffs.Icons.Max = 15
	cfg.profile.unit.player.Buffs.Icons.Filter.Caster.Other = true
	cfg.profile.unit.player.Debuffs.Icons.Filter.Caster.Other = true
	cfg.profile.unit.player.Debuffs.Icons.Filter.Caster.Group = true
	cfg.profile.unit.player.Debuffs.Icons.Filter.Time.Unlimited = true
	cfg.profile.unit.player.Buffs.Icons.Growth = {
		x = "RIGHT",
		y = "UP",
	}
	cfg.profile.unit.player.Debuffs.Icons.Growth = {
		x = "LEFT",
		y = "UP",
	}
	cfg.profile.unit.player.Buffs.Icons.Position = {
		AnchorFrame = "Frame",
		AnchorTo = "TOPLEFT",
		AnchorFrom = "BOTTOMLEFT",
		x = 0, -- Offset.
		y = 1,
	}
	cfg.profile.unit.player.Debuffs.Icons.Position = {
		AnchorFrame = "Frame",
		AnchorTo = "TOPRIGHT",
		AnchorFrom = "BOTTOMRIGHT",
		x = 0, -- Offset.
		y = 1,
	}

	cfg.profile.unit.target.Debuffs.Icons.Filter.Time.Unlimited = true
	cfg.profile.unit.target.Buffs.Icons.Max = 15
	cfg.profile.unit.target.Debuffs.Icons.Max = 15
	cfg.profile.unit.target.Buffs.Icons.Growth = {
		x = "LEFT",
		y = "UP",
	}
	cfg.profile.unit.target.Debuffs.Icons.Growth = {
		x = "RIGHT",
		y = "UP",
	}
	cfg.profile.unit.target.Buffs.Icons.Position = {
		AnchorFrame = "Frame",
		AnchorTo = "TOPRIGHT",
		AnchorFrom = "BOTTOMRIGHT",
		x = 0, -- Offset.
		y = 1,
	}
	cfg.profile.unit.target.Debuffs.Icons.Position = {
		AnchorFrame = "Frame",
		AnchorTo = "TOPLEFT",
		AnchorFrom = "BOTTOMLEFT",
		x = 0, -- Offset.
		y = 1,
	}




	cfg.profile.unit.player.Frame.Indicators.Honor = {
		Badge = true,
		AlwaysShow = false,
		Enabled = true,
		Size = 32,
		Position = {
			x = 0,
			y = 0,
			AnchorFrame = "Frame", -- Icon to Anchor to, if none, anchor to frame
			AnchorTo = "LEFT",
			AnchorFrom = "CENTER",								
		},		
	}

	cfg.profile.unit.focus.Frame.Position = {
		x = 4,
		y = 160,
		AnchorFrame = 'UIParent',
		AnchorTo = 'LEFT',
		AnchorFrom = 'LEFT',	
	}

	cfg.profile.unit.boss.Frame.Position = {
		x = -4,
		y = -40,
		offsetx = 0,
		offsety = -4,
		growth = "BOTTOM",
		AnchorFrame = 'UIParent',
		AnchorTo = "RIGHT",
		AnchorFrom = 'TOPRIGHT',
	}

	cfg.profile.unit.arena.Frame.Position = {
		x = -4,
		y = 40,
		offsetx = 0,
		offsety = 4,
		growth = "TOP",
		AnchorFrame = 'UIParent',
		AnchorTo = "RIGHT",
		AnchorFrom = 'BOTTOMRIGHT',
	}

	cfg.profile.unit.pet.Frame.Position = {
		x = 0,
		y = -4,
		AnchorFrame = 'oUF_RUF_Player',
		AnchorTo = "BOTTOM",
		AnchorFrom = 'TOP',
	}
	
	cfg.profile.unit.party.Frame.Position = {
		x = 4,
		y = -40,
		offsetx = 0,
		offsety = -4,
		growth = "BOTTOM",
		AnchorFrame = 'UIParent',
		AnchorTo = "LEFT",
		AnchorFrom = 'TOPLEFT',
	}

	cfg.profile.unit.pettarget.Enabled = false
	cfg.profile.unit.pettarget.Frame.Position = {
		x = 4,
		y = 0,
		AnchorFrame = 'oUF_RUF_Pet',
		AnchorTo = "BOTTOMRIGHT",
		AnchorFrom = 'BOTTOMLEFT',
	}
	
	cfg.profile.unit.focustarget.Frame.Position = {
		x = 0,
		y = 4,
		AnchorFrame = 'oUF_RUF_Focus',
		AnchorTo = "TOPLEFT",
		AnchorFrom = 'BOTTOMLEFT',
	}

	cfg.profile.unit.bosstarget.Frame.Position = {
		x = 4,
		y = 0,
		AnchorFrame = 'oUF_RUF_Boss1',
		AnchorTo = "BOTTOMRIGHT",
		AnchorFrom = 'BOTTOMLEFT',
	}
	
	cfg.profile.unit.arenatarget.Frame.Position = {
		x = 4,
		y = 0,
		AnchorFrame = 'oUF_RUF_Arena1',
		AnchorTo = "BOTTOMRIGHT",
		AnchorFrom = 'BOTTOMLEFT',
	}
	
	cfg.profile.unit.partytarget.Frame.Position = {
		x = 4,
		y = 0,
		AnchorFrame = 'oUF_RUF_Party',
		AnchorTo = "BOTTOMRIGHT",
		AnchorFrom = 'BOTTOMLEFT',
	}

	cfg.profile.unit.target.Frame.Position = {
		x = 390,
		y = -200,
		AnchorFrame = 'UIParent',
		AnchorTo = "CENTER",
		AnchorFrom = 'CENTER',
	}

	cfg.profile.unit.targettarget.Frame.Position = {
		x = 0,
		y = -4,
		AnchorFrame = 'oUF_RUF_Target',
		AnchorTo = "BOTTOM",
		AnchorFrom = 'TOP',
	}
end

RUF.Layout.cfg = cfg


local Alidie = {
	["Appearance"] = {
		["Text"] = {
			["HPPerc"] = {
				["Color"] = {
					["PercentageAtMax"] = false,
					["PercentageGradient"] = {
						[3] = 0.215686274509804,
						[6] = 1,
						[7] = 1,
						[9] = 1,
					},
				},
			},
			["Name"] = {
				["Color"] = {
					["Level"] = true,
				},
				["Case"] = 0,
				["CharLimit"] = 12,
			},
			["CurHPPerc"] = {
				["Color"] = {
					["PercentageAtMax"] = false,
					["PercentageGradient"] = {
						[3] = 0.215686274509804,
						[6] = 1,
						[7] = 1,
						[9] = 1,
					},
				},
			},
			["CurHP"] = {
				["Color"] = {
					["PercentageAtMax"] = false,
					["PercentageGradient"] = {
						[3] = 0.215686274509804,
						[6] = 1,
						[7] = 1,
						[9] = 1,
					},
				},
			},
		},
		["Colors"] = {
			["PowerColors"] = {
				[13] = {
					0.462745098039216, -- [1]
					0.105882352941176, -- [2]
					0.823529411764706, -- [3]
				},
			},
			["ReactionColors"] = {
				nil, -- [1]
				nil, -- [2]
				{
					0.815686274509804, -- [1]
					0.509803921568627, -- [2]
					0.305882352941177, -- [3]
				}, -- [3]
				{
					0.854901960784314, -- [1]
					0.772549019607843, -- [2]
					0.36078431372549, -- [3]
				}, -- [4]
				{
					0.196078431372549, -- [1]
					0.662745098039216, -- [2]
					0.250980392156863, -- [3]
				}, -- [5]
				{
					0.196078431372549, -- [1]
					0.662745098039216, -- [2]
					0.250980392156863, -- [3]
				}, -- [6]
				{
					0.196078431372549, -- [1]
					0.662745098039216, -- [2]
					0.250980392156863, -- [3]
				}, -- [7]
				{
					0.196078431372549, -- [1]
					0.662745098039216, -- [2]
					0.250980392156863, -- [3]
				}, -- [8]
				nil, -- [9]
				{
					0.188235294117647, -- [1]
					0.443137254901961, -- [2]
					0.749019607843137, -- [3]
				}, -- [10]
			},
			["ClassColors"] = {
				["DEATHKNIGHT"] = {
					0.77, -- [1]
					0.12, -- [2]
					0.23, -- [3]
				},
				["WARRIOR"] = {
					0.78, -- [1]
					0.61, -- [2]
					0.43, -- [3]
				},
				["SHAMAN"] = {
					nil, -- [1]
					0.44, -- [2]
					0.87, -- [3]
				},
				["MAGE"] = {
					0.25, -- [1]
					0.78, -- [2]
					0.92, -- [3]
				},
				["HUNTER"] = {
					0.67, -- [1]
					0.83, -- [2]
					0.45, -- [3]
				},
				["WARLOCK"] = {
					0.53, -- [1]
					0.53, -- [2]
					0.93, -- [3]
				},
				["DEMONHUNTER"] = {
					0.64, -- [1]
					0.19, -- [2]
					0.79, -- [3]
				},
				["ROGUE"] = {
					nil, -- [1]
					0.96, -- [2]
					0.41, -- [3]
				},
				["DRUID"] = {
					nil, -- [1]
					0.49, -- [2]
					0.04, -- [3]
				},
				["MONK"] = {
					nil, -- [1]
					nil, -- [2]
					0.59, -- [3]
				},
				["PALADIN"] = {
					0.96, -- [1]
					0.55, -- [2]
					0.73, -- [3]
				},
			},
			["UseClassColors"] = false,
		},
		["Bars"] = {
			["Absorb"] = {
				["Color"] = {
					["Reaction"] = false,
					["Multiplier"] = 0.5,
					["Class"] = false,
					["Alpha"] = 0.5,
					["BaseColor"] = {
						nil, -- [1]
						nil, -- [2]
						1, -- [3]
					},
				},
			},
			["Class"] = {
				["Color"] = {
					["Multiplier"] = 0,
				},
				["Background"] = {
					["Alpha"] = 0.75,
				},
				["Texture"] = "RUF 5",
			},
			["Health"] = {
				["Color"] = {
					["Reaction"] = true,
					["Class"] = true,
					["Percentage"] = false,
				},
				["Background"] = {
					["Alpha"] = 0.75,
					["UseBarColor"] = true,
				},
			},
			["Power"] = {
				["Background"] = {
					["Alpha"] = 0.75,
				},
				["Texture"] = "RUF 5",
			},
		},
	},
	["unit"] = {
		["party"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Enabled"] = false,
					},
					["TargetMark"] = {
						["Position"] = {
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["Lead"] = {
						["Enabled"] = false,
					},
					["Phased"] = {
						["Position"] = {
							["x"] = 50,
						},
					},
					["Role"] = {
						["Position"] = {
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
						["Size"] = 18,
					},
					["MainTankAssist"] = {
						["Enabled"] = false,
					},
					["Assist"] = {
						["Enabled"] = false,
					},
					["Ready"] = {
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "RIGHT",
						},
					},
				},
				["Position"] = {
					["y"] = 88,
					["x"] = 135,
					["offsety"] = 4,
					["AnchorTo"] = "BOTTOM",
					["AnchorFrom"] = "BOTTOMLEFT",
					["growth"] = "TOP",
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 1,
						},
						["Tag"] = "[RUF:CurHP]",
					},
					["Health Percent"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Tag"] = "[RUF:HPPerc]",
						["Position"] = {
							["y"] = -2,
							["x"] = 0,
							["Anchor"] = "TOP",
							["AnchorFrame"] = "Frame",
						},
						["Shadow"] = 0,
						["Enabled"] = true,
						["Size"] = 28,
						["Width"] = 100,
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOM",
							["x"] = 0,
						},
						["Size"] = 16,
					},
					["Level"] = {
						["Size"] = 14,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 250,
				},
			},
		},
		["target"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Position"] = {
							["x"] = 2,
						},
					},
					["Lead"] = {
						["Enabled"] = false,
					},
					["Role"] = {
						["Enabled"] = false,
						["Size"] = 18,
						["Position"] = {
							["x"] = -30,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["MainTankAssist"] = {
						["Enabled"] = false,
					},
					["Assist"] = {
						["Enabled"] = false,
					},
					["Ready"] = {
						["Enabled"] = false,
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
				},
				["Position"] = {
					["y"] = -100,
					["x"] = 300,
					["AnchorFrom"] = "LEFT",
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 1,
						},
						["Tag"] = "[RUF:CurHP]",
					},
					["Power"] = {
						["Enabled"] = false,
					},
					["Health Percent"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Tag"] = "[RUF:HPPerc]",
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["Anchor"] = "LEFT",
							["AnchorFrame"] = "Name",
						},
						["Shadow"] = 0,
						["Enabled"] = true,
						["Size"] = 21,
						["Width"] = 100,
					},
					["Level"] = {
						["Size"] = 14,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["boss"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Enabled"] = false,
					},
					["Phased"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 2,
						},
						["Tag"] = "[RUF:HPPerc]",
						["Size"] = 36,
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOM",
						},
						["Tag"] = "[RUF:PowerPerc]",
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["Level"] = {
						["Size"] = 14,
					},
					["Health Current"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Width"] = 100,
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["Anchor"] = "RIGHT",
							["AnchorFrame"] = "Name",
						},
						["Shadow"] = 0,
						["Size"] = 21,
						["Enabled"] = false,
						["Tag"] = "[RUF:CurHP]",
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["arena"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Enabled"] = false,
					},
					["Lead"] = {
						["Enabled"] = false,
					},
					["Role"] = {
						["Enabled"] = false,
						["Size"] = 18,
						["Position"] = {
							["x"] = -30,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["MainTankAssist"] = {
						["Enabled"] = false,
					},
					["Assist"] = {
						["Enabled"] = false,
					},
					["Ready"] = {
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 2,
						},
						["Tag"] = "[RUF:HPPerc]",
						["Size"] = 36,
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOM",
							["x"] = 0,
						},
						["Tag"] = "[RUF:PowerPerc]",
						["Size"] = 16,
					},
					["Level"] = {
						["Size"] = 14,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["pet"] = {
			["Frame"] = {
				["Indicators"] = {
					["TargetMark"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
				["Position"] = {
					["AnchorTo"] = "BOTTOMRIGHT",
					["AnchorFrom"] = "TOPRIGHT",
				},
				["Text"] = {
					["Health"] = {
						["Tag"] = "[RUF:HPPerc]",
					},
				},
				["Size"] = {
					["Width"] = 200,
				},
			},
		},
		["boss"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Enabled"] = false,
					},
					["Phased"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 2,
						},
						["Tag"] = "[RUF:HPPerc]",
						["Size"] = 36,
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOM",
						},
						["Tag"] = "[RUF:PowerPerc]",
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["Level"] = {
						["Size"] = 14,
					},
					["Health Current"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Width"] = 100,
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["Anchor"] = "RIGHT",
							["AnchorFrame"] = "Name",
						},
						["Shadow"] = 0,
						["Size"] = 21,
						["Enabled"] = false,
						["Tag"] = "[RUF:CurHP]",
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["player"] = {
			["Frame"] = {
				["Indicators"] = {
					["Honor"] = {
						["Enabled"] = false,
						["Badge"] = false,
					},
					["InCombat"] = {
						["Enabled"] = false,
					},
					["Lead"] = {
						["Enabled"] = false,
					},
					["Role"] = {
						["Enabled"] = false,
					},
					["MainTankAssist"] = {
						["Enabled"] = false,
					},
					["Assist"] = {
						["Enabled"] = false,
					},
					["Ready"] = {
						["Enabled"] = false,
						["Position"] = {
							["x"] = 2,
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "LEFT",
						},
					},
				},
				["Position"] = {
					["y"] = -100,
					["x"] = -300,
					["AnchorFrom"] = "RIGHT",
				},
				["Bars"] = {
					["Class"] = {
						["Height"] = 6,
					},
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Text"] = {
					["Health Percent"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Tag"] = "[RUF:HPPerc]",
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["Anchor"] = "CENTER",
							["AnchorFrame"] = "Frame",
						},
						["Shadow"] = 0,
						["Enabled"] = true,
						["Size"] = 36,
						["Width"] = 100,
					},
					["Health"] = {
						["Position"] = {
							["y"] = 0,
						},
						["Tag"] = "[RUF:CurHP]",
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOMLEFT",
							["x"] = 4,
						},
						["Tag"] = "[RUF:PowerPerc]",
					},
					["Mana"] = {
						["Position"] = {
							["Anchor"] = "TOPLEFT",
							["x"] = 4,
							["y"] = -3,
							["AnchorFrame"] = "Frame",
						},
						["Tag"] = "[RUF:ManaPerc]",
					},
					["Level"] = {
						["Position"] = {
							["y"] = 0,
							["x"] = 44,
							["Anchor"] = "LEFT",
						},
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 20,
							["x"] = 0,
							["Anchor"] = "TOP",
						},
						["Enabled"] = false,
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["focus"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Enabled"] = false,
					},
					["TargetMark"] = {
						["Position"] = {
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["Lead"] = {
						["Enabled"] = false,
					},
					["Role"] = {
						["Enabled"] = false,
						["Size"] = 18,
						["Position"] = {
							["x"] = 30,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["MainTankAssist"] = {
						["Enabled"] = false,
					},
					["Assist"] = {
						["Enabled"] = false,
					},
					["Ready"] = {
						["Enabled"] = false,
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Text"] = {
					["Health"] = {
						["Tag"] = "[RUF:CurHP]",
					},
					["Health Percent"] = {
						["Outline"] = "OUTLINE",
						["Font"] = "RUF",
						["Tag"] = "[RUF:HPPerc]",
						["Position"] = {
							["y"] = 0,
							["x"] = 0,
							["Anchor"] = "RIGHT",
							["AnchorFrame"] = "Name",
						},
						["Shadow"] = 0,
						["Enabled"] = true,
						["Size"] = 21,
						["Width"] = 100,
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "BOTTOM",
							["x"] = 0,
						},
						["Size"] = 16,
					},
					["Level"] = {
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["AFKDND"] = {
						["Enabled"] = false,
					},
				},
				["Size"] = {
					["Height"] = 45,
					["Width"] = 200,
				},
			},
		},
		["focustarget"] = {
			["Frame"] = {
				["Indicators"] = {
					["TargetMark"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Tag"] = "[RUF:HPPerc]",
					},
				},
				["Size"] = {
					["Width"] = 200,
				},
			},
		},
		["targettarget"] = {
			["Frame"] = {
				["Indicators"] = {
					["TargetMark"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
				["Position"] = {
					["AnchorTo"] = "BOTTOMLEFT",
					["AnchorFrom"] = "TOPLEFT",
				},
				["Text"] = {
					["Health"] = {
						["Tag"] = "[RUF:HPPerc]",
					},
				},
				["Size"] = {
					["Width"] = 200,
				},
			},
		},
	},
}
RUF.Layout.Alidie = Alidie

local Raeli = {
	["Appearance"] = {
		["Colors"] = {
			["DifficultyColors"] = {
				{
					nil, -- [1]
					0.501960784313726, -- [2]
					0.0980392156862745, -- [3]
				}, -- [1]
				{
					nil, -- [1]
					0.745098039215686, -- [2]
					0.0980392156862745, -- [3]
				}, -- [2]
				{
					0.250980392156863, -- [1]
					0.784313725490196, -- [2]
					0.250980392156863, -- [3]
				}, -- [3]
				{
					0.305882352941177, -- [1]
					0.501960784313726, -- [2]
					0.643137254901961, -- [3]
				}, -- [4]
				[0] = {
					nil, -- [1]
					0.196078431372549, -- [2]
					0.0980392156862745, -- [3]
				},
			},
			["ReactionColors"] = {
				{
					0.780392156862745, -- [1]
					0.250980392156863, -- [2]
					0.250980392156863, -- [3]
				}, -- [1]
				{
					0.8, -- [1]
					0.380392156862745, -- [2]
					0.27843137254902, -- [3]
				}, -- [2]
				{
					0.815686274509804, -- [1]
					0.509803921568627, -- [2]
					0.305882352941177, -- [3]
				}, -- [3]
				{
					0.854901960784314, -- [1]
					0.772549019607843, -- [2]
					0.36078431372549, -- [3]
				}, -- [4]
				{
					0.196078431372549, -- [1]
					0.662745098039216, -- [2]
					0.250980392156863, -- [3]
				}, -- [5]
				{
					0.294117647058824, -- [1]
					0.686274509803922, -- [2]
					0.294117647058824, -- [3]
				}, -- [6]
				{
					0.235294117647059, -- [1]
					0.686274509803922, -- [2]
					0.333333333333333, -- [3]
				}, -- [7]
				{
					0.196078431372549, -- [1]
					0.666666666666667, -- [2]
					0.372549019607843, -- [3]
				}, -- [8]
				nil, -- [9]
				{
					0.188235294117647, -- [1]
					0.443137254901961, -- [2]
					0.749019607843137, -- [3]
				}, -- [10]
			},
			["ClassColors"] = {
				["DEATHKNIGHT"] = {
					0.811764705882353, -- [1]
					0.215686274509804, -- [2]
					0.301960784313726, -- [3]
				},
				["WARRIOR"] = {
					0.733333333333333, -- [1]
					0.498039215686275, -- [2]
					0.294117647058824, -- [3]
				},
				["SHAMAN"] = {
					nil, -- [1]
					0.419607843137255, -- [2]
					0.764705882352941, -- [3]
				},
				["MAGE"] = {
					0.215686274509804, -- [1]
					0.772549019607843, -- [2]
					1, -- [3]
				},
				["PRIEST"] = {
					nil, -- [1]
					0.925490196078432, -- [2]
					0.827450980392157, -- [3]
				},
				["PALADIN"] = {
					1, -- [1]
					0.388235294117647, -- [2]
					0.71764705882353, -- [3]
				},
				["WARLOCK"] = {
					0.588235294117647, -- [1]
					0.466666666666667, -- [2]
					0.898039215686275, -- [3]
				},
				["DEMONHUNTER"] = {
					0.6, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["ROGUE"] = {
					nil, -- [1]
					0.847058823529412, -- [2]
					0, -- [3]
				},
				["DRUID"] = {
					nil, -- [1]
					0.513725490196078, -- [2]
					0.196078431372549, -- [3]
				},
				["MONK"] = {
					nil, -- [1]
					0.662745098039216, -- [2]
					0.541176470588235, -- [3]
				},
				["HUNTER"] = {
					0.631372549019608, -- [1]
					0.729411764705882, -- [2]
					0.286274509803922, -- [3]
				},
			},
			["PowerColors"] = {
				[13] = {
					0.588235294117647, -- [1]
					0.466666666666667, -- [2]
					0.898039215686275, -- [3]
				},
				[18] = {
					[3] = 0.00392156862745098,
				},
				[17] = {
					[3] = 0.00392156862745098,
				},
			},
		},
		["Text"] = {
			["AFKDND"] = {
				["Color"] = {
					["BaseColor"] = {
						0.749019607843137, -- [1]
						0.749019607843137, -- [2]
						0.749019607843137, -- [3]
					},
				},
			},
			["CurHPPerc"] = {
				["Color"] = {
					["Reaction"] = true,
					["Class"] = true,
					["PercentageAtMax"] = false,
				},
			},
			["Level"] = {
				["HideSameLevel"] = true,
			},
		},
		["Bars"] = {
			["Class"] = {
				["Background"] = {
					["Multiplier"] = 0.2,
					["Alpha"] = 0.75,
				},
				["Texture"] = "Cabaret 2",
			},
			["Health"] = {
				["Color"] = {
					["PercentageGradient"] = {
						nil, -- [1]
						nil, -- [2]
						0.12156862745098, -- [3]
						0.117647058823529, -- [4]
						0.117647058823529, -- [5]
						0.117647058823529, -- [6]
						0.117647058823529, -- [7]
						0.117647058823529, -- [8]
						0.117647058823529, -- [9]
					},
				},
				["Background"] = {
					["Alpha"] = 0.75,
				},
			},
			["Power"] = {
				["Background"] = {
					["Multiplier"] = 0.2,
					["Alpha"] = 0.75,
				},
				["Texture"] = "Armory",
			},
		},
	},
	["unit"] = {
		["boss"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Honor"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Lead"] = {
						["Position"] = {
							["AnchorTo"] = "TOPRIGHT",
						},
					},
					["Role"] = {
						["Position"] = {
							["x"] = -50,
							["AnchorTo"] = "RIGHT",
							["AnchorFrom"] = "RIGHT",
						},
					},
					["MainTankAssist"] = {
						["Position"] = {
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "RIGHT",
						},
					},
					["PvPCombat"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Ready"] = {
						["Position"] = {
							["x"] = 75,
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "LEFT",
						},
					},
				},
				["Position"] = {
					["y"] = -34,
					["x"] = 0,
					["AnchorTo"] = "BOTTOMLEFT",
					["AnchorFrom"] = "TOPLEFT",
					["AnchorFrame"] = "oUF_RUF_FocusTarget",
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 1,
							["x"] = -4,
							["Anchor"] = "RIGHT",
						},
					},
					["Power"] = {
						["Position"] = {
							["y"] = 4,
						},
						["Size"] = 16,
					},
					["Level"] = {
						["Position"] = {
							["y"] = 4,
							["x"] = 0,
							["Anchor"] = "BOTTOM",
						},
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = -4,
							["x"] = 4,
							["Anchor"] = "TOPLEFT",
						},
					},
					["AFKDND"] = "",
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
				},
			},
			["Buffs"] = {
				["Icons"] = {
					["Enabled"] = false,
					["Growth"] = {
						["x"] = "RIGHT",
					},
					["Filter"] = {
						["Time"] = {
							["Unlimited"] = true,
						},
						["Caster"] = {
							["Player"] = false,
						},
					},
					["Position"] = {
						["x"] = 1,
						["AnchorTo"] = "TOPRIGHT",
						["AnchorFrom"] = "TOPLEFT",
					},
					["Size"] = 45,
				},
			},
			["Debuffs"] = {
				["Icons"] = {
					["Growth"] = {
						["x"] = "RIGHT",
					},
					["Filter"] = {
						["Time"] = {
							["Unlimited"] = true,
						},
					},
					["Position"] = {
						["x"] = 1,
						["AnchorTo"] = "BOTTOMRIGHT",
						["AnchorFrom"] = "BOTTOMLEFT",
					},
					["Size"] = 45,
				},
			},
		},
		["target"] = {
			["Frame"] = {
				["Indicators"] = {
					["Honor"] = {
						["Badge"] = true,
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
						["Enabled"] = true,
					},
					["Role"] = {
						["Enabled"] = false,
						["Position"] = {
							["x"] = 0,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
				},
				["Position"] = {
					["y"] = -266,
					["x"] = 224,
					["AnchorFrom"] = "LEFT",
				},
				["Text"] = {
					["Power"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
					["Level"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
			},
		},
		["pet"] = {
			["Frame"] = {
				["Position"] = {
					["AnchorTo"] = "BOTTOMLEFT",
					["AnchorFrom"] = "TOPLEFT",
				},
				["Bars"] = {
					["Power"] = {
						["Position"] = {
							["Anchor"] = "TOP",
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Enabled"] = false,
					},
					["Name"] = {
						["Position"] = {
							["y"] = -1,
							["x"] = 0,
							["Anchor"] = "CENTER",
						},
						["Size"] = 18,
					},
				},
				["Size"] = {
					["Width"] = 148,
				},
			},
		},
		["player"] = {
			["Frame"] = {
				["Indicators"] = {
					["Role"] = {
						["Enabled"] = false,
						["Position"] = {
							["x"] = 50,
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "LEFT",
						},
					},
				},
				["Position"] = {
					["y"] = -266,
					["x"] = -224,
					["AnchorFrom"] = "RIGHT",
				},
			},
		},
		["arena"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Honor"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Lead"] = {
						["Position"] = {
							["AnchorTo"] = "TOPRIGHT",
						},
					},
					["Role"] = {
						["Position"] = {
							["x"] = -50,
							["AnchorTo"] = "RIGHT",
							["AnchorFrom"] = "RIGHT",
						},
					},
					["MainTankAssist"] = {
						["Position"] = {
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "RIGHT",
						},
					},
					["PvPCombat"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
						},
					},
					["Ready"] = {
						["Position"] = {
							["x"] = 75,
							["AnchorTo"] = "LEFT",
							["AnchorFrom"] = "LEFT",
						},
					},
				},
				["Position"] = {
					["y"] = -34,
					["x"] = 0,
					["offsety"] = -4,
					["AnchorTo"] = "BOTTOMLEFT",
					["AnchorFrom"] = "TOPLEFT",
					["growth"] = "BOTTOM",
					["AnchorFrame"] = "oUF_RUF_FocusTarget",
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 1,
						},
					},
					["Power"] = {
						["Position"] = {
							["y"] = 4,
						},
						["Size"] = 16,
					},
					["Level"] = {
						["Position"] = {
							["y"] = 4,
							["x"] = 0,
							["Anchor"] = "BOTTOM",
						},
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = 6,
						},
					},
					["AFKDND"] = "",
				},
				["Bars"] = {
					["Power"] = {
						["Height"] = 6,
					},
				},
				["Size"] = {
					["Height"] = 45,
				},
			},
			["Buffs"] = {
				["Icons"] = {
					["Growth"] = {
						["x"] = "RIGHT",
					},
					["Filter"] = {
						["Time"] = {
							["Max"] = 30,
						},
						["Caster"] = {
							["Player"] = false,
						},
					},
					["Position"] = {
						["AnchorTo"] = "TOPRIGHT",
						["AnchorFrom"] = "TOPLEFT",
					},
					["Size"] = 20,
				},
			},
			["Debuffs"] = {
				["Icons"] = {
					["Columns"] = 10,
					["Max"] = 10,
					["Growth"] = {
						["x"] = "RIGHT",
					},
					["Filter"] = {
						["Caster"] = {
							["Other"] = true,
						},
					},
					["Position"] = {
						["x"] = 1,
						["AnchorTo"] = "BOTTOMRIGHT",
						["AnchorFrom"] = "BOTTOMLEFT",
					},
					["Size"] = 26,
				},
			},
		},
		["party"] = {
			["Frame"] = {
				["Indicators"] = {
					["Objective"] = {
						["Position"] = {
							["AnchorTo"] = "LEFT",
						},
					},
					["Honor"] = {
						["Badge"] = true,
						["Position"] = {
							["AnchorTo"] = "LEFT",
						},
						["Enabled"] = true,
					},
					["Lead"] = {
						["Position"] = {
							["AnchorTo"] = "TOPLEFT",
						},
					},
					["Role"] = {
						["Position"] = {
							["x"] = 50,
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["MainTankAssist"] = {
						["Position"] = {
							["AnchorTo"] = "RIGHT",
							["AnchorFrom"] = "LEFT",
						},
					},
					["PvPCombat"] = {
						["Position"] = {
							["AnchorTo"] = "LEFT",
						},
					},
					["TargetMark"] = {
						["Position"] = {
							["AnchorTo"] = "CENTER",
							["AnchorFrom"] = "CENTER",
						},
					},
					["Ready"] = {
						["Position"] = {
							["x"] = -75,
							["AnchorTo"] = "RIGHT",
							["AnchorFrom"] = "RIGHT",
						},
					},
				},
				["Position"] = {
					["y"] = 210,
					["x"] = -4,
					["AnchorTo"] = "BOTTOMRIGHT",
					["AnchorFrom"] = "BOTTOMRIGHT",
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = 1,
							["x"] = 4,
							["Anchor"] = "LEFT",
						},
					},
					["Power"] = {
						["Position"] = {
							["y"] = 4,
						},
						["Size"] = 16,
					},
					["Level"] = {
						["Position"] = {
							["y"] = 4,
							["x"] = 0,
							["Anchor"] = "BOTTOM",
						},
						["Size"] = 16,
					},
					["Name"] = {
						["Position"] = {
							["y"] = -4,
							["x"] = -4,
							["Anchor"] = "TOPRIGHT",
						},
					},
					["AFKDND"] = {
						["Position"] = {
							["Anchor"] = "LEFT",
							["x"] = 2,
						},
					},
				},
				["Bars"] = {
					["Absorb"] = {
						["Fill"] = "REVERSE",
					},
					["Health"] = {
						["Fill"] = "REVERSE",
					},
					["Power"] = {
						["Enabled"] = 2,
						["Height"] = 6,
						["Fill"] = "REVERSE",
					},
				},
				["Size"] = {
					["Height"] = 45,
				},
			},
			["Buffs"] = {
				["Icons"] = {
					["Enabled"] = false,
					["Growth"] = {
						["x"] = "LEFT",
					},
					["Filter"] = {
						["Caster"] = {
							["Unit"] = false,
						},
					},
					["Position"] = {
						["x"] = -1,
						["AnchorTo"] = "TOPLEFT",
						["AnchorFrom"] = "TOPRIGHT",
					},
					["Size"] = 45,
				},
			},
			["Debuffs"] = {
				["Icons"] = {
					["Growth"] = {
						["x"] = "LEFT",
					},
					["Filter"] = {
						["Caster"] = {
							["Group"] = true,
							["Other"] = true,
						},
					},
					["Position"] = {
						["x"] = -1,
						["AnchorTo"] = "BOTTOMLEFT",
						["AnchorFrom"] = "BOTTOMRIGHT",
					},
					["Size"] = 45,
				},
			},
		},
		["focus"] = {
			["Frame"] = {
				["Position"] = {
					["y"] = 302,
				},
				["Text"] = {
					["Power"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
					["Level"] = {
						["Position"] = {
							["y"] = 2,
						},
					},
				},
			},
			["Buffs"] = {
				["Icons"] = {
					["Enabled"] = false,
				},
			},
			["Debuffs"] = {
				["Icons"] = {
					["Max"] = 10,
					["Filter"] = {
						["Time"] = {
							["Unlimited"] = true,
						},
						["Caster"] = {
							["Group"] = true,
							["Other"] = true,
						},
					},
					["Size"] = 60,
				},
			},
		},
		["focustarget"] = {
			["Frame"] = {
				["Position"] = {
					["y"] = -4,
					["AnchorTo"] = "BOTTOMLEFT",
					["AnchorFrom"] = "TOPLEFT",
				},
				["Bars"] = {
					["Power"] = {
						["Position"] = {
							["Anchor"] = "TOP",
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = -1,
						},
					},
					["Name"] = {
						["Position"] = {
							["y"] = -1,
						},
					},
				},
			},
		},
		["pettarget"] = {
			["Enabled"] = true,
			["Frame"] = {
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = -1,
						},
					},
					["Name"] = {
						["Position"] = {
							["y"] = -1,
						},
						["Size"] = 18,
					},
				},
				["Bars"] = {
					["Absorb"] = {
						["Fill"] = "REVERSE",
					},
					["Health"] = {
						["Fill"] = "REVERSE",
					},
					["Power"] = {
						["Position"] = {
							["Anchor"] = "TOP",
						},
						["Fill"] = "REVERSE",
					},
				},
				["Size"] = {
					["Width"] = 148,
				},
			},
		},
		["targettarget"] = {
			["Frame"] = {
				["Bars"] = {
					["Power"] = {
						["Position"] = {
							["Anchor"] = "TOP",
						},
					},
				},
				["Text"] = {
					["Health"] = {
						["Position"] = {
							["y"] = -1,
						},
					},
					["Name"] = {
						["Position"] = {
							["y"] = -1,
						},
					},
				},
			},
		},
	},
}
RUF.Layout.Raeli = Raeli
