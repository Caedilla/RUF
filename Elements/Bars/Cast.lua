local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

-- TODO setup styling and positioning based on profile.



--[[
	OPTIONS:

	Bar Color:
		Base Colors: - Cast, cancelled, interrupted etc. can we do all this?
		Color by class maybe?
		Brightness Multiplier

	Bar Background:
		Use Bar Color
		Brightness Multiplier
		Alpha
		Base Color

	Border:
		Alpha
		Size
		Color
		Texture

	Text:
		Time
		Spell Name
			Enabled
			Location (Left/Right)
			Font
			Shadow
			Outline
			Size
			X/Y Offset

	Spark:
		On/Off
		Color?
		Size?

	Icon:
		I don't want it. Do it later for other users.

	Latency:
		Enabled
		Color
		Alpha





]]--


function RUF.SetCastBar(self, unit)
	local profileReference = RUF.db.profile.Appearance.Bars.Cast
	local unitProfile = RUF.db.profile.unit[unit].Frame.Bars.Cast
	local texture = LSM:Fetch("statusbar", profileReference.Texture)
	local Bar = CreateFrame("StatusBar",nil,self)
	local Border = CreateFrame("Frame",nil,Bar)
	local Background = Bar:CreateTexture(nil,"BACKGROUND")

	-- Bar
	Bar.colorClass = profileReference.Color.Class
	Bar.colorDisconnected = profileReference.Color.Disconnected
	Bar.colorSmooth = profileReference.Color.Percentage
	Bar.smoothGradient = profileReference.Color.PercentageGradient
	Bar.colorReaction = profileReference.Color.Reaction
	Bar.colorTapping = profileReference.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = profileReference.Animate
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(3)
	Bar:SetFillStyle(unitProfile.Fill)
	Bar:SetWidth(unitProfile.Width)
	Bar:SetHeight(unitProfile.Height)
	local anchorFrame
	if unitProfile.Position.AnchorFrame == true then
		anchorFrame = self
	else
		anchorFrame = 'UIParent'
	end
	Bar:SetPoint(
		unitProfile.Position.AnchorFrom,
		anchorFrame,
		unitProfile.Position.AnchorTo,
		unitProfile.Position.x,
		unitProfile.Position.y
	)

	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, profileReference.Border.Alpha)

	-- Background
	local r,g,b = unpack(profileReference.Background.CustomColor)
	local Multiplier = profileReference.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,profileReference.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Text
	local Time = Bar:CreateFontString(self:GetName() .. '.Cast.Time', 'OVERLAY', 'Raeli')
	local Text = Bar:CreateFontString(self:GetName() .. '.Cast.Text', 'OVERLAY', 'Raeli')
	if unitProfile.Fill == "REVERSE" then
		Time:SetPoint('LEFT', Bar, 4, 0)
		Text:SetPoint('RIGHT', Bar, -4, 0)
	else
		Time:SetPoint('RIGHT', Bar, -4, 0)
		Text:SetPoint('LEFT', Bar, 4, 0)
	end

	-- Spark
	--local Spark = Bar:CreateTexture(nil, 'OVERLAY')
	--Spark:SetSize(10, unitProfile.Height *1.5)
	--Spark:SetBlendMode('ADD')

	-- Icon
	--local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
	--Icon:SetSize(20, 20)
	--Icon:SetPoint('TOPLEFT', Castbar, 'TOPLEFT')

	-- Safe Zone
	local SafeZone = Bar:CreateTexture(nil, 'OVERLAY')

	-- Register with oUF
	Bar.Background = Background
	Bar.Border = Border
	Bar.Time = Time
	Bar.Text = Text
	--Bar.Spark = Spark
	--Bar.Icon = Icon
	Bar.SafeZone = SafeZone
	self.Castbar = Bar

	--self.Castbar.UpdateOptions = RUF.CastbarUpdateOptions
end