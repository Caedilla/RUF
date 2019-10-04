local _, ns = ...
local oUF = ns.oUF


local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(self, bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	end
end


for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)


local f, min, max = CreateFrame('Frame'), math.min, math.max
f:SetScript('OnUpdate', function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)


--[[
if self.__owner.Portrait then
	local Portrait = self.__owner.Portrait
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	--local curWidth = Portrait:GetWidth()
	local frameWidth = self:GetWidth()
	local width = frameWidth * (cur/max)
	--Portrait:SetViewInsets((-frameWidth)+curWidth,0,0,0)
	Portrait:SetViewInsets((-frameWidth)+width,0,0,0)
end]]--