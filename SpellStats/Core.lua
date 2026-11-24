local addon, ns = ...
local app = ns.SomethingNeedDoing:NewAddon(addon)
local scope = app:Scope("action-bars")
ns.App = app

app:Appearance({
    defaultTheme = "forever",
    themes = {forever = ns.SomethingNeedDoing.Themes.forever},
})

local stats = {
    {value = "heal", label = "Median heal"},
    {value = "damage", label = "Median damage"},
    {value = "amount", label = "Median heal or damage"},
    {value = "hpm", label = "Healing per mana (HPM)"},
    {value = "dpm", label = "Damage per mana (DPM)"},
    {value = "manaPercent", label = "Mana cost (% of max)"},
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
local alignments = {
    {value = "LEFT", label = "Left"},
    {value = "CENTER", label = "Center"},
    {value = "RIGHT", label = "Right"},
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
        topAlign = enum("LEFT", alignments),
        bottomAlign = enum("LEFT", alignments),
        topSize = {type = "integer", min = 1, max = 64, default = 12},
        bottomSize = {type = "integer", min = 1, max = 64, default = 11},
    },
})

local function selectControl(key, label, choices)
    return {type = "select", id = key, key = key, label = label, choices = choices}
end

-- Unmodified Holy Nova rank 6 at level 60. It heals and deals damage, so
-- every statistic can be previewed using the same cast on any character.
local example = {isHeal = true, heal = 311, damage = 187, cost = 750}
local function createPreview(parent)
    if parent.spellStatsPreview then return parent.spellStatsPreview end

    local clip = CreateFrame("Frame", nil, parent)
    clip:SetAllPoints(parent)
    clip:SetClipsChildren(true)
    local button = CreateFrame("Frame", nil, clip)
    button:SetAllPoints(clip)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    icon:SetTexture("Interface\\Icons\\Spell_Holy_HolyNova")
    local rim = button:CreateTexture(nil, "ARTWORK", nil, 1)
    rim:SetAllPoints(button)
    rim:SetAtlas("UI-HUD-ActionBar-IconFrame")
    button:EnableMouse(true)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Holy Nova preview", 1, 0.82, 0)
        GameTooltip:AddLine("Rank 6 with 5,000 maximum mana.")
        GameTooltip:Show()
    end)
    local function hideTooltip(self)
        if GameTooltip:GetOwner() == self then GameTooltip:Hide() end
    end
    button:SetScript("OnLeave", hideTooltip)
    button:SetScript("OnHide", hideTooltip)

    local record = {button = button}
    parent.spellStatsPreview = {
        Refresh = function()
            clip:Show()
            ns.PaintButtonStats(record, ns.GetSettings(), example, 5000)
        end,
        Layout = function(_, width) return width end,
        Hide = function() clip:Hide() end,
    }
    return parent.spellStatsPreview
end

local options = app:Options({
    title = "SpellStats",
    width = 448,
    height = 438,
    header = {width = 46, create = createPreview},
    layout = {
        columns = 2, minColumnWidth = 178, columnGap = 16,
        fieldWidth = 200, minLabelWidth = 80, gap = 8, rowGap = 6,
    },
    pages = {
        {id = "display", label = "Display", sections = {
            {title = "Action buttons", controls = {
                selectControl("topStat", "Top stat", stats),
                selectControl("bottomStat", "Bottom stat", stats),
                selectControl("spellFilter", "Spells", filters),
                selectControl("visibility", "When to show", visibility),
            }},
            {title = "Text style", controls = {
                {type = "font", key = "font", id = "font", label = "Font"},
                selectControl("outline", "Outline", outlines),
                selectControl("topAlign", "Top alignment", alignments),
                selectControl("bottomAlign", "Bottom alignment", alignments),
                {type = "slider", key = "topSize", id = "topSize", label = "Top size", step = 1, editable = true},
                {type = "slider", key = "bottomSize", id = "bottomSize", label = "Bottom size", step = 1, editable = true},
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
