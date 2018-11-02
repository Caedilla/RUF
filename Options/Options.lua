local RUF = LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local RUF_O = RUF:NewModule("RUF_Options")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local TagList = {}
local LocalisedTags = {}
local TagInputs = {}
for k,v in pairs(RUF.db.profile.Appearance.Text) do
	if v ~= "" then
		table.insert(TagList,k)
		table.insert(LocalisedTags,L[k])
		TagInputs["[RUF:"..k.."]"] = L[k]
	end
end

local Options = {
	type = "group",
	name = function(info)
		return "RUF [|c5500DBBDRaeli's Unit Frames|r] r|c5500DBBD" .. RUF.db.global.Version .."|r"
	end,	
	order = 0,
	childGroups = "tab",
	args = {
		Notes = {
			name = "Known Issues",
			type = "group",
			order = 2000,
			args = {
				KnownIssuesHeader = {
						name = "|cffFFCC00".."Known Issues".."|r",
						type = "description",
						order = 0,
						fontSize = "large",
					},
				AuraTestMode = {
					name = "Buffs and Debuffs don't currently display correctly while using Test Mode.",
					type = "description",
					order = 1,
					width = "full",
				},
				Configuring = {
					name = "The options panel can cause significant frame drops while using it, particularly when using sliders to adjust settings. This is only while configuring the addon though.",
					type = "description",
					order = 1,
					width = "full",	
				},
				IndicatorStyle = {
					name = "Switching Indicator styles currently requires a UI Reload to take effect.",
					type = "description",
					order = 1,
					width = "full",
				},
			},
		},
		Appearance = {
			name = L["Appearance Options"],
			desc = L["These settings affect all frames."],
			type = "group",
			childGroups = "tab",
			order = 1,
			args = {
				FrameLock = {
					name = "|cff00B2FA"..L["Frame Lock"].."|r",
					desc = L["Allow unit frames to be repositioned by dragging."],
					order = 0,
					type = "toggle",
					get = function(info)
						return RUF.db.global.Lock
					end,
					set = function(info, value)
						RUF.db.global.Lock = value
						RUF:UpdateFrames()
					end,
				},
				TestMode = {
					name = "|cff00B2FA"..L["Test Mode"].."|r",
					desc = L["Shows all unitframes so you can easily configure them."],
					order = 1,
					type = "toggle",
					get = function(info)
						return RUF.db.global.TestMode
					end,
					set = function(info, value)
						RUF.db.global.TestMode = value
						RUF:TestMode()
						RUF:UpdateFrames()
					end,
				},
				TestModeShowUnits = {
					name = "|cff00B2FA"..L["Show Unit in Test Mode."].."|r",
					desc = L["Displays the name of the unit frame in test mode."],
					order = 2,
					type = "toggle",
					get = function(info)
						return RUF.db.global.TestModeShowUnits
					end,
					set = function(info, value)
						RUF.db.global.TestModeShowUnits = value
						RUF:UpdateFrames()
						RUF:TestMode()
					end,
				},
				Border = {
					name = L["Border"],
					type = "group",
					order = 5,
					--hidden = true,
					args = {
						Debuff = {
							name = L["Debuff Highlighting"],
							desc = L["Not Yet Implemented."],
							type = "toggle",
							disabled = true,							
							order = 0.01,
						},
						Texture = {
							name = L["Border Texture"],
							type = "select",
							order = 0.02,
							values = LSM:HashTable("border"),
							dialogControl = "LSM30_Border",
							get = function(info)
								return RUF.db.profile.Appearance.Border.Style.edgeFile
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Border.Style.edgeFile = value
								RUF:UpdateFrames()
							end,
						},
						Size = {
							name = L["Border Size"],
							type = "range",
							order = 0.03,
							min = -20,
							max = 20,
							softMin = -20,
							softMax = 20,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Border.Style.edgeSize
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Border.Style.edgeSize = value
								RUF:UpdateFrames()
							end,
						},
						Alpha = {
							name = L["Alpha"],
							type = "range",
							order = 0.03,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Border.Alpha			
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Border.Alpha = value
								RUF:UpdateFrames()
							end,
						},
						Offset = {
							name = L["Offset"],
							type = "range",
							order = 0.03,
							min = -30,
							max = 30,
							softMin = -30,
							softMax = 30,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.Appearance.Border.Offset			
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Border.Offset = value
								RUF:UpdateFrames()
							end,
						},
						Color = {
							name = L["Base Color"],
							type = "color",
							order = 0.04,
							get = function(info)
								return RUF.db.profile.Appearance.Border.Color[1], RUF.db.profile.Appearance.Border.Color[2],RUF.db.profile.Appearance.Border.Color[3]
							end,
							set = function(info,r,g,b)
								RUF.db.profile.Appearance.Border.Color[1] = r
								RUF.db.profile.Appearance.Border.Color[2] = g
								RUF.db.profile.Appearance.Border.Color[3] = b
								RUF:UpdateFrames()
							end,
						},
					},
				},
				Bars = {
					name = L["Bars"],
					type = "group",
					order = 1,
					args = {},
				},
				Colors = {
					name = L["Colors"],
					type = "group",
					order = 0,
					args = {},
				},
				Auras = {
					name = L["Auras"],
					type = "group",
					order = 3,
					args = {
						Highlight = {
							name = L["Aura Highlighting"],
							type = "header",
							order = 0,
						},
						DefaultBuff = {
							name = L["Default Buff Glow"],
							type = "color",
							hasAlpha = true,
							order = 0.1,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.DefaultBuff = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						DefaultDebuff = {
							name = L["Default Debuff Glow"],
							type = "color",
							hasAlpha = true,
							order = 0.1,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						DebuffMagic = {
							name = L["Magic"],
							type = "color",
							hasAlpha = true,
							order = 0.2,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Magic)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Magic = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						DebuffDisease = {
							name = L["Disease"],
							type = "color",
							hasAlpha = true,
							order = 0.2,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Disease)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Disease = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},	
						DebuffCurse = {
							name = L["Curse"],
							type = "color",
							hasAlpha = true,
							order = 0.2,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Curse)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Curse = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						DebuffPoison = {
							name = L["Poison"],
							type = "color",
							hasAlpha = true,
							order = 0.2,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Poison)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Poison = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						DebuffEnrage = {
							name = L["Enrage"],
							type = "color",
							hasAlpha = true,
							order = 0.2,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Enrage)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Enrage = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},
						Buff = {
							name = L["Color Buffs by Type"],
							type = "toggle",
							order = 10.1,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Buff
							end,
							set = function(info, value)		
								RUF.db.profile.Appearance.Aura.Buff = value
								RUF:UpdateAllAuras()
							end,
						},
						Debuff = {
							name = L["Color Debuffs by Type"],
							type = "toggle",
							order = 10.1,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Debuff
							end,
							set = function(info, value)		
								RUF.db.profile.Appearance.Aura.Debuff = value
								RUF:UpdateAllAuras()
							end,
						},
						Dispellable = {
							name = L["Color only removable"],
							type = "toggle",
							order = 10.2,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.OnlyDispellable
							end,
							set = function(info, value)		
								RUF.db.profile.Appearance.Aura.OnlyDispellable = value
								RUF:UpdateAllAuras()
							end,
						},
						BorderSpacer = {
							name = " ",
							type = "description",
							order = 10.5,
						},
						BorderTexture = {
							name = L["Highlight Texture"],
							type = "select",
							order = 11,
							values = LSM:HashTable("border"),
							dialogControl = "LSM30_Border",
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Border.Style.edgeFile
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Border.Style.edgeFile = value
								RUF:UpdateAllAuras()
							end,
						},
						BorderSize = {
							name = L["Highlight Size"],
							type = "range",
							order = 11.1,
							min = -20,
							max = 20,
							softMin = -20,
							softMax = 20,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Border.Style.edgeSize
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Border.Style.edgeSize = value
								RUF:UpdateAllAuras()
							end,
						},
						BorderOffset = {
							name = L["Offset"],
							type = "range",
							order = 11.2,
							min = -30,
							max = 30,
							softMin = -30,
							softMax = 30,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Border.Offset			
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Border.Offset = value
								RUF:UpdateAllAuras()
							end,
						},
						Pixel = {
							name = "Pixel Border",
							type = "header",
							order = 15,
						},
						Enabled = {
							name = L["Enabled"],
							type = "toggle",
							order = 15.1,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Pixel.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Pixel.Enabled = value
								RUF:UpdateAllAuras()
							end,
						},
						PixelColor = {
							name = L["Border Color"],
							type = "color",
							hasAlpha = true,
							order = 16,
							get = function(info)
								return unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
							end,
							set = function(info, r,g,b,a)
								RUF.db.profile.Appearance.Colors.Aura.Pixel = {r,g,b,a}
								RUF:UpdateAllAuras()
							end,
						},						
						PixelTexture = {
							name = L["Border Texture"],
							type = "select",
							order = 16.1,
							values = LSM:HashTable("border"),
							dialogControl = "LSM30_Border",
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile = value
								RUF:UpdateAllAuras()
							end,
						},
						PixelSize = {
							name = L["Border Size"],
							type = "range",
							order = 16.1,
							min = -20,
							max = 20,
							softMin = -20,
							softMax = 20,
							step = 0.01,
							bigStep = 0.05,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize = value
								RUF:UpdateAllAuras()
							end,
						},
						PixelOffset = {
							name = L["Offset"],
							type = "range",
							order = 16.2,
							min = -30,
							max = 30,
							softMin = -30,
							softMax = 30,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.Appearance.Aura.Pixel.Offset			
							end,
							set = function(info, value)
								RUF.db.profile.Appearance.Aura.Pixel.Offset = value
								RUF:UpdateAllAuras()
							end,
						},
					},
				},
			},
		},
		Unit = {
			name = L["Unit Options"],
			type = "group",
			order = 2,
			args = {

			},
		},
		Filtering = {
			name = L["Filtering"],
			type = "group",
			order = 3,
			hidden = true,
			args = {

			},
		},
		Feedback = {
			name = L["Feedback"],
			type = "group",
			order = 1000,
			args = {
				Head = {
					name = L["Feedback"],
					type = "header",					
					order = 0,
				},
				Revision = {
					name = "|cffFFCC00"..L["Current Revision"].."|r |c5500DBBD".. RUF.db.global.Version .. "|r",
					type = "description",
					order = 0.5,
					fontSize = "large",
				},
				RevisionDescription = {
					name = L["When reporting an issue, please also post the revision number above. Thanks!"],
					type = "description",
					order = 0.6,
				},
				Spacer_FeedbackOnline = {
					name = "\n",
					type = "description",
					order = 1,
				},
				Curseforge_Header = {
					name = "|cff91BE0F"..L["Online"].."|r",
					type = "description",
					order = 50,
					fontSize = "large",
				},
				Curseforge_Description = {
					name = L["If you encounter a bug, or have a feature request, please file a ticket on Curseforge using the link below."],
					type = "description",
					order = 50.1,
				},
				Curseforge_URL = {
					name = L["RUF on Curseforge"],
					type = "input",
					order = 50.2,
					width = "full",
					get = function() return "https://wow.curseforge.com/projects/ruf/issues" end,
					set = function() return "https://wow.curseforge.com/projects/ruf/issues" end,
				},
				Spacer_OnlineCommunity = {
					name = "\n\n\n\n",
					type = "description",
					order = 75,
				},
				Community_Header = {
					name = "|cff00B2FA"..L["In Game"].."|r",
					type = "description",
					order = 100,
					fontSize = "large",
				},
				Community_Description = {
					name = L["I have a Battle.net community for my addons. If you have any issues, now you can easily report them to me in game. Just copy the invite link below and throw me a message."],
					type = "description",
					order = 100.1,
				},
				Community_URL = {
					name = L["Invite Link"],
					type = "input",
					order = 100.2,
					width = "full",
					get = function() return "https://blizzard.com/invite/WqRG7EUgOR" end,
					set = function() return "https://blizzard.com/invite/WqRG7EUgOR" end,
				},
			},
		},
	},
}

local function Filters()
	local FilterList = {}	
	for k,v in pairs(RUF.db.profile.Filters.Lists) do
		if v ~= "" then
			FilterList[k]=k
		end
	end
	local Spells = {}

	local Filtering = {
		name = L["Filtering"],
		type = "group",
		order = 2,
		args = {
			AddNew = {
				name = L["New Filter List"],
				type = "input",
				order = 0,
				set = function(info, value)
					if not RUF.db.profile.Filters.Lists[value] and value ~= " " then
						RUF.db.profile.Filters.Lists[value] = {}
						RUF:UpdateOptions()
					end
				end,				
			},
			EditFilter = {
				name = L["Select Filter to Configure"],
				type = "select",
				values = FilterList,
				order = 1,
				get = function(info)
					return RUF.db.profile.Filters.Selected
				end,
				set = function(info, value)
					RUF.db.profile.Filters.Selected = value
					wipe(Spells)
					for k,v in pairs(RUF.db.profile.Filters.Lists[RUF.db.profile.Filters.Selected]) do
						if v ~= "" then
							Spells[v]=v
						end
					end
					RUF:UpdateOptions()
				end,
			},
			AddSpell = {
				name = L["Add Spell"],
				type = "input",
				order = 10,
				set = function(info, value)
					if value == " " then return end
					table.insert(RUF.db.profile.Filters.Lists[RUF.db.profile.Filters.Selected],value)
					RUF:UpdateFrames()
					RUF:UpdateOptions()
				end,
			},
			SpellList = {
				name = L["Spell List"],
				type = "select",
				order = 11,
				values = Spells,
				get = function(info)
					return RUF.db.profile.Filters.SelectedSpell
				end,
				set = function(info, value)
					RUF.db.profile.Filters.SelectedSpell = value
					RUF:UpdateOptions()
				end,							
			},
			RemoveSpell = {
				name = L["Remove Spell"],
				type = "execute",
				order = 10,
				set = function(info, value)
					table.remove(RUF.db.profile.Filters.Lists[RUF.db.profile.Filters.Selected],RUF.db.profile.Filters.SelectedSpell)
					RUF.db.profile.Filters.SelectedSpell = ""
					RUF:UpdateFrames()
				end,
			},
		},
	}

	return Filtering
end

local function Bars()
	local LocalisedBar = {
		[1] = L["Health"],
		[2] = L["Power"],
		[3] = L["Class"],
		[4] = L["Absorb"],
	}
	local Bar = {
		[1] = "Health",
		[2] = "Power",
		[3] = "Class",
		[4] = "Absorb",
	}
	local Bars = {
		name = L["Bars"],
		type = "group",	
		childGroups = "select",
		order = 1,
		args = {},
	}
	for i=1,4 do
		Bars.args[Bar[i]] = {
			name = LocalisedBar[i],
			type = "group",
			order = i,
			args = {
				Texture = {
					name = L["Texture"],
					type = "select",
					order = 0,
					values = LSM:HashTable("statusbar"),
					dialogControl = "LSM30_Statusbar",
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Texture					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Texture = value
						RUF:UpdateFrames()
					end,
				},
				Type = {
					name = L["Type"],
					desc = L["Not Yet Implemented."],
					type = "select",
					order = 0.01,
					hidden = function() return i ~= 4 end,
					disabled = true,
					values = {
						[1] = L["Health Bar Overlay"],
						[2] = L["Separate Bar"],
					},
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Type					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Type = value
						RUF:UpdateFrames()
					end,
				},
				Animate = {
					name = L["Animate"],
					desc = L["Animate bar changes."],
					type = "toggle",
					order = 0.01,
					desc = "",					
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Animate					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Animate = value
						RUF:UpdateFrames()
					end,
				},
				Disconnected = {
					name = L["Color Disconnected"],
					desc = L["Colors the bar using the disconnected color if the unit is disconnected."],
					type = "toggle",
					order = 0.02,
					hidden = function() return (i == 4 or i == 3) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Disconnected					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Disconnected = value
						RUF:UpdateFrames()
					end,
				},
				Tapped = {
					name = L["Color Tapped"],
					desc = L["Colors the bar using the tapped color if the unit is tapped."],
					type = "toggle",
					order = 0.03,
					hidden = function() return (i == 4 or i == 3) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Tapped					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Tapped = value
						RUF:UpdateFrames()
					end,
				},
				Class = {
					name = L["Color Class"],
					desc = L["Color player units by class color."],
					type = "toggle",
					order = 0.04,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Class					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Class = value
						RUF:UpdateFrames()
					end,
				},
				Power = {
					name = L["Color Power Type"],
					desc = L["Colors the bar using the power color."],
					type = "toggle",
					hidden = function() return (i == 1 or i == 4) end,
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PowerType					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PowerType = value
						RUF:UpdateFrames()
					end,
				},
				Reaction = {
					name = L["Color Reaction"],
					desc = L["Color unit by reaction toward the player."],
					type = "toggle",
					hidden = function() return i == 3 end,
					order = 0.06,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Reaction					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Reaction = value
						RUF:UpdateFrames()
					end,
				},
				Absorb_Alpha = {
					name = L["Alpha"],
					desc = L["Overlay Alpha"],
					type = "range",
					order = 0.07,
					hidden = i ~= 4,
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Alpha					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Alpha = value
						RUF:UpdateFrames()
					end,
				},
				Absorb_Multiplier = {
					name = L["Brightness Multiplier"],
					desc = L["Reduce Bar color's brightness by this percentage."],
					type = "range",
					order = 0.08,
					hidden = function() return (i ~= 4) end,
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier = value
						RUF:UpdateFrames()
					end,
				},
				Class_Multiplier = {
					name = L["Segment Multiplier"],
					desc = L["Reduce each segment's brightness by this percentage."],
					type = "range",
					order = 0.08,
					hidden = function() return (i ~= 3) end,
					min = 0.0,
					max = 33,
					softMin = 0,
					softMax = 20,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Multiplier = value
						RUF:UpdateFrames()
					end,
				},
				Percentage = {
					name = L["Color Percentage"],
					desc = L["Color Bar by percentage colors."],
					type = "toggle",
					order = 0.09,
					hidden = function() return (i == 4 or i == 3) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage = value
						RUF:UpdateFrames()
					end,
				},
				Percent_100 = {
					name = L["100%"],
					desc = L["Color at 100%."],
					type = "color",
					order = 0.1,
					hidden =  function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[7],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[8],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[9]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[7] = r
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[8] = g
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[9] = b
						RUF:UpdateFrames()
					end,
				},
				Percent_50 = {
					name = L["50%"],
					desc = L["Color at 50%"],
					type = "color",
					order = 0.11,
					hidden =  function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[4],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[5],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[6]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[4] = r
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[5] = g
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[6] = b
						RUF:UpdateFrames()
					end,
				},
				Percent_0 = {
					name = L["0%"],
					desc = L["Color at 0%"],
					type = "color",
					order = 0.12,
					hidden =  function() return not RUF.db.profile.Appearance.Bars[Bar[i]].Color.Percentage end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[1],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[2],RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[3]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[1] = r
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[2] = g
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.PercentageGradient[3] = b
						RUF:UpdateFrames()
					end,
				},
				Base_Color = {
					name = L["Base Color"],
					desc = L["Color used if none of the other options are checked."],
					type = "color",
					order = 0.13,
					get = function(info)
						return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].Color.BaseColor)
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Color.BaseColor = {r,g,b}
						RUF:UpdateFrames()
					end,
				},
				Background = {
					name = L["Background"],
					type = "header",
					order = 10,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
				},
				CustomColor = {
					name = L["Background Color"],
					desc = L["Background Color to use if not using the bar's color."],
					type = "color",
					order = 10.01,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) or (RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor) end,
					get = function(info)
						return unpack(RUF.db.profile.Appearance.Bars[Bar[i]].Background.CustomColor)
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Background.CustomColor = {r,g,b}
						RUF:UpdateFrames()
					end,
				},
				UseBarColor = {
					name = L["Use Bar Color"],
					desc = L["Color the background the same as the bar's color. Brightness reduced by the Multiplier setting."],
					type = "toggle",
					order = 10.02,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Background.UseBarColor = value
						RUF:UpdateFrames()
					end,
				},
				Multiplier = {
					name = L["Brightness Multiplier"],
					desc = L["Reduce background color's brightness by this percentage."],
					type = "range",
					order = 10.03,
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Background.Multiplier					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Background.Multiplier = value
						RUF:UpdateFrames()
					end,
				},
				Alpha = {
					name = L["Alpha"],
					desc = L["Background Alpha"],
					type = "range",
					order = 10.04,
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					disabled = function() return (i == 4 and RUF.db.profile.Appearance.Bars[Bar[i]].Type == 1) end,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Background.Alpha					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Background.Alpha = value
						RUF:UpdateFrames()
					end,
				},
				Border = {
					name = L["Border"],
					type = "header",
					order = 20,
					hidden = i==1 or i==4,
				},
				Border_Texture = {
					name = L["Border Texture"],
					type = "select",
					order = 20.02,
					hidden = i==1 or i==4,
					values = LSM:HashTable("border"),
					dialogControl = "LSM30_Border",
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeFile
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeFile = value
						RUF:UpdateFrames()
					end,
				},
				Border_Size = {
					name = L["Border Size"],
					type = "range",
					order = 20.03,
					hidden = i==1 or i==4,
					min = -20,
					max = 20,
					softMin = -20,
					softMax = 20,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeSize
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Style.edgeSize = value
						RUF:UpdateFrames()
					end,
				},
				Border_Alpha = {
					name = L["Alpha"],
					desc = L["Overlay Alpha"],
					type = "range",
					order = 20.03,
					hidden = i==1 or i==4,
					min = 0,
					max = 1,
					softMin = 0,
					softMax = 1,
					step = 0.01,
					bigStep = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Alpha			
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Alpha = value
						RUF:UpdateFrames()
					end,
				},
				Border_Color = {
					name = L["Base Color"],
					type = "color",
					order = 20.04,
					hidden = i==1 or i==4,
					get = function(info)
						return RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[1], RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[2],RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[3]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[1] = r
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[2] = g
						RUF.db.profile.Appearance.Bars[Bar[i]].Border.Color[3] = b
						RUF:UpdateFrames()
					end,
				},
			},
		}
	end
	return Bars
end

local function Colors()
	local Reactions = {
		[1] = L["Hated"],
		[2] = L["Hostile"],
		[3] = L["Unfriendly"],
		[4] = L["Neutral"],
		[5] = L["Friendly"],
		[6] = L["Honored"],
		[7] = L["Revered"],
		[8] = L["Exalted"],
		--[9] = L["Paragon"],
		[10] = L["Friendly Pet"],
	}
	local Difficulties = {
		[0] = L["Very Hard"],
		[1] = L["Hard"],
		[2] = L["Normal"],
		[3] = L["Easy"],
		[4] = L["Trivial"],
	}
	local Powers = {
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
		--[10] = "Alternate Power",
		[11] = _G['MAELSTROM'] or MAELSTROM,
		[12] = _G['CHI'] or CHI,
		[13] = _G['INSANITY'] or INSANITY,
		--[14] = _G['UNUSED'] or UNUSED,
		--[15] = _G['UNUSED'] or UNUSED,
		[16] = _G['ARCANE_CHARGES'] or ARCANE_CHARGES,
		[17] = _G['FURY'] or FURY,
		[18] = _G['PAIN'] or PAIN,
		[50] = L["Runes - Blood"],
		[51] = L["Runes - Frost"],
		[52] = L["Runes - Unholy"],
		[75] = L["Stagger - Low"],
		[76] = L["Stagger - Medium"],
		[77] = L["Stagger - High"],
	}
	local Class = { -- !ClassColors Addon Overrides these values.
		[0] = select(1,(GetClassInfo(6))),
		[1] = select(1,(GetClassInfo(12))),
		[2] = select(1,(GetClassInfo(11))),
		[3] = select(1,(GetClassInfo(3))),
		[4] = select(1,(GetClassInfo(8))),
		[5] = select(1,(GetClassInfo(10))),
		[6] = select(1,(GetClassInfo(2))),
		[7] = select(1,(GetClassInfo(5))),
		[8] = select(1,(GetClassInfo(4))),
		[9] = select(1,(GetClassInfo(7))),
		[10] = select(1,(GetClassInfo(9))),
		[11] = select(1,(GetClassInfo(1))),
	}
	local UpperClass = { -- !ClassColors Addon Overrides these values.
		[0] = "DEATHKNIGHT",
		[1] = "DEMONHUNTER",
		[2] = "DRUID",
		[3] = "HUNTER",
		[4] = "MAGE",
		[5] = "MONK",
		[6] = "PALADIN",
		[7] = "PRIEST",
		[8] = "ROGUE",
		[9] = "SHAMAN",
		[10] = "WARLOCK",
		[11] = "WARRIOR",
	}
	local Colors = {
		name = L["Colors"],
		type = "group",
		order = 0,
		args = {
			Class = {
				name = L["Class Colors"],
				type = "header",
				order = 00,
			},
			ClassColors_UseAddon = {
				order = 0.01,
				type = "toggle",
				name = L["Use colors from the Class Colors addon"],
				width = "double",
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
					RUF:UpdateFrames()
				end,
			},
			UseBlizz_CC = {
				order = 0.011,
				type = "execute",
				name = L["Set Blizard Default"],
				desc = L["Set class colors to the default Blizzard colors."],
				width = "double",
				func = function(info, value)
					RUF.db.profile.Appearance.Colors.UseClassColors = false
					for classToken, color in next, RAID_CLASS_COLORS  do
						RUF.db.profile.Appearance.Colors.ClassColors[classToken] = {(color.r), (color.g), (color.b)}				
					end
					RUF:UpdateFrames()
					RUF:UpdateFrames()
				end,
			},
			Spacer_CC = {
				name = "",
				type = "description",
				order = 0.012,
				width = "full",
			},
			Misc = {
				name = L["Misc Colors"],
				type = "header",
				order = 9,
			},
			Disconnected = {
				name = L["Disconnected"],
				type = "color",
				order = 9.01,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Disconnected)
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.MiscColors.Disconnected = {r,g,b}
					RUF:UpdateFrames()
				end,
			},
			Tapped = {
				name = L["Tapped"],
				type = "color",
				order = 9.02,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.MiscColors.Tapped = {r,g,b}
					RUF:UpdateFrames()
				end,
			},
			Power = {
				name = L["Power Colors"],
				type = "header",
				order = 10,
			},
			Reaction = {
				name = L["Reaction Colors"],
				type = "header",
				order = 20,
			},
			Difficulty = {
				name = L["Difficulty Colors"],
				type = "header",
				order = 30,
			},
		},
	}
	for i=0,#Class do
		if Class[i] then
			Colors.args[Class[i]] = {
				name = Class[i],
				type = "color",
				order = 0 + ((i)+2)/100,
				disabled = function() 
					if(CUSTOM_CLASS_COLORS) and RUF.db.profile.Appearance.Colors.UseClassColors then							
						return true
					end
				end, -- !ClassColors takes precedent.
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ClassColors[UpperClass[i]])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.ClassColors[UpperClass[i]] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	for i=0,#Powers do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = "color",
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	for i=50,52 do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = "color",
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	for i=75,77 do
		if Powers[i] then
			Colors.args[Powers[i]] = {
				name = Powers[i],
				type = "color",
				order = 10 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.PowerColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.PowerColors[i] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	for i=1,#Reactions do
		if Reactions[i] then
			Colors.args[Reactions[i]] = {
				name = Reactions[i],
				type = "color",
				order = 20 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.ReactionColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.ReactionColors[i] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	for i=0,#Difficulties do
		if Difficulties[i] then
			Colors.args[Difficulties[i]] = {
				name = Difficulties[i],
				type = "color",
				order = 30 + ((i)+2)/100,
				get = function(info)
					return unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[i])
				end,
				set = function(info, r,g,b)
					RUF.db.profile.Appearance.Colors.DifficultyColors[i] = {r,g,b}
					RUF:UpdateFrames()
				end,
			}
		end
	end
	return Colors
end


local function Texts()
	local Texts = {
		name = L["Tags"],
		type = "group",
		order = 4,
		args = {},
	}
	for i=1,#TagList do
		Texts.args[TagList[i]] = {
			name = LocalisedTags[i],
			type = "group",
			args = {
				Case = {
					type = "select",
					name = L["Text Case"],
					desc = L["Choose if text is Capitalised, All Lower Case or all Upper case."],
					order = 0.03,
					values = {
						[0] = L["Normal"],
						[1] = L["Upper Case"],
						[2] = L["Lower Case"],
					},
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Case
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Case = value
						RUF:UpdateFrames()																				  			
					end,
				},
				Base_Color = {
					name = L["Base Color"],
					desc = L["Color used if none of the other options are checked."],
					type = "color",
					order = 0.04,
					get = function(info)
						return unpack(RUF.db.profile.Appearance.Text[TagList[i]].Color.BaseColor)
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.BaseColor = {r,g,b}
						RUF:UpdateFrames()
					end,
				},
				Class = {
					name = L["Color Class"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Class					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Class = value
						RUF:UpdateFrames()
					end,
				},
				Level = {
					name = L["Color Level"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Level					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Level = value
						RUF:UpdateFrames()
					end,
				},
				Reaction = {
					name = L["Color Reaction"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Reaction					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Reaction = value
						RUF:UpdateFrames()
					end,
				},
				PowerType = {
					name = L["Color Power Type"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PowerType					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PowerType = value
						RUF:UpdateFrames()
					end,
				},
				Percentage = {
					name = L["Color Percentage"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage = value
						RUF:UpdateFrames()
					end,
				},
				PercentageAtMax = {
					name = L["Color Percentage At Max"],
					type = "toggle",
					order = 0.05,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageAtMax					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageAtMax = value
						RUF:UpdateFrames()
					end,
				},
				Percent_100 = {
					name = L["100%"],
					desc = L["Color at 100%."],
					type = "color",
					order = 0.1,
					hidden =  function() return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage end,
					get = function(info)
						
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[7],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[8],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[9]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[7] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[8] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[9] = b
						RUF:UpdateFrames()
					end,
				},
				Percent_50 = {
					name = L["50%"],
					desc = L["Color at 50%"],
					type = "color",
					order = 0.11,
					hidden =  function() return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[4],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[5],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[6]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[4] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[5] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[6] = b
						RUF:UpdateFrames()
					end,
				},
				Percent_0 = {
					name = L["0%"],
					desc = L["Color at 0%"],
					type = "color",
					order = 0.12,
					hidden =  function() return not RUF.db.profile.Appearance.Text[TagList[i]].Color.Percentage end,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[1],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[2],RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[3]
					end,
					set = function(info,r,g,b)
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[1] = r
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[2] = g
						RUF.db.profile.Appearance.Text[TagList[i]].Color.PercentageGradient[3] = b
						RUF:UpdateFrames()
					end,
				},
				Spacer = {
					name = " ",
					type = "description",
					width = "full",
					order = 10.0,
				},
				HideSameLevel = {
					name = L["Hide same level"],
					desc = L["Hide the level text if the unit is the same level as you."],
					type = "toggle",
					width = "full",
					hidden = function() return TagList[i] ~= "Level" end,
					order = 10.01,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].HideSameLevel					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].HideSameLevel = value
						RUF:UpdateFrames()
					end,
				},
				HideWhenPrimaryIsMana = {
					name = L["Hide if Primary Power is Mana."],
					desc = L["Sets this to hidden if your primary resource is mana, so it only shows if you have a class resource, such as Maelstrom."],
					type = "toggle",
					width = "full",
					hidden = function() 
						if TagList[i] == "CurMana" or TagList[i] == "ManaPerc" or TagList[i] == "CurManaPerc" then return false else return true end end,
					order = 10.01,
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].HideWhenPrimaryIsMana					
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].HideWhenPrimaryIsMana = value
						RUF:UpdateFrames()
					end,
				},
				Name_Limit = {
					name = L["Character Limit"],
					desc = L["Abbreviate Character Names longer than this. Set 0 for no limit."],
					type = "range",
					order = 10.03,
					hidden = function() return TagList[i] ~= "Name" end,
					min = 0,
					max = 50,
					softMin = 0,
					softMax = 50,
					step = 1,
					bigStep = 1,					
					get = function(info)
						return RUF.db.profile.Appearance.Text.Name.CharLimit
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text.Name.CharLimit = value
						RUF:UpdateFrames()
					end,
				},
				CurManaPerc_Enabled = {
					name = L["Display Style"],
					desc = L["Hide this tag at 0 or always display."],
					type = "select",
					order = 10.01,
					hidden = function() return TagList[i] ~= "CurManaPerc" end,
					hidden = function() 
						if TagList[i] == "CurMana" or TagList[i] == "ManaPerc" or TagList[i] == "CurManaPerc" or 
						   TagList[i] == "CurPower" or TagList[i] == "PowerPerc" or TagList[i] == "CurPowerPerc"
						   then 
							return false 
						else 
							return true 
						end 
					end,
					values = {
						[1] = L["Hidden at 0"],
						[2] = L["Always Visible"],
					},
					get = function(info)
						return RUF.db.profile.Appearance.Text[TagList[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.Appearance.Text[TagList[i]].Enabled = value
						RUF:UpdateFrames()
					end,
				},
			},
		}
	end
	return Texts
end

local function Units()
	local LocalisedBar = {
		[1] = L["Health"],
		[2] = L["Power"],
		[3] = L["Class"],
		[4] = L["Absorb"],
	}
	local Bar = {
		[1] = "Health",
		[2] = "Power",
		[3] = "Class",
		[4] = "Absorb",
	}
	local Indicators = {
		[1] = "Assist",
		[2] = "Honor",
		[3] = "InCombat",
		[4] = "Lead",
		[5] = "MainTankAssist",
		[6] = "Phased",
		[7] = "PvPCombat",
		[8] = "Objective",
		[9] = "Ready",
		[10] = "Rest",		
		[11] = "Role",
		[12] = "TargetMark",		
	}
	local Units = {
		name = L["Unit Options"],
		type = "group",
		childGroups = "tree",
		order = 1,
		args = {
		},
	}

	local function UnitArgs(name,ord,i)
		
		Units.args[RUF.db.global.UnitList[i].name] = {
			name = L[name],
			type = "group",
			childGroups = "tab",
			order = ord,
			args = {
				Frame = {
					name = L["Frame"],
					type = "group",
					childGroups = "tab",
					order = 0,
					args = {
						NickName = {
							type = "input",
							name = L["Nickname"],
							desc = L["You can set a nickname to replace your character's name on all RUF frames. Leave blank for your character's name."],
							width = "full",
							hidden = function() return (i ~= 1) end,
							order = 0.0,
							multiline = false,
							get = function(info)
								return RUF.db.char.NickName
							end,
							set = function(info, value)
								RUF.db.char.NickName = value
								RUF:UpdateFrames()
							end,
						},
						Enabled = {
							name = function()
								if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled == true then
									Units.args[RUF.db.global.UnitList[i].name].args.Frame.args.Enabled.name = "|cFF00FF00"..L["Enabled"].."|r"
								else
									Units.args[RUF.db.global.UnitList[i].name].args.Frame.args.Enabled.name = "|cFFFF0000"..L["Enabled"].."|r"
								end
							end,
							desc = L["Enable the Unit Frame."],
							type = "toggle",
							order = 0.004,
							hidden = function() return (i == 1) end,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled
							end,
							set = function(info, value)		
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled = value
								RUF:UpdateFrames()
								RUF:UpdateOptions()
							end,
						},
						EnabledSpacer = {
							name = " ",
							type = "description",
							order = 0.005,
							width = "full",
							hidden = function() return (i == 1) end,
						},
						RangeFading = {
							name = L["Fade out of Range"],
							desc = L["Fade the unit frame it the target is out of range of your spells."],
							type = "toggle",
							hidden = true,
							order = 0.01,
							--hidden = function() return (i == 1) end,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.RangeFading.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.RangeFading.Enabled = value
								RUF:UpdateFrames()
							end,
						},
						Alpha = {
							name = L["Alpha"],
							desc = L["Out of Range transparency"],
							type = "range",
							hidden = true,
							order = 0.02,
							min = 0,
							max = 1,
							softMin = 0,
							softMax = 1,
							step = 0.1,
							bigStep = 0.1,
							--hidden = function() return (i == 1) end,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.RangeFading.Alpha
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.RangeFading.Alpha = value
								RUF:UpdateFrames()
							end,
						},
						Width = {
							name = L["Width"],
							type = "range",
							order = 0.03,
							min = 50,
							max = 750,
							softMin = 100,
							softMax = 400,
							step = 1,
							bigStep = 10,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Width
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Width = value
								RUF:UpdateFrames()
								RUF:UpdateOptions()
							end,
						},
						Height = {
							name = L["Height"],
							type = "range",
							order = 0.04,
							min = 10,
							max = 300,
							softMin = 20,
							softMax = 100,
							step = 1,
							bigStep = 5,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Height
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Height = value
								RUF:UpdateFrames()
							end,
						},
						SpacerHeightX = {
							name = " ",
							type = "description",
							order = 0.05,
							width = "full",
						},
						Anchor_Frame = {
							type = "input",
							name = L["Anchor Frame"],
							desc = L["The name of the frame for the unit to anchor to. Defaults to UI Parent if set blank."],
							--width = "full",
							multiline = false,
							order = 0.06,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrame
							end,
							set = function(info, value)
								if value ~= nil and value:match("%S") ~= nil then
									if _G[value] then
										if RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame], _G[value]) then
											RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrame = value
										end
									else
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrame = "UIParent"
									end
								else
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrame = "UIParent"
								end
								RUF:UpdateOptions()
								RUF:UpdateFrames()
							end,
						},
						X = {
							type = "range",
							name = L["X Offset"],
							desc = L["Horizontal Offset from the Frame Anchor."],
							order = 0.07,
							min = -5000,
							max = 5000,
							softMin = -1000,
							softMax = 1000,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								RUF:UpdateFrames()
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.x = value
								RUF:UpdateFrames()
							end,
						},
						Y = {
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical Offset from the Frame Anchor."],
							order = 0.08,
							min = -5000,
							max = 5000,
							softMin = -1000,
							softMax = 1000,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.y = value
								RUF:UpdateFrames()
							end,
						},
						Anchor_From = {
							type = "select",
							name = L["Anchor From"],
							desc = L["Location area of the Unitframe to anchor from."],
							--width = "full",
							order = 0.09,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrom
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrom = value
								RUF:UpdateFrames()
							end,
						},
						Anchor_To = {
							type = "select",
							name = L["Anchor To"],
							desc = L["Area on the anchor frame to anchor the unitframe to."],
							--width = "full",
							order = 0.09,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorTo
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorTo = value
								RUF:UpdateFrames()
							end,
						},
						AnchorGroupSeparator = {
							name = " ",
							type = "description",
							order = 0.095,
							width = "full",
						},
						GrowthDirection = {
							type = "select",
							name = L["Growth Direction"],
							desc = L["Grow up or down."],
							hidden = function() 
								if RUF.db.global.UnitList[i].group == "boss" or RUF.db.global.UnitList[i].group == "arena" then return false else return true end end,
							order = 0.1,
							values = {
								TOP = L["Up"],
								BOTTOM = L["Down"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth
							end,
							set = function(info, value)
								
								if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth ~= value then
									if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety > 0 then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety = 0 - RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety
									else
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety = 0 - (RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety)
									end
								end
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth = value
								RUF:UpdateFrames()
								RUF:TestMode()
								RUF:UpdateOptions()
							end,
						},
						PartyOrder = {
							type = "select",
							name = L["Sort Direction"],
							hidden = RUF.db.global.UnitList[i].group ~= "party",
							order = 0.1,
							values = {
								TOP = L["Up"],
								BOTTOM = L["Down"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth
							end,
							set = function(info, value)
								
								if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth ~= value then
									if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety > 0 then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety = 0 - RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety
									else
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety = 0 - (RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety)
									end
								end
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.growth = value
								RUF:UpdateFrames()
								RUF:TestMode()
								RUF:UpdateOptions()
							end,
						},
						XOffset = {
							type = "range",
							name = L["X Spacing"],
							desc = L["Horizontal Offset from the previous unit in the group."],
							hidden = RUF.db.global.UnitList[i].group == "" or RUF.db.global.UnitList[i].group == "party" ,
							order = 0.11,
							min = -5000,
							max = 5000,
							softMin = -1000,
							softMax = 1000,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								RUF:UpdateFrames()
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsetx
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsetx = value
								RUF:UpdateFrames()
							end,
						},
						YOffset = {
							type = "range",
							name = L["Y Spacing"],
							desc = L["Vertical Offset from the previous unit in the group."],
							hidden = RUF.db.global.UnitList[i].group == "",
							order = 0.12,
							min = -5000,
							max = 5000,
							softMin = -1000,
							softMax = 1000,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.offsety = value
								RUF:UpdateFrames()
							end,
						},
					},
				},
				BarGroup = {
					name = L["Bars"],
					type = "group",
					childGroups = "tab",
					order = 10,
					args = {
						Order = {
							name = L["Bar Order"],
							desc = L["If Class and Power bars are anchored to the same location, choose which bar is closest to the order."],
							type = "select",
							order = 0.1,
							hidden = function()	return (i ~= 1) or (RUF:GetSpec() == 0) end,
							values = {
								[0] = L["Power First, Class Second"],
								[1] = L["Class First, Power Second"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Power.Position.Order
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Power.Position.Order = value
								RUF:UpdateFrames()
							end,
						},
						Health = {
							name = L["Health"],
							type = "group",
							order = 10,
							args = {
	
							},
						},
						Power = {
							name = L["Power"],
							type = "group",
							order = 10,
							args = {
								
							},
						},
						Class = {
							name = L["Class"],
							type = "group",
							order = 10,
							hidden = function()	return (i ~= 1) or (RUF:GetSpec() == 0) end,
							args = {
								
							},
						},
						Absorb = {
							name = L["Absorb"],
							type = "group",
							order = 10,
							args = {
								
							},
						},
					}
				},
				TextGroup = {
					name = L["Texts"],
					type = "group",
					childGroups = "select",
					order = 20,
					args = {
						Add = {
							name = L["Add Text Area"],
							desc = L["Add a Text Area for this unit with this name."],
							type = "input",
							order = 0.0,
							set = function(info, value)
								if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] then 
									if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] ~= "" then
										RUF:Print_Self(L['A text area with that name already exists!'])
										return 
									end
								end
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] = {
									Font = "RUF",
									Outline = "OUTLINE",
									Shadow = 0,
									Tag = value,
									Enabled = true,
									Size = 21,
									Width = 100,
									Position = {
										x = 0,
										y = 0,
										AnchorFrame = "Frame",
										Anchor = "CENTER",
									},
								}
								RUF:UpdateOptions()
								RUF:UpdateFrames()
							end,							
						},
						Remove = {
							name = L["Remove Text Area"],
							desc = L["Remove Text Area from this unit with this name."],
							type = "input",
							order = 0.1,
							set = function(info, value)
								if not RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] then return end --TODO Error Message
								if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] == "" then return end
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] = "DISABLED"
								RUF:UpdateFrames()
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[value] = ""
								RUF:UpdateOptions()
							end,	
						},
					},
				},
				IndicatorGroup = {
					name = L["Indicators"],
					type = "group",
					order = 30,
					args = {
						Assist = {
							name = L["Assist"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].group == "boss",
							args = {
							},
						},
						Honor = {
							name = L["Honor"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet",
							args = {
							},
						},
						InCombat = {
							name = L["Combat"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name ~= "player",
							args = {
							},
						},
						Lead = {
							name = L["Leader"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].group == "boss",
							args = {
							},
						},
						MainTankAssist = {
							name = L["Main Tank / Assist"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].group == "boss",
							args = {
							},
						},
						Phased = {
							name = L["Phased"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].name == "player",
							args = {
							},
						},
						PvPCombat = {
							name = L["PvP"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet",
							args = {
							},
						},
						Objective = {
							name = L["Quest"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].name == "player" or RUF.db.global.UnitList[i].group == "party" or RUF.db.global.UnitList[i].group == "arena",
							args = {
							},
						},
						Ready = {
							name = L["Ready Check"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].group == "boss",
							args = {
							},
						},
						Rest = {
							name = L["Resting"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name ~= "player",
							args = {
							},
						},
						Role = {
							name = L["Group Role"],
							type = "group",
							order = 0,
							hidden = RUF.db.global.UnitList[i].name == "pet" or RUF.db.global.UnitList[i].group == "boss",
							args = {
							},
						},
						TargetMark = {
							name = L["Target Markers"],
							type = "group",
							order = 0,
							args = {
							},
						},
					},
				},
				Buffs = {
					name = L["Buffs"],
					type = "group",
					order = 40,
					args = {
						Enabled = {
							name = L["Enabled"],
							type = "toggle",
							order = 0,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Enabled = value
								RUF:UpdateFrames()
							end,
						},
						EnabledSpacer = {
							name = " ",
							type = "description",
							order = 1,
							width = "full",
						},
						Size = {
							name = L["Size"],
							type = "range",
							order = 2,
							min = 4,
							max = 64,
							softMin = 12,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Size
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Size = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Rows = {
							name = L["Rows"],
							type = "range",
							hidden = true,
							order = 3,
							min = 1,
							max = 32,
							softMin = 1,
							softMax = 8,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Rows
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Rows = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Columns = {
							name = L["Columns"],
							type = "range",
							order = 3,
							min = 1,
							max = 64,
							softMin = 1,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Columns
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Columns = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SpacingX = {
							name = L["Horizontal Spacing"],
							type = "range",
							order = 3.1,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Spacing.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Spacing.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SpacingY = {
							name = L["Vertical Spacing"],
							type = "range",
							order = 3.2,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Spacing.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Spacing.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						GrowthX = {
							type = "select",
							name = L["Horizontal Growth"],
							order = 3.3,
							values = {
								RIGHT = L["Right"],
								LEFT = L["Left"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Growth.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Growth.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						GrowthY = {
							type = "select",
							name = L["Vertical Growth"],
							order = 3.3,
							values = {
								DOWN = L["Down"],
								UP = L["Up"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Growth.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Growth.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SortSpacer = {
							name = L["Sorting"],
							type = "header",
							order = 3.5,
							hidden = true,
						},
						SortDirection = {
							type = "select",
							name = L["Direction"],
							hidden = true,
							order = 4,
							values = {
								Ascending = L["Ascending"],
								Descending = L["Descending"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Sort.Direction
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Sort.Direction = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SortBy = {
							type = "select",
							name = L["Sort By"],
							hidden = true,
							order = 4,
							values = {
								Alphabetically = L["Alphabetically"],
								Duration = L["Duration"],
								Index = L["Index"],
								Player = L["Player"],
								Remaining = L["Time Remaining"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Sort.SortBy
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Sort.SortBy = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						AnchorSpacer = {
							name = L["Anchoring"],
							type = "header",
							order = 4.5,
						},
						OffsetX = {
							type = "range",
							name = L["X Offset"],
							desc = L["Horizontal Offset from the Anchor."],
							order = 5,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						OffsetY = {
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical Offset from the Anchor."],
							order = 6,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Anchor_From = {
							type = "select",
							name = L["Anchor From"],
							desc = L["Location area of the Indicator to anchor from."],
							order = 7,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrom
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrom = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Anchor_Frame = {
							type = "select",
							name = L["Attach To"],
							desc = L["Choose an element to attach to, either the frame or another indicator."],
							hidden = true,
							values = {
								Frame = L["Frame"],
								DebuffIcons = L["Debuff Icons"],
							},
							order = 8,
							get = function(info)
								RUF:UpdateOptions()
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrame
							end,
							set = function(info, value)
								if value ~= nil and value:match("%S") ~= nil then
									if value == "Frame" then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrame = "Frame"
									elseif RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame..".Buffs"], _G[RUF.db.global.UnitList[i].frame..".Debuffs"]) then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrame = value
									else
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrame = "Frame"
										-- TODO Pop up to confirm force anchoring Debuffs back to frame, so we can anchor buffs to debuffs.
									end
								else
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorFrame = "Frame"
								end
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
								RUF:UpdateOptions()
							end,
						},
						Anchor_To = {
							type = "select",
							name = L["Anchor To"],
							desc = L["Area on the anchor frame to anchor the indicator to."],
							order = 7,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorTo
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Position.AnchorTo = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						ClickThrough = {
							name = L["Click Through"],
							type = "toggle",
							order = 8,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.ClickThrough
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.ClickThrough = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterSpacer = {
							name = L["Filtering"],
							type = "header",
							order = 10.5,
						},
						FilterCasterPlayer = {
							type = "toggle",
							name = L["Show Player"],
							desc = L["Show Buffs cast by "].. L["Player"] .. L[" on this unit."],
							order = 15,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Player
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Player = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterUnit = {
							type = "toggle",
							name = L["Show "].. L[RUF.db.global.UnitList[i].name],
							desc = L["Show Buffs cast by "].. RUF.db.global.UnitList[i].name .. L[" on this unit."],
							hidden = RUF.db.global.UnitList[i].name == "player",
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Unit
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Unit = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterGroup = {
							type = "toggle",
							name = L["Show Group Members"],
							desc = L["Show Buffs cast by "].. L["group members"] .. L[" on this unit."],
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Group
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Group = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterOther = {
							type = "toggle",
							name = L["Show Others"],
							desc = L["Show Buffs cast by "].. L["others"] .. L[" on this unit."],
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Other
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Caster.Other = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						DurationSpacer = {
							name = " ",
							type = "description",
							order = 17,
							width = "full",
						},
						FilterDurationMin = {
							name = L["Minimum Duration"],
							type = "range",
							order = 20,
							min = 0,
							max = 3600,
							softMin = 0,
							softMax = 360,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Min
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Min = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDurationMax = {
							name = L["Maximum Duration"],
							type = "range",
							order = 21,
							min = 0,
							max = 86400,
							softMin = 0,
							softMax = 3600,
							step = 0.5,
							bigStep = 5,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Max
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Max = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDurationUnlimited = {
							type = "toggle",
							name = L["Show Unlimited Duration"],
							order = 22,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Unlimited
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Time.Unlimited = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDispellable = {
							type = "toggle",
							name = L["Show Only Dispellable"],
							desc = L["Show only auras you can dispel"],
							order = 23,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Dispellable
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Filter.Dispellable = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						MaxAuras = {
							name = L["Max Auras"],
							type = "range",
							order = 24,
							min = 1,
							max = 64,
							softMin = 1,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Max
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Buffs.Icons.Max = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
					},
				},
				Debuffs = {
					name = L["Debuffs"],
					type = "group",
					order = 40,
					args = {
						Enabled = {
							name = L["Enabled"],
							type = "toggle",
							order = 0,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Enabled
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Enabled = value
								RUF:UpdateFrames()
							end,
						},
						EnabledSpacer = {
							name = " ",
							type = "description",
							order = 1,
							width = "full",
						},
						Size = {
							name = L["Size"],
							type = "range",
							order = 2,
							min = 4,
							max = 64,
							softMin = 12,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Size
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Size = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Rows = {
							name = L["Rows"],
							type = "range",
							hidden = true,
							order = 3,
							min = 1,
							max = 32,
							softMin = 1,
							softMax = 8,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Rows
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Rows = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Columns = {
							name = L["Columns"],
							type = "range",
							order = 3,
							min = 1,
							max = 64,
							softMin = 1,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Columns
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Columns = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SpacingX = {
							name = L["Horizontal Spacing"],
							type = "range",
							order = 3.1,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Spacing.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Spacing.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SpacingY = {
							name = L["Vertical Spacing"],
							type = "range",
							order = 3.2,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Spacing.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Spacing.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						GrowthX = {
							type = "select",
							name = L["Horizontal Growth"],
							order = 3.3,
							values = {
								RIGHT = L["Right"],
								LEFT = L["Left"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Growth.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Growth.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						GrowthY = {
							type = "select",
							name = L["Vertical Growth"],
							order = 3.3,
							values = {
								DOWN = L["Down"],
								UP = L["Up"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Growth.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Growth.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SortSpacer = {
							name = L["Sorting"],
							type = "header",
							order = 3.5,
							hidden = true,
						},
						SortDirection = {
							type = "select",
							name = L["Direction"],
							hidden = true,
							order = 4,
							values = {
								Ascending = L["Ascending"],
								Descending = L["Descending"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Sort.Direction
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Sort.Direction = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						SortBy = {
							type = "select",
							name = L["Sort By"],
							hidden = true,
							order = 4,
							values = {
								Alphabetically = L["Alphabetically"],
								Duration = L["Duration"],
								Index = L["Index"],
								Player = L["Player"],
								Remaining = L["Time Remaining"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Sort.SortBy
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Sort.SortBy = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						AnchorSpacer = {
							name = L["Anchoring"],
							type = "header",
							order = 4.5,
						},
						OffsetX = {
							type = "range",
							name = L["X Offset"],
							desc = L["Horizontal Offset from the Anchor."],
							order = 5,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.x
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.x = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						OffsetY = {
							type = "range",
							name = L["Y Offset"],
							desc = L["Vertical Offset from the Anchor."],
							order = 6,
							min = -500,
							max = 500,
							softMin = -100,
							softMax = 100,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.y
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.y = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Anchor_From = {
							type = "select",
							name = L["Anchor From"],
							desc = L["Location area of the Indicator to anchor from."],
							order = 7,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrom
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrom = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						Anchor_Frame = {
							type = "select",
							name = L["Attach To"],
							desc = L["Choose an element to attach to, either the frame or another indicator."],
							hidden = true,
							values = {
								Frame = L["Frame"],
								BuffIcons = L["Buff Icons"],
							},
							order = 8,
							get = function(info)
								RUF:UpdateOptions()
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrame
							end,
							set = function(info, value)
								if value ~= nil and value:match("%S") ~= nil then
									if value == "Frame" then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrame = "Frame"
									elseif RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame..".Debuffs"], _G[RUF.db.global.UnitList[i].frame..".Buffs"]) then
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrame = value
									else
										RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrame = "Frame"
										-- TODO Pop up to confirm force anchoring DeDebuffs back to frame, so we can anchor Debuffs to deDebuffs.
									end
								else
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorFrame = "Frame"
								end
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
								RUF:UpdateOptions()
							end,
						},
						Anchor_To = {
							type = "select",
							name = L["Anchor To"],
							desc = L["Area on the anchor frame to anchor the indicator to."],
							order = 7,
							values = {
								TOP = L["Top"],
								RIGHT = L["Right"],
								BOTTOM = L["Bottom"],
								LEFT = L["Left"],
								TOPRIGHT = L["Top-right"],
								TOPLEFT = L["Top-left"],
								BOTTOMRIGHT = L["Bottom-right"],
								BOTTOMLEFT = L["Bottom-left"],
								CENTER = L["Center"],
							},
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorTo
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Position.AnchorTo = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						ClickThrough = {
							name = L["Click Through"],
							type = "toggle",
							order = 8,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.ClickThrough
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.ClickThrough = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterSpacer = {
							name = L["Filtering"],
							type = "header",
							order = 10.5,
						},
						FilterCasterPlayer = {
							type = "toggle",
							name = L["Show Player"],
							desc = L["Show Debuffs cast by "].. L["Player"] .. L[" on this unit."],
							order = 15,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Player
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Player = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterUnit = {
							type = "toggle",
							name = L["Show "].. L[RUF.db.global.UnitList[i].name],
							desc = L["Show Debuffs cast by "].. RUF.db.global.UnitList[i].name .. L[" on this unit."],
							hidden = RUF.db.global.UnitList[i].name == "player",
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Unit
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Unit = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterGroup = {
							type = "toggle",
							name = L["Show Group Members"],
							desc = L["Show Debuffs cast by "].. L["group members"] .. L[" on this unit."],
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Group
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Group = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterCasterOther = {
							type = "toggle",
							name = L["Show Others"],
							desc = L["Show Debuffs cast by "].. L["others"] .. L[" on this unit."],
							order = 16,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Other
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Caster.Other = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						DurationSpacer = {
							name = " ",
							type = "description",
							order = 17,
							width = "full",
						},
						FilterDurationMin = {
							name = L["Minimum Duration"],
							type = "range",
							order = 20,
							min = 0,
							max = 3600,
							softMin = 0,
							softMax = 360,
							step = 0.5,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Min
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Min = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDurationMax = {
							name = L["Maximum Duration"],
							type = "range",
							order = 21,
							min = 0,
							max = 86400,
							softMin = 0,
							softMax = 3600,
							step = 0.5,
							bigStep = 5,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Max
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Max = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDurationUnlimited = {
							type = "toggle",
							name = L["Show Unlimited Duration"],
							order = 22,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Unlimited
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Time.Unlimited = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						FilterDispellable = {
							type = "toggle",
							name = L["Show Only Dispellable"],
							desc = L["Show only auras you can dispel"],
							order = 23,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Dispellable
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Filter.Dispellable = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
						MaxAuras = {
							name = L["Max Auras"],
							type = "range",
							order = 24,
							min = 1,
							max = 64,
							softMin = 1,
							softMax = 32,
							step = 1,
							bigStep = 1,
							get = function(info)
								return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Max
							end,
							set = function(info, value)
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Debuffs.Icons.Max = value
								RUF:UpdateAuras(RUF.db.global.UnitList[i])
							end,
						},
					},
				},
			},
		}

		-- Unit Bar Options
		for j=1,#Bar do
			Units.args[RUF.db.global.UnitList[i].name].args.BarGroup.args[Bar[j]].args = {
				Class_Enabled = {
					name = function()
						if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Enabled == true then
							Units.args[RUF.db.global.UnitList[i].name].args.BarGroup.args[Bar[j]].args.Class_Enabled.name = "|cFF00FF00"..L["Enabled"].."|r"
						else
							Units.args[RUF.db.global.UnitList[i].name].args.BarGroup.args[Bar[j]].args.Class_Enabled.name = "|cFFFF0000"..L["Enabled"].."|r"
						end
					end,
					type = "toggle",
					order = 0,
					hidden = j ~= 3,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Enabled = value
						RUF:UpdateFrames()
						RUF:UpdateOptions()
					end,
				},
				Enabled = {
					name = L["Display Style"],
					type = "select",
					order = 0,
					hidden = j == 1 or j == 3,
					values = {
						[0] = L["Always Hidden"],
						[1] = L["Hidden at 0"],
						[2] = L["Always Visible"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Enabled = value
						RUF:UpdateFrames()
					end,
				},
				Fill = {
					name = L["Fill Type"],
					type = "select",
					order = 1,
					values = {
						["STANDARD"] = "Standard",
						["REVERSE"] = "Reverse",
						["CENTER"] = "Center",
						--["STANDARD_NO_RANGE_FILL"] = "Show no value as full",
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Fill
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Fill = value
						RUF:UpdateFrames()
					end,
				},
				Height = {
					name = L["Height"],
					type = "range",
					order = 0.04,
					hidden = j == 1,
					disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and j == 4 then return true end end,
					min = 2,
					max = 100,
					softMin = 4,
					softMax = 30,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Height
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Height = value
						RUF:UpdateFrames()
					end,
				},
				Anchor = {
					type = "select",
					name = L["Anchor"],
					order = 0.05,
					hidden = j == 1,
					disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and j == 4 then return true end end,
					values = {
						["TOP"] = L["Top"],
						["BOTTOM"] = L["Bottom"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Position.Anchor
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars[Bar[j]].Position.Anchor = value
						RUF:UpdateFrames()
					end,
				},					
			}
		end

		-- Unit Text Options
		local Text = {}		
		for k,v in pairs(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text) do
			if v ~= "" then
				table.insert(Text,k)
			end
		end
		for j=1,#Text do
			local TextAnchors = {}
			TextAnchors["Frame"] = "Frame"
			for k,v in pairs(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text) do
				if v ~= "" then
					if k ~= Text[j] then
						if RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame..".TextParent."..Text[j]..".Text"], _G[RUF.db.global.UnitList[i].frame..".TextParent."..k..".Text"]) then
							TextAnchors[k] = k
						end
					end
				end
			end
			Units.args[RUF.db.global.UnitList[i].name].args.TextGroup.args[Text[j]] = {
				name = Text[j],
				type = "group",
				order = 10,
				args = {

				},
			}
			Units.args[RUF.db.global.UnitList[i].name].args.TextGroup.args[Text[j]].args = {
				Enabled = {
					name = L["Enabled"],
					type = "toggle",
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Enabled = value
						RUF:UpdateFrames()
					end,
				},
				Tag = {
					type = "select",
					name = L["Tag"],
					values = TagInputs,
					order = 0.01,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Tag
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Tag = value
						RUF:UpdateFrames()
					end,
				},
				Spacer = {
					name = " ",
					type = "description",
					order = 0.02,
					width = "full",
				},
				X = {
					type = "range",
					name = L["X Offset"],
					desc = L["Horizontal Offset from the Anchor."],
					order = 0.03,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.x = value
						RUF:UpdateFrames()
					end,
				},
				Y = {
					type = "range",
					name = L["Y Offset"],
					desc = L["Vertical Offset from the Anchor."],
					order = 0.04,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.y = value
						RUF:UpdateFrames()
					end,
				},
				Width = {
					name = L["Max Width"],
					desc = L["Limit text width."],
					type = "range",
					hidden = true,
					order = 0.05,
					min = 0,
					max = 750,
					softMin = 10,
					softMax = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Width,
					step = 1,
					bigStep = 10,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Width
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Width = value
						RUF:UpdateFrames()
					end,
				},
				Anchor_Frame = {
					type = "select",
					name = L["Attach To"],
					desc = L["Choose an element to attach to, either the frame or another text area."],
					values = TextAnchors,
					order = 0.06,
					get = function(info)
						RUF:UpdateOptions()
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match("%S") ~= nil then
							if value == "Frame" then
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.AnchorFrame = "Frame"
							elseif RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame..".TextParent."..Text[j]..".Text"], _G[RUF.db.global.UnitList[i].frame..".TextParent."..value..".Text"]) then
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.AnchorFrame = "Frame"
							end
						else
							RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.AnchorFrame = "Frame"
						end
						RUF:UpdateFrames()
						RUF:UpdateOptions()
					end,
				},
				Anchor = {
					type = "select",
					name = L["Anchor To"],
					order = 0.07,
					values = {
						TOP = L["Top"],
						RIGHT = L["Right"],
						BOTTOM = L["Bottom"],
						LEFT = L["Left"],
						TOPRIGHT = L["Top-right"],
						TOPLEFT = L["Top-left"],
						BOTTOMRIGHT = L["Bottom-right"],
						BOTTOMLEFT = L["Bottom-left"],
						CENTER = L["Center"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.Anchor
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Position.Anchor = value
						RUF:UpdateFrames()
					end,
				},
				Font = {
					name = L["Font"],
					type = "select",
					order = 10,
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Font					
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Font = value
						RUF:UpdateFrames()
					end,
				},
				Size = {
					name = L["Font Size"],
					type = "range",
					order = 10,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 48,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Size = value
						RUF:UpdateFrames()
					end,
				},
				Outline = {
					name = L["Outline"],
					type = "select",
					order = 10,
					values = {
						[""] = L["None"],
						["OUTLINE"] = L["Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
						["MONOCHROME"] = L["Monochrome"],
						["MONOCHROME,OUTLINE"] = L["Monochrome Outline"],
						["MONOCHROME,THICKOUTLINE"] = L["Monochrome Thick Outline"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Outline							
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Outline = value
						RUF:UpdateFrames()
					end,
				},
				ShadowEnabled = {
					name = L["Shadow"],
					desc = L["Enable Text Shadow"],
					type = "toggle",
					order = 10,
					get = function(info)
						if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Shadow == 1 then 
							return true
						else
							return false
						end
					end,
					set = function(info, value)
						if value == true then
							RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Shadow = 1
						else
							RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[Text[j]].Shadow = 0
						end
						RUF:UpdateFrames()
					end,
				},
			} 
		end

		-- Unit Indicator Options
		local Icon = {}		
		for k,v in pairs(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators) do
			if v ~= "" then
				table.insert(Icon,k)
			end
		end
		for j=1,#Indicators do
			local IndicatorAnchors = {}
			IndicatorAnchors["Frame"] = "Frame"
			for k,v in pairs(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators) do
				if v ~= "" then
					if k ~= Indicators[j] then
						if RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame.."."..Indicators[j].."Indicator"], _G[RUF.db.global.UnitList[i].frame.."."..k.."Indicator"]) then
							IndicatorAnchors[k] = k
							if k == "TargetMark" then
								IndicatorAnchors[k] = L["Target Markers"]
							elseif k == "InCombat" then
								IndicatorAnchors[k] = L["Combat"]
							elseif k == "MainTankAssist" then
								IndicatorAnchors[k] = L["Main Tank / Assist"]
							elseif k == "PvPCombat" then
								IndicatorAnchors[k] = L["PvP"]
							end
						end
					end
				end
			end
			Units.args[RUF.db.global.UnitList[i].name].args.IndicatorGroup.args[Indicators[j]].args = {
				Enabled = {
					name = function()
						if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Enabled == true then
							Units.args[RUF.db.global.UnitList[i].name].args.IndicatorGroup.args[Indicators[j]].args.Enabled.name = "|cFF00FF00"..L["Enabled"].."|r"
						else
							Units.args[RUF.db.global.UnitList[i].name].args.IndicatorGroup.args[Indicators[j]].args.Enabled.name = "|cFFFF0000"..L["Enabled"].."|r"
						end
					end,
					type = "toggle",
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Enabled = value
						RUF:UpdateFrames()
					end,
				},
				Style = {
					name = L["Style"],
					desc = L["Changes Indicator icon style. Requires a UI Reload to take effect."],
					type = "select",
					order = 0.05,
					hidden = j == 2,
					values = {
						["Blizzard"] = L["Blizzard Icons"],
						["RUF"] = L["RUF Icons"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Style
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Style = value
						RUF:UpdateFrames()
					end,
				},
				Badge = {
					name = function()
						if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[2]].Badge == true then
							Units.args[RUF.db.global.UnitList[i].name].args.IndicatorGroup.args[Indicators[2]].args.Badge.name = "|cFF00FF00"..L["Enable Badge"].."|r"
						else
							Units.args[RUF.db.global.UnitList[i].name].args.IndicatorGroup.args[Indicators[2]].args.Badge.name = "|cFFFF0000"..L["Enable Badge"].."|r"
						end
					end,
					type = "toggle",
					order = 0.1,
					hidden = j ~= 2,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Badge
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Badge = value
						RUF:UpdateFrames()
					end,
				},
				AlwaysShow = {
					name = L["Always Show"],
					type = "toggle",
					order = 0.2,
					hidden = j ~= 2,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].AlwaysShow
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].AlwaysShow = value
						RUF:UpdateFrames()
					end,
				},
				Spacer = {
					name = "",
					type = "description",
					order = 1,
					width = "full",
				},
				Size = {
					name = L["Size"],
					type = "range",
					order = 2,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 64,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Size = value
						RUF:UpdateFrames()
					end,
				},
				X = {
					type = "range",
					name = L["X Offset"],
					desc = L["Horizontal Offset from the Anchor."],
					order = 3,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.x = value
						RUF:UpdateFrames()
					end,
				},
				Y = {
					type = "range",
					name = L["Y Offset"],
					desc = L["Vertical Offset from the Anchor."],
					order = 4,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.y = value
						RUF:UpdateFrames()
					end,
				},
				Anchor_From = {
					type = "select",
					name = L["Anchor From"],
					desc = L["Location area of the Indicator to anchor from."],
					--width = "full",
					order = 5,
					values = {
						TOP = L["Top"],
						RIGHT = L["Right"],
						BOTTOM = L["Bottom"],
						LEFT = L["Left"],
						TOPRIGHT = L["Top-right"],
						TOPLEFT = L["Top-left"],
						BOTTOMRIGHT = L["Bottom-right"],
						BOTTOMLEFT = L["Bottom-left"],
						CENTER = L["Center"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrom
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrom = value
						RUF:UpdateFrames()
					end,
				},
				Anchor_Frame = {
					type = "select",
					name = L["Attach To"],
					desc = L["Choose an element to attach to, either the frame or another indicator."],
					values = IndicatorAnchors,
					order = 6,
					get = function(info)
						RUF:UpdateOptions()
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match("%S") ~= nil then
							if value == "Frame" then
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrame = "Frame"
							elseif RUF:CanAttach(_G[RUF.db.global.UnitList[i].frame.."."..Indicators[j].."Indicator"], _G[RUF.db.global.UnitList[i].frame.."."..value.."Indicator"]) then
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrame = "Frame"
							end
						else
							RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorFrame = "Frame"
						end
						RUF:UpdateFrames()
						RUF:UpdateOptions()
					end,
				},
				Anchor_To = {
					type = "select",
					name = L["Anchor To"],
					desc = L["Area on the anchor frame to anchor the indicator to."],
					order = 7,
					values = {
						TOP = L["Top"],
						RIGHT = L["Right"],
						BOTTOM = L["Bottom"],
						LEFT = L["Left"],
						TOPRIGHT = L["Top-right"],
						TOPLEFT = L["Top-left"],
						BOTTOMRIGHT = L["Bottom-right"],
						BOTTOMLEFT = L["Bottom-left"],
						CENTER = L["Center"],
					},
					get = function(info)
						return RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorTo
					end,
					set = function(info, value)
						RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Indicators[Indicators[j]].Position.AnchorTo = value
						RUF:UpdateFrames()
					end,
				},				
			}
		end
		
	end

	local bossdone, bosstargetdone, arenadone, arenatargetdone, partydone, partytargetdone
	for i=1,#RUF.db.global.UnitList  do		
		if RUF.db.global.UnitList[i].group == "boss" and bossdone ~= true then
			bossdone = true
			UnitArgs(RUF.db.global.UnitList[i].group, 51,i)
		elseif RUF.db.global.UnitList[i].group == "bosstarget" and bosstargetdone ~= true then
			bosstargetdone = true
			--UnitArgs(RUF.db.global.UnitList[i].group, 51,i)
		elseif RUF.db.global.UnitList[i].group == "arena" and arenadone ~= true then
			arenadone = true
			UnitArgs(RUF.db.global.UnitList[i].group, 51,i)
		elseif RUF.db.global.UnitList[i].group == "arenatarget" and arenatargetdone ~= true then
			arenatargetdone = true
			--UnitArgs(RUF.db.global.UnitList[i].group, 51,i)
		elseif RUF.db.global.UnitList[i].group == "party" and partydone ~= true then
			partydone = true
			UnitArgs(RUF.db.global.UnitList[i].group, 52,i)
		elseif RUF.db.global.UnitList[i].group == "partytarget" and partytargetdone ~= true then
			partytargetdone = true
			--UnitArgs(RUF.db.global.UnitList[i].group, 52,i)
		elseif RUF.db.global.UnitList[i].group == "" then -- SINGLE UNIT OPTIONS
			UnitArgs(RUF.db.global.UnitList[i].name, RUF.db.global.UnitList[i].order,i)
		end
	end

	return Units
end


local function AddOptions()
	--Options.args.Filtering = Filters()
	Options.args.Appearance.args.Colors = Colors()
	Options.args.Appearance.args.Bars = Bars()
	Options.args.Appearance.args.Texts = Texts()
	Options.args.Unit = Units()
end

function RUF_O:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RUFDB", RUF.Layout.cfg) -- Setup Saved Variables
	RUF:UpdateUnitSettings()
	
	-- Profile Management
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("RUF", Options)
	local Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	Options.args.profiles = Profiles
	Options.args.profiles.order = 99
	AddOptions()
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RUF", "RUF")
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("RUF",975,680)
	local LibDualSpec = LibStub('LibDualSpec-1.0')
	LibDualSpec:EnhanceDatabase(self.db, "RUF")
	LibDualSpec:EnhanceOptions(Profiles, self.db)
	InterfaceAddOnsList_Update()
	GuildRoster()
	RUF.db.char.GuildNum = GetNumGuildMembers()
	RUF.db.char.Guild = {}
	if RUF.db.char.GuildNum > 50 then RUF.db.char.GuildNum = 50 end
	if RUF.db.char.GuildNum > 0 then
		for i=1,RUF.db.char.GuildNum do
			local n = GetGuildRosterInfo(i)
			local c = select(11,GetGuildRosterInfo(i))
			RUF.db.char.Guild[i] = {["Name"] = string.gsub(n, "-.*", ""), ["Class"] = c}
		end
	else
		RUF.db.char.Guild[1] = {["Name"] = UnitName("player"), ["Class"] = PlayerClass}
	end
end

function RUF:UpdateOptions()
	Options.args.Appearance.args.Bars = Bars()
	Options.args.Appearance.args.Colors = Colors()
	Options.args.Appearance.args.Texts = Texts()
	Options.args.Unit = Units()
	LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF")
end

function RUF_O:RefreshConfig()
	RUF.db.profile = self.db.profile
	RUF:UpdateUnitSettings()
	RUF:UpdateFrames()
	RUF:UpdateAllAuras()
	RUF:UpdateOptions()
end


