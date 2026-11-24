-- Run from the repository root or the extracted release with Lua 5.1+.
unpack = unpack or table.unpack
Enum = {PowerType = {Mana = 0}}
SlashCmdList = {}
local installedVersion = "1.2.3-test"
C_AddOns = {GetAddOnMetadata = function(addon, key)
    assert(addon == "SpellStats" and key == "Version")
    return installedVersion
end}
function InCombatLockdown() return false end
function UnitLevel() return 60 end
function GetSpellBonusHealing() return 0 end
function GetSpellBonusDamage() return 0 end
C_Spell = {GetSpellPowerCost = function(id)
    assert(id == 27801)
    return {{type = Enum.PowerType.Mana, cost = 750}}
end}

-- The options window stays closed. Only its sample button and the native
-- event frame need stand-ins; SND handles settings, restore and notifications.
local function noop() end
local frameMethods = {
    SetAllPoints = noop, SetClipsChildren = noop, EnableMouse = noop, Show = noop,
    CreateTexture = function(self)
        self.textureCount = (self.textureCount or 0) + 1
        return {SetPoint = noop, SetAllPoints = noop, SetTexture = noop, SetAtlas = noop, SetColorTexture = noop}
    end,
    SetScript = function(self, name, fn) self.scripts[name] = fn end,
    RegisterEvent = function(self, event) self.events[event] = true end,
    IsEventRegistered = function(self, event) return self.events[event] end,
    UnregisterEvent = function(self, event) self.events[event] = nil end,
    UnregisterAllEvents = function(self) self.events = {} end,
}
local labels = {}
function frameMethods:CreateFontString()
    local label = {
        SetShadowColor = noop, SetShadowOffset = noop, SetTextColor = noop,
        ClearAllPoints = noop, SetJustifyH = noop,
        SetPoint = function(self, point, _, _, x, y) self.point, self.x, self.y = point, x, y end,
        SetScale = function(self, scale) self.scale = scale end,
        GetStringHeight = function() return self.fontHeight or 10 end,
        SetText = function(self, text) self.text = text end,
        SetFont = function(self, path, size, flags) self.path, self.size, self.flags = path, size, flags end,
        GetFont = function(self) return self.path, self.size, self.flags end,
    }
    labels[#labels + 1] = label
    return label
end
local eventFrame
function CreateFrame()
    local frame = setmetatable({scripts = {}, events = {}}, {__index = frameMethods})
    if not eventFrame then eventFrame = frame end
    return frame
end

local function boot(saved, legacy)
    if eventFrame then eventFrame.scripts.OnEvent(eventFrame, "PLAYER_LOGOUT") end
    eventFrame = nil
    SpellStatsDB, SpellInsightDB = saved, legacy
    local ns, options = {}, nil
    for line in io.lines("SpellStats/SpellStats.toc") do
        if line == "Core.lua" then
            -- Observe the public declaration while still registering the real panel.
            local newAddon = ns.SomethingNeedDoing.NewAddon
            function ns.SomethingNeedDoing:NewAddon(...)
                local app = newAddon(self, ...)
                local declare = app.Options
                function app:Options(spec)
                    options = spec
                    return declare(self, spec)
                end
                return app
            end
        end
        if line:match("%.lua$") then assert(loadfile("SpellStats/" .. line))("SpellStats", ns) end
    end
    eventFrame.scripts.OnEvent(eventFrame, "ADDON_LOADED", "SpellStats")
    assert(ns.App:IsReady() and ns.GetSettings(), "restored settings must reach the consumer")
    for _, entry in ipairs(ns.App.log:Entries()) do assert(entry.level ~= "Error", entry.message) end
    return ns, options
end

local ns, options = boot()
local defaults = ns.GetSettings()
assert(defaults.topStat == "amount" and defaults.bottomStat == "manaPercent")
assert(defaults.spellFilter == "heals" and defaults.visibility == "always")
assert(SpellStatsDB.version == 2)

local currentChoices = {
    {"amount", "Heal/Damage", "311"}, {"perMana", "HPM/DPM", "0.41"},
    {"perSecond", "HPS/DPS", "207.33"}, {"manaPercent", "Mana cost (% of max)", "15%"},
    {"manaCost", "Mana cost", "750"}, {"none", "None", ""},
}
local controls = {}
for _, page in ipairs(options.pages) do
    for _, section in ipairs(page.sections) do
        for _, control in ipairs(section.controls) do
            if control.key then controls[control.key] = control end
        end
    end
end
for _, key in ipairs({"topStat", "bottomStat"}) do
    local menu = assert(controls[key])
    assert(menu.type == "select" and #menu.choices == #currentChoices)
    for i, choice in ipairs(currentChoices) do
        assert(menu.choices[i].value == choice[1] and menu.choices[i].label == choice[2], key)
    end
end
assert(controls.topSize.label == "Top text size" and controls.bottomSize.label == "Bottom text size")

local preview
for _, height in ipairs({10, 22}) do
    local shell = CreateFrame("Frame")
    shell.fontHeight = height
    local host = {GetParent = function() return shell end}
    labels = {}
    preview = options.header.create(host)
    local footer = assert(labels[1])
    assert(#labels == 1 and footer.text == installedVersion and footer.point == "BOTTOMRIGHT")
    local bottom = footer.y * footer.scale
    assert(footer.x < 0 and bottom > 0 and bottom + height * footer.scale <= 16,
        "the installed version must fit below the scroll area")
    assert((footer.scale == 1) == (height == 10), "only the taller font should shrink")
    assert(options.header.create(host) == preview and #labels == 1 and shell.textureCount == 1,
        "reopening must reuse both the version label and its backing")
end
labels = {} -- collect only the two preview and two action-button rows below
local realButton = {button = CreateFrame("Frame")}
local estimate = ns.Estimate(27801, true) -- Holy Nova rank 6 at level 60
for i, top in ipairs(currentChoices) do
    local bottom = currentChoices[#currentChoices - i + 1]
    assert(ns.App:SetMany({topStat = top[1], bottomStat = bottom[1]}))
    preview:Refresh()
    ns.PaintButtonStats(realButton, ns.GetSettings(), estimate, 5000)
    assert(#labels == 4 and (labels[1].text or "") == top[3] and (labels[2].text or "") == bottom[3],
        "Holy Nova preview differs for " .. top[1] .. " and " .. bottom[1])
    assert(labels[1].text == labels[3].text and labels[2].text == labels[4].text,
        "preview must agree with an action button showing the same Holy Nova")
end
assert(boot(SpellStatsDB).GetSettings().topStat == "none")

local oldChoices = {
    heal = "amount", damage = "amount", amount = "amount", hpm = "perMana", dpm = "perMana",
    manaPercent = "manaPercent", manaCost = "manaCost", none = "none",
}
for oldTop, newTop in pairs(oldChoices) do
    for oldBottom, newBottom in pairs(oldChoices) do
        local values = {topStat = oldTop, bottomStat = oldBottom, font = "Arial", topSize = 31,
            bottomSize = 9, visibility = "combat", spellFilter = "all", outline = "",
            topAlign = "CENTER", bottomAlign = "RIGHT"}
        local restored = boot({version = 1, values = values}).GetSettings()
        assert(restored.topStat == newTop and restored.bottomStat == newBottom, oldTop .. "/" .. oldBottom)
        assert(SpellStatsDB.version == 2 and SpellStatsDB.values.topStat == newTop and SpellStatsDB.values.bottomStat == newBottom)
        for key, value in pairs(values) do
            if key ~= "topStat" and key ~= "bottomStat" then assert(restored[key] == value, key) end
        end
    end
end

local legacy = {version = 1, active = "Holy", profiles = {Holy = {topStat = "dpm", bottomStat = "damage"}}}
local imported = boot(nil, legacy).GetSettings()
assert(imported.topStat == "perMana" and imported.bottomStat == "amount")
assert(legacy.profiles.Holy.topStat == "dpm" and legacy.profiles.Holy.bottomStat == "damage")
local restored = boot({version = 2, values = {topStat = "bad", bottomStat = "perSecond"}}, legacy).GetSettings()
assert(restored.topStat == "amount" and restored.bottomStat == "perSecond")
local future = {version = 99, values = {topStat = "future"}}
ns = boot(future, legacy)
local ok, reason = ns.App:Set("topStat", "none")
assert(not ok and reason.code == "readOnly" and SpellStatsDB == future and future.values.topStat == "future")
assert(ns.GetSettings().topStat == "amount" and ns.GetSettings().bottomStat == "manaPercent")
print("SpellStats settings, migration and Holy Nova preview checks passed.")
