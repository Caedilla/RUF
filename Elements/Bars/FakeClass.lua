local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local _,uClass = UnitClass("player")

local fakeClassPower = {
	DRUID = {
		classPowerID = 8,
		requireSpec = 1,
		classPowerType = 'LUNAR_POWER',
	},
	PRIEST = {
		classPowerID = 13,
		requireSpec = 3,
		classPowerType = 'INSANITY',
	},
	SHAMAN = {
		classPowerID = 11,
		noSpec = 2,
		classPowerType = 'MAELSTROM',
	},
}




function RUF.SetFakeClassBar(self, unit)
	if not fakeClassPower[uClass] then return end
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	local Bar = CreateFrame("StatusBar",nil,self)
	local Border = CreateFrame("Frame",nil,Bar)
	local Background = Bar:CreateTexture(nil,"BACKGROUND")

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Class.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)

	-- Bar Position
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == 'TOP' then
		Bar:SetPoint('TOP',0,0)
		Bar:SetPoint('LEFT',0,0)
		Bar:SetPoint('RIGHT',0,0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar.anchorTo = 'TOP'
	else
		Bar:ClearAllPoints()
		Bar:SetPoint('BOTTOM',0,0)
		Bar:SetPoint('LEFT',0,0)
		Bar:SetPoint('RIGHT',0,0)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar.anchorTo = 'BOTTOM'
	end

	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.FakeClassPower = Bar
	self.FakeClassPower.Override = RUF.FakeClassUpdate
	self.FakeClassPower.Border = Border
	self.FakeClassPower.Background = Background

	self.FakeClassPower.UpdateOptions = RUF.FakeClassPowerUpdateOptions
end

function RUF.FakeClassUpdate(self, event, unit, powerType)
	if(not (unit and (UnitIsUnit(unit, 'player') and powerType == fakeClassPower[uClass].classPowerType))) then
		return
	end
	local element = self.FakeClassPower
	if RUF.db.profile.unit[self.frame].Frame.Bars.Class.Enabled ~= true then
		self:DisableElement('FakeClassPower')
		return
	end


	local cur, max = UnitPower(unit,fakeClassPower[uClass].classPowerID), UnitPowerMax(unit,fakeClassPower[uClass].classPowerID)
	element:SetMinMaxValues(0, max)
	element:SetValue(cur)


	-- Update Statusbar colour
	local r,g,b = RUF:GetBarColor(element, unit, "Class",fakeClassPower[uClass].classPowerID)
	element:SetStatusBarColor(r,g,b)
	local a = RUF.db.profile.Appearance.Bars.Class.Background.Alpha
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier

	if element.hideAtZero then
		if cur < 1 then
			if element:IsVisible() then
				element:Hide()
			end
		else
			if not element:IsVisible() then
				element:Show()
			end
		end
	end


	-- Update background
	if RUF.db.profile.Appearance.Bars.Class.Background.UseBarColor == false then
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	end
	element.Background:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,a)
end

function RUF.FakeClassPowerUpdateOptions(self)
	if not fakeClassPower[uClass] then return end
	local unit = self.__owner.frame
	local Bar = self
	local Border = self.Border
	local Background = self.Background
	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)

	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Class.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar.hideAtZero = RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == 1
	Bar.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)

	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	self:ForceUpdate()
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled ~= true then
		self:Hide()
	else
		self.__owner:EnableElement('FakeClassPower')
	end
end