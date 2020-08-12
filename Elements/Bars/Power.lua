local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

function RUF.SetPowerBar(self, unit) -- Mana, Rage, Insanity, Maelstrom etc.
	local Texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Power.Texture)
	local Bar = CreateFrame('StatusBar', nil, self)
	local Border = CreateFrame('Frame', nil, Bar, BackdropTemplateMixin and 'BackdropTemplate')
	local Background = Bar:CreateTexture(nil, 'BACKGROUND')

	if RUF.db.profile.unit[unit].Frame.Bars.Power.Position.Anchor == 'TOP' then
		Bar:SetPoint('TOP', 0, 0)
		Bar:SetPoint('LEFT', 0, 0)
		Bar:SetPoint('RIGHT', 0, 0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		Bar.anchorTo = 'TOP'
	else
		Bar:ClearAllPoints()
		Bar:SetPoint('BOTTOM', 0, 0)
		Bar:SetPoint('LEFT', 0, 0)
		Bar:SetPoint('RIGHT', 0, 0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		Bar.anchorTo = 'BOTTOM'
	end

	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Power.Animate
	Bar.frequentUpdates = true
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Power.Height
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(15)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Power.Fill)

	-- Border
	local offset = RUF.db.profile.Appearance.Bars.Power.Border.Offset or 0
	Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(17)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)

	-- Background
	local r, g, b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(r*Multiplier, g*Multiplier, b*Multiplier, RUF.db.profile.Appearance.Bars.Power.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.Power = Bar
	self.Power.Border = Border
	self.Power.Background = Background
	self.Power.UpdateOptions = RUF.PowerUpdateOptions
end

function RUF.PowerUpdate(self, event, unit)
	if(self.unit ~= unit) then return end
	local element = self.Power
	if RUF.db.profile.unit[self.frame].Frame.Bars.Power.Enabled == 0 then
		self:DisableElement('Power')
		return
	end

	local disconnected = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local _, pType = UnitPowerType(unit)
	local cur, max, r, g, b, a, bgMult

	element.disconnected = disconnected
	element.tapped = tapped

	-- Update Statusbar colour
	if UnitIsUnit('player', unit) and (self.frame == 'player') and (pType == 'INSANITY' or pType == 'MAELSTROM' or pType == 'LUNAR_POWER') then
		cur, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
		r, g, b = RUF:GetBarColor(element, unit, 'Power', 0)
		element:SetStatusBarColor(r, g, b)
		a = RUF.db.profile.Appearance.Bars.Class.Background.Alpha
		bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	else
		cur, max = UnitPower(unit), UnitPowerMax(unit)
		r, g, b = RUF:GetBarColor(element, unit, 'Power')
		element:SetStatusBarColor(r, g, b)
		a = RUF.db.profile.Appearance.Bars.Power.Background.Alpha
		bgMult = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	end

	-- Update background
	if RUF.db.profile.Appearance.Bars.Power.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	end
	element.Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)

	if RUF.db.global.TestMode == true then
		cur = math.random(25, 75)
		max = 100
	end

	-- Set Statusbar Value
	element:SetMinMaxValues(0, max)
	if(disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end

	if element.hideAtZero == true and not disconnected then
		if cur < 1 then
			if element:IsVisible() then
				element:Hide()
			end
			RUF.SetBarLocation(self, unit)
		else
			if not element:IsVisible() then
				element:Show()
			end
			RUF.SetBarLocation(self, unit)
		end
	end
end

function RUF.PowerUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self
	local Border = self.Border

	local Texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Power.Texture)
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Power.Animate
	Bar.frequentUpdates = true
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Power.Height
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(15)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Power.Fill)
	RUF.SetBarLocation(self.__owner, unit)

	-- Border
	local offset = RUF.db.profile.Appearance.Bars.Power.Border.Offset or 0
	Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(17)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate() -- Runs Update function for everything else.
	if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled == 0 then
		self:Hide()
	else
		self.__owner:EnableElement('Power')
	end
end