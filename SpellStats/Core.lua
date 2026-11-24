local addon, ns = ...
local app = ns.SomethingNeedDoing:NewAddon(addon)
local scope = app:Scope("action-bars")
ns.App = app

app:Appearance({
    defaultTheme = "forever",
    themes = {forever = ns.SomethingNeedDoing.Themes.forever},
})

local stats = {
    {value = "amount", label = "Heal/Damage"},
    {value = "perMana", label = "HPM/DPM"},
    {value = "perSecond", label = "HPS/DPS"},
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

app:Settings({
    savedVariables = {"SpellStatsProfiles"},
    characterProfiles = true,
    initialProfile = ns.InitialProfile,
    fields = {
        topStat = enum("amount", stats),
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

ns.InitializeProfiles(app)

local function selectControl(key, label, choices)
    return {type = "select", id = key, key = key, label = label, choices = choices}
end

local function useUI(ok, value)
    if not ok then error(value.message) end
    return value
end

local formLayout = {
    columns = 2, minColumnWidth = 178, columnGap = 16,
    fieldWidth = 200, minLabelWidth = 80, gap = 8, rowGap = 6,
}

local function alignmentControl(line)
    local key = line .. "Align"
    return {type = "custom", id = key, create = function(parent, app, owner)
        -- SND reuses the host across opens. Keep the three buttons and their artwork
        -- with it, and bind clicks to the new component lifetime.
        local group = parent.spellStatsAlignment
        if not group then
            local label = parent:CreateFontString(nil, "OVERLAY")
            useUI(app.fonts:Apply(label, "control"))
            label:SetText("Alignment")
            label:SetJustifyH("LEFT")
            group = {label = label, field = CreateFrame("Frame", nil, parent), buttons = {}}
            for i, choice in ipairs(alignments) do
                local button = useUI(app.ui:Control(group.field, choice.value, "button"))
                local caption = button:CreateFontString(nil, "OVERLAY")
                useUI(app.fonts:Apply(caption, "control"))
                caption:SetText(choice.label)
                caption:SetPoint("CENTER")
                caption:SetWordWrap(true)
                local mark = button:CreateTexture(nil, "OVERLAY")
                mark:SetColorTexture(1, 1, 1, 1)
                useUI(app.ui:Color(mark, "accent"))
                mark:SetHeight(2)
                mark:SetPoint("BOTTOMLEFT", 3, 2)
                mark:SetPoint("BOTTOMRIGHT", -3, 2)
                group.buttons[i] = {button = button, caption = caption, mark = mark}
            end
            parent.spellStatsAlignment = group
        end

        for i, choice in ipairs(alignments) do
            local value = choice.value
            group.buttons[i].button:SetScript("OnClick", owner:Guard(function()
                if app:Get(line .. "Stat") == "none" then return end
                local ok, err = app:Set(key, value)
                if ok then ns.HighlightPreviewLine(line)
                else app.log:Warn("Alignment change failed", {code = err.code}) end
            end))
        end
        return {
            Refresh = function()
                local enabled = app:Get(line .. "Stat") ~= "none" and not app.profiles:Capabilities().readOnly
                useUI(app.ui:Color(group.label, enabled and "text" or "muted"))
                for i, item in ipairs(group.buttons) do
                    local selected = app:Get(key) == alignments[i].value
                    item.button:SetEnabled(enabled)
                    item.mark:SetShown(selected)
                    useUI(app.ui:Color(item.caption, selected and "accent" or "text"))
                end
            end,
            Layout = function(_, width)
                local gap = 3
                local buttonWidth = (math.min(width, formLayout.fieldWidth) - 2 * gap) / 3
                local height = 26
                for _, item in ipairs(group.buttons) do
                    item.caption:SetWidth(math.max(1, buttonWidth - 4))
                    height = math.max(height, item.caption:GetStringHeight() + 8)
                end
                for i, item in ipairs(group.buttons) do
                    item.button:ClearAllPoints()
                    item.button:SetPoint("TOPLEFT", group.field, "TOPLEFT", (i - 1) * (buttonWidth + gap), 0)
                    item.button:SetSize(buttonWidth, height)
                end
                group.field:SetHeight(height)
                return useUI(app.layout:Row(parent, {
                    width = width, label = group.label, control = group.field, layout = formLayout,
                }))
            end,
            Hide = function() parent:Hide() end,
        }
    end}
end

local lines = {}
for _, line in ipairs({"top", "bottom"}) do
    local name = line == "top" and "Top" or "Bottom"
    local stat, size = line .. "Stat", line .. "Size"
    lines[#lines + 1] = selectControl(stat, name .. " line", stats)
    lines[#lines + 1] = alignmentControl(line)
    lines[#lines + 1] = {type = "slider", id = size, key = size, label = name .. " text size",
        step = 1, editable = true, enabled = function(app) return app:Get(stat) ~= "none" end}
end

local options = app:Options({
    title = "SpellStats",
    width = 448,
    height = 456,
    header = {width = 46, create = ns.CreatePreview},
    subheader = {width = 210, create = ns.CreateProfileSelector},
    layout = formLayout,
    pages = {
        {id = "display", label = "Display", sections = {
            {flow = "column", controls = lines},
            {title = "Text style", controls = {
                {type = "font", key = "font", id = "font", label = "Font"},
                selectControl("outline", "Outline", outlines),
            }},
            {title = "Visibility", controls = {
                selectControl("spellFilter", "Spells", filters),
                selectControl("visibility", "When to show", visibility),
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
