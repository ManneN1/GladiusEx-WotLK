local GladiusEx = _G.GladiusEx
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")
local LSM = LibStub("LibSharedMedia-3.0")

-- global functions
local strfind = string.find
local pairs = pairs
local min = math.min

local Spectate = GladiusEx:GetModule("Spectate", true)

local UnitHealth = Spectate and Spectate.UnitHealth or UnitHealth
local UnitHealthMax = Spectate and Spectate.UnitHealthMax or UnitHealthMax
local UnitClass = Spectate and Spectate.UnitClass or UnitClass

local HealthBar = GladiusEx:NewGladiusExModule("HealthBar", {
    healthBarAttachTo = "Frame",
    healthBarHeight = 15,
    healthBarAdjustWidth = true,
    healthBarWidth = 200,
    healthBarInverse = false,
    healthBarColor = { r = 1, g = 1, b = 1, a = 1 },
    healthBarClassColor = true,
    healthBarBackgroundColor = { r = 1, g = 1, b = 1, a = 0.3 },
    healthBarGlobalTexture = true,
    healthBarTexture = GladiusEx.default_bar_texture,
    healthBarOrder = 1,
    healthBarAnchor = "TOPLEFT",
    healthBarRelativePoint = "TOPLEFT",
})

function HealthBar:OnEnable()
    self:RegisterEvent("UNIT_HEALTH", "UpdateHealthEvent")
    self:RegisterEvent("UNIT_HEALTH_FREQUENT", "UpdateHealthEvent")
    self:RegisterEvent("UNIT_MAXHEALTH", "UpdateHealthEvent")

    if not self.frame then
        self.frame = {}
    end
end

function HealthBar:OnDisable()
    self:UnregisterAllEvents()

    for unit in pairs(self.frame) do
        self.frame[unit]:Hide()
    end
end

function HealthBar:GetAttachType(unit)
    return "Bar"
end

function HealthBar:GetBarHeight(unit)
    return self.db[unit].healthBarHeight
end

function HealthBar:GetBarOrder(unit)
    return self.db[unit].healthBarOrder
end

function HealthBar:GetModuleAttachPoints()
    return {
        ["HealthBar"] = L["HealthBar"],
    }
end

function HealthBar:GetModuleAttachFrame(unit)
    if not self.frame[unit] then
        self:CreateBar(unit)
    end

    return self.frame[unit]
end

function HealthBar:UpdateColorEvent(event, unit)
    self:UpdateColor(unit)
end

function HealthBar:UpdateHealthEvent(event, unit)
    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
    self:UpdateHealth(unit, health, maxHealth)
end

function HealthBar:UpdateColor(unit)
    if not self.frame[unit] then return end

    local class
    if GladiusEx:IsTesting(unit) then
        class = GladiusEx.testing[unit].unitClass
    else
        class = select(2, UnitClass(unit))
    end
    if not class then
        class = GladiusEx.testing[unit].unitClass
    end

    -- set color
    local color
    if class and self.db[unit].healthBarClassColor and (self.frame[unit].seen or GladiusEx:IsTesting(unit)) then
        color = self:GetBarColor(class)
    else
        color = self.db[unit].healthBarColor
    end
    self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
end

function HealthBar:UpdateHealth(unit, health, maxHealth)
    if not self.frame[unit] then return end

    if health > 0 or maxHealth > 0 then
        self.frame[unit].freeze = false
        self.frame[unit].seen = true
    else
        self.frame[unit].freeze = true
    end
    
    self.frame[unit].health = health
    self.frame[unit].maxHealth = maxHealth
    

    -- update min max values
    
    if self.frame[unit].freeze and maxHealth == 0 then
    
    end

    if self.frame[unit].seen == nil then 
        self.frame[unit]:SetMinMaxValues(0, 100)
        if self.db[unit].healthBarInverse then
            self.frame[unit]:SetValue(0)
        else
            self.frame[unit]:SetValue(100)
        end
    
    elseif not self.frame[unit].freeze then
        self.frame[unit]:SetMinMaxValues(0, maxHealth)
        -- inverse bar
        if self.db[unit].healthBarInverse then
            self.frame[unit]:SetValue(maxHealth - health)
        else
            self.frame[unit]:SetValue(health)
        end
    end
end

--function HealthBar:SetIncomingBarAmount(unit, bar, incamount, inccap)
--    local health = self.frame[unit].health
--    local maxHealth = self.frame[unit].maxHealth
--    local barWidth = self.frame[unit]:GetWidth()
--
--
--    -- cap amount
--    incamount = min((maxHealth * (1 + inccap)) - health, incamount)
--
--    local value
--    if self.db[unit].healthBarInverse then
--        value = maxHealth - health
--    else
--        value = health
--    end
--
--    if incamount == 0 then
--        bar:Hide()
--    else
--        local parent = self.frame[unit]
--        local ox = value / maxHealth * barWidth
--
--        if self.db[unit].healthBarInverse then
--            bar:SetPoint("TOPRIGHT", parent, "TOPLEFT", ox, 0)
--            bar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", ox, 0)
--        else
--            bar:SetPoint("TOPLEFT", parent, "TOPLEFT", ox, 0)
--            bar:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", ox, 0)
--        end
--        bar:SetWidth(incamount / maxHealth * barWidth)
--
--        -- set tex coords so that the incoming bar follows the bar texture
--        local left = value / maxHealth
--        local right = (value + incamount) / maxHealth
--        bar:SetTexCoord(left, right, 0, 1)
--        bar:Show()
--    end
--end


function HealthBar:GetBarColor(class)
    return RAID_CLASS_COLORS[class] or { r = 0, g = 1, b = 0 }
end

function HealthBar:CreateBar(unit)
    local button = GladiusEx.buttons[unit]
    if not button then return end

    -- create bar + text
    self.frame[unit] = CreateFrame("STATUSBAR", "GladiusEx" .. self:GetName() .. unit, button)
    self.frame[unit].background = self.frame[unit]:CreateTexture("GladiusEx" .. self:GetName() .. unit .. "Background", "BACKGROUND")
    self.frame[unit].background:SetAllPoints()

    self.frame[unit].inc_frame = CreateFrame("Frame", "GladiusEx" .. self:GetName() .. unit .. "IncBars", self.frame[unit])
    self.frame[unit].inc_frame:SetAllPoints()

    self.frame[unit].incabsorbs = self.frame[unit].inc_frame:CreateTexture("GladiusEx" .. self:GetName() .. unit .. "IncAbsorbs", "OVERLAY", nil, 6)
    self.frame[unit].incheals = self.frame[unit].inc_frame:CreateTexture("GladiusEx" .. self:GetName() .. unit .. "IncHeals", "OVERLAY", nil, 7)
end

function HealthBar:Refresh(unit)
    self:UpdateColorEvent("Refresh", unit)
    self:UpdateHealthEvent("Refresh", unit)
end

function HealthBar:Update(unit)
    -- create power bar
    if not self.frame[unit] then
        self:CreateBar(unit)
    end

    local bar_texture = self.db[unit].healthBarGlobalTexture and LSM:Fetch(LSM.MediaType.STATUSBAR, GladiusEx.db.base.globalBarTexture) or LSM:Fetch(LSM.MediaType.STATUSBAR, self.db[unit].healthBarTexture)
    self.frame[unit]:SetStatusBarTexture(bar_texture)
    self.frame[unit]:GetStatusBarTexture():SetHorizTile(false)
    self.frame[unit]:GetStatusBarTexture():SetVertTile(false)
    self.frame[unit]:SetMinMaxValues(0, 100)
    self.frame[unit]:SetValue(100)

    -- update health bar background
    self.frame[unit].background:SetTexture(bar_texture)
    self.frame[unit].background:SetVertexColor(self.db[unit].healthBarBackgroundColor.r, self.db[unit].healthBarBackgroundColor.g,
        self.db[unit].healthBarBackgroundColor.b, self.db[unit].healthBarBackgroundColor.a)
    self.frame[unit].background:SetHorizTile(false)
    self.frame[unit].background:SetVertTile(false)

    -- hide frame
    self.frame[unit]:Hide()
end

function HealthBar:Show(unit)
    -- update color
    self:UpdateColorEvent("Show", unit)

    -- call event
    self:UpdateHealthEvent("Show", unit)

    -- show frame
    self.frame[unit]:Show()
end

function HealthBar:Reset(unit)
    if not self.frame[unit] then return end

    -- reset bar
    self.frame[unit]:SetMinMaxValues(0, 1)
    self.frame[unit]:SetValue(1)

    -- hide
    self.frame[unit]:Hide()
end

function HealthBar:Test(unit)
    -- set test values
    local maxHealth = GladiusEx.testing[unit].maxHealth
    local health = GladiusEx.testing[unit].health
    self:UpdateColorEvent("Test", unit)
    self:UpdateHealth(unit, health, maxHealth)
end

function HealthBar:GetOptions(unit)
    return {
        general = {
            type = "group",
            name = L["General"],
            order = 1,
            args = {
                bar = {
                    type = "group",
                    name = L["Bar"],
                    desc = L["Bar settings"],
                    inline = true,
                    order = 1,
                    args = {
                        healthBarClassColor = {
                            type = "toggle",
                            name = L["Class color"],
                            desc = L["Toggle health bar class color"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 5,
                        },
                        healthBarColor = {
                            type = "color",
                            name = L["Color"],
                            desc = L["Color of the health bar"],
                            hasAlpha = true,
                            get = function(info) return GladiusEx:GetColorOption(self.db[unit], info) end,
                            set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db[unit], info, r, g, b, a) end,
                            disabled = function() return self.db[unit].healthBarClassColor or not self:IsUnitEnabled(unit) end,
                            order = 10,
                        },
                        healthBarBackgroundColor = {
                            type = "color",
                            name = L["Background color"],
                            desc = L["Color of the health bar background"],
                            hasAlpha = true,
                            get = function(info) return GladiusEx:GetColorOption(self.db[unit], info) end,
                            set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db[unit], info, r, g, b, a) end,
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 15,
                        },
                        sep = {
                            type = "description",
                            name = "",
                            width = "full",
                            order = 17,
                        },
                        healthBarInverse = {
                            type = "toggle",
                            name = L["Inverse"],
                            desc = L["Invert the bar colors"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 20,
                        },
                        sep2 = {
                            type = "description",
                            name = "",
                            width = "full",
                            order = 21,
                        },
                        healthBarGlobalTexture = {
                            type = "toggle",
                            name = L["Use global texture"],
                            desc = L["Use the global bar texture"],
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 24,
                        },
                        healthBarTexture = {
                            type = "select",
                            name = L["Texture"],
                            desc = L["Texture of the health bar"],
                            dialogControl = "LSM30_Statusbar",
                            values = AceGUIWidgetLSMlists.statusbar,
                            disabled = function() return self.db[unit].healthBarGlobalTexture or not self:IsUnitEnabled(unit) end,
                            order = 25,
                        },
                    },
                },
                size = {
                    type = "group",
                    name = L["Size"],
                    desc = L["Size settings"],
                    inline = true,
                    order = 2,
                    args = {
                        healthBarHeight = {
                            type = "range",
                            name = L["Height"],
                            desc = L["Height of the health bar"],
                            softMin = -25, softMax = 25, bigStep = 1,
                            disabled = function() return not self:IsUnitEnabled(unit) end,
                            order = 20,
                        },
                    },
                },
                position = {
                    type = "group",
                    name = L["Position"],
                    desc = L["Position settings"],
                    inline = true,
                    order = 3,
                    args = {
                        healthBarOrder = {
                            type = "range",
                            name = L["Bar order"],
                            desc = L["Bar order"],
                            softMin = 1, softMax = 10, bigStep = 1,
                            disabled = function() return  not self:IsUnitEnabled(unit) end,
                            order = 1,
                        },
                    },
                },
            },
        },        
    }
end
