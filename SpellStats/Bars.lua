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
local ellesmereModule, scanEllesmere, discoverEllesmere
local colors = {
    heal = {0.40, 1.00, 0.45},
    damage = {1.00, 0.70, 0.32},
    mana = {0.45, 0.82, 1.00},
}

local function spellFromMacro(slot, macroIndex)
    local getName = C_ActionBar and C_ActionBar.GetActionText or GetActionText
    if not (getName and GetMacroInfo and GetMacroItem and GetMacroSpell) then return end
    -- Some macro actions expose an index without a resolved subtype. Verify
    -- it against the button caption before asking the macro API for a spell.
    local name = getName(slot)
    local macroName = GetMacroInfo(macroIndex)
    if not values.Readable(name) or not values.Readable(macroName) then return end
    if type(name) ~= "string" or name == "" or macroName ~= name then return end
    local item = GetMacroItem(macroIndex)
    if not values.Readable(item) or item then return end
    return GetMacroSpell(macroIndex)
end

local function spellOnButton(record)
    local button = record.button
    local slot
    if record.ellesmere then
        -- The suffix identifies a permanent frame. Its secure action attribute
        -- follows the bar's page and can differ from the template's .action.
        slot = button:GetAttribute("action")
    else
        slot = button.action
    end
    if not values.Number(slot) or slot < 1 then return end
    local kind, id, subtype = GetActionInfo(slot)
    if not values.Readable(kind) or not values.Number(id) or id < 1 then return end
    -- For a spell macro, GetActionInfo already returns its currently resolved
    -- spell ID. Treating that number as a macro index breaks conditional macros.
    if kind == "macro" then
        if not values.Readable(subtype) then return end
        if subtype == nil then
            id = spellFromMacro(slot, id)
            if not values.Number(id) or id < 1 then return end
        elseif subtype ~= "spell" then
            return
        end
    elseif kind ~= "spell" then
        return
    end
    if C_Spell.GetOverrideSpell then
        local resolved = C_Spell.GetOverrideSpell(id)
        if not values.Readable(resolved) then return end
        if values.Number(resolved) and resolved > 0 then return resolved end
    end
    return id
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

local function newLine(owner)
    local text = owner:CreateFontString(nil, "OVERLAY")
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

local anchors = {
    LEFT = {justify = "LEFT", fraction = 0, x = 2, TOP = "TOPLEFT", BOTTOM = "BOTTOMLEFT"},
    CENTER = {justify = "CENTER", fraction = 0.5, x = 0, TOP = "TOP", BOTTOM = "BOTTOM"},
    RIGHT = {justify = "RIGHT", fraction = 1, x = -2, TOP = "TOPRIGHT", BOTTOM = "BOTTOMRIGHT"},
}

-- Reserve space only where the text actually lies. Blizzard gives its hotkey
-- a wide region, and EllesmereUI lets players move each caption independently.
local function clearance(caption, edge, boundary, rowHeight, rowLeft, rowRight)
    if not caption or not caption:IsShown() then return 2 end
    local alpha = caption:GetAlpha()
    if not values.Number(alpha) or alpha <= 0 then return 2 end
    local text = caption:GetText()
    if not values.Readable(text) or not text or text == "" then return 2 end
    local left, bottom, width, height = caption:GetRect()
    if not values.Number(left) or not values.Number(bottom) or
        not values.Number(width) or not values.Number(height) then return 2 end
    local ink = caption:GetStringWidth()
    if not values.Number(ink) or ink <= 0 then return 2 end
    ink = math.min(width, ink)
    local justification = caption:GetJustifyH()
    if not values.Readable(justification) then return 2 end
    if justification == "RIGHT" then
        left = left + width - ink
    elseif justification == "CENTER" then
        left = left + (width - ink) / 2
    end
    if rowRight <= left or rowLeft >= left + ink then return 2 end
    if edge == "TOP" and bottom < boundary and bottom + height > boundary - 2 - rowHeight then
        return boundary - bottom
    elseif edge == "BOTTOM" and bottom + height > boundary and bottom < boundary + 2 + rowHeight then
        return bottom + height - boundary
    end
    return 2
end

local function rowInset(button, line, edge, anchor, left, bottom, width, height)
    if not line.value or not left then return 2 end
    local textWidth, textHeight = line.text:GetStringWidth(), line.text:GetStringHeight()
    if not values.Number(textWidth) or not values.Number(textHeight) then return 2 end
    local rowLeft = left + (width - textWidth) * anchor.fraction + anchor.x
    local rowRight = rowLeft + textWidth
    local boundary = edge == "TOP" and bottom + height or bottom
    local inset = math.max(
        clearance(button.Name, edge, boundary, textHeight, rowLeft, rowRight),
        clearance(button.HotKey, edge, boundary, textHeight, rowLeft, rowRight),
        clearance(button.Count, edge, boundary, textHeight, rowLeft, rowRight))
    return math.max(2, math.min(inset, height - textHeight - 2)), rowLeft, rowRight, textHeight
end

local function placeLine(line, owner, edge, anchor, inset)
    if line.value and (line.anchor ~= anchor or line.inset ~= inset) then
        local point = anchor[edge]
        line.text:ClearAllPoints()
        line.text:SetPoint(point, owner, point, anchor.x, edge == "TOP" and -inset or inset)
        line.text:SetJustifyH(anchor.justify)
        line.anchor, line.inset = anchor, inset
    end
end

-- Each real or preview button keeps a record so settings changes move the
-- same FontStrings and share the same formatting and native font fallback.
function ns.PaintButtonStats(record, settings, estimate, maxMana)
    local top, topColor = statistic(settings.topStat, estimate, maxMana)
    local bottom, bottomColor = statistic(settings.bottomStat, estimate, maxMana)
    local button = record.button
    local owner = button.TextOverlayContainer or button
    if not record.top then
        if not top and not bottom then return end
        record.top = newLine(owner)
        record.bottom = newLine(owner)
    end
    paintLine(record.top, top, topColor, settings.topSize, settings.outline)
    paintLine(record.bottom, bottom, bottomColor, settings.bottomSize, settings.outline)
    if not top and not bottom then return end
    local topAnchor = anchors[settings.topAlign] or anchors.LEFT
    local bottomAnchor = anchors[settings.bottomAlign] or anchors.LEFT
    local left, base, width, height
    if button.Name or button.HotKey or button.Count then
        left, base, width, height = owner:GetRect()
        if not (values.Number(left) and values.Number(base) and values.Number(width) and values.Number(height)) then
            left = nil
        end
    end
    local topInset, topLeft, topRight, topHeight = rowInset(button, record.top, "TOP", topAnchor, left, base, width, height)
    local bottomInset, bottomLeft, bottomRight, bottomHeight = rowInset(button, record.bottom, "BOTTOM", bottomAnchor, left, base, width, height)
    if topLeft and bottomLeft and topRight > bottomLeft and bottomRight > topLeft then
        -- If both captions use this column, share the available vertical
        -- space before the two SpellStats lines would cross each other.
        local available = math.max(0, height - topHeight - bottomHeight - 4)
        local requested = topInset + bottomInset - 4
        if requested > available then
            topInset = 2 + math.floor((topInset - 2) * available / requested)
            bottomInset = 2 + available - (topInset - 2)
        end
    end
    placeLine(record.top, owner, "TOP", topAnchor, topInset)
    placeLine(record.bottom, owner, "BOTTOM", bottomAnchor, bottomInset)
end

local function refresh()
    refreshPending = false
    if scanEllesmere then
        scanEllesmere = false
        discoverEllesmere()
    end
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
            local id = spellOnButton(record)
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
        ns.PaintButtonStats(record, settings, estimate, maxMana)
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

local function actionChanged(_, attribute)
    if values.Readable(attribute) and attribute == "action" then queueRefresh() end
end

local function watchButton(button, ellesmere)
    if buttons[button] then return end
    buttons[button] = {button = button, ellesmere = ellesmere}
    local ok, err = scope:HookScript(button, "OnShow", queueRefresh)
    if not ok then app.log:Warn("Could not watch action button", {reason = err.message}) end
    if ellesmere then
        ok, err = scope:HookScript(button, "OnAttributeChanged", actionChanged)
        if not ok then app.log:Warn("Could not watch EllesmereUI button paging", {reason = err.message}) end
    end
end

-- EllesmereUI 9.9.2 names its ten bars' buttons by their original slot.
-- EABButton109..120 and EABButton145..180 live beyond the first six pages.
discoverEllesmere = function()
    for slot = 1, 180 do
        local button = _G["EABButton" .. slot]
        if button and button.GetAttribute then watchButton(button, true) end
    end
end

local function watchEllesmere()
    local modules = EllesmereUI and EllesmereUI._ModuleNS
    local module = modules and modules.EllesmereUIActionBars
    if module and module ~= ellesmereModule and type(module.BuildBarButtons) == "function" then
        -- The provider builds enabled bars after login and builds previously
        -- disabled bars on demand. Inspect frames after that construction pass.
        local ok, err = scope:PostHook(module, "BuildBarButtons", function()
            scanEllesmere = true
            queueRefresh()
        end)
        if ok then
            ellesmereModule = module
        else
            app.log:Warn("Could not watch EllesmereUI bar creation", {reason = err.message})
        end
    end
    scanEllesmere = true
end

local function discover()
    for _, name in ipairs(barNames) do
        local bar = _G[name]
        if bar and bar.actionButtons then
            for _, button in ipairs(bar.actionButtons) do
                watchButton(button, false)
            end
        end
    end
    watchEllesmere()
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
        "UPDATE_MOUSEOVER_UNIT", "UPDATE_BINDINGS", "SPELL_UPDATE_CHARGES",
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
        if name == "Blizzard_ActionBar" or name == "EllesmereUIActionBars" then discover() end
    end)
    listen("PLAYER_ENTERING_WORLD", discover)
    discover()
end
