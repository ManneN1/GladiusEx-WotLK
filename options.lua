﻿local fn = LibStub("LibFunctional-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiusEx")

GladiusEx.default_bar_texture = "Wglass (GladiusEx)"
GladiusEx.defaults = {
    profile = {
        locked = false,
        advancedOptions = false,
        globalFont = "Designosaur (GladiusEx)",
        globalFontSize = 11,
        globalFontOutline = "OUTLINE",
        globalFontShadowColor = { r = 0, g = 0, b = 0, a = 0 },
        globalBarTexture = GladiusEx.default_bar_texture,
        showParty = true,
        showArena = true,
        hideSelf = false,
        superFS = true,
        specManaLimit = 15000,
        testUnits = {
            ["arena1"] = { health = 350000, maxHealth = 350000, power = 180000, maxPower = 300000, powerType = 0, unitClass = "MAGE", unitRace = "Undead", specID = 64 },
            ["arena2"] = { health = 275000, maxHealth = 320000, power = 10, maxPower = 100, powerType = 2, unitClass = "HUNTER", unitRace = "NightElf", specID = 253 },
            ["arena3"] = { health = 220000, maxHealth = 350000, power = 175000, maxPower = 300000, powerType = 0, unitClass = "DRUID", unitRace = "Worgen", specID = 105 },
            ["arena4"] = { health = 240000, maxHealth = 350000, power = 90, maxPower = 110, powerType = 3, unitClass = "ROGUE", unitRace = "Human", specID = 261 },
            ["arena5"] = { health = 100000, maxHealth = 370000, power = 10, maxPower = 100, powerType = 1, unitClass = "WARRIOR", unitRace = "Gnome", specID = 71 },

            ["player"] = { health = 250000, maxHealth = 350000, power = 18000, maxPower = 300000, powerType = 0, unitClass = "PRIEST", unitRace = "Draenei", specID = 256 },
            ["party1"] = { health = 300000, maxHealth = 320000, power = 10000, maxPower = 12000, powerType = 1, unitClass = "WARRIOR", unitRace = "Pandaren", specID = 71 },
            ["party2"] = { health = 220000, maxHealth = 350000, power = 280000, maxPower = 300000, powerType = 0, unitClass = "WARLOCK", unitRace = "Orc", specID = 267 },
            ["party3"] = { health = 100000, maxHealth = 300000, power = 10, maxPower = 100, powerType = 1, unitClass = "WARRIOR", unitRace = "Troll", specID = 71 },
            ["party4"] = { health = 200000, maxHealth = 400000, power = 80, maxPower = 130, powerType = 6, unitClass = "DEATHKNIGHT", unitRace = "Dwarf", specID = 252 },
        },
        --[===[@debug@
        debug = true,
        --@end-debug@]===]
    }
}

local group_defaults = {
    x = {},
    y = {},
    growDirection = "VCENTER",
    groupButtons = true,
    oorAlpha = 0.7,
    stealthAlpha = 0.4,
    deadAlpha = 0.2,
    backgroundColor = { r = 0, g = 0, b = 0, a = 0 },
    backgroundPadding = 5,
    margin = 2,
    barWidth = 174,
    barsHeight = 40,
    frameScale = 1,
    borderSize = 2,
    modMargin = 1,
    backdropColor = { r = 0, g = 0, b = 0, a = 0.8 },
}

GladiusEx.defaults_arena = fn.merge(group_defaults, {
    modules = {
        ["*"] = true,
        ["TargetBar"] = false,
        ["PetBar"] = false,
        ["Clicks"] = false,
        ["Auras"] = false,
        ["Alerts"] = false,
    },
})

GladiusEx.defaults_party = fn.merge(group_defaults, {
    modules = {
        ["*"] = true,
        ["TargetBar"] = false,
        ["PetBar"] = false,
        ["Clicks"] = false,
        ["Announcements"] = false,
        ["Auras"] = false,
        ["Alerts"] = false,
    },
})

-- upvalues
local strfind = string.find


SLASH_GLADIUSEX1 = "/gladiusex"
SLASH_GLADIUSEX2 = "/gex"
SlashCmdList["GLADIUSEX"] = function(msg)
    if msg:find("test") then
        local test = false

        if msg == "test2" then
            test = 2
        elseif msg == "test3" then
            test = 3
        elseif msg == "test5" then
            test = 5
        else
            test = tonumber(msg:match("^test (.+)"))

            if test and (test > 5 or test < 2 or test == 4) then
                test = 5
            end
        end

        GladiusEx:SetTesting(test)
    elseif msg == "" or msg == "options" or msg == "config" or msg == "ui" then
        GladiusEx:ShowOptionsDialog()
    elseif msg == "hide" then
        -- hide buttons
        GladiusEx:HideFrames()
    elseif msg == "reset" then
        -- reset profile
        GladiusEx.dbi:ResetProfile()
    end
end

function GladiusEx:GetColorOption(db, info)
    local key = info.arg or info[#info]
    return db[key].r, db[key].g, db[key].b, db[key].a
end

function GladiusEx:SetColorOption(db, info, r, g, b, a)
    local key = info.arg or info[#info]
    db[key].r, db[key].g, db[key].b, db[key].a = r, g, b, a

    GladiusEx:UpdateFrames()
end

function GladiusEx:GetPositions()
    return {
        ["TOPLEFT"] = L["Top left"],
        ["TOPRIGHT"] = L["Top right"],
        ["LEFT"] = L["Center left"],
        ["RIGHT"] = L["Center right"],
        ["BOTTOMLEFT"] = L["Bottom left"],
        ["BOTTOMRIGHT"] = L["Bottom right"],
    }
end

function GladiusEx:SetupModuleOptions(unit, key, module, order)
    local function getModuleOption(module, info)
        return (info.arg and module.db[unit][info.arg] or module.db[unit][info[#info]])
    end

    local function setModuleOption(module, info, value)
        local key = info.arg or info[#info]
        module.db[unit][key] = value
        self:UpdateFrames()
    end

    local options = {
        type = "group",
        name = function() return (self:IsModuleEnabled(unit, key) and "" or "|cff7f7f7f") .. L[key]  end,
        desc = string.format(L["%s settings"], L[key]),
        childGroups = "tab",
        order = order,
        get = fn.bind(getModuleOption, module),
        set = fn.bind(setModuleOption, module),
        args = {},
    }

    -- set additional module options
    local mod_options = module:GetOptions(unit)

    if type(options) == "table" then
        options.args = mod_options
    end

    -- add enable module option
    options.args.enable = {
        type = "toggle",
        name = L["Enable module"],
        set = function(info, v)
            self.db[unit].modules[key] = v

            self:CheckEnableDisableModule(key)

            self:UpdateFrames()
        end,
        get = function(info)
            return self.db[unit].modules[key]
        end,
        order = 0,
    }

    -- add reset module option
    options.args.reset = {
        type = "execute",
        name = L["Reset module"],
        func = function()
            if self:IsArenaUnit(unit) then
                module.dbi_arena:ResetProfile()
            else
                module.dbi_party:ResetProfile()
            end
            self:SetupOptions()
            self:UpdateFrames()
        end,
        order = 0.5,
    }

    -- add copy from other group option
    options.args.copy = {
        type = "execute",
        name = self:IsArenaUnit(unit) and L["Copy from party"] or L["Copy from arena"],
        func = function()
            if self:IsArenaUnit(unit) then
                self:CopyGroupModuleSettings(module, "arena", "party")
            else
                self:CopyGroupModuleSettings(module, "party", "arena")
            end
        end,
        order = 0.75,
    }

    return options
end

function GladiusEx:MakeGroupOptions(group, unit, order)
    local function getOption(info)
        return (info.arg and GladiusEx.db[unit][info.arg] or GladiusEx.db[unit][info[#info]])
    end

    local function setOption(info, value)
        local key = info.arg or info[#info]
        GladiusEx.db[unit][key] = value
        GladiusEx:UpdateFrames()
    end

    local options = {
        type = "group",
        name = L[group],
        get = getOption,
        set = setOption,
        order = order,
        args = {
            general = {
                type = "group",
                name = L["General"],
                desc = L["General settings"],
                order = 1,
                args = {
                    grouping = {
                        type = "group",
                        name = L["Grouping"],
                        desc = L["Frame grouping"],
                        inline = true,
                        order = 1,
                        args = {
                            groupButtons = {
                                type = "toggle",
                                name = L["Group unit frames"],
                                desc = L["Disable this to be able to move the frames separately"],
                                set = function(info, value)
                                    if not value then
                                        -- if ungrouping, save current frame positions
                                        self:SaveAnchorPosition(self:GetUnitAnchorType(unit))
                                    end
                                    setOption(info, value)
                                end,
                                order = 10,
                            },
                            sep = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 11,
                            },
                            growDirection = {
                                order = 15,
                                type = "select",
                                name = L["Grow direction"],
                                desc = L["The direction you want the frames to grow in"],
                                values = {
                                    ["HCENTER"] = L["Left and right"],
                                    ["VCENTER"] = L["Up and down"],
                                    ["LEFT"]    = L["Left"],
                                    ["RIGHT"]   = L["Right"],
                                    ["UP"]      = L["Up"],
                                    ["DOWN"]    = L["Down"],
                                },
                                disabled = function() return not self.db[unit].groupButtons end,
                            },
                            margin = {
                                type = "range",
                                name = L["Margin"],
                                desc = L["Margin between each button"],
                                softMin = 0, softMax = 100, bigStep = 1,
                                disabled = function() return not self.db[unit].groupButtons end,
                                order = 17,
                            },
                            sep3 = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 18,
                            },
                            backgroundColor = {
                                type = "color",
                                name = L["Group background color"],
                                desc = L["Color of the background"],
                                hasAlpha = true,
                                get = function(info) return GladiusEx:GetColorOption(self.db[unit], info) end,
                                set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db[unit], info, r, g, b, a) end,
                                disabled = function() return not self.db[unit].groupButtons end,
                                order = 20,
                            },
                            backgroundPadding = {
                                type = "range",
                                name = L["Background padding"],
                                desc = L["Padding of the background"],
                                min = 0, max = 100, step = 1,
                                disabled = function() return not self.db[unit].groupButtons end,
                                order = 30,
                            },
                        },
                    },
                    frame = {
                        type = "group",
                        name = L["Unit frames"],
                        desc = L["Unit frames settings"],
                        inline = true,
                        order = 2,
                        args = {
                            backdropColor = {
                                type = "color",
                                name = L["Frame background color"],
                                desc = L["Color of the frames background"],
                                hasAlpha = true,
                                get = function(info) return GladiusEx:GetColorOption(self.db[unit], info) end,
                                set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db[unit], info, r, g, b, a) end,
                                order = 10,
                            },
                            sep = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 20,
                            },
                            modMargin = {
                                type = "range",
                                name = L["Mod margin"],
                                desc = L["Margin between each module"],
                                softMin = 0, softMax = 10, bigStep = 1,
                                order = 30,
                            },
                            borderSize = {
                                type = "range",
                                name = L["Border size"],
                                desc = L["Size of the frames border"],
                                softMin = 0, softMax = 10, bigStep = 1,
                                order = 40,
                            },
                            size = {
                                type = "group",
                                name = L["Size"],
                                desc = L["Size settings"],
                                inline = true,
                                order = 45,
                                args = {
                                    barWidth = {
                                        type = "range",
                                        name = L["Bar width"],
                                        desc = L["Width of the bars"],
                                        softMin = 10, softMax = 500, bigStep = 1,
                                        order = 50,
                                    },
                                    barsHeight = {
                                        type = "range",
                                        name = L["Bars height"],
                                        desc = L["Height of the bars"],
                                        softMin = 10, softMax = 100, bigStep = 1,
                                        order = 60,
                                    },
                                    frameScale = {
                                        type = "range",
                                        name = L["Frame scale"],
                                        desc = L["Scale of the frame"],
                                        min = 0.1, softMax = 2, bigStep = 0.01,
                                        order = 70,
                                    },
                                },
                            },
                            units = {
                                type = "group",
                                name = L["Transparency"],
                                desc = L["Transparency settings"],
                                inline = true,
                                order = 75,
                                args = {
                                    oorAlpha = {
                                        type = "range",
                                        name = L["Out of range alpha"],
                                        desc = L["Transparency for units out of range"],
                                        min = 0, max = 1, bigStep = 0.1,
                                        order = 80,
                                    },
                                    stealthAlpha = {
                                        type = "range",
                                        name = L["Stealth alpha"],
                                        desc = L["Transparency for units in stealth"],
                                        min = 0, max = 1, bigStep = 0.1,
                                        hidden = function() return self:IsPartyUnit(unit) end,
                                        order = 90,
                                    },
                                    deadAlpha = {
                                        type = "range",
                                        name = L["Dead alpha"],
                                        desc = L["Transparency for dead units"],
                                        min = 0, max = 1, bigStep = 0.1,
                                        order = 100,
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    }


    -- Add module options
    local mods = fn.sort(fn.from_iterator(self:IterateModules()), function(x, y) return x[1] < y[1] end)
    for order, mod in ipairs(mods) do
        options.args[mod[1]] = self:SetupModuleOptions(unit, mod[1], mod[2], order + 10)
    end

    return options
end

function GladiusEx:RefreshFrames()
    -- todo: this shouldn't be so.. awkward
    if self:IsPartyShown() or self:IsArenaShown() then
        self:HideFrames()
        self:ShowFrames()
    end
end

function GladiusEx:SetupOptions()
    local function getOption(info)
        return (info.arg and GladiusEx.db.base[info.arg] or GladiusEx.db.base[info[#info]])
    end

    local function setOption(info, value)
        local key = info.arg or info[#info]
        GladiusEx.db.base[key] = value
        GladiusEx:UpdateFrames()
    end

    local options = {
        type = "group",
        name = "GladiusEx",
        get = getOption,
        set = setOption,
        args = {
            general = {
                type = "group",
                name = L["General"],
                desc = L["General settings"],
                order = 1,
                args = {
                    general = {
                        type = "group",
                        name = L["General"],
                        desc = L["General settings"],
                        inline = true,
                        order = 1,
                        args = {
                            locked = {
                                type = "toggle",
                                name = L["Lock frames"],
                                desc = L["Toggle if the frames can be moved"],
                                order = 1,
                            },
                            showParty = {
                                type = "toggle",
                                name = L["Show party frames"],
                                desc = L["Toggle to show your party frames"],
                                set = function(info, value)
                                    setOption(info, value)
                                    -- todo: this shouldn't be so.. awkward
                                    GladiusEx:RefreshFrames()
                                end,
                                order = 11,
                            },
                            showArena = {
                                type = "toggle",
                                name = L["Show arena frames"],
                                desc = L["Toggle to show your arena frames"],
                                set = function(info, value)
                                    setOption(info, value)
                                    GladiusEx:RefreshFrames()
                                end,
                                order = 12,
                            },
                            hideSelf = {
                                type = "toggle",
                                name = L["Hide self frame"],
                                desc = L["Hide the player's frame"],
                                set = function(info, value)
                                    setOption(info, value)
                                    GladiusEx:RefreshFrames()
                                end,
                                order = 13,
                            },
                            advancedOptions = {
                                type = "toggle",
                                name = L["Advanced options"],
                                desc = L["Toggle display of advanced options"],
                                order = 15,
                            },
                            specManaLimit = {
                                type = "range",
                                name = "Mana Specialization Limit",
                                desc = "This mana limit will be used to determine whether a Shaman is Enhancement, a Paladin is Holy (etc)",
                                min = 0,
                                max = 300000,
                                step = 100,
                                set = function(info, value)
                                    setOption(info, value)
                                    GladiusEx:RefreshFrames()
                                end,
                                hidden = function() return not self.db.base.advancedOptions end,
                                order = 16,
                            },
                        },
                    },
                    font = {
                        type = "group",
                        name = L["Global settings"],
                        desc = L["Global settings"],
                        inline = true,
                        order = 4,
                        args = {
                            globalFont = {
                                type = "select",
                                name = L["Font"],
                                desc = L["Global font, used by the modules"],
                                dialogControl = "LSM30_Font",
                                values = AceGUIWidgetLSMlists.font,
                                order = 1,
                            },
                            globalFontSize = {
                                type = "range",
                                name = L["Font size"],
                                desc = L["Text size of the global font"],
                                min = 1, max = 20, bigStep = 1,
                                order = 2,
                            },
                            globalFontOutline = {
                                type = "select",
                                name = L["Font outline"],
                                desc = L["Text outline of the global font"],
                                values = {
                                    [""] = L["None"],
                                    ["OUTLINE"] = L["Outline"],
                                    ["THICKOUTLINE"] = L["Thick outline"],
                                },
                                order = 3,
                            },
                            globalFontShadowColor = {
                                type = "color",
                                name = L["Font shadow color"],
                                desc = L["Text shadow color of the global font"],
                                hasAlpha = true,
                                get = function(info) return GladiusEx:GetColorOption(self.db.base, info) end,
                                set = function(info, r, g, b, a) return GladiusEx:SetColorOption(self.db.base, info, r, g, b, a) end,
                                order = 4,
                            },
                            superFS = {
                                type = "toggle",
                                name = L["Advanced font rendering"],
                                desc = L["Disable this if you are experiencing problems with the texts (requires a UI reload to take effect)"],
                                width = "double",
                                hidden = function() return not self.db.base.advancedOptions end,
                                order = 5,
                            },
                            sep = {
                                type = "description",
                                name = "",
                                width = "full",
                                order = 7,
                            },
                            globalBarTexture = {
                                type = "select",
                                name = L["Bar texture"],
                                desc = L["Global texture of the bars"],
                                dialogControl = "LSM30_Statusbar",
                                values = AceGUIWidgetLSMlists.statusbar,
                                order = 10,
                            },
                        },
                    },
                },
            },
            testing = {
                type = "group",
                name = L["Testing"],
                desc = L["Testing settings"],
                childGroups = "tree",
                order = 2,
                args = {
                    test = {
                        type = "header",
                        name = L["Test frames"],
                        order = 0,
                    },
                    test2 = {
                        type = "execute",
                        name = L["Test 2v2"],
                        width = "half",
                        func = function() self:SetTesting(2) end,
                        disabled = function() return self:IsTesting() == 2 end,
                        order = 0.2,
                    },
                    test3 = {
                        type = "execute",
                        name = L["Test 3v3"],
                        width = "half",
                        func = function() self:SetTesting(3) end,
                        disabled = function() return self:IsTesting() == 3 end,
                        order = 0.3,
                    },
                    test5 = {
                        type = "execute",
                        name = L["Test 5v5"],
                        width = "half",
                        func = function() self:SetTesting(5) end,
                        disabled = function() return self:IsTesting() == 5 end,
                        order = 0.5,
                    },
                    hide = {
                        type = "execute",
                        name = L["Stop testing"],
                        width = "triple",
                        func = function() self:SetTesting() end,
                        disabled = function() return not self:IsTesting() end,
                        order = 1,
                    },
                    testunits = {
                        type = "header",
                        name = L["Test units"],
                        hidden = function() return not self.db.base.advancedOptions end,
                        order = 3,
                    },
                }
            }
        }
    }

    -- add test units
    for _, unit in ipairs(fn.difference(fn.concat(fn.keys(self.party_units), fn.keys(self.arena_units)), { "player" })) do
        local test_frame = {
            type = "group",
            name = unit,
            order = 10,
            inline = true,
            hidden = function() return not self.db.base.advancedOptions end,
            args = {
                race = {
                    order = 1,
                    type = "select",
                    name = L["Race"],
                    desc = L["Unit race"],
                    get = function() return self.db.base.testUnits[unit].unitRace end,
                    set = function(info, value)
                        self.db.base.testUnits[unit].unitRace = value
                        self:UpdateFrames()
                    end,
                    values = {
                        ["BloodElf"] = "BloodElf",
                        ["Draenei"] = "Draenei",
                        ["Dwarf"] = "Dwarf",
                        ["Gnome"] = "Gnome",
                        ["Goblin"] = "Goblin",
                        ["Human"] = "Human",
                        ["NightElf"] = "NightElf",
                        ["Orc"] = "Orc",
                        ["Pandaren"] = "Pandaren",
                        ["Undead"] = "Undead",
                        ["Tauren"] = "Tauren",
                        ["Troll"] = "Troll",
                        ["Worgen"] = "Worgen",
                    },
                },
                class = {
                    order = 2,
                    type = "select",
                    name = "Class",
                    desc = "Class of test unit",
                    get = function() return self.db.base.testUnits[unit].unitClass end,
                    set = function(info, value)
                        self.db.base.testUnits[unit].unitClass = value
                        self:UpdateFrames()
                    end,
                    values = {
                        ["WARRIOR"] = "Warrior",
                        ["DRUID"] = "Druid",
                        ["PALADIN"] = "Paladin",
                        ["PRIEST"] = "Priest",
                        ["WARLOCK"] = "Warlock",
                        ["MAGE"] = "Mage",
                        ["ROGUE"] = "Rogue",
                        ["SHAMAN"] = "Shaman",
                        ["DEATHKNIGHT"] = "Death Knight",
                        ["HUNTER"] = "Hunter",
                    },                   
                },
                spec = {
                    order = 3,
                    type = "select",
                    name = L["Spec"],
                    desc = L["Unit talent specialization"],
                    get = function() return self.db.base.testUnits[unit].specID end,
                    set = function(info, value)
                        self.db.base.testUnits[unit].specID = value
                        self:UpdateFrames()
                    end,
                    values = {
                        [250] = "Blood",         
                        [251] = "Frost",         
                        [252] = "Unholy",        
                        [577] = "Havoc",         
                        [581] = "Vengeance",    
                        [102] = "Balance",      
                        [103] = "Feral",         
                        [105] = "Restoration",   
                        [253] = "Beast Mastery", 
                        [254] = "Marksmanship",  
                        [255] = "Survival",      
                        [62]  = "Arcane",        
                        [63]  = "Fire",          
                        [64]  = "Frost",         
                        [65]  = "Holy",          
                        [66]  = "Protection",    
                        [70]  = "Retribution",   
                        [256] = "Discipline",   
                        [257] = "Holy",         
                        [258] = "Shadow",       
                        [259] = "Assassination",
                        [260] = "Combat",       
                        [261] = "Subtlety",     
                        [262] = "Elemental",    
                        [263] = "Enhancement", 
                        [264] = "Restoration",  
                        [265] = "Affliction",  
                        [266] = "Demonology", 
                        [267] = "Destruction", 
                        [71]  = "Arms",         
                        [72]  = "Fury",    
                        [73]  = "Protection"    
                    }
                },
                powerType = {
                    order = 4,
                    type = "select",
                    name = L["Power type"],
                    desc = L["Unit power type"],
                    get = function() return self.db.base.testUnits[unit].powerType end,
                    set = function(info, value)
                        self.db.base.testUnits[unit].powerType = value
                        self:UpdateFrames()
                    end,
                    values = {
                        [0] = MANA,
                        [1] = RAGE,
                        [2] = FOCUS,
                        [3] = ENERGY,
                        [4] = CHI,
                        [6] = RUNIC_POWER,
                    },
                },
            }
        }
        options.args.testing.args[unit] = test_frame
    end


    -- add groups
    options.args.arena = self:MakeGroupOptions("Arena", "arena1", 10)
    options.args.arena.args.copy = {
        type = "group",
        name = L["Copy settings"],
        desc = L["Copy settings"],
        inline = true,
        order = 1,
        args = {
            party_to_arena = {
                type = "execute",
                name = L["Copy from party"],
                desc = L["Copy all settings from party to arena"],
                func = function() self:CopyGroupSettings("arena", "party") end,
                order = 2,
            },
        }
    }
    options.args.arena.args.reset = {
        type = "group",
        name = L["Reset settings"],
        desc = L["Reset settings"],
        inline = true,
        order = 2,
        args = {
            arena_to_party = {
                type = "execute",
                name = L["Reset arena settings"],
                desc = L["Reset all arena settings to their default values"],
                func = function() self:ResetGroupSettings("arena") end,
                order = 1,
            },
        }
    }
    -- party
    options.args.party = self:MakeGroupOptions("Party", "player", 11)
    options.args.party.disabled = function() return not self.db.base.showParty end
    options.args.party.args.copy = {
        type = "group",
        name = L["Copy settings"],
        desc = L["Copy settings"],
        inline = true,
        order = 1,
        args = {
            arena_to_party = {
                type = "execute",
                name = L["Copy from arena"],
                desc = L["Copy all settings from arena to party"],
                func = function() self:CopyGroupSettings("party", "arena") end,
                order = 1,
            },
        }
    }
    options.args.party.args.reset = {
        type = "group",
        name = L["Reset settings"],
        desc = L["Reset settings"],
        inline = true,
        order = 2,
        args = {
            party_to_arena = {
                type = "execute",
                name = L["Reset party settings"],
                desc = L["Reset all party settings to their default values"],
                func = function() self:ResetGroupSettings("party") end,
                order = 2,
            },
        }
    }

    -- add profile options
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.dbi)

    -- add dual-spec support
    local LibDualSpec = LibStub("LibDualSpec-1.0")
    LibDualSpec:EnhanceDatabase(self.dbi, "GladiusEx")
    LibDualSpec:EnhanceOptions(options.args.profiles, self.dbi)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("GladiusEx", options)

    if not self.options then
        LibStub("AceConfigDialog-3.0"):SetDefaultSize("GladiusEx", 860, 550)
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GladiusEx", "GladiusEx")
    end

    self.options = options
end

function GladiusEx:ResetGroupSettings(group)
    self["dbi_" .. group]:ResetProfile()

    for name, mod in self:IterateModules() do
        mod["dbi_" .. group]:ResetProfile()
    end

    self:SetupOptions()
    self:EnableModules()
    self:UpdateFrames()
end

-- this may be completely unneccesary, but I want to make sure that I don't
-- overwrite some acedb metatable
local function copy_over_table(dst, src)
    if dst then
        wipe(dst)
    else
        dst = {}
    end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = copy_over_table(dst[k], v)
        else
            dst[k] = v
        end
    end
    return dst
end

local function copy_dbi(dst, src)
    for k, v in pairs(src.profile) do
        if type(v) == "table" then
            dst.profile[k] = copy_over_table(dst.profile[k], v)
        else
            dst.profile[k] = v
        end
    end
end

function GladiusEx:CopyGroupSettings(dst_group, src_group)
    copy_dbi(self["dbi_" .. dst_group], self["dbi_" .. src_group])

    for name, mod in self:IterateModules() do
        copy_dbi(mod["dbi_" .. dst_group], mod["dbi_" .. src_group])
    end

    self:SetupOptions()
    self:EnableModules()
    self:UpdateFrames()
end

function GladiusEx:CopyGroupModuleSettings(module, dst_group, src_group)
    copy_dbi(module["dbi_" .. dst_group], module["dbi_" .. src_group])

    self:SetupOptions()
    self:EnableModules()
    self:UpdateFrames()
end

function GladiusEx:ShowOptionsDialog()
    -- InterfaceOptionsFrame_OpenToCategory("GladiusEx")
    LibStub("AceConfigDialog-3.0"):Open("GladiusEx")
end

-- helper functions for simple position settings
function GladiusEx:GetGrowSimplePositions()
    return {
        ["LEFT"] = L["Left"],
        ["RIGHT"] = L["Right"],
        ["TOP"] = L["Top"],
        ["BOTTOM"] = L["Bottom"]
    }
end

function GladiusEx:GrowSimplePositionFromAnchor(anchor, relative, grow)
    for position in pairs(self:GetGrowSimplePositions()) do
        local panchor, prelative = self:AnchorFromGrowSimplePosition(position, grow)
        if panchor == anchor and prelative == relative then
            return position
        end
    end
end

function GladiusEx:AnchorFromGrowSimplePosition(position, grow)
    local grow_v = (strfind(grow, "UP") and "BOTTOM") or (strfind(grow, "DOWN") and "TOP") or ""
    local grow_h = (strfind(grow, "LEFT") and "RIGHT") or (strfind(grow, "RIGHT") and "LEFT") or ""

    local anchor, relative

    if position == "LEFT" then
        anchor = grow_v .. "RIGHT"
        relative = grow_v .. "LEFT"
    elseif position == "RIGHT" then
        anchor = grow_v .. "LEFT"
        relative = grow_v .. "RIGHT"
    elseif position == "TOP" then
        anchor = "BOTTOM" .. grow_h
        relative = "TOP" .. grow_h
    elseif position == "BOTTOM" then
        anchor = "TOP" .. grow_h
        relative = "BOTTOM" .. grow_h
    end

    return anchor, relative
end

function GladiusEx:AnchorFromGrowDirection(anchor, relative, grow, newgrow)
    local position = GladiusEx:GrowSimplePositionFromAnchor(anchor, relative, grow)
    if position then
        anchor, relative = GladiusEx:AnchorFromGrowSimplePosition(position, newgrow)
    end
    return anchor, relative
end


-- values for simple positioning without grow direction
local simple_pos = {
    ["TOPLEFT"] = L["Top left"],
    ["TOPRIGHT"] = L["Top right"],
    ["LEFTTOP"] = L["Left top"],
    ["LEFTBOTTOM"] = L["Left bottom"],
    ["RIGHTTOP"] = L["Right top"],
    ["RIGHTBOTTOM"] = L["Right bottom"],
    ["BOTTOMLEFT"] = L["Bottom left"],
    ["BOTTOMRIGHT"] = L["Bottom right"],
}

local pos_rel = {
    ["LEFTTOP"] = "TOPLEFT",
    ["LEFTBOTTOM"] = "BOTTOMLEFT",
    ["RIGHTTOP"] = "TOPRIGHT",
    ["RIGHTBOTTOM"] = "BOTTOMRIGHT",
}

local pos_anchor = {
    ["TOPLEFT"] = "BOTTOMLEFT",
    ["TOPRIGHT"] = "BOTTOMRIGHT",
    ["LEFTTOP"] = "TOPRIGHT",
    ["LEFTBOTTOM"] = "BOTTOMRIGHT",
    ["RIGHTTOP"] = "TOPLEFT",
    ["RIGHTBOTTOM"] = "BOTTOMLEFT",
    ["BOTTOMLEFT"] = "TOPLEFT",
    ["BOTTOMRIGHT"] = "TOPRIGHT",
}

function GladiusEx:GetSimplePositions()
    return simple_pos
end

function GladiusEx:SimplePositionToAnchor(pos)
    local anchor = pos_anchor[pos]
    local relative = pos_rel[pos] or pos
    return anchor, relative
end

function GladiusEx:AnchorToSimplePosition(anchor, relative)
    for pos in pairs(simple_pos) do
        local panchor, prelative = GladiusEx:SimplePositionToAnchor(pos)
        if panchor == anchor and prelative == relative then
            return pos
        end
    end
end
