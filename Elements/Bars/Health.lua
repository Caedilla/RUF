local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

local function hslToRgb(h, s, l)
	if s == 0 then return l, l, l end
	local function to(p, q, t)
		if t < 0 then t = t + 1 end
		if t > 1 then t = t - 1 end
		if t < .16667 then return p + (q - p) * 6 * t end
		if t < .5 then return q end
		if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
		return p
	end
	local q = l < .5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function rgbToHsl(r, g, b)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local t = max + min
	local d = max - min
	local h, s, l

	if t == 0 then return 0, 0, 0 end
	l = t / 2

	s = l > .5 and d / (2 - t) or d / t

	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		h = (b - r) / d + 2
	elseif max == b then
		h = (r - g) / d + 4
	end

	h = h * 0.16667

	return h, s, l
end

function RUF.HealthUpdateColor(element, unit, cur, max)
	local r, g, b = RUF:GetBarColor(element, unit, 'Health', 'Health', cur)

	-- Update background
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier
	local a = RUF.db.profile.Appearance.Bars.Health.Background.Alpha
	if RUF.db.profile.Appearance.Bars.Health.Background.UseBarColor == false then
		r, g, b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	end
	element.__owner.Background.Base.Texture:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, a)

	-- Why on earth would I do it this way? What was I thinking? This is why you comment code.
	local Background = {}
	if element.__owner.frame == 'player' then
		Background = {
			element.__owner.Background.Base.Texture,
		}
	else
		Background = {
			element.__owner.Background.Base.Texture,
		}
	end

	for i = 1, #Background do
		if Background[i] then
			Background[i]:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
		end
	end

	-- Not ideal, gradient is applied to active portion of statusbar texture
	local gradientDirection = 'HORIZONTAL'



	local h,s,l = rgbToHsl(r/255, g/255, b/255)
	local ar, ab, ag = hslToRgb(((h * 360) + 67) / 360 , s, l)
	ar, ab, ag = ar *255, ab * 255, ag * 255


	--local ar, ab, ag = r * 0.5,g * 0.5 ,b * 0.5
	local br, bb, bg = r, g, b
	element:GetStatusBarTexture():SetGradient(gradientDirection, ar, ab, ag, br, bb, bg)

	--element:SetStatusBarColor(r,g,b)

end



local firstH, firstS, firstL = rgbToHsl(255/255, 151/255, 3/255)
local secondH, secondS, secondL = rgbToHsl(hslToRgb( ((firstH * 360) + 67) / 360, firstS, firstL))

local function updateRainbow()
	local a,b,c = hslToRgb(firstH, firstS, firstL)
	local x,y,z = hslToRgb(secondH, secondS, secondL)
	firstH = firstH + (1/360)
	secondH = secondH + (1/360)
	if firstH > 1 then
		firstH = 1/360
	end
	if secondH > 1 then
		secondH = 1/360
	end
	_G["oUF_RUF_Target"].Health:GetStatusBarTexture():SetGradient('VERTICAL', a, b, c, x, y, z)
end

C_Timer.NewTicker(0.001, updateRainbow)



function RUF.HealthUpdate(self, event, unit)
	if(not unit or self.unit ~= unit) then return end
	local element = self.Health

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local disconnected = not UnitIsConnected(unit)
	element:SetMinMaxValues(0, max)

	element.disconnected = disconnected
	element.tapped = tapped

	if(disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end

	if RUF.db.global.TestMode == true then
		cur = math.random(max /4, max - (max/4))
		element:SetValue(cur)
	end

	element:UpdateColor(unit, cur, max)

	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max)
	end
end

function RUF.SetHealthBar(self, unit)
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = CreateFrame('StatusBar', nil, self)

	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self)
	Bar:SetFrameLevel(11)
	Bar:SetFillStyle(RUF.db.profile.unit[self.frame].Frame.Bars.Health.Fill)
	Bar.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill

	-- Register with oUF
	self.Health = Bar
	self.Health.UpdateOptions = RUF.HealthUpdateOptions
end

function RUF.HealthUpdateOptions(self)
	local unit = self.__owner.frame
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Health.Texture)
	local Bar = self

	Bar.colorClass = RUF.db.profile.Appearance.Bars.Health.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Health.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Health.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Health.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Health.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Health.Color.Tapped
	Bar.colorHealth = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.unit[unit].Frame.Bars.Health.Animate
	Bar.frequentUpdates = true -- Is there an option for this? CHECK IT.
	Bar:SetStatusBarTexture(texture)
	Bar:SetAllPoints(self.__owner)
	Bar:SetFrameLevel(10)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Health.Fill)
	Bar.FillStyle = RUF.db.profile.unit[unit].Frame.Bars.Health.Fill

	if Bar.Smooth == true then
		self.__owner:SmoothBar(Bar)
	else
		self.__owner:UnSmoothBar(Bar)
	end

	self:ForceUpdate()
end