-- Run from the SpellStats project root with texlua tests/bars.lua.
local events, timers, spells, measured = {}, {}, {}, {}
local inCombat = false
local secret = {}
local settings = {
    topStat = "heal", bottomStat = "manaPercent", spellFilter = "heals", visibility = "always",
    topSize = 12, bottomSize = 11, outline = "OUTLINE",
}
local maxMana = 2000
local totals = {
    [774] = {heal = 182.25, cost = 122, isHeal = true},
    [403] = {damage = 1950, cost = 300, isHeal = false},
    [100] = {damage = 0, cost = 0, isHeal = false},
}
local ns = {
    SomethingNeedDoing = {Values = {
        Number = function(n) return type(n) == "number" end,
        Readable = function(v) return v ~= secret end,
    }},
    SpellData = {[403] = {allMana = true}},
    GetSettings = function() return settings end,
    MaxMana = function() return maxMana end,
    Estimate = function(id)
        measured[id] = (measured[id] or 0) + 1
        return totals[id]
    end,
}
function InCombatLockdown() return inCombat end
function GetActionInfo(slot)
    local info = spells[slot] or {}
    return info[1], info[2], info[3]
end
C_Spell = {GetOverrideSpell = function(id) return id == 775 and 774 or id end}

local function newButton(slot)
    local owner = {labels = {}}
    function owner:CreateFontString()
        local text = {}
        function text:SetText(t) self.value = t end
        function text:SetPoint(at, _, _, x, y) self.at, self.x, self.y = at, x, y end
        function text:SetJustifyH() end
        function text:SetShadowColor() end
        function text:SetShadowOffset() end
        function text:SetTextColor(r, g, b) self.color = {r, g, b} end
        table.insert(self.labels, text)
        return text
    end
    return {action = slot, visible = true, TextOverlayContainer = owner,
        IsVisible = function(self) return self.visible end}
end

local app = {log = {Warn = function(_, message) error(message) end}, fonts = {
    Apply = function(_, text, role, opts)
        assert(role == "body")
        text.size, text.flags = opts.size, opts.flags
        return true
    end,
}}
local scope = {
    After = function(_, _, key, cb) assert(not timers[key]); timers[key] = cb; return true end,
    Event = function(_, event, cb) events[event] = cb; return true end,
    HookScript = function(_, button, event, cb) button[event] = cb; return true end,
    PostHook = function(_, module, name, cb)
        local original = assert(module[name], name)
        module[name] = function(...)
            original(...)
            cb(...)
        end
        return true
    end,
}
local function frame()
    local batch = timers
    timers = {}
    for _, cb in pairs(batch) do cb() end
end

local primary, second = newButton(1), newButton(26)
second.Name = {GetText = function() return "Heal" end, GetHeight = function() return 10 end,
    IsShown = function() return true end}
MainActionBar = {actionButtons = {primary}}
MultiBar7 = {actionButtons = {second}}
spells[1], spells[26] = {"spell", 775}, {"macro", 774, "spell"}
assert(loadfile("SpellStats/Bars.lua"))("SpellStats", ns)
ns.StartBars(app, scope)
events.PLAYER_ENTERING_WORLD()
frame()
local top, bottom = primary.TextOverlayContainer.labels[1], primary.TextOverlayContainer.labels[2]
local macroTop = second.TextOverlayContainer.labels[1]
assert(top.value == "182" and macroTop.value == "182" and bottom.value == "6.1%")
assert(top.at == "TOPLEFT" and bottom.at == "BOTTOMLEFT" and bottom.y == 2)
assert(second.TextOverlayContainer.labels[2].y == 12, "mana label clears the macro name")
assert(top.color[2] > top.color[1] and bottom.color[3] > bottom.color[2])
assert(measured[774] == 1, "duplicate spell and macro should share estimate")
assert(top.size == 12 and bottom.size == 11 and top.flags == "OUTLINE")

primary.action = 13
spells[13] = {"spell", 403}
events.ACTIONBAR_PAGE_CHANGED()
frame()
assert(top.value == "" and bottom.value == "", "heals-only removes old page text")
settings.spellFilter, settings.topStat, settings.bottomStat = "all", "amount", "dpm"
settings.topSize, settings.outline = 16, ""
ns.RefreshBars()
frame()
assert(top.value == "1950" and bottom.value == "6.5")
assert(top.size == 16 and top.flags == "" and macroTop.value == "182")

settings.visibility = "combat"
ns.RefreshBars()
frame()
assert(top.value == "")
inCombat = true
events.PLAYER_REGEN_DISABLED()
frame()
assert(top.value == "1950")
spells[26] = {"macro", 403, "spell"}
events.MODIFIER_STATE_CHANGED()
frame()
assert(macroTop.value == "1950")
spells[26] = {"macro", 403, "item"}
events.PLAYER_TARGET_CHANGED()
frame()
assert(macroTop.value == "", "numeric macro item ID is not a spell")

settings.topStat, settings.bottomStat = "hpm", "manaPercent"
spells[13] = {"spell", 774}
events.ACTIONBAR_SLOT_CHANGED(13)
frame()
assert(top.value == "1.49" and bottom.value == "6.1%")
maxMana = 1000
events.UNIT_MAXPOWER("player")
events.UNIT_AURA("player")
frame()
assert(bottom.value == "12.2%")
spells[13] = {"spell", 100}
settings.topStat = "dpm"
events.ACTIONBAR_SLOT_CHANGED(13)
frame()
assert(top.value == "" and bottom.value == "0%", "free cast must hide efficiency")

spells[13] = {"spell", 403}
totals[403].cost = 100
events.SPELL_TEXT_UPDATE(403)
events.ACTIONBAR_UPDATE_STATE()
frame()
assert(top.value == "19.5")
local previousHeals = measured[774]
totals[403].cost = 200
events.UNIT_POWER_UPDATE("target", "MANA")
assert(next(timers) == nil)
events.UNIT_POWER_UPDATE("player", "MANA")
frame()
assert(top.value == "9.75" and measured[774] == previousHeals)
totals[403].cost = 100
totals[403].damage = nil
events.ENCOUNTER_START()
frame()
assert(top.value == "")
totals[403].damage = 123
events.ENCOUNTER_END()
frame()
assert(top.value == "1.23", "after encounter, retry unavailable values")
settings.visibility, settings.topStat, settings.bottomStat = "peace", "damage", "none"
ns.RefreshBars()
frame()
assert(top.value == "")
inCombat = false
events.PLAYER_REGEN_ENABLED()
frame()
assert(top.value == "123" and bottom.value == "")
settings.topStat = "none"
ns.RefreshBars()
frame()
assert(top.value == "" and bottom.value == "")
settings.topStat = "manaCost"
primary.visible = false
ns.RefreshBars()
frame()
primary.visible = true
primary:OnShow()
frame()
assert(top.value == "100")
spells[13] = {"spell", secret}
events.ACTIONBAR_SLOT_CHANGED(13)
frame()
assert(top.value == "", "restricted spell ID clears old text")
assert(#primary.TextOverlayContainer.labels == 2 and #second.TextOverlayContainer.labels == 2)
assert(next(timers) == nil, "idle bars have no scheduled work")

-- EllesmereUIActionBars creates its own named buttons and retires the stock
-- bars. The suffix identifies the original slot. Its secure paging driver
-- writes the currently displayed slot into the button's "action" attribute.
local function ellesmereButton(currentSlot)
    local button = newButton(26) -- stale Blizzard mixin state after a page change
    button.currentSlot = currentSlot
    function button:GetAttribute(key)
        if key == "action" then return self.currentSlot end
    end
    return button
end
primary.visible, second.visible = false, false
settings.topStat, settings.bottomStat = "heal", "manaPercent"
settings.spellFilter, settings.visibility = "heals", "always"
maxMana = 2000
spells[1], spells[109] = {"spell", 403}, {"spell", 774}
EABButton1 = ellesmereButton(109)
EABButton109 = ellesmereButton(109)
local eabModule = {
    BuildBarButtons = function()
        EABButton180 = ellesmereButton(109)
    end,
}
EllesmereUI = {_ModuleNS = {EllesmereUIActionBars = eabModule}}
events.ADDON_LOADED("EllesmereUIActionBars")
frame()
local eabLines = EABButton1.TextOverlayContainer.labels
local customLines = EABButton109.TextOverlayContainer.labels
assert(eabLines[1] and eabLines[1].value == "182" and eabLines[2].value == "6.1%",
    "default heal and mana rows must appear on the visible Ellesmere button")
assert(customLines[1] and customLines[1].value == "182", "custom Ellesmere Bar10 also gets labels")
events.PLAYER_ENTERING_WORLD()
frame()

-- A custom modifier page can change the secure attribute in combat without
-- a native ACTIONBAR_PAGE_CHANGED. The original static bar remains on 109.
inCombat = true
EABButton1.currentSlot = 1
EABButton1:OnAttributeChanged("action", 1)
frame()
assert(eabLines[1].value == "" and eabLines[2].value == "",
    "heals-only clears both rows after Ellesmere pages to a damaging spell")
assert(customLines[1].value == "182")
EABButton1.currentSlot = 109
EABButton1:OnAttributeChanged("action", 109)
frame()
assert(eabLines[1].value == "182" and eabLines[2].value == "6.1%")
inCombat = false
eabModule.BuildBarButtons()
frame() -- coalesced provider discovery
frame() -- paint the discovered buttons
local lateLines = EABButton180.TextOverlayContainer.labels
assert(lateLines[1] and lateLines[1].value == "182" and lateLines[2].value == "6.1%",
    "opening a previously unbuilt Ellesmere bar after login must discover its buttons")
local override
C_Spell.GetOverrideSpell = function() return override end
events.ACTIONBAR_SLOT_CHANGED(109)
frame()
assert(eabLines[1].value == "182", "a missing override must preserve the original spell ID")
override = 0
events.ACTIONBAR_SLOT_CHANGED(109)
frame()
assert(eabLines[1].value == "182", "zero is not a usable override spell ID")
override = secret
events.ACTIONBAR_SLOT_CHANGED(109)
frame()
assert(eabLines[1].value == "" and eabLines[2].value == "",
    "clear restricted override results instead of displaying a possibly unrelated spell")

-- Some macro slots expose the macro index and omit the subtype. Resolve the
-- index only when its name matches the slot's label and it is a spell macro.
C_Spell.GetOverrideSpell = function(id) return id end
local macroName, actionName, macroItem = "Quick heal", "Quick heal", nil
C_ActionBar = {GetActionText = function(slot) if slot == 109 then return actionName end end}
function GetMacroInfo(index) if index == 7 then return macroName end end
function GetMacroSpell(index) if index == 7 then return 774 end end
function GetMacroItem(index) if index == 7 then return macroItem end end
spells[109] = {"macro", 7}
events.ACTIONBAR_SLOT_CHANGED(109)
frame()
assert(eabLines[1].value == "182", "resolve the active spell of a matching index-only macro")
macroItem = "Healing Potion"
events.UPDATE_MACROS()
frame()
assert(eabLines[1].value == "", "an item macro cannot be interpreted as a heal")
macroItem, actionName = nil, "Different macro"
events.UPDATE_MACROS()
frame()
assert(eabLines[1].value == "", "a macro index from a different slot cannot supply this spell")
actionName = secret
events.UPDATE_MACROS()
frame()
assert(eabLines[1].value == "", "restricted macro identity leaves the rows empty")
assert(#eabLines == 2 and #customLines == 2, "repeated displays must reuse the two labels")
assert(next(timers) == nil, "Ellesmere bars should also be idle after rendering")
print("Action button overlay checks passed.")
