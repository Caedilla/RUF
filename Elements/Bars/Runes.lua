local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF

local _, uClass = UnitClass('player')

local classPowerData = {
	DEATHKNIGHT = {
		classPowerID = 5,
		unitPowerMaxAmount = 6,
	},
}

function RUF.SetRunes(self, unit)
	if uClass ~= 'DEATHKNIGHT' then return end
	local classPowerBar = {}
	local classPowerBorder = {}
	local classPowerBackground = {}
	local unitPowerMaxAmount = classPowerData[uClass].unitPowerMaxAmount or UnitPowerMax(unit, classPowerData[uClass].classPowerID)
	local name = self:GetName() .. '.Runes'
	self.Runes = {}

	local Holder = CreateFrame('Frame', name .. '.Holder', self)
	Holder.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == 'TOP' then
		Holder:SetPoint('TOP', 0, 0)
		Holder:SetPoint('LEFT', 0, 0)
		Holder:SetPoint('RIGHT', 0, 0)
		Holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Holder.anchorTo = 'TOP'
	elseif RUF.db.profile.unit[unit].Frame.Bars.Class.Position.Anchor == 'BOTTOM' then
		Holder:SetPoint('BOTTOM', 0, 0)
		Holder:SetPoint('LEFT', 0, 0)
		Holder:SetPoint('RIGHT', 0, 0)
		Holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Holder.anchorTo = 'BOTTOM'
	end

	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local spec = GetSpecialization() or 0
	if spec == 1 then -- Blood
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[50])
	elseif spec == 2 then -- Frost
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[51])
	elseif spec == 3 then -- Unholy
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[52])
	else -- no value returned yet?
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	end
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier

	for i = 1, unitPowerMaxAmount do
		local Bar = CreateFrame('StatusBar', name .. i, Holder)
		local Border = CreateFrame('Frame', name .. i .. '.Border', Bar, BackdropTemplateMixin and 'BackdropTemplate')
		local Background = Bar:CreateTexture(name .. i .. '.Background', 'BACKGROUND')
		local size = (RUF.db.profile.unit[unit].Frame.Size.Width + (unitPowerMaxAmount-1))/unitPowerMaxAmount
		local counter = i
		if unitPowerMaxAmount == 4 then
			counter = i +1
		end

		-- Set Bar Parent Size
		Bar:SetWidth(size)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		if i == 1 then
			Bar:SetPoint('TOPLEFT', Holder, 'TOPLEFT', 0, 0)
		else
			Bar:SetPoint('TOPLEFT', classPowerBar[i-1], 'TOPRIGHT', -1, 0)
		end
		-- Bar:SetPoint('TOPLEFT', self, 'TOPLEFT', ((i - 1)*size - ((i - 1 )*1)), 0)
		Bar:SetFrameLevel(15)

		-- Set Status Bar
		Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
		Bar:SetFrameLevel(16)
		Bar:SetStatusBarTexture(texture)
		local ir = (r*((((counter+colorAdd)*6.6667)/100)))
		local ig = (g*((((counter+colorAdd)*6.6667)/100)))
		local ib = (b*((((counter+colorAdd)*6.6667)/100)))
		Bar:SetStatusBarColor(ir, ig, ib)

		-- Set Border
		local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
		Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
		Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
		Border:SetFrameLevel(17)
		Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(LSM:Fetch('background', 'Solid'))
		Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

		classPowerBar[i] = Bar
		classPowerBorder[i] = Border
		classPowerBackground[i] = Background
		self.Runes[i] = Bar
		self.Runes[i].Border = Border
		self.Runes[i].Background = Background
		self.Runes[i].__owner = self
	end

	self.Runes.UpdateColor = RUF.RunesUpdateColor
	self.Runes.Override = RUF.RunesUpdate
	self.Runes.Holder = Holder
	self.Runes.Holder.__owner = self
	self.Runes.UpdateOptions = RUF.RunesUpdateOptions
end

local runemap = {1, 2, 3, 4, 5, 6}
local hasSortOrder = false

local function onUpdate(self, elapsed)
	local duration = self.duration + elapsed
	self.duration = duration
	self:SetValue(duration)
end

local function ascSort(runeAID, runeBID)
	local runeAStart, _, runeARuneReady = GetRuneCooldown(runeAID)
	local runeBStart, _, runeBRuneReady = GetRuneCooldown(runeBID)
	if(runeARuneReady ~= runeBRuneReady) then
		return runeARuneReady
	elseif(runeAStart ~= runeBStart) then
		return runeAStart < runeBStart
	else
		return runeAID < runeBID
	end
end

local function descSort(runeAID, runeBID)
	local runeAStart, _, runeARuneReady = GetRuneCooldown(runeAID)
	local runeBStart, _, runeBRuneReady = GetRuneCooldown(runeBID)
	if(runeARuneReady ~= runeBRuneReady) then
		return runeBRuneReady
	elseif(runeAStart ~= runeBStart) then
		return runeAStart > runeBStart
	else
		return runeAID > runeBID
	end
end

function RUF.RunesUpdate(self, event)
	local element = self.Runes
	if RUF.db.profile.unit[self.frame].Frame.Bars.Class.Enabled ~= true then
		self:DisableElement('Runes')
		return
	end

	if(element.sortOrder == 'asc') then
		table.sort(runemap, ascSort)
		hasSortOrder = true
	elseif(element.sortOrder == 'desc') then
		table.sort(runemap, descSort)
		hasSortOrder = true
	elseif(hasSortOrder) then
		table.sort(runemap)
		hasSortOrder = false
	end

	local rune, start, duration, runeReady
	for index, runeID in next, runemap do
		rune = element[index]
		if(not rune) then break end

		if(UnitHasVehicleUI('player')) then
			rune:Hide()
		else
			start, duration, runeReady = GetRuneCooldown(runeID)
			if(runeReady) then
				rune:SetMinMaxValues(0, 1)
				rune:SetValue(1)
				rune:SetScript('OnUpdate', nil)
			elseif(start) then
				rune.duration = GetTime() - start
				rune:SetMinMaxValues(0, duration)
				rune:SetValue(0)
				rune:SetScript('OnUpdate', onUpdate)
			end

			rune:Show()
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(runemap)
	end
end

function RUF.RunesUpdateColor(element, rune)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local spec = GetSpecialization() or 0
	if spec == 1 then -- Blood
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[50])
	elseif spec == 2 then -- Frost
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[51])
	elseif spec == 3 then -- Unholy
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[52])
	else -- no value returned yet?
		r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	end
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier

	if rune and type(rune) ~= 'number' then
		local realElement = element.Runes
		for i = 1,#realElement do
			local ir = (r*((((i+colorAdd)*6.6667)/100)))
			local ig = (g*((((i+colorAdd)*6.6667)/100)))
			local ib = (b*((((i+colorAdd)*6.6667)/100)))
			realElement[i]:SetStatusBarColor(ir, ig, ib)
			realElement[i].Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
		end
	else
		local ir = (r*((((rune+colorAdd)*6.6667)/100)))
		local ig = (g*((((rune+colorAdd)*6.6667)/100)))
		local ib = (b*((((rune+colorAdd)*6.6667)/100)))
		element[rune]:SetStatusBarColor(ir, ig, ib)
		element[rune].Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)
	end
end

function RUF.RunesUpdateOptions(self)
	if uClass ~= 'DEATHKNIGHT' then return end
	local unit = self.__owner.frame
	local unitPowerMaxAmount = classPowerData[uClass].unitPowerMaxAmount or UnitPowerMax(unit, classPowerData[uClass].classPowerID)
	local texture = LSM:Fetch('statusbar', RUF.db.profile.Appearance.Bars.Class.Texture)
	local r, g, b = unpack(RUF.db.profile.Appearance.Colors.PowerColors[classPowerData[uClass].classPowerID])
	local bgMult = RUF.db.profile.Appearance.Bars.Class.Background.Multiplier
	local colorAdd = RUF.db.profile.Appearance.Bars.Class.Color.SegmentMultiplier

	local holder = self.__owner.Runes.Holder
	holder:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
	holder.barHeight = RUF.db.profile.unit[unit].Frame.Bars.Class.Height

	for i = 1, unitPowerMaxAmount do
		local Bar = self[i]
		local Background = self[i].Background
		local Border = self[i].Border
		local size = (RUF.db.profile.unit[unit].Frame.Size.Width + (unitPowerMaxAmount-1))/unitPowerMaxAmount
		local counter = i
		if unitPowerMaxAmount == 4 then
			counter = i +1
		end

		-- Set Bar Parent Size
		Bar:SetWidth(size)
		Bar:SetHeight(RUF.db.profile.unit[unit].Frame.Bars.Class.Height)
		Bar:SetFrameLevel(15)

		-- Set Status Bar
		Bar:SetFillStyle(RUF.db.profile.unit[unit].Frame.Bars.Class.Fill)
		Bar:SetFrameLevel(16)
		Bar:SetStatusBarTexture(texture)
		local ir = (r*((((counter+colorAdd)*6.6667)/100)))
		local ig = (g*((((counter+colorAdd)*6.6667)/100)))
		local ib = (b*((((counter+colorAdd)*6.6667)/100)))
		Bar:SetStatusBarColor(ir, ig, ib)

		-- Set Border
		local offset = RUF.db.profile.Appearance.Bars.Class.Border.Offset or 0
		Border:SetPoint('TOPLEFT',Bar,'TOPLEFT',-offset,offset)
		Border:SetPoint('BOTTOMRIGHT',Bar,'BOTTOMRIGHT',offset,-offset)
		Border:SetFrameLevel(17)
		Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Bars.Class.Border.Style.edgeSize})
		local borderr, borderg, borderb = unpack(RUF.db.profile.Appearance.Bars.Class.Border.Color)
		Border:SetBackdropBorderColor(borderr, borderg, borderb, RUF.db.profile.Appearance.Bars.Class.Border.Alpha)

		-- Set Background
		Background:SetAllPoints(Bar)
		Background:SetTexture(LSM:Fetch('background', 'Solid'))
		Background:SetVertexColor(r*bgMult, g*bgMult, b*bgMult, RUF.db.profile.Appearance.Bars.Class.Background.Alpha)

		self:UpdateColor(i)
	end
	if RUF.db.profile.unit[unit].Frame.Bars.Class.Enabled == true then
		self.__owner:EnableElement('Runes')
	end
	self:ForceUpdate()
end