local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

function RUF.SetFrameBackground(self, unit)
	local name = self:GetName()
	local Background = CreateFrame('Frame',name..'.Background',self)

	Background:SetAllPoints(self)
	Background:SetFrameLevel(4)

	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier

	-- Base Background
	local BaseFrame = CreateFrame('Frame',name..'.Background.Base',Background)
	local BaseTexture = BaseFrame:CreateTexture(name..'.Background.Base.Texture','BACKGROUND')
	BaseTexture:SetTexture(LSM:Fetch('background', 'Solid'))
	BaseTexture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	BaseFrame:SetAllPoints(Background)
	BaseTexture:SetAllPoints(BaseFrame)

	self.Background = Background
	self.Background.Base = BaseFrame
	self.Background.Base.Texture = BaseTexture
end