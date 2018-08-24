local RUF = RUF or LibStub("AceAddon-3.0"):GetAddon("RUF")
local L = LibStub("AceLocale-3.0"):GetLocale("RUF")
local LSM = LibStub("LibSharedMedia-3.0")
local _, ns = ...
local oUF = ns.oUF

--[[
Assist / Leader - icon-Crown 
Honor - Default?
Combat - icon-Combat-2 
Main Tank - icon-shield-3 
Main Assist - icon-fire 
Objective - icon-Exclamation 
Phased - icon-Phased 
PvP - Default?
Ready:
	Yes - icon-Tick-2 
	No - icon-Cross 
	? - icon-Question-mark 
Rest - icon-Sleep 
Role:
	Tank - icon-Shield-3 
	DPS - icon-fire 
	Heal - icon-Plus 

]]--

local function GetAnchorFrame(self,unit,indicator)
    -- TODO:
    -- Anchor to element (health, power)
    
    local AnchorFrame = "Frame"
    if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame == "Frame" then
        AnchorFrame = self:GetName()
    else
        AnchorFrame = self:GetName().."."..RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrame.."Indicator"
        if not _G[AnchorFrame] then
            AnchorFrame = self:GetName()
        end
    end
    return AnchorFrame
end

local function IsFrameEnabled(self,unit,indicator)
    if not self[indicator.."Indicator"] then return end
    if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Enabled == true then
        return true
    else
        return false
    end
end

local function FrameToggle(self)
    if RUF.db.global.TestMode == true then
        if self.Enabled == true then
            self:Show()
        else
            self:Hide()
        end
    end
    if self.Badge then
        if self.Badge.Enabled == false then
            self.Badge:Hide()
        else
            if self.Enabled == true then
                if self:IsVisible() then
                    self.Badge:Show()
                else
                    self.Badge:Hide()
                end
            else
                self.Badge:Hide()
            end
        end
    end
    if self.Enabled == false then
        self:Hide()
    end
end

function RUF.GetIndicatorFont(self,unit,indicator)
    return RUF.db.profile.unit[unit].Frame.Indicators[indicator].Size
end

local function IndicatorCreator(self,unit,indicator,Parent,layer)
    layer = layer or "OVERLAY"
    local Frame = Parent:CreateTexture(self:GetName().."."..indicator.."Indicator", layer)
    Frame:SetSize(RUF.db.profile.unit[unit].Frame.Indicators[indicator].Size,RUF.db.profile.unit[unit].Frame.Indicators[indicator].Size) 
    Frame:SetPoint(
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrom,
        GetAnchorFrame(self,unit,indicator),
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorTo,
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.x,
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.y)
    return Frame
end

local function TextIndicatorCreator(self,unit,indicator,Parent,layer)
    layer = layer or "OVERLAY"
    local Frame = Parent:CreateFontString(self:GetName().."."..indicator.."Indicator", layer)
    Frame:SetPoint(
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorFrom,
        GetAnchorFrame(self,unit,indicator),
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.AnchorTo,
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.x,
        RUF.db.profile.unit[unit].Frame.Indicators[indicator].Position.y)
    return Frame
end

local function IndicatorCreatorType(self,unit,indicator,Parent,layer)
    local frame
    if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Style then
        if RUF.db.profile.unit[unit].Frame.Indicators[indicator].Style == "RUF" then
            frame = TextIndicatorCreator(self,unit,indicator,Parent,layer)
        elseif RUF.db.profile.unit[unit].Frame.Indicators[indicator].Style == "Blizzard" then
            frame = IndicatorCreator(self,unit,indicator,Parent,layer)
        end
    else
        frame = TextIndicatorCreator(self,unit,indicator,Parent,layer)
    end
    return frame
end

function RUF.UpdateIndicators(self,unit)
	local Frames = {
		[1] = "AssistIndicator",
		[2] = "HonorIndicator",
		[3] = "InCombatIndicator",
		[4] = "LeadIndicator",
		[5] = "MainTankAssistIndicator",
		[6] = "PhasedIndicator",
		[7] = "PvPCombatIndicator",
		[8] = "ObjectiveIndicator",
		[9] = "ReadyIndicator",
		[10] = "RestIndicator",		
		[11] = "RoleIndicator",
		[12] = "TargetMarkIndicator",		
    }
    local indicator = {
		[1] = "Assist",
		[2] = "Honor",
		[3] = "InCombat",
		[4] = "Lead",
		[5] = "MainTankAssist",
		[6] = "Phased",
		[7] = "PvPCombat",
		[8] = "Objective",
		[9] = "Ready",
		[10] = "Rest",		
		[11] = "Role",
		[12] = "TargetMark",		
	}
    for i = 1,#Frames do
        if self[Frames[i]] then
            if self[Frames[i]]:IsObjectType('Texture') then
                self[Frames[i]].Enabled = IsFrameEnabled(self,unit,indicator[i])
                self[Frames[i]]:SetSize(RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Size,RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Size)
                self[Frames[i]]:ClearAllPoints()
                self[Frames[i]]:SetPoint(
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.AnchorFrom,
                    GetAnchorFrame(self,unit,indicator[i]),
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.AnchorTo,
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.x,
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.y)
                if self[Frames[i]].AlwaysShow ~= nil then
                    self[Frames[i]].AlwaysShow = RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].AlwaysShow
                end
                if self[Frames[i]].Badge then
                    self[Frames[i]].Badge.Enabled = RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Badge
                    self[Frames[i]].Badge:SetSize(math.floor(RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Size * 1.7),math.floor(RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Size * 1.7))
                end
                FrameToggle(self[Frames[i]])
            elseif self[Frames[i]]:IsObjectType('FontString') then
                self[Frames[i]].Enabled = IsFrameEnabled(self,unit,indicator[i])
                self[Frames[i]]:SetFont([[Interface\Addons\RUF\Media\RUF.ttf]], RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Size, "OUTLINE")
                self[Frames[i]]:ClearAllPoints()
                self[Frames[i]]:SetPoint(
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.AnchorFrom,
                    GetAnchorFrame(self,unit,indicator[i]),
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.AnchorTo,
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.x,
                    RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].Position.y)  
                if self[Frames[i]].AlwaysShow ~= nil then
                    self[Frames[i]].AlwaysShow = RUF.db.profile.unit[unit].Frame.Indicators[indicator[i]].AlwaysShow
                end
                FrameToggle(self[Frames[i]])
            end
        end
    end
end

function RUF.SetIndicators(self, unit)
    -- TODO:
    --Objective

    -- Indicator Holder Frame
    local Indicators = CreateFrame('Frame', nil, self)
    Indicators:SetAllPoints(self)
    Indicators:SetFrameLevel(15)
    self.Indicators = Indicators

    -- Assist  
    if unit ~= "boss" then     
        self.AssistIndicator = IndicatorCreatorType(self,unit,"Assist",Indicators) 
        self.AssistIndicator.Enabled = IsFrameEnabled(self,unit,"Assist")
        self.AssistIndicator.PostUpdate = FrameToggle
    end

    if unit ~= "pet" then
        if unit == "player" then -- Only Available for Player unit.
            -- Combat Indicator
            self.InCombatIndicator = IndicatorCreatorType(self,unit,"InCombat",Indicators) 
            self.InCombatIndicator.Enabled = IsFrameEnabled(self,unit,"InCombat")
            self.InCombatIndicator.PostUpdate = FrameToggle
        end

        -- Honor
        self.HonorIndicator = IndicatorCreator(self,unit,"Honor",Indicators)
        local Badge = Indicators:CreateTexture(self:GetName()..".HonorIndicator.Badge", 'ARTWORK')
        Badge:SetSize(50, 52)
        Badge:SetPoint('CENTER', self.HonorIndicator, 'CENTER')
        self.HonorIndicator.Badge = Badge
        self.HonorIndicator.Badge.Enabled = RUF.db.profile.unit[unit].Frame.Indicators.Honor.Badge
        self.HonorIndicator.AlwaysShow = RUF.db.profile.unit[unit].Frame.Indicators.Honor.AlwaysShow
        self.HonorIndicator.Enabled = IsFrameEnabled(self,unit,"Honor")
        self.HonorIndicator.PostUpdate = FrameToggle

        -- Lead 
        if unit ~= "boss" then
            self.LeadIndicator = IndicatorCreatorType(self,unit,"Lead",Indicators) 
            self.LeadIndicator.Enabled = IsFrameEnabled(self,unit,"Lead")
            self.LeadIndicator.PostUpdate = FrameToggle

            -- MainTankAssist
            self.MainTankAssistIndicator = IndicatorCreatorType(self,unit,"MainTankAssist",Indicators)
            self.MainTankAssistIndicator.Enabled = IsFrameEnabled(self,unit,"MainTankAssist")
            self.MainTankAssistIndicator.PostUpdate = FrameToggle
        end

        -- Phased
        if unit ~= "player" then
            self.PhasedIndicator = IndicatorCreatorType(self,unit,"Phased",Indicators) 
            self.PhasedIndicator.Enabled = IsFrameEnabled(self,unit,"Phased")
            self.PhasedIndicator.PostUpdate = FrameToggle
        end

        -- PvP
        self.PvPCombatIndicator = IndicatorCreatorType(self,unit,"PvPCombat",Indicators,"ARTWORK")
        self.PvPCombatIndicator.Enabled = IsFrameEnabled(self,unit,"PvPCombat")
        self.PvPCombatIndicator.PostUpdate = FrameToggle

        -- Objective
        if unit ~= "player" and unit ~= "party" and unit ~= "arena" then
            self.ObjectiveIndicator = IndicatorCreatorType(self,unit,"Objective",Indicators) 
            self.ObjectiveIndicator.Enabled = IsFrameEnabled(self,unit,"Objective")
            self.ObjectiveIndicator.PostUpdate = FrameToggle
        end

        -- Ready Check
        if unit ~= "pet" and unit ~= "boss" then
            self.ReadyIndicator = IndicatorCreatorType(self,unit,"Ready",Indicators) 
            self.ReadyIndicator.Enabled = IsFrameEnabled(self,unit,"Ready")
            self.ReadyIndicator.PostUpdate = FrameToggle
        end

        -- Rest
        if unit == "player" then  
            self.RestIndicator = IndicatorCreatorType(self,unit,"Rest",Indicators)
            self.RestIndicator.Enabled = IsFrameEnabled(self,unit,"Rest")
            self.RestIndicator.PostUpdate = FrameToggle
        end

        -- Role
        if unit ~= "boss" then
            self.RoleIndicator = IndicatorCreatorType(self,unit,"Role",Indicators)
            self.RoleIndicator.Enabled = IsFrameEnabled(self,unit,"Role")
            self.RoleIndicator.PostUpdate = FrameToggle
        end
    end

    --Target Markers
    self.TargetMarkIndicator = IndicatorCreatorType(self,unit,"TargetMark",Indicators)
    self.TargetMarkIndicator.Enabled = IsFrameEnabled(self,unit,"TargetMark")
    self.TargetMarkIndicator.PostUpdate = FrameToggle

    RUF.UpdateIndicators(self,unit)
end


