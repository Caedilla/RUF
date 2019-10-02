local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

function RUF.SetFramePortrait(self, unit)
	-- 3D Portrait
	-- Position and size
	--local Portrait = CreateFrame('PlayerModel', nil, self)
	--Portrait:SetSize(32, 32)
	--Portrait:SetAllPoints(self)

	-- Register it with oUF
	--self.Portrait = Portrait

	-- 2D Portrait
	--local Portrait = self:CreateTexture(nil, 'OVERLAY')
	--Portrait:SetSize(32, 32)
	--Portrait:SetPoint('RIGHT', self, 'LEFT')

	-- Register it with oUF
	--self.Portrait = Portrait


	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait
	if not profileReference then return end

	local Portrait = CreateFrame('PlayerModel', nil, self)
	local Border = CreateFrame("Frame",nil,Portrait)
	local Background = Portrait:CreateTexture(nil,"BACKGROUND")
	local r,g,b

	if profileReference.Style == 1 then
		Portrait:SetAllPoints(self)
	elseif profileReference.Style == 2 then
		Portrait:SetSize(profileReference.Width,profileReference.Height)
		Portrait:SetPoint(profileReference.Position.AnchorFrom,self,profileReference.Position.AnchorTo,profileReference.Position.x,profileReference.Position.y)
	end

	Portrait:SetAlpha(profileReference.Alpha)
	Portrait:SetPaused(true) -- Whether to animate or not.

	-- In Radians. 0 is a facing of about 45 degrees.
	-- Degrees x math.pi / 180 = radian

	-- math.pi * 2 = default position

	-- https://en.wikipedia.org/wiki/Radian


	-- TODO: Make a list of cam positions and rotations for each main character race, and a default "good enough" for non-player units to make them face left or right since
	-- (-math.pi / 4) aka 45 degrees is not the same on every unit as every races's default facing is slightly different.


	Portrait:SetFacing(/run oUF_RUF_Player.Portrait:SetFacing(-math.pi/2))
	--Portrait:SetFrameStrata(profileReference.Strata)
	--Portrait:SetFrameLevel(profileReference.Level)

	-- Border
	local offset = profileReference.Border.Offset
	Border:SetPoint('TOPLEFT',Portrait,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Portrait,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
	r,g,b = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(r,g,b,profileReference.Border.Alpha)

	-- Background
	r,g,b = unpack(profileReference.Background.Color)
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r,g,b,profileReference.Background.Alpha)
	Background:SetAllPoints(Portrait)

	-- Register with oUF
	self.Portrait = Portrait
	self.Portrait.Border = Border
	self.Portrait.Background = Background
	self.Portrait.UpdateOptions = RUF.PortraitUpdateOptions

end

function RUF.PortraitUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self
	local Border = self.Border

	-- TODO
end