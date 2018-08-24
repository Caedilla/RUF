local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

local AnchorSwaps = {
	["BOTTOM"] = "TOP",
	["BOTTOMLEFT"] = "TOPRIGHT",
	["BOTTOMRIGHT"] = "TOPLEFT",
	["CENTER"] = "CENTER",
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["TOP"] = "BOTTOM",
	["TOPLEFT"] = "BOTTOMRIGHT",
	["TOPRIGHT"] = "BOTTOMLEFT",
}

function RUF.SetTextParent(self, unit)
	local TextParent = CreateFrame('Frame', self:GetName() .. ".TextParent", self)
	TextParent:SetFrameLevel(20)
	TextParent:SetAllPoints(self)
	local FrameName = CreateFrame('Frame',self:GetName()..".TextParent.FrameName",TextParent)
	FrameName:SetFrameLevel(100)
	FrameName:SetAllPoints(self)
	local Text = FrameName:CreateFontString(self:GetName() .. ".TextParent.FrameName.Text", 'OVERLAY', "Raeli")
	local Font = LSM:Fetch("font", "RUF")
	Text:SetFont(Font, 21, "OUTLINE")
	Text:SetText(L[unit])
	for i = 1,#RUF.db.global.UnitList do
		if RUF.db.global.UnitList[i].group == unit then
			if self:GetName() == RUF.db.global.UnitList[i].frame then
				Text:SetText(L[RUF.db.global.UnitList[i].name])
			end
		end
	end	
	Text:SetAllPoints(TextParent)
	FrameName:Hide()
	self.TextParent = TextParent
end

function RUF.SetTextPoints(self,unit,TextName)
	local AnchorFrame = "Frame"
	if RUF.db.profile.unit[unit].Frame.Text[TextName].Position.AnchorFrame == "Frame" then
		AnchorFrame = self:GetName()
	else
		AnchorFrame = (self:GetName()..".TextParent."..RUF.db.profile.unit[unit].Frame.Text[TextName].Position.AnchorFrame .. ".Text")
		if not _G[AnchorFrame] then
			AnchorFrame = self:GetName()
		end

	end
	local ReverseAnchor = RUF.db.profile.unit[unit].Frame.Text[TextName].Position.Anchor
	if RUF.db.profile.unit[unit].Frame.Text[TextName].Position.AnchorFrame ~= "Frame" then
		ReverseAnchor = AnchorSwaps[ReverseAnchor]
	end
	self.TextParent[TextName].Text:SetPoint(ReverseAnchor,
				  AnchorFrame,
				  RUF.db.profile.unit[unit].Frame.Text[TextName].Position.Anchor,
				  RUF.db.profile.unit[unit].Frame.Text[TextName].Position.x, 
				  RUF.db.profile.unit[unit].Frame.Text[TextName].Position.y)
end

function RUF.CreateTextArea(self, unit, TextName)
	local StringParent = CreateFrame('Frame', self:GetName() .. ".TextParent."..TextName, self.TextParent)
	StringParent:SetFrameLevel(20)
	self.TextParent[TextName] = StringParent
	local Font = ""
	Font = LSM:Fetch("font", RUF.db.profile.unit[unit].Frame.Text[TextName].Font)
	local Text = self.TextParent[TextName]:CreateFontString(self:GetName() .. ".TextParent."..TextName..".Text", 'OVERLAY')
	Text:SetFont(Font, RUF.db.profile.unit[unit].Frame.Text[TextName].Size, RUF.db.profile.unit[unit].Frame.Text[TextName].Outline)
	if not RUF.db.profile.unit[unit].Frame.Text[TextName].Shadow then RUF.db.profile.unit[unit].Frame.Text[TextName].Shadow = 0 end
	Text:SetShadowColor(0,0,0,RUF.db.profile.unit[unit].Frame.Text[TextName].Shadow)
	Text:SetShadowOffset(1, -1)
	Text:SetTextColor(1, 1, 1, 1)
	Text.overrideUnit = true
	Text.frequentUpdates = 0.5
	local AnchorPoint = RUF.db.profile.unit[unit].Frame.Text[TextName].Position.Anchor
	if AnchorPoint == "RIGHT" or AnchorPoint == "TOPRIGHT" or AnchorPoint == "BOTTOMRIGHT" then
		Text:SetJustifyH("RIGHT")
	elseif AnchorPoint == "LEFT" or AnchorPoint == "TOPLEFT" or AnchorPoint == "BOTTOMLEFT" then
		Text:SetJustifyH("LEFT")
	else
		Text:SetJustifyH("CENTER")
	end
	Text:SetWordWrap(false)
	--Text:SetWidth(RUF.db.profile.unit[unit].Frame.Text[TextName].Width)
	self.TextParent[TextName].Text = Text
	self:Tag(Text, RUF.db.profile.unit[unit].Frame.Text[TextName].Tag)
end
