--[[
# Element: Absorb Bars

Handles the visibility and updating of damage absorbs.

## Widget

Absorb - A `StatusBar` used to represent the unit's Damage Absorbption.

## Notes
A default texture will be applied to the StatusBar widgets if they don't have a texture set.
A default texture will be applied to the Texture widgets if they don't have a texture or a color set.

## Options
.frequentUpdates - Indicates whether to use UNIT_HEALTH_FREQUENT instead of UNIT_HEALTH. Use this if .frequentUpdates is
				   also set on the Health element (boolean)

## Examples

	-- Position and size
	local Absorb = CreateFrame('StatusBar', nil, self)
	Absorb:SetHeight(20)
	Absorb:SetPoint('BOTTOM')
	Absorb:SetPoint('LEFT')
	Absorb:SetPoint('RIGHT')

	-- Options
	Absorb.frequentUpdates = true

	-- Register it with oUF
	self.Absorb = Absorb
--]]

local _, ns = ...
local oUF = ns.oUF

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local element = self.Absorb

	--[[ Callback: Absorb:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Absorb element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local absorb = UnitGetTotalAbsorbs(unit) or 0
	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)


	element:SetMinMaxValues(0, maxHealth)
	element:SetValue(absorb)
	element:Show()

	--[[ Callback: Absorb:PostUpdate(unit, absorb)
	Called after the element has been updated.

	* self			  - the Absorb element
	* unit			  - the unit for which the update has been triggered (string)
	* absorb			- the amount of damage the unit can absorb without losing health (number)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit, absorb)
	end
end

local function Path(self, ...)
	--[[ Override: Absorb.Override(self, event, unit)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event
	--]]
	return (self.Absorb.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.Absorb
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if(element.frequentUpdates) then
			self:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)
		else
			self:RegisterEvent('UNIT_HEALTH', Path)
		end

		self:RegisterEvent('UNIT_MAXHEALTH', Path)
		self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
		self:RegisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)

		if(element:IsObjectType('StatusBar')) then
			element.texture = element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or [[Interface\TargetingFrame\UI-StatusBar]]
			element:SetStatusBarTexture(element.texture)
		end

		element:Show()
		return true
	end
end

local function Disable(self)
	local element = self.Absorb
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_HEALTH', Path)
		self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		self:UnregisterEvent('UNIT_HEALTH_FREQUENT', Path)
		self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
		self:UnregisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
	end
end

oUF:AddElement('Absorb', Path, Enable, Disable)
