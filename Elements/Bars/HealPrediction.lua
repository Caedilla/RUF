local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

function RUF.HealPredictionUpdate(self, event, unit)
	if(not unit or self.unit ~= unit) then return end
	local element = self.Health

	--[[ Callback: Health:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local disconnected = not UnitIsConnected(unit)
	element:SetMinMaxValues(0, max)

	element.disconnected = disconnected
	element.tapped = tapped

	if(disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end

	if RUF.db.global.TestMode == true then
		cur = math.random(max /4, max - (max/4))
		element:SetValue(cur)
	end

	--[[ Override: Health:UpdateColor(unit, cur, max)
	Used to completely override the internal function for updating the widgets' colors.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	* cur  - the unit's current health value (number)
	* max  - the unit's maximum possible health value (number)
	--]]
	element:UpdateColor(unit, cur, max)

	--[[ Callback: Health:PostUpdate(unit, cur, max)
	Called after the element has been updated.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	* cur  - the unit's current health value (number)
	* max  - the unit's maximum possible health value (number)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max)
	end
end

function RUF.SetHealPrediction(self, unit)
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)

	local PlayerHeals,OtherHeals
	local Health = self.Health

	PlayerHeals = CreateFrame('StatusBar', nil, Health)
	OtherHeals = CreateFrame('StatusBar', nil, Health)
	local anchorFrom, anchorTo
	if Health.FillStyle == 'REVERSE' then -- Right
		anchorFrom = 'RIGHT'
		anchorTo = 'LEFT'

	--elseif Health.FillStyle == 'CENTER' then
		-- TODO: Create a bar on either side of the health bar and split value in two to make it grow outwards.
	else -- Left
		anchorFrom = 'LEFT'
		anchorTo = 'RIGHT'
	end

	PlayerHeals:SetPoint('TOP')
	PlayerHeals:SetPoint('BOTTOM')
	PlayerHeals:SetPoint(anchorFrom, self.Health:GetStatusBarTexture(), anchorTo)
	PlayerHeals:SetStatusBarTexture(texture)
	PlayerHeals:SetStatusBarColor(0,1,0,1)
	PlayerHeals:SetFillStyle(RUF.db.profile.unit[self.frame].Frame.Bars.Health.Fill)
	PlayerHeals:SetWidth(self:GetWidth())
	PlayerHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill

	OtherHeals:SetPoint('TOP')
	OtherHeals:SetPoint('BOTTOM')
	OtherHeals:SetPoint(anchorFrom, PlayerHeals:GetStatusBarTexture(), anchorTo)
	OtherHeals:SetStatusBarTexture(texture)
	OtherHeals:SetStatusBarColor(0,1,1,1)
	OtherHeals:SetFillStyle(RUF.db.profile.unit[self.frame].Frame.Bars.Health.Fill)
	OtherHeals:SetWidth(self:GetWidth())
	OtherHeals.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill


	-- Register with oUF
	self.HealPrediction = {
		myBar = PlayerHeals,
		otherBar = OtherHeals,
		maxOverflow = 1, -- TODO Option
		frequentUpdates = true, -- TODO Option
	}
	self.HealPrediction.UpdateOptions = RUF.PowerUpdateOptions
end

function RUF.HealPredictionUpdateOptions(self)
	local unit = self.__owner.frame
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = {
		[1] = self.myBar,
		[2] = self.otherBar,
	}

	self.frequentUpdates = true -- TODO Option

	for i = 1,#Bar do
		Bar[i]:SetStatusBarTexture(texture)
		Bar[i]:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Health.Fill)
		Bar[i].FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill
	end

	-- TODO Add Smoothing support
	-- This should already work, just need to update initial hook so it gets set at login too.
	--[[if Bar[i].Smooth == true then
		self.__owner:SmoothBar(Bar[i])
	else
		self.__owner:UnSmoothBar(Bar[i])
	end]]--

	self:ForceUpdate()
end