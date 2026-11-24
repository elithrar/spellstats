-- Run from the repository root or the extracted release with Lua 5.1+.
unpack = unpack or table.unpack
Enum = {PowerType = {Mana = 0}}
SlashCmdList = {}
local playerName
function UnitFullName(unit)
    assert(unit == "player")
    return playerName, "Realm"
end
function GetNormalizedRealmName() return "Realm" end
local installedVersion = "1.2.3-test"
C_AddOns = {GetAddOnMetadata = function(addon, key)
    assert(addon == "SpellStats" and key == "Version")
    return installedVersion
end}
function InCombatLockdown() return false end
function UnitLevel() return 60 end
function GetSpellBonusHealing() return 0 end
function GetSpellBonusDamage() return 0 end
function UnitHealthMax() return 2000 end
function UnitPowerMax() return 5000 end
function UnitAttackPower() return 0, 0, 0 end
UnitRangedAttackPower = UnitAttackPower
function UnitStat() return 0, 0 end
C_SpellBook = {IsSpellKnown = function() return false end}
local costs = {[27801] = 750, [6064] = 305, [25315] = 410, [25306] = 410}
C_Spell = {GetSpellPowerCost = function(id)
    return {{type = Enum.PowerType.Mana, cost = assert(costs[id])}}
end}

-- The options window stays closed. Only its sample button and the native
-- event frame need stand-ins; SND handles settings, restore and notifications.
local function noop() end
GameTooltip = {GetOwner = noop}
local menu
MenuUtil = {CreateContextMenu = function(owner, generate)
    local root = {choices = {}, AddMenuAcquiredCallback = noop, SetScrollMode = noop}
    function root:CreateRadio(name, selected, choose, value)
        self.choices[name] = {selected = selected, choose = choose, value = value,
            IsRadio = function() return true end, AddInitializer = noop}
        return self.choices[name]
    end
    function root:CreateButton(name, choose)
        self.choices[name] = {choose = choose, IsRadio = function() return false end}
        return self.choices[name]
    end
    function root:AddMenuReleasedCallback(release) self.release = release end
    generate(owner, root)
    menu = {root = root, Close = function() root.release(); menu = nil end}
    return menu
end}
function MenuUtil.TraverseMenu(root, visit)
    for _, choice in pairs(root.choices) do visit(choice) end
end
local frameMethods = {
    SetAllPoints = noop, SetClipsChildren = noop, EnableMouse = noop, RegisterForClicks = noop,
    Show = function(self) self.shown = true end, Hide = function(self) self.shown = false end,
    GetHeight = function() return 46 end,
    CreateTexture = function(self)
        self.textureCount = (self.textureCount or 0) + 1
        local texture = {SetAllPoints = noop, SetTexture = noop, SetAtlas = noop, SetColorTexture = noop,
            ClearAllPoints = noop, SetHeight = noop,
            SetPoint = function(region, point) region.point = point end,
            Hide = function(region) region.shown = false end, Show = function(region) region.shown = true end}
        self.textures[self.textureCount] = texture
        return texture
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
        ClearAllPoints = noop, SetJustifyH = noop, SetWordWrap = noop,
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
local eventFrame, previewButton
function CreateFrame(kind)
    local frame = setmetatable({scripts = {}, events = {}, textures = {}}, {__index = frameMethods})
    if not eventFrame then eventFrame = frame end
    if kind == "Button" then previewButton = frame end
    return frame
end

local function loadClient(saved, legacy, profiles, character)
    if eventFrame then eventFrame.scripts.OnEvent(eventFrame, "PLAYER_LOGOUT") end
    eventFrame = nil
    SpellStatsDB, SpellInsightDB, SpellStatsProfiles = saved, legacy, profiles
    playerName = character
    if character == nil then playerName = "Ada" end
    if character == false then playerName = nil end
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
    return ns, options
end
local function boot(...)
    local ns, options = loadClient(...)
    assert(ns.App:IsReady() and ns.GetSettings(), "restored settings must reach the consumer")
    for _, entry in ipairs(ns.App.log:Entries()) do assert(entry.level ~= "Error", entry.message) end
    return ns, options
end

local ns, options = boot()
local defaults = ns.GetSettings()
assert(defaults.topStat == "amount" and defaults.bottomStat == "manaPercent")
assert(defaults.spellFilter == "heals" and defaults.visibility == "always")
assert(ns.App.profiles:Active() == "Shared" and SpellStatsProfiles.version == 1)

local currentChoices = {
    {"amount", "Heal/Damage", "311"}, {"perMana", "HPM/DPM", "0.41"},
    {"perSecond", "HPS/DPS", "207.33"}, {"manaPercent", "Mana cost (% of max)", "15%"},
    {"manaCost", "Mana cost", "750"}, {"none", "None", ""},
}
assert(#options.pages == 1 and options.header.create == ns.CreatePreview
    and options.subheader.create == ns.CreateProfileSelector)
local firstSection = options.pages[1].sections[1]
assert(firstSection.flow == "column")
for i, id in ipairs({"topStat", "topAlign", "topSize", "bottomStat", "bottomAlign", "bottomSize"}) do
    assert(firstSection.controls[i].id == id, "each line keeps its controls together when stacked")
end
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

local preview, owner
for _, height in ipairs({10, 22}) do
    local shell = CreateFrame("Frame")
    shell.fontHeight = height
    local host = {GetParent = function() return shell end}
    labels = {}
    owner = ns.App:Scope()
    preview = ns.CreatePreview(host, ns.App, owner)
    local footer = assert(labels[1])
    assert(#labels == 1 and footer.text == installedVersion and footer.point == "BOTTOMRIGHT")
    local bottom = footer.y * footer.scale
    assert(footer.x < 0 and bottom > 0 and bottom + height * footer.scale <= 16,
        "the installed version must fit below the scroll area")
    assert((footer.scale == 1) == (height == 10), "only the taller font should shrink")
    assert(ns.CreatePreview(host, ns.App, owner) == preview and #labels == 1 and shell.textureCount == 1,
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
assert(ns.App:SetMany({topStat = "amount", bottomStat = "perSecond"}))
local sampleSpells = {{"Fireball", 25306}, {"Heal", 6064}, {"Renew", 25315}, {"Holy Nova", 27801}}
for _, sample in ipairs(sampleSpells) do
    previewButton.scripts.OnClick(previewButton)
    local choice = assert(menu.root.choices[sample[1]])
    choice.choose(choice.value)
    assert(choice.selected(choice.value), sample[1])
    menu:Close()
    ns.PaintButtonStats(realButton, ns.GetSettings(), ns.Estimate(sample[2], true), 5000)
    assert(labels[1].text == labels[3].text and labels[2].text == labels[4].text, sample[1])
end
previewButton.scripts.OnClick(previewButton)
local stale = menu.root.choices.Fireball
menu:Close()
stale.choose(stale.value)
assert(labels[1].text == "311", "a closed sample menu cannot change the preview")
assert(ns.App:Set("bottomStat", "none"))
assert(controls.topSize.enabled(ns.App) and not controls.bottomSize.enabled(ns.App))
preview:Refresh()
local flash = previewButton.textures[#previewButton.textures]
assert(flash.shown and flash.point == "BOTTOMRIGHT" and labels[2].text == "")
ns.HighlightPreviewLine("top")
assert(flash.shown and flash.point == "TOPRIGHT")
eventFrame.scripts.OnUpdate(eventFrame, 1)
assert(not flash.shown)
previewButton.scripts.OnClick(previewButton)
stale = menu.root.choices.Fireball
owner:Cancel()
preview:Hide()
stale.choose(stale.value)
assert(labels[1].text == "311")
assert(ns.App:Set("topStat", "none"))
assert(boot(nil, nil, SpellStatsProfiles).GetSettings().topStat == "none")

local oldChoices = {
    heal = "amount", damage = "amount", amount = "amount", hpm = "perMana", dpm = "perMana",
    manaPercent = "manaPercent", manaCost = "manaCost", none = "none",
}
for oldTop, newTop in pairs(oldChoices) do
    for oldBottom, newBottom in pairs(oldChoices) do
        local values = {topStat = oldTop, bottomStat = oldBottom, font = "Arial", topSize = 31,
            bottomSize = 9, visibility = "combat", spellFilter = "all", outline = "",
            topAlign = "CENTER", bottomAlign = "RIGHT"}
        local previous = {version = 1, values = values}
        local restored = boot(previous).GetSettings()
        assert(restored.topStat == newTop and restored.bottomStat == newBottom, oldTop .. "/" .. oldBottom)
        local shared = SpellStatsProfiles.profiles.Shared
        assert(shared.topStat == newTop and shared.bottomStat == newBottom)
        assert(SpellStatsDB == previous and values.topStat == oldTop and values.bottomStat == oldBottom)
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
ns = boot({version = 2, values = {topStat = "perMana", topSize = 28}})
ns = boot(nil, nil, SpellStatsProfiles, "Bob")
assert(ns.App.profiles:Active() == "Shared" and ns.GetSettings().topSize == 28)
assert(table.concat(ns.App.profiles:Characters("Shared"), ",") == "Ada-Realm,Bob-Realm")
ns = boot(nil, nil, SpellStatsProfiles, "Ada")

-- Drive the selector through the same generate/select/release protocol as a
-- native dropdown. SND owns the subscriptions and SpellStats owns the commands.
local dropdown = {
    Text = frameMethods:CreateFontString(), ClearAllPoints = noop, SetPoint = noop, SetHeight = noop,
    Show = noop, Hide = noop, HookScript = noop, SetMotionScriptsWhileDisabled = noop,
    OverrideText = function(self, caption) self.caption = caption end,
    SetupMenu = function(self, build) self.build = build end,
    IsMenuOpen = function() return menu ~= nil end,
    CloseMenu = function() menu:Close() end,
    SetEnabled = function(self, enabled) self.enabled = enabled end,
}
local selectorApp = {profiles = ns.App.profiles, fonts = ns.App.fonts, ui = {
    Control = function() return true, dropdown end, Color = ns.App.ui.Color, StyleMenu = ns.App.ui.StyleMenu,
}}
local selectorOwner = ns.App:Scope()
local selector = ns.CreateProfileSelector({}, selectorApp, selectorOwner)
local function openSelector()
    selector:Refresh()
    assert(dropdown.enabled)
    return MenuUtil.CreateContextMenu(dropdown, dropdown.build).root.choices
end
local rows = openSelector()
assert(dropdown.caption == "Profile · Shared" and rows.Shared.selected("Shared"))
local staleCopy = rows["Make a copy for this character"].choose
dropdown:CloseMenu()
staleCopy()
assert(ns.App.profiles:Active() == "Shared")
rows = openSelector()
rows["Make a copy for this character"].choose()
dropdown:CloseMenu()
assert(ns.App.profiles:Active() == "Ada-Realm")
assert(table.concat(ns.App.profiles:Characters("Shared"), ",") == "Bob-Realm")
assert(ns.GetSettings().topStat == "perMana" and ns.GetSettings().topSize == 28)
assert(ns.App:SetMany({topStat = "none", topSize = 10}))
rows = openSelector()
assert(dropdown.caption == "Profile · Ada-Realm" and rows.Shared)
selectorOwner:Cancel()
selector:Hide()
rows.Shared.choose("Shared")
assert(ns.App.profiles:Active() == "Ada-Realm")
ns = boot(nil, nil, SpellStatsProfiles, "Bob")
assert(ns.App.profiles:Active() == "Shared" and ns.GetSettings().topStat == "perMana")
assert(ns.App:Set("topSize", 16))
ns = boot(nil, nil, SpellStatsProfiles, "Ada")
assert(ns.App.profiles:Active() == "Ada-Realm" and ns.GetSettings().topSize == 10)
assert(ns.App.profiles:Switch("Shared") and ns.GetSettings().topSize == 16)
assert(ns.App.profiles:Switch("Ada-Realm") and ns.GetSettings().topStat == "none")
local future = {version = 99, values = {topStat = "future"}}
ns = boot(future, legacy)
local ok, reason = ns.App:Set("topStat", "none")
assert(not ok and reason.code == "readOnly" and SpellStatsDB == future and future.values.topStat == "future")
assert(ns.GetSettings().topStat == "amount" and ns.GetSettings().bottomStat == "manaPercent")
ns = boot(nil, nil, future)
ok, reason = ns.App:Set("topStat", "none")
assert(not ok and reason.code == "readOnly" and SpellStatsProfiles == future)
local malformed = {version = 1, profiles = {Shared = {}}, characters = {["Ada-Realm"] = "Missing"}}
ns = loadClient(nil, nil, malformed)
assert(not ns.App:IsReady() and SpellStatsProfiles == malformed)
ns = boot({version = 2, values = {bottomStat = "perMana"}}, nil, nil, false)
assert(ns.App.profiles:Capabilities().needsCharacter and not SpellStatsProfiles)
ok, reason = ns.App:Set("bottomStat", "none")
assert(not ok and reason.code == "readOnly")
playerName = "Clara"
eventFrame.scripts.OnEvent(eventFrame, "UNIT_NAME_UPDATE", "target")
assert(ns.App.profiles:Capabilities().needsCharacter)
eventFrame.scripts.OnEvent(eventFrame, "PLAYER_LOGIN")
assert(not ns.App.profiles:Capabilities().needsCharacter and ns.App.profiles:Active() == "Shared")
assert(SpellStatsProfiles.characters["Clara-Realm"] == "Shared" and ns.GetSettings().bottomStat == "perMana")
playerName = "Other"
eventFrame.scripts.OnEvent(eventFrame, "UNIT_NAME_UPDATE", "player")
assert(SpellStatsProfiles.characters["Other-Realm"] == nil, "late identity events cannot rebind a live session")
print("SpellStats profile, migration, settings and preview checks passed.")
