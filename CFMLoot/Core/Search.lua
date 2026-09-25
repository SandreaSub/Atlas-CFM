---
--- Search.lua - Advanced item search functionality
---
--- This module provides comprehensive search functionality across items, spells, and enchantments
--- for Atlas-CFM. It enables users to quickly find specific items using various search criteria
--- including name patterns, item types, and source locations.
---
--- Features:
--- • Multi-criteria item searching
--- • Real-time search result filtering
--- • Integration with loot frame display
--- • Search history and suggestions
--- • Performance-optimized search algorithms
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}
AtlasCFM.SearchLib = AtlasCFM.SearchLib or {}

local L = AtlasCFM.Localization.UI

-- Cached global functions for performance
local GetItemInfo = GetItemInfo
local string_lower = string.lower
local string_find = string.find
local string_gsub = string.gsub
local string_sub = string.sub
local string_len = string.len
local type = type
local ipairs = ipairs
local pairs = pairs
local table_insert = table.insert
local table_getn = table.getn
local tostring = tostring

---
--- Shows search results in the loot frame
--- @return nil
--- @usage AtlasCFMLoot.Search.ShowResult()
---
function AtlasCFM.SearchLib.ShowResult()
    -- Reset scroll position
    FauxScrollFrame_SetOffset(AtlasCFMLootScrollBar, 0)
    AtlasCFMLootScrollBarScrollBar:SetValue(0)
    -- Set data for displaying search results
    AtlasCFMLootItemsFrame.StoredElement = "SearchResult"
    AtlasCFMLootItemsFrame.StoredMenu = nil
    AtlasCFMLootItemsFrame.activeElement = nil
    -- Update display
    AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
end

---
--- Trims whitespace from string
--- @param s string - String to trim
--- @return string - Trimmed string
--- @usage local trimmed = strtrim(" hello ")
---
local function strtrim(s)
    return (string_gsub(s, "^%s*(.-)%s*$", "%1"))
end
---
--- Main search function for items, spells, and enchantments
--- @param Text string - Search query text
--- @param callback function|nil - Optional callback to invoke after search and caching completes
--- @return nil
--- @usage AtlasCFM.SearchLib.Search("Thunderfury")
---
function AtlasCFM.SearchLib.Search(Text, callback)
    if not Text then return end
    Text = strtrim(Text)
    if Text == "" then return end

    AtlasCFMCharDB.SearchResult = {}
    AtlasCFMLoot_InvalidateCategorizedList("SearchResult")
    AtlasCFMCharDB.LastSearchedText = Text

    local partial = AtlasCFMCharDB.PartialMatching
    -- Note: DataIndex.FindItems handles string_len < 3 check internally if needed,
    -- but we can pass the preference.

    -- Use centralized DataIndex for search
    -- This avoids redundant calculations and uses the shared index
    if AtlasCFM.DataIndex and AtlasCFM.DataIndex.FindItems then
        local results = AtlasCFM.DataIndex.FindItems(Text, {
            partial = partial,
            types = { item = true, spell = true, enchant = true } -- explicit types to match legacy behavior (no quests)
        })
        AtlasCFMCharDB.SearchResult = results
    else
        -- Fallback if DataIndex is missing (should not happen)
        PrintA("Error: AtlasCFM.DataIndex.FindItems not found.")
    end

    AtlasCFMLoot_InvalidateCategorizedList("SearchResult")

    if table.getn(AtlasCFMCharDB.SearchResult) == 0 then
        PrintA(L["No match found for"] .. " \"" .. Text .. "\".")
        if callback then
            callback()
        else
            AtlasCFM.SearchLib.ShowResult()
        end
    else
        -- Display all results, scroll is handled by loot frame
        -- Ensure all results are cached so names and icons appear
        AtlasCFM.LootCache.CacheAllItems(AtlasCFMCharDB.SearchResult, function()
            if callback then
                callback()
            else
                AtlasCFM.SearchLib.ShowResult()
            end
        end)
    end
end

---
--- Shows search options dropdown menu
--- @param button table - Button frame to anchor the dropdown to
--- @return nil
--- @usage AtlasCFM.SearchLib.ShowOptions(someButton)
---
function AtlasCFM.SearchLib.ShowOptions(button)
    local Hewdrop = _G.ATWHewdrop
    if not Hewdrop then return end
    if Hewdrop:IsOpen(button) then
        Hewdrop:Close(1)
    else
        local setOptions = function()
            Hewdrop:AddLine(
                "text", L["Search options"],
                "isTitle", true,
                "notCheckable", true
            )
            Hewdrop:AddLine(
                "text", L["Partial matching"],
                "checked", AtlasCFMCharDB.PartialMatching,
                "tooltipTitle", L["Partial matching"],
                "tooltipText", L["If checked, AtlasCFMLoot searches item names for a partial match."],
                "func", function()
                    AtlasCFMCharDB.PartialMatching = not AtlasCFMCharDB.PartialMatching
                    Hewdrop:Refresh(1)
                end
            )
            Hewdrop:AddLine(
                "text", L["Predict search"],
                "checked", AtlasCFMCharDB.PredictSearch ~= false,
                "tooltipTitle", L["Predict search"],
                "tooltipText", L["If checked, AtlasCFMLoot predicts search results."],
                "func", function()
                    local enabled = AtlasCFMCharDB.PredictSearch ~= false
                    AtlasCFMCharDB.PredictSearch = not enabled
                    Hewdrop:Refresh(1)
                end
            )
        end
        Hewdrop:Open(button,
            'point', function(parent)
                return "BOTTOMLEFT", "BOTTOMRIGHT"
            end,
            "children", setOptions
        )
    end
end

---
--- Gets original data from search result by item ID
--- @param itemID number - The item ID to find data for
--- @param elementType string|nil - Optional type filter ("item", "spell", "enchant")
--- @return ... - Unpacked search result data (id, bossName, instanceKey, type, sourcePage)
--- @usage local id, boss, instance = AtlasCFM.SearchLib.GetOriginalDataFromSearchResult(12345)
---
function AtlasCFM.SearchLib.GetOriginalDataFromSearchResult(itemID, elementType)
    local fallback = nil
    for i, v in ipairs(AtlasCFMCharDB.SearchResult) do
        if v and v[1] == itemID then
            if elementType and v[4] == elementType then
                return unpack(v)
            end
            if not fallback then
                fallback = v
            end
        end
    end
    if fallback then
        return unpack(fallback)
    end
end
