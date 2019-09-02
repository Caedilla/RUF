local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

function RUF:Print_Self(message) -- Send a message to your default chat window.
	ChatFrame1:AddMessage("|c5500DBBDRaeli's Unit Frames|r: " .. format(message))
end

function RUF:PopUp(name,message,button1value,button2value,acceptfunc)
	StaticPopupDialogs[name] = {
		text = message,
		button1 = button1value,
		button2 = button2value,
		OnAccept = acceptfunc,--function()
			--GreetTheWorld()
			--ReloadUI()
		--end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		showAlert = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	  }
end

function RUF:copyTable(src, dest)
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			if type(v) == "table" then
				-- try to index the key first so that the metatable creates the defaults, if set, and use that table
				v = RUF:copyTable(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end


function RUF:Short(value,format)
	if type(value) == "number" then
		local fmt
		local gsub
		if value >= 1000000000 or value <= -1000000000 then
			fmt = "%.1fB"
			value = value / 1000000000
		elseif value >= 10000000 or value <= -10000000 then
			fmt = "%.1fM"
			value = value / 1000000
		elseif value >= 1000000 or value <= -1000000 then
			fmt = "%.2fM"
			value = value / 1000000
		elseif value >= 100000 or value <= -100000 then
			fmt = "%.0fK"
			value = value / 1000
		elseif value >= 10000 or value <= -10000 then
			fmt = "%.1fK"
			value = value / 1000
		elseif value >= 1000 or value <= -1000 then
			gsub = string.gsub(value, "^(-?%d+)(%d%d%d)", '%1,%2')
		else
			fmt = "%d"
			value = math.floor(value + 0.5)
		end
		if format then
			if gsub then
				return gsub
			else
				return fmt:format(value)
			end
		end
		return fmt, value
	else
		local fmt_a, fmt_b
		local a, b = value:match("^(%d+)/(%d+)$")
		if a then
			a, b = tonumber(a), tonumber(b)
			if a >= 1000000000 or a <= -1000000000 then
				fmt_a = "%.1fB"
				a = a / 1000000000
			elseif a >= 10000000 or a <= -10000000 then
				fmt_a = "%.1fM"
				a = a / 1000000
			elseif a >= 1000000 or a <= -1000000 then
				fmt_a = "%.2fM"
				a = a / 1000000
			elseif a >= 100000 or a <= -100000 then
				fmt_a = "%.0fK"
				a = a / 1000
			elseif a >= 10000 or a <= -10000 then
				fmt_a = "%.1fK"
				a = a / 1000
			elseif a >= 1000 or a <= -1000 then
				fmt_a = "%s"
				a = string.gsub(a, "^(-?%d+)(%d%d%d)", '%1,%2')
			end
			if b >= 1000000000 or b <= -1000000000 then
				fmt_b = "%.1fB"
				b = b / 1000000000
			elseif b >= 10000000 or b <= -10000000 then
				fmt_b = "%.1fM"
				b = b / 1000000
			elseif b >= 1000000 or b <= -1000000 then
				fmt_b = "%.2fM"
				b = b / 1000000
			elseif b >= 100000 or b <= -100000 then
				fmt_b = "%.0fK"
				b = b / 1000
			elseif b >= 10000 or b <= -10000 then
				fmt_b = "%.1fK"
				b = b / 1000
			elseif b >= 1000 or b <= -1000 then
				fmt_b = "%s"
				b = string.gsub(b, "^(-?%d+)(%d%d%d)", '%1,%2')
			end
			local fmt = ("%s/%s"):format(fmt_a, fmt_b)
			if format then
				return fmt:format(a, b)
			end
			return fmt, a, b
		else
			return value
		end
	end
end

function RUF:Round(number, digits)
	local mantissa = 10^(digits or 0)
	local norm = number * mantissa + 0.5
	local norm_floor = math.floor(norm)
	if norm == norm_floor and (norm_floor % 2) == 1 then
		return (norm_floor - 1) / mantissa
	end
	return norm_floor / mantissa
end

function RUF:Percent(x, y)
	if y ~= 0 then
		return Round(x / y * 100, 1)
	end
	return 0
end

function RUF:ColorsAndPercent(a, b, ...)
	if(a <= 0 or b == 0) then
		return nil, ...
	elseif(a >= b) then
		return nil, select(select('#', ...) - 2, ...)
	end

	local num = select('#', ...) / 3
	local segment, relperc = math.modf((a / b) * (num - 1))
	return relperc, select((segment * 3) + 1, ...)
end

function RUF:ColorGradient(...)
	local relperc, r1, g1, b1, r2, g2, b2 = RUF:ColorsAndPercent(...)
	if(relperc) then
		return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	else
		return r1, g1, b1
	end
end

function RUF:FrameIsDependentOnFrame(frame, otherFrame)
	if (frame and otherFrame) then
		if frame == otherFrame then
			return true
		end
		local points = frame:GetNumPoints()
		for i = 1, points do
			local point,parent,relative,x,y  = frame:GetPoint(i)
			if RUF:FrameIsDependentOnFrame(parent, otherFrame) then
				return true
			end
		end
	end
end

function RUF:CanAttach(frame, otherFrame)
	if not(frame and otherFrame) then
		return
	elseif frame:GetNumPoints() == 0 or otherFrame:GetNumPoints() == 0 then
		return
	elseif frame:GetWidth() == 0 or frame:GetHeight() == 0 or otherFrame:GetWidth() == 0 or otherFrame:GetHeight() == 0 then
		return
	elseif RUF:FrameIsDependentOnFrame(otherFrame, frame) then
		return
	end
	return true
end

function RUF.GetIndicatorAnchorFrame(self,unit,indicator)
	-- TODO:
	-- Anchor to element (health, power)

	local AnchorFrame = "Frame"
	if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame == "Frame" then
		AnchorFrame = self:GetName()
	else
		AnchorFrame = self:GetName().."."..RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame.."Indicator"
		if not _G[AnchorFrame] then
			AnchorFrame = self:GetName()
		end
	end
	return AnchorFrame
end

function RUF.GetLevelColor(self, level)
	if level <= 0 then level = 500 end
	local color = GetQuestDifficultyColor(level)
	local index = 4

	if color.font == "QuestDifficulty_Impossible" then
		index = 0
	elseif color.font == "QuestDifficulty_VeryDifficult" then
		index = 1
	elseif color.font == "QuestDifficulty_Difficult" then
		index = 2
	elseif color.font == "QuestDifficulty_Standard" then
		index = 3
	elseif color.font == "QuestDifficulty_Trivial" then
		index = 4
	end

	local r,g,b = unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[index])
	return r,g,b
end

function RUF.ReturnTextColors(self, unit, tag, cur, max, test) -- Get Text Colors
	local r,g,b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
	local _,class = UnitClass(unit)
	--[[if RUF.db.global.TestMode == true then
		if not test then
			test = math.random(RUF.db.char.GuildNum)
		end
		class = RUF.db.char.Guild[test].Class
	end]]--
	if not class then class = "PRIEST" end
	if not cur then
		cur = UnitHealth(unit)
	end
	if not max then
		max = UnitHealthMax(unit)
	end
	if RUF.db.profile.Appearance.Text[tag].Color.Percentage and RUF.db.profile.Appearance.Text[tag].Color.PercentageAtMax and cur == max then -- If we want to show gradient colors at max health, and we're at max health.
		r,g,b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Text[tag].Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Text[tag].Color.Percentage and cur < max and cur > 0 then -- If we want to show gradient colors and we're not at max health.
		r,g,b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Text[tag].Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Text[tag].Color.Class and UnitIsPlayer(unit) then -- If we want to show class colors.
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[class])
	elseif RUF.db.profile.Appearance.Text[tag].Color.Reaction then -- If we want to show unit reaction colors
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,"player") and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
		elseif UnitReaction(unit,'player') then -- If the unit is an offline party member, possibly others too?
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])
		elseif UnitInParty(unit) then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
		else
			r,g,b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
		end
	elseif RUF.db.profile.Appearance.Text[tag].Color.Level then
		local level = UnitLevel(unit)
		if level <= 0 then level = 500 end
		r,g,b = RUF:GetLevelColor(level)
	elseif RUF.db.profile.Appearance.Text[tag].Color.PowerType then -- Color by UnitPower (Mana, Rage, etc.)
		if tag == "CurMana" or tag == "ManaPerc" or tag == "CurManaPerc" then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[0])
		else
			local pType,pToken,altr,altg,altb = UnitPowerType(unit)
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[pType])
		end
	else -- If none of that matches, show the base colour
		r,g,b = unpack(RUF.db.profile.Appearance.Text[tag].Color.BaseColor)
	end
	return r,g,b
end

function RUF.RefreshTextElements(frame,groupNum)
	local unitFrame
	local referenceUnit
	if groupNum == -1 then
		unitFrame = _G['oUF_RUF_' .. frame]
		referenceUnit = frame
	elseif frame == 'Party' then
		unitFrame = _G['oUF_RUF_PartyUnitButton' .. groupNum]
		referenceUnit = 'PartyUnitButton' .. groupNum
	else
		unitFrame = _G['oUF_RUF_' .. frame .. groupNum]
		referenceUnit = frame .. groupNum
	end
	local profileTexts = {}
	for k,v in pairs(RUF.db.profile.unit[unitFrame.frame].Frame.Text) do
		if v ~= "" then
			table.insert(profileTexts,k)
		end
	end


	local existingTexts = { unitFrame.Text:GetChildren() }
	for old = 1,#existingTexts do
		local currentText = existingTexts[old]
		local currentTextName = currentText:GetName()
		for new = 1,#profileTexts do
			local newTextName = 'oUF_RUF_'  .. referenceUnit .. '.Text.' .. profileTexts[new]
			local exists = false
			if currentTextName == newTextName then
				currentText:Show()
				break
			end
			if exists == false then
				currentText:Hide()
				unitFrame:Untag(currentText)
			end
		end
	end

	for new = 1,#profileTexts do
		local currentTextName = 'oUF_RUF_'  .. referenceUnit .. '.Text.' .. profileTexts[new]
		if not _G[currentTextName] then
			RUF.CreateTextArea(unitFrame, unitFrame.frame, profileTexts[new])
			RUF.SetTextPoints(unitFrame, unitFrame.frame, profileTexts[new])
		end
	end

end

function RUF.ToggleFrameLock(status, unitFrame)
	local anchorFrom1, anchorFrame1, anchorTo1, x1, y1, anchorFrom2, anchorFrame2, anchorTo2, x2, y2, x3, y3
	local frames = {}
	local groupFrames = {}
	local MoveBG = _G["oUF_RUF_Party.MoveBG"]

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


	if unitFrame then
		-- if unitFrame == frame from frames or groupFrames then lock or unlock based on status
	elseif status == false then
		MoveBG:Show()
		oUF_RUF_Party:SetMovable(true)
		MoveBG:SetMovable(true)


		MoveBG:SetScript("OnMouseDown", function(MoveBG)
		oUF_RUF_Party:StartMoving()
		MoveBG:StartMoving()
		anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = oUF_RUF_Party:GetPoint() end)

		MoveBG:SetScript("OnMouseUp", function(MoveBG)
		anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = oUF_RUF_Party:GetPoint()
		oUF_RUF_Party:StopMovingOrSizing()
		MoveBG:StopMovingOrSizing()
		x3 = x2-x1
		y3 = y2-y1
		RUF.db.profile.unit["party"].Frame.Position.x = RUF.db.profile.unit["party"].Frame.Position.x + x3
		RUF.db.profile.unit["party"].Frame.Position.y = RUF.db.profile.unit["party"].Frame.Position.y + y3
		LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF") end)

		for i = 1,#frames do
			local frameName = 'oUF_RUF_' .. frames[i]
			local profile = string.lower(frames[i])
			_G[frameName]:SetMovable(true)
			_G[frameName]:SetScript("OnMouseDown", function()
			_G[frameName]:StartMoving()
			anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = _G[frameName]:GetPoint() end)

			_G[frameName]:SetScript("OnMouseUp", function()
			anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = _G[frameName]:GetPoint()
			_G[frameName]:StopMovingOrSizing()
			x3 = x2-x1
			y3 = y2-y1
			RUF.db.profile.unit[profile].Frame.Position.x = RUF.db.profile.unit[profile].Frame.Position.x + x3
			RUF.db.profile.unit[profile].Frame.Position.y = RUF.db.profile.unit[profile].Frame.Position.y + y3
			LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF") end)
		end
		for i = 1,#groupFrames do
			local frameName = 'oUF_RUF_' .. groupFrames[i] .. "1"
			local profile = string.lower(groupFrames[i])
			_G[frameName]:SetMovable(true)
			_G[frameName]:SetScript("OnMouseDown", function()
			_G[frameName]:StartMoving()
			anchorFrom1, anchorFrame1, anchorTo1, x1, y1 = _G[frameName]:GetPoint() end)

			_G[frameName]:SetScript("OnMouseUp", function()
			anchorFrom2, anchorFrame2, anchorTo2, x2, y2 = _G[frameName]:GetPoint()
			_G[frameName]:StopMovingOrSizing()
			x3 = x2-x1
			y3 = y2-y1
			RUF.db.profile.unit[profile].Frame.Position.x = RUF.db.profile.unit[profile].Frame.Position.x + x3
			RUF.db.profile.unit[profile].Frame.Position.y = RUF.db.profile.unit[profile].Frame.Position.y + y3
			LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF") end)
		end

	else -- lock
		for i = 1,#frames do
			local frameName = 'oUF_RUF_' .. frames[i]
			local profile = string.lower(frames[i])
			_G[frameName]:SetMovable(false)
			_G[frameName]:SetScript("OnMouseDown",nil)
			_G[frameName]:SetScript("OnMouseUp",nil)
		end
		for j = 1,#groupFrames do
			local frameName = 'oUF_RUF_' .. groupFrames[j] .. "1"
			local profile = string.lower(groupFrames[j])
			_G[frameName]:SetMovable(false)
			_G[frameName]:SetScript("OnMouseDown",nil)
			_G[frameName]:SetScript("OnMouseUp",nil)
		end
		MoveBG:Hide()
		oUF_RUF_Party:SetMovable(false)
		MoveBG:SetMovable(false)
		MoveBG:SetScript("OnMouseDown",nil)
		MoveBG:SetScript("OnMouseUp",nil)
	end
end