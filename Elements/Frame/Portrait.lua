local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

function RUF.PortraitHealthUpdate(self)
	local frame = self.__owner
	local profileReference = RUF.db.profile.unit[frame.frame].Frame.Portrait
	if profileReference.Enabled ~= true then
		frame:DisableElement('Portrait')
		frame.Portrait:Hide()
		return end
	if profileReference.Cutaway and (not frame.Health.Smooth or RUF.db.global.TestMode == true) then
		local element = frame.Portrait
		local cur, max = UnitHealth(frame.unit), UnitHealthMax(frame.unit)
		if RUF.db.global.TestMode == true then
			cur = frame.Health:GetValue()
		end
		local frameWidth = frame:GetWidth()
		local width = frameWidth * (cur/max)
		if frame.Health.FillStyle == 'REVERSE' then
			element:SetViewInsets((-frameWidth)+width,0,0,0) -- Right
		elseif frame.Health.FillStyle == 'CENTER' then
			element:SetViewInsets(((-frameWidth)+width)/2,((-frameWidth)+width)/2,0,0)
		else
			element:SetViewInsets(0,(-frameWidth)+width,0,0) -- Left
		end
	end
end

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
		if(element:IsObjectType('PlayerModel')) then
			if(not isAvailable) then
				element:SetCamDistanceScale(0.25)
				element:SetPortraitZoom(0)
				element:SetPosition(0, 0, 0.25)
				element:ClearModel()
				element:SetModel([[Interface\Buttons\TalkToMeQuestionMark.m2]])
			else
				local profileReference = RUF.db.profile.unit[self.frame].Frame.Portrait
				local desaturate = 0
				if profileReference.Model.Desaturate == true then
					desaturate = 1
				end
				element:SetPortraitZoom(profileReference.Model.PortraitZoom)
				element:SetCamDistanceScale(profileReference.Model.CameraDistance)
				element:SetPosition(profileReference.Model.z/10,profileReference.Model.x/10,-profileReference.Model.y/10)
				element:ClearModel()
				element:SetUnit(unit)
				element:SetPaused(profileReference.Model.Animation.Paused)
				element:SetViewInsets(0,0,0,0)
				element:MakeCurrentCameraCustom()
				element:SetCameraFacing(math.rad(-profileReference.Model.Rotation))
				element:SetDesaturation(desaturate)
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
	Portrait:SetFrameLevel(11)

	-- Border
	local offset = profileReference.Border.Offset
	Border:SetPoint('TOPLEFT',Portrait,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',Portrait,'BOTTOMRIGHT',offset,-offset)
	Border:SetFrameLevel(12)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
	r,g,b = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(r,g,b,profileReference.Border.Alpha)


	-- Background
	r,g,b = unpack(profileReference.Background.Color)
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r,g,b,profileReference.Background.Alpha)
	Background:SetAllPoints(Portrait)


	if profileReference.Style == 1 then
		Background:Hide()
		Border:Hide()
		Portrait:SetAlpha(profileReference.Alpha)
		if profileReference.Cutaway == true then
			Portrait:ClearAllPoints()
			Portrait:SetAllPoints(self.Health:GetStatusBarTexture())
			Portrait.Cutaway = true
		else
			Portrait:ClearAllPoints()
			Portrait:SetAllPoints(self)
		end
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
	self.Portrait.Enabled = true
	self.Health.PreUpdate = RUF.PortraitHealthUpdate

	if profileReference.Enabled ~= true then
		self:DisableElement('Portrait')
		self.Portrait.Enabled = false
	end
end


-- TODO Update BarAnimation plugin to check enabled state as well as health preupdate
function RUF.PortraitUpdateOptions(self)
	local unit = self.__owner.frame
	local Portrait = self
	local Background = self.Background
	local Border = self.Border
	local profileReference = RUF.db.profile.unit[unit].Frame.Portrait
	if profileReference.Enabled == true then
		Portrait.Enabled = true
		self.__owner:EnableElement('Portrait')
		Portrait:Show()
		if profileReference.Style == 1 then
			Background:Hide()
			Border:Hide()
			Portrait.Cutaway = profileReference.Cutaway
			Portrait:SetAlpha(profileReference.Alpha)
			if profileReference.Cutaway == true then
				Portrait:ClearAllPoints()
				Portrait:SetAllPoints(self.__owner.Health:GetStatusBarTexture())
				RUF.PortraitHealthUpdate(Portrait)
			else
				Portrait:ClearAllPoints()
				Portrait:SetAllPoints(self.__owner)
				Portrait:SetViewInsets(0,0,0,0)
			end
		elseif profileReference.Style == 2 then
			Background:Show()
			Border:Show()
			Portrait:SetAlpha(1)
			Portrait:ClearAllPoints()
			Portrait:SetViewInsets(0,0,0,0)
			Portrait:SetSize(profileReference.Width,profileReference.Height)
			Portrait:SetPoint(profileReference.Position.AnchorFrom,self.__owner,profileReference.Position.AnchorTo,profileReference.Position.x,profileReference.Position.y)

			-- Border
			local offset = profileReference.Border.Offset
			Border:SetPoint('TOPLEFT',Portrait,'TOPLEFT',-offset,offset)
			Border:SetPoint('BOTTOMRIGHT',Portrait,'BOTTOMRIGHT',offset,-offset)
			Border:SetFrameLevel(17)
			Border:SetBackdrop({edgeFile = LSM:Fetch("border", profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
			local r,g,b = unpack(profileReference.Border.Color)
			Border:SetBackdropBorderColor(r,g,b,profileReference.Border.Alpha)

			-- Background
			r,g,b = unpack(profileReference.Background.Color)
			Background:SetTexture(LSM:Fetch("background", "Solid"))
			Background:SetVertexColor(r,g,b,profileReference.Background.Alpha)
			Background:SetAllPoints(Portrait)

			Portrait.Cutaway = false
		end
	else
		Portrait.Enabled = false
		self.__owner:DisableElement('Portrait')
		Portrait:Hide()
	end
end