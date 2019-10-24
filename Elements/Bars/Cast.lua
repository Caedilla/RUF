local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	local LibClassicCasterino = LibStub('LibClassicCasterino', true)
	UnitCastingInfo = CastingInfo
	UnitChannelInfo = ChannelInfo
	if LibClassicCasterino then
		UnitCastingInfo = function(unit)
			return LibClassicCasterino:UnitCastingInfo(unit)
		end

		UnitChannelInfo = function(unit)
			return LibClassicCasterino:UnitChannelInfo(unit)
		end
	end
end

local function onUpdate(self, elapsed)
	if self.Enabled == false then self:Hide() return end
	elapsed = elapsed or 0
	self.updateThrottle = self.updateThrottle or 0
	self.updateThrottle = self.updateThrottle + elapsed
	if self.updateThrottle < 0.0125 then return end
	local add = self.updateThrottle
	self.updateThrottle = 0
	if RUF.db.global.TestMode == true and not InCombatLockdown() then
		local duration = self.testDuration or 0
		duration = duration + add
		self.testDuration = duration
		self:Show()
		if duration < 30.05 then
			self:SetMinMaxValues(0, 30)
			self:SetValue(duration)
			self.Time:SetFormattedText('%.1f', duration)
			self.Text:SetText(L['Cast Bar'] .. ' - ' .. L[self.__owner.frame])
		else
			self.testDuration = 0
		end
	elseif(self.casting) then
		local duration = self.duration + add
		if(duration >= self.max) then
			self.casting = nil
			self:Hide()

			if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
			return
		end

		if(self.Time) then --and RUF.db.profile.unit[self.__owner.frame].Frame.Bars.Cast.Time.Enabled then
			--local style = RUF.db.profile.unit[self.__owner.frame].Frame.Bars.Cast.Time.Style
			--if style == 1 then
			--elseif style == 2 then
			--end
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

			local offset = (duration/self.max)*size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
	elseif(self.channeling) then
		local duration = self.duration - add

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

			local offset = (duration/self.max)*size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
	elseif(self.holdTime > 0) then
		self.holdTime = self.holdTime - add
	else
		self.casting = nil
		self.castID = nil
		self.channeling = nil
		self.testDuration = nil
		self:Hide()
	end
end

function RUF.SetCastBar(self, unit)
	local profileReference = RUF.db.profile.Appearance.Bars.Cast
	local unitProfile = RUF.db.profile.unit[unit].Frame.Bars.Cast
	local texture = LSM:Fetch('statusbar', profileReference.Texture)
	local Bar = CreateFrame('StatusBar', nil, self)
	local Border = CreateFrame('Frame', nil, Bar)
	local Background = Bar:CreateTexture(nil, 'BACKGROUND')

	-- Bar
	Bar.colorClass = profileReference.Color.Class
	Bar.colorDisconnected = profileReference.Color.Disconnected
	Bar.colorSmooth = profileReference.Color.Percentage
	Bar.smoothGradient = profileReference.Color.PercentageGradient
	Bar.colorReaction = profileReference.Color.Reaction
	Bar.colorTapping = profileReference.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(200)
	Bar:SetFillStyle(unitProfile.Fill)
	Bar:SetWidth(unitProfile.Width)
	Bar:SetHeight(unitProfile.Height)
	Bar:SetClampedToScreen(true)
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
	Border:SetFrameLevel(201)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, profileReference.Border.Alpha)

	-- Background
	local r, g, b = unpack(profileReference.Background.CustomColor)
	local Multiplier = profileReference.Background.Multiplier
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(r*Multiplier, g*Multiplier, b*Multiplier, profileReference.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Text
	local Time = Bar:CreateFontString(nil, 'OVERLAY', 'Raeli')
	local Text = Bar:CreateFontString(nil, 'OVERLAY', 'Raeli')
	if unitProfile.Fill == 'REVERSE' then
		Time:SetPoint('LEFT', Bar, 4, 0)
		Text:SetPoint('RIGHT', Bar, -4, 0)
	else
		Time:SetPoint('RIGHT', Bar, -4, 0)
		Text:SetPoint('LEFT', Bar, 4, 0)
	end

	-- Spark
	--local Spark = Bar:CreateTexture(nil, 'OVERLAY')
	--Spark:SetSize(10, unitProfile.Height*1.5)
	--Spark:SetBlendMode('ADD')

	-- Icon
	--local Icon = Castbar:CreateTexture(nil, 'OVERLAY')
	--Icon:SetSize(20, 20)
	--Icon:SetPoint('TOPLEFT', Castbar, 'TOPLEFT')

	-- Safe Zone
	if unit == 'player' then
		local SafeZone = Bar:CreateTexture(nil, 'OVERLAY')
		local sr, sg, sb = unpack(RUF.db.profile.Appearance.Bars.Cast.SafeZone.Color)
		local sa = RUF.db.profile.Appearance.Bars.Cast.SafeZone.Alpha
		SafeZone:SetColorTexture(sr, sg, sb, sa)
		Bar.SafeZone = SafeZone
	end

	-- Register with oUF
	Bar.Background = Background
	Bar.Border = Border
	Bar.Time = Time
	Bar.Text = Text
	--Bar.Spark = Spark
	--Bar.Icon = Icon
	self.Cast = Bar

	self.Cast.OnUpdate = onUpdate
	self.Cast.PostCastStart = RUF.CastUpdate
	self.Cast.PostChannelStart = RUF.ChannelUpdate
	self.Cast.PostCastInterrupted = RUF.CastInterrupted
	self.Cast.PostCastInterruptible = RUF.CastUpdate
	self.Cast.UpdateOptions = RUF.CastUpdateOptions
	self.Cast.Enabled = RUF.db.profile.unit[unit].Frame.Bars.Cast.Enabled

	r, g, b = RUF:GetBarColor(self.Cast, unit, 'Cast')
	Bar:SetStatusBarColor(r, g, b)
end

function RUF.CastInterrupted(element, unit, name)
	if element.Enabled == false then element:Hide() return end
	local unitFrame = element.__owner
	local r, g, b, a, bgMult
	local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
	if notInterruptible and RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Enabled then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Color)
	else
		r, g, b = RUF:GetBarColor(element, unit, 'Cast')
	end
	element:SetStatusBarColor(r, g, b)
	if element.SafeZone then
		if RUF.db.profile.Appearance.Bars.Cast.SafeZone.Enabled == true then
			local sr, sg, sb = unpack(RUF.db.profile.Appearance.Bars.Cast.SafeZone.Color)
			local sa = RUF.db.profile.Appearance.Bars.Cast.SafeZone.Alpha
			element.SafeZone:SetColorTexture(sr, sg, sb, sa)
		else
			element.SafeZone:SetColorTexture(0, 0, 0, 0)
		end
	end
	if RUF.db.profile.Appearance.Bars.Cast.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.Background.CustomColor)
	end
	bgMult = RUF.db.profile.Appearance.Bars.Cast.Background.Multiplier
	a = RUF.db.profile.Appearance.Bars.Cast.Background.Alpha
	element.Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)
end

function RUF.CastUpdate(element, unit, name)
	if element.Enabled == false then element:Hide() return end
	local unitFrame = element.__owner
	local r, g, b, a, bgMult
	local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
	if notInterruptible and RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Enabled then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Color)
	else
		r, g, b = RUF:GetBarColor(element, unit, 'Cast')
	end
	element:SetStatusBarColor(r, g, b)
	if element.SafeZone then
		if RUF.db.profile.Appearance.Bars.Cast.SafeZone.Enabled == true then
			local sr, sg, sb = unpack(RUF.db.profile.Appearance.Bars.Cast.SafeZone.Color)
			local sa = RUF.db.profile.Appearance.Bars.Cast.SafeZone.Alpha
			element.SafeZone:SetColorTexture(sr, sg, sb, sa)
		else
			element.SafeZone:SetColorTexture(0, 0, 0, 0)
		end
	end
	if RUF.db.profile.Appearance.Bars.Cast.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.Background.CustomColor)
	end
	bgMult = RUF.db.profile.Appearance.Bars.Cast.Background.Multiplier
	a = RUF.db.profile.Appearance.Bars.Cast.Background.Alpha
	element.Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)
end

function RUF.ChannelUpdate(element, unit, name)
	if element.Enabled == false then element:Hide() return end
	local unitFrame = element.__owner
	local r, g, b, a, bgMult
	local _, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
	if notInterruptible and RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Enabled then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.ColorInterrupt.Color)
	else
		r, g, b = RUF:GetBarColor(element, unit, 'Cast')
	end
	element:SetStatusBarColor(r, g, b)
	if element.SafeZone then
		if RUF.db.profile.Appearance.Bars.Cast.SafeZone.Enabled == true then
			local sr, sg, sb = unpack(RUF.db.profile.Appearance.Bars.Cast.SafeZone.Color)
			local sa = RUF.db.profile.Appearance.Bars.Cast.SafeZone.Alpha
			element.SafeZone:SetColorTexture(sr, sg, sb, sa)
		else
			element.SafeZone:SetColorTexture(0, 0, 0, 0)
		end
	end
	if RUF.db.profile.Appearance.Bars.Cast.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Cast.Background.CustomColor)
	end
	bgMult = RUF.db.profile.Appearance.Bars.Cast.Background.Multiplier
	a = RUF.db.profile.Appearance.Bars.Cast.Background.Alpha
	element.Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)
end

function RUF.CastUpdateOptions(self)
	local unit = self.__owner.frame
	local Bar = self
	local Border = self.Border
	local profileReference = RUF.db.profile.Appearance.Bars.Cast

	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(17)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', profileReference.Border.Style.edgeFile), edgeSize = profileReference.Border.Style.edgeSize})
	local borderr, borderg, borderb = unpack(profileReference.Border.Color)
	Border:SetBackdropBorderColor(borderr, borderg, borderb, profileReference.Border.Alpha)

	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Cast.Texture)
	Bar:SetStatusBarTexture(texture)
	Bar:SetFrameLevel(15)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Cast.Fill)
	Bar:PostCastStart(unit)
	Bar:OnUpdate()
end