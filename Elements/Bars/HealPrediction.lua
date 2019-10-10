local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

function RUF.HealthUpdateColor(element, unit, cur, max)
	local r,g,b = RUF:GetBarColor(element, unit, "Health","Health",cur)
	element:SetStatusBarColor(r,g,b)


	-- Update background
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier
	local a = RUF.db.profile.Appearance.Bars.Health.Background.Alpha
	if RUF.db.profile.Appearance.Bars.Health.Background.UseBarColor == false then
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	end
	element.__owner.Background.Base.Texture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,a)

	local Background = {}
	if element.__owner.frame == 'player' then
		Background = {
			element.__owner.Background.Base.Texture,
		}
	else
		Background = {
			element.__owner.Background.Base.Texture,
		}
	end

	for i = 1,#Background do
		if Background[i] then
			--Background[i]:SetTexture(LSM:Fetch('background', 'Solid'))
			Background[i]:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
		end
	end
end

function RUF.HealthUpdate(self, event, unit)
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

function RUF.HealthPostUpdate(element, unit, cur, max)
 -- Update bar background colour if bar background should use foreground colour
 -- Update bar background colour if we colour by reaction to ensure allied pets get coloured as we desire

 -- Add self.Health.PostUpdate = RUF.HealthPostUpdate only to frames that require either of these updates if possible.
 --So if neither of these options are enabled, this doesn't get added to a frame, saving time.


end

function RUF.SetHealPrediction(self, unit)
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = CreateFrame("StatusBar",nil,self)


	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self)
	Bar:SetFrameLevel(2)
	Bar:SetFillStyle(RUF.db.profile.unit[self.frame].Frame.Bars.Health.Fill)
	Bar.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill


	-- Register with oUF
	self.Health = Bar
	self.Health.UpdateOptions = RUF.HealthUpdateOptions

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

	OtherHeals:SetPoint('TOP')
	OtherHeals:SetPoint('BOTTOM')
	OtherHeals:SetPoint(anchorFrom, PlayerHeals:GetStatusBarTexture(), anchorTo)


	-- Register with oUF
	self.HealPrediction = {
		myBar = PlayerHeals,
		otherBar = OtherHeals,
		maxOverflow = 1, -- TODO Option
		frequentUpdates = true,
	}

end

function RUF.HealthUpdateOptions(self)
	local unit = self.__owner.frame
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = self

	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self.__owner)
	Bar:SetFrameLevel(2)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Health.Fill)
	Bar.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate()
end