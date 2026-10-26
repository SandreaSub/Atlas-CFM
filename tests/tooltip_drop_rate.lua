-- Run from the repository root with Lua 5.1: lua tests/tooltip_drop_rate.lua
local function noop() end
function CreateFrame(_, name)
    local frame = { scripts = {}, lines = {} }
    function frame:SetScript(event, fn) self.scripts[event] = fn end
    function frame:GetScript(event) return self.scripts[event] end
    function frame:SetOwner() end
    function frame:RegisterEvent() end
    function frame:UnregisterAllEvents() end
    function frame:ClearLines() self.lines = {} end
    function frame:SetHyperlink() self.lines = {} end
    function frame:AddLine(text) table.insert(self.lines, text) end
    function frame:Show() end
    function frame:GetName() return name end
    return frame
end
GetLocale = function() return "deDE" end -- Addon text remains English.
GetItemInfo = function(id) if id == 900001 then return "Rune Band of Wizardry" end end
getglobal = function(key) return _G[key] end
IsShiftKeyDown = function() return false end
IsControlKeyDown = IsShiftKeyDown
IsAddOnLoaded = IsShiftKeyDown
SetTooltipMoney = noop
SetItemRef = function() ItemRefTooltip:ClearLines() end
GameTooltip = CreateFrame("GameTooltip", "GameTooltip")
ItemRefTooltip = CreateFrame("GameTooltip", "ItemRefTooltip")
AtlasCFM = { Colors = setmetatable({}, {__index = function() return "" end}) }
dofile("Locales/LocalizationFramework.lua")
dofile("Locales/enUS/Core.lua")
assert(AtlasCFM.Localization.currentLocale == "enUS")
for _, namespace in pairs(AtlasCFM.Localization.namespaces) do
    assert(namespace.enUS == namespace.current, "English tables must share storage")
end
assert(AtlasCFM.Localization.UI["Show Drop Rate on Tooltips"] == "Show Drop Rate on Tooltips")
AtlasCFM.Server = {
    GetDataField = function(entry, key) return type(entry) == "table" and entry[key] or nil end,
    VANILLA_PLUS = "Vanilla Plus", NOT_VANILLA_PLUS = "!Vanilla Plus",
    TURTLE = "Turtle", TURTLE1 = "Turtle1"
}
AtlasCFM.LootUtils = { GetLootTableSource = noop }
AtlasCFMLoot_Data = {}
dofile("CFMLoot/Core/ItemDB.lua")
dofile("CFMLoot/Data/Instances/BlackrockSpireUpper.lua")
-- Known, missing, zero, fractional and nested-container rates, plus a second
-- source for the same item: its rate must not overwrite the selected source.
local bosses = AtlasCFM.InstanceData.BlackrockSpireUpper.Bosses
table.insert(bosses, {name = "Test Boss", items = {
    {id = 900002, dropRate = 0.05}, {id = 900003}, {id = 900004, dropRate = 0},
    {id = 900005, dropRate = 100, container = {900006}}
}})
table.insert(bosses, {name = "Other Boss", items = {{id = 22339, dropRate = 99}}})
AtlasCFMOptions = {LootShowSource = true, TooltipShowDropRate = true, ReagentRows = 0}
local pending = {}
AtlasCFM.Timer = {Start = function(_, fn) table.insert(pending, fn) end}
dofile("CFMLoot/Core/DataIndex.lua")
dofile("CFMLoot/Core/Tooltip.lua")
GameTooltip:SetHyperlink("item:22339")
assert(table.getn(GameTooltip.lines) == 0, "Index is still loading")
while table.getn(pending) > 0 do table.remove(pending, 1)() end
local source = "Upper Blackrock Spire - Lord Valthalak"
local function hover(id, expected)
    GameTooltip:SetHyperlink("item:" .. id)
    assert(GameTooltip.lines[1] == expected,
        tostring(GameTooltip.lines[1]) .. " ~= " .. tostring(expected))
end
hover(22339, source .. " (25%)|r")
AtlasCFMOptions.TooltipShowDropRate = false
hover(22339, source .. "|r")
AtlasCFMOptions.TooltipShowDropRate = true
hover(22339, source .. " (25%)|r")
AtlasCFMOptions.LootShowSource = false
hover(22339, nil)
AtlasCFMOptions.LootShowSource = true
hover(900002, "Upper Blackrock Spire - Test Boss (0.05%)|r")
hover(900003, "Upper Blackrock Spire - Test Boss|r")
hover(900004, "Upper Blackrock Spire - Test Boss (0%)|r")
hover(900006, "Upper Blackrock Spire - Test Boss|r")
hover(999999, nil)
AtlasCFM.DataIndex.NameToID["Rune Band of Wizardry"] = 22339
hover(900001, source .. " (25%)|r")
SetItemRef("item:22339", "", "LeftButton")
assert(ItemRefTooltip.lines[1] == source .. " (25%)|r")
-- Also exercise the synchronous index path used by explicit callers.
dofile("CFMLoot/Core/DataIndex.lua")
AtlasCFM.DataIndex.BuildIndex(false)
assert(AtlasCFM.DataIndex.DropRateCache[22339] == 25)
assert(AtlasCFM.DataIndex.DropRateCache[900006] == nil)
-- Existing saved options gain the default while a saved false stays false.
StaticPopupDialogs = {}
dofile("CFMAtlas/AtlasOptions.lua")
AtlasCFMOptions.TooltipShowDropRate = nil
AtlasCFM.EnsureSavedOptions()
assert(AtlasCFMOptions.TooltipShowDropRate == true)
AtlasCFM.OptionsInit = noop
AtlasCFM.OptionTooltipDropRateOnClick()
assert(AtlasCFMOptions.TooltipShowDropRate == false)
AtlasCFM.SyncOptionsBackup()
AtlasCFM.EnsureSavedOptions()
assert(AtlasCFMOptions.TooltipShowDropRate == false)
AtlasCFM.Quest = {}
dofile("Locales/enUS/QuestData.lua")
assert(next(AtlasCFM.Quest.DataBase), "English quests must load on every client locale")
print("PASS: source rates, toggle, startup, aliases, chat links, sync/async indexing, English storage")
