local RUF = RUF or LibStub('AceAddon-3.0'):GetAddon('RUF')
local _, ns = ...
local oUF = ns.oUF

local function ChangeAlpha(self, to, duration)
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if profileReference.animate then
		RUF.AnimateAlpha(self, to, duration)
	else
		self:SetAlpha(to)
		self.Alpha.target = to
	end

	if self.RangeCheck then
		if self.RangeCheck.enabled and self.RangeCheck.ForceUpdate then
			self.RangeCheck:ForceUpdate()
		end
	end
end

function RUF:RangeCheckPostUpdate(frame, unit)
	if not frame.Animator then
		frame:SetAlpha(frame.Alpha.range)
		return
	end
	if frame.Animator:IsPlaying() then
		if frame.Alpha.inRange == false then
			frame.Animator:Stop()
			frame:SetAlpha(frame.Alpha.range)
			frame.Alpha.current = frame.Alpha.range
		end
	else
		frame:SetAlpha(frame.Alpha.range)
	end
end

local function Reset(fast)
	if fast then
		for k, v in next, oUF.objects do
			v:SetAlpha(1)
			v.Alpha.target = 1
			v.Alpha.current = 1
		end
	else
		local profileReference = RUF.db.profile.Appearance.CombatFader
		for k, v in next, oUF.objects do
			ChangeAlpha(v, 1, profileReference.animationDuration)
		end
	end
end

function RUF.CombatFaderUpdate()
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if not InCombatLockdown() then
		if profileReference.Enabled ~= true then
			Reset()
			return
		end
		if UnitExists('target') and profileReference.targetOverride == true then
			for k, v in next, oUF.objects do
				ChangeAlpha(v, profileReference.targetAlpha or 1, profileReference.animationDuration or 0.5)
			end
		else
			for k, v in next, oUF.objects do
				if UnitExists(v.unit) then
					ChangeAlpha(v, profileReference.restAlpha or 0.5, profileReference.animationDuration or 0.5)
				else
					v:SetAlpha(profileReference.restAlpha)
					v.Alpha.target = profileReference.restAlpha
					v.Alpha.current = profileReference.restAlpha
				end
			end
			if profileReference.damagedOverride == true then
				local playerPercentHealth = RUF:Percent(UnitHealth('player'), UnitHealthMax('player'))
				if playerPercentHealth < (profileReference.damagedPercent or 100) then
					if not oUF_RUF_Player then return end
					ChangeAlpha(oUF_RUF_Player, profileReference.damagedAlpha or 1, profileReference.animationDuration or 0.5)
				end
			end
		end
	end
end

local function PLAYER_REGEN_DISABLED(self, event)
	if event ~= 'PLAYER_REGEN_DISABLED' then return end
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if profileReference.Enabled == true then
		Reset(true)
	end
end

local function PLAYER_REGEN_ENABLED(self, event)
	if event ~= 'PLAYER_REGEN_ENABLED' then return end
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if profileReference.Enabled == true then
		RUF.CombatFaderRegister()
	end
end

local function PLAYER_ENTERING_WORLD(self, event)
	if event ~= 'PLAYER_ENTERING_WORLD' then return end
	RUF.CombatFaderRegister()
end

local function UNIT_HEALTH(self, event)
	if event ~= 'UNIT_HEALTH_FREQUENT' and event ~= 'UNIT_MAXHEALTH' then return end
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if profileReference.Enabled == true then
		RUF.CombatFaderUpdate()
	end
end

function RUF.CombatFaderRegister()
	local profileReference = RUF.db.profile.Appearance.CombatFader
	if profileReference.Enabled == true then
		if profileReference.targetOverride == true then
			if RUF.Client == 2 then
				RUF:RegisterEvent('UNIT_TARGET', RUF.CombatFaderUpdate, true)
			end
		end
		if profileReference.damagedOverride == true then
			RUF:RegisterEvent('UNIT_HEALTH_FREQUENT', UNIT_HEALTH, true)
			RUF:RegisterEvent('UNIT_MAXHEALTH', UNIT_HEALTH, true)
		end
		RUF:RegisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFaderUpdate, true)
		RUF:RegisterEvent('PLAYER_REGEN_DISABLED', PLAYER_REGEN_DISABLED, true)
		RUF:RegisterEvent('PLAYER_REGEN_ENABLED', PLAYER_REGEN_ENABLED, true)
		RUF:RegisterEvent('PLAYER_ENTERING_WORLD', PLAYER_ENTERING_WORLD, true)
		RUF.CombatFaderUpdate()
	else
		RUF:UnregisterEvent('UNIT_TARGET', RUF.CombatFaderUpdate)
		RUF:UnregisterEvent('UNIT_HEALTH_FREQUENT', UNIT_HEALTH)
		RUF:UnregisterEvent('UNIT_MAXHEALTH', UNIT_HEALTH)
		RUF:UnregisterEvent('PLAYER_TARGET_CHANGED', RUF.CombatFaderUpdate)
		RUF:UnregisterEvent('PLAYER_REGEN_DISABLED', PLAYER_REGEN_DISABLED)
		RUF:UnregisterEvent('PLAYER_REGEN_ENABLED', PLAYER_REGEN_ENABLED)
		RUF:UnregisterEvent('PLAYER_ENTERING_WORLD', PLAYER_ENTERING_WORLD)
		Reset()
	end
end