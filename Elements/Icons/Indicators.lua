local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
RUF.Indicators = RUF.Indicators or {}

RUF.IndicatorGlyphs = {
	['Assist'] = '',
	['InCombat'] = '',
	['Lead'] = '',
	['LootMaster'] = '',
	['MainAssist'] = '',
	['MainTank'] = '',
	['Objective'] = '',
	['Phased'] = '',
	['PvP-Alliance'] = '',
	['PvP-Horde'] = '',
	['Ready-No'] = '',
	['Ready-Question'] = '',
	['Ready-Yes'] = '',
	['Resting'] = '',
	['Role-DPS'] = '', -- Fire
	['Role-DPS-Alternative-1'] = '', -- Sword
	['Role-Heal'] = '',
	['Role-Heal-Alternative-1'] = '', -- Heart
	['Role-Heal-Alternative-2'] = '', -- Plaster
	['Role-Tank'] = '',
	['Target-Circle'] = '',
	['Target-Cross'] = '',
	['Target-Diamond'] = '',
	['Target-Moon'] = '',
	['Target-Skull'] = '',
	['Target-Square'] = '',
	['Target-Star'] = '',
	['Target-Triangle'] = '',
}

-- TODO
--[[
	Two attach modes - one free form, you choose anchor and offsets and the icon just stays there.
	You can attach to other elements but when they are not visible, the element stays where it is.

	Second mode, choose an area, and we make a table of elements in that area.
	Each element has a location and order associated with it.
	Elements lower in the order are offset from the original anchor point automatically set by me - no option.
	So center icons grow out horizontally, icons in the top-right will grow left, icons in the top-left will grow right.

	Check the visibility of parent elements on their update function. If not visible, swap their positions?
		X - Y - Z becomes
		Y - X - Z Z updates and it becomes
		Y - Z - X with x hidden.

	Or, get width of parent, and offset correctly based on width
	So
	A = 30
	B = 25

	becomes
	B = 25 - Aw
]]--

function RUF.SetIndicators(self, unit)
	local Indicators = CreateFrame('Frame', nil, self)

	Indicators:SetAllPoints(self)
	Indicators:SetFrameLevel(15)

	self.Indicators = Indicators

	RUF.Indicators.Assist(self,unit)
	RUF.Indicators.InCombat(self, unit)
	RUF.Indicators.Lead(self, unit)
	RUF.Indicators.MainTankAssist(self, unit)
	RUF.Indicators.Phased(self, unit)
	RUF.Indicators.PvPCombat(self, unit)

	RUF.Indicators.Ready(self, unit)
	RUF.Indicators.Rest(self, unit)
	RUF.Indicators.TargetMark(self, unit)
	if RUF.Client == 1 then -- Only load on Standard, not Classic
		 -- Required API functions do not exist in Classic
		RUF.Indicators.Objective(self, unit) -- No UnitIsQuestBoss()
		RUF.Indicators.Role(self, unit) -- No UnitGroupRolesAssigned()
	else
		RUF.Indicators.LootMaster(self, unit) -- We have master looting in Classic!
	end
end