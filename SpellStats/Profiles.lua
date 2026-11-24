local _, ns = ...
local readable = ns.SomethingNeedDoing.Values.Readable
local character, revision = nil, 0
local oldStats = {heal = "amount", damage = "amount", hpm = "perMana", dpm = "perMana"}
local profileLimit = 32

-- Seed Shared from the last SpellStats settings or the selected SpellInsight
-- profile. SND calls this only when the new profile database does not exist.
function ns.InitialProfile(fields)
    local old, source = SpellStatsDB
    if old ~= nil then
        if type(old) ~= "table" or (old.version ~= 1 and old.version ~= 2) then return nil, "readOnly" end
        source = old.values
    elseif SpellInsightDB ~= nil then
        old = SpellInsightDB
        if type(old) ~= "table" or old.version ~= 1 then return nil, "readOnly" end
        if type(old.profiles) == "table" and type(old.active) == "string" then source = old.profiles[old.active] end
    end
    if type(source) ~= "table" then return end

    local seed = {}
    for key, field in pairs(fields) do
        local value = source[key]
        if key == "topStat" or key == "bottomStat" then value = oldStats[value] or value end
        if field.type == "enum" then
            for _, allowed in ipairs(field.values) do
                if value == allowed then seed[key] = value; break end
            end
        elseif field.type == "integer" and type(value) == "number" and value >= field.min and value <= field.max
            and value == math.floor(value) then
            seed[key] = value
        elseif field.type == "font" and type(value) == "string" and #value > 0 and #value <= 256 then
            seed[key] = value
        end
    end
    return seed
end

local function knownName(name)
    return readable(name) and type(name) == "string" and name ~= "" and name ~= UNKNOWN and name ~= UNKNOWNOBJECT
        and not name:find("^%s") and not name:find("%s$") and not name:find("[%c|]")
end

local function identity()
    local name, realm = UnitFullName("player")
    if not knownName(name) or not readable(realm) then return end
    if not realm or realm == "" then realm = GetNormalizedRealmName() end
    if knownName(realm) and #name + #realm + 1 <= 255 then return name .. "-" .. realm end
end

function ns.InitializeProfiles(app)
    app:OnSettingsChanged(function(_, change) revision = change.revision end)
    app:OnReady(function()
        if not app.profiles:Capabilities().needsCharacter then return end
        local waiting = app:Scope("profile-identity")
        local attempts, lastError = 0, nil
        local function bind()
            local key = identity()
            if key then
                character = key
                local ok, err = app.profiles:BindCharacter(key)
                if ok then waiting:Cancel(); return end
                character = nil
                if lastError ~= err.message then
                    lastError = err.message
                    app.log:Warn("Could not bind character profile", {reason = err.message})
                end
            end
            if attempts < 5 then
                attempts = attempts + 1
                waiting:After(1, "bind", bind)
            end
        end
        local function listen(event, callback)
            local ok, err = waiting:Event(event, callback)
            if not ok then app.log:Warn("Could not watch " .. event, {reason = err.message}) end
        end
        listen("PLAYER_LOGIN", bind)
        listen("PLAYER_ENTERING_WORLD", bind)
        listen("PLAYER_REGEN_ENABLED", bind)
        listen("UNIT_NAME_UPDATE", function(unit)
            if readable(unit) and unit == "player" then bind() end
        end)
        bind()
    end)
end

local function copyName(names)
    local taken = {}
    for _, name in ipairs(names) do taken[name] = true end
    for index = 1, #names + 1 do
        local suffix = index == 1 and "" or (" " .. index)
        local length = math.min(#character, 48 - #suffix)
        -- SND limits profile names in bytes. Keep whole UTF-8 characters.
        while length < #character and character:byte(length + 1) >= 128 and character:byte(length + 1) < 192 do
            length = length - 1
        end
        local name = character:sub(1, length):gsub("%s+$", "") .. suffix
        if not taken[name] then return name end
    end
end

local function requireResult(ok, result)
    if not ok then error(result.message) end
    return result
end

function ns.CreateProfileSelector(parent, app, scope)
    local profiles = app.profiles
    local menu = requireResult(app.ui:Control(parent, "profile", "dropdown"))
    parent.spellStatsProfileSelector = menu
    menu:ClearAllPoints()
    menu:SetPoint("TOPLEFT")
    menu:SetHeight(26)
    menu:SetMotionScriptsWhileDisabled(true)
    menu.Text:ClearAllPoints()
    menu.Text:SetPoint("LEFT", menu, "LEFT", 10, 0)
    menu.Text:SetPoint("RIGHT", menu, "RIGHT", -25, 0)
    menu.Text:SetJustifyH("LEFT")
    menu.Text:SetWordWrap(false)
    requireResult(app.fonts:Apply(menu.Text, "control"))
    requireResult(app.ui:Color(menu.Text, "text"))
    local function hideTip()
        if GameTooltip and GameTooltip:GetOwner() == menu then GameTooltip:Hide() end
    end
    local function showTip()
        if not GameTooltip then return end
        local active = profiles:Active()
        local status = profiles:Capabilities()
        GameTooltip:SetOwner(menu, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profile · " .. active)
        if status.needsCharacter then
            GameTooltip:AddLine("Waiting for character and realm.")
        elseif status.readOnly then
            GameTooltip:AddLine("These saved settings are read-only.")
        else
            GameTooltip:AddLine("Characters using this profile", 1, .82, 0)
            GameTooltip:AddLine(table.concat(profiles:Characters(active), ", "), 1, 1, 1, true)
            if #profiles:List() >= profileLimit then GameTooltip:AddLine("All 32 profile slots are in use.") end
        end
        GameTooltip:Show()
    end
    requireResult(scope:HookScript(menu, "OnEnter", showTip))
    requireResult(scope:HookScript(menu, "OnLeave", hideTip))
    local currentRoot
    local choose = scope:Guard(function(root, shownRevision, method, name)
        if currentRoot ~= root or not menu:IsMenuOpen() or shownRevision ~= revision or profiles:Capabilities().readOnly then return end
        local ok, err = profiles[method](profiles, name)
        if not ok then print("SpellStats: " .. err.message) end
    end)
    local component = {}
    local function build(_, root)
        currentRoot = root
        local version = revision
        local names, active = profiles:List(), profiles:Active()
        root:SetScrollMode(240)
        for _, name in ipairs(names) do
            root:CreateRadio(name, function(value) return value == active end,
                function(value) choose(root, version, "Switch", value) end, name)
        end
        local members = profiles:Characters(active)
        if #names < profileLimit and character and (active == "Shared" or #members ~= 1 or members[1] ~= character) then
            root:CreateButton("Make a copy for this character", function()
                choose(root, version, "Duplicate", copyName(names))
            end)
        end
        requireResult(app.ui:StyleMenu(root))
        root:AddMenuReleasedCallback(function()
            if currentRoot == root then currentRoot = nil end
        end)
    end
    -- The native button regenerates the root on every OpenMenu.
    menu:SetupMenu(build)
    function component.Refresh()
        menu:Show()
        menu:OverrideText("Profile · " .. profiles:Active())
        menu:SetEnabled(not profiles:Capabilities().readOnly)
        if GameTooltip and GameTooltip:GetOwner() == menu then showTip() end
    end
    function component:Layout(width)
        menu:SetWidth(math.min(210, width))
        return 26
    end
    function component.Hide()
        if menu:IsMenuOpen() then menu:CloseMenu() end
        hideTip()
        menu:Hide()
    end
    return component
end
