local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

-- TODO setup styling and positioning based on profile.

function RUF.SetCastBar(self, unit)
	-- Position and size
	local Castbar = CreateFrame('StatusBar', nil, self)
	Castbar:SetSize(20, 20)
	Castbar:SetPoint('TOPLEFT',self,'BOTTOMLEFT',0,0)
	Castbar:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',0,-20)

	-- Add a background
	local Background = Castbar:CreateTexture(nil, 'BACKGROUND')
	Background:SetAllPoints(Castbar)
	Background:SetColorTexture(1, 1, 1, .5)

	-- Add a spark
	local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
	Spark:SetSize(20, 20)
	Spark:SetBlendMode('ADD')

	-- Add a timer
	local Time = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	Time:SetPoint('RIGHT', Castbar)

	-- Add spell text
	local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	Text:SetPoint('LEFT', Castbar)

	-- Add spell icon
	local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
	Icon:SetSize(20, 20)
	Icon:SetPoint('TOPLEFT', Castbar, 'TOPLEFT')

	-- Add Shield
	local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
	Shield:SetSize(20, 20)
	Shield:SetPoint('CENTER', Castbar)

	-- Add safezone
	local SafeZone = Castbar:CreateTexture(nil, 'OVERLAY')

	-- Register it with oUF
	Castbar.bg = Background
	Castbar.Spark = Spark
	Castbar.Time = Time
	Castbar.Text = Text
	Castbar.Icon = Icon
	Castbar.Shield = Shield
	Castbar.SafeZone = SafeZone
	self.Castbar = Castbar
end