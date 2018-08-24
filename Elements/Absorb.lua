local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

function RUF.AbsorbUpdate(self, event, unit,...)
	-- TODO: use self instead of _G and Unitlist table.
	-------- self:GetName() is the unitframe, still need to check and update "fake" units on each update though.



	if RUF.db.global.TestMode == true then	return	end
	if not unit then return end
	local i = RUF:UnitToIndex(unit)
	if not i then return end
	local cfgunit = RUF.db.global.UnitList[i].name

	if RUF.db.global.UnitList[i].group then -- If the unit is part of a group, use the group's settings.
		local cfgunit = RUF.db.global.UnitList[i].group
	end

	-- Update Absorb display state.
	if RUF.db.profile.unit[cfgunit].Frame.Bars.Absorb.Enabled == 0 then
		if _G[RUF.db.global.UnitList[i].frame].Absorb:IsShown() then
			_G[RUF.db.global.UnitList[i].frame].Absorb:Hide()
		end
		return
	else
		if not _G[RUF.db.global.UnitList[i].frame].Absorb:IsShown() then
			_G[RUF.db.global.UnitList[i].frame].Absorb:Show()
		end
	end



	-- Update Values
	if event == "UNIT_TARGET" then
		if unit == "player" then
			if _G[RUF.db.global.UnitList[3].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[3].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[3].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[3].name) or 0)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
			if _G[RUF.db.global.UnitList[4].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[4].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[4].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[4].name) or 0)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
		elseif unit == "target" then
			if _G[RUF.db.global.UnitList[4].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[4].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[4].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[4].name) or 0)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
		else
			for i = 1,#RUF.db.global.UnitList do
				if _G[RUF.db.global.UnitList[i].frame] then
					local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[i].name)
					local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[i].name) or 0)
					local max = (UnitHealthMax(RUF.db.global.UnitList[i].name) or 0)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetMinMaxValues(0, max)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetValue(AbsorbAmount)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetStatusBarColor(r,g,b,a)					
				end
			end			
		end
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		if unit == "player" then
			if _G[RUF.db.global.UnitList[1].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[1].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[1].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[1].name) or 0)
				_G[RUF.db.global.UnitList[1].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[1].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[1].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
		elseif unit == "target" then
			if _G[RUF.db.global.UnitList[3].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[3].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[3].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[3].name) or 0)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[3].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
			if _G[RUF.db.global.UnitList[4].frame] then
				local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[4].name)
				local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[4].name) or 0)
				local max = (UnitHealthMax(RUF.db.global.UnitList[4].name) or 0)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetMinMaxValues(0, max)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetValue(AbsorbAmount)
				_G[RUF.db.global.UnitList[4].frame].Absorb:SetStatusBarColor(r,g,b,a)	
			end
		else
			for i = 1,#RUF.db.global.UnitList do
				if _G[RUF.db.global.UnitList[i].frame] then
					local r,g,b,a = RUF:GetAbsorbColor(RUF.db.global.UnitList[i].name)
					local AbsorbAmount = (UnitGetTotalAbsorbs(RUF.db.global.UnitList[i].name) or 0)
					local max = (UnitHealthMax(RUF.db.global.UnitList[i].name) or 0)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetMinMaxValues(0, max)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetValue(AbsorbAmount)
					_G[RUF.db.global.UnitList[i].frame].Absorb:SetStatusBarColor(r,g,b,a)					
				end
			end			
		end	
	end
end

function RUF.SetAbsorbBar(self, unit)
	local Texture = LSM:Fetch("statusbar", RUF.db.profile.Appearance.Bars.Absorb.Texture)	
	local Name = self:GetName()
	local Bar = CreateFrame("StatusBar",Name..".Absorb.Bar",self)
	local Border = CreateFrame("Frame",Name..".Absorb.Border",self)
	local Background = Border:CreateTexture(Name..".Absorb.Background","BACKGROUND")	
	 
	-- Bar
	Bar.colorClass = RUF.db.profile.Appearance.Bars.Absorb.Color.Class
	Bar.colorDisconnected = RUF.db.profile.Appearance.Bars.Absorb.Color.Disconnected
	Bar.colorSmooth = RUF.db.profile.Appearance.Bars.Absorb.Color.Percentage
	Bar.smoothGradient = RUF.db.profile.Appearance.Bars.Absorb.Color.PercentageGradient
	Bar.colorReaction = RUF.db.profile.Appearance.Bars.Absorb.Color.Reaction
	Bar.colorTapping = RUF.db.profile.Appearance.Bars.Absorb.Color.Tapped
	Bar.colorAbsorb = true -- BaseColor, always enabled, so if none of the other colors match, it falls back to this.
	Bar.Smooth = RUF.db.profile.Appearance.Bars.Absorb.Animate
	Bar:SetStatusBarTexture(Texture)
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 1 then
		Bar:SetAllPoints(self)
		Border:Hide() -- Hides background too.
	end
	Bar:SetFrameLevel(3)
	Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Absorb.Fill)
	
	local AbsorbAmount = (UnitGetTotalAbsorbs(unit))
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Absorb.Color.BaseColor)
	local a = RUF.db.profile.Appearance.Bars.Absorb.Color.Alpha
	local min = 0
	local max = UnitHealthMax(unit)
	Bar:SetMinMaxValues(min, max)
	Bar:SetValue(AbsorbAmount)
	Bar:SetStatusBarColor(r,g,b,a)
	
	-- Border
	Border:SetAllPoints(Bar)
	Border:SetFrameLevel(7)
	Border:SetBackdrop(RUF.db.profile.Appearance.Border.Style)
	Border:SetBackdropBorderColor(0,0,0,1)
	
	-- Background
	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Absorb.Background.CustomColor)
	local Multiplier = RUF.db.profile.Appearance.Bars.Absorb.Background.Multiplier
	Background:SetTexture(LSM:Fetch("background", "Solid"))	
	Background:SetVertexColor(r*Multiplier,g*Multiplier,b*Multiplier,RUF.db.profile.Appearance.Bars.Absorb.Background.Alpha)
	Background:SetAllPoints(Bar)
	Background.colorSmooth = false

	-- Register with oUF	
	self.Absorb = Bar
	self.Absorb.border = Border
	self.Absorb.background = Background
	self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED',RUF.AbsorbUpdate)
	self:RegisterEvent('UNIT_TARGET',RUF.AbsorbUpdate)
	if RUF.db.profile.Appearance.Bars.Absorb.Type == 0 then
		self.Absorb:Hide()
		self.Absorb.border:Hide()
		self.Absorb.background:Hide()
	end
end
