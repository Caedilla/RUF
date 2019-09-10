local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _,uClass = UnitClass('player')

function RUF:GetBarColor(element,unit,barType,overridePowerType,testCurrent)
	local pType,uClass,_
	_,uClass = UnitClass(unit)
	if not barType then return 1,0,1 end -- Return magenta to show I messed up somewhere.
	if overridePowerType then
		if overridePowerType ~= 'Health' then
			pType = overridePowerType
		end
	else
		pType,_ = UnitPowerType(unit)
	end
	if not uClass then uClass = 'PRIEST' end
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars[barType].Color.BaseColor)
	local colorMult = RUF.db.profile.Appearance.Bars[barType].Color.Multiplier
	if colorMult > 1 then colorMult = 1 end -- Because we replaced Class bar multiplier which could be higher.
	r = r * colorMult
	g = g * colorMult
	b = b * colorMult
	-- Color Priority:
	-- Disconnected
	-- Tapped
	-- Class (if unit is a player unit)
	-- Reaction
	-- Percentage
	-- Power Type
	-- Base Colour

	if RUF.db.profile.Appearance.Bars[barType].Color.Disconnected and element.disconnected then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.MiscColors.Disconnected)
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Tapped and element.tapped then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Class and UnitIsPlayer(unit) then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[uClass])
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Reaction then
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,'player') and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r,g,b
		elseif UnitReaction(unit,'player') then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r,g,b
		elseif UnitInParty(unit) then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
			r = r * colorMult
			g = g * colorMult
			b = b * colorMult
			return r,g,b
		end
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Percentage then
		local cur, max = UnitPower(unit,pType), UnitPowerMax(unit,pType)
		if barType == 'Health' then cur,max = UnitHealth(unit), UnitHealthMax(unit) end
		if RUF.db.global.TestMode == true then
			cur = testCurrent or math.random(25,75)
			if barType == 'Power' then
				max = 100
			end
		end
		r,g,b = RUF:ColorGradient(cur, max, unpack(RUF.db.profile.Appearance.Bars[barType].Color.PercentageGradient))
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.PowerType and barType ~= 'Health' then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[pType])
		r = r * colorMult
		g = g * colorMult
		b = b * colorMult
		return r,g,b
	end
	return r,g,b
end

function RUF.SetBarLocation(self,unit)
	if not self then return end
	if unit == 'ACTIVE_TALENT_GROUP_CHANGED' then unit = 'player' end
	if unit == 'PLAYER_ENTERING_WORLD' then unit = 'player' end
	local profileUnit = self.frame
	local profileReference = RUF.db.profile.unit[profileUnit].Frame.Bars
	local barsAtTop = {}
	local barsAtBottom = {}
	if unit == 'player' then
		local _,pType = UnitPowerType(unit)
		local visibleTopBars = false
		local visibleBottomBars = false
		local powerShouldShow = false
		if profileReference.Class.Position.Anchor == profileReference.Power.Position.Anchor then
			-- Force override from old broken ability to place both bars at same location
			RUF.db.profile.unit[profileUnit].Frame.Bars.Class.Position.Anchor = 'TOP'
			RUF.db.profile.unit[profileUnit].Frame.Bars.Power.Position.Anchor = 'BOTTOM'
		end
		if self.ClassPower and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'ClassPower')
			else
				table.insert(barsAtBottom,'ClassPower')
			end
		end
		if self.FakeClassPower and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'FakeClassPower')
			else
				table.insert(barsAtBottom,'FakeClassPower')
			end
		end
		if self.Runes and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'Runes')
			else
				table.insert(barsAtBottom,'Runes')
			end
		end
		if self.Stagger and profileReference.Class.Enabled == true then
			if profileReference.Class.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'Stagger')
			else
				table.insert(barsAtBottom,'Stagger')
			end
		end
		if profileReference.Power.Enabled == 1 then
			if ((pType == "INSANITY" or pType == "MAELSTROM" or pType == "LUNAR_POWER") and UnitPower(unit,0) > 0) or UnitPower(unit) > 0 then
				powerShouldShow = true
			end
		elseif profileReference.Power.Enabled == 2 then
			powerShouldShow = true
		end
		if powerShouldShow == true then
			if profileReference.Power.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'Power')
			else
				table.insert(barsAtBottom,'Power')
			end
		end
		local topOffset,bottomOffset
		for i = 1,#barsAtTop do
			local element
			local profileName = 'Class'
			if barsAtTop[i] == 'ClassPower' then
				element = self.ClassPower.Holder
			elseif barsAtTop[i] == 'FakeClassPower' then
				element = self.FakeClassPower
			elseif barsAtTop[i] == 'Runes' then
				element = self.Runes.Holder
			elseif barsAtTop[i] == 'Stagger' then
				element = self.Stagger
			elseif barsAtTop[i] == 'Power' then
				profileName = 'Power'
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint('TOP',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = 'TOP'
			if element:IsVisible() then
				visibleTopBars = true
				self.Background.Base:SetPoint('TOPLEFT',element,'BOTTOMLEFT',0,0)
			end
		end
		for i = 1,#barsAtBottom do
			local element
			local profileName = 'Class'
			if barsAtBottom[i] == 'ClassPower' then
				element = self.ClassPower.Holder
			elseif barsAtBottom[i] == 'FakeClassPower' then
				element = self.FakeClassPower
			elseif barsAtBottom[i] == 'Runes' then
				element = self.Runes.Holder
			elseif barsAtBottom[i] == 'Stagger' then
				element = self.Stagger
			elseif barsAtBottom[i] == 'Power' then
				profileName = 'Power'
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint('BOTTOM',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = 'BOTTOM'
			if element:IsVisible() then
				visibleBottomBars = true
				self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
			end
		end
		if visibleTopBars == false then
			self.Background.Base:SetPoint('TOPLEFT',self,0,0)
		end
		if visibleBottomBars == false then
			self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
		end
	else
		if profileReference.Power.Enabled == 2 or (profileReference.Power.Enabled == 1 and UnitPower(unit) > 0) then
			if profileReference.Power.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'Power')
			else
				table.insert(barsAtBottom,'Power')
			end
		end
		local topOffset,bottomOffset
		for i = 1,#barsAtTop do
			local element
			local profileName = barsAtTop[i]
			if barsAtTop[i] == 'Power' then
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint('TOP',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = 'TOP'
			topOffset = profileReference[profileName].Height
			self.Background.Base:SetPoint('TOPLEFT',element,'BOTTOMLEFT',0,0)
		end
		for i = 1,#barsAtBottom do
			local element
			local profileName = barsAtBottom[i]
			if barsAtBottom[i] == 'Power' then
				element = self.Power
			end
			element:ClearAllPoints()
			element:SetPoint('BOTTOM',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(profileReference[profileName].Height)
			element.anchorTo = 'BOTTOM'
			self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
		end
		if #barsAtTop == 0 then
			self.Background.Base:SetPoint('TOPLEFT',self,0,0)
		end
		if #barsAtBottom == 0 then
			self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
		end

	end

end
