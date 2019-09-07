local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
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

local function onUpdate(self, elapsed)
	if RUF.db.global.TestMode == true and not InCombatLockdown() then
		local duration = self.duration or 0
		local add = elapsed or 0
		duration = duration + add
		self.duration = duration
		if duration < 30.05 then
			self:Show()
			self:SetMinMaxValues(0,30)
			self:SetValue(duration)
			self.Time:SetFormattedText('%.1f', duration)
			self.Text:SetText(L["Cast Bar"])
		else
			self.duration = 0
		end
	elseif(self.casting) then
		local duration = self.duration + elapsed
		if(duration >= self.max) then
			self.casting = nil
			self:Hide()

			if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
			return
		end

		if(self.Time) then
			if(self.delay ~= 0) then
				if(self.CustomDelayText) then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText('%.1f|cffff0000-%.1f|r', duration, self.delay)
				end
			else
				if(self.CustomTimeText) then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText('%.1f', duration)
				end
			end
		end

		self.duration = duration
		self:SetValue(duration)

		if(self.Spark) then
			local horiz = self.horizontal
			local size = self[horiz and 'GetWidth' or 'GetHeight'](self)

			local offset = (duration / self.max) * size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
	elseif(self.channeling) then
		local duration = self.duration - elapsed

		if(duration <= 0) then
			self.channeling = nil
			self:Hide()

			if(self.PostChannelStop) then self:PostChannelStop(self.__owner.unit) end
			return
		end

		if(self.Time) then
			if(self.delay ~= 0) then
				if(self.CustomDelayText) then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText('%.1f|cffff0000-%.1f|r', duration, self.delay)
				end
			else
				if(self.CustomTimeText) then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText('%.1f', duration)
				end
			end
		end

		self.duration = duration
		self:SetValue(duration)
		if(self.Spark) then
			local horiz = self.horizontal
			local size = self[horiz and 'GetWidth' or 'GetHeight'](self)

			local offset = (duration / self.max) * size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
	elseif(self.holdTime > 0) then
		self.holdTime = self.holdTime - elapsed
	else
		self.casting = nil
		self.castID = nil
		self.channeling = nil
		self.duration = nil
		self:Hide()
	end
end


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
	local Time = Bar:CreateFontString(nil, 'OVERLAY', 'Raeli')
	local Text = Bar:CreateFontString(nil, 'OVERLAY', 'Raeli')
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

	self.Castbar.OnUpdate = onUpdate
	self.Castbar.PostCastStart = RUF.CastBarUpdate
	self.Castbar.PostChannelStart = RUF.CastBarUpdate
	self.Castbar.UpdateOptions = RUF.CastBarUpdateOptions
end

function RUF.CastBarUpdate(element, unit, name)
	local unitFrame = element.__owner
	local r,g,b

	r,g,b = RUF:GetBarColor(element, unit, "Cast")
	element:SetStatusBarColor(r,g,b)
	if RUF.db.profile.Appearance.Bars.Cast.SafeZone.Enabled == true then
		local sr,sg,sb = unpack(RUF.db.profile.Appearance.Bars.Cast.SafeZone.Color)
		local sa = RUF.db.profile.Appearance.Bars.Cast.SafeZone.Alpha
		element.SafeZone:SetColorTexture(sr, sg, sb, sa)
	else
		element.SafeZone:SetColorTexture(0, 0, 0, 0)
	end
end

function RUF.CastBarUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self

	local texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Cast.Texture)
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Cast.Fill)
end