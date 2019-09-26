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

	local mstring = '[RUF:ManaPerc][RUF:ManaPerc]'

	for a in mstring:gmatch(pattern) do
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
	local displayText = name:gsub('oUF_RUF_',''):gsub('UnitButton','')
	text:SetText(L[string.lower(displayText)])
	text:SetAllPoints(testModeDisplayName)
	testModeDisplayName:Hide()

	self.Text = TextParent
	self.Text.DisplayName = testModeDisplayName
end

function RUF.SetTextPoints(self,unit,textName)
	local name = self:GetName()
	local profileReference = RUF.db.profile.unit[self.frame].Frame.Text[textName]
	local anchorFrame = 'Frame'
	local element = self.Text[textName].String
	if profileReference.Position.AnchorFrame == 'Frame' then
		anchorFrame = name
	else
		anchorFrame = (name ..'.Text.'.. profileReference.Position.AnchorFrame .. '.String')
		if not _G[anchorFrame] then
			anchorFrame = name
		end
	end
	if not profileReference.Position.AnchorTo then
		RUF.db.profile.unit[self.frame].Frame.Text[textName] = profileReference.Position.Anchor
	end
	element:SetPoint(
		profileReference.Position.Anchor,
		anchorFrame,
		profileReference.Position.AnchorTo,
		profileReference.Position.x,
		profileReference.Position.y
	)

	self.Text[textName]:SetAllPoints(element)
end

function RUF.CreateTextArea(self, unit, textName)
	local name = self:GetName()
	local profileReference = RUF.db.profile.unit[self.frame].Frame.Text[textName]

	-- Purely so we can control frame level
	local stringParent = CreateFrame('Frame', name .. '.Text.' .. textName, self.Text)
	stringParent:SetFrameLevel(20)
	self.Text[textName] = stringParent


	local Font = ''
	Font = LSM:Fetch('font', profileReference.Font)
	local size = profileReference.Size
	if not size or type(size) ~= 'number' then
		size = 18
		profileReference.Size = 18
	end

	local Text = self.Text[textName]:CreateFontString(name .. '.Text.' .. textName .. '.String' , 'OVERLAY')
	Text:SetFont(Font, profileReference.Size, profileReference.Outline)

	if not profileReference.Shadow then profileReference.Shadow = 0 end
	Text:SetShadowColor(0,0,0,profileReference.Shadow)
	Text:SetShadowOffset(1, -1)
	Text:SetTextColor(1, 1, 1, 1)
	Text.overrideUnit = true
	Text.frequentUpdates = 0.5
	local anchorPoint = profileReference.Position.Anchor
	if profileReference.CustomWidth then
		if not profileReference.Justify then -- Update existing texts to store this data.
			if anchorPoint == 'RIGHT' or anchorPoint == 'TOPRIGHT' or anchorPoint == 'BOTTOMRIGHT' then
				profileReference.Justify = 'RIGHT'
			elseif anchorPoint == 'LEFT' or anchorPoint == 'TOPLEFT' or anchorPoint == 'BOTTOMLEFT' then
				profileReference.Justify = 'LEFT'
			else
				profileReference.Justify = 'CENTER'
			end
		end
		local width = profileReference.Width or 300
		Text:SetWidth(width)
		Text:SetJustifyH(profileReference.Justify)
	end
	Text:SetWordWrap(false)
	Text:SetHeight(Text:GetLineHeight()) -- Prevents FontString from collapsing to a 1x1 box when the string is empty, which our tags do to 'hide'

	self.Text[textName].String = Text
	self:Tag(Text, profileReference.Tag)
end