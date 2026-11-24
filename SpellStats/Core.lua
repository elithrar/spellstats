local addon, ns = ...
local app = ns.SomethingNeedDoing:NewAddon(addon)
local scope = app:Scope("action-bars")
ns.App = app

local stats = {
    {value = "heal", label = "Median heal"},
    {value = "damage", label = "Median damage"},
    {value = "amount", label = "Median heal or damage"},
    {value = "hpm", label = "Healing per mana (HPM)"},
    {value = "dpm", label = "Damage per mana (DPM)"},
    {value = "manaPercent", label = "Mana cost (%)"},
    {value = "manaCost", label = "Mana cost"},
    {value = "none", label = "None"},
}
local filters = {
    {value = "heals", label = "Heals only"},
    {value = "all", label = "All spells"},
}
local visibility = {
    {value = "always", label = "Always"},
    {value = "combat", label = "In combat"},
    {value = "peace", label = "Out of combat"},
}
local outlines = {
    {value = "", label = "None"},
    {value = "OUTLINE", label = "Outline"},
    {value = "THICKOUTLINE", label = "Thick outline"},
}

local function enum(default, choices)
    local values = {}
    for index, choice in ipairs(choices) do
        values[index] = choice.value
    end
    return {type = "enum", default = default, values = values}
end

-- Normalize each restored field independently so an obsolete selection cannot
-- prevent the other action-bar preferences from loading.
local function restoredValue(field, value)
    if field.type == "enum" then
        for _, allowed in ipairs(field.values) do
            if value == allowed then return value end
        end
    elseif field.type == "integer" then
        if type(value) == "number" and value >= field.min and value <= field.max and value == math.floor(value) then
            return value
        end
    elseif field.type == "font" and type(value) == "string" and #value > 0 and #value <= 256 then
        return value
    end
    return field.default
end

local function settingsResult(values, readOnly)
    local result = {state = {values = values, readOnly = readOnly}}
    if not readOnly then
        result.saved = {SpellStatsDB = {version = 1, values = values}}
    end
    return result
end

local storage = {}
function storage:Restore(saved, fields)
    local current = saved.SpellStatsDB
    local source, readOnly
    if current ~= nil then
        readOnly = type(current) ~= "table" or current.version ~= 1
        if not readOnly then source = current.values end
    else
        -- WoW has restored the copied SpellInsight.lua file at this point.
        -- Read the active SND profile without changing the original database.
        local old = _G.SpellInsightDB
        if type(old) == "table" and old.version == 1 and type(old.profiles) == "table" and type(old.active) == "string" then
            source = old.profiles[old.active]
        end
    end
    local values = {}
    for key, field in pairs(fields) do
        values[key] = restoredValue(field, type(source) == "table" and source[key])
    end
    return true, settingsResult(values, readOnly)
end

function storage:Prepare(state, operation)
    -- SND provides an isolated state copy and validates each edit before here.
    local values = state.values
    if operation.kind == "set" then
        values[operation.path] = operation.value
    elseif operation.kind == "patch" then
        for key, value in pairs(operation.values) do values[key] = value end
    else
        return false, {code = "unsupported"}
    end
    return true, settingsResult(values, false)
end

app:Settings({
    savedVariables = {"SpellStatsDB"},
    adapter = storage,
    fields = {
        topStat = enum("heal", stats),
        bottomStat = enum("manaPercent", stats),
        spellFilter = enum("heals", filters),
        visibility = enum("always", visibility),
        outline = enum("OUTLINE", outlines),
        font = {type = "font", default = "Game tooltip"},
        topSize = {type = "integer", min = 8, max = 16, default = 12},
        bottomSize = {type = "integer", min = 8, max = 16, default = 11},
    },
})

local function selectControl(key, label, choices)
    return {type = "select", id = key, key = key, label = label, choices = choices}
end

local options = app:Options({
    title = "SpellStats",
    width = 490,
    height = 360,
    layout = {fieldWidth = 220, minLabelWidth = 140},
    pages = {
        {id = "display", label = "Display", sections = {
            {controls = {
                selectControl("topStat", "Top stat", stats),
                selectControl("bottomStat", "Bottom stat", stats),
                selectControl("spellFilter", "Spells", filters),
                selectControl("visibility", "Show stats", visibility),
                {type = "description", text = "Mana cost (%) is the share of your maximum mana spent on one cast."},
            }},
        }},
        {id = "appearance", label = "Appearance", sections = {
            {controls = {
                {type = "font", key = "font", id = "font", label = "Font"},
                selectControl("outline", "Text outline", outlines),
                {type = "slider", key = "topSize", id = "topSize", label = "Top font size", step = 1},
                {type = "slider", key = "bottomSize", id = "bottomSize", label = "Bottom font size", step = 1},
            }},
        }},
    },
})

local activeSettings
local started = false

function ns.GetSettings()
    return activeSettings
end

scope:Watch(app:SelectSettings(function(values) return values end), function(values)
    activeSettings = values
    if started then ns.RefreshBars() end
end)
scope:Watch(app:SelectAppearance(function(appearance) return appearance.fontRevision end), function()
    if started then ns.RefreshBars() end
end)
app:OnReady(function()
    ns.StartBars(app, scope)
    started = true
end)

local function openOptions(message)
    local command = message:lower():match("^%s*(.-)%s*$")
    if command == "" or command == "opts" or command == "options" then
        local opened, reason = options:Open()
        if not opened then print("SpellStats: " .. reason.message) end
    else
        print("SpellStats: /spellstats options")
    end
end
for _, command in ipairs({"/spellstats", "/spellinsight"}) do
    local ok, err = app:Slash(command, openOptions)
    if not ok then app.log:Warn("Slash command unavailable", {command = command, reason = err.message}) end
end
