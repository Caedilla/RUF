local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF


function RUF.AdditionalPowerUpdate(self, event, unit, ...)
	-- TODO:
	-- None, fine for now.
	if self.frame == "player" then
		if UnitHasVehicleUI('player') then
			if self.AdditionalPower:IsVisible() == true then
				RUF:BarVisibility(self.AdditionalPower, "AdditionalPower", false)
				return
			else
				return
			end
		end
	end

	if self.frame ~= "player" then return end
	if not RUF.db.profile.unit[unit] then return end
	local element = self.AdditionalPower
	if(element.PreUpdate) then element:PreUpdate(unit) end
	local cur = UnitPower('player', 0)
	local max = UnitPowerMax('player', 0)
	element:SetMinMaxValues(0, max)
	element:SetValue(cur)
	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max)
	end
end

function RUF.OverrideVisibility(self, event, unit)

	self:RegisterEvent('UNIT_POWER_FREQUENT', RUF.AdditionalPowerUpdate)
	self:RegisterEvent('UNIT_MAXPOWER', RUF.AdditionalPowerUpdate)
	self:RegisterEvent('UNIT_ENTERED_VEHICLE', RUF.AdditionalPowerUpdate)
	self:RegisterEvent('UNIT_EXITED_VEHICLE', RUF.AdditionalPowerUpdate)
	self:RegisterEvent('UNIT_EXITING_VEHICLE', RUF.AdditionalPowerUpdate)
end

function RUF.PowerPostUpdate(element, unit, cur, min, max) -- Update ShadowPriest Mana too
	-- TODO:
	-- Check visibility stuff, do we need to check that here? Should only be required for druids/shamans on form change, maybe there's a better way to track for them.

	-- On moving bars, again, should only be required here for druid/shaman on form change. Others should only need on spec change, including shadow priest.
	-- Figure out a better way to deal with this.
	

	if not unit then return end
	if not RUF.db.profile.unit[element.__owner.frame] then return end
	local realUnit = unit
	local unit = element.__owner.frame
	pType = (select(2,UnitPowerType("player")))
	if RUF:GetSpec() == 1 and element.__owner:GetName() == "oUF_RUF_Player" then -- Correct Class and Player
		if RUF.db.profile.unit.player.Frame.Bars.Class.Enabled and not UnitHasVehicleUI('player') then
			RUF:UpdateElementColor(element,"Power","Power")
			RUF:UpdateElementColor(element,"Class","AdditionalPower")
			local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
			local r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[0])
			element.__owner.AdditionalPower:SetStatusBarColor(r,g,b)
			element.__owner.AdditionalPower.bg:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)			
			if pType ~= "MANA" then
				if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled then
					RUF:BarVisibility(element, "Power", true)
				else
					RUF:BarVisibility(element, "Power", false)
				end

				if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled > 0 then
					RUF:BarVisibility(element, "AdditionalPower", true)
				else
					RUF:BarVisibility(element, "AdditionalPower", false)
				end
			else
				RUF:BarVisibility(element, "Power", false)
				if RUF.db.profile.unit[unit].Frame.Bars.Power.Enabled > 0 then
					RUF:BarVisibility(element, "AdditionalPower", true)
				else
					RUF:BarVisibility(element, "AdditionalPower", false)
				end
			end
			element.__owner.AdditionalPower:ClearAllPoints()
			element.__owner.AdditionalPower:SetPoint('LEFT',0,0)
			element.__owner.AdditionalPower:SetPoint('RIGHT',0,0)
			element.__owner.Power:ClearAllPoints()
			element.__owner.Power:SetPoint('LEFT',0,0)
			element.__owner.Power:SetPoint('RIGHT',0,0)

			if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor ~= RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor then
				element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)-- Move AdditionalPower (Mana)
				element.__owner.AdditionalPower:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Power.Height)					
				element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor,0,0)-- Move Power (Insanity, Maelstrom)
				element.__owner.Power:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Class.Height)
			elseif RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor then
				if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Order == 0 then
					element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)-- Move AdditionalPower
					element.__owner.AdditionalPower:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Power.Height)
					element.__owner.Power:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Class.Height)
					if element.__owner.AdditionalPower:IsShown() then-- Move Power Offset to AdditionalPower
						if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "TOP" then-- Move down by height of the Mana bar.
							element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor,0,- RUF.db.profile.unit.player.Frame.Bars.Power.Height +1)
						else-- Move up by height of Mana bar.
							element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor,0,RUF.db.profile.unit.player.Frame.Bars.Power.Height -1)
						end
					else
						element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor,0,0)
					end
				else
					element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor,0,0)-- Move Power (Insanity, Maelstrom)
					element.__owner.Power:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Class.Height)
					element.__owner.AdditionalPower:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Power.Height)-- Move AdditionalPower Offset to Power
					
					if element.__owner.Power:IsShown() then-- Move AdditionalPower Offset to Power
						if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "TOP" then
							element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,-RUF.db.profile.unit.player.Frame.Bars.Class.Height +1)
						else
							element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,RUF.db.profile.unit.player.Frame.Bars.Class.Height -1)
						end
					else
						element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)
					end
				end
			end
		elseif UnitHasVehicleUI('player') then
			RUF:BarVisibility(element, "AdditionalPower", false)
			element.__owner.Power:ClearAllPoints()
			element.__owner.Power:SetPoint('LEFT',0,0)
			element.__owner.Power:SetPoint('RIGHT',0,0)
			element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)
			element.__owner.Power:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Power.Height)
		else
			if element.__owner.AdditionalPower:IsShown() then
				if RUF.db.profile.unit.player.Frame.Bars.Power.Enabled == 0 then 
					RUF:BarVisibility(element, "AdditionalPower", false)
				end
				RUF:UpdateElementColor(element,"Class","AdditionalPower")
				local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
				local r,g,b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[0])
				element.__owner.AdditionalPower:SetStatusBarColor(r,g,b)
				element.__owner.AdditionalPower.bg:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
				element.__owner.AdditionalPower:ClearAllPoints()
				element.__owner.AdditionalPower:SetPoint('LEFT',0,0)
				element.__owner.AdditionalPower:SetPoint('RIGHT',0,0)
				element.__owner.AdditionalPower:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)
			end
			RUF:BarVisibility(element, "Power", false)
		end
	elseif RUF:GetSpec() == 2 and element.__owner:GetName() == "oUF_RUF_Player" then
		RUF:BarVisibility(element, "AdditionalPower", false)
		local a,_,_,x,y = element.__owner.Power:GetPoint(3)
		if a ~= RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor then
			element.__owner.Power:ClearAllPoints()
			element.__owner.Power:SetPoint('LEFT',0,0)
			element.__owner.Power:SetPoint('RIGHT',0,0)
			element.__owner.Power:SetPoint(RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor,0,0)
			element.__owner.Power:SetHeight(RUF.db.profile.unit.player.Frame.Bars.Power.Height)
		end
		RUF:PowerShouldDisplay(element, unit, cur)
	elseif RUF:GetSpec() == 3 and element.__owner:GetName() == "oUF_RUF_Player" then -- Has Class Power but not one of the previous classes.
		RUF:PowerShouldDisplay(element, unit, cur)
		RUF:MoveBars(element, unit)
	else
		RUF:PowerShouldDisplay(element, unit, cur)
		RUF:MoveBars(element, unit)
	end

	--[[if PlayerClass == "PRIEST" or PlayerClass == "SHAMAN" or PlayerClass == "DRUID" then		
		if pType == "MANA" and element.__owner:GetName() == "oUF_RUF_Player" then 
			element.__owner.TextParent.Power.Text:UpdateTag()
			element.__owner.TextParent.Class:Hide()
		elseif RUF.db.profile.unit[unit].Frame.Text.Class.Enabled == 2 and element.__owner:GetName() == "oUF_RUF_Player"  then
			element.__owner.TextParent.Power.Text:UpdateTag()
			element.__owner.TextParent.Class:Show()
		elseif RUF.db.profile.unit[unit].Frame.Text.Class.Enabled == 1 and element.__owner:GetName() == "oUF_RUF_Player"  then
			if UnitPower(unit,0) > 0 then
				element.__owner.TextParent.Power.Text:UpdateTag()
				element.__owner.TextParent.Class:Show()
			else
				element.__owner.TextParent.Power.Text:UpdateTag()
				element.__owner.TextParent.Class:Hide()
			end
		elseif RUF.db.profile.unit[unit].Frame.Text.Class.Enabled == 0 and element.__owner:GetName() == "oUF_RUF_Player" then
			element.__owner.TextParent.Power.Text:UpdateTag()
			element.__owner.TextParent.Class:Hide()
		end
	end]]--

	local r,g,b = RUF:GetPowerColor(element, realUnit)
	element.__owner.Power:SetStatusBarColor(r,g,b)
	local Multiplier = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	if RUF.db.profile.Appearance.Bars.Power.Background.UseBarColor == false then
		r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	end
	element.__owner.Power.bg:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Power.Background.Alpha)

	local FrameIndex = RUF:UnitToIndex(unit)
	RUF:UpdateHealthBackground(FrameIndex)
end	

function RUF.SetPower(self, unit) -- Mana, Rage, Insanity, Maelstrom etc.
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Power.Texture)	
	local Name = self:GetName()
	local Bar = CreateFrame("StatusBar",Name..".Power.Bar",self)
	local Border = CreateFrame("Frame",Name..".Power.Border",Bar) --/run print(oUF_RUF_Player.Power:GetParent():GetName())
	local Background = Bar:CreateTexture(Name..".Power.Background","BACKGROUND")
	
	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Power.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Power.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Power.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Power.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Power.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Power.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Power.Color.PowerType
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Power.Animate
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Power.Fill)
	
	-- Bar Position
	local function SetTopBot()
		if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "TOP" then
			Bar:SetPoint('TOP',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
		elseif RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "BOTTOM" then
			Bar:SetPoint('BOTTOM',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height) 		
		end
	end
	if unit == "player" and RUF.db.char.ClassPowerID then
		if RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor then
			if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Order == 0 then
				SetTopBot()
			elseif RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "TOP" then
				Bar:SetPoint('TOP',0,-RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
				Bar:SetPoint('LEFT',0,0)
				Bar:SetPoint('RIGHT',0,0)
				Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
			elseif RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor == "BOTTOM" then
				Bar:SetPoint('BOTTOM',0,RUF.db.profile.unit[unit].Frame.Bars.Power.Height)
				Bar:SetPoint('LEFT',0,0)
				Bar:SetPoint('RIGHT',0,0)
				Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Power.Height) 		
			end
		else
			SetTopBot()
		end
	else
		SetTopBot()
	end
	
	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)
	
	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Power.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Power.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Power.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.Power = Bar
	self.Power.border = Border
	self.Power.bg = Background	
end

function RUF.SetAdditionalPower(self, unit) -- Mana for Shadow Priests
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)	
	local Name = self:GetName()
	local Bar = CreateFrame("StatusBar",Name..".AdditionalPower.Bar",self)
	local Border = CreateFrame("Frame",Name..".AdditionalPower.Border",Bar) --/run print(oUF_RUF_Player.Class:GetParent():GetName())
	local Background = Bar:CreateTexture(Name..".AdditionalPower.Background","BACKGROUND")	
	
	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Class.Animate
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
	
	-- Bar Position
	local function SetTopBot()
		if RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor== "TOP" then
			Bar:SetPoint('TOP',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		elseif RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == "BOTTOM" then
			Bar:SetPoint('BOTTOM',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height) 		
		end
	end	
	if unit == "player" and RUF.db.profile.unit.player.Frame.Bars.Power.Position.Enabled then -- Unnecessary because we only generate this on Player.
		if RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == RUF.db.profile.unit.player.Frame.Bars.Power.Position.Anchor then
			if RUF.db.profile.unit.player.Frame.Bars.Power.Position.Order == 1 then
				SetTopBot()
			else
		if RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == "TOP" then
			Bar:SetPoint('TOP',0,-RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		elseif RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == "BOTTOM" then
			Bar:SetPoint('BOTTOM',0,RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height) 		
		end
			end
		else
			SetTopBot()
		end
	else
		SetTopBot()
	end
	
	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Power.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Power.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Power.Border.Alpha)


	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.AdditionalPower = Bar
	self.AdditionalPower.border = Border
	self.AdditionalPower.bg = Background

	local _, unitClass = UnitClass(unit)
	if UnitPowerMax(unit, ADDITIONAL_POWER_BAR_INDEX) ~= 0 then
		if(ALT_MANA_BAR_PAIR_DISPLAY_INFO[unitClass]) then
			local powerType = UnitPowerType(unit)
			ShouldEnable = ALT_MANA_BAR_PAIR_DISPLAY_INFO[unitClass][powerType]
		end
	end
	if not ShouldEnable then
		self.AdditionalPower:Hide()
		self.AdditionalPower.border:Hide()
		self.AdditionalPower.bg:Hide()
	end
end

function RUF.StaggerPostUpdate(element, cur, max)
	local stagger_low = RUF.db.profile.Appearance.Colors.PowerColors[75]
	local stagger_medium = RUF.db.profile.Appearance.Colors.PowerColors[76]
	local stagger_high = RUF.db.profile.Appearance.Colors.PowerColors[77]
	local r,g,b = RUF:GetClassColor("player")
	local br,bg,bb

	local perc = cur / max
	if perc >= 0.6 then
		r,g,b = unpack(stagger_high)
	elseif perc > 0.3 then
		r,g,b = unpack(stagger_medium)
	else
		r,g,b = unpack(stagger_low)
	end
	element:SetStatusBarColor(r, g, b)

	if RUF.db.profile.Appearance.Bars.Class.Background.UseBarColor == false then 
		br,bg,bb = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	else
		br,bg,bb = r,g,b
	end	
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	element.bg:SetVertexColor(br*Multiplier,bg*Multiplier,bb*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)
	element:SetStatusBarTexture(Texture)
end

function RUF.SetStagger(self, unit) -- Stagger Bar, BRM
	
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Class.Texture)	
	local Name = self:GetName()
	local Bar = CreateFrame("StatusBar",Name..".Stagger.Bar",self)
	local Border = CreateFrame("Frame",nil,Bar) --/run print(oUF_RUF_Player.Power:GetParent():GetName())
	local Background = Bar:CreateTexture(nil,"BACKGROUND")	
	
	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Class.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Class.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Class.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Class.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Class.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Class.Color.Tapped
	Bar.colorPower = RUF.db.profile.Appearance.Bars.Class.Color.PowerType
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Class.Animate
	Bar:SetStatusBarTexture(Texture)
	Bar:SetFrameLevel(5)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
	
	-- Bar Position
	local function SetTopBot()
		if RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == "TOP" then
			Bar:SetPoint('TOP',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		elseif RUF.db.profile.unit.player.Frame.Bars.Class.Position.Anchor == "BOTTOM" then
			Bar:SetPoint('BOTTOM',0,0)
			Bar:SetPoint('LEFT',0,0)
			Bar:SetPoint('RIGHT',0,0)
			Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height) 		
		end
	end
	SetTopBot()
	
	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop({edgeFile = LSM:Fetch("border", RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
	local borderr,borderg,borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
	Border:SetBackdropBorderColor(borderr,borderg,borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)
	
	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Class.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF
	self.Stagger = Bar
	self.Stagger.border = Border
	self.Stagger.bg = Background
end
