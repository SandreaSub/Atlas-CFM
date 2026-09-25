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
DataIndex.stage = "idle"

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
local function IndexProfessionPage(profEntry, lookup)
    if not profEntry or not lookup then return end

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

    local pageKey = profEntry.pageKey
    local page = AtlasCFMLoot_Data and AtlasCFMLoot_Data[pageKey]
    if page then
        indexPageList(page, pageKey, profEntry.name)
    end
end

local function BuildProfessionLookup(profPages)
    local lookup = {}
    for _, profEntry in ipairs(profPages) do
        IndexProfessionPage(profEntry, lookup)
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

local function IndexElement(el, source, locationInfo)
    if not el then return end
    locationInfo = locationInfo or {}

    local id = type(el) == "table" and (el.id or el[1]) or el
    if not id or type(id) ~= "number" then return end

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

        -- Also index the created item if this ID is a spell/enchant.
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
            table.insert(cache, {
                page = locationInfo.page,
                boss = locationInfo.boss,
                inst = locationInfo.inst,
                displayName = locationInfo.displayName,
                type = actualType
            })
        end

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
                    table.insert(cCache, {
                        page = locationInfo.page,
                        boss = locationInfo.boss,
                        inst = locationInfo.inst,
                        type = "item",
                        displayName = locationInfo.displayName
                    })
                end
            end
        end
    end

    -- Skill Level Processing (from ProfessionHooks).
    if type(el) == "table" and el.skill then
        local names = DataIndex.GetNamesFromID(el.id)
        local skillText = FormatSkillLevels(el.skill)
        for _, name in ipairs(names) do
            DataIndex.SkillCache[name] = skillText
        end
    end
end

local function ChildLocationInfo(locationInfo)
    local child = {}
    if locationInfo then
        for k, v in pairs(locationInfo) do child[k] = v end
    end
    child.forceType = "item"
    return child
end

-- Synchronous list traversal retained for the explicit non-incremental path.
local function IndexList(list, source, locationInfo)
    if type(list) ~= "table" then return end
    for i = 1, table.getn(list) do
        local el = list[i]
        IndexElement(el, source, locationInfo)
        if type(el) == "table" and el.container then
            IndexList(el.container, source, ChildLocationInfo(locationInfo))
        end
    end
end

-- Cooperative list traversal used by normal background warm-up. It processes a
-- bounded number of rows per timer slice, including nested containers, so one
-- large raid/crafting page cannot become a hidden synchronous spike.
local function IndexListAsync(list, source, locationInfo, done, batchSize)
    if type(list) ~= "table" then
        if done then done() end
        return
    end

    if not (AtlasCFM.Timer and AtlasCFM.Timer.Start) then
        IndexList(list, source, locationInfo)
        if done then done() end
        return
    end

    local stack = { { list = list, index = 1, locationInfo = locationInfo } }
    local perSlice = batchSize or 18

    local function RunBatch()
        local processed = 0
        while table.getn(stack) > 0 and processed < perSlice do
            local stackIndex = table.getn(stack)
            local frame = stack[stackIndex]
            local n = table.getn(frame.list)

            if frame.index > n then
                stack[stackIndex] = nil
            else
                local el = frame.list[frame.index]
                frame.index = frame.index + 1
                IndexElement(el, source, frame.locationInfo)
                processed = processed + 1

                if type(el) == "table" and el.container then
                    table.insert(stack, {
                        list = el.container,
                        index = 1,
                        locationInfo = ChildLocationInfo(frame.locationInfo)
                    })
                end
            end
        end

        if table.getn(stack) > 0 then
            AtlasCFM.Timer.Start(0.03, RunBatch)
        elseif done then
            done()
        end
    end

    AtlasCFM.Timer.Start(0.01, RunBatch)
end

-- Main Indexing Function
function DataIndex.BuildIndex(incremental)
    if DataIndex.isIndexed or DataIndex.isIndexing then return end

    DataIndex.isIndexing = true
    DataIndex.stage = "starting"

    local function FinalizeIndexing()
        DataIndex.isIndexed = true
        DataIndex.isIndexing = false
        DataIndex.stage = "ready"
        itemToSetMap = {} -- Clear temporary map
        NotifyCallbacks()
    end

    local function CollectProfessionPages()
        local profPages = {}
        if not (AtlasCFM.SpellDB and AtlasCFM.MenuData) then return profPages end

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
        return profPages
    end

    local pageBelongsToInstance = {}

    local function ResolveInstanceEntry(instanceKey, instanceData, entry, defaultName)
        if not entry then return nil end

        local lootTable = nil
        local pageKey = nil
        local bossName = entry.name or entry.Name or defaultName or "?"

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

        if not lootTable then return nil end

        local source = AtlasCFM.LootUtils.GetLootTableSource(pageKey) or instanceKey
        if not source or source == instanceKey then
            local instName = instanceData.Name or instanceKey
            source = instName .. " - " .. bossName
        end

        local locationInfo = {
            type = "item",
            page = pageKey or (instanceKey .. "_" .. bossName),
            boss = bossName,
            inst = instanceKey,
            displayName = source
        }
        return lootTable, pageKey, source, locationInfo
    end

    local function ProcessInstanceEntry(instanceKey, instanceData, entry, defaultName)
        local lootTable, pageKey, source, locationInfo = ResolveInstanceEntry(instanceKey, instanceData, entry, defaultName)
        if not lootTable then return end
        IndexList(lootTable, source, locationInfo)
        if pageKey then pageBelongsToInstance[pageKey] = true end
    end

    local function ProcessInstanceEntryAsync(instanceKey, instanceData, entry, defaultName, done)
        local lootTable, pageKey, source, locationInfo = ResolveInstanceEntry(instanceKey, instanceData, entry, defaultName)
        if not lootTable then
            if done then done() end
            return
        end

        IndexListAsync(lootTable, source, locationInfo, function()
            if pageKey then pageBelongsToInstance[pageKey] = true end
            if done then done() end
        end)
    end

    local lootKeys = {}
    if AtlasCFMLoot_Data then
        for k in pairs(AtlasCFMLoot_Data) do table.insert(lootKeys, k) end
    end

    local function IndexOneLootTable(key)
        if pageBelongsToInstance[key] then return end

        local tbl = AtlasCFMLoot_Data[key]
        if type(tbl) ~= "table" then return end

        local isCraft = false
        local craftPrefixes = { "Alchemy", "Smithing", "Smith", "Enchanting", "Engineering",
            "Leatherworking", "Tailoring", "Smelting", "Jewelcraft", "Cooking", "FirstAid", "Survival" }
        for _, prefix in ipairs(craftPrefixes) do
            if string.find(key, "^" .. prefix) then
                isCraft = true
                break
            end
        end

        if not isCraft then
            local source = AtlasCFM.LootUtils.GetLootPageDisplayName(key) or key

            if source and string.find(key, "^PVP") then
                local L_UI = AtlasCFM.Localization and AtlasCFM.Localization.UI or {}
                local meta = AtlasCFM.LootUtils.GetMetaCategoryForMenu(key)
                if meta == (L_UI["PvP Rewards"] or "PvP Rewards") then
                    local pvpPrefix = L_UI["PvP Armor Sets"] or "PvP Armor Sets"
                    if string.find(key, "118") then pvpPrefix = pvpPrefix .. " 1.18" end
                    local cleanSource = AtlasCFM.LootUtils.StripFormatting(source)
                    if cleanSource ~= key and cleanSource ~= "" and not string.find(string.lower(cleanSource), "pvp") then
                        source = pvpPrefix .. " - " .. source
                    end
                end
            end

            IndexList(tbl, source, { type = "item", page = key, displayName = source })
        else
            local displayName = AtlasCFM.LootUtils.GetLootPageDisplayName(key) or key
            IndexList(tbl, nil, { type = "item", page = key, displayName = displayName })
        end
    end

    local function IndexOneLootTableAsync(key, done)
        if pageBelongsToInstance[key] then
            if done then done() end
            return
        end

        local tbl = AtlasCFMLoot_Data[key]
        if type(tbl) ~= "table" then
            if done then done() end
            return
        end

        local isCraft = false
        local craftPrefixes = { "Alchemy", "Smithing", "Smith", "Enchanting", "Engineering",
            "Leatherworking", "Tailoring", "Smelting", "Jewelcraft", "Cooking", "FirstAid", "Survival" }
        for _, prefix in ipairs(craftPrefixes) do
            if string.find(key, "^" .. prefix) then
                isCraft = true
                break
            end
        end

        local source = nil
        local displayName = AtlasCFM.LootUtils.GetLootPageDisplayName(key) or key
        if not isCraft then
            source = displayName
            if source and string.find(key, "^PVP") then
                local L_UI = AtlasCFM.Localization and AtlasCFM.Localization.UI or {}
                local meta = AtlasCFM.LootUtils.GetMetaCategoryForMenu(key)
                if meta == (L_UI["PvP Rewards"] or "PvP Rewards") then
                    local pvpPrefix = L_UI["PvP Armor Sets"] or "PvP Armor Sets"
                    if string.find(key, "118") then pvpPrefix = pvpPrefix .. " 1.18" end
                    local cleanSource = AtlasCFM.LootUtils.StripFormatting(source)
                    if cleanSource ~= key and cleanSource ~= "" and not string.find(string.lower(cleanSource), "pvp") then
                        source = pvpPrefix .. " - " .. source
                    end
                end
            end
            displayName = source
        end

        IndexListAsync(tbl, source, { type = "item", page = key, displayName = displayName }, done)
    end

    -- Keep the synchronous implementation as a compatibility/debug fallback.
    -- Normal operation always uses the cooperative path below.
    if not incremental then
        DataIndex.stage = "quests"
        if AtlasCFM.Quest and AtlasCFM.Quest.DataBase then
            for _, instanceData in pairs(AtlasCFM.Quest.DataBase) do
                local instanceName = instanceData.Caption
                if type(instanceName) == "table" then instanceName = instanceName[1] end
                indexQuests(instanceData.Alliance, instanceName)
                indexQuests(instanceData.Horde, instanceName)
            end
        end

        DataIndex.stage = "sets"
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

        DataIndex.stage = "professions"
        local profPages = CollectProfessionPages()
        local profLookup = BuildProfessionLookup(profPages)
        indexProfItems(AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants, profLookup, "enchant")
        indexProfItems(AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells, profLookup, "spell")

        DataIndex.stage = "instances"
        if AtlasCFM.InstanceData then
            for instanceKey, instanceData in pairs(AtlasCFM.InstanceData) do
                if instanceData.Bosses then
                    for _, boss in ipairs(instanceData.Bosses) do ProcessInstanceEntry(instanceKey, instanceData, boss, "?") end
                end
                if instanceData.Reputation then
                    for _, rep in pairs(instanceData.Reputation) do ProcessInstanceEntry(instanceKey, instanceData, rep, "Reputation") end
                end
                if instanceData.Keys then
                    for _, keyEntry in pairs(instanceData.Keys) do ProcessInstanceEntry(instanceKey, instanceData, keyEntry, "Keys") end
                end
            end
        end

        DataIndex.stage = "loot"
        for _, key in ipairs(lootKeys) do IndexOneLootTable(key) end
        FinalizeIndexing()
        return
    end

    -- Build lightweight work lists only. The expensive item traversal happens
    -- in timed slices below, never as one large PLAYER_ENTERING_WORLD callback.
    local questJobs = {}
    if AtlasCFM.Quest and AtlasCFM.Quest.DataBase then
        for _, instanceData in pairs(AtlasCFM.Quest.DataBase) do
            table.insert(questJobs, instanceData)
        end
    end

    local setJobs = {}
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
                            table.insert(setJobs, { data = AtlasCFMLoot_Data[entry.lootpage], name = setCat.name })
                        end
                    end
                end
            end
        end
    end

    local profPages = CollectProfessionPages()

    local instanceJobs = {}
    if AtlasCFM.InstanceData then
        for instanceKey, instanceData in pairs(AtlasCFM.InstanceData) do
            if instanceData.Bosses then
                for _, boss in ipairs(instanceData.Bosses) do
                    table.insert(instanceJobs, { instanceKey, instanceData, boss, "?" })
                end
            end
            if instanceData.Reputation then
                for _, rep in pairs(instanceData.Reputation) do
                    table.insert(instanceJobs, { instanceKey, instanceData, rep, "Reputation" })
                end
            end
            if instanceData.Keys then
                for _, keyEntry in pairs(instanceData.Keys) do
                    table.insert(instanceJobs, { instanceKey, instanceData, keyEntry, "Keys" })
                end
            end
        end
    end

    local SLICE_DELAY = 0.05
    local QUESTS_PER_SLICE = 2
    local SETS_PER_SLICE = 1
    local PROF_PAGES_PER_SLICE = 1

    local function Schedule(func, delay)
        if AtlasCFM.Timer and AtlasCFM.Timer.Start then
            AtlasCFM.Timer.Start(delay or SLICE_DELAY, func)
        else
            -- This is only a last-resort compatibility fallback. Atlas 1.80+
            -- normally reaches C_Timer.After through AtlasCFM.Timer.Start.
            func()
        end
    end

    local RunQuestSlice, RunSetSlice, RunProfessionLookupSlice, RunInstanceSlice, RunLootSlice
    local questIndex, setIndex, profPageIndex, instanceIndex, lootIndex = 1, 1, 1, 1, 1
    local profLookup = {}

    RunLootSlice = function()
        DataIndex.stage = "loot"
        if lootIndex > table.getn(lootKeys) then
            FinalizeIndexing()
            return
        end

        local key = lootKeys[lootIndex]
        lootIndex = lootIndex + 1
        IndexOneLootTableAsync(key, function()
            Schedule(RunLootSlice, 0.05)
        end)
    end

    RunInstanceSlice = function()
        DataIndex.stage = "instances"
        if instanceIndex > table.getn(instanceJobs) then
            Schedule(RunLootSlice)
            return
        end

        local job = instanceJobs[instanceIndex]
        instanceIndex = instanceIndex + 1
        ProcessInstanceEntryAsync(job[1], job[2], job[3], job[4], function()
            Schedule(RunInstanceSlice, 0.05)
        end)
    end

    local function RunProfessionItems()
        DataIndex.stage = "professions"
        if not AtlasCFM.SpellDB then
            Schedule(RunInstanceSlice)
            return
        end

        indexProfItemsAsync(AtlasCFM.SpellDB.enchants, profLookup, "enchant", function()
            indexProfItemsAsync(AtlasCFM.SpellDB.craftspells, profLookup, "spell", function()
                Schedule(RunInstanceSlice)
            end)
        end)
    end

    RunProfessionLookupSlice = function()
        DataIndex.stage = "profession-lookup"
        local processed = 0
        while profPageIndex <= table.getn(profPages) and processed < PROF_PAGES_PER_SLICE do
            IndexProfessionPage(profPages[profPageIndex], profLookup)
            profPageIndex = profPageIndex + 1
            processed = processed + 1
        end

        if profPageIndex <= table.getn(profPages) then
            Schedule(RunProfessionLookupSlice)
        else
            Schedule(RunProfessionItems)
        end
    end

    RunSetSlice = function()
        DataIndex.stage = "sets"
        local processed = 0
        while setIndex <= table.getn(setJobs) and processed < SETS_PER_SLICE do
            local job = setJobs[setIndex]
            mapItems(job.data, job.name)
            setIndex = setIndex + 1
            processed = processed + 1
        end

        if setIndex <= table.getn(setJobs) then
            Schedule(RunSetSlice)
        else
            Schedule(RunProfessionLookupSlice)
        end
    end

    RunQuestSlice = function()
        DataIndex.stage = "quests"
        local processed = 0
        while questIndex <= table.getn(questJobs) and processed < QUESTS_PER_SLICE do
            local instanceData = questJobs[questIndex]
            local instanceName = instanceData.Caption
            if type(instanceName) == "table" then instanceName = instanceName[1] end
            indexQuests(instanceData.Alliance, instanceName)
            indexQuests(instanceData.Horde, instanceName)
            questIndex = questIndex + 1
            processed = processed + 1
        end

        if questIndex <= table.getn(questJobs) then
            Schedule(RunQuestSlice)
        else
            Schedule(RunSetSlice)
        end
    end

    -- Never perform the first traversal in the frame that started the build.
    Schedule(RunQuestSlice, 0.10)
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

-- Warm the complete index after login, but do every expensive stage in the
-- cooperative slices above. This preserves the long-standing Atlas guarantee
-- that source/search/profession data becomes fully available each session
-- without putting one large traversal in the cold-login critical path.
local frame = CreateFrame("Frame")
local warmupScheduled = false
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    if DataIndex.isIndexed or DataIndex.isIndexing or warmupScheduled then return end

    if AtlasCFM and AtlasCFM.Timer and AtlasCFM.Timer.Start then
        warmupScheduled = true
        AtlasCFM.Timer.Start(6, function()
            warmupScheduled = false
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

    -- Auto-start indexing if not ready. Preserve the long-standing Atlas
    -- behavior of searching whatever has already been indexed rather than
    -- making the search box appear unresponsive during background warm-up.
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
