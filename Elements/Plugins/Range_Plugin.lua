local _, ns = ...
local oUF = ns.oUF
local libRangeCheck = LibStub("LibRangeCheck-2.0")
local updateFrequency = 0.25 -- TODO Add Option somewhere
local _FRAMES = {}
local OnRangeFrame

local function Update(self, event)
	local element = self.RangeCheck
	local unit = self.unit
	local currentAlpha = self.Alpha or 1 -- Work with combat fader

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		local minRange, maxRange
		local connected = UnitIsConnected(unit)
		if(connected) then
			local isEnemy = UnitCanAttack('player', unit)
			local isFriend = UnitCanAssist('player', unit)
			minRange, maxRange = libRangeCheck:GetRange(unit,true)
			if minRange and not maxRange then
				maxRange = minRange
			end
			if maxRange then
				if (not isEnemy and maxRange > 40) or (isEnemy and maxRange > 30) or (not isEnemy and not isFriend and maxRange >= 28) then
					self:SetAlpha(currentAlpha * element.outsideAlpha)
				else
					self:SetAlpha(currentAlpha * element.insideAlpha)
				end
			else
				self:SetAlpha(currentAlpha * element.insideAlpha)
			end
		else
			self:SetAlpha(currentAlpha * element.insideAlpha)
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, minRange, maxRange, connected)
		end
	else
		self:SetAlpha(currentAlpha * element.insideAlpha)
		self:DisableElement('RangeCheck')
	end
end

local function Path(self, ...)
	return (self.RangeCheck.Override or Update) (self, ...)
end

-- Internal updating method
local timer = 0
local function OnRangeUpdate(_, elapsed)
	timer = timer + elapsed

	if(timer >= updateFrequency) then
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				Path(object, 'OnUpdate')
			end
		end

		timer = 0
	end
end

local function Enable(self)
	local element = self.RangeCheck
	if(element) then
		element.__owner = self
		element.insideAlpha = element.insideAlpha or 1
		element.outsideAlpha = element.outsideAlpha or 0.55

		if(not OnRangeFrame) then
			OnRangeFrame = CreateFrame('Frame')
			OnRangeFrame:SetScript('OnUpdate', OnRangeUpdate)
		end

		table.insert(_FRAMES, self)
		OnRangeFrame:Show()

		return true
	end
end

local function Disable(self)
	local element = self.RangeCheck
	if(element) then
		for index, frame in next, _FRAMES do
			if(frame == self) then
				table.remove(_FRAMES, index)
				break
			end
		end
		self:SetAlpha(element.insideAlpha)

		if(#_FRAMES == 0) then
			OnRangeFrame:Hide()
		end
	end
end

oUF:AddElement('RangeCheck', nil, Enable, Disable)