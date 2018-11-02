local RUF = LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local TestModeToggle, Set
local restore = {}
local UnitsSpawned = false
local AnchorSwaps = {
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

function RUF:Print_Self(message) -- Send a message to your default chat window.
	ChatFrame1:AddMessage("|c5500DBBDRaeli's Unit Frames|r: " .. format(message))	
end

function RUF:PopUp(name,tv,b1v)
	StaticPopupDialogs[name] = {
		text = tv,
		button1 = b1v,
		--button2 = "No",
		OnAccept = function()
			--GreetTheWorld()
			ReloadUI()			
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		showAlert = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	  }
end

function RUF:UpdateUnitSettings()
	for i = 1,5 do
		RUF.db.profile.unit["arena"..i] = RUF.db.profile.unit.arena
		RUF.db.profile.unit["arenatarget"..i] = RUF.db.profile.unit.arenatarget
		RUF.db.profile.unit["boss"..i] = RUF.db.profile.unit.boss
		RUF.db.profile.unit["bosstarget"..i] = RUF.db.profile.unit.bosstarget
		RUF.db.profile.unit["party"..i] = RUF.db.profile.unit.party
		RUF.db.profile.unit["partytarget"..i] = RUF.db.profile.unit.partytarget
	end
end

function RUF:UpdateFramePoint(i)
	if not _G[RUF.db.global.UnitList[i].frame] then return end
	local AnchorFrom, Frame
	if RUF.db.global.UnitList[i].group == "arena" then
			Frame = "oUF_RUF_Arena"
		for index = 1, 5 do
			if RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth == "BOTTOM" then
				AnchorFrom = "TOP"
			elseif RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth == "TOP" then
				AnchorFrom = "BOTTOM"
			end
			if(index == 1) then
				_G[Frame..index]:ClearAllPoints()
				_G[Frame..index]:SetPoint(
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorFrom,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorFrame,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorTo,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.x,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.y)

			else
				_G[Frame..index]:ClearAllPoints()
				_G[Frame..index]:SetPoint(
					AnchorFrom, 
					_G[Frame .. index - 1], 
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.offsetx, 
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.offsety)
			end
		end
	elseif RUF.db.global.UnitList[i].group == "boss" then
			Frame = "oUF_RUF_Boss"
		for index = 1, 4 do
			if RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth == "BOTTOM" then
				AnchorFrom = "TOP"
			elseif RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth == "TOP" then
				AnchorFrom = "BOTTOM"
			end
			if(index == 1) then
				_G[Frame..index]:ClearAllPoints()
				_G[Frame..index]:SetPoint(
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorFrom,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorFrame,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.AnchorTo,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.x,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.y)
			else

				_G[Frame..index]:ClearAllPoints()
				_G[Frame..index]:SetPoint(
					AnchorFrom, 
					_G[Frame .. index - 1], 
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.growth,
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.offsetx, 
					RUF.db.profile.unit[RUF.db.global.UnitList[i].group].Frame.Position.offsety)
			end
		end
	elseif RUF.db.global.UnitList[i].group == "party" then
		Frame = "oUF_RUF_PartyUnitButton"
		if RUF.db.profile.unit["party"].Frame.Position.growth == "BOTTOM" then
			AnchorFrom = "TOP"
		elseif RUF.db.profile.unit["party"].Frame.Position.growth == "TOP" then
			AnchorFrom = "BOTTOM"
		end
		oUF_RUF_Party:ClearAllPoints()
		oUF_RUF_Party:SetAttribute("Point",AnchorFrom)
		oUF_RUF_Party:SetAttribute('yOffset', RUF.db.profile.unit["party"].Frame.Position.offsety)
		for index = 1, 4 do
			_G[Frame..index]:ClearAllPoints()
		end
		
		oUF_RUF_Party:SetPoint(
			RUF.db.profile.unit["party"].Frame.Position.AnchorFrom,
			RUF.db.profile.unit["party"].Frame.Position.AnchorFrame,
			RUF.db.profile.unit["party"].Frame.Position.AnchorTo,
			RUF.db.profile.unit["party"].Frame.Position.x,
			RUF.db.profile.unit["party"].Frame.Position.y)
	else
	_G[RUF.db.global.UnitList[i].frame]:ClearAllPoints()
	_G[RUF.db.global.UnitList[i].frame]:SetPoint(
		RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrom,
		RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorFrame,
		RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.AnchorTo,
		RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.x,
		RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.y)
	end
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

function RUF:UnitToIndex(unit)
	for i=1,#RUF.db.global.UnitList do
		if unit == RUF.db.global.UnitList[i].name then
			return i
		end
	end
end

function RUF:GetSpec()
	local SpecID = GetSpecializationInfo(GetSpecialization())
	if PlayerClass == "PRIEST" then
		if SpecID == 258 then
			return 1
		end
		return 2
	elseif PlayerClass == "SHAMAN" then
		if SpecID == 262 or SpecID == 263 then
			return 1
		end
		return 2
	elseif PlayerClass == "DRUID" then
		if SpecID == 102 then
			return 1
		end
		return 2
	elseif RUF.db.char.ClassPowerID then
		return 3
	else
		return 0
	end
end

function RUF:GetLevelColor(level)
	if level <= 0 then level = 500 end
	local color = GetQuestDifficultyColor(level)
	local inex = 4
	if color.g == 0.1 then -- Impossible		
		index = 0
	elseif color.g == 0.82 then -- Normal
		index = 2
	elseif color.g == 0.75 then  -- Easy
		index = 3
	elseif color.g == 0.5 then
		if color.r == 1 then -- Hard
			index = 1
		else -- Trivial
			index = 4
		end
	end
	local r,g,b = unpack(RUF.db.profile.Appearance.Colors.DifficultyColors[index])
	return r,g,b
end

function RUF:ReturnTextColors(unit, tag, cur, max, test) -- Get Text Colors
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

function RUF:FrameAttributes(element)
	element.colors.Tapping = RUF.db.profile.Appearance.Colors.MiscColors.Tapped
	element.colors.Disconnected = RUF.db.profile.Appearance.Colors.MiscColors.Disconnected
	element.colors.class.DEATHKNIGHT = RUF.db.profile.Appearance.Colors.ClassColors.DEATHKNIGHT
	element.colors.class.DEMONHUNTER = RUF.db.profile.Appearance.Colors.ClassColors.DEMONHUNTER
	element.colors.class.DRUID = RUF.db.profile.Appearance.Colors.ClassColors.DRUID
	element.colors.class.HUNTER = RUF.db.profile.Appearance.Colors.ClassColors.HUNTER
	element.colors.class.MAGE = RUF.db.profile.Appearance.Colors.ClassColors.MAGE
	element.colors.class.MONK = RUF.db.profile.Appearance.Colors.ClassColors.MONK
	element.colors.class.PALADIN = RUF.db.profile.Appearance.Colors.ClassColors.PALADIN
	element.colors.class.PRIEST = RUF.db.profile.Appearance.Colors.ClassColors.PRIEST
	element.colors.class.ROGUE = RUF.db.profile.Appearance.Colors.ClassColors.ROGUE
	element.colors.class.SHAMAN = RUF.db.profile.Appearance.Colors.ClassColors.SHAMAN
	element.colors.class.WARLOCK = RUF.db.profile.Appearance.Colors.ClassColors.WARLOCK
	element.colors.class.WARRIOR = RUF.db.profile.Appearance.Colors.ClassColors.WARRIOR	
	for i = 1,8 do
		element.colors.reaction[i][1] = RUF.db.profile.Appearance.Colors.ReactionColors[i][1]
		element.colors.reaction[i][2] = RUF.db.profile.Appearance.Colors.ReactionColors[i][2]
		element.colors.reaction[i][3] = RUF.db.profile.Appearance.Colors.ReactionColors[i][3]
	end
	element.colors.health = RUF.db.profile.Appearance.Bars.Health.Color.BaseColor
	element.colors.power.MANA = RUF.db.profile.Appearance.Colors.PowerColors[0]
	element.colors.power.RAGE = RUF.db.profile.Appearance.Colors.PowerColors[1]
	element.colors.power.FOCUS = RUF.db.profile.Appearance.Colors.PowerColors[2]
	element.colors.power.ENERGY = RUF.db.profile.Appearance.Colors.PowerColors[3]
	element.colors.power.COMBO_POINTS = RUF.db.profile.Appearance.Colors.PowerColors[4]
	element.colors.power.RUNES = RUF.db.profile.Appearance.Colors.PowerColors[5]
	element.colors.power.RUNIC_POWER = RUF.db.profile.Appearance.Colors.PowerColors[6]
	element.colors.power.SOUL_SHARDS = RUF.db.profile.Appearance.Colors.PowerColors[7]
	element.colors.power.LUNAR_POWER = RUF.db.profile.Appearance.Colors.PowerColors[8]
	element.colors.power.HOLY_POWER = RUF.db.profile.Appearance.Colors.PowerColors[9]
	element.colors.power.MAELSTROM = RUF.db.profile.Appearance.Colors.PowerColors[11]
	element.colors.power.CHI = RUF.db.profile.Appearance.Colors.PowerColors[12]
	element.colors.power.INSANITY = RUF.db.profile.Appearance.Colors.PowerColors[13]
	element.colors.power.ARCANE_CHARGES = RUF.db.profile.Appearance.Colors.PowerColors[16]
	element.colors.power.FURY = RUF.db.profile.Appearance.Colors.PowerColors[17]
	element.colors.power.PAIN = RUF.db.profile.Appearance.Colors.PowerColors[18]

	element.colors.runes[1] = RUF.db.profile.Appearance.Colors.PowerColors[50]--Blood
	element.colors.runes[2] = RUF.db.profile.Appearance.Colors.PowerColors[51]--Frost
	element.colors.runes[3] = RUF.db.profile.Appearance.Colors.PowerColors[52]--Unholy
end

function RUF:GetAbsorbColor(unit)
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Absorb.Color.BaseColor)
	local a = RUF.db.profile.Appearance.Bars.Absorb.Color.Alpha	
	local _,class = UnitClass(unit)
	if not class then class = "PRIEST" end	
	if RUF.db.profile.Appearance.Bars.Absorb.Color.Class and UnitIsPlayer(unit) then
		r = RUF.db.profile.Appearance.Colors.ClassColors[class][1] * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
		g = RUF.db.profile.Appearance.Colors.ClassColors[class][2] * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
		b = RUF.db.profile.Appearance.Colors.ClassColors[class][3] * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier--unpack(RUF.db.profile.Appearance.Colors.ClassColors[class])		
	elseif RUF.db.profile.Appearance.Bars.Absorb.Color.Reaction then -- If we want to show unit reaction colors
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,"player") and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
		elseif UnitReaction(unit,'player') then -- If the unit is an offline party member, possibly others too?
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])
		elseif UnitInParty(unit) then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
		else
			r,g,b = unpack(RUF.db.profile.Appearance.Bars.Absorb.Color.BaseColor)
		end
		r = r * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
		g = g * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
		b = b * RUF.db.profile.Appearance.Bars.Absorb.Color.Multiplier
	end
	return r,g,b,a
end

function RUF:GetPowerColor(element,unit)
	-- Get Color
	local pType,_ = UnitPowerType(unit)
	local _,class = UnitClass(unit)
	if not class then class = "PRIEST" end	
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Color.BaseColor)	
	if RUF.db.profile.Appearance.Bars.Power.Color.Tapped and element.tapped then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)		
	elseif RUF.db.profile.Appearance.Bars.Power.Color.Disconnected and element.disconnected then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.MiscColors.Disconnected)		
	elseif RUF.db.profile.Appearance.Bars.Power.Color.Class and UnitIsPlayer(unit) then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[class])				
	elseif RUF.db.profile.Appearance.Bars.Power.Color.Reaction then
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,"player") and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
		elseif UnitReaction(unit,'player') then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])			
		elseif UnitInParty(unit) then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil			
		else
			r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Color.BaseColor)			
		end
	elseif RUF.db.profile.Appearance.Bars.Power.Color.Percentage then
		local cur, max = UnitPower(unit), UnitPowerMax(unit)
		r,g,b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Bars.Power.Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Bars.Power.Color.PowerType then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[pType])		
	else
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Color.BaseColor)
	end
	return r,g,b
end

function RUF:GetClassColor(unit)
	-- Get Color
	local _,class = UnitClass(unit)
	if not class then class = "PRIEST" end	
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Color.BaseColor)	
	if RUF.db.profile.Appearance.Bars.Class.Color.Class and UnitIsPlayer(unit) then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[class])			
	elseif RUF.db.profile.Appearance.Bars.Class.Color.Percentage then
		local cur, max = UnitPower(unit), UnitPowerMax(unit)
		r,g,b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient))
	elseif RUF.db.profile.Appearance.Bars.Class.Color.PowerType then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[RUF.db.char.ClassPowerID])			
	else
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Color.BaseColor)
	end
	return r,g,b
end

function RUF:UpdateHealthBackgroundPosition(element)
	local unit = element.__owner.frame
	local frame = element.__owner:GetName()
	local bar = _G[frame:GetName() .. ".Health.Bar"]
	local background = _G[frame:GetName() .. ".Health.Background"]
	local ClassBar
	local ClassBarShown 


	local ManaCfg = RUF.db.profile.unit[unit].Frame.Bars.Power
	local ClassCfg = RUF.db.profile.unit[unit].Frame.Bars.Class
	if frame:GetName() == "oUF_RUF_Player" and PlayerClass == "DEATHKNIGHT" then
		ClassBar = frame.Runes.bg[1]
		ClassBar = _G[frame:GetName() .. ".Class"]
	elseif PlayerClass == "PRIEST" or PlayerClass == "SHAMAN" or PlayerClass == "DRUID" then
		ClassBar = _G[RUF.db.global.UnitList[i].frame .. ".AdditionalPower.Border"]
	elseif i == 1 and RUF.db.char.ClassPowerID then
		--ClassBar = frame.ClassPower.bg[1]	
		ClassBar = _G[frame:GetName() .. ".Class"]	
	end
	if ClassBar then
		if ClassBar:IsShown() then
			ClassBarShown = true
		else
			ClassBarShown = false
		end
	else
		ClassBarShown = false
	end

	--if not RUF.db.global.UnitList[i].frame then return end
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then
		frame.Absorb:ClearAllPoints()
		frame.Absorb:SetAllPoints(frame.Health)
		if ClassBarShown and frame.Power:IsShown() and unit == "player" then
			if ClassCfg.Position.Anchor == "TOP" then
				if ManaCfg.Position.Anchor == "TOP" then
					background:SetPoint("TOPLEFT",0, - (ManaCfg.Height + ClassCfg.Height - 1))
					background:SetPoint("BOTTOMRIGHT",0, 0)
				else
					background:SetPoint("TOPLEFT",0, - (ClassCfg.Height))
					background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
				end
			else
				if ManaCfg.Position.Anchor == "BOTTOM" then
					background:SetPoint("TOPLEFT",0, 0)
					background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height + ClassCfg.Height - 1))
				else
					background:SetPoint("BOTTOMRIGHT",0, (ClassCfg.Height))
					background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				end
			end	
		elseif ClassBarShown and unit == "player" and not RUF:GetSpec() == 1 then
			if ClassCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ClassCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ClassCfg.Height))
			end
		elseif ClassBarShown and unit == "player" and RUF:GetSpec() == 1 then
			if ManaCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
			end
		elseif frame.Power:IsShown() then
			if ManaCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
			end
		else
			background:SetPoint("TOPLEFT",0, 0)
			background:SetPoint("BOTTOMRIGHT",0, 0)
		end
	end
end

function RUF:UpdateHealthBackground(i)
	if not i then return end
	if not _G[RUF.db.global.UnitList[i].frame] then return end
	local unit = RUF.db.global.UnitList[i].name
	local frame = _G[RUF.db.global.UnitList[i].frame] --_G["oUF_RUF_Player"]
	local bar = _G[frame:GetName() .. ".Health.Bar"]
	local background = _G[frame:GetName() .. ".Health.Background"]
	local ClassBar
	local ClassBarShown

	local ManaCfg = RUF.db.profile.unit[unit].Frame.Bars.Power
	local ClassCfg = RUF.db.profile.unit[unit].Frame.Bars.Class
	if i == 1 and PlayerClass == "DEATHKNIGHT" then
		ClassBar = frame.Runes.bg[1]
		ClassBar = _G[frame:GetName() .. ".Class"]
	elseif PlayerClass == "PRIEST" or PlayerClass == "SHAMAN" or PlayerClass == "DRUID" then
		ClassBar = _G[RUF.db.global.UnitList[i].frame .. ".AdditionalPower.Border"]
	elseif i == 1 and RUF.db.char.ClassPowerID then
		--ClassBar = frame.ClassPower.bg[1]	
		ClassBar = _G[frame:GetName() .. ".Class"]	
	end
	if ClassBar then
		if ClassBar:IsShown() then
			ClassBarShown = true
		else
			ClassBarShown = false
		end
	else
		ClassBarShown = false
	end

	--if not RUF.db.global.UnitList[i].frame then return end
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then
		frame.Absorb:ClearAllPoints()
		frame.Absorb:SetAllPoints(frame.Health)
		if ClassBarShown and frame.Power:IsShown() and unit == "player" then
			if ClassCfg.Position.Anchor == "TOP" then
				if ManaCfg.Position.Anchor == "TOP" then
					background:SetPoint("TOPLEFT",0, - (ManaCfg.Height + ClassCfg.Height - 1))
					background:SetPoint("BOTTOMRIGHT",0, 0)
				else
					background:SetPoint("TOPLEFT",0, - (ClassCfg.Height))
					background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
				end
			else
				if ManaCfg.Position.Anchor == "BOTTOM" then
					background:SetPoint("TOPLEFT",0, 0)
					background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height + ClassCfg.Height - 1))
				else
					background:SetPoint("BOTTOMRIGHT",0, (ClassCfg.Height))
					background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				end
			end	
		elseif ClassBarShown and unit == "player" and not RUF:GetSpec() == 1 then
			if ClassCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ClassCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ClassCfg.Height))
			end
		elseif ClassBarShown and unit == "player" and RUF:GetSpec() == 1 then
			if ManaCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
			end
		elseif frame.Power:IsShown() then
			if ManaCfg.Position.Anchor == "TOP" then
				background:SetPoint("TOPLEFT",0, - (ManaCfg.Height))
				background:SetPoint("BOTTOMRIGHT",0, 0)
			else
				background:SetPoint("TOPLEFT",0, 0)
				background:SetPoint("BOTTOMRIGHT",0, (ManaCfg.Height))
			end
		else
			background:SetPoint("TOPLEFT",0, 0)
			background:SetPoint("BOTTOMRIGHT",0, 0)
		end
	end
end

function RUF:UpdateElementColor(element,bar,region)
	lreg = string.lower(region)
	if lreg == "additionalpower" then lreg = "power" end
	do
		element.__owner[region].colorTapping = RUF.db.profile.Appearance.Bars[bar].Color.Tapped
		element.__owner[region].colorDisconnected = RUF.db.profile.Appearance.Bars[bar].Color.Disconnected
		element.__owner[region].colorClass = RUF.db.profile.Appearance.Bars[bar].Color.Class
		element.__owner[region].colorReaction = RUF.db.profile.Appearance.Bars[bar].Color.Reaction
		if RUF.db.profile.Appearance.Bars[bar].Color.Percentage == "false" then RUF.db.profile.Appearance.Bars[bar].Color.Percentage = false end
		element.__owner[region].colorSmooth = RUF.db.profile.Appearance.Bars[bar].Color.Percentage
		element.__owner[region].smoothGradient = RUF.db.profile.Appearance.Bars[bar].Color.PercentageGradient
		element.__owner[region].Smooth = RUF.db.profile.Appearance.Bars[bar].Animate
		element.__owner[region].colorPower = RUF.db.profile.Appearance.Bars[bar].Color.PowerType		
		for i = 1,8 do
			element.__owner.colors.reaction[i][1] = RUF.db.profile.Appearance.Colors.ReactionColors[i][1]
			element.__owner.colors.reaction[i][2] = RUF.db.profile.Appearance.Colors.ReactionColors[i][2]
			element.__owner.colors.reaction[i][3] = RUF.db.profile.Appearance.Colors.ReactionColors[i][3]
		end
		element.__owner.colors[lreg].MANA = RUF.db.profile.Appearance.Colors.PowerColors[0]
		element.__owner.colors[lreg].RAGE = RUF.db.profile.Appearance.Colors.PowerColors[1]
		element.__owner.colors[lreg].FOCUS = RUF.db.profile.Appearance.Colors.PowerColors[2]
		element.__owner.colors[lreg].ENERGY = RUF.db.profile.Appearance.Colors.PowerColors[3]
		element.__owner.colors[lreg].COMBO_POINTS = RUF.db.profile.Appearance.Colors.PowerColors[4]
		element.__owner.colors[lreg].RUNES = RUF.db.profile.Appearance.Colors.PowerColors[5]
		element.__owner.colors[lreg].RUNIC_POWER = RUF.db.profile.Appearance.Colors.PowerColors[6]
		element.__owner.colors[lreg].SOUL_SHARDS = RUF.db.profile.Appearance.Colors.PowerColors[7]
		element.__owner.colors[lreg].LUNAR_POWER = RUF.db.profile.Appearance.Colors.PowerColors[8]
		element.__owner.colors[lreg].HOLY_POWER = RUF.db.profile.Appearance.Colors.PowerColors[9]
		element.__owner.colors[lreg].MAELSTROM = RUF.db.profile.Appearance.Colors.PowerColors[11]
		element.__owner.colors[lreg].CHI = RUF.db.profile.Appearance.Colors.PowerColors[12]
		element.__owner.colors[lreg].INSANITY = RUF.db.profile.Appearance.Colors.PowerColors[13]
		element.__owner.colors[lreg].ARCANE_CHARGES = RUF.db.profile.Appearance.Colors.PowerColors[16]
		element.__owner.colors[lreg].FURY = RUF.db.profile.Appearance.Colors.PowerColors[17]
		element.__owner.colors[lreg].PAIN = RUF.db.profile.Appearance.Colors.PowerColors[18]
	end
end

function RUF:PowerShouldDisplay(element, unit, cur)
	if RUF.db.global.TestMode == true then
		unit = element.__owner.oldUnit
		--unit = element.__owner:GetAttribute('oldUnit')
	end
	if unit == "vehicle" then unit = "player" end
	if not RUF.db.profile.unit[unit] then return end
	if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 0 then 
		if element.__owner.Power:IsShown() then -- Always Hidden on this unit.
			RUF:BarVisibility(element, "Power", false)
			return false
		end
	elseif RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 1 then -- Hidden at 0
		if cur < 1 then
			if element.__owner.Power:IsShown() then
				RUF:BarVisibility(element, "Power", false)
			end
			return false
		elseif cur > 0 then
			if not element.__owner.Power:IsShown() then
				RUF:BarVisibility(element, "Power", true)
			end
			return true
		end	
	elseif 	RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 2 then 
		if not element.__owner.Power:IsShown() then
			RUF:BarVisibility(element, "Power", true)
		end
		return true
	end
end

function RUF:BarVisibility(element, bar, show)
	if not show then show = false end
	local unit
	local UnitPowerMaxAmount = UnitPowerMax("player", RUF.db.char.ClassPowerID)
	if bar == "Power" then
		--RUF:UpdateHealthBackgroundPosition(element)
		unit = element.__owner:GetName()
		if show == true then
			if element.__owner.Power.bg:IsShown() == true then return end -- Already Shown
			element.__owner.Power:Show()
			element.__owner.Power.bg:Show()
			element.__owner.Power.border:Show()
		else
			if element.__owner.Power.bg:IsShown() == false then return end -- Already Hidden
			element.__owner.Power:Hide()
			element.__owner.Power.bg:Hide()
			element.__owner.Power.border:Hide()
		end
	elseif bar == "AdditionalPower" then
		unit = element.__owner:GetName()	
		if show == true then
			if element.__owner.AdditionalPower.bg:IsShown() == true then return end -- Already Shown
			element.__owner.AdditionalPower:Show()
			element.__owner.AdditionalPower.bg:Show()
			element.__owner.AdditionalPower.border:Show()
		else
			if element.__owner.AdditionalPower.bg:IsShown() == false then return end -- Already Hidden
			element.__owner.AdditionalPower:Hide()
			element.__owner.AdditionalPower.bg:Hide()
			element.__owner.AdditionalPower.border:Hide()
		end
	elseif bar == "Stagger" then
		if PlayerClass == "MONK" then
			if element.__owner.Stagger:IsShown() == true then return end
			element.__owner.Stagger:Show()
		else
			if element.__owner.Stagger:IsShown() == false then return end
			element.__owner.Stagger:Hide()
		end
	elseif bar == "Class" then
		unit = element:GetName()
		if show == true then
			if PlayerClass == "DEATHKNIGHT" then
				if _G[element:GetName()..".Class"]:IsShown() == true then return end
				_G[element:GetName()..".Class"]:Show()
			else
				if _G[element:GetName()..".Class"]:IsShown() == true then return end
				_G[element:GetName()..".Class"]:Show()
			end
		else
			if PlayerClass == "DEATHKNIGHT" then
				if _G[element:GetName()..".Class"]:IsShown() == false then return end
				_G[element:GetName()..".Class"]:Hide()
			else
				if _G[element:GetName()..".Class"]:IsShown() == false then return end
				_G[element:GetName()..".Class"]:Hide()
				if element.ClassPower.bg[1]:IsShown() == false then return end -- Already Hidden
			end
		end
	elseif bar == "Absorb" then
		if show == true then
			element.__owner.Absorb:Show()
			element.__owner.Absorb.bg:Show()
			element.__owner.Absorb.border:Show()
		else
			element.__owner.Absorb:Hide()
			element.__owner.Absorb.bg:Hide()
			element.__owner.Absorb.border:Hide()
		end
	end


	local FrameIndex = RUF:UnitToIndex(_G[unit].frame)
	RUF:UpdateHealthBackground(FrameIndex)
end

function RUF:PLAYER_REGEN_ENABLED()
	RUF:UpdateFrames()
end

function RUF:FrameLock(i,UnitFrame)
	local AnchorFrom1, AnchorFrame1, AnchorTo1, X1, Y1, AnchorFrom2, AnchorFrame2, AnchorTo2, X2, Y2, X3, Y3
	if RUF.db.global.Lock == false then
		if RUF.db.global.UnitList[i].group == "party" then
			_G["oUF_RUF_Party.MoveBG.BG"]:SetVertexColor(0,0,0,0.5)
			oUF_RUF_PartyUnitButton1:SetFrameStrata("BACKGROUND")
			oUF_RUF_PartyUnitButton2:SetFrameStrata("BACKGROUND")
			oUF_RUF_PartyUnitButton3:SetFrameStrata("BACKGROUND")
			oUF_RUF_PartyUnitButton4:SetFrameStrata("BACKGROUND")
			oUF_RUF_Party:SetMovable(true)
			oUF_RUF_Party:SetScript("OnMouseDown", function(oUF_RUF_Party)
			oUF_RUF_Party:StartMoving()
			AnchorFrom1, AnchorFrame1, AnchorTo1, X1, Y1 = oUF_RUF_Party:GetPoint() end)
			oUF_RUF_Party:SetScript("OnMouseUp", function(oUF_RUF_Party)
			AnchorFrom2, AnchorFrame2, AnchorTo2, X2, Y2 = oUF_RUF_Party:GetPoint()
			oUF_RUF_Party:StopMovingOrSizing()
			X3 = X2-X1
			Y3 = Y2-Y1
			RUF.db.profile.unit["party"].Frame.Position.x = RUF.db.profile.unit["party"].Frame.Position.x + X3
			RUF.db.profile.unit["party"].Frame.Position.y = RUF.db.profile.unit["party"].Frame.Position.y + Y3
			LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF") end)
		else
			if RUF.db.global.UnitList[i].name == "arena1" or RUF.db.global.UnitList[i].name == "boss1" or RUF.db.global.UnitList[i].group == "" then
				UnitFrame:SetMovable(true)
				UnitFrame:SetScript("OnMouseDown", function(UnitFrame)
				UnitFrame:StartMoving()
				AnchorFrom1, AnchorFrame1, AnchorTo1, X1, Y1 = UnitFrame:GetPoint() end)
				UnitFrame:SetScript("OnMouseUp", function(UnitFrame)
				AnchorFrom2, AnchorFrame2, AnchorTo2, X2, Y2 = UnitFrame:GetPoint()
				UnitFrame:StopMovingOrSizing()
				X3 = X2-X1
				Y3 = Y2-Y1
				RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.x = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.x + X3
				RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.y = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Position.y + Y3
				LibStub("AceConfigRegistry-3.0"):NotifyChange("RUF") end)
			end
		end
	else
		UnitFrame:SetMovable(false)
		UnitFrame:SetScript("OnMouseDown",nil)
		UnitFrame:SetScript("OnMouseUp",nil)
		oUF_RUF_Party:SetMovable(false)
		oUF_RUF_Party:SetScript("OnMouseDown",nil)
		oUF_RUF_Party:SetScript("OnMouseUp",nil)
		oUF_RUF_PartyUnitButton1:SetFrameStrata("LOW")
		oUF_RUF_PartyUnitButton2:SetFrameStrata("LOW")
		oUF_RUF_PartyUnitButton3:SetFrameStrata("LOW")
		oUF_RUF_PartyUnitButton4:SetFrameStrata("LOW")
	end
end

function RUF:UpdateAuras(unit)
	if _G[unit.frame] then
		local UnitFrame = _G[unit.frame]
		local profile = _G[unit.frame].frame

		UnitFrame.Buffs:SetSize((RUF.db.profile.unit[profile].Buffs.Icons.Size * RUF.db.profile.unit[profile].Buffs.Icons.Columns), (RUF.db.profile.unit[profile].Buffs.Icons.Size * RUF.db.profile.unit[profile].Buffs.Icons.Rows) + 2) -- x,y size of buff holder frame
		UnitFrame.Buffs.size = RUF.db.profile.unit[profile].Buffs.Icons.Size
		UnitFrame.Debuffs:SetSize((RUF.db.profile.unit[profile].Debuffs.Icons.Size * RUF.db.profile.unit[profile].Debuffs.Icons.Columns), (RUF.db.profile.unit[profile].Debuffs.Icons.Size * RUF.db.profile.unit[profile].Debuffs.Icons.Rows) + 2) -- x,y size of buff holder frame
		UnitFrame.Debuffs.size = RUF.db.profile.unit[profile].Debuffs.Icons.Size

		UnitFrame.Buffs:ClearAllPoints()
		UnitFrame.Buffs:SetPoint(
			RUF.db.profile.unit[profile].Buffs.Icons.Position.AnchorFrom,
			RUF.GetAuraAnchorFrame(UnitFrame,profile,"Buffs"),
			RUF.db.profile.unit[profile].Buffs.Icons.Position.AnchorTo,
			RUF.db.profile.unit[profile].Buffs.Icons.Position.x,
			RUF.db.profile.unit[profile].Buffs.Icons.Position.y)

		UnitFrame.Debuffs:ClearAllPoints()
		UnitFrame.Debuffs:SetPoint(
			RUF.db.profile.unit[profile].Debuffs.Icons.Position.AnchorFrom,
			RUF.GetAuraAnchorFrame(UnitFrame,profile,"Debuffs"),
			RUF.db.profile.unit[profile].Debuffs.Icons.Position.AnchorTo,
			RUF.db.profile.unit[profile].Debuffs.Icons.Position.x,
			RUF.db.profile.unit[profile].Debuffs.Icons.Position.y)
	
		UnitFrame.Buffs["growth-x"] = RUF.db.profile.unit[profile].Buffs.Icons.Growth.x
		UnitFrame.Buffs["growth-y"] = RUF.db.profile.unit[profile].Buffs.Icons.Growth.y
		UnitFrame.Buffs.initialAnchor = RUF.db.profile.unit[profile].Buffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
		UnitFrame.Buffs["spacing-x"] = RUF.db.profile.unit[profile].Buffs.Icons.Spacing.x
		UnitFrame.Buffs["spacing-y"] = RUF.db.profile.unit[profile].Buffs.Icons.Spacing.y

		UnitFrame.Debuffs["growth-x"] = RUF.db.profile.unit[profile].Debuffs.Icons.Growth.x
		UnitFrame.Debuffs["growth-y"] = RUF.db.profile.unit[profile].Debuffs.Icons.Growth.y
		UnitFrame.Debuffs.initialAnchor = RUF.db.profile.unit[profile].Debuffs.Icons.Position.AnchorFrom -- Where icons spawn from in the buff frame
		UnitFrame.Debuffs["spacing-x"] = RUF.db.profile.unit[profile].Debuffs.Icons.Spacing.x
		UnitFrame.Debuffs["spacing-y"] = RUF.db.profile.unit[profile].Debuffs.Icons.Spacing.y
	
		if RUF.db.profile.unit[profile].Buffs.Icons.ClickThrough == true then
			UnitFrame.Buffs.disableMouse = true
		else
			UnitFrame.Buffs.disableMouse = false
		end
		if RUF.db.profile.unit[profile].Debuffs.Icons.ClickThrough == true then
			UnitFrame.Debuffs.disableMouse = true
		else
			UnitFrame.Debuffs.disableMouse = false
		end

		UnitFrame.Buffs.num = RUF.db.profile.unit[profile].Buffs.Icons.Max
		UnitFrame.Debuffs.num = RUF.db.profile.unit[profile].Debuffs.Icons.Max
	
		if RUF.db.profile.unit[profile].Buffs.Icons.CooldownSpiral == true then
			UnitFrame.Buffs.disableCooldown = false
		else
			UnitFrame.Buffs.disableCooldown = true
		end
		if RUF.db.profile.unit[profile].Debuffs.Icons.CooldownSpiral == true then
			UnitFrame.Debuffs.disableCooldown = false
		else
			UnitFrame.Debuffs.disableCooldown = true
		end

		if UnitFrame.Buffs.anchoredIcons then
			if UnitFrame.Buffs.anchoredIcons > 0 then
				for i=1,UnitFrame.Buffs.anchoredIcons do
					local pixel = UnitFrame.Buffs[i].pixel
					pixel:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize})
					local pixelr,pixelg,pixelb,pixela = unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
					pixel:SetBackdropBorderColor(pixelr,pixelg,pixelb,pixela)	
					if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
						pixel:Show()
					else
						pixel:Hide()
					end
					local PixelOffset = RUF.db.profile.Appearance.Aura.Pixel.Offset
					pixel:ClearAllPoints()
					if PixelOffset == 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",0,0)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",0,0)			
					elseif PixelOffset > 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",-PixelOffset,PixelOffset)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",PixelOffset,-PixelOffset)
					elseif PixelOffset < 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",-PixelOffset,PixelOffset)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",PixelOffset,-PixelOffset)
					end
				
					local border = UnitFrame.Buffs[i].border
					border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize})
					local BorderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
					border:ClearAllPoints()
					if BorderOffset == 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",0,0)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",0,0)			
					elseif BorderOffset > 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",-BorderOffset,BorderOffset)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",BorderOffset,-BorderOffset)
					elseif BorderOffset < 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Buffs[i],"TOPLEFT",-BorderOffset,BorderOffset)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Buffs[i],"BOTTOMRIGHT",BorderOffset,-BorderOffset)
					end
				end
			end
		end
		if UnitFrame.Debuffs.anchoredIcons then
			if UnitFrame.Debuffs.anchoredIcons > 0 then		
				for i=1,UnitFrame.Debuffs.anchoredIcons do
					local pixel = UnitFrame.Debuffs[i].pixel
					pixel:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Pixel.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Pixel.Style.edgeSize})
					local pixelr,pixelg,pixelb,pixela = unpack(RUF.db.profile.Appearance.Colors.Aura.Pixel)
					pixel:SetBackdropBorderColor(pixelr,pixelg,pixelb,pixela)	
					if RUF.db.profile.Appearance.Aura.Pixel.Enabled == true then
						pixel:Show()
					else
						pixel:Hide()
					end
					local PixelOffset = RUF.db.profile.Appearance.Aura.Pixel.Offset
					pixel:ClearAllPoints()
					if PixelOffset == 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",0,0)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",0,0)			
					elseif PixelOffset > 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",-PixelOffset,PixelOffset)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",PixelOffset,-PixelOffset)
					elseif PixelOffset < 0 then
						pixel:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",-PixelOffset,PixelOffset)
						pixel:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",PixelOffset,-PixelOffset)
					end
				
					local border = UnitFrame.Debuffs[i].border
					border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Aura.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Aura.Border.Style.edgeSize})
					local BorderOffset = RUF.db.profile.Appearance.Aura.Border.Offset
					border:ClearAllPoints()
					if BorderOffset == 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",0,0)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",0,0)			
					elseif BorderOffset > 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",-BorderOffset,BorderOffset)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",BorderOffset,-BorderOffset)
					elseif BorderOffset < 0 then
						border:SetPoint("TOPLEFT",UnitFrame.Debuffs[i],"TOPLEFT",-BorderOffset,BorderOffset)
						border:SetPoint("BOTTOMRIGHT",UnitFrame.Debuffs[i],"BOTTOMRIGHT",BorderOffset,-BorderOffset)
					end
				end	
			end
		end
		if RUF.db.profile.unit[profile].Buffs.Icons.Enabled == false then
			UnitFrame.Buffs:Hide()
		end
		if RUF.db.profile.unit[profile].Debuffs.Icons.Enabled == false then
			UnitFrame.Debuffs:Hide()
		end
		UnitFrame.Buffs:ForceUpdate()
		UnitFrame.Debuffs:ForceUpdate()
	end
end

function RUF:UpdateAllAuras()
	for i = 1,#RUF.db.global.UnitList do	
		if _G[RUF.db.global.UnitList[i].frame] then
			RUF:UpdateAuras(RUF.db.global.UnitList[i])
		end
	end
end

function RUF:AuraTestMode()
	
end

function RUF:UpdateFrames()
	-- TODO
	-- Use RUF_PetBattleFrameHider:GetChildren() to iterate through updates, rather than database unitlist.
	-- or use oUF.Objects

	if InCombatLockdown() then
		if Set == true then return end
		Set = true
		RUF:RegisterEvent("PLAYER_REGEN_ENABLED")
	return end

	if Set == true then
		Set = false
		RUF:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	RUF:UpdateUnitSettings()	
	for i = 1,#RUF.db.global.UnitList do	
		if _G[RUF.db.global.UnitList[i].frame] then

			-- Get Elements
			local UnitFrame = _G[RUF.db.global.UnitList[i].frame]
			local HealthBar = _G[UnitFrame:GetName() .. ".Health.Bar"]
			local AbsorbBar = _G[UnitFrame:GetName() .. ".Absorb.Bar"]
			local PowerBar = _G[UnitFrame:GetName() .. ".Power.Bar"]

			
			RUF:FrameLock(i,UnitFrame)

			-- Enable / Disable units and Show / Hide in test mode
			if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled == false then
				if RUF.db.global.TestMode == true then
					UnitFrame:Hide()
				else
					UnitFrame:Disable()
				end
			elseif RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Enabled == true then
				if RUF.db.global.TestMode == true then
					UnitFrame:Show()
				else	
					UnitFrame:Enable()
				end
			end

			-- Enable / Disable Absorb Bar
			if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Absorb.Enabled == 0 then
				if UnitFrame.Absorb:IsShown() then
					UnitFrame.Absorb:Hide()
				end
			else
				if not UnitFrame.Absorb:IsShown() then
					UnitFrame.Absorb:Show()
				end					
			end

			-- Update Absorb Settings
			local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[i].name)
			local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[i].name) or 0)
			local max = (UnitHealthMax(RUF.db.global.UnitList[i].name) or 0)
			if RUF.db.global.TestMode == true then -- Set Mock values if we're in test mode.
				r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[1].name)
				AbsorbAmount = ((UnitHealthMax(RUF.db.global.UnitList[1].name) /2) or 0)
				max = (UnitHealthMax(RUF.db.global.UnitList[1].name) or 0)
				UnitFrame.Absorb:SetMinMaxValues(0, max)
				UnitFrame.Absorb:SetValue(AbsorbAmount)
				UnitFrame.Absorb:SetStatusBarColor(r,g,b,a)
			else
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[i].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[i].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[i].name) or 0)
				UnitFrame.Absorb:SetMinMaxValues(0, max)
				UnitFrame.Absorb:SetValue(AbsorbAmount)
				UnitFrame.Absorb:SetStatusBarColor(r,g,b,a)
			end
			
			-- Update Frame Position
			if RUF.db.global.UnitList[i].name == "arena1" or RUF.db.global.UnitList[i].name == "boss1" or RUF.db.global.UnitList[i].name == "party1" or RUF.db.global.UnitList[i].group == "" then
				RUF:UpdateFramePoint(i)
			end
		

			-- Textures
			HealthBar:SetStatusBarTexture(LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture))
			AbsorbBar:SetStatusBarTexture(LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Absorb.Texture))
			--PowerBar:SetStatusBarTexture(LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Power.Texture))
			UnitFrame.Power.texture = LibStub("LibSharedMedia-3.0"):Fetch("statusbar", RUF.db.profile.Appearance.Bars.Power.Texture)

			-- Border
			UnitFrame.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
			local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Border.Color)
			UnitFrame.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Border.Alpha)
			local BorderOffsetx = RUF.db.profile.Appearance.Border.Offset
			local BorderOffsety = RUF.db.profile.Appearance.Border.Offset		
			if BorderOffsetx == 0 then
				UnitFrame.border:SetPoint("TOPLEFT",UnitFrame,"TOPLEFT",0,0)
				UnitFrame.border:SetPoint("BOTTOMRIGHT",UnitFrame,"BOTTOMRIGHT",0,0)			
			elseif BorderOffsetx > 0 then
				UnitFrame.border:SetPoint("TOPLEFT",UnitFrame,"TOPLEFT",-BorderOffsetx,BorderOffsety)
				UnitFrame.border:SetPoint("BOTTOMRIGHT",UnitFrame,"BOTTOMRIGHT",BorderOffsetx,-BorderOffsety)
			elseif BorderOffsetx < 0 then
				UnitFrame.border:SetPoint("TOPLEFT",UnitFrame,"TOPLEFT",-BorderOffsetx,BorderOffsety)
				UnitFrame.border:SetPoint("BOTTOMRIGHT",UnitFrame,"BOTTOMRIGHT",BorderOffsetx,-BorderOffsety)
			end
			UnitFrame.Power.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
			local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
			UnitFrame.Power.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)

			-- Fill Style
			HealthBar:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Health.Fill)
			AbsorbBar:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Absorb.Fill)
			PowerBar:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Power.Fill)
			AbsorbBar:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Absorb.Fill)
			
			-- Size
			UnitFrame:SetWidth(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Width)
			UnitFrame:SetHeight(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Height)
			HealthBar:SetAllPoints(UnitFrame)
			PowerBar:SetHeight(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Power.Height)

			-- Force Updates
			HealthBar:ForceUpdate()
			PowerBar:ForceUpdate()
			HealthBar:ForceUpdate()
			PowerBar:ForceUpdate()
			
			-- Update Additional Power if it exists
			if UnitFrame.AdditionalPower then
				UnitFrame.AdditionalPower:ForceUpdate()
				UnitFrame.AdditionalPower:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Class.Fill)
				UnitFrame.AdditionalPower.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
				local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
				UnitFrame.AdditionalPower.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)

				if RUF.db.profile.unit.player.Frame.Bars.Class.Enabled == true then
					RUF:BarVisibility(UnitFrame.AdditionalPower, "Power", true)
				else
					RUF:BarVisibility(UnitFrame.AdditionalPower, "Power", false)
				end
				if RUF.db.profile.unit.player.Frame.Bars.Power.Enabled > 0 then
					RUF:BarVisibility(UnitFrame.AdditionalPower, "AdditionalPower", true)
				else
					RUF:BarVisibility(UnitFrame.AdditionalPower, "AdditionalPower", false)
				end
			end

			-- Update Stagger if it exists
			if UnitFrame.Stagger then
				if GetSpecialization() == 1 then
					UnitFrame.Stagger:ForceUpdate()
					UnitFrame.Stagger:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Class.Fill)
					UnitFrame.Stagger.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
					local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
					UnitFrame.Stagger.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)				
					if RUF.db.profile.unit.player.Frame.Bars.Class.Enabled == true then
						RUF:BarVisibility(UnitFrame.Stagger, "Stagger", true)
					else
						RUF:BarVisibility(UnitFrame.Stagger, "Stagger", false)
					end
				end
			end

			-- Update Class Bar or Runes if they exist
			if UnitFrame.ClassPower or UnitFrame.Runes then
				if UnitFrame.Runes then
					UnitFrame.Runes:ForceUpdate()
					--UnitFrame.Runes.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
					local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
					--UnitFrame.Runes.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)
					for r = 1,6 do
						_G["oUF_RUF_Player.Class"..r..".Border"]:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
						_G["oUF_RUF_Player.Class"..r..".Border"]:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)
					end
				else
					if PlayerClass == "MONK" and GetSpecialization() == 3 or PlayerClass ~= "MONK" then
						UnitFrame.ClassPower:ForceUpdate()
						-- TODO iterate over amount of class power bars.
						--UnitFrame.ClassPower.border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
						--local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
						--UnitFrame.ClassPower.border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)	
					end
				end
				local UnitPowerMaxAmount = UnitPowerMax(RUF.db.global.UnitList[i].name, RUF.db.char.ClassPowerID)
				local Size = (RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Size.Width + (UnitPowerMaxAmount-1)) / UnitPowerMaxAmount				
				if (RUF.db.char.ClassPowerID) then -- If we're a class that should show a class bar
					local UnitPowerMaxAmount = UnitPowerMax("player", RUF.db.char.ClassPowerID)
					if RUF.db.profile.unit.player.Frame.Bars.Class.Enabled == false then
						RUF:BarVisibility(UnitFrame, "Class", false)	
					elseif(not RUF.db.char.RequireSpec or RUF.db.char.RequireSpec == GetSpecialization()) then -- If the class requires a specific spec, and if so, if we are that spec.
						if(not RUF.db.char.RequireSpell or IsPlayerSpell(RUF.db.char.RequireSpell)) then -- If the class requires a specific spell, druid cat form.
							RUF:BarVisibility(UnitFrame, "Class", true)				
						else
							RUF:BarVisibility(UnitFrame, "Class", false)	
						end
					else
						RUF:BarVisibility(UnitFrame, "Class", false)	
					end
				else
					RUF:BarVisibility(UnitFrame, "Class", false)
				end
				for j = 1,UnitPowerMaxAmount do
					local ClassParent = _G[UnitFrame:GetName() .. ".Class"..j..".Parent"]
					ClassParent:SetHeight(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Class.Height)
					ClassParent:SetWidth(Size)
					ClassParent:SetPoint('TOPLEFT', ((j - 1) * Size - ((j - 1 ) * 1)), 0)
					local ClassBar = _G[UnitFrame:GetName() .. ".Class"..j..".Bar"]
					ClassBar:SetFillStyle(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Bars.Class.Fill)
				end
				PowerBar:ForceUpdate()
			end
			-- Set Health Background Size
			RUF:UpdateHealthBackground(i)	

			-- Create list of Text Areas to update.
			local TextList = {}		
			for k,v in pairs(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text) do
				if v ~= "" then
					table.insert(TextList,k)
				end
			end

			-- Check current frame for Text Areas, and hide ones that shouldn't be here for this profile.
			local OldTexts = { _G[UnitFrame:GetName() .. ".TextParent"]:GetChildren() }
			for j = 1,#OldTexts do
				local text = OldTexts[j]:GetName()
				local len = string.find(text,"TextParent")
				OldTexts[j] = string.sub(text,len+11)

				for k = 1,#TextList do
					local exists = false
					if OldTexts[j] == TextList[k] then
						exists = true
						_G[UnitFrame:GetName() .. ".TextParent."..OldTexts[j]]:Show()
						UnitFrame:Untag(_G[UnitFrame:GetName() .. ".TextParent." .. OldTexts[j] .. ".Text"])
						break
					end
					if exists == false then
						_G[UnitFrame:GetName() .. ".TextParent."..OldTexts[j]]:Hide()
						UnitFrame:Untag(_G[UnitFrame:GetName() .. ".TextParent." .. OldTexts[j] .. ".Text"])
					end
				end
			end

			-- Update Texts
			for j = 1,#TextList do
				if _G[UnitFrame:GetName() .. ".TextParent." .. TextList[j] .. ".Text"] then
					local frame = _G[UnitFrame:GetName() .. ".TextParent." .. TextList[j] .. ".Text"]
					local frameparent = _G[UnitFrame:GetName() .. ".TextParent." .. TextList[j]]
					local fontType = LSM:Fetch("font", RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Font)
					local fontSize = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Size
					local fontOutline = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Outline
					local frameTag = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Tag
					if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]] == "DISABLED" then
						frame:Hide()
						UnitFrame:Untag(frame)
						return
					end
					if RUF.db.global.TestMode == true then
						if RUF.db.global.TestModeShowUnits == true then
							_G[UnitFrame:GetName() .. ".TextParent.FrameName"]:Show()
						else
							_G[UnitFrame:GetName() .. ".TextParent.FrameName"]:Hide()
						end
						frame.frequentUpdates = 10
						UnitFrame.onUpdateFrequency = 5
					else
						_G[UnitFrame:GetName() .. ".TextParent.FrameName"]:Hide()
						if RUF.db.global.UnitList[i].name == "targettarget" or RUF.db.global.UnitList[i].name == "focustarget" or RUF.db.global.UnitList[i].name == "pettarget" then
							UnitFrame.onUpdateFrequency = 0.25
						else
							UnitFrame.onUpdateFrequency = 1
						end
						frame.frequentUpdates = 0.5
					end
					UnitFrame:Tag(frame,frameTag)
					frame:SetFont(fontType, fontSize, fontOutline)
					frame:SetShadowColor(0,0,0,RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Shadow)
					frame:UpdateTag()
					frame:ClearAllPoints()
					--frame:SetWidth(RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Width)
					local AnchorFrame = "Frame"
					if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.AnchorFrame == "Frame" then
						AnchorFrame = UnitFrame:GetName()
					else
						AnchorFrame = (UnitFrame:GetName()..".TextParent."..RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.AnchorFrame .. ".Text")
					end

					local ReverseAnchor = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.Anchor
					if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.AnchorFrame ~= "Frame" then
						ReverseAnchor = AnchorSwaps[ReverseAnchor]
					end

					frame:SetPoint(	ReverseAnchor,
									_G[AnchorFrame],
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.Anchor,
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.x,
									RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.y)
					local AnchorPoint = RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Position.Anchor
					if AnchorPoint == "RIGHT" or AnchorPoint == "TOPRIGHT" or AnchorPoint == "BOTTOMRIGHT" then
						frame:SetJustifyH("RIGHT")
					elseif AnchorPoint == "LEFT" or AnchorPoint == "TOPLEFT" or AnchorPoint == "BOTTOMLEFT" then
						frame:SetJustifyH("LEFT")
					else
						frame:SetJustifyH("CENTER")
					end
					if RUF.db.profile.unit[RUF.db.global.UnitList[i].name].Frame.Text[TextList[j]].Enabled then
						frame:Show()
						UnitFrame:Tag(frame,frameTag)
						frame:UpdateTag()
					else
						UnitFrame:Untag(frame)
						frame:Hide()
					end
				else
					RUF.CreateTextArea(UnitFrame,RUF.db.global.UnitList[i].name,TextList[j])
					RUF.SetTextPoints(UnitFrame,RUF.db.global.UnitList[i].name,TextList[j])
				end
			end

			-- Update Indicators
			RUF.UpdateIndicators(UnitFrame,RUF.db.global.UnitList[i].name)
			local Frames = {
				[1] = "AssistIndicator",
				[2] = "HonorIndicator",
				[3] = "InCombatIndicator",
				[4] = "LeadIndicator",
				[5] = "MainTankAssistIndicator",
				[6] = "PhasedIndicator",
				[7] = "PvPIndicator",
				[8] = "ObjectiveIndicator",
				[9] = "ReadyIndicator",
				[10] = "RestIndicator",		
				[11] = "RoleIndicator",
				[12] = "TargetMarkIndicator",		
			}
			for i = 1,#Frames do
				if UnitFrame[Frames[i]] then
					if UnitFrame[Frames[i]].ForceUpdate then
						UnitFrame[Frames[i]]:ForceUpdate()
					end
				end
			end
		end
	end
end

function RUF:MoveBars(element, unit)
	if RUF:GetSpec() == 1 or RUF:GetSpec() == 2 then return end
	if not unit then return end
	if not RUF.db.profile.unit[unit] then return end
	local AbsorbBar, AbsorbAnchor, PowerBar, PowerAnchor, PowerOrder, ClassBar, ClassBarParent, ClassAnchor, NumBars
	if RUF.db.global.TestMode == true then
		unit = element.__owner.oldUnit
		--unit = element.__owner:GetAttribute('oldUnit')
	end
	local NegativeFrameHeight = - RUF.db.profile.unit[unit].Frame.Size.Height
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 2 then
		AbsorbBar = element.__owner.Absorb
		AbsorbAnchor = RUF.db.profile.unit[unit].Frame.Bars.Absorb.Position.Anchor
	end
	if element.__owner:GetName() == "oUF_RUF_Player" and RUF.db.char.ClassPowerID then
		if _G[element.__owner:GetName() .. ".Class"] then
			PowerAnchor = RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor
			PowerBar = element.__owner.Power
			NumBars = UnitPowerMax(unit, RUF.db.char.ClassPowerID)
			ClassAnchor = RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor
			ClassBarParent = _G[element.__owner:GetName()..".Class"]
			if PlayerClass == "DEATHKNIGHT" then		
				ClassBar = ".Class"
			else			
				ClassBar = ".Class"
			end
		end
	else
		PowerAnchor = RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor
		PowerBar = element.__owner.Power
		ClassBarParent = "nil"
		ClassAnchor = "nil"
		ClassBar = "nil"
		NumBars = UnitPowerMax(unit, RUF.db.char.ClassPowerID)
	end	
	if PowerAnchor == ClassAnchor then	
		if RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Order == 0 then
			PowerBar:ClearAllPoints()
			PowerBar:SetPoint('LEFT',0,0)
			PowerBar:SetPoint('RIGHT',0,0)
			PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor,0,0)
			PowerBar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
			if PowerAnchor == "TOP" then
				if PowerBar:IsShown() then
					ClassBarParent:SetPoint("TOP",0,(-RUF.db.profile.unit[unit].Frame.Bars.Power.Height)+1)
				else
					ClassBarParent:SetPoint("TOP",0,0)
				end
				for i=1,NumBars do
					_G[element.__owner:GetName() .. ClassBar..i..".Parent"]:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				end					
			elseif PowerAnchor == "BOTTOM" then
				if PowerBar:IsShown() then
					ClassBarParent:SetPoint("TOP",0, NegativeFrameHeight + RUF.db.profile.unit[unit].Frame.Bars.Power.Height + RUF.db.profile.unit[unit].Frame.Bars.Class.Height -1)
				else
					ClassBarParent:SetPoint("TOP",0, NegativeFrameHeight + RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				end
				for i=1,NumBars do
					_G[element.__owner:GetName() .. ClassBar..i..".Parent"]:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				end
			end
		else
			if PowerAnchor == "TOP" then
				PowerBar:ClearAllPoints()
				PowerBar:SetPoint('LEFT',0,0)
				PowerBar:SetPoint('RIGHT',0,0)
				PowerBar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
				if ClassBarParent:IsShown() then
					PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor,0,-RUF.db.profile.unit[unit].Frame.Bars.Class.Height+1)
				else
					PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor,0,0)
				end
				ClassBarParent:SetPoint("TOP",0, 0)				
				for i=1,NumBars do
					_G[element.__owner:GetName() .. ClassBar..i..".Parent"]:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				end
			elseif PowerAnchor == "BOTTOM" then
				PowerBar:ClearAllPoints()
				PowerBar:SetPoint('LEFT',0,0)
				PowerBar:SetPoint('RIGHT',0,0)
				if ClassBarParent:IsShown() then
					PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor,0,RUF.db.profile.unit[unit].Frame.Bars.Class.Height-1)	
				else
					PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor,0,0)
				end		
				ClassBarParent:SetPoint("TOP",0, NegativeFrameHeight +RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				for i=1,NumBars do
					_G[element.__owner:GetName() .. ClassBar..i..".Parent"]:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				end
			end
		end
	else
		if element.__owner:GetName() == "oUF_RUF_Player" and RUF.db.char.ClassPowerID then
			if _G[element.__owner:GetName()..".Class"]:IsShown() then				
				if ClassAnchor == "BOTTOM" then
					_G[element.__owner:GetName()..".Class"]:SetPoint("TOP",0,NegativeFrameHeight + RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				elseif ClassAnchor == "TOP" then
					ClassBarParent:SetPoint("TOP",0, 0)
				end
				--[[for i=1,NumBars do
					--_G[element.__owner:GetName() .. ClassBar..i..".Parent"]:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
					print(i)
				end]]--
			end
		end
		if PowerBar:IsShown() then
			PowerBar:ClearAllPoints()
			PowerBar:SetPoint('LEFT',0,0)
			PowerBar:SetPoint('RIGHT',0,0)
			PowerBar:SetPoint(RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor,0,0)
			PowerBar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		end
	end

	
	--[[
	if AbsorbBar == 1 then
		AbsorbBar:ClearAllPoints()
		AbsorbBar:SetAllPoints(Health)
	elseif AbsorbBar == 2 then
		if ClassBar and PowerBar then
			if PowerAnchor == AbsorbAnchor == ClassAnchor then
				if PowerAnchor == TOP then
					Move AbsorbBar to AbsorbAnchor TOP Offset by NEGATIVE (PowerHeight + ClassHeight)+2
				else
					Move AbsorbBar to AbsorbAnchor BOTTOM Offset by POSITIVE (PowerHeight + ClassHeight)-2
				end
			elseif (PowerAnchor == ClassAnchor) ~= AbsorbAnchor then
				Move AbsorbBar to AbsorbAnchor
			elseif (PowerAnchor == AbsorbAnchor) ~= ClassAnchor then
				if AbsorbAnchor == TOP then
					Move AbsorbBar to AbsorbAnchor TOP Offset by NEGATIVE (PowerHeight)+1
				else
					Move AbsorbBar to AbsorbAnchor BOTTOM Offset by POSITIVE (PowerHeight)-1
				end
			elseif (ClassAnchor == AbsorbAnchor) ~= PowerAnchor then
				if AbsorbAnchor == TOP then
					Move AbsorbBar to AbsorbAnchor TOP Offset by NEGATIVE (ClassHeight)+1
				else
					Move AbsorbBar to AbsorbAnchor BOTTOM Offset by POSITIVE (ClassHeight)-1
				end
			end
		elseif PowerBar then
			if PowerAnchor == AbsorbAnchor then
				if AbsorbAnchor == TOP then
					Move AbsorbBar to AbsorbAnchor TOP Offset by NEGATIVE (PowerHeight)+1
				else
					Move AbsorbBar to AbsorbAnchor BOTTOM Offset by POSITIVE (PowerHeight)-1
				end				
			else
				Move AbsorbBar to AbsorbAnchor
			end
		elseif ClassBar then
			if ClassAnchor == AbsorbAnchor then
				if AbsorbAnchor == TOP then
					Move AbsorbBar to AbsorbAnchor TOP Offset by NEGATIVE (ClassHeight)+1
				else
					Move AbsorbBar to AbsorbAnchor BOTTOM Offset by POSITIVE (ClassHeight)-1
				end				
			else
				Move AbsorbBar to AbsorbAnchor
			end				
		end
	end	
	]]--
	
	
	
	
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
	RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',"show")
	wipe(restore)
	for k, v in next, oUF.objects do
		v:SetAttribute('oldUnit',v.unit)
		v.oldUnit = v:GetAttribute('oldUnit')
		if v.realUnit then v.oldUnit = v.realUnit end
		v:SetAttribute('unit','player')
		v:Disable()
		if RUF.db.profile.unit[v.oldUnit].Enabled then
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
	RegisterAttributeDriver(oUF_RUF_Party,'state-visibility',oUF_RUF_Party.visibility)
	for k, v in next, oUF.objects do
		v:SetAttribute('unit',v.oldUnit)
		v.unit = v:GetAttribute('unit')
		v:Hide()
		if RUF.db.profile.unit[v.oldUnit].Enabled then
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
