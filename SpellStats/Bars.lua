local _, ns = ...
local values = ns.SomethingNeedDoing.Values

-- On Forever these eight bars own their secure buttons in actionButtons.
-- The native button updates .action when its active page or stance changes.
local barNames = {
    "MainActionBar", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight",
    "MultiBarLeft", "MultiBar5", "MultiBar6", "MultiBar7",
}
local app, scope
local buttons, estimates, variableCosts = {}, {}, {}
local refreshPending = false
local colors = {
    heal = {0.40, 1.00, 0.45},
    damage = {1.00, 0.70, 0.32},
    mana = {0.45, 0.82, 1.00},
}

local function spellOnButton(button)
    local slot = button.action
    if not values.Number(slot) or slot < 1 then return end
    local kind, id, subtype = GetActionInfo(slot)
    if not values.Readable(kind) or not values.Number(id) or id < 1 then return end
    -- For a spell macro, GetActionInfo already returns its currently resolved
    -- spell ID. Treating that number as a macro index breaks conditional macros.
    if kind ~= "spell" and not (kind == "macro" and values.Readable(subtype) and subtype == "spell") then
        return
    end
    local resolved = C_Spell.GetOverrideSpell(id)
    if values.Number(resolved) and resolved > 0 then return resolved end
end

local function decimal(value, precision)
    return string.format(precision, value):gsub("%.?0+$", "")
end

local function compact(value)
    if value >= 1000000 then return decimal(value / 1000000, "%.1f") .. "m" end
    if value >= 10000 then return decimal(value / 1000, "%.1f") .. "k" end
    return tostring(math.floor(value + 0.5))
end

local function statistic(stat, estimate, maxMana)
    if not estimate then return end
    if stat == "amount" then stat = estimate.heal and "heal" or "damage" end
    if stat == "heal" or stat == "damage" then
        if estimate[stat] then return compact(estimate[stat]), stat end
    elseif stat == "manaCost" and estimate.cost then
        return compact(estimate.cost), "mana"
    elseif stat == "manaPercent" and estimate.cost and maxMana and maxMana > 0 then
        return decimal(estimate.cost / maxMana * 100, "%.1f") .. "%", "mana"
    elseif stat == "hpm" or stat == "dpm" then
        local kind = stat == "hpm" and "heal" or "damage"
        if estimate[kind] and estimate.cost and estimate.cost > 0 then
            return decimal(estimate[kind] / estimate.cost, "%.2f"), kind
        end
    end
end

local function newLine(owner, position)
    local text = owner:CreateFontString(nil, "OVERLAY")
    text:SetPoint(position, owner, position, 2, position == "TOPLEFT" and -2 or 2)
    text:SetJustifyH("LEFT")
    text:SetShadowColor(0, 0, 0, 1)
    text:SetShadowOffset(1, -1)
    return {text = text}
end

local function paintLine(line, text, color, size, outline)
    if text then
        if line.size ~= size or line.outline ~= outline then
            local ok, err = app.fonts:Apply(line.text, "body", {size = size, flags = outline})
            if not ok then
                app.log:Warn("Could not set action button font", {reason = err.message})
                return
            end
            line.size, line.outline = size, outline
        end
        if line.color ~= color then
            local rgb = colors[color]
            line.text:SetTextColor(rgb[1], rgb[2], rgb[3])
            line.color = color
        end
    end
    if line.value ~= text then
        line.text:SetText(text or "")
        line.value = text
    end
end

local function paintButton(record, settings, estimate, maxMana)
    local top, topColor = statistic(settings.topStat, estimate, maxMana)
    local bottom, bottomColor = statistic(settings.bottomStat, estimate, maxMana)
    if not record.top then
        if not top and not bottom then return end
        local owner = record.button.TextOverlayContainer or record.button
        record.top = newLine(owner, "TOPLEFT")
        record.bottom = newLine(owner, "BOTTOMLEFT")
    end
    -- Macro names share the bottom edge of Blizzard's template. Leave the
    -- native label in place and lift our number when the caption is in use.
    if bottom then
        local caption = record.button.Name
        local offset = 2
        if caption and caption:IsShown() then
            local name = caption:GetText()
            if not values.Readable(name) or (name and name ~= "") then
                offset = offset + caption:GetHeight()
            end
        end
        if record.captionOffset ~= offset then
            local owner = record.button.TextOverlayContainer or record.button
            record.bottom.text:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", 2, offset)
            record.captionOffset = offset
        end
    end
    paintLine(record.top, top, topColor, settings.topSize, settings.outline)
    paintLine(record.bottom, bottom, bottomColor, settings.bottomSize, settings.outline)
end

local function refresh()
    refreshPending = false
    local settings = ns.GetSettings()
    local inCombat = InCombatLockdown()
    local visible = settings.visibility == "always" or
        (settings.visibility == "combat" and inCombat) or
        (settings.visibility == "peace" and not inCombat)
    local enabled = visible and (settings.topStat ~= "none" or settings.bottomStat ~= "none")
    local maxMana
    if enabled and (settings.topStat == "manaPercent" or settings.bottomStat == "manaPercent") then
        maxMana = ns.MaxMana()
    end
    local used, manaDependent = {}, {}
    for button, record in pairs(buttons) do
        local estimate
        if enabled and button:IsVisible() then
            local id = spellOnButton(button)
            if id then
                estimate = used[id]
                if estimate == nil then
                    estimate = estimates[id]
                    if estimate == nil then estimate = ns.Estimate(id) or false end
                    used[id] = estimate
                    local rank = ns.SpellData[id]
                    if rank and rank.allMana then manaDependent[id] = true end
                end
                if estimate and settings.spellFilter == "heals" and not estimate.isHeal then estimate = nil end
            end
        end
        paintButton(record, settings, estimate, maxMana)
    end
    estimates, variableCosts = used, manaDependent
end

local function queueRefresh()
    if not refreshPending then
        refreshPending = true
        local ok, err = scope:After(0, "button-refresh", refresh)
        if not ok then
            refreshPending = false
            app.log:Warn("Could not schedule action button refresh", {reason = err.message})
        end
    end
end

-- A gear/stat/tooltip change invalidates magnitudes. Page and macro changes can
-- reuse estimates for spells which remain on a visible button.
local function invalidate()
    estimates = {}
    queueRefresh()
end

function ns.RefreshBars()
    queueRefresh()
end

local function discover()
    for _, name in ipairs(barNames) do
        local bar = _G[name]
        if bar and bar.actionButtons then
            for _, button in ipairs(bar.actionButtons) do
                if not buttons[button] then
                    local ok, err = scope:HookScript(button, "OnShow", queueRefresh)
                    if not ok then app.log:Warn("Could not watch action button", {reason = err.message}) end
                    buttons[button] = {button = button}
                end
            end
        end
    end
    invalidate()
end

local function listen(event, callback)
    if C_EventUtils and not C_EventUtils.IsEventValid(event) then return end
    local ok, err = scope:Event(event, callback)
    if not ok then app.log:Warn("Could not watch " .. event, {reason = err.message}) end
end

function ns.StartBars(owner, ownerScope)
    app, scope = owner, ownerScope
    for _, event in ipairs({
        "ACTIONBAR_PAGE_CHANGED", "ACTIONBAR_SLOT_CHANGED", "ACTIONBAR_UPDATE_STATE", "UPDATE_BONUS_ACTIONBAR",
        "UPDATE_OVERRIDE_ACTIONBAR", "SPELL_UPDATE_ICON", "UPDATE_MACROS",
        "MODIFIER_STATE_CHANGED", "PLAYER_TARGET_CHANGED", "PLAYER_FOCUS_CHANGED",
        "UPDATE_MOUSEOVER_UNIT",
    }) do
        listen(event, queueRefresh)
    end
    for _, event in ipairs({
        "PLAYER_DAMAGE_DONE_MODS", "SPELL_POWER_CHANGED", "PLAYER_EQUIPMENT_CHANGED",
        "SPELLS_CHANGED", "PLAYER_LEVEL_UP", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED",
        "ENCOUNTER_START", "ENCOUNTER_END",
        "PLAYER_TALENT_UPDATE", "UPDATE_SHAPESHIFT_FORM", "ACTIVE_TALENT_GROUP_CHANGED",
    }) do
        listen(event, invalidate)
    end
    local function dataChanged(id)
        if values.Number(id) and estimates[id] ~= nil then
            estimates[id] = nil
            queueRefresh()
        end
    end
    listen("SPELL_TEXT_UPDATE", dataChanged)
    listen("SPELL_DATA_LOAD_RESULT", dataChanged)
    local function playerChanged(unit)
        if values.Readable(unit) and unit == "player" then invalidate() end
    end
    for _, event in ipairs({
        "UNIT_AURA", "UNIT_STATS", "UNIT_MAXPOWER", "UNIT_DAMAGE", "UNIT_RANGEDDAMAGE",
        "UNIT_ATTACK_POWER", "UNIT_RANGED_ATTACK_POWER", "UNIT_MAXHEALTH",
    }) do
        listen(event, playerChanged)
    end
    listen("UNIT_POWER_UPDATE", function(unit, powerType)
        if not next(variableCosts) or not values.Readable(unit) or not values.Readable(powerType) then return end
        if unit == "player" and powerType == "MANA" then
            for id in pairs(variableCosts) do estimates[id] = nil end
            queueRefresh()
        end
    end)
    listen("ADDON_LOADED", function(name)
        if name == "Blizzard_ActionBar" then discover() end
    end)
    listen("PLAYER_ENTERING_WORLD", discover)
    discover()
end
