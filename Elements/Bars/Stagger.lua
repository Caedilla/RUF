local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, uClass = UnitClass('player')

function RUF.SetStagger(self, unit)
	if uClass ~= 'MONK' then return end
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Class.Texture)
	local Bar = CreateFrame('StatusBar', nil, self)
	local Border = CreateFrame('Frame', nil, Bar, BackdropTemplateMixin and 'BackdropTemplate')
	local Background = Bar:CreateTexture(nil, 'BACKGROUND')

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Class.Animate
	Bar.frequentUpdates = true
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(15)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)

	-- Bar Position
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == 'TOP' then
		Bar:SetPoint('TOP', 0, 0)
		Bar:SetPoint('LEFT', 0, 0)
		Bar:SetPoint('RIGHT', 0, 0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar.anchorTo = 'TOP'
	else
		Bar:ClearAllPoints()
		Bar:SetPoint('BOTTOM', 0, 0)
		Bar:SetPoint('LEFT', 0, 0)
		Bar:SetPoint('RIGHT', 0, 0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar.anchorTo = 'BOTTOM'
	end

	-- Border
	local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
	Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(16)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

	-- Background
	local r, g, b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(r*Multiplier, g*Multiplier, b*Multiplier, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.Stagger = Bar
	self.Stagger.Border = Border
	self.Stagger.Background = Background
	self.Stagger.Override = RUF.StaggerUpdate
	self.Stagger.UpdateOptions = RUF.StaggerUpdateOptions
end

function RUF.StaggerUpdate(self, event, unit)
	if(unit and unit ~= self.unit) then return end
	local element = self.Stagger
	if RUF.db.profile.unit[self.frame].Frame.Bars.Class.Enabled ~= true then
		self:DisableElement('Stagger')
		return
	end

	-- Set Values
	local cur, max = UnitStagger('player') or 0, UnitHealthMax('player')
	element:SetMinMaxValues(0, max)
	element:SetValue(cur)

	-- Update Colours
	local stagger_low = RUF.db.profile.Appearance.Colors.PowerColors[75]
	local stagger_medium = RUF.db.profile.Appearance.Colors.PowerColors[76]
	local stagger_high = RUF.db.profile.Appearance.Colors.PowerColors[77]
	local r, g, b = RUF:GetBarColor(element, 'player', 'Class')
	local a = RUF.db.profile.Appearance.Bars.Class.Background.Alpha
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Class.Texture)
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local perc = cur/max

	if perc >= 0.6 then
		r, g, b = unpack(stagger_high)
	elseif perc > 0.3 then
		r, g, b = unpack(stagger_medium)
	else
		r, g, b = unpack(stagger_low)
	end
	element:SetStatusBarColor(r, g, b)

	-- Update background
	if RUF.db.profile.Appearance.Bars.Class.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	end
	element.Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)
end

function RUF.StaggerUpdateOptions(self)
	if uClass ~= 'MONK' then return end
	local unit = self.__owner.frame
	local Bar = self
	local Border = self.Border
	local Background = self.Background
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Class.Texture)

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Class.Animate
	Bar.frequentUpdates = true
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(15)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)

	-- Border
	local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
	Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(16)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

	-- Background
	local r, g, b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(r*Multiplier, g*Multiplier, b*Multiplier, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate()
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled ~= true then
		self:Hide()
	else
		self.__owner:EnableElement('Stagger')
	end
end