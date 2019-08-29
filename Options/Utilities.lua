local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:GetModule('Options')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
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

function RUF:UpdateFramePosition(unitFrame,profileName,groupFrame,i,anchorFrom,anchorFrame,anchorTo,offsetX,offsetY)
	if not unitFrame and not profileName and not groupFrame then return end
	local profileName = string.lower(profileName)
	local profileReference = RUF.db.profile.unit[profileName].Frame.Position

	local anchorFrom = anchorFrom or profileReference.AnchorFrom
	local anchorFrame = anchorFrame or profileReference.AnchorFrame
	local anchorTo = anchorTo or profileReference.AnchorTo
	local offsetX = offsetX or profileReference.x
	local offsetY = offsetY or profileReference.y
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
			spacingX = profileReference.offsetx
			spacingY = profileReference.offsety
			local _, originalAnchorFrame, originalAnchorTo = unitFrame:GetPoint()
			unitFrame:ClearAllPoints()
			unitFrame:SetPoint(groupAnchorFrom,originalAnchorFrame,profileReference.growth,spacingX,spacingY)
		end
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
		-- No Arena or Boss units in vanilla.
	end

	for i = 1,#frames do
		local profileName = string.lower(frames[i])
		if _G['oUF_RUF_' .. profileName] then
			for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Indicators) do
				if v ~= '' then
					RUF:OptionsUpdateIndicators(profileName,'none',k)
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
		currentIndicator = unitFrame[indicator .. 'Indicator']
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
	-- TODO Remove Texts
	-- Add/Remove on all relevant elements on profile switch.

	local function AddText(profileName,groupFrame,textName,i)
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

		RUF.CreateTextArea(unitFrame, unitFrame.Frame, textName)
		RUF.SetTextPoints(unitFrame, unitFrame.Frame, textName)
	end

	if string.lower(groupFrame) == 'party' then
		local partyUnits = { oUF_RUF_Party:GetChildren() }
		partyUnits[#partyUnits] = nil -- Remove last entry which is the moveBG holder.
		for i = 1,#partyUnits do
			AddText(profileName,groupFrame,text,i,partyUnits[i])
		end
	elseif groupFrame ~= 'none' and string.lower(profileName) == string.lower(profileName) then
		for i = 1,5 do
			AddText(profileName,groupFrame,text,i)
		end
	else
		AddText(profileName,groupFrame,text,-1)
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
		if _G['oUF_RUF_' .. profileName] then
			for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
				if v ~= '' then
					RUF:OptionsUpdateTexts(profileName,'none',k)
				end
			end

		end
	end
	for i = 1,#groupFrames do
		local profileName = string.lower(groupFrames[i])
		for k,v in pairs(RUF.db.profile.unit[profileName].Frame.Text) do
			if v ~= '' then
				RUF:OptionsUpdateTexts(groupFrames[i],groupFrames[i],k)
			end
		end
	end
end

function RUF:OptionsUpdateTexts(profileName,groupFrame,text)
	if not profileName or not groupFrame or not text then return end

	-- TODO implement updateOptions function to each text like with bars
	-- Call that function here based on the arguments provided by the options.
	-- Also for add and remove, look at Enable.lua.
	-- We call the creation function in Text/Parent.lua to create a text area with our settings,
	-- then we use the SetTextPoints function to place it on the frame
	-- Create a similar function that goes through the text and updates it

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
		currentText = unitFrame.Text[text].String
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
			if string.lower(groupFrame) == 'party' then
				oUF_RUF_Party:SetAttribute("Point",anchorFrom)
				oUF_RUF_Party:SetAttribute('yOffset', profileReference.Frame.Position.offsety)
				for i = 1, 4 do -- Why are we doing this?
					_G['oUF_RUF_PartyUnitButton'..i]:ClearAllPoints()
				end
				RUF:UpdateFramePosition(oUF_RUF_Party,profileName,groupFrame)
			else
				local anchorFrom
				if profileReference.Frame.Position.growth == "BOTTOM" then
					anchorFrom = "TOP"
				elseif profileReference.Frame.Position.growth == "TOP" then
					anchorFrom = "BOTTOM"
				end
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
		-- No Arena or Boss units in vanilla.
	end

	for i = 1,#frames do
		local profileName = frames[i]
		if _G['oUF_RUF_' .. profileName] then
			RUF:OptionsUpdateBars(profileName,'none','Health')
			RUF:OptionsUpdateBars(profileName,'none','Power')
			RUF:OptionsUpdateBars(profileName,'none','Absorb')
			if i == 1 then
				RUF:OptionsUpdateBars(profileName,'none','Class')
			end
		end
	end
	for i = 1,#groupFrames do
		local profileName = groupFrames[i]
		RUF:OptionsUpdateBars(profileName,groupFrames[i],'Health')
		RUF:OptionsUpdateBars(profileName,groupFrames[i],'Power')
		RUF:OptionsUpdateBars(profileName,groupFrames[i],'Absorb')
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
		local bar = bar
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
		unitFrame[bar]:UpdateOptions()
		unitFrame[bar]:ForceUpdate()
		if bar then
			unitFrame[bar]:UpdateOptions()
			if PlayerClass == 'MONK' then
				unitFrame['Stagger']:UpdateOptions()
			end
			if PlayerClass == 'DRUID' then
				unitFrame['FakeClassPower']:UpdateOptions()
			end
		end
		if bar == 'Power' or bar == 'Absorb' then
			if action == 'enabled' then
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
			end
		elseif originalBar == 'Class' then
			if action == 'enabled' then
				if profileReference.Enabled == true then
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