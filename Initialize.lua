local RUF = LibStub("AceAddon-3.0"):NewAddon("RUF", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0", "AceSerializer-3.0", "AceTimer-3.0", "NickTag-1.0")
local _, ns = ...
local oUF = ns.oUF
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local ACD = LibStub('AceConfigDialog-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local includedLayouts = {
	"Alidie's Layout",
	"Raeli's Layout",
}

local versionFromToc = GetAddOnMetadata('RUF','Version')
local versionFromPackager = "@project-version@"
local isDev = false

--@do-not-package@
if versionFromToc == "@project-version@" then
	versionFromToc = 'Dev'
	isDev = true
end
--@end-do-not-package@

function RUF.IsRetail()
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function RUF.IsClassic()
	return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function RUF.IsBCC()
	return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function RUF.IsWrath()
	return WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
end

function RUF.GetClientVariant()
	if RUF.IsRetail() then return WOW_PROJECT_MAINLINE
	elseif RUF.IsWrath() then return WOW_PROJECT_WRATH_CLASSIC
	elseif RUF.IsBCC() then return WOW_PROJECT_BURNING_CRUSADE_CLASSIC
	elseif RUF.IsClassic() then return WOW_PROJECT_CLASSIC
	end
end

local frames = {}
local groupFrames = {}
local headers = {}
if RUF.IsClassic() then
	frames = {
		'Player',
		'Pet',
		'PetTarget',
		'Target',
		'TargetTarget',
		'TargetTargetTarget',
	}
	groupFrames = {
		'PartyTarget',
		'PartyPet',
	}
	headers = {
		'Party',
	}
else
	frames = {
		'Player',
		'Pet',
		'PetTarget',
		'Focus',
		'FocusTarget',
		'Target',
		'TargetTarget',
		'TargetTargetTarget',
	}
	groupFrames = {
		'Boss',
		'BossTarget',
		'Arena',
		'ArenaTarget',
		'PartyTarget',
		'PartyPet',
	}
	headers = {
		'Party',
	}
end
RUF.frameList = {}
RUF.frameList.frames = frames
RUF.frameList.groupFrames = groupFrames
RUF.frameList.headers = headers

function RUF:OnInitialize()
	self.db = LibStub('AceDB-3.0'):New('RUFDB', RUF.Layout.cfg, true) -- Setup Saved Variables

	if RUF.IsRetail() then
		local LibDualSpec = LibStub('LibDualSpec-1.0')
		LibDualSpec:EnhanceDatabase(self.db, 'RUF')
	else
		local LibClassicDurations = LibStub('LibClassicDurations', true)
		if LibClassicDurations then
			LibClassicDurations:Register(RUF)
		end
	end

	-- Register /RUF command
	self:RegisterChatCommand('RUF', 'ChatCommand')

	-- Profile Management
	self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileReset', 'ResetProfile')

	-- Register Media
	LSM:Register('font', 'RUF', [[Interface\Addons\RUF\Media\TGL.ttf]],LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
	LSM:Register('statusbar', 'RUF 1', [[Interface\Addons\RUF\Media\Raeli 1.tga]])
	LSM:Register('statusbar', 'RUF 2', [[Interface\Addons\RUF\Media\Raeli 2.tga]])
	LSM:Register('statusbar', 'RUF 3', [[Interface\Addons\RUF\Media\Raeli 3.tga]])
	LSM:Register('statusbar', 'RUF 4', [[Interface\Addons\RUF\Media\Raeli 4.tga]])
	LSM:Register('statusbar', 'RUF 5', [[Interface\Addons\RUF\Media\Raeli 5.tga]])
	LSM:Register('statusbar', 'RUF 6', [[Interface\Addons\RUF\Media\Raeli 6.tga]])
	LSM:Register('statusbar', 'Armory',[[Interface\Addons\RUF\Media\Extra\Armory.tga]])
	LSM:Register('statusbar', 'Cabaret 2', [[Interface\Addons\RUF\Media\Extra\Cabaret 2.tga]])
	LSM:Register('border','RUF Pixel', [[Interface\ChatFrame\ChatFrameBackground]])
	LSM:Register('border','RUF Glow', [[Interface\Addons\RUF\Media\InternalGlow.tga]])
	LSM:Register('border','RUF Glow Small', [[Interface\Addons\RUF\Media\InternalGlowSmall.tga]])
	LSM:Register('font','Overwatch Oblique',[[Interface\Addons\RUF\Media\Extra\BigNoodleTooOblique.ttf]])
	LSM:Register('font','Overwatch',[[Interface\Addons\RUF\Media\Extra\BigNoodleToo.ttf]])
	LSM:Register('font','Futura',[[Interface\Addons\RUF\Media\Extra\Futura.ttf]])
	LSM:Register('font','Semplicita Light',[[Interface\Addons\RUF\Media\Extra\semplicita.light.otf]])
	LSM:Register('font','Semplicita Light Italic',[[Interface\Addons\RUF\Media\Extra\semplicita.light-italic.otf]])
	LSM:Register('font','Semplicita Medium',[[Interface\Addons\RUF\Media\Extra\semplicita.medium.otf]])
	LSM:Register('font','Semplicita Medium Italic',[[Interface\Addons\RUF\Media\Extra\semplicita.medium-italic.otf]])

	RUF.db.global.TestMode = false
	RUF.db.global.frameLock = true

	--project-revision
	RUF.db.global.Version = string.match(GetAddOnMetadata('RUF','Version'),'%d+')

	if not RUFDB.profiles then
		RUF.FirstRun = true
		RUFDB.profiles = {}
		for i = 1,#includedLayouts do
			RUFDB.profiles[includedLayouts[i]] = RUF.Layout[includedLayouts[i]]
		end
	else
		for i = 1,#includedLayouts do
			if not RUFDB.profiles[includedLayouts[i]] then
				RUFDB.profiles[includedLayouts[i]] = RUF.Layout[includedLayouts[i]]
			end
		end
	end

end

function RUF:ChatCommand(input)
	if not InCombatLockdown() then
		self:EnableModule('Options')
		if ACD.OpenFrames['RUF'] then
			ACD:Close('RUF')
		else
			ACD:Open('RUF')
		end
	else
		RUF:Print_Self(L["Cannot configure while in combat."])
	end
end

function RUF:ResetProfile()
	local currentProfile = self.db:GetCurrentProfile()

	for i = 1,#includedLayouts do
		if includedLayouts[i] == currentProfile then
			local profile = RUF.db.profile
			local source = RUF.Layout[includedLayouts[i]]
			RUF:copyTable(source, profile)
		end
	end
	RUF:RefreshConfig()
	RUF:GetModule('Options'):RefreshConfig()
end

function RUF:RefreshConfig()
	if RUF.db.global.TestMode == true then
		RUF:TestMode()
	end
	RUF.db.profile = self.db.profile
	RUF:UpdateAllUnitSettings()
end