--[[
# Element: FakeClassPower

Handles the visibility and updating of the player's class resources (like Chi Orbs or Holy Power) and combo points.

## Widget

FakeClassPower - An `table` consisting of as many StatusBars as the theoretical maximum return of [UnitPowerMax](http://wowprogramming.com/docs/api/UnitPowerMax.html).

## Sub-Widgets

.bg - A `Texture` used as a background. It will inherit the color of the main StatusBar.

## Sub-Widget Options

.multiplier - Used to tint the background based on the widget's R, G and B values. Defaults to 1 (number)[0-1]

## Notes

A default texture will be applied if the sub-widgets are StatusBars and don't have a texture set.
If the sub-widgets are StatusBars, their minimum and maximum values will be set to 0 and 1 respectively.

Supported class powers:
  - All	 - Combo Points
  - Mage	- Arcane Charges
  - Monk	- Chi Orbs
  - Paladin - Holy Power
  - Warlock - Soul Shards

## Examples

	local FakeClassPower = {}
	for index = 1, 10 do
		local Bar = CreateFrame('StatusBar', nil, self)

		-- Position and size.
		Bar:SetSize(16, 16)
		Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', (index - 1) * Bar:GetWidth(), 0)

		FakeClassPower[index] = Bar
	end

	-- Register with oUF
	self.FakeClassPower = FakeClassPower
--]]

local _, ns = ...
local oUF = ns.oUF

local _, PlayerClass = UnitClass('player')

-- Holds the class specific stuff.
local ClassPowerID, ClassPowerType
local FakeClassPowerEnable, FakeClassPowerDisable
local RequireSpec, RequirePower
local RequireSpell = false

local function UpdateColor(element, powerType)
	local color = element.__owner.colors.power[powerType]
	local r, g, b = color[1], color[2], color[3]
	element:SetStatusBarColor(r, g, b)
end

local function Update(self, event, unit, powerType)
	if(not (unit and (UnitIsUnit(unit, 'player') and powerType == ClassPowerType))) then
		return
	end


	local element = self.FakeClassPower

	--[[ Callback: FakeClassPower:PreUpdate(event)
	Called before the element has been updated.

	* self  - the FakeClassPower element
	]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local cur, max = UnitPower(unit,ClassPowerID), UnitPowerMax(unit,ClassPowerID)

	element:SetMinMaxValues(0, max)
	element:SetValue(cur)

	--[[ Callback: FakeClassPower:PostUpdate(cur, max, hasMaxChanged, powerType)
	Called after the element has been updated.

	* self		  - the FakeClassPower element
	* cur		   - the current amount of power (number)
	* max		   - the maximum amount of power (number)
	* hasMaxChanged - indicates whether the maximum amount has changed since the last update (boolean)
	* powerType	 - the active power type (string)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(cur, max, false, powerType)
	end
end

local function Path(self, ...)
	--[[ Override: FakeClassPower.Override(self, event, unit, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.FakeClassPower.Override or Update) (self, ...)
end

local function Visibility(self, event, unit)
	local element = self.FakeClassPower
	local shouldEnable

	if(UnitHasVehicleUI('player')) then
		shouldEnable = PlayerVehicleHasComboPoints()
		unit = 'vehicle'
	elseif(ClassPowerID) then
		if(not RequireSpec or RequireSpec == GetSpecialization()) then
			-- use 'player' instead of unit because 'SPELLS_CHANGED' is a unitless event
			if(not RequirePower or RequirePower == UnitPowerType('player')) then
				if(not RequireSpell or IsPlayerSpell(RequireSpell)) then
					self:UnregisterEvent('SPELLS_CHANGED', Visibility)
					shouldEnable = true
					unit = 'player'
				else
					self:RegisterEvent('SPELLS_CHANGED', Visibility, true)
				end
			end
		end
	end

	local isEnabled = element.isEnabled
	local powerType = ClassPowerType

	if(shouldEnable) then
		--[[ Override: FakeClassPower:UpdateColor(powerType)
		Used to completely override the internal function for updating the widgets' colors.

		* self	  - the FakeClassPower element
		* powerType - the active power type (string)
		--]]
		(element.UpdateColor or UpdateColor) (element, powerType)
	end

	if(shouldEnable and not isEnabled) then
		FakeClassPowerEnable(self)
	elseif(not shouldEnable and (isEnabled or isEnabled == nil)) then
		FakeClassPowerDisable(self)
	elseif(shouldEnable and isEnabled) then
		Path(self, event, unit, powerType)
	end
end

local function VisibilityPath(self, ...)
	--[[ Override: FakeClassPower.OverrideVisibility(self, event, unit)
	Used to completely override the internal visibility function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	return (self.FakeClassPower.OverrideVisibility or Visibility) (self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

do
	function FakeClassPowerEnable(self)
		self:RegisterEvent('UNIT_MAXPOWER', Path)

		self.FakeClassPower.isEnabled = true
		local element = self.FakeClassPower
		element:Show()

		Path(self, 'FakeClassPowerEnable', 'player', ClassPowerType)
	end

	function FakeClassPowerDisable(self)
		self:UnregisterEvent('UNIT_MAXPOWER', Path)

		local element = self.FakeClassPower
		element:Hide()

		self.FakeClassPower.isEnabled = false
		Path(self, 'FakeClassPowerDisable', 'player', ClassPowerType)
	end

	if(PlayerClass == 'DRUID') then
		ClassPowerID = 8
		ClassPowerType = 'LUNAR_POWER'
		RequirePower = Enum.PowerType.LunarPower
	elseif(PlayerClass == 'PRIEST') then
		ClassPowerID = 13
		ClassPowerType = 'INSANITY'
		RequireSpec = 3
	elseif(PlayerClass == 'SHAMAN') then
		ClassPowerID = 11
		ClassPowerType = 'MAELSTROM'
		RequirePower = Enum.PowerType.Maelstrom
	end
end

--[[ Power:SetFrequentUpdates(state)
Used to toggle frequent updates.

* self  - the Power element
* state - the desired state of frequent updates (boolean)
--]]
local function SetFrequentUpdates(element, state)
	if(element.frequentUpdates ~= state) then
		element.frequentUpdates = state
		if(element.frequentUpdates) then
			element.__owner:UnregisterEvent('UNIT_POWER_UPDATE', Path)
			element.__owner:RegisterEvent('UNIT_POWER_FREQUENT', Path)
		else
			element.__owner:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
			element.__owner:RegisterEvent('UNIT_POWER_UPDATE', Path)
		end
	end
end

local function Enable(self, unit)
	local element = self.FakeClassPower
	if(element and UnitIsUnit(unit, 'player')) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.SetFrequentUpdates = SetFrequentUpdates

		if(element.frequentUpdates) then
			self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
		else
			self:RegisterEvent('UNIT_POWER_UPDATE', Path)
		end

		if(RequireSpec) then
			self:RegisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath, true)
		end

		if(RequirePower) then
			self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		end

		element.FakeClassPowerEnable = FakeClassPowerEnable
		element.FakeClassPowerDisable = FakeClassPowerDisable

		if(element:IsObjectType('StatusBar')) then
			element.texture = element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or [[Interface\TargetingFrame\UI-StatusBar]]
			element:SetStatusBarTexture(element.texture)
		end

		if(not element.UpdateColor) then
			element.UpdateColor = UpdateColor
		end

		return true
	end
end

local function Disable(self)
	if(self.FakeClassPower) then
		FakeClassPowerDisable(self)

		self:UnregisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:UnregisterEvent('SPELLS_CHANGED', Visibility)
		self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
		self:UnregisterEvent('UNIT_POWER_UPDATE', Path)

	end
end

oUF:AddElement('FakeClassPower', VisibilityPath, Enable, Disable)
