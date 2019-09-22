local RUF = LibStub('AceAddon-3.0'):GetAddon('RUF')
local L = LibStub('AceLocale-3.0'):GetLocale('RUF')
local RUF_Options = RUF:NewModule('Options')
local ACD = LibStub('AceConfigDialog-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local _, ns = ...
local oUF = ns.oUF
local _, PlayerClass = UnitClass('player')
local Options = {}

function RUF_Options:TempOptions()
	local tempOptions = {
		type = 'group',
		name = function(info)
			return "RUF [|c5500DBBDRaeli's Unit Frames|r] r|c5500DBBD" .. string.match(GetAddOnMetadata('RUF','Version'),'%d+') ..'|r'
		end,
		order = 0,
		args = {
				Open = {
					name = L["Open Configuration Panel"],
					type = 'execute',
					order = 0,
					func = function()
						HideUIPanel(InterfaceOptionsFrame)
						HideUIPanel(GameMenuFrame)
						RUF:ChatCommand('Open') end,
				},
			},
		}
	LibStub('AceConfig-3.0'):RegisterOptionsTable('RUF_Blizz', tempOptions) -- Register Options
	self.optionsFrame = ACD:AddToBlizOptions('RUF_Blizz', 'RUF')
end

local function UnitOptions()
	Options.args.Unit = RUF_Options.GenerateUnits()
end

function RUF_Options:OnEnable()

	Options = RUF_Options.MainOptions()
	Options.args.Appearance.args.Colors = RUF_Options.Colors()
	Options.args.Appearance.args.Bars = RUF_Options.Bars()
	Options.args.Appearance.args.Texts = RUF_Options.Texts()
	--Options.args.Filtering = RUF_Options.Filters()

	LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('RUF', Options)
	local Profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	Options.args.profiles = Profiles
	Options.args.profiles.order = 99
	UnitOptions()

	ACD:SetDefaultSize('RUF',995,690)
	if RUF.Client == 1 then
		local LibDualSpec = LibStub('LibDualSpec-1.0')
		LibDualSpec:EnhanceDatabase(self.db, 'RUF')
		LibDualSpec:EnhanceOptions(Profiles, self.db)
	end
	InterfaceAddOnsList_Update()
	GuildRoster()

	-- Profile Management
	self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
	self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')
end

function RUF_Options:OnInitialize()
	self:SetEnabledState(false)
	self.db = RUF.db -- Setup Saved Variables
	--RUF:UpdateUnitSettings()


	RUF_Options:TempOptions()
	--[[RUF.db.char.GuildNum = GetNumGuildMembers()
	RUF.db.char.Guild = {}
	if RUF.db.char.GuildNum > 50 then RUF.db.char.GuildNum = 50 end
	if RUF.db.char.GuildNum > 0 then
		for i=1,RUF.db.char.GuildNum do
			local n = GetGuildRosterInfo(i)
			local c = select(11,GetGuildRosterInfo(i))
			RUF.db.char.Guild[i] = {['Name'] = string.gsub(n, '-.*', ''), ['Class'] = c}
		end
	else
		RUF.db.char.Guild[1] = {['Name'] = UnitName('player'), ['Class'] = PlayerClass}
	end]]--
end

function RUF:UpdateOptions()
	local Options = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	UnitOptions()
	LibStub('AceConfigRegistry-3.0'):NotifyChange('RUF')
end

function RUF_Options:RefreshConfig()
	if RUF.db.global.TestMode == true then
		RUF:TestMode()
	end
	RUF.db.profile = self.db.profile
	RUF:UpdateOptions()
end