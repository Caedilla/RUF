local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local TestModeToggle,UnitsSpawned
local anchorSwap = {
	["BOTTOM"] = "TOP",
	["BOTTOMLEFT"] = "TOPRIGHT",
	["BOTTOMRIGHT"] = "TOPLEFT",
	["CENTER"] = "CENTER",
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["TOP"] = "BOTTOM",
	["TOPLEFT"] = "BOTTOMRIGHT",
	["TOPRIGHT"] = "BOTTOMLEFT",
}

function RUF:NickValidator(string)
	if (string.len(string) > 12) then
		return 'Length'
	end
	if string.find(string, '%p') then
		return 'Letters'
	end
	if string.find(string, '%d') then
		return 'Letters'
	end
	if string.find(string, '%s%s+') then
		return 'Spaces'
	end
	local numSpaces = select(2,string.gsub(string, '%s',''))
	if numSpaces then
		if numSpaces > 2 then
			return 'Spaces'
		end
	end
		return true
end

function RUF:UpdateFramePosition(unitFrame,profileName,groupFrame,i,anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
	if not unitFrame and not profileName and not groupFrame then return end
	profileName = string.lower(profileName)
	local profileReference = RUF.db.profile.unit[profileName].Frame.Position

	anchorFrom = anchorFrom or profileReference.AnchorFrom
	anchorFrame = anchorFrame or profileReference.AnchorFrame
	anchorTo = anchorTo or profileReference.AnchorTo
	offsetX = offsetX or profileReference.x
	offsetY = offsetY or profileReference.y
	if not i then
		unitFrame:ClearAllPoints()
		unitFrame:SetPoint(anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
	else
		if i == 1 then
			unitFrame:ClearAllPoints()
			unitFrame:SetPoint(anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
		else
			local groupAnchorFrom
			if profileReference.growth == "BOTTOM" then
				groupAnchorFrom = "TOP"
			elseif profileReference.growth == "TOP" then
				groupAnchorFrom = "BOTTOM"
			end
			local spacingX = profileReference.offsetx
			local spacingY = profileReference.offsety
			local _, originalAnchorFrame, originalAnchorTo = unitFrame:GetPoint()
			unitFrame:ClearAllPoints()
			unitFrame:SetPoint(groupAnchorFrom,originalAnchorFrame,profileReference.growth,spacingX,spacingY)
		end
	end

end

function RUF:OptionsUpdateCastbars(profileName,groupFrame)
 -- TODO: Update Castbar appearance
	for k, v in next, oUF.objects do
		if v.Castbar then
			local Bar = v.Castbar
			local Border = Bar.Border
			local Background = Bar.Background
			local Time = Bar.Time
			local Text = Bar.Text
			local profileReference = RUF.db.profile.Appearance.Bars.Cast
			local unitProfile = RUF.db.profile.unit[v.frame].Frame.Bars.Cast
			local texture = LSM:Fetch("statusbar", profileReference.Texture)

			Bar:SetStatusBarTexture(texture)
			Bar:SetFillStyle(unitProfile.Fill)
			Bar:SetWidth(unitProfile.Width)
			Bar:SetHeight(unitProfile.Height)
			local anchorFrame
			if unitProfile.Position.AnchorFrame == true then
				anchorFrame = v
			else
				anchorFrame = 'UIParent'
			end
			Bar:ClearAllPoints()
			Bar:SetPoint(
				unitProfile.Position.AnchorFrom,
				anchorFrame,
				unitProfile.Position.AnchorTo,
				unitProfile.Position.x,
				unitProfile.Position.y
			)

			Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
			local borderr,borderg,borderb = unpack(profileReference.Border.Color)
			Border:SetBackdropBorderColor(borderr,borderg,borderb, profileReference.Border.Alpha)

			local r,g,b = RUF:GetBarColor(Bar, v.frame, "Cast")
			Bar:SetStatusBarColor(r,g,b)
			if profileReference.Background.UseBarColor == false then
				r,g,b = unpack(profileReference.Background.CustomColor)
			end
			local Multiplier = profileReference.Background.Multiplier
			Background:SetTexture(LSM:Fetch("background", "Solid"))
			Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,profileReference.Background.Alpha)
			Background:SetAllPoints(Bar)
			Background.colorSmooth = false

			Time:ClearAllPoints()
			Text:ClearAllPoints()
			if unitProfile.Fill == "REVERSE" then
				Time:SetPoint('LEFT', Bar, 4, 0)
				Text:SetPoint('RIGHT', Bar, -4, 0)
			else
				Time:SetPoint('RIGHT', Bar, -4, 0)
				Text:SetPoint('LEFT', Bar, 4, 0)
			end
			if unitProfile.Enabled == false then
				v:DisableElement('Castbar')
				v.Castbar:Hide()
			else
				v:EnableElement('Castbar')
				v.Castbar:Show()
			end
		end
	end
end

function RUF:OptionsUpdateFrameBorders()
	for k, v in next, oUF.objects do
		local Border = v.Border
		local offset = RUF.db.profile.Appearance.Border.Offset
		Border:SetPoint('TOPLEFT',v,'TOPLEFT',-offset,offset)
		Border:SetPoint('BOTTOMRIGHT',v,'BOTTOMRIGHT',offset,-offset)
		Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
		local r,g,b = unpack(RUF.db.profile.Appearance.Border.Color)
		Border:SetBackdropBorderColor(r,g,b, RUF.db.profile.Appearance.Border.Alpha)
	end
end

function RUF:OptionsUpdateAllAuras()
	for k, v in next, oUF.objects do
		v.Buffs:ForceUpdate()
		v.Debuffs:ForceUpdate()
	end
end

function RUF:OptionsUpdateAuras(profileName,groupFrame,auraType)
	if not profileName or not groupFrame or not auraType then return end

	local function UpdateAura(profileName,groupFrame,auraType,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end
		local currentElement = unitFrame[auraType]
		if not currentElement then return end
		profileReference = RUF.db.profile.unit[string.lower(profileName)][auraType].Icons
		currentElement:ClearAllPoints()
		currentElement:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetAuraAnchorFrame(unitFrame,string.lower(profileName),'Buffs'),
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		currentElement.size = profileReference.Width
		currentElement.width = profileReference.Width
		currentElement.height = profileReference.Height
		currentElement['spacing-x'] = profileReference.Spacing.x
		currentElement['spacing-y'] = profileReference.Spacing.y
		currentElement.num = profileReference.Max
		currentElement['growth-x'] = profileReference.Growth.x
		currentElement['growth-y'] = profileReference.Growth.y
		currentElement.initialAnchor = profileReference.Position.AnchorFrom
		currentElement.disableMouse = profileReference.ClickThrough
		currentElement:SetSize((profileReference.Width * profileReference.Columns), (profileReference.Height * profileReference.Rows) + 2)

		currentElement.Enabled = profileReference.Enabled
		if profileReference.Enabled == true then
			unitFrame:EnableElement('Auras')
		else
			unitFrame:DisableElement('Auras')
		end
		currentElement:ForceUpdate()
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			UpdateAura(profileName,groupFrame,auraType,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			UpdateAura(profileName,groupFrame,auraType,i)
		end
	else
		UpdateAura(profileName,groupFrame,auraType,-1)
	end

end

function RUF:OptionsUpdateAllIndicators()
	-- Runs when we change a Bar setting in Global Options
	local frames = {}
	local groupFrames = {}

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

	for i = 1,#frames do
		local profileName = string.lower(frames[i])
		if _G['oUF_RUF_' .. profileName] then
			for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Indicators) do
				if v ~= '' then
					RUF:OptionsUpdateIndicators(frames[i],'none',k)
				end
			end
		end
	end
	for i = 1,#groupFrames do
		local profileName = string.lower(groupFrames[i])
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Indicators) do
			if v ~= '' then
				RUF:OptionsUpdateIndicators(groupFrames[i],groupFrames[i],k)
			end
		end
	end
end

function RUF:OptionsUpdateIndicators(profileName,groupFrame,indicator)
	if not profileName or not groupFrame or not indicator then return end

	local function UpdateIndicator(profileName,groupFrame,indicator,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end
		local currentIndicator = unitFrame[indicator .. 'Indicator']
		if not currentIndicator then return end -- When refresh profile, ensure we don't try to update indicators that don't exist.
		profileReference = RUF.db.profile.unit[string.lower(profileName)].Frame.Indicators[indicator]
		currentIndicator:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, "OUTLINE")
		currentIndicator:ClearAllPoints()
		currentIndicator:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(unitFrame,string.lower(profileName),indicator),
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)
		currentIndicator.Enabled = profileReference.Enabled
		currentIndicator:ForceUpdate()
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			UpdateIndicator(profileName,groupFrame,indicator,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			UpdateIndicator(profileName,groupFrame,indicator,i)
		end
	else
		UpdateIndicator(profileName,groupFrame,indicator,-1)
	end

end

function RUF:OptionsAddTexts(profileName,groupFrame,textName)

	local function AddText(profileName,groupFrame,textName,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end

		RUF.CreateTextArea(unitFrame, unitFrame.frame, textName)
		RUF.SetTextPoints(unitFrame, unitFrame.frame, textName)
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			AddText(profileName,groupFrame,textName,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			AddText(profileName,groupFrame,textName,i)
		end
	else
		AddText(profileName,groupFrame,textName,-1)
	end
end

function RUF:OptionsDisableTexts(profileName,groupFrame,textName)

	local function RemoveText(profileName,groupFrame,textName,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end
		profileReference = RUF.db.profile.unit[string.lower(profileName)].Frame.Text[textName]
		if profileReference == 'DISABLED' then
			unitFrame.Text[textName]:Hide()
			unitFrame:Untag(unitFrame.Text[textName])
		end
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			RemoveText(profileName,groupFrame,textName,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			RemoveText(profileName,groupFrame,textName,i)
		end
	else
		RemoveText(profileName,groupFrame,textName,-1)
	end
end

function RUF:OptionsUpdateAllTexts()
	-- Runs when we change a Bar setting in Global Options
	local frames = {}
	local groupFrames = {}

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
		-- No Arena or Boss units in vanilla.
	end



	for i = 1,#frames do
		local profileName = string.lower(frames[i])
		if _G['oUF_RUF_' .. frames[i]] then
			RUF.RefreshTextElements(frames[i],-1)
			for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
				if v ~= '' then
					RUF:OptionsUpdateTexts(frames[i],'none',k)
				end
			end
		end
	end
	for i = 1,#groupFrames do
		local profileName = string.lower(groupFrames[i])
		if groupFrames[i] == 'Party' then
			local partyUnits = { oUF_RUF_Party:GetChildren() }
			partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
			for groupNum = 1,#partyUnits do
				RUF.RefreshTextElements(groupFrames[i],groupNum)
			end
		else
			for groupNum = 1,5 do
				RUF.RefreshTextElements(groupFrames[i],groupNum)
			end
		end
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
			if v ~= '' then
				RUF:OptionsUpdateTexts(groupFrames[i],groupFrames[i],k)
			end
		end
	end
end

function RUF:OptionsUpdateTexts(profileName,groupFrame,text)
	if not profileName or not groupFrame or not text then return end

	local function UpdateText(profileName,groupFrame,text,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end
		local currentText = unitFrame.Text[text].String
		if not currentText then return end -- When refresh profile, ensure we don't try to update indicators that don't exist.
		profileReference = RUF.db.profile.unit[string.lower(profileName)].Frame.Text[text]
		currentText:SetFont(LSM:Fetch('font',profileReference.Font), profileReference.Size, profileReference.Outline)
		currentText:SetShadowColor(0,0,0,profileReference.Shadow)
		currentText:ClearAllPoints()

		local anchorFrame = "Frame"
		local reverseAnchor = profileReference.Position.Anchor
		local anchorPoint = profileReference.Position.Anchor
		if profileReference.Position.AnchorFrame == "Frame" then
			anchorFrame = unitFrame
		else
			anchorFrame = unitFrame.Text[profileReference.Position.AnchorFrame].String
		end
		if profileReference.Position.AnchorFrame ~= "Frame" then
			reverseAnchor = anchorSwap[reverseAnchor]
		end
		currentText:SetPoint(
			reverseAnchor,
			anchorFrame,
			anchorPoint,
			profileReference.Position.x,
			profileReference.Position.y
		)
		if anchorPoint == "RIGHT" or anchorPoint == "TOPRIGHT" or anchorPoint == "BOTTOMRIGHT" then
			currentText:SetJustifyH("RIGHT")
		elseif anchorPoint == "LEFT" or anchorPoint == "TOPLEFT" or anchorPoint == "BOTTOMLEFT" then
			currentText:SetJustifyH("LEFT")
		else
			currentText:SetJustifyH("CENTER")
		end
		if profileReference.Enabled then
			unitFrame:Tag(currentText,profileReference.Tag)
			currentText:UpdateTag()
			currentText:Show()
		else
			unitFrame:Untag(currentText)
			currentText:SetText('')
			currentText:Hide()
		end
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			UpdateText(profileName,groupFrame,text,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			UpdateText(profileName,groupFrame,text,i)
		end
	else
		UpdateText(profileName,groupFrame,text,-1)
	end

end

function RUF:OptionsUpdateFrame(profileName,groupFrame)
	if not profileName or not groupFrame then return end

	local function UpdateFrame(profileName,groupFrame,i,partyUnit)
		local currentUnit,unitFrame,profileReference,passUnit
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
			passUnit = profileName
		end
		profileReference = RUF.db.profile.unit[string.lower(profileName)]
		if not partyUnit then
			if profileReference.Enabled == false then
				unitFrame:Disable()
			else
				unitFrame:Enable()
			end
		else
			oUF_RUF_Party.Enabled = RUF.db.profile.unit["party"].Enabled
			if RUF.db.global.TestMode == true then
				if profileReference.Enabled == false then
					RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"hide")
					unitFrame:Hide()
				else
					RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"show")
					unitFrame:Show()
				end
			else
				if profileReference.Enabled == false then
					unitFrame:Disable()
					RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"hide")
				else
					unitFrame:Enable()
					RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',oUF_RUF_Party.visibility)
				end
			end
		end

		unitFrame:SetWidth(profileReference.Frame.Size.Width)
		unitFrame:SetHeight(profileReference.Frame.Size.Height)
		if i == -1 then
			RUF:UpdateFramePosition(unitFrame,profileName,groupFrame)
		end
		if groupFrame ~= 'none' then
			local anchorFrom
			if profileReference.Frame.Position.growth == "BOTTOM" then
				anchorFrom = "TOP"
			elseif profileReference.Frame.Position.growth == "TOP" then
				anchorFrom = "BOTTOM"
			end
			if string.lower(groupFrame) == 'party' then
				oUF_RUF_Party:SetAttribute("Point",anchorFrom)
				oUF_RUF_Party:SetAttribute('yOffset', profileReference.Frame.Position.offsety)
				for i = 1, 4 do -- Why are we doing this?
					_G['oUF_RUF_PartyUnitButton'..i]:ClearAllPoints()
				end
				RUF:UpdateFramePosition(oUF_RUF_Party,profileName,groupFrame)
			else
				if i == 1 then
					RUF:UpdateFramePosition(unitFrame,profileName,groupFrame,i)
				else
					RUF:UpdateFramePosition(unitFrame,profileName,groupFrame,i,anchorFrom,_G['oUF_RUF_' .. passUnit .. i-1])
				end
			end
		end

	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			UpdateFrame(profileName,groupFrame,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			UpdateFrame(profileName,groupFrame,i)
		end
	else
		UpdateFrame(profileName,groupFrame,-1)
	end

end

function RUF:OptionsUpdateAllBars()
	-- Runs when we change a Bar setting in Global Options
	local frames = {}
	local groupFrames = {}

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

	for i = 1,#frames do
		local profileName = frames[i]
		if _G['oUF_RUF_' .. profileName] then
			RUF:OptionsUpdateBars(profileName,'none','Health')
			RUF:OptionsUpdateBars(profileName,'none','Power')
			if _G['oUF_RUF_' .. profileName].Castbar then
				_G['oUF_RUF_' .. profileName].Castbar:UpdateOptions()
			end
			if RUF.Client == 1 then
				RUF:OptionsUpdateBars(profileName,'none','Absorb')
				if i == 1 then
					RUF:OptionsUpdateBars(profileName,'none','Class')
				end
			end
		end
	end
	for i = 1,#groupFrames do
		local profileName = groupFrames[i]
		RUF:OptionsUpdateBars(profileName,groupFrames[i],'Health')
		RUF:OptionsUpdateBars(profileName,groupFrames[i],'Power')
		if RUF.Client == 1 then
			RUF:OptionsUpdateBars(profileName,groupFrames[i],'Absorb')
		end
	end
end

function RUF:OptionsUpdateBars(profileName,groupFrame,bar)
	if not profileName or not groupFrame or not bar then return end

	local function UpdateBar(profileName,groupFrame,bar,i,partyUnit)
		local currentUnit,unitFrame,profileReference
		if partyUnit then
			unitFrame = partyUnit
		else
			if i == -1 then
				currentUnit = profileName
			else
				currentUnit = profileName .. i
			end
			unitFrame = _G['oUF_RUF_' .. currentUnit]
		end
		local originalBar = bar
		if bar == 'Class' then
			if PlayerClass == 'DEATHKNIGHT' then
				bar = 'Runes'
			elseif PlayerClass == 'PRIEST' or PlayerClass == 'SHAMAN' then
				bar = 'FakeClassPower'
			else
				bar = 'ClassPower'
			end
		end
		profileReference = RUF.db.profile.unit[string.lower(profileName)].Frame.Bars[bar]
		unitFrame[bar].UpdateOptions(unitFrame[bar])
		unitFrame[bar]:ForceUpdate()
		if bar then
			unitFrame[bar].UpdateOptions(unitFrame[bar])
			if PlayerClass == 'MONK' then
				unitFrame['Stagger'].UpdateOptions(unitFrame['Stagger'])
			end
			if PlayerClass == 'DRUID' then
				unitFrame['FakeClassPower'].UpdateOptions(unitFrame['FakeClassPower'])
			end
		end
		if bar == 'Power' or bar == 'Absorb' then
				if profileReference.Enabled == 0 then
					unitFrame:DisableElement(bar)
				elseif profileReference.Enabled == 1 then
					unitFrame[bar].hideAtZero = true
					unitFrame:DisableElement(bar)
					unitFrame:EnableElement(bar)
					unitFrame[bar]:ForceUpdate()
				else
					unitFrame[bar].hideAtZero = false
					unitFrame:DisableElement(bar)
					unitFrame:EnableElement(bar)
					unitFrame[bar]:ForceUpdate()
				end
		elseif originalBar == 'Class' then
			if RUF.db.profile.unit[string.lower(profileName)].Frame.Bars.Class.Enabled == true then
				unitFrame:EnableElement(bar)
				if unitFrame[bar] then
					unitFrame[bar]:ForceUpdate()
				end
				if PlayerClass == 'MONK' then
					unitFrame:EnableElement('Stagger')
					unitFrame['Stagger']:ForceUpdate()
				end
				if PlayerClass == 'DRUID' then
					unitFrame:EnableElement('FakeClassPower')
					unitFrame['FakeClassPower']:ForceUpdate()
				end
			else
				unitFrame:DisableElement(bar)
				if PlayerClass == 'MONK' then
					unitFrame:DisableElement('Stagger')
				end
				if PlayerClass == 'DRUID' then
					unitFrame:DisableElement('FakeClassPower')
				end
			end
		end
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			UpdateBar(profileName,groupFrame,bar,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			UpdateBar(profileName,groupFrame,bar,i)
		end
	else
		UpdateBar(profileName,groupFrame,bar,-1)
	end

end

function RUF:SpawnUnits()
	if UnitsSpawned == true then return end
	TestModeToggle = true
	local PartyNum = GetNumGroupMembers() -1
	if PartyNum == -1 then PartyNum = 0 end
	if IsInRaid() then
		PartyNum = GetNumSubgroupMembers()
	end
	oUF_RUF_Party:SetAttribute('startingIndex', -3 + PartyNum)
	if oUF_RUF_Party.Enabled then
		RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"show")
	end
	for k, v in next, oUF.objects do
		v:SetAttribute('oldUnit',v.unit)
		v.oldUnit = v:GetAttribute('oldUnit')
		if v.realUnit then v.oldUnit = v.realUnit end
		v:SetAttribute('unit','player')
		v:Disable()
		if RUF.db.profile.unit[string.gsub(v.oldUnit,'%d','')].Enabled then
			if RUF.db.global.TestModeShowUnits then
				v.Text.DisplayName:Show()
			else
				v.Text.DisplayName:Hide()
			end
			v:Show()
		else
			v:Hide()
		end
		if v.Castbar then
			v.Castbar:OnUpdate()
		end
	end
	UnitsSpawned = true
end

function RUF:RestoreUnits()
	if UnitsSpawned ~= true then return end
	TestModeToggle = false
	oUF_RUF_Party:SetAttribute('startingIndex', 1)
	if oUF_RUF_Party.Enabled then
		RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',oUF_RUF_Party.visibility)
	else
		RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"hide")
	end
	for k, v in next, oUF.objects do
		v:SetAttribute('unit',v.oldUnit)
		v.unit = v:GetAttribute('unit')
		v.Text.DisplayName:Hide()
		v:Hide()
		if RUF.db.profile.unit[string.gsub(v.oldUnit,'%d','')].Enabled then
			v:Enable()
		else
			v:Disable()
		end
		if v.Castbar then
			v.Castbar:OnUpdate()
		end
	end
	UnitsSpawned = false
end

function RUF:TestMode()
	if RUF.db.global.TestMode == true then
		if TestModeToggle ~= true and not InCombatLockdown() then
			RUF:SpawnUnits()
		elseif TestModeToggle == true and not InCombatLockdown() then
			RUF:RestoreUnits()
			RUF:SpawnUnits()
		end
	else
		if TestModeToggle == true and not InCombatLockdown() then
			RUF:RestoreUnits()
		end
	end
end

function RUF:UpdateAllUnitSettings()
	local frames,groupFrames
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
		-- No Arena or Boss units in vanilla.
	end

	for i = 1,#frames do
		local profileName = frames[i]
		if _G['oUF_RUF_' .. profileName] then
			RUF:OptionsUpdateFrame(profileName,'none')
		end
	end
	for i = 1,#groupFrames do
		local profileName = groupFrames[i]
		RUF:OptionsUpdateFrame(profileName,groupFrames[i])
	end

	RUF:OptionsUpdateAllBars()
	RUF:OptionsUpdateAllTexts()
	RUF:OptionsUpdateAllIndicators()
end