---
--- Cache.lua - Centralized asynchronous item-cache manager for Atlas-CFM Loot
---
--- The original cache path could permanently mark a page as checked even when
--- item data had not arrived yet. This manager keeps only live outstanding
--- requests, deduplicates them globally, and never negative-caches an item.
---
--- ClassicAPI clients use C_Item.RequestLoadItemDataByID +
--- ITEM_DATA_LOAD_RESULT. Stock/other 1.12 clients retain a throttled hidden
--- tooltip fallback. No polling runs when there is no outstanding work.
--- @compatible World of Warcraft 1.12 / Lua 5.0
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}
AtlasCFM.LootCache = AtlasCFM.LootCache or {}

local LootCache = AtlasCFM.LootCache

-- Live request state only. Entries are removed on success/failure/timeout.
local pending = {}       -- itemID -> { attempts, firstRequest, lastRequest, queued }
local queue = {}         -- FIFO item IDs waiting for an actual server/cache request
local queueHead = 1
local queueTail = 0
local workerScheduled = false
local pollScheduled = false
local refreshScheduled = false
local eventRegistered = false

local REQUEST_BATCH = 4
local REQUEST_SLICE_DELAY = 0.15
local POLL_DELAY = 0.25
local RETRY_AFTER = 1.50
local MAX_ATTEMPTS = 3
local REQUEST_TIMEOUT = 12.0

local hiddenTooltip = nil

local function Now()
    if GetTime then return GetTime() end
    return 0
end

local function IsCached(itemID)
    if not itemID or itemID <= 0 then return true end
    return GetItemInfo and GetItemInfo(itemID) ~= nil
end

local function HasPending()
    for _ in pairs(pending) do return true end
    return false
end

local function GetHiddenTooltip()
    if hiddenTooltip then return hiddenTooltip end
    local name = "AtlasCFMLootCacheRequestTooltip"
    hiddenTooltip = _G[name]
    if not hiddenTooltip then
        hiddenTooltip = CreateFrame("GameTooltip", name, UIParent, "GameTooltipTemplate")
        hiddenTooltip:SetOwner(WorldFrame or UIParent, "ANCHOR_NONE")
        _G[name] = hiddenTooltip
    end
    return hiddenTooltip
end

local function QueueVisibleRefresh()
    if refreshScheduled then return end
    if not AtlasCFM.Timer or not AtlasCFM.Timer.Start then return end
    refreshScheduled = true
    AtlasCFM.Timer.Start(0.05, function()
        refreshScheduled = false
        if AtlasCFMLootItemsFrame and AtlasCFMLootItemsFrame:IsVisible()
            and AtlasCFM.LootBrowserUI and AtlasCFM.LootBrowserUI.ScrollBarLootUpdate then
            AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
        end
    end)
end

local eventFrame = CreateFrame("Frame", "AtlasCFMLootCacheEventFrame")
eventFrame:SetScript("OnEvent", function()
    if event ~= "ITEM_DATA_LOAD_RESULT" then return end
    local itemID = tonumber(arg1)
    if not itemID then return end

    local state = pending[itemID]
    if not state then return end

    -- ClassicAPI versions in the wild have represented success as 1/0 or
    -- 1/nil. Check explicitly so numeric 0 is never mistaken for truthy Lua.
    local success = (arg2 == true or tonumber(arg2) == 1)
    pending[itemID] = nil

    if success or IsCached(itemID) then
        QueueVisibleRefresh()
    end
end)

local function EnsureEventRegistration()
    if eventRegistered then return end
    if C_Item and C_Item.RequestLoadItemDataByID then
        local ok = pcall(eventFrame.RegisterEvent, eventFrame, "ITEM_DATA_LOAD_RESULT")
        if ok then eventRegistered = true end
    end
end

local function DoRequest(itemID, state)
    if not itemID or not state then return end
    if IsCached(itemID) then
        pending[itemID] = nil
        QueueVisibleRefresh()
        return
    end

    state.attempts = (state.attempts or 0) + 1
    state.lastRequest = Now()
    if not state.firstRequest then state.firstRequest = state.lastRequest end
    state.queued = false

    EnsureEventRegistration()

    if C_Item and C_Item.RequestLoadItemDataByID then
        -- Fire-and-forget. ITEM_DATA_LOAD_RESULT (plus the bounded poll below)
        -- completes the request when the engine receives the item data.
        pcall(C_Item.RequestLoadItemDataByID, itemID)
    else
        -- Vanilla-compatible fallback. SetHyperlink asks the client for an
        -- uncached item, but requests are globally throttled by this manager.
        local tooltip = GetHiddenTooltip()
        if tooltip then
            tooltip:ClearLines()
            pcall(tooltip.SetHyperlink, tooltip, "item:" .. itemID .. ":0:0:0")
        end
    end
end

local ProcessQueue
local PollPending

local function ScheduleWorker(delay)
    if workerScheduled then return end
    if not AtlasCFM.Timer or not AtlasCFM.Timer.Start then return end
    workerScheduled = true
    AtlasCFM.Timer.Start(delay or 0, function()
        workerScheduled = false
        ProcessQueue()
    end)
end

local function SchedulePoll()
    if pollScheduled or not HasPending() then return end
    if not AtlasCFM.Timer or not AtlasCFM.Timer.Start then return end
    pollScheduled = true
    AtlasCFM.Timer.Start(POLL_DELAY, function()
        pollScheduled = false
        PollPending()
    end)
end

local function EnqueueExisting(itemID, state)
    if not state or state.queued then return end
    state.queued = true
    queueTail = queueTail + 1
    queue[queueTail] = itemID
    ScheduleWorker(0)
end

ProcessQueue = function()
    local processed = 0

    while queueHead <= queueTail and processed < REQUEST_BATCH do
        local itemID = queue[queueHead]
        queue[queueHead] = nil
        queueHead = queueHead + 1

        local state = pending[itemID]
        if state then
            state.queued = false
            DoRequest(itemID, state)
        end
        processed = processed + 1
    end

    if queueHead <= queueTail then
        ScheduleWorker(REQUEST_SLICE_DELAY)
    else
        -- Compact the queue after a completed pass. Do not use table.remove(1)
        -- on this old client; resetting the sparse FIFO is O(1).
        queue = {}
        queueHead = 1
        queueTail = 0
    end

    SchedulePoll()
end

PollPending = function()
    local now = Now()
    local refreshed = false

    for itemID, state in pairs(pending) do
        if IsCached(itemID) then
            pending[itemID] = nil
            refreshed = true
        else
            local firstRequest = state.firstRequest or now
            local lastRequest = state.lastRequest or 0
            local attempts = state.attempts or 0

            if (now - firstRequest) >= REQUEST_TIMEOUT then
                -- Never mark the item as permanently missing. Dropping only the
                -- live request lets a later page-open attempt it again.
                pending[itemID] = nil
            elseif attempts < MAX_ATTEMPTS and (now - lastRequest) >= RETRY_AFTER then
                EnqueueExisting(itemID, state)
            end
        end
    end

    if refreshed then QueueVisibleRefresh() end
    if HasPending() then SchedulePoll() end
end

local function AddItemID(out, seen, itemID)
    itemID = tonumber(itemID)
    if not itemID or itemID <= 0 or seen[itemID] then return end
    seen[itemID] = true
    table.insert(out, itemID)
end

local function AddCraftResult(out, seen, spellID, kind)
    if not AtlasCFM.SpellDB or not spellID then return false end
    local data = nil

    if kind == "enchant" then
        data = AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[spellID]
    elseif kind == "spell" then
        data = AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[spellID]
    else
        data = (AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[spellID]) or
            (AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[spellID])
    end

    if data then
        local resultItem = AtlasCFM.Server and AtlasCFM.Server.GetDataField
            and AtlasCFM.Server.GetDataField(data, "item") or data.item
        if resultItem then AddItemID(out, seen, resultItem) end
        return true
    end
    return false
end

local function CollectItems(dataSource, out, seen, forceItems)
    if type(dataSource) ~= "table" then return end
    local n = table.getn(dataSource)

    for i = 1, n do
        local element = dataSource[i]
        local t = type(element)

        if t == "number" then
            AddItemID(out, seen, element)
        elseif t == "table" then
            -- Respect current-server visibility before touching any IDs.
            local visible = not AtlasCFM.Server or not AtlasCFM.Server.IsVisible or AtlasCFM.Server.IsVisible(element)
            if visible then
                local id = element.id or element[1]
                local itemType = element._wlType or element[4]
                local elType = AtlasCFM.Server and AtlasCFM.Server.GetDataField
                    and AtlasCFM.Server.GetDataField(element, "type") or element.type
                local skill = AtlasCFM.Server and AtlasCFM.Server.GetDataField
                    and AtlasCFM.Server.GetDataField(element, "skill") or element.skill

                if id then
                    if forceItems then
                        AddItemID(out, seen, id)
                    elseif itemType == "spell" or itemType == "enchant" then
                        if not AddCraftResult(out, seen, id, itemType) then
                            -- Search rows can legitimately contain an ordinary
                            -- item with no SpellDB record.
                            AddItemID(out, seen, id)
                        end
                    elseif elType == "spell" or elType == "enchant" then
                        if not AddCraftResult(out, seen, id, elType) then
                            AddItemID(out, seen, id)
                        end
                    elseif elType == "item" then
                        AddItemID(out, seen, id)
                    elseif skill ~= nil then
                        -- Profession pages use spell IDs for rows with skill data.
                        -- Only cache a result item when SpellDB confirms the ID as
                        -- a craft/enchant; never query the spell ID as an item.
                        AddCraftResult(out, seen, id, nil)
                    elseif element.id == nil and element[1] ~= nil then
                        -- Reagent tuple { itemID, quantity }.
                        AddItemID(out, seen, id)
                    else
                        -- Ordinary Atlas item row.
                        AddItemID(out, seen, id)
                    end
                end

                if element.container then
                    CollectItems(element.container, out, seen, true)
                end
            end
        end
    end
end

local function QueueItem(itemID)
    if IsCached(itemID) then return true end

    local state = pending[itemID]
    if not state then
        state = { attempts = 0, firstRequest = Now(), lastRequest = 0, queued = false }
        pending[itemID] = state
    end
    EnqueueExisting(itemID, state)
    return false
end

--- Request one item without creating a separate retry loop.
function LootCache.ForceCacheItem(itemID, maxAttempts, callback)
    itemID = tonumber(itemID)
    if not itemID or itemID <= 0 then
        if callback then callback(false) end
        return false
    end

    if IsCached(itemID) then
        if callback then callback(true) end
        return true
    end

    QueueItem(itemID)
    if callback then
        if AtlasCFM.Timer and AtlasCFM.Timer.Start then
            AtlasCFM.Timer.Start(0.05, function()
                callback(IsCached(itemID))
            end)
        else
            callback(false)
        end
    end
    return false
end

--- Request all real item IDs represented by a loot-data list.
--- The callback means "requests have been queued; render the page now", not
--- "every server response has arrived". Successful async responses repaint the
--- visible page progressively.
function LootCache.CacheAllItems(dataSource, callback)
    if type(dataSource) ~= "table" then
        if callback then callback() end
        return
    end

    local items = {}
    local seen = {}
    CollectItems(dataSource, items, seen, false)

    for i = 1, table.getn(items) do
        QueueItem(items[i])
    end

    if callback then
        if AtlasCFM.Timer and AtlasCFM.Timer.Start then
            AtlasCFM.Timer.Start(0.05, callback)
        else
            callback()
        end
    end
end

--- Small diagnostics helpers used only for safe/manual debugging.
function LootCache.GetPendingCount()
    local count = 0
    for _ in pairs(pending) do count = count + 1 end
    return count
end
