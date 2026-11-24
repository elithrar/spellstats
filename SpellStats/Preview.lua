local _, ns = ...

-- Level-60 baseline casts with no bonus spell power and 5,000 maximum mana.
-- Renew includes five ticks; Fireball includes the hit and all four ticks.
local samples = {
    {name = "Holy Nova", rank = 6, icon = "Spell_Holy_HolyNova", detail = "Instant heal and damage",
        estimate = {heal = 311, damage = 187, cost = 750, seconds = 1.5}},
    {name = "Heal", rank = 4, icon = "Spell_Holy_Heal02", detail = "Direct heal",
        estimate = {heal = 673.5, cost = 305, seconds = 3}},
    {name = "Renew", rank = 10, icon = "Spell_Holy_Renew", detail = "Healing over 15 seconds",
        estimate = {heal = 830, cost = 410, seconds = 15}},
    {name = "Power Word: Shield", rank = 10, icon = "Spell_Holy_PowerWordShield", detail = "Instant shield, no talents",
        estimate = {heal = 928, absorb = 928, cost = 500, seconds = 1.5}},
    {name = "Fireball", rank = 12, icon = "Spell_Fire_FlameBolt", detail = "Direct damage and 8 seconds of burning",
        estimate = {damage = 543, cost = 410, seconds = 11.5}},
}
local activePreview

function ns.HighlightPreviewLine(line)
    if activePreview and (line == "top" or line == "bottom") then activePreview:Highlight(line) end
end

local function lineChanged(previous, current, line)
    return previous[line .. "Stat"] ~= current[line .. "Stat"]
        or previous[line .. "Size"] ~= current[line .. "Size"]
        or previous[line .. "Align"] ~= current[line .. "Align"]
end

function ns.CreatePreview(parent, app, scope)
    local preview = parent.spellStatsPreview
    if preview then
        preview.scope = scope
        return preview
    end

    local clip = CreateFrame("Frame", nil, parent)
    clip:SetAllPoints(parent)
    clip:SetClipsChildren(true)
    local button = CreateFrame("Button", nil, clip)
    button:SetAllPoints(clip)
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    local rim = button:CreateTexture(nil, "ARTWORK", nil, 1)
    rim:SetAllPoints(button)
    rim:SetAtlas("UI-HUD-ActionBar-IconFrame")
    local flash = button:CreateTexture(nil, "ARTWORK", nil, 2)
    flash:SetColorTexture(1, 0.79, 0.28, 0.38)
    flash:Hide()

    local selected = samples[1]
    local record = {button = button}
    local previousSettings, menu, currentRoot
    preview = {scope = scope}
    function preview:Highlight(line)
        if not self.scope or not self.scope.active then return end
        local edge = line == "top" and "TOP" or "BOTTOM"
        local inset = line == "top" and -2 or 2
        flash:ClearAllPoints()
        flash:SetPoint(edge .. "LEFT", button, edge .. "LEFT", 2, inset)
        flash:SetPoint(edge .. "RIGHT", button, edge .. "RIGHT", -2, inset)
        flash:SetHeight(math.max(1, math.min(button:GetHeight() / 2 - 2, ns.GetSettings()[line .. "Size"] + 4)))
        flash:Show()
        self.scope:After(0.65, "preview-line", function() flash:Hide() end)
    end
    function preview:Refresh()
        clip:Show()
        local settings = ns.GetSettings()
        ns.PaintButtonStats(record, settings, selected.estimate, 5000)
        if previousSettings and previousSettings ~= settings then
            local top = lineChanged(previousSettings, settings, "top")
            local bottom = lineChanged(previousSettings, settings, "bottom")
            if top ~= bottom then self:Highlight(top and "top" or "bottom") end
        end
        previousSettings = settings
        activePreview = self
    end
    function preview:Layout(width) return width end

    local function hideTooltip()
        if GameTooltip:GetOwner() == button then GameTooltip:Hide() end
    end
    function preview:Hide()
        if activePreview == self then activePreview = nil end
        previousSettings, currentRoot = nil, nil
        self.scope = nil
        if menu then menu:Close(); menu = nil end
        hideTooltip()
        flash:Hide()
        clip:Hide()
    end
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:AddLine(selected.name .. " preview", 1, 0.82, 0)
        GameTooltip:AddLine(selected.detail .. " (Rank " .. selected.rank .. ").")
        if selected.estimate.absorb then GameTooltip:AddLine("Healing stats count the full shield when it is applied.") end
        GameTooltip:AddLine("Level 60, 5,000 maximum mana, no bonus spell power.")
        GameTooltip:AddLine("Click to choose a preview spell.", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", hideTooltip)
    button:SetScript("OnHide", hideTooltip)
    button:SetScript("OnClick", function()
        hideTooltip()
        if menu then menu:Close(); return end
        menu = MenuUtil.CreateContextMenu(button, function(_, root)
            currentRoot = root
            root:AddMenuReleasedCallback(function()
                if currentRoot == root then menu, currentRoot = nil, nil end
            end)
            for _, sample in ipairs(samples) do
                root:CreateRadio(sample.name, function(choice) return selected == choice end, function(choice)
                    if currentRoot ~= root or activePreview ~= preview then return end
                    selected = choice
                    icon:SetTexture("Interface\\Icons\\" .. choice.icon)
                    preview:Refresh()
                end, sample)
            end
            app.ui:StyleMenu(root)
        end)
        if not menu then currentRoot = nil end
    end)
    icon:SetTexture("Interface\\Icons\\" .. selected.icon)
    parent.spellStatsPreview = preview
    return preview
end
