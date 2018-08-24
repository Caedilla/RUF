local _, ns = ...
local oUF = ns.oUF
local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")

local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

local function Update(self, event)
	local element = self.TargetMarkIndicator

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local index = GetRaidTargetIndex(self.unit)
	if element:IsObjectType('Texture') then
		if(index) then
			SetRaidTargetIconTexture(element, index)
			element:Show()
		else
			element:Hide()
		end
	elseif element:IsObjectType('FontString') then
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
	end

	if RUF.db.global.TestMode == true then
		if element:IsObjectType('Texture') then
			SetRaidTargetIconTexture(element, 1)
		elseif element:IsObjectType('FontString') then
			element:SetText("") -- Star
			element:SetTextColor(1,234/255,0/255)
			element:SetWidth(element:GetStringWidth()+2)
		end
		element:Show()
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

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		end
		if element:IsObjectType('FontString') then
			element:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[self.unit].Frame.Indicators["TargetMark"].Size, "OUTLINE")
			element:SetText(" ")
			element:SetJustifyH("CENTER")
			element:SetWidth(1)
		end

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
