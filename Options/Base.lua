local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')

function RUF_Options.MainOptions()
	local Options = {
		type = 'group',
		name = function(info)
			return "RUF [|c5500DBBDRaeli's Unit Frames|r] r|c5500DBBD" .. RUF.db.global.Version ..'|r'
		end,
		order = 0,
		childGroups = 'tab',
		args = {
			Appearance = {
				name = L["Global Appearance Options"],
				desc = L["These settings affect all frames."],
				type = 'group',
				childGroups = 'tab',
				order = 1,
				args = {
					FrameLock = {
						name = '|cff00B2FA'..L["Frame Lock"]..'|r',
						desc = L["Allow unit frames to be repositioned by dragging."],
						order = 0,
						type = 'toggle',
						get = function(info)
							return RUF.db.global.frameLock
						end,
						set = function(info, value)
							RUF.db.global.frameLock = value
							RUF.ToggleFrameLock(value == true)
						end,
					},
					TestMode = {
						name = '|cff00B2FA'..L["Test Mode"]..'|r',
						desc = L["Shows all unitframes so you can easily configure them."],
						order = 1,
						type = 'toggle',
						get = function(info)
							return RUF.db.global.TestMode
						end,
						set = function(info, value)
							RUF.db.global.TestMode = value
							RUF:TestMode()
							--RUF:UpdateFrames()
						end,
					},
					TestModeShowUnits = {
						name = '|cff00B2FA'..L["Show Unit in Test Mode."]..'|r',
						desc = L["Displays the name of the unit frame in test mode."],
						order = 2,
						type = 'toggle',
						get = function(info)
							return RUF.db.global.TestModeShowUnits
						end,
						set = function(info, value)
							RUF.db.global.TestModeShowUnits = value
							--RUF:UpdateFrames()
							RUF:TestMode()
						end,
					},
					Border = {
						name = L["Border"],
						type = 'group',
						order = 5,
						args = {
							Debuff = {
								name = L["Debuff Highlighting"],
								desc = L["Not Yet Implemented."],
								type = 'toggle',
								disabled = true,
								order = 0.01,
							},
							Texture = {
								name = L["Border Texture"],
								type = 'select',
								order = 0.02,
								values = LSM:HashTable('border'),
								dialogControl = 'LSM30_Border',
								get = function(info)
									return RUF.db.profile.Appearance.Border.Style.edgeFile
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Border.Style.edgeFile = value
								end,
							},
							Size = {
								name = L["Border Size"],
								type = 'range',
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
								end,
							},
							Alpha = {
								name = L["Alpha"],
								type = 'range',
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
								end,
							},
							Offset = {
								name = L["Offset"],
								type = 'range',
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
								end,
							},
							Color = {
								name = L["Base Color"],
								type = 'color',
								order = 0.04,
								get = function(info)
									return RUF.db.profile.Appearance.Border.Color[1], RUF.db.profile.Appearance.Border.Color[2],RUF.db.profile.Appearance.Border.Color[3]
								end,
								set = function(info,r,g,b)
									RUF.db.profile.Appearance.Border.Color[1] = r
									RUF.db.profile.Appearance.Border.Color[2] = g
									RUF.db.profile.Appearance.Border.Color[3] = b
								end,
							},
						},
					},
					Bars = {
						name = L["Bars"],
						type = 'group',
						order = 1,
						args = {},
					},
					Colors = {
						name = L["Colors"],
						type = 'group',
						order = 0,
						args = {},
					},
					Auras = {
						name = L["Auras"],
						type = 'group',
						order = 3,
						args = {
							Highlight = {
								name = L["Aura Highlighting"],
								type = 'header',
								order = 0,
							},
							DefaultBuff = {
								name = L["Default Buff Glow"],
								type = 'color',
								hasAlpha = true,
								order = 0.1,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultBuff)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.DefaultBuff = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DefaultDebuff = {
								name = L["Default Debuff Glow"],
								type = 'color',
								hasAlpha = true,
								order = 0.1,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DebuffMagic = {
								name = L["Magic"],
								type = 'color',
								hasAlpha = true,
								order = 0.2,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Magic)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Magic = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DebuffDisease = {
								name = L["Disease"],
								type = 'color',
								hasAlpha = true,
								order = 0.2,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Disease)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Disease = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DebuffCurse = {
								name = L["Curse"],
								type = 'color',
								hasAlpha = true,
								order = 0.2,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Curse)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Curse = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DebuffPoison = {
								name = L["Poison"],
								type = 'color',
								hasAlpha = true,
								order = 0.2,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Poison)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Poison = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							DebuffEnrage = {
								name = L["Enrage"],
								type = 'color',
								hasAlpha = true,
								order = 0.2,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Enrage)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Enrage = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							Buff = {
								name = L["Color Buffs by Type"],
								type = 'toggle',
								order = 10.1,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Buff
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Buff = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							Debuff = {
								name = L["Color Debuffs by Type"],
								type = 'toggle',
								order = 10.1,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Debuff
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Debuff = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							Dispellable = {
								name = L["Color only removable"],
								type = 'toggle',
								order = 10.2,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.OnlyDispellable
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.OnlyDispellable = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							BorderSpacer = {
								name = ' ',
								type = 'description',
								order = 10.5,
							},
							BorderTexture = {
								name = L["Highlight Texture"],
								type = 'select',
								order = 11,
								values = LSM:HashTable('border'),
								dialogControl = 'LSM30_Border',
								width = 'double',
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Border.Style.edgeFile
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Border.Style.edgeFile = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							BorderSize = {
								name = L["Highlight Thickness"],
								desc = L["Thickness of the highlight."],
								type = 'range',
								order = 11.1,
								min = -100,
								max = 100,
								softMin = -20,
								softMax = 20,
								step = 0.01,
								bigStep = 0.05,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Border.Style.edgeSize
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Border.Style.edgeSize = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							BorderOffset = {
								name = L["Highlight Inset"],
								desc = L["Size relative to the aura icon."],
								type = 'range',
								order = 11.2,
								min = -100,
								max = 100,
								softMin = -30,
								softMax = 30,
								step = 1,
								bigStep = 1,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Border.Offset
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Border.Offset = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							Pixel = {
								name = L["Border"],
								type = 'header',
								order = 15,
							},
							Enabled = {
								name = L["Enabled"],
								type = 'toggle',
								order = 15.1,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Pixel.Enabled
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Pixel.Enabled = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							PixelColor = {
								name = L["Border Color"],
								type = 'color',
								hasAlpha = true,
								order = 16,
								get = function(info)
									return unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
								end,
								set = function(info, r,g,b,a)
									RUF.db.profile.Appearance.Colors.Aura.Pixel = {r,g,b,a}
									RUF:OptionsUpdateAllAuras()
								end,
							},
							PixelTexture = {
								name = L["Border Texture"],
								type = 'select',
								order = 16.1,
								values = LSM:HashTable('border'),
								dialogControl = 'LSM30_Border',
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							PixelSize = {
								name = L["Border Size"],
								type = 'range',
								order = 16.1,
								min = -100,
								max = 100,
								softMin = -20,
								softMax = 20,
								step = 0.01,
								bigStep = 0.05,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
							PixelOffset = {
								name = L["Offset"],
								type = 'range',
								order = 16.2,
								min = -100,
								max = 100,
								softMin = -30,
								softMax = 30,
								step = 1,
								bigStep = 1,
								get = function(info)
									return RUF.db.profile.Appearance.Aura.Pixel.Offset
								end,
								set = function(info, value)
									RUF.db.profile.Appearance.Aura.Pixel.Offset = value
									RUF:OptionsUpdateAllAuras()
								end,
							},
						},
					},
				},
			},
			Unit = {
				name = L["Unit Options"],
				type = 'group',
				order = 2,
				args = {

				},
			},
			Filtering = {
				name = L["Filtering"],
				type = 'group',
				order = 3,
				hidden = true,
				args = {

				},
			},
			Feedback = {
				name = L["Feedback"],
				type = 'group',
				order = 1000,
				args = {
					Head = {
						name = L["Feedback"],
						type = 'header',
						order = 0,
					},
					Revision = {
						name = "|cffFFCC00" .. L["Current Version: %s"]:format("r|r|c5500DBBD" .. RUF.db.global.Version) .. "|r",
						type = 'description',
						order = 0.5,
						fontSize = 'large',
					},
					RevisionDescription = {
						name = L["When reporting an issue, please also post the revision number above. Thanks!"],
						type = 'description',
						order = 0.6,
					},
					Spacer_FeedbackOnline = {
						name = '\n',
						type = 'description',
						order = 1,
					},
					Curseforge_Header = {
						name = '|cff91BE0F'..L["Curseforge"]..'|r',
						type = 'description',
						order = 50,
						fontSize = 'large',
					},
					Curseforge_URL = {
						name = L["URL"],
						type = 'input',
						order = 50.2,
						width = 'full',
						get = function() return 'https://wow.curseforge.com/projects/ruf/issues' end,
						set = function() return 'https://wow.curseforge.com/projects/ruf/issues' end,
					},
					Spacer_OnlineCommunity = {
						name = '\n\n',
						type = 'description',
						order = 75,
					},
					Community_Header = {
						name = '|cff00B2FA'..L["Discord"]..'|r',
						type = 'description',
						order = 100,
						fontSize = 'large',
					},
					Community_URL = {
						name = L["Invite Link"],
						type = 'input',
						order = 100.2,
						width = 'full',
						get = function() return 'https://discord.gg/99QZ6sd' end,
						set = function() return 'https://discord.gg/99QZ6sd' end,
					},
				},
			},
		},
	}
	return Options
end