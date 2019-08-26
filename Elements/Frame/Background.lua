local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF


function RUF.SetFrameBorder(self, unit)
	local name = self:GetName()
	local Border = CreateFrame('Frame',name..'.Border',self)
	local x = RUF.db.profile.Appearance.Border.Offset
	local y = RUF.db.profile.Appearance.Border.Offset

	if x == 0 then
		Border:SetPoint('TOPLEFT',self,'TOPLEFT',0,0)
		Border:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',0,0)
	else
		Border:SetPoint('TOPLEFT',self,'TOPLEFT',-x,y)
		Border:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',x,-y)
	end

	Border:SetFrameLevel(10)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
	local r,g,b = unpack(RUF.db.profile.Appearance.Border.Color)
	Border:SetBackdropBorderColor(r,g,b, RUF.db.profile.Appearance.Border.Alpha)

	self.Border = Border
end

function RUF.SetFrameBackground(self, unit)
	local name = self:GetName()
	local Background = CreateFrame('Frame',name..'.Background',self)

	Background:SetAllPoints(self)
	Background:SetFrameStrata('BACKGROUND')

	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier

	-- Base Background
	local BaseFrame = CreateFrame('Frame',name..'.Background.Base',Background)
	local BaseTexture = BaseFrame:CreateTexture(name..'.Background.Base.Texture','BACKGROUND')
	BaseTexture:SetTexture(LSM:Fetch('background', 'Solid'))
	BaseTexture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	BaseFrame:SetAllPoints(Background)
	BaseTexture:SetAllPoints(BaseFrame)

	-- Power
	--[[local PowerFrame = CreateFrame('Frame',name..'.Background.Power',Background)
	local PowerTexture = PowerFrame:CreateTexture(name..'.Background.Power.Texture','BACKGROUND')
	PowerTexture:SetTexture(LSM:Fetch('background', 'Solid'))
	PowerTexture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	PowerFrame:Hide()
	PowerTexture:SetAllPoints(PowerFrame)]]--

	self.Background = Background
	self.Background.Base = BaseFrame
	self.Background.Base.Texture = BaseTexture
	--self.Background.Power = PowerFrame
	--self.Background.Power.Texture = PowerTexture

	--[[if unit == 'player' then
		-- Class
		local ClassPowerFrame = CreateFrame('Frame',name..'.Background.ClassPower',Background)
		local ClassPowerTexture = ClassPowerFrame:CreateTexture(name..'.Background.ClassPower.Texture','BACKGROUND')
		ClassPowerTexture:SetTexture(LSM:Fetch('background', 'Solid'))
		ClassPowerTexture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
		ClassPowerFrame:Hide()
		ClassPowerTexture:SetAllPoints(ClassPowerFrame)

		self.Background.ClassPower = ClassPowerFrame
		self.Background.ClassPower.Texture = ClassPowerTexture
	end]]--

end