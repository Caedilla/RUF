local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

--[[
	Easiest 'best' version:

	Icons need to register which point they are on, then when visibility is changed of an icon in that area we move the others appropriately.

	Icons and Text don't anchor to each other.
	Text anchor to main 9 points, top, left, right, bottomright etc.

	-- Find all tags registered for a given text by profile data. Register relevant events and update size from that.
	local pattern = '%[..-%]+'

	local mstring = '[RUF:ManaPerc][RUF:ManaPesrc]'

	for a in mstring:gmatch(pattern) do
	print(a)
	end


	Make text 'dumb' - just like ElvUI, it has it's position, and that's that. Allow anchoring to other text elements though.
	When everything else is working, come back and add resizing as per above.

]]--

local anchorSwaps = {
	['BOTTOM'] = 'TOP',
	['BOTTOMLEFT'] = 'TOPRIGHT',
	['BOTTOMRIGHT'] = 'TOPLEFT',
	['CENTER'] = 'CENTER',
	['LEFT'] = 'RIGHT',
	['RIGHT'] = 'LEFT',
	['TOP'] = 'BOTTOM',
	['TOPLEFT'] = 'BOTTOMRIGHT',
	['TOPRIGHT'] = 'BOTTOMLEFT',
}

function RUF.SetTextParent(self,unit)
	local name = self:GetName()
	local TextParent = CreateFrame('Frame', name .. '.Text', self)
	TextParent:SetFrameLevel(20)
	TextParent:SetAllPoints(self)

	local testModeDisplayName = CreateFrame('Frame', name .. '.Text.DisplayName',TextParent)
	testModeDisplayName:SetFrameLevel(100)
	testModeDisplayName:SetAllPoints(self)

	local text = testModeDisplayName:CreateFontString(name .. '.Text.DisplayName.String', 'OVERLAY', 'Raeli')
	local font = LSM:Fetch('font', 'RUF')
	text:SetFont(font,21,'OUTLINE')
	text:SetText(L[self.unit])
	text:SetAllPoints(testModeDisplayName)
	testModeDisplayName:Hide()

	self.Text = TextParent
	self.Text.DisplayName = testModeDisplayName
end

function RUF.SetTextPoints(self,unit,textName)
	local name = self:GetName()
	local anchorFrame = 'Frame'
	local element = self.Text[textName].String
	if RUF.db.profile.unit[unit].Frame.Text[textName].Position.AnchorFrame == 'Frame' then
		anchorFrame = name
	else
		anchorFrame = (name ..'.Text.'.. RUF.db.profile.unit[unit].Frame.Text[textName].Position.AnchorFrame .. '.String')
		if not _G[anchorFrame] then
			anchorFrame = name
		end
	end
	local reverseAnchor = RUF.db.profile.unit[unit].Frame.Text[textName].Position.Anchor
	if RUF.db.profile.unit[unit].Frame.Text[textName].Position.AnchorFrame ~= 'Frame' then
		reverseAnchor = anchorSwaps[reverseAnchor]
	end

	element:SetPoint(
		reverseAnchor,
		anchorFrame,
		RUF.db.profile.unit[unit].Frame.Text[textName].Position.Anchor,
		RUF.db.profile.unit[unit].Frame.Text[textName].Position.x,
		RUF.db.profile.unit[unit].Frame.Text[textName].Position.y
	)

	self.Text[textName]:SetAllPoints(element)
end

function RUF.CreateTextArea(self, unit, textName)

	local name = self:GetName()

	-- Purely so we can control frame level
	local stringParent = CreateFrame('Frame', name .. '.Text.' .. textName, self.Text)
	stringParent:SetFrameLevel(20)
	self.Text[textName] = stringParent


	local Font = ''
	Font = LSM:Fetch('font', RUF.db.profile.unit[unit].Frame.Text[textName].Font)

	local Text = self.Text[textName]:CreateFontString(name .. '.Text.' .. textName .. '.String' , 'OVERLAY')
	Text:SetFont(Font, RUF.db.profile.unit[unit].Frame.Text[textName].Size, RUF.db.profile.unit[unit].Frame.Text[textName].Outline)

	if not RUF.db.profile.unit[unit].Frame.Text[textName].Shadow then RUF.db.profile.unit[unit].Frame.Text[textName].Shadow = 0 end
	Text:SetShadowColor(0,0,0,RUF.db.profile.unit[unit].Frame.Text[textName].Shadow)
	Text:SetShadowOffset(1, -1)
	Text:SetTextColor(1, 1, 1, 1)
	Text.overrideUnit = true
	Text.frequentUpdates = 0.5
	local anchorPoint = RUF.db.profile.unit[unit].Frame.Text[textName].Position.Anchor
	if anchorPoint == 'RIGHT' or anchorPoint == 'TOPRIGHT' or anchorPoint == 'BOTTOMRIGHT' then
		Text:SetJustifyH('RIGHT')
	elseif anchorPoint == 'LEFT' or anchorPoint == 'TOPLEFT' or anchorPoint == 'BOTTOMLEFT' then
		Text:SetJustifyH('LEFT')
	else
		Text:SetJustifyH('CENTER')
	end
	Text:SetWordWrap(false)
	Text:SetHeight(Text:GetLineHeight()) -- Prevents FontString from collapsing to a 1x1 box when the string is empty, which our tags do to 'hide'

	self.Text[textName].String = Text
	self:Tag(Text, RUF.db.profile.unit[unit].Frame.Text[textName].Tag)
end