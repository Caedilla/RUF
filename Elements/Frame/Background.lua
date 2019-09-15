local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _,uClass = UnitClass("player")
local faderState

local DebuffDispel = {-- DISPELLING ALLIES, 10 = Classic since there are no specs in classic.
	['DEATHKNIGHT'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['DEMONHUNTER'] = {
		[1] = {'None'},
		[2] = {'None'},
		[10] = {'None'},
	},
	['DRUID'] = {
		[1] = {'Curse','Poison'},
		[2] = {'Curse','Poison'},
		[3] = {'Curse','Poison'},
		[4] = {'Curse','Magic','Poison'},
		[10] = {'Curse','Poison'}
	},
	['HUNTER'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['MAGE'] = {
		[1] = {'Curse'},
		[2] = {'Curse'},
		[3] = {'Curse'},
		[10] = {'Curse'},
	},
	['MONK'] = {
		[1] = {'Disease','Poison'},
		[2] = {'Disease','Magic','Poison'},
		[3] = {'Disease','Poison'},
		[10] = {'None'},
	},
	['PALADIN'] = {
		[1] = {'Disease','Magic','Poison'},
		[2] = {'Disease','Poison'},
		[3] = {'Disease','Poison'},
		[10] = {'Disease','Magic','Poison'},
	},
	['PRIEST'] = {
		[1] = {'Disease','Magic'},
		[2] = {'Disease','Magic'},
		[3] = {'Disease'},
		[10] = {'Disease','Magic'},
	},
	['ROGUE'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['SHAMAN'] = {
		[1] = {'Curse'},
		[2] = {'Curse'},
		[3] = {'Curse','Magic'},
		[10] = {'Disease','Poison'},
	},
	['WARLOCK'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARRIOR'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
}
local BuffDispel = {-- PURGES
	['DEATHKNIGHT'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['DEMONHUNTER'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[10] = {'None'},
	},
	['DRUID'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[4] = {'Enrage'},
		[10] = {'None'},
	},
	['HUNTER'] = {
		[1] = {'Enrage'},
		[2] = {'Enrage'},
		[3] = {'Enrage'},
		[10] = {'Enrage'},
	},
	['MAGE'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'None'},
	},
	['MONK'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['PALADIN'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['PRIEST'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['ROGUE'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
	['SHAMAN'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARLOCK'] = {
		[1] = {'Magic'},
		[2] = {'Magic'},
		[3] = {'Magic'},
		[10] = {'Magic'},
	},
	['WARRIOR'] = {
		[1] = {'None'},
		[2] = {'None'},
		[3] = {'None'},
		[10] = {'None'},
	},
}

function RUF.SetFrameBorder(self, unit)
	local name = self:GetName()
	local Border = CreateFrame('Frame',name..'.Border',self)
	local offset = RUF.db.profile.Appearance.Border.Offset

	Border:SetPoint('TOPLEFT',self,'TOPLEFT',-offset,offset)
	Border:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',offset,-offset)

	Border:SetFrameLevel(10)
	Border:SetBackdrop({edgeFile = LSM:Fetch('border', RUF.db.profile.Appearance.Border.Style.edgeFile), edgeSize = RUF.db.profile.Appearance.Border.Style.edgeSize})
	local r,g,b = unpack(RUF.db.profile.Appearance.Border.Color)
	Border:SetBackdropBorderColor(r,g,b, RUF.db.profile.Appearance.Border.Alpha)

	self.Border = Border
end

function RUF.SetGlowBorder(self, unit) -- Aura Highlight Border
	--[[
	TODO:
	Options
	Unregister Events in options too if set. We only set if enabled, so only need to disable if they have been set in that session.


	]]--


	local name = self:GetName()
	local Border = CreateFrame('Frame',name..'.Border',self)
	local profileReference = RUF.db.profile.Appearance.Border.Glow
	local offset = profileReference.Offset

	local GlowBorder = CreateFrame('Frame',name..'.GlowBorder',self)
	GlowBorder:SetPoint('TOPLEFT',self,'TOPLEFT',-offset,offset)
	GlowBorder:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',offset,-offset)
	GlowBorder:SetFrameLevel(10)
	GlowBorder:SetBackdrop({edgeFile = LSM:Fetch('border', profileReference.Style.edgeFile), edgeSize = profileReference.Style.edgeSize})
	GlowBorder:SetBackdropBorderColor(0,0,0, profileReference.Alpha)
	GlowBorder:Hide()

	self.GlowBorder = GlowBorder
	if profileReference.Enabled == true then
		self:RegisterEvent('UNIT_AURA',RUF.UpdateGlowBorder,true)
		self:RegisterEvent('UNIT_TARGET',RUF.UpdateGlowBorder,true)
	end
end

function RUF.UpdateGlowBorder(self, event)
	local unit = self.unit
	if event == 'UNIT_TARGET' then
		self.GlowBorder:Hide() -- Immediately hide until we check the new unit.
	end
	if RUF.Client == 1 then
		-- GetSpecialization doesn't exist for Classic. All 'specs' can dispel the same types, so set to 10 to follow those values where appropriate.
		RUF.Specialization = GetSpecialization()
	else
		RUF.Specialization = 10
	end
	local removable = false
	local dispelType
	local auraTypes
	local buffFilter
	if UnitIsFriend('player',unit) then
		auraTypes = DebuffDispel[uClass][RUF.Specialization]
		buffFilter = "HARMFUL"
	else
		auraTypes = BuffDispel[uClass][RUF.Specialization]
		buffFilter = "HELPFUL"
	end
	for i = 1,40 do
		local name, texture, count, debuffType, duration, expiration, caster, isStealable,
		nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,
		timeMod, effect1, effect2, effect3 = UnitAura(unit, i,buffFilter)
		if auraTypes == 'None' then
			removable = false
			break
		else
			for k,v in pairs(auraTypes) do
				if v == debuffType then
					removable = true
					dispelType = debuffType
				end
			end
		end
	end
	if removable == true then
		local r,g,b,a = unpack(RUF.db.profile.Appearance.Colors.Aura.DefaultDebuff)
		r,g,b = unpack(RUF.db.profile.Appearance.Colors.Aura[dispelType])
		a = RUF.db.profile.Appearance.Border.Glow.Alpha
		self.GlowBorder:SetBackdropBorderColor(r,g,b,a)
		self.GlowBorder:Show()
	else
		self.GlowBorder:Hide()
	end

end

function RUF.SetFrameBackground(self, unit)
	local name = self:GetName()
	local Background = CreateFrame('Frame',name..'.Background',self)

	Background:SetAllPoints(self)
	Background:SetFrameStrata('BACKGROUND')

	local r,g,b = unpack(RUF.db.profile.Appearance.Bars.Health.Background.CustomColor)
	local bgMult = RUF.db.profile.Appearance.Bars.Health.Background.Multiplier

	-- Base Background
	local BaseFrame = CreateFrame('Frame',name..'.Background.Base',Background)
	local BaseTexture = BaseFrame:CreateTexture(name..'.Background.Base.Texture','BACKGROUND')
	BaseTexture:SetTexture(LSM:Fetch('background', 'Solid'))
	BaseTexture:SetVertexColor(r*bgMult,g*bgMult,b*bgMult,RUF.db.profile.Appearance.Bars.Health.Background.Alpha)
	BaseFrame:SetAllPoints(Background)
	BaseTexture:SetAllPoints(BaseFrame)

	self.Background = Background
	self.Background.Base = BaseFrame
	self.Background.Base.Texture = BaseTexture
end

function RUF.CombatFader(self,event,unit,arg2,arg3)
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if event == 'updateOptions' then
		if profileReference.Enabled then
			if RUF.Client == 1 then
				RUF:RegisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader, true)
			else
				RUF:RegisterEvent('UNIT_TARGET', RUF.CombatFader, true)
			end
			RUF:RegisterEvent('PLAYER_REGEN_DISABLED', RUF.CombatFader, true)
			RUF:RegisterEvent('PLAYER_REGEN_ENABLED', RUF.CombatFader, true)
			RUF:RegisterEvent('PLAYER_ENTERING_WORLD', RUF.CombatFader, true)
		else
			if RUF.Client == 1 then
				RUF:UnregisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFader)
			else
				RUF:UnregisterEvent('UNIT_TARGET', RUF.CombatFader)
			end
			RUF:UnregisterEvent('PLAYER_REGEN_DISABLED', RUF.CombatFader)
			RUF:UnregisterEvent('PLAYER_REGEN_ENABLED', RUF.CombatFader)
			RUF:UnregisterEvent('PLAYER_ENTERING_WORLD', RUF.CombatFader)
		end
	end
	if profileReference.Enabled then
		faderState = true
		for k, v in next, oUF.objects do
			if (event == 'PLAYER_TARGET_CHANGED' or event == 'updateOptions' or (event == 'UNIT_TARGET' and unit == 'player')) and not InCombatLockdown() then
				if profileReference.targetOverride == true and UnitExists('target') then
					v:SetAlpha(profileReference.targetAlpha)
					v.Alpha = profileReference.targetAlpha
				else
					v:SetAlpha(profileReference.restAlpha)
					v.Alpha = profileReference.restAlpha
				end
			elseif event == 'PLAYER_REGEN_DISABLED' then
				v:SetAlpha(profileReference.combatAlpha)
				v.Alpha = profileReference.combatAlpha
			elseif event == 'PLAYER_REGEN_ENABLED' then
				v:SetAlpha(profileReference.restAlpha)
				v.Alpha = profileReference.restAlpha
			elseif event == 'PLAYER_ENTERING_WORLD' then
				if InCombatLockdown() then
					v:SetAlpha(profileReference.combatAlpha)
					v.Alpha = profileReference.combatAlpha
				else
					v:SetAlpha(profileReference.restAlpha)
					v.Alpha = profileReference.restAlpha
				end
			end
		end
	elseif faderState == true then
		for k, v in next, oUF.objects do
			v:SetAlpha(1)
			v.Alpha = 1
		end
		faderState = false
	end
end