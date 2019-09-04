local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')

local tagList = {}
local localisedTags = {}
local tagInputs = {}
local frames = {}
local groupFrames = {}

local function UnitGroup(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end
	local referenceUnit = profileName
	if groupFrame == 'Party' then
		referenceUnit = profileName .. 'UnitButton1'
	elseif groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	local passUnit = profileName
	profileName = string.lower(profileName)
	groupFrame = string.lower(groupFrame)

	local frameOptions = {
		name = L[profileName],
		type = 'group',
		childGroups = 'tab',
		order = ord,
		args = {
			frameSettings = {
				name = L["Frame"],
				type = 'group',
				childGroups = 'tab',
				order = 0,
				args = {
					nickName = {
						type = 'input',
						name = L["Nickname"],
						desc = L["This syncs with other addons that support NickTag-1.0 such as Details!"],
						width = 'full',
						hidden = function() return (profileName ~= 'player') end,
						order = 0.0,
						multiline = false,
						validate = function(info, value)
							local trimString = string.match(value,"^%s*(.-)%s*$")
							local valid = RUF:NickValidator(trimString)
							if valid == true then return true end
							if valid == 'Length' then return L["Nickname cannot be more than 12 characters long."] end
							if valid == 'Letters' then return L["Nickname can only contain letters and spaces."] end
							if valid == 'Spaces' then return L["Nickname cannot have repeating spaces or more than two total spaces."] end
						end,
						get = function(info)
							return RUF.db.char.Nickname
						end,
						set = function(info, value)
							local trimString = string.match(value,"^%s*(.-)%s*$")
							local toStore = trimString
							if string.len(trimString) < 1 then
								toStore = UnitName('Player')
							end
							RUF:SetNickname(toStore)
							if toStore ~= UnitName('Player') then
								RUF.db.char.Nickname = toStore
							else
								RUF.db.char.Nickname = ""
							end
						end,
					},
					enabled = {
						name = function()
							if RUF.db.profile.unit[profileName].Enabled == true then
								return '|cFF00FF00'..L["Enabled"]..'|r'
							else
								return '|cFFFF0000'..L["Enabled"]..'|r'
							end
						end,
						desc = L["Enable the Unit Frame."],
						type = 'toggle',
						order = 0.004,
						disabled = function() return (profileName == 'Player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].Enabled
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Enabled = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
							RUF:UpdateOptions()
						end,
					},
					enabledSpacer = {
						name = ' ',
						type = 'description',
						order = 0.005,
						width = 'full',
					},
					rangeFading = {
						name = L["Fade out of Range"],
						desc = L["Fade the unit frame it the target is out of range of your spells."],
						type = 'toggle',
						order = 0.01,
						disabled = true, -- IMPLEMENT THIS FUNCTIONALITY
						hidden = function() return (profileName == 'player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.RangeFading.Enabled
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.RangeFading.Enabled = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					rangeFadingAlpha = {
						name = L["Alpha"],
						desc = L["Out of Range transparency"],
						type = 'range',
						order = 0.02,
						min = 0,
						max = 1,
						softMin = 0,
						softMax = 1,
						step = 0.1,
						bigStep = 0.1,
						disabled = true, -- IMPLEMENT THIS FUNCTIONALITY
						hidden = function() return (profileName == 'player') end,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.RangeFading.Alpha
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.RangeFading.Alpha = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameWidth = {
						name = L["Width"],
						type = 'range',
						order = 0.03,
						min = 50,
						max = 750,
						softMin = 100,
						softMax = 400,
						step = 1,
						bigStep = 10,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Size.Width
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Size.Width = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameHeight = {
						name = L["Height"],
						type = 'range',
						order = 0.04,
						min = 10,
						max = 300,
						softMin = 20,
						softMax = 100,
						step = 1,
						bigStep = 5,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Size.Height
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Size.Height = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameHeightSpacer = {
						name = ' ',
						type = 'description',
						order = 0.05,
						width = 'full',
					},
					frameAnchor = {
						type = 'input',
						name = L["Anchor Frame"],
						desc = L["The name of the frame for the unit to anchor to. Defaults to UI Parent if set blank."],
						multiline = false,
						order = 0.06,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame
						end,
						set = function(info, value)
							if value ~= nil and value:match('%S') ~= nil then
								if _G[value] then
									if RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit], _G[value]) then
										RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = value
									end
								else
									RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = 'UIParent'
								end
							else
								RUF.db.profile.unit[profileName].Frame.Position.AnchorFrame = 'UIParent'
							end
							RUF:UpdateOptions()
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameHorizontal = {
						type = 'range',
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
							return RUF.db.profile.unit[profileName].Frame.Position.x
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.x = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameVertical = {
						type = 'range',
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
							return RUF.db.profile.unit[profileName].Frame.Position.y
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.y = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameAnchorPoint = {
						type = 'select',
						name = L["Anchor From"],
						desc = L["Location area of the Unitframe to anchor from."],
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
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorFrom
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.AnchorFrom = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameAnchorTo = {
						type = 'select',
						name = L["Anchor To"],
						desc = L["Area on the anchor frame to anchor the unitframe to."],
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
							return RUF.db.profile.unit[profileName].Frame.Position.AnchorTo
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.AnchorTo = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					frameAnchorToSeparator = {
						name = ' ',
						type = 'description',
						order = 0.095,
						width = 'full',
					},
					groupFrameGrowthDirection = {
						type = 'select',
						name = L["Growth Direction"],
						desc = L["Grow up or down."],
						hidden = groupFrame ~= 'boss' or groupFrame ~= 'arena' or groupFrame ~= 'bosstarget' or groupFrame ~= 'arenatarget',
						order = 0.1,
						values = {
							TOP = L["Up"],
							BOTTOM = L["Down"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growth
						end,
						set = function(info, value)

							if RUF.db.profile.unit[profileName].Frame.Position.growth ~= value then
								if RUF.db.profile.unit[profileName].Frame.Position.offsety > 0 then
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - RUF.db.profile.unit[profileName].Frame.Position.offsety
								else
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - (RUF.db.profile.unit[profileName].Frame.Position.offsety)
								end
							end

							RUF.db.profile.unit[profileName].Frame.Position.growth = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
							RUF:UpdateOptions()
						end,
					},
					partyFrameSortOrder = {
						type = 'select',
						name = L["Sort Direction"],
						hidden = groupFrame ~= 'party',
						order = 0.1,
						values = {
							TOP = L["Up"],
							BOTTOM = L["Down"],
						},
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.growth
						end,
						set = function(info, value)

							if RUF.db.profile.unit[profileName].Frame.Position.growth ~= value then
								if RUF.db.profile.unit[profileName].Frame.Position.offsety > 0 then
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - RUF.db.profile.unit[profileName].Frame.Position.offsety
								else
									RUF.db.profile.unit[profileName].Frame.Position.offsety = 0 - (RUF.db.profile.unit[profileName].Frame.Position.offsety)
								end
							end
							RUF.db.profile.unit[profileName].Frame.Position.growth = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
							RUF:UpdateOptions()
						end,
					},
					groupFrameHorizontalOffset = {
						type = 'range',
						name = L["X Spacing"],
						desc = L["Horizontal Offset from the previous unit in the group."],
						hidden = groupFrame == 'none',
						order = 0.11,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.offsetx
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.offsetx = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
					groupFrameVerticalOffset = {
						type = 'range',
						name = L["Y Spacing"],
						desc = L["Vertical Offset from the previous unit in the group."],
						hidden = groupFrame == 'none',
						order = 0.12,
						min = -5000,
						max = 5000,
						softMin = -1000,
						softMax = 1000,
						step = 0.5,
						bigStep = 1,
						get = function(info)
							return RUF.db.profile.unit[profileName].Frame.Position.offsety
						end,
						set = function(info, value)
							RUF.db.profile.unit[profileName].Frame.Position.offsety = value
							RUF:OptionsUpdateFrame(passUnit,groupFrame)
						end,
					},
				},
			},
		},
	}

	return frameOptions
end

local function BarSettings(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end
	local referenceUnit = profileName
	if groupFrame == 'Party' then
		referenceUnit = profileName .. 'UnitButton1'
	elseif groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	local passUnit = profileName
	profileName = string.lower(profileName)
	groupFrame = string.lower(groupFrame)

	local barOptions = {
		name = L["Bars"],
		type = 'group',
		childGroups = 'tab',
		order = 10,
		args = {
			Health = {
				name = L["Health"],
				type = 'group',
				order = 10,
				args = {
				},
			},
			Power = {
				name = L["Power"],
				type = 'group',
				order = 15,
				args = {

				},
			},
			Class = {
				name = L["Class"],
				type = 'group',
				order = 20,
				hidden = function() return (profileName ~= 'player') or (RUF.Client ~= 1) end,
				args = {

				},
			},
			Absorb = {
				name = L["Absorb"],
				type = 'group',
				order = 25,
				hidden = RUF.Client ~= 1,
				args = {

				},
			},
		},
	}

	local barList = {
		[1] = 'Health',
		[2] = 'Class',
		[3] = 'Power',
		[4] = 'Absorb',
	}

	for i = 1,#barList do
		barOptions.args[barList[i]].args = {
			displayStyleAbsorbPower = {
				name = L["Display Style"],
				type = 'select',
				order = 0,
				hidden = i < 3,
				values = {
					[0] = L["Always Hidden"],
					[1] = L["Hidden at 0"],
					[2] = L["Always Visible"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled = value
					RUF:OptionsUpdateBars(passUnit,groupFrame,barList[i])
				end,
			},
			classEnabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0,
				hidden = i ~= 2,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Enabled = value
					RUF:OptionsUpdateBars(passUnit,groupFrame,barList[i])
				end,
			},
			fillStyle = {
				name = L["Fill Type"],
				type = 'select',
				order = 1,
				values = function()
					local table = {}
					if i == 2 then
						table = {
							['STANDARD'] = L["Standard"],
							['REVERSE'] = L["Reverse"],
						}
					else
						table = {
							['STANDARD'] = L["Standard"],
							['REVERSE'] = L["Reverse"],
							['CENTER'] = L["Center"],
						}
					end
					return table
				end,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Fill
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Fill = value
					RUF:OptionsUpdateBars(passUnit,groupFrame,barList[i])
				end,
			},
			barHeight = {
				name = L["Height"],
				type = 'range',
				order = 0.04,
				hidden = i == 1,
				disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and i == 4 then return true end end,
				min = 2,
				max = 100,
				softMin = 4,
				softMax = 30,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Height
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Height = value
					RUF:OptionsUpdateBars(passUnit,groupFrame,barList[i])
				end,
			},
			barAnchor = {
				type = 'select',
				name = L["Anchor"],
				order = 0.05,
				hidden = i == 1,
				disabled = function() if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 and i == 4 then return true end end,
				values = {
					['TOP'] = L["Top"],
					['BOTTOM'] = L["Bottom"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Position.Anchor
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Frame.Bars[barList[i]].Position.Anchor = value

					if profileName == 'player' then
						if RUF.db.profile.unit[profileName].Frame.Bars.Class.Position.Anchor == RUF.db.profile.unit[profileName].Frame.Bars.Power.Position.Anchor then
							local otherBar
							if i == 2 then otherBar = barList[3] elseif i == 3 then otherBar = barList[2] end
							if value == 'TOP' then
								RUF.db.profile.unit[profileName].Frame.Bars[otherBar].Position.Anchor = 'BOTTOM'
							else
								RUF.db.profile.unit[profileName].Frame.Bars[otherBar].Position.Anchor = 'TOP'
							end

						end
					end
					RUF:OptionsUpdateBars(passUnit,groupFrame,barList[i])
				end,
			},
		}
	end

	return barOptions
end

local function TextSettings(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end

	-- Generate list of units we can copy text elements from
	local copyList = {}
	if RUF.Client == 1 then
		copyList = {
			['Player'] = L["player"],
			['Pet'] = L["pet"],
			['PetTarget'] = L["pettarget"],
			['Focus'] = L["focus"],
			['FocusTarget'] = L["focustarget"],
			['Target'] = L["target"],
			['TargetTarget'] = L["targettarget"],
			['Boss'] = L["boss"],
			--['BossTarget'] = L["bosstarget"],
			['Arena'] = L["arena"],
			--['ArenaTarget'] = L["arenatarget"],
			['Party'] = L["party"],
		}
	else
		copyList = {
			['Player'] = L["player"],
			['Pet'] = L["pet"],
			['PetTarget'] = L["pettarget"],
			['Target'] = L["target"],
			['TargetTarget'] = L["targettarget"],
			['Party'] = L["party"],
		}
	end
	copyList[profileName] = nil
	copyList[groupFrame] = nil

	local referenceUnit = profileName
	if groupFrame == 'Party' then
		referenceUnit = profileName .. 'UnitButton1'
	elseif groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	local passUnit = profileName
	profileName = string.lower(profileName)
	groupFrame = string.lower(groupFrame)

	local textOptions = {
		name = L["Texts"],
		type = 'group',
		childGroups = 'select',
		order = 20,
		args = {
			addTextElement = {
				name = L["Add Text Area"],
				type = 'input',
				desc = L["Add a Text Area for this unit with this name."],
				order = 0.0,
				set = function(info, value)
					if RUF.db.profile.unit[profileName].Frame.Text[value] then
						if RUF.db.profile.unit[profileName].Frame.Text[value] ~= '' then
							RUF:Print_Self(L["A text area with that name already exists!"])
							return
						end
					end
					RUF.db.profile.unit[profileName].Frame.Text[value] = {
						Font = 'RUF',
						Outline = 'OUTLINE',
						Shadow = 0,
						Tag = value,
						Enabled = true,
						Size = 21,
						Width = 100,
						Position = {
							x = 0,
							y = 0,
							AnchorFrame = 'Frame',
							Anchor = 'CENTER',
						},
					}
					RUF:OptionsAddTexts(passUnit,groupFrame,value)
					RUF:UpdateOptions()
				end,
			},
			removeTextElement = {
				name = L["Remove Text Area"],
				type = 'input',
				desc = L["Remove Text Area from this unit with this name."],
				order = 0.1,
				set = function(info, value)
					if not RUF.db.profile.unit[profileName].Frame.Text[value] then return end --TODO Error Message
					if RUF.db.profile.unit[profileName].Frame.Text[value] == '' then return end
					RUF.db.profile.unit[profileName].Frame.Text[value] = 'DISABLED'
					RUF:OptionsDisableTexts(passUnit,groupFrame,value)
					RUF.db.profile.unit[profileName].Frame.Text[value] = ''
					RUF:UpdateOptions()
				end,
			},
			copyUnit = {
				name = 'Copy Settings from:',
				type = 'select',
				desc = 'Copy and replace all text elements from the selected unit to this unit.',
				order = 0.2,
				values = copyList,
				confirm = function() return 'Are you sure you want to replace these settings? You cannot undo this change?' end,
				set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text = nil
						RUF.db.profile.unit[profileName].Frame.Text = RUF.db.profile.unit[string.lower(value)].Frame.Text
						RUF:UpdateAllUnitSettings()
						RUF:UpdateOptions()
				end,
			},
		},
	}


	-- Generate list of text elements
	local textList = {}
	for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
		if v ~= '' then
			table.insert(textList,k)
		end
	end

	-- For each text element, generate a list of valid anchor elements.
	for i = 1,#textList do
		local textAnchors = {}
		textAnchors['Frame'] = 'Frame'
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
			if v ~= '' then
				if k ~= textList[i] then
					if RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit].Text[textList[i]].String,_G['oUF_RUF_' .. referenceUnit].Text[k].String) then
						textAnchors[k] = k
					end
				end
			end
		end

		textOptions.args[textList[i]] = {
			name = textList[i],
			type = 'group',
			order = 10,
			args = {
				enabled = {
					name = function()
						if RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled == true then
							return '|cFF00FF00'..L["Enabled"]..'|r'
						else
							return '|cFFFF0000'..L["Enabled"]..'|r'
						end
					end,
					type = 'toggle',
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Enabled = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])

					end,
				},
				tag = {
					name = L["Tag"],
					type = 'select',
					order = 0.01,
					values = tagInputs,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Tag
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Tag = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				tagSpacer = {
					name = ' ',
					type = 'description',
					order = 0.02,
					width = 'full',
				},
				offsetX = {
					name = L["X Offset"],
					type = 'range',
					desc = L["Horizontal Offset from the Anchor."],
					order = 0.03,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.x = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				offsetY = {
					name = L["Y Offset"],
					type = 'range',
					desc = L["Vertical Offset from the Anchor."],
					order = 0.04,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.y = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				textWidth = {
					name = L["Max Width"],
					type = 'range',
					desc = L["Limit text width."],
					type = 'range',order = 0.05,
					hidden = true,
					min = 0,
					max = 750,
					softMin = 10,
					softMax = RUF.db.profile.unit[profileName].Frame.Size.Width,
					step = 1,
					bigStep = 10,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Width
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Width = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				anchorFrame = {
					name = L["Attach To"],
					type = 'select',
					desc = L["Choose an element to attach to, either the frame or another text area."],
					order = 0.06,
					values = textAnchors,
					get = function(info)
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match('%S') ~= nil then
							if value == 'Frame' then
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
							elseif RUF:CanAttach(
								_G['oUF_RUF_' .. referenceUnit].Text[textList[i]].String,
								_G['oUF_RUF_' .. referenceUnit].Text[value].String) then
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
							end
						else
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.AnchorFrame = 'Frame'
						end
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				anchorPoint = {
					name = L["Anchor To"],
					type = 'select',
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
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Position.Anchor = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				font = {
					name = L["Font"],
					type = 'select',
					order = 10,
					values = LSM:HashTable('font'),
					dialogControl = 'LSM30_Font',
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Font
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Font = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				fontSize = {
					name = L["Font Size"],
					type = 'range',
					order = 10,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 48,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Size = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				fontOutline = {
					name = L["Outline"],
					type = 'select',
					order = 10,
					values = {
						[''] = L["None"],
						['OUTLINE'] = L["Outline"],
						['THICKOUTLINE'] = L["Thick Outline"],
						['MONOCHROME'] = L["Monochrome"],
						['MONOCHROME,OUTLINE'] = L["Monochrome Outline"],
						['MONOCHROME,THICKOUTLINE'] = L["Monochrome Thick Outline"],
					},
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Outline
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Outline = value
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},
				fontShadow = {
					name = L["Shadow"],
					type = 'toggle',
					desc = L["Enable Text Shadow"],
					order = 10,
					get = function(info)
						if RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow == 1 then
							return true
						else
							return false
						end
					end,
					set = function(info, value)
						if value == true then
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow = 1
						else
							RUF.db.profile.unit[profileName].Frame.Text[textList[i]].Shadow = 0
						end
						RUF:OptionsUpdateTexts(passUnit,groupFrame,textList[i])
					end,
				},

			},
		}

	end

	return textOptions
end

local function HideIndicatorOptions(profileName,indicator)
	if RUF.Client == 1 and indicator == 'LootMaster' then return true end
	if (indicator == 'InCombat' or indicator == 'Rest') and profileName ~= 'player' then return true end
	if profileName == 'pet' then
		if indicator == 'Objective' or indicator == 'Phased' or indicator == 'Role' or indicator == 'Honor' then
			return true
		end
	elseif profileName == 'boss' then
		if indicator == 'Phased' or indicator == 'Objective' or indicator == 'TargetMark' then
			return false
		else
			return true
		end
	elseif profileName == 'arena' then
		if indicator == 'Assist' or indicator == 'Lead' or indicator == 'MainTankAssist' or indicator == 'Objective' or indicator == 'Ready' then
			return true
		end
	end
end

local function IndicatorSettings(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end
	local referenceUnit = profileName
	if groupFrame == 'Party' then
		referenceUnit = profileName .. 'UnitButton1'
	elseif groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	local passUnit = profileName
	profileName = string.lower(profileName)
	groupFrame = string.lower(groupFrame)

	local indicators = {
		[1] = 'Assist',
		[2] = 'Honor',
		[3] = 'InCombat',
		[4] = 'Lead',
		[5] = 'LootMaster',
		[6] = 'MainTankAssist',
		[7] = 'Phased',
		[8] = 'PvPCombat',
		[9] = 'Objective',
		[10] = 'Ready',
		[11] = 'Rest',
		[12] = 'Role',
		[13] = 'TargetMark',
	}

	local indicatorOptions = {
		name = L["Indicators"],
		type = 'group',
		order = 30,
		args = {
		},
	}

	for i = 1,#indicators do
		local currentIndicator = indicators[i] .. 'Indicator'
		local indicatorAnchors = {}
		indicatorAnchors['Frame'] = 'Frame'
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Indicators) do
			if v ~= '' then
				if k ~= indicators[i] then
					local targetIndicator = k..'Indicator'
					if RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit][currentIndicator],_G['oUF_RUF_' .. referenceUnit][targetIndicator]) then
						indicatorAnchors[k] = k
					end
				end
			end
		end
		indicatorOptions.args[indicators[i]] = {
			name = L[indicators[i]],
			type = 'group',
			order = 0, -- TODO or leave as whatever?
			hidden = HideIndicatorOptions(profileName, indicators[i]),
			args = {
				enabled = {
					name = function()
						if RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled == true then
							return '|cFF00FF00'..L["Enabled"]..'|r'
						else
							return '|cFFFF0000'..L["Enabled"]..'|r'
						end
					end,
					type = 'toggle',
					order = 0,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Enabled = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
				enabledSpacer = {
					name = '',
					type = 'description',
					order = 1,
					width = 'full',
				},
				indicatorSize = {
					name = L["Size"],
					type = 'range',
					order = 2,
					min = 4,
					max = 256,
					softMin = 8,
					softMax = 64,
					step = 1,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Size
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Size = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
				offsetX = {
					name = L["X Offset"],
					type = 'range',
					desc = L["Horizontal Offset from the Anchor."],
					order = 3,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.x
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.x = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
				offsetY = {
					name = L["Y Offset"],
					type = 'range',
					desc = L["Vertical Offset from the Anchor."],
					order = 4,
					min = -500,
					max = 500,
					softMin = -100,
					softMax = 100,
					step = 0.5,
					bigStep = 1,
					get = function(info)
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.y
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.y = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
				anchorFrom = {
					name = L["Anchor From"],
					type = 'select',
					desc = L["Location area of the Indicator to anchor from."],
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
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrom
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrom = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
				anchorFrame = {
					name = L["Attach To"],
					type = 'select',
					desc = L["Choose an element to attach to, either the frame or another indicator."],
					values = indicatorAnchors,
					order = 6,
					get = function(info)
						RUF:UpdateOptions()
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame
					end,
					set = function(info, value)
						if value ~= nil and value:match('%S') ~= nil then
							if value == 'Frame' then
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
							elseif RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit][currentIndicator], _G['oUF_RUF_' .. referenceUnit][value..'Indicator']) then
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = value
							else
								RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
							end
						else
							RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorFrame = 'Frame'
						end
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
						RUF:UpdateOptions()
					end,
				},
				anchorPoint = {
					name = L["Anchor To"],
					type = 'select',
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
						return RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorTo
					end,
					set = function(info, value)
						RUF.db.profile.unit[profileName].Frame.Indicators[indicators[i]].Position.AnchorTo = value
						RUF:OptionsUpdateIndicators(passUnit,groupFrame,indicators[i])
					end,
				},
			},
		}
	end
	return indicatorOptions
end

local function BuffSettings(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end
	local referenceUnit = profileName
	if groupFrame == 'Party' then
		referenceUnit = profileName .. 'UnitButton1'
	elseif groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	profileName = string.lower(profileName)

	local buffOptions = {
		name = L["Buffs"],
		type = 'group',
		order = 40,
		args = {
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Buffs.Icons.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Enabled = value
					RUF:UpdateAuras(profileName)
					-- TODO UpdateAuras function. Just resetting all auras should work maybe?
					-- Since the settings for an aura is updated when it is refreshed or a new one is applied
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 1,
				width = 'full',
			},
			buffSize = {
				name = L["Size"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Size
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Size = value
					RUF:UpdateAuras(profileName)
				end,
			},
			numRows = {
				name = L["Rows"],
				type = 'range',
				hidden = true, -- Why? I don't remember. Check it out.
				order = 3,
				min = 1,
				max = 32,
				softMin = 1,
				softMax = 8,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Rows
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Rows = value
					RUF:UpdateAuras(profileName)
				end,
			},
			numColumns = {
				name = L["Columns"],
				type = 'range',
				order = 3,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Columns
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Columns = value
					RUF:UpdateAuras(profileName)
				end,
			},
			horizontalPadding = {
				name = L["Horizontal Spacing"],
				type = 'range',
				order = 3.1,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalPadding = {
				name = L["Vertical Spacing"],
				type = 'range',
				order = 3.2,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Spacing.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			horizontalGrowthDirection = {
				type = 'select',
				name = L["Horizontal Growth"],
				order = 3.3,
				values = {
					RIGHT = L["Right"],
					LEFT = L["Left"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Growth.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Growth.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalGrowthDirection = {
				type = 'select',
				name = L["Vertical Growth"],
				order = 3.3,
				values = {
					DOWN = L["Down"],
					UP = L["Up"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Growth.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Growth.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			sortingHeader = {
				name = L["Sorting"],
				type = 'header',
				order = 3.5,
				hidden = true,
			},
			sortDirection = {
				name = L["Direction"],
				type = 'select',
				hidden = true, -- Why?
				order = 4,
				values = {
					Ascending = L["Ascending"],
					Descending = L["Descending"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Sort.Direction
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Sort.Direction = value
					RUF:UpdateAuras(profileName)
				end,
			},
			sortType = {
				type = 'select',
				name = L["Sort By"],
				hidden = true, -- Why? NYI? Check it.
				order = 4,
				values = {
					Alphabetically = L["Alphabetically"],
					Duration = L["Duration"],
					Index = L["Index"],
					Player = L["Player"],
					Remaining = L["Time Remaining"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Sort.SortBy
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Sort.SortBy = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorHeader = {
				name = L["Anchoring"],
				type = 'header',
				order = 4.5,
			},
			horizontalOffset = {
				name = L["X Offset"],
				type = 'range',
				desc = L["Horizontal Offset from the Anchor."],
				order = 5,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalOffset = {
				name = L["Y Offset"],
				type = 'range',
				desc = L["Vertical Offset from the Anchor."],
				order = 6,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorFrom = {
				name = L["Anchor From"],
				type = 'select',
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
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrom
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrom = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorFrame = {
				name = L["Attach To"],
				type = 'select',
				desc = L["Choose an element to attach to, either the frame or another indicator."],
				hidden = true,
				values = {
					Frame = L["Frame"],
					DebuffIcons = L["Debuff Icons"],
				},
				order = 8,
				get = function(info)
					RUF:UpdateOptions()
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrame
				end,
				set = function(info, value)
					if value ~= nil and value:match('%S') ~= nil then
						if value == 'Frame' then
							RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrame = 'Frame'

						elseif RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit]['Buffs'], _G['oUF_RUF_' .. referenceUnit]['Debuffs']) then
							RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrame = value
						else
							RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrame = 'Frame'
							-- TODO Pop up to confirm force anchoring Debuffs back to frame, so we can anchor buffs to debuffs.
						end
					else
						RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorFrame = 'Frame'
					end
					RUF:UpdateAuras(profileName)
					RUF:UpdateOptions()
				end,
			},
			anchorPoint = {
				name = L["Anchor To"],
				type = 'select',
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
					return RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorTo
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Position.AnchorTo = value
					RUF:UpdateAuras(profileName)
				end,
			},
			clickThrough = {
				name = L["Click Through"],
				type = 'toggle',
				order = 8,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.ClickThrough
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.ClickThrough = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterHeader = {
				name = L["Filtering"],
				type = 'header',
				order = 10.5,
			},
			filterCasterByPlayer = {
				name = L["Show Player"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["Player"]),
				order = 15,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Player
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Player = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByCurrentUnit = {
				name = L["Show %s"]:format(L[profileName]),
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L[profileName]),
				hidden = profileName == 'player',
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Unit
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Unit = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByGroupUnits = {
				name = L["Show Group Members"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["group members"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Group
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Group = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByOtherUnits = {
				name = L["Show Others"],
				type = 'toggle',
				desc = L["Show buffs cast by %s on this unit."]:format(L["others"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Other
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Caster.Other = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterSpacer = {
				name = ' ',
				type = 'description',
				order = 17,
				width = 'full',
			},
			minDuration = {
				name = L["Minimum Duration"],
				type = 'range',
				order = 20,
				min = 0,
				max = 3600,
				softMin = 0,
				softMax = 360,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Min
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Min = value
					RUF:UpdateAuras(profileName)
				end,
			},
			maxDuration = {
				name = L["Maximum Duration"],
				type = 'range',
				order = 21,
				min = 0,
				max = 86400,
				softMin = 0,
				softMax = 3600,
				step = 0.5,
				bigStep = 5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Max = value
					RUF:UpdateAuras(profileName)
				end,
			},
			toggleDurationLimit = {
				name = L["Show Unlimited Duration"],
				type = 'toggle',
				order = 22,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Unlimited
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Time.Unlimited = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterDispellable = {
				name = L["Show Only Dispellable"],
				type = 'toggle',
				desc = L["Show only auras you can dispel"],
				order = 23,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Dispellable
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Filter.Dispellable = value
					RUF:UpdateAuras(profileName)
				end,
			},
			maxAuras = {
				name = L["Max Auras"],
				type = 'range',
				order = 24,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Buffs.Icons.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Buffs.Icons.Max = value
					RUF:UpdateAuras(profileName)
				end,
			},
		},
	}

	return buffOptions
end

local function DebuffSettings(profileName,groupFrame)
	if not groupFrame then groupFrame = 'none' end
	local ord = 99
	for i=1,#frames do
		if frames[i] == profileName then
			ord = i
		end
	end
	local referenceUnit = profileName
	if groupFrame ~= 'none' then
		referenceUnit = profileName .. '1'
	end
	profileName = string.lower(profileName)

	local debuffOptions = {
		name = L["Debuffs"],
		type = 'group',
		order = 40,
		args = {
			enabled = {
				name = function()
					if RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled == true then
						return '|cFF00FF00'..L["Enabled"]..'|r'
					else
						return '|cFFFF0000'..L["Enabled"]..'|r'
					end
				end,
				type = 'toggle',
				order = 0,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Enabled = value
					RUF:UpdateAuras(profileName)
					-- TODO UpdateAuras function. Just resetting all auras should work maybe?
					-- Since the settings for an aura is updated when it is refreshed or a new one is applied
				end,
			},
			enabledSpacer = {
				name = ' ',
				type = 'description',
				order = 1,
				width = 'full',
			},
			debuffSize = {
				name = L["Size"],
				type = 'range',
				order = 2,
				min = 4,
				max = 64,
				softMin = 12,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Size
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Size = value
					RUF:UpdateAuras(profileName)
				end,
			},
			numRows = {
				name = L["Rows"],
				type = 'range',
				hidden = true, -- Why? I don't remember. Check it out.
				order = 3,
				min = 1,
				max = 32,
				softMin = 1,
				softMax = 8,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Rows
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Rows = value
					RUF:UpdateAuras(profileName)
				end,
			},
			numColumns = {
				name = L["Columns"],
				type = 'range',
				order = 3,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Columns
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Columns = value
					RUF:UpdateAuras(profileName)
				end,
			},
			horizontalPadding = {
				name = L["Horizontal Spacing"],
				type = 'range',
				order = 3.1,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalPadding = {
				name = L["Vertical Spacing"],
				type = 'range',
				order = 3.2,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Spacing.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			horizontalGrowthDirection = {
				type = 'select',
				name = L["Horizontal Growth"],
				order = 3.3,
				values = {
					RIGHT = L["Right"],
					LEFT = L["Left"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalGrowthDirection = {
				type = 'select',
				name = L["Vertical Growth"],
				order = 3.3,
				values = {
					DOWN = L["Down"],
					UP = L["Up"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Growth.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			sortingHeader = {
				name = L["Sorting"],
				type = 'header',
				order = 3.5,
				hidden = true,
			},
			sortDirection = {
				name = L["Direction"],
				type = 'select',
				hidden = true, -- Why?
				order = 4,
				values = {
					Ascending = L["Ascending"],
					Descending = L["Descending"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.Direction
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.Direction = value
					RUF:UpdateAuras(profileName)
				end,
			},
			sortType = {
				type = 'select',
				name = L["Sort By"],
				hidden = true, -- Why? NYI? Check it.
				order = 4,
				values = {
					Alphabetically = L["Alphabetically"],
					Duration = L["Duration"],
					Index = L["Index"],
					Player = L["Player"],
					Remaining = L["Time Remaining"],
				},
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.SortBy
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Sort.SortBy = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorHeader = {
				name = L["Anchoring"],
				type = 'header',
				order = 4.5,
			},
			horizontalOffset = {
				name = L["X Offset"],
				type = 'range',
				desc = L["Horizontal Offset from the Anchor."],
				order = 5,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.x
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.x = value
					RUF:UpdateAuras(profileName)
				end,
			},
			verticalOffset = {
				name = L["Y Offset"],
				type = 'range',
				desc = L["Vertical Offset from the Anchor."],
				order = 6,
				min = -500,
				max = 500,
				softMin = -100,
				softMax = 100,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.y
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.y = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorFrom = {
				name = L["Anchor From"],
				type = 'select',
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
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrom
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrom = value
					RUF:UpdateAuras(profileName)
				end,
			},
			anchorFrame = {
				name = L["Attach To"],
				type = 'select',
				desc = L["Choose an element to attach to, either the frame or another indicator."],
				hidden = true,
				values = {
					Frame = L["Frame"],
					BuffIcons = L["Buff Icons"],
				},
				order = 8,
				get = function(info)
					RUF:UpdateOptions()
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrame
				end,
				set = function(info, value)
					if value ~= nil and value:match('%S') ~= nil then
						if value == 'Frame' then
							RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrame = 'Frame'

						elseif RUF:CanAttach(_G['oUF_RUF_' .. referenceUnit]['Debuffs'], _G['oUF_RUF_' .. referenceUnit]['Buffs']) then
							RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrame = value
						else
							RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrame = 'Frame'
							-- TODO Pop up to confirm force anchoring Debuffs back to frame, so we can anchor buffs to debuffs.
						end
					else
						RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorFrame = 'Frame'
					end
					RUF:UpdateAuras(profileName)
					RUF:UpdateOptions()
				end,
			},
			anchorPoint = {
				name = L["Anchor To"],
				type = 'select',
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
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorTo
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Position.AnchorTo = value
					RUF:UpdateAuras(profileName)
				end,
			},
			clickThrough = {
				name = L["Click Through"],
				type = 'toggle',
				order = 8,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.ClickThrough
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.ClickThrough = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterHeader = {
				name = L["Filtering"],
				type = 'header',
				order = 10.5,
			},
			filterCasterByPlayer = {
				name = L["Show Player"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["Player"]),
				order = 15,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Player
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Player = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByCurrentUnit = {
				name = L["Show %s"]:format(L[profileName]),
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L[profileName]),
				hidden = profileName == 'player',
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Unit
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Unit = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByGroupUnits = {
				name = L["Show Group Members"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["group members"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Group
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Group = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterCasterByOtherUnits = {
				name = L["Show Others"],
				type = 'toggle',
				desc = L["Show debuffs cast by %s on this unit."]:format(L["others"]),
				order = 16,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Other
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Caster.Other = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterSpacer = {
				name = ' ',
				type = 'description',
				order = 17,
				width = 'full',
			},
			minDuration = {
				name = L["Minimum Duration"],
				type = 'range',
				order = 20,
				min = 0,
				max = 3600,
				softMin = 0,
				softMax = 360,
				step = 0.5,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Min
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Min = value
					RUF:UpdateAuras(profileName)
				end,
			},
			maxDuration = {
				name = L["Maximum Duration"],
				type = 'range',
				order = 21,
				min = 0,
				max = 86400,
				softMin = 0,
				softMax = 3600,
				step = 0.5,
				bigStep = 5,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Max = value
					RUF:UpdateAuras(profileName)
				end,
			},
			toggleDurationLimit = {
				name = L["Show Unlimited Duration"],
				type = 'toggle',
				order = 22,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Unlimited
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Time.Unlimited = value
					RUF:UpdateAuras(profileName)
				end,
			},
			filterDispellable = {
				name = L["Show Only Dispellable"],
				type = 'toggle',
				desc = L["Show only auras you can dispel"],
				order = 23,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Dispellable
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Filter.Dispellable = value
					RUF:UpdateAuras(profileName)
				end,
			},
			maxAuras = {
				name = L["Max Auras"],
				type = 'range',
				order = 24,
				min = 1,
				max = 64,
				softMin = 1,
				softMax = 32,
				step = 1,
				bigStep = 1,
				get = function(info)
					return RUF.db.profile.unit[profileName].Debuffs.Icons.Max
				end,
				set = function(info, value)
					RUF.db.profile.unit[profileName].Debuffs.Icons.Max = value
					RUF:UpdateAuras(profileName)
				end,
			},
		},
	}

	return debuffOptions
end

function RUF_Options.GenerateUnits()
	wipe(tagList)
	wipe(localisedTags)
	wipe(tagInputs)
	for k,v in pairs(RUF.db.profile.Appearance.Text) do
		if v ~= '' then
			table.insert(tagList,k)
			table.insert(localisedTags,L[k])
			tagInputs['[RUF:'..k..']'] = L[k]
		end
	end

	if RUF.Client == 1 then
		frames = {
			'Player',
			'Pet',
			'PetTarget',
			'Focus',
			'FocusTarget',
			'Target',
			'TargetTarget',
		}
		groupFrames = {
			'Boss',
			--'BossTarget',
			'Arena',
			--'ArenaTarget',
			'Party',
		}
	else
		frames = {
			'Player',
			'Pet',
			'PetTarget',
			'Target',
			'TargetTarget',
		}
		groupFrames = {
			--'Boss',
			--'BossTarget',
			--'Arena',
			--'ArenaTarget',
			'Party',
		}
	end

	local Units = {
		name = L["Unit Options"],
		type = 'group',
		childGroups = 'tree',
		order = 2,
		args = {
		},
	}

	for i = 1,#frames do
		Units.args[frames[i]] = UnitGroup(frames[i])
		Units.args[frames[i]].args.barOptions = BarSettings(frames[i])
		Units.args[frames[i]].args.textOptions = TextSettings(frames[i])
		Units.args[frames[i]].args.indicatorOptions = IndicatorSettings(frames[i])
		Units.args[frames[i]].args.buffOptions = BuffSettings(frames[i])
		Units.args[frames[i]].args.debuffOptions = DebuffSettings(frames[i])
	end
	for i = 1,#groupFrames do
		Units.args[groupFrames[i]] = UnitGroup(groupFrames[i],groupFrames[i])
		Units.args[groupFrames[i]].args.barOptions = BarSettings(groupFrames[i],groupFrames[i])
		Units.args[groupFrames[i]].args.textOptions = TextSettings(groupFrames[i],groupFrames[i])
		Units.args[groupFrames[i]].args.indicatorOptions = IndicatorSettings(groupFrames[i],groupFrames[i])
		Units.args[groupFrames[i]].args.buffOptions = BuffSettings(groupFrames[i],groupFrames[i])
		Units.args[groupFrames[i]].args.debuffOptions = DebuffSettings(groupFrames[i],groupFrames[i])
	end

	return Units

end