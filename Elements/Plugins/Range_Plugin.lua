--[[
# Element: Range Fader

Changes the opacity of a unit frame based on whether the frame's unit is in the player's range.

## Widget

Range - A table containing opacity values.

## Notes

Offline units are handled as if they are in range.

## Options

.outsideAlpha - Opacity when the unit is out of range. Defaults to 0.55 (number)[0-1].
.insideAlpha  - Opacity when the unit is within range. Defaults to 1 (number)[0-1].

## Examples

    -- Register with oUF
    self.RangeCheck = {
        insideAlpha = 1,
        outsideAlpha = 1/2,
    }
--]]

local _, ns = ...
local oUF = ns.oUF
local libRangeCheck = LibStub("LibRangeCheck-2.0")
local updateFrequency = 0.25 -- TODO Add Option somewhere

local _FRAMES = {}
local OnRangeFrame

local UnitInRange, UnitIsConnected = UnitInRange, UnitIsConnected

local function Update(self, event)
	local element = self.RangeCheck
	local unit = self.unit

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		local minRange, maxRange
		local connected = UnitIsConnected(unit)
		if(connected) then
			minRange, maxRange = libRangeCheck:GetRange(unit,true)
			if maxRange then
				if maxRange >= 40 then
					self:SetAlpha(element.outsideAlpha)
				else
					self:SetAlpha(element.insideAlpha)
				end
			else
				self:SetAlpha(element.insideAlpha)
			end
		else
			self:SetAlpha(element.insideAlpha)
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, minRange, maxRange, connected)
		end
	else
		self:SetAlpha(element.insideAlpha)
		self:DisableElement('RangeCheck')
	end
end

local function Path(self, ...)
	--[[ Override: Range.Override(self, event)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	--]]
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