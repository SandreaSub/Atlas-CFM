---
--- DataIndex.lua - Centralized indexing and caching for Atlas-CFM
---
--- This module unifies the caching logic from Tooltip.lua and ProfessionHooks.lua
--- into a single efficient indexing system. It iterates over loot data once
--- and populates caches for item sources, skill levels, and name-to-id mappings.
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}
AtlasCFM.DataIndex = AtlasCFM.DataIndex or {}

local DataIndex = AtlasCFM.DataIndex
local L = AtlasCFM.Localization.UI
local Colors = AtlasCFM.Colors or {}

-- Caches
DataIndex.SourceCache = {}   -- itemID -> sourceString
DataIndex.LocationCache = {} -- itemID -> list of { type, page, boss, inst, displayName }
DataIndex.SkillCache = {}    -- name -> skillString (e.g. "<1/50/100/150>")
DataIndex.NameToID = {}      -- name -> itemID
DataIndex.SpellID = {}       -- spellID -> sourceString

-- State
DataIndex.isIndexed = false
DataIndex.isIndexing = false
DataIndex.callbacks = {}

-- Scanner for name resolution
local scanner = CreateFrame("GameTooltip", "AtlasCFMDataIndexScanner", nil, "GameTooltipTemplate")
scanner:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Helper: Format skill levels
local function FormatSkillLevels(skillTable)
    if not skillTable or type(skillTable) ~= "table" then return "" end
    local O = Colors.ORANGE or "|cffFF8000"
    local Y = Colors.YELLOW or "|cffFFFF00"
    local G = Colors.GREEN or "|cff00FF00"
    local Gr = Colors.GREY or "|cff808080"
    local W = "|r"

    local s1 = (skillTable[1] and (O .. skillTable[1] .. W)) or "?"
    local s2 = (skillTable[2] and (Y .. skillTable[2] .. W)) or "?"
    local s3 = (skillTable[3] and (G .. skillTable[3] .. W)) or "?"
    local s4 = (skillTable[4] and (Gr .. skillTable[4] .. W)) or "?"

    return "<" .. s1 .. "/" .. s2 .. "/" .. s3 .. "/" .. s4 .. ">"
end

-- Helper: Get Names from ID (returns list of potential names)
-- Consolidated from ProfessionHooks.lua
function DataIndex.GetNamesFromID(id)
    if not id then return {} end
    local names = {}
    local seen = {}

    local function addName(n)
        if n and n ~= "" and not seen[n] then
            table.insert(names, n)
            seen[n] = true
        end
    end

    -- 1. Check SpellDB
    if AtlasCFM.SpellDB then
        local function checkDB(db)
            if db and db[id] then
                local name = AtlasCFM.Server.GetDataField(db[id], "name")
                if name then
                    addName(name)
                    -- Strip prefix like "Smelting: " to match GetCraftInfo
                    local _, _, stripped = string.find(name, ":%s*(.+)$")
                    if stripped then addName(stripped) end
                end
                -- Do not touch the item cache while the startup index is running.
                -- SpellDB already contains the craft/enchant name used for skill
                -- matching; forcing result-item hyperlinks here can race the
                -- client/server item cache during login. Result item names are
                -- resolved later, on demand, by the loot cache/browser.
            end
        end

        checkDB(AtlasCFM.SpellDB.enchants)
        checkDB(AtlasCFM.SpellDB.craftspells)
    end

    -- 2. Tooltip Scan (Spell)
    scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
    scanner:ClearLines()
    if scanner.SetHyperlink then
        if pcall(scanner.SetHyperlink, scanner, "spell:" .. id) then
            local textObj = _G["AtlasCFMDataIndexScannerTextLeft1"]
            if textObj then
                local text = textObj:GetText()
                if text then
                    addName(text)
                    -- Try to strip Rank if present (e.g. "Instant Poison Rank 1" -> "Instant Poison")
                    -- This helps matching with TradeSkill names which often omit rank
                    local pattern = L["Rank Pattern"] or " %a+ %d+$"
                    local noRank = string.gsub(text, pattern, "") -- Basic " Rank N" matching
                    if noRank ~= text then addName(noRank) end
                end
            end
        end
    end

    return names
end

-- Public API: Register callback for updates
function DataIndex.RegisterCallback(func)
    table.insert(DataIndex.callbacks, func)
end

-- Internal: Notify callbacks
local function NotifyCallbacks()
    for _, func in ipairs(DataIndex.callbacks) do
        pcall(func)
    end
end

-- Internal: Helper for Tooltip indexing (recursive list processing)
local itemToSetMap = {} -- Temporary map for set categories

local function mapItems(data, setName)
    if type(data) ~= "table" then return end
    local n = table.getn(data)
    for i = 1, n do
        local item = data[i]
        if type(item) == "table" then
            local id = item.id or item[1]
            if id and itemToSetMap[id] == nil then
                itemToSetMap[id] = setName
            end
            if item.container then mapItems(item.container, setName) end
        elseif type(item) == "number" then
            if itemToSetMap[item] == nil then
                itemToSetMap[item] = setName
            end
        end
    end
end

local function indexQuests(questList, instanceName)
    if not questList then return end
    for _, quest in pairs(questList) do
        if quest.Rewards then
            for _, reward in pairs(quest.Rewards) do
                local rID = type(reward) == "table" and reward.id or reward
                if rID then
                    local questTitle = quest.Title or "?"
                    local source = (instanceName ~= "" and instanceName .. " " or "") ..
                        (L["Quest"] or "Quest") .. ": " .. questTitle
                    if DataIndex.SourceCache[rID] == nil then
                        DataIndex.SourceCache[rID] = source
                    end

                    -- Populate LocationCache
                    if not DataIndex.LocationCache[rID] then DataIndex.LocationCache[rID] = {} end
                    local cache = DataIndex.LocationCache[rID]
                    local exists = false
                    for _, loc in ipairs(cache) do
                        if loc.displayName == source and loc.type == "quest" then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        table.insert(cache, {
                            type = "quest",
                            page = "Quest",
                            boss = "Quest",
                            inst = instanceName,
                            displayName = source
                        })
                    end
                end
            end
        end
    end
end

-- Build a direct spellID -> profession page lookup in one pass.
-- The old startup path searched every profession page for every SpellDB entry,
-- which is O(spells * pages * page_items) and causes a large login hitch on 1.12.
local function BuildProfessionLookup(profPages)
    local lookup = {}

    local function indexPageList(list, pageKey, profName)
        if type(list) ~= "table" then return end
        local n = table.getn(list)
        for i = 1, n do
            local el = list[i]
            local id = type(el) == "table" and (el.id or el[1]) or el
            local visible = type(el) ~= "table" or not AtlasCFM.Server or not AtlasCFM.Server.IsVisible or AtlasCFM.Server.IsVisible(el)
            local isKnownSpell = type(id) == "number" and type(el) == "table" and el.skill ~= nil and AtlasCFM.SpellDB and
                ((AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id]) or
                 (AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id]))
            if visible and isKnownSpell and not lookup[id] then
                lookup[id] = { pageKey = pageKey, name = profName }
            end
            if visible and type(el) == "table" and el.container then
                indexPageList(el.container, pageKey, profName)
            end
        end
    end

    for _, profEntry in ipairs(profPages) do
        local pageKey = profEntry.pageKey
        local page = AtlasCFMLoot_Data and AtlasCFMLoot_Data[pageKey]
        if page then
            indexPageList(page, pageKey, profEntry.name)
        end
    end

    return lookup
end

local function indexProfItems(spellList, profLookup, typeName)
    if not spellList then return end
    for spellID, data in pairs(spellList) do
        local foundPageKey = nil
        local foundProfName = nil
        local profEntry = profLookup and profLookup[spellID]

        if profEntry then
            foundPageKey = profEntry.pageKey
            foundProfName = profEntry.name
            DataIndex.SpellID[spellID] = foundProfName
        end

        local itemID = AtlasCFM.Server.GetDataField(data, "item")
        if itemID then
            if DataIndex.SourceCache[itemID] == nil then
                DataIndex.SourceCache[itemID] = DataIndex.SpellID[spellID]
            end
        end

        -- Populate LocationCache
        if foundPageKey then
            -- For the spell itself
            local spellKey = "s" .. spellID
            if not DataIndex.LocationCache[spellKey] then DataIndex.LocationCache[spellKey] = {} end
            local cache = DataIndex.LocationCache[spellKey]
            local exists = false
            for _, loc in ipairs(cache) do
                if loc.page == foundPageKey and loc.type == typeName then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(cache, {
                    type = typeName,
                    page = foundPageKey,
                    boss = nil,
                    inst = nil,
                    displayName = foundProfName
                })
            end

            -- For the created item
            local itemID = AtlasCFM.Server.GetDataField(data, "item")
            if itemID then
                if not DataIndex.LocationCache[itemID] then DataIndex.LocationCache[itemID] = {} end
                local iCache = DataIndex.LocationCache[itemID]
                local iExists = false
                for _, loc in ipairs(iCache) do
                    if loc.page == foundPageKey and loc.type == "item" then
                        iExists = true
                        break
                    end
                end
                if not iExists then
                    table.insert(iCache, {
                        type = "item",
                        page = foundPageKey,
                        boss = nil,
                        inst = nil,
                        displayName = foundProfName
                    })
                end
            end
        end
    end
end


-- Gentle asynchronous version of profession indexing.
-- Processes only a few spell records per timer tick so large SpellDB tables
-- cannot monopolize a frame on the 1.12 client.
local function indexProfItemsAsync(spellList, profLookup, typeName, done)
    if not spellList then
        if done then done() end
        return
    end

    local cursor = nil
    local BATCH_SIZE = 8

    local function ProcessOneSpell(spellID, data)
        local foundPageKey = nil
        local foundProfName = nil
        local profEntry = profLookup and profLookup[spellID]

        if profEntry then
            foundPageKey = profEntry.pageKey
            foundProfName = profEntry.name
            DataIndex.SpellID[spellID] = foundProfName
        end

        local itemID = AtlasCFM.Server.GetDataField(data, "item")
        if itemID and DataIndex.SourceCache[itemID] == nil then
            DataIndex.SourceCache[itemID] = DataIndex.SpellID[spellID]
        end

        if foundPageKey then
            local spellKey = "s" .. spellID
            if not DataIndex.LocationCache[spellKey] then DataIndex.LocationCache[spellKey] = {} end
            local cache = DataIndex.LocationCache[spellKey]
            local exists = false
            for _, loc in ipairs(cache) do
                if loc.page == foundPageKey and loc.type == typeName then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(cache, {
                    type = typeName,
                    page = foundPageKey,
                    boss = nil,
                    inst = nil,
                    displayName = foundProfName
                })
            end

            if itemID then
                if not DataIndex.LocationCache[itemID] then DataIndex.LocationCache[itemID] = {} end
                local iCache = DataIndex.LocationCache[itemID]
                local iExists = false
                for _, loc in ipairs(iCache) do
                    if loc.page == foundPageKey and loc.type == "item" then
                        iExists = true
                        break
                    end
                end
                if not iExists then
                    table.insert(iCache, {
                        type = "item",
                        page = foundPageKey,
                        boss = nil,
                        inst = nil,
                        displayName = foundProfName
                    })
                end
            end
        end
    end

    local function RunBatch()
        local count = 0
        while count < BATCH_SIZE do
            local spellID, data = next(spellList, cursor)
            if spellID == nil then
                if done then done() end
                return
            end
            cursor = spellID
            ProcessOneSpell(spellID, data)
            count = count + 1
        end
        AtlasCFM.Timer.Start(0.05, RunBatch)
    end

    AtlasCFM.Timer.Start(0.05, RunBatch)
end

local function IndexList(list, source, locationInfo)
    if not list then return end
    for i = 1, table.getn(list) do
        local el = list[i]
        local id = type(el) == "table" and (el.id or el[1]) or el

        if id and type(id) == "number" then
            -- Determine type and cache key
            local el_type = AtlasCFM.Server.GetDataField(el, "type")
            local el_skill = AtlasCFM.Server.GetDataField(el, "skill")

            local actualType = locationInfo.type or "item"
            if locationInfo.forceType then
                actualType = locationInfo.forceType
            elseif el_type == "item" then
                actualType = "item"
            elseif el_skill then
                actualType = "spell"
                if AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] then
                    actualType = "enchant"
                end
            elseif actualType ~= "item" and AtlasCFM.SpellDB then
                -- Fallback for simple number entries in lists that aren't primarily items
                if AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] then
                    actualType = "enchant"
                elseif AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id] then
                    actualType = "spell"
                end
            end

            local cacheKey = id
            if actualType == "spell" or actualType == "enchant" then
                cacheKey = "s" .. id
            end

            -- Name mapping must remain passive during startup indexing.
            -- Use only names already present in the static data; never call
            -- GetItemInfo here because uncached item lookups can initiate cache
            -- work while the cooperative index is still running.
            if actualType == "item" and type(el) == "table" and el.name then
                DataIndex.NameToID[el.name] = id
            end

            -- Source mapping
            if source then
                local itemSource = source
                if itemToSetMap[id] then
                    if not string.find(itemSource, itemToSetMap[id], 1, true) then
                        itemSource = itemSource .. " (" .. itemToSetMap[id] .. ")"
                    end
                end
                if not DataIndex.SourceCache[cacheKey] then DataIndex.SourceCache[cacheKey] = itemSource end

                -- Also index the created item if this ID is a spell (e.g. Poisons, some Crafts)
                if (actualType == "spell" or actualType == "enchant") and AtlasCFM.SpellDB then
                    local createdItem
                    if AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id] then
                        createdItem = AtlasCFM.Server.GetDataField(AtlasCFM.SpellDB.craftspells[id], "item")
                    elseif AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] then
                        createdItem = AtlasCFM.Server.GetDataField(AtlasCFM.SpellDB.enchants[id], "item")
                    end

                    if createdItem and type(createdItem) == "number" then
                        if not DataIndex.SourceCache[createdItem] then DataIndex.SourceCache[createdItem] = itemSource end
                    end
                end
            end

            -- Location mapping
            if locationInfo then
                if not DataIndex.LocationCache[cacheKey] then DataIndex.LocationCache[cacheKey] = {} end
                local cache = DataIndex.LocationCache[cacheKey]

                local exists = false
                for _, loc in ipairs(cache) do
                    if loc.page == locationInfo.page and loc.boss == locationInfo.boss and loc.inst == locationInfo.inst then
                        exists = true
                        break
                    end
                end
                if not exists then
                    local entry = {
                        page = locationInfo.page,
                        boss = locationInfo.boss,
                        inst = locationInfo.inst,
                        displayName = locationInfo.displayName,
                        type = actualType
                    }
                    table.insert(cache, entry)
                end

                -- Also index the created item if this ID is a spell
                if (actualType == "spell" or actualType == "enchant") and AtlasCFM.SpellDB then
                    local createdItem
                    if AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id] then
                        createdItem = AtlasCFM.Server.GetDataField(AtlasCFM.SpellDB.craftspells[id], "item")
                    elseif AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] then
                        createdItem = AtlasCFM.Server.GetDataField(AtlasCFM.SpellDB.enchants[id], "item")
                    end

                    if createdItem and type(createdItem) == "number" then
                        if not DataIndex.LocationCache[createdItem] then DataIndex.LocationCache[createdItem] = {} end
                        local cCache = DataIndex.LocationCache[createdItem]
                        local cExists = false
                        for _, loc in ipairs(cCache) do
                            if loc.page == locationInfo.page and loc.boss == locationInfo.boss and loc.inst == locationInfo.inst then
                                cExists = true
                                break
                            end
                        end
                        if not cExists then
                            local cLoc = {
                                page = locationInfo.page,
                                boss = locationInfo.boss,
                                inst = locationInfo.inst,
                                type = "item",
                                displayName = locationInfo.displayName
                            }
                            table.insert(cCache, cLoc)
                        end
                    end
                end
            end

            -- Skill Level Processing (from ProfessionHooks)
            if type(el) == "table" and el.skill then
                -- This item has skill requirements. Resolve name and cache it.
                -- Note: This might be slow if we do it for every item synchronously.
                -- We should queue it or do it here if fast.
                -- Since we are in an incremental loop, we can try to do it here.
                -- But resolving names might require tooltip scanning which is slow.
                -- Let's check if we have the name in SpellDB first.

                local names = DataIndex.GetNamesFromID(el.id)
                local skillText = FormatSkillLevels(el.skill)

                for _, name in ipairs(names) do
                    DataIndex.SkillCache[name] = skillText
                end
            end
        end

        -- Recurse into containers
        if type(el) == "table" and el.container then
            local containerLoc = {}
            if locationInfo then
                for k, v in pairs(locationInfo) do containerLoc[k] = v end
            end
            containerLoc.forceType = "item"
            IndexList(el.container, source, containerLoc)
        end
    end
end

-- Main Indexing Function
function DataIndex.BuildIndex(incremental)
    if DataIndex.isIndexed or DataIndex.isIndexing then return end

    DataIndex.isIndexing = true

    local function FinalizeIndexing()
        DataIndex.isIndexed = true
        DataIndex.isIndexing = false
        itemToSetMap = {} -- Clear temporary map
        NotifyCallbacks()
    end

    -- Step-by-step processing
    local steps = {}

    -- Step 1: Quests
    table.insert(steps, function()
        if AtlasCFM.Quest and AtlasCFM.Quest.DataBase then
            for _, instanceData in pairs(AtlasCFM.Quest.DataBase) do
                local instanceName = instanceData.Caption
                if type(instanceName) == "table" then instanceName = instanceName[1] end
                indexQuests(instanceData.Alliance, instanceName)
                indexQuests(instanceData.Horde, instanceName)
            end
        end
    end)

    -- Step 2: Sets
    table.insert(steps, function()
        if AtlasCFM.MenuData and AtlasCFM.MenuData.Sets then
            for _, setCat in ipairs(AtlasCFM.MenuData.Sets) do
                if setCat.lootpage then
                    local _, _, shortName = string.find(setCat.lootpage, "AtlasCFMLoot(.+)Menu")
                    local menuTable = AtlasCFM.MenuData[shortName or setCat.lootpage]
                    if not menuTable and shortName then
                        local _, _, baseName = string.find(shortName, "^(.+)Set$")
                        if baseName then menuTable = AtlasCFM.MenuData[baseName] end
                    end
                    if menuTable then
                        for _, entry in pairs(menuTable) do
                            if entry.lootpage and AtlasCFMLoot_Data[entry.lootpage] then
                                mapItems(AtlasCFMLoot_Data[entry.lootpage], setCat.name)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Step 3 has both synchronous and asynchronous implementations.
    -- The synchronous path remains available as a safe fallback, while normal
    -- startup uses RunProfessionStep below to spread the work across frames.
    table.insert(steps, function()
        if not (AtlasCFM.SpellDB and AtlasCFM.MenuData) then return end
        local profPages = {}
        local menuKeys = { "Alchemy", "Smithing", "Enchanting", "Engineering", "Leatherworking", "Mining",
            "Tailoring", "Jewelcrafting", "Cooking", "FirstAid", "Survival", "Crafting", "CraftedSet" }
        for _, key in ipairs(menuKeys) do
            local menu = AtlasCFM.MenuData[key]
            if menu then
                for _, entry in ipairs(menu) do
                    if entry.lootpage and entry.name then
                        table.insert(profPages, { pageKey = entry.lootpage, name = entry.name })
                    end
                end
            end
        end
        local profLookup = BuildProfessionLookup(profPages)
        indexProfItems(AtlasCFM.SpellDB.enchants, profLookup, "enchant")
        indexProfItems(AtlasCFM.SpellDB.craftspells, profLookup, "spell")
    end)

    local function RunProfessionStep(done)
        if not (AtlasCFM.SpellDB and AtlasCFM.MenuData) then
            done()
            return
        end

        local profPages = {}
        local menuKeys = { "Alchemy", "Smithing", "Enchanting", "Engineering", "Leatherworking", "Mining",
            "Tailoring", "Jewelcrafting", "Cooking", "FirstAid", "Survival", "Crafting", "CraftedSet" }
        for _, key in ipairs(menuKeys) do
            local menu = AtlasCFM.MenuData[key]
            if menu then
                for _, entry in ipairs(menu) do
                    if entry.lootpage and entry.name then
                        table.insert(profPages, { pageKey = entry.lootpage, name = entry.name })
                    end
                end
            end
        end

        -- This one-pass lookup is much cheaper than the original repeated scans.
        local profLookup = BuildProfessionLookup(profPages)

        indexProfItemsAsync(AtlasCFM.SpellDB.enchants, profLookup, "enchant", function()
            indexProfItemsAsync(AtlasCFM.SpellDB.craftspells, profLookup, "spell", done)
        end)
    end

    -- Step 4: Loot Tables (InstanceData)
    local pageBelongsToInstance = {}

    table.insert(steps, function()
        if AtlasCFM.InstanceData then
            for instanceKey, instanceData in pairs(AtlasCFM.InstanceData) do
                -- Helper to process an entry (boss/rep/key)
                local function ProcessEntry(entry, defaultName)
                    local lootTable = nil
                    local pageKey = nil
                    local bossName = entry.name or entry.Name or defaultName or "?"

                    -- Determine loot table and page key
                    if type(entry.items) == "table" then
                        lootTable = entry.items
                    elseif type(entry.loot) == "table" then
                        lootTable = entry.loot
                    elseif type(entry.items) == "string" and AtlasCFMLoot_Data[entry.items] then
                        pageKey = entry.items
                        lootTable = AtlasCFMLoot_Data[pageKey]
                    elseif type(entry.loot) == "string" and AtlasCFMLoot_Data[entry.loot] then
                        pageKey = entry.loot
                        lootTable = AtlasCFMLoot_Data[pageKey]
                    elseif type(entry.id) == "string" and AtlasCFMLoot_Data[entry.id] then
                        pageKey = entry.id
                        lootTable = AtlasCFMLoot_Data[pageKey]
                    end

                    if lootTable then
                        local source = AtlasCFM.LootUtils.GetLootTableSource(pageKey) or instanceKey
                        -- If we have a pageKey, use it to get a better source name if possible,
                        -- otherwise construct one from Instance + Boss
                        if not source or source == instanceKey then
                            local instName = (instanceData.Name or instanceKey)
                            source = instName .. " - " .. bossName
                        end

                        IndexList(lootTable, source, {
                            type = "item",
                            page = pageKey or (instanceKey .. "_" .. bossName), -- Fallback page key
                            boss = bossName,
                            inst = instanceKey,
                            displayName = source
                        })

                        if pageKey then
                            pageBelongsToInstance[pageKey] = true
                        end
                    end
                end

                if instanceData.Bosses then
                    for _, boss in ipairs(instanceData.Bosses) do
                        ProcessEntry(boss, "?")
                    end
                end

                if instanceData.Reputation then
                    for _, rep in pairs(instanceData.Reputation) do
                        ProcessEntry(rep, "Reputation")
                    end
                end

                if instanceData.Keys then
                    for _, keyEntry in pairs(instanceData.Keys) do
                        ProcessEntry(keyEntry, "Keys")
                    end
                end
            end
        end
    end)

    -- Step 5: Loot Tables (AtlasCFMLoot_Data) - Chunked
    local lootKeys = {}
    if AtlasCFMLoot_Data then
        for k in pairs(AtlasCFMLoot_Data) do table.insert(lootKeys, k) end
    end

    -- Helper for loot tables
    local function IndexOneLootTable(key)
        -- Skip if already indexed as part of an instance
        if pageBelongsToInstance[key] then return end

        local tbl = AtlasCFMLoot_Data[key]
        if type(tbl) == "table" then
            -- Source mapping
            local isCraft = false
            local craftPrefixes = { "Alchemy", "Smithing", "Smith", "Enchanting", "Engineering",
                "Leatherworking",
                "Tailoring", "Smelting", "Jewelcraft", "Cooking", "FirstAid", "Survival" }
            for _, prefix in ipairs(craftPrefixes) do
                if string.find(key, "^" .. prefix) then
                    isCraft = true
                    break
                end
            end

            if not isCraft then
                local source = AtlasCFM.LootUtils.GetLootPageDisplayName(key) or key

                -- Enhance short names for PvP Sets to prevent confusing tooltips like "Mage" or "PVPMage118"
                if source and string.find(key, "^PVP") then
                    local L_UI = AtlasCFM.Localization and AtlasCFM.Localization.UI or {}
                    local meta = AtlasCFM.LootUtils.GetMetaCategoryForMenu(key)
                    if meta == (L_UI["PvP Rewards"] or "PvP Rewards") then
                        local pvpPrefix = L_UI["PvP Armor Sets"] or "PvP Armor Sets"
                        if string.find(key, "118") then
                            pvpPrefix = pvpPrefix .. " 1.18"
                        end
                        local cleanSource = AtlasCFM.LootUtils.StripFormatting(source)
                        if cleanSource ~= key and cleanSource ~= "" and not string.find(string.lower(cleanSource), "pvp") then
                            source = pvpPrefix .. " - " .. source
                        end
                    end
                end

                IndexList(tbl, source, { type = "item", page = key, displayName = source })
            else
                -- For craft pages, we still iterate to find skills
                local displayName = AtlasCFM.LootUtils.GetLootPageDisplayName(key) or key
                IndexList(tbl, nil, { type = "item", page = key, displayName = displayName })
            end
        end
    end

    if incremental then
        local currentKeyIndex = 1
        local CHUNK_SIZE = 1 -- Ultra-gentle startup: one loot page per timer slice

        local function IndexLootTablesChunk()
            local count = 0
            local n = table.getn(lootKeys)
            while currentKeyIndex <= n and count < CHUNK_SIZE do
                local key = lootKeys[currentKeyIndex]
                IndexOneLootTable(key)
                currentKeyIndex = currentKeyIndex + 1
                count = count + 1
            end

            if currentKeyIndex <= n then
                AtlasCFM.Timer.Start(0.10, IndexLootTablesChunk)
            else
                FinalizeIndexing()
            end
        end

        -- Start execution
        local currentStep = 1
        local function RunNextStep()
            if currentStep > table.getn(steps) then
                AtlasCFM.Timer.Start(0.10, IndexLootTablesChunk)
                return
            end

            if currentStep == 3 then
                currentStep = currentStep + 1
                RunProfessionStep(function()
                    AtlasCFM.Timer.Start(0.10, RunNextStep)
                end)
                return
            end

            steps[currentStep]()
            currentStep = currentStep + 1
            AtlasCFM.Timer.Start(0.15, RunNextStep)
        end

        -- Do not execute the first indexing step in the same frame that starts
        -- the build.  Giving the client one more frame avoids stacking this work
        -- on top of other delayed login initialization.
        AtlasCFM.Timer.Start(0.10, RunNextStep)
    else
        -- Synchronous execution
        for _, step in ipairs(steps) do
            step()
        end
        for _, key in ipairs(lootKeys) do
            IndexOneLootTable(key)
        end
        FinalizeIndexing()
    end
end

-- API: Get Item Source
function DataIndex.GetItemSource(itemID)
    if not itemID then return nil end

    -- Auto-start indexing if not ready
    if not DataIndex.isIndexed and not DataIndex.isIndexing then
        -- Never force the whole database through one frame.  Start the same
        -- cooperative index used at login and return whatever is available now.
        DataIndex.CheckAndBuildIndex()
    end

    local cached = DataIndex.SourceCache[itemID]
    if cached ~= nil then
        return cached or nil
    end

    -- Fallback: Check if itemID is actually a name (shouldn't happen with strict typing but good for safety)
    if type(itemID) == "string" then
        return nil
    end

    -- Support for Transmogrification (Custom IDs via Name mapping)
    local name = GetItemInfo(itemID)
    if name then
        local originalID = DataIndex.NameToID[name]
        if originalID and originalID ~= itemID then
            local source = DataIndex.SourceCache[originalID]
            if source then
                DataIndex.SourceCache[itemID] = source
                return source
            end
        end
    end

    -- Sets logic (if not indexed yet or missed)
    -- We can't easily do GetItemSetCategory without full scan, so we rely on BuildIndex.

    -- Only cache a negative lookup after the full index is complete.
    -- During cooperative startup the item may simply belong to a page that has
    -- not been indexed yet; caching false at that point can hide a valid source.
    if DataIndex.isIndexed then
        DataIndex.SourceCache[itemID] = false
    end
    return nil
end

-- API: Get Skill Levels
function DataIndex.GetSkillLevels(name)
    if not name then return nil end
    -- Auto-start indexing if not ready
    if not DataIndex.isIndexed and not DataIndex.isIndexing then
        DataIndex.CheckAndBuildIndex()
    end
    return DataIndex.SkillCache[name]
end

-- API: Get Item ID by Name
function DataIndex.GetItemIDByName(name)
    if not name then return nil end
    -- Auto-start indexing if not ready
    if not DataIndex.isIndexed and not DataIndex.isIndexing then
        DataIndex.CheckAndBuildIndex()
    end
    return DataIndex.NameToID[name]
end

-- API: Check options and build index if required
function DataIndex.CheckAndBuildIndex()
    -- Default to true if options are missing (safe fallback)
    local shouldIndex = true

    if AtlasCFMOptions then
        shouldIndex = false
        -- Check Reagent Rows (default 20 if nil)
        if (AtlasCFMOptions.ReagentRows or 20) > 0 then
            shouldIndex = true
        end
        -- Check Show Source (default false if nil)
        if AtlasCFMOptions.LootShowSource then
            shouldIndex = true
        end
        -- Check Profession Info (default true if nil)
        if AtlasCFMOptions.ProfessionInfo ~= false then -- nil or true -> true
            shouldIndex = true
        end
    end

    if shouldIndex then
        DataIndex.BuildIndex(true)
    end
end

-- Initialize on load
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    -- Start indexing when player enters world to ensure all data is loaded
    -- But only if options require it
    -- FIX: Delay indexing to allow server data to propagate (fixes missing skills on login)
    if AtlasCFM and AtlasCFM.Timer and AtlasCFM.Timer.Start then
        AtlasCFM.Timer.Start(6, function()
            DataIndex.CheckAndBuildIndex()
        end)
    else
        DataIndex.CheckAndBuildIndex()
    end
end)

-- API: Find items by text (Search)
function DataIndex.FindItems(text, options)
    if not text then return {} end
    text = string.lower(text)
    -- Trim
    text = string.gsub(text, "^%s*(.-)%s*$", "%1")
    if text == "" then return {} end

    local partial = (options and options.partial)
    if string.len(text) < 3 then
        partial = false
    end

    local types = options and options.types -- nil means all

    local results = {}

    -- Numeric search prep
    local numericText = text
    numericText = string.gsub(numericText, "^id", "")
    numericText = string.gsub(numericText, "^ид", "")
    numericText = string.gsub(numericText, "^%s*(.-)%s*$", "%1")
    if numericText == "" then numericText = text end

    -- Helper: is match?
    local function isMatch(name, id)
        -- Priority: ID match
        if id then
            local sid = tostring(id)
            if partial then
                if string.find(sid, numericText, 1, true) then return true end
            else
                if sid == numericText or id == tonumber(numericText) then return true end
            end
        end

        -- Name match
        if name then
            local ln = string.lower(name)
            if partial then
                if string.find(ln, text, 1, true) then return true end
            else
                if ln == text then return true end
            end
        end
        return false
    end

    -- Auto-start indexing if not ready
    if not DataIndex.isIndexed and not DataIndex.isIndexing then
        DataIndex.CheckAndBuildIndex()
    end

    -- Iterate LocationCache
    for k, locations in pairs(DataIndex.LocationCache) do
        local name = nil
        local id = k
        local isSpellKey = false

        if type(k) == "string" and string.sub(k, 1, 1) == "s" then
            id = tonumber(string.sub(k, 2)) or k
            isSpellKey = true
        else
            id = tonumber(k) or k
        end

        -- Resolve name
        if isSpellKey and AtlasCFM.SpellDB then
            -- Check spells
            if AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] then
                name = AtlasCFM.SpellDB.enchants[id].name
            elseif AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id] then
                name = AtlasCFM.SpellDB.craftspells[id].name
            end
        elseif not isSpellKey and GetItemInfo then
            name = GetItemInfo(id)
        end

        if isMatch(name, id) then
            for _, loc in ipairs(locations) do
                if not types or types[loc.type] then
                    local entryName = loc.displayName
                    local entryInst = loc.page
                    local sourcePage = loc.page

                    if loc.boss and loc.inst then
                        entryName = loc.boss
                        entryInst = loc.inst
                        sourcePage = loc.boss .. "|" .. loc.inst
                    end

                    -- Ensure entryName is not nil
                    if not entryName then entryName = "?" end

                    table.insert(results, {
                        id,
                        entryName,
                        entryInst,
                        loc.type,
                        sourcePage
                    })
                end
            end
        end
    end

    return results
end
