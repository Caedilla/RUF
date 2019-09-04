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
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Tapped and element.tapped then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.MiscColors.Tapped)
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Class and UnitIsPlayer(unit) then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.ClassColors[uClass])
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.Reaction then
		if UnitPlayerControlled(unit) and not UnitCanAttack(unit,'player') and not UnitIsPlayer(unit) then  -- If the unit is an allied pet then show as blue.
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[10])
			return r,g,b
		elseif UnitReaction(unit,'player') then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[UnitReaction(unit, 'player')])
			return r,g,b
		elseif UnitInParty(unit) then
			r,g,b = unpack(RUF.db.profile.Appearance.Colors.ReactionColors[5]) -- So Reaction Works when Party member is in a different zone and UnitReaction returns nil
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
		return r,g,b
	end
	if RUF.db.profile.Appearance.Bars[barType].Color.PowerType and barType ~= 'Health' then
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[pType])
		return r,g,b
	end
	return r,g,b
end

function RUF.UpdateBarLocation(self,unit,element,cur)
	local barsAtTop = {}
	local barsAtBottom = {}
	local profileReference = RUF.db.profile.unit[unit].Frame.Bars
	if unit == 'player' then


	else
		if profileReference.Power.Enabled == 2 then
			if profileReference.Power.Position.Anchor == 'TOP' then
				self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
				self.Background.Base:SetPoint('TOPLEFT',element,'BOTTOMLEFT',0,0)
			else
				self.Background.Base:SetPoint('TOPLEFT',self,0,0)
				self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
			end
		elseif profileReference.Power.Enabled == 1 then
			if cur then
				if cur > 0 then
					if profileReference.Power.Position.Anchor == 'TOP' then
						self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
						self.Background.Base:SetPoint('TOPLEFT',element,'BOTTOMLEFT',0,0)
					else
						self.Background.Base:SetPoint('TOPLEFT',self,0,0)
						self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
					end
				else
					self.Background.Base:SetPoint('TOPLEFT',self,0,0)
					self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
				end
			else
				self.Background.Base:SetPoint('TOPLEFT',self,0,0)
				self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
			end
		else
			self.Background.Base:SetPoint('TOPLEFT',self,0,0)
			self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
		end
	end


		--[[
			Check absorb type, if absorb type is full bar then check order else just set Power bar to proper anchor and absorb to full bar anchor
		]]--

end

function RUF.SetBarLocation(self,unit,element)
	if not self then return end
	local barsAtTop = {}
	local barsAtBottom = {}
 -- TODO
 --[[


	 Handle support for when elements are disabled, i.e move everything up a 'slot'
	 Handle support for when power bar is set to hide at 0. Not sure how we should track that, register UNIT_POWER_FREQUENT or UNIT_POWER and make it run this? Could be inefficient.


	 REMOVE SETTOPBOT OPTIONS. Fuck stacking elements.
	Power can be top or bot. Class can be on opposite part, never both on same 'side'
	Remove Absorb bar type shit, always an overlay. Maybe add height and vertical offset values so you can make it into a 'fake' stacking bar.
 ]]


	if unit == 'player' then
		local classPowerUser = {
			['DEATHKNIGHT'] = true,
			['DRUID'] = true,
			['MAGE'] = true,
			['MONK'] = true,
			['PALADIN'] = true,
			['PRIEST'] = true,
			['ROGUE'] = true,
			['SHAMAN'] = true,
			['WARLOCK'] = true,
		}
		local hasClassBar = false
		if classPowerUser[uClass] then
			if self.ClassPower then
				if self.ClassPower.Holder:IsVisible() then
					hasClassBar = true
				end
			elseif self.FakeClassPower then
				if self.FakeClassPower:IsVisible() then
					hasClassBar = true
				end
			elseif self.Runes then
				if self.Runes.Holder:IsVisible() then
					hasClassBar = true
				end
			end
		end

		if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor then
			-- Force override from old broken ability to place both bars at same location
			RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor = 'TOP'
			RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor = 'BOTTOM'
		end
		if hasClassBar and RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == true then
			if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == 'TOP' then
				table.insert(barsAtTop,'ClassPower')
			else
				table.insert(barsAtBottom,'ClassPower')
			end
		end
		if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled > 0 then
			if RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor == 'TOP' then
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
			elseif barsAtTop[i] == 'ClassPower' then
				profileName = 'Class'
				-- Handle Stagger and Druid FakeClass after.
				if self.ClassPower then
					element = self.ClassPower.Holder
				elseif self.FakeClassPower then
					element = self.FakeClassPower
				elseif self.Runes then
					element = self.Runes.Holder
				end
			end
			element:ClearAllPoints()
			element:SetPoint('TOP',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(RUF.db.profile.unit[unit].Frame.Bars[profileName].Height)
			element.anchorTo = 'TOP'
			self.Background.Base:SetPoint('TOPLEFT',element,'BOTTOMLEFT',0,0)
		end
		for i = 1,#barsAtBottom do
			local element
			local profileName = barsAtBottom[i]
			if barsAtBottom[i] == 'Power' then
				element = self.Power
			elseif barsAtBottom[i] == 'ClassPower' then
				profileName = 'Class'
				-- Handle Stagger and Druid FakeClass after.
				if self.ClassPower then
					element = self.ClassPower.Holder
				elseif self.FakeClassPower then
					element = self.FakeClassPower
				elseif self.Runes then
					element = self.Runes.Holder
				end
			end
			element:ClearAllPoints()
			element:SetPoint('BOTTOM',0,0)
			element:SetPoint('LEFT',0,0)
			element:SetPoint('RIGHT',0,0)
			element:SetHeight(RUF.db.profile.unit[unit].Frame.Bars[profileName].Height)
			element.anchorTo = 'BOTTOM'
			self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
		end
		if #barsAtTop == 0 then
			self.Background.Base:SetPoint('TOPLEFT',self,0,0)
		end
		if #barsAtBottom == 0 then
			self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
		end
	else
		if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled > 0 then
			if RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor == 'TOP' then
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
			element:SetHeight(RUF.db.profile.unit[unit].Frame.Bars[profileName].Height)
			element.anchorTo = 'TOP'
			topOffset = RUF.db.profile.unit[unit].Frame.Bars[profileName].Height
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
			element:SetHeight(RUF.db.profile.unit[unit].Frame.Bars[profileName].Height)
			element.anchorTo = 'BOTTOM'
			self.Background.Base:SetPoint('BOTTOMRIGHT',element,'TOPRIGHT',0,0)
		end
		if #barsAtTop == 0 then
			self.Background.Base:SetPoint('TOPLEFT',self,0,0)
		end
		if #barsAtBottom == 0 then
			self.Background.Base:SetPoint('BOTTOMRIGHT',self,0,0)
		end




		--[[
			Check absorb type, if absorb type is full bar then check order else just set Power bar to proper anchor and absorb to full bar anchor
		]]--

	end


end
