local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF
local elementName = 'TargetMark'

local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

local function Update(self, event)
	local element = self.TargetMarkIndicator
	element.Enabled = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName].Enabled

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	if element.Enabled == true then
		local index = GetRaidTargetIndex(self.unit)
		if(index) then
			element:Show()
			if index == 1 then -- Star
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,234/255,0/255)
			elseif index == 2 then -- Circle
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,156/255,0/255)
			elseif index == 3 then -- Diamond
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(240/255,0/255,255/255)
			elseif index == 4 then -- Triangle
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(46/255,206/255,0/255)
			elseif index == 5 then -- Moon
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(163/255,217/255,255/255)
			elseif index == 6 then -- Square
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(61/255,180/255,255/255)
			elseif index == 7 then -- Cross
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,52/255,52/255)
			elseif index == 8 then -- Skull
				element:SetText("")
				element:SetWidth(element:GetStringWidth()+2)
				element:SetTextColor(1,253/255,229/255)
			else
				element:SetText(" ")
				element:SetWidth(1)
				element:Hide()
			end
		else
			element:SetText(" ")
			element:SetWidth(1)
			element:Hide()
		end

		if RUF.db.global.TestMode == true then
			element:SetText("") -- Star
			element:SetTextColor(1,234/255,0/255)
			element:SetWidth(element:GetStringWidth()+2)
			element:Show()
		end
	else
		self:DisableElement('TargetMarkIndicator')
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(index)
	end
end

local function Path(self, ...)
	return (self.TargetMarkIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	if(not element.__owner.unit) then return end
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.TargetMarkIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		self:RegisterEvent('RAID_TARGET_UPDATE', Path, true)

		local profileReference = RUF.db.profile.unit[self.frame].Frame.Indicators[elementName]
		element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], profileReference.Size, 'OUTLINE')
		element:SetText(' ')
		element:SetJustifyH('CENTER')
		element:ClearAllPoints()
		element:SetPoint(
			profileReference.Position.AnchorFrom,
			RUF.GetIndicatorAnchorFrame(self,self.frame,elementName),
			profileReference.Position.AnchorTo,
			profileReference.Position.x,
			profileReference.Position.y
		)

		element:Show()
		return true
	end
end

local function Disable(self)
	local element = self.TargetMarkIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('RAID_TARGET_UPDATE', Path)
	end
end

oUF:AddElement('TargetMarkIndicator', Path, Enable, Disable)


function RUF.Indicators.TargetMark(self, unit)
	local element = self.Indicators:CreateFontString(self:GetName()..".TargetMarkIndicator", "OVERLAY")
	element:SetPoint(
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorFrom,
		RUF.GetIndicatorAnchorFrame(self,unit,elementName),
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.AnchorTo,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.x,
		RUF.db.profile.unit[unit].Frame.Indicators[elementName].Position.y
	)

	element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[elementName].Size, "OUTLINE")

	self.TargetMarkIndicator = element
end