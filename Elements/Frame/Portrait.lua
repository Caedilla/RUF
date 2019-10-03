local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

local function Update(self, event, unit)
	if(not unit or not UnitIsUnit(self.unit, unit)) then return end

	local element = self.Portrait

	--[[ Callback: Portrait:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Portrait element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then element:PreUpdate(unit) end

	local guid = UnitGUID(unit)
	local isAvailable = UnitIsConnected(unit) and UnitIsVisible(unit)
	if(event ~= 'OnUpdate' or element.guid ~= guid or element.state ~= isAvailable) then
		local profileReference = RUF.db.profile.unit[self.frame].Frame.Portrait

		if(element:IsObjectType('PlayerModel')) then
			if(not isAvailable) then
				element:SetCamDistanceScale(0.25)
				element:SetPortraitZoom(0)
				element:SetPosition(0, 0, 0.25)
				element:ClearModel()
				element:SetModel([[Interface\Buttons\TalkToMeQuestionMark.m2]])
			else
				element:SetPortraitZoom(profileReference.Model.PortraitZoom)
				element:SetCamDistanceScale(profileReference.Model.CameraDistance)
				element:SetPosition(profileReference.Model.z/10,profileReference.Model.x/10,-profileReference.Model.y/10)
				element:ClearModel()
				element:SetUnit(unit)
				element:SetPaused(profileReference.Model.Animation.Paused)
				element:MakeCurrentCameraCustom()
				element:SetCameraFacing(math.rad(-profileReference.Model.Rotation))
			end
		else
			SetPortraitTexture(element, unit)
		end

		element.guid = guid
		element.state = isAvailable
	end

	--[[ Callback: Portrait:PostUpdate(unit)
	Called after the element has been updated.

	* self - the Portrait element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit)
	end
end

function RUF.SetFramePortrait(self, unit)
	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait
	if not profileReference then return end

	local Portrait = CreateFrame('PlayerModel', nil, self)
	local Border = CreateFrame("Frame",nil,Portrait)
	local Background = Portrait:CreateTexture(nil,"BACKGROUND")
	local r,g,b

	-- Set Lighting
	-- Portrait:SetLight(true,false,-10,0,3,0.35,1,1,1,0.75,1,1,1)
	local dirX,dirY,dirZ,ambStr,ambR,ambG,ambB,dirStr,dirR,dirG,dirB
	dirX = -10
	dirY = 0
	dirZ = 3
	ambStr = 0.35
	ambR = 1
	ambG = 1
	ambB = 1
	dirStr = 0.75
	dirR = 1
	dirG = 1
	dirB = 1

	Portrait:SetLight(true,false,dirX,dirY,dirZ,ambStr,ambR,ambG,ambB,dirStr,dirR,dirG,dirB)

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


	if profileReference.Style == 1 then
		Portrait:SetAllPoints(self)
		Background:Hide()
		Border:Hide()
		Portrait:SetAlpha(profileReference.Alpha)
	elseif profileReference.Style == 2 then
		Portrait:SetAlpha(1)
		Portrait:SetSize(profileReference.Width,profileReference.Height)
		Portrait:SetPoint(profileReference.Position.AnchorFrom,self,profileReference.Position.AnchorTo,profileReference.Position.x,profileReference.Position.y)
	end

	-- Register with oUF
	self.Portrait = Portrait
	self.Portrait.Border = Border
	self.Portrait.Background = Background
	self.Portrait.Override = Update
	self.Portrait.UpdateOptions = RUF.PortraitUpdateOptions

	if profileReference.Enabled ~= true then
		self:DisableElement('Portrait')
	end
end

function RUF.PortraitUpdateOptions(self)
	local unit = self.__owner.frame
	local Portrait = self
	local Background = self.Background
	local Border = self.Border
	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait

	if profileReference.Style == 1 then
		Background:Hide()
		Border:Hide()
		Portrait:ClearAllPoints()
		Portrait:SetAllPoints(self)
		Portrait:SetAlpha(profileReference.Alpha)
	elseif profileReference.Style == 2 then
		Background:Show()
		Border:Show()
		Portrait:SetAlpha(1)
		Portrait:ClearAllPoints()
		Portrait:SetSize(profileReference.Width,profileReference.Height)
		Portrait:SetPoint(profileReference.Position.AnchorFrom,self,profileReference.Position.AnchorTo,profileReference.Position.x,profileReference.Position.y)

		-- Border
		local offset = profileReference.Border.Offset
		Border:SetPoint('TOPLEFT',Portrait,'TOPLEFT',-offset,offset)
		Border:SetPoint('BOTTOMRIGHT',Portrait,'BOTTOMRIGHT',offset,-offset)
		Border:SetFrameLevel(7)
		Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
		local r,g,b = unpack(profileReference.Border.Color)
		Border:SetBackdropBorderColor(r,g,b,profileReference.Border.Alpha)


		-- Background
		r,g,b = unpack(profileReference.Background.Color)
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(r,g,b,profileReference.Background.Alpha)
		Background:SetAllPoints(Portrait)
	end
end