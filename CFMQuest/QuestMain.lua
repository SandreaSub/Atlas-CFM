---
--- QuestMain.lua - Atlas quest system main functionality
---
--- This file contains the main quest system functionality for Atlas-CFM.
--- It handles quest display, quest data processing, quest UI management,
--- and provides the core infrastructure for the Atlas quest browser.
---
--- Features:
--- - Quest display and management
--- - Quest data processing
--- - Quest UI state handling
--- - Quest navigation system
--- - Quest filtering and search
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM

local L = (AtlasCFM.Localization and AtlasCFM.Localization.UI) or {}
-----------------------------------------------------------------------------
-- Colours
-----------------------------------------------------------------------------
local red = AtlasCFM.Colors.RED
local redHorde = AtlasCFM.Colors.RED_HORDE
local white = AtlasCFM.Colors.WHITE
local grey = AtlasCFM.Colors.GREY2
local orange = AtlasCFM.Colors.ORANGE2
local blue = AtlasCFM.Colors.BLUE
local green = AtlasCFM.Colors.GREEN2
local yellow = AtlasCFM.Colors.YELLOW2
-----------------------------------------------------------------------------
-- AtlasCFM
-----------------------------------------------------------------------------
local kQuestInstChanged
local kQQuestColor

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------
---
--- Clears all quest-related UI elements and resets quest state
--- Hides quest frames and resets current quest selection
--- @return nil
--- @usage Called when switching maps or clearing quest display
---
function AtlasCFM.Quest.ClearAll()
    AtlasCFM.Quest.UI.PageCount:SetText()
    AtlasCFM.Quest.UI.NextPageButtonRight:Hide()
    AtlasCFM.Quest.UI.NextPageButtonLeft:Hide()
    AtlasCFM.Quest.UI.QuestName:SetText()
    AtlasCFM.Quest.UI.QuestLevel:SetText()
    AtlasCFM.Quest.UI.Prerequisite:SetText()
    AtlasCFM.Quest.UI.QuestAttainLevel:SetText()
    AtlasCFM.Quest.UI.Rewards:SetText()
    AtlasCFM.Quest.UI.Story:SetText()
    AtlasCFM.Quest.UI.FinishedQuestText:SetText()
    AtlasCFM.Quest.UI.FinishedQuestCheckbox:Hide()
    AtlasCFM.Quest.HideQuestButtonHighlights()
    for b = 1, AtlasCFM.QMAXQUESTITEMS do
        AtlasCFM.Quest.UI.QuestItems[b].Icon:SetTexture()
        AtlasCFM.Quest.UI.QuestItems[b].Name:SetText()
        AtlasCFM.Quest.UI.QuestItems[b].Extra:SetText()
        AtlasCFM.Quest.UI.QuestItems[b].Quantity:SetText()
        AtlasCFM.Quest.UI.QuestItems[b].Frame:Hide()
    end
end

-----------------------------------------------------------------------------
-- Hide the AtlasCFMLoot Frame if available
-----------------------------------------------------------------------------
---
--- Hides the AtlasCFMLoot frame if it's currently visible
--- Ensures quest UI doesn't conflict with loot display
--- @return nil
--- @usage Called before showing quest details
---
function AtlasCFM.Quest.HideAtlasCFMLootFrame()
    if AtlasCFMLootItemsFrame then
        AtlasCFMLootItemsFrame:Hide() -- hide AtlasCFMLoot
    end
end

-----------------------------------------------------------------------------
-- Helper function to check if a quest exists
-- Returns true if quest exists, false otherwise
-----------------------------------------------------------------------------
---
--- Checks if a quest exists in the database for given parameters
--- @param instance string - Instance name (defaults to current)
--- @param questId number - Quest ID to check
--- @param faction string - Faction name (defaults to current player faction)
--- @return boolean - True if quest exists, false otherwise
--- @usage Used internally to validate quest existence
---
local function kQQuestExists(instance, questId, faction)
    -- Default to current instance and faction if not provided
    instance = instance or AtlasCFM.QCurrentInstance
    faction = faction or AtlasCFM.Faction

    -- Check if quest exists in the new format
    return AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][questId] ~= nil
end

---
--- Compares quest with player's quest log and sets appropriate color
--- @param questId number - Quest ID to compare (defaults to current quest)
--- @return boolean - True if quest is found in quest log, false otherwise
--- @usage Used to highlight completed or active quests
---
local function kQCompareQuestLogtoQuest(questId)
    -- Early return if quest log checking is disabled
    if not AtlasCFMOptions.QuestCheckQuestlog then
        return false
    end

    -- Use current shown quest if no specific quest ID provided
    local targetQuest = questId or AtlasCFM.QCurrentQuest

    -- Get quest data from new structure
    local instanceData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance]
    if not instanceData then
        return false
    end

    local faction = AtlasCFM.Faction
    local questData = instanceData[faction] and instanceData[faction][targetQuest]

    if questData and not questData.Title then
        return false
    end

    -- ClassicAPI provides a stable quest-ID check that is independent of
    -- localization, punctuation, duplicate names, and collapsed Quest Log
    -- headers. Prefer it whenever the current quest record has an ID.
    local questID = questData and tonumber(questData.Id) or nil
    if questID and C_QuestLog and type(C_QuestLog.IsOnQuest) == "function" then
        local ok, onQuest = pcall(C_QuestLog.IsOnQuest, questID)
        if ok and onQuest ~= nil then
            return onQuest and true or false
        end
    end

    -- Legacy fallback for clients without the ClassicAPI quest-ID bridge.
    -- Extract quest name from title (remove number prefix like "1. ")
    local questTitle = questData.Title
    local questName = questTitle
    if questTitle and strlen(questTitle) > 0 then
        local _, _, extractedName = strfind(questTitle, "^%d+%.%s*(.+)")
        questName = extractedName or questTitle
    end

    -- Remove parentheses and content within them for better matching
    local startPos, _ = strfind(questName, " %(.*%)")
    if startPos then
        questName = strsub(questName, 1, startPos - 1)
    end

    -- Remove special characters for better matching
    questName = string.gsub(questName, "[%p%c]", "")

    -- Iterate through all quest log entries to find a match
    local totalQuestEntries = GetNumQuestLogEntries()
    for questIndex = 1, totalQuestEntries do
        local logQuestTitle, _, _ = GetQuestLogTitle(questIndex)

        -- Process the quest log title to match our format
        local processedTitle = logQuestTitle
        if processedTitle then
            -- Remove parentheses content and special characters
            local pos = strfind(processedTitle, " %(.*%)")
            if pos then
                processedTitle = strsub(processedTitle, 1, pos - 1)
            end
            processedTitle = string.gsub(processedTitle, "[%p%c]", "")

            -- Case insensitive comparison
            if string.lower(processedTitle) == string.lower(questName) then
                return true
            end
        end
    end

    -- Quest not found in quest log
    return false
end

---
--- Sets the checkbox state for finished quest tracking
--- Updates UI checkbox based on quest completion status
--- @return nil
--- @usage Called when updating quest completion display
---
local function kQuestFinishedSetChecked()
    local questKey = "Completed_" .. AtlasCFM.QCurrentInstance .. "_Quest_" .. AtlasCFM.QCurrentQuest
    questKey = questKey .. (AtlasCFM.isHorde and "_Horde" or "_Alliance")
    AtlasCFM.Quest.UI.FinishedQuestCheckbox:SetChecked(AtlasCFM.Q[questKey] == 1)
end

---
--- Handles multi-page quest display and navigation
--- Sets up page navigation for quests with multiple pages
--- @return nil
--- @usage Called when displaying quests with extended content
---
local function kQuestExtendedPages()
    -- Determine current faction
    local faction = AtlasCFM.Faction
    local questId = AtlasCFM.QCurrentQuest
    local instance = AtlasCFM.QCurrentInstance

    -- In the new format, check if the quest has Pages data
    local questData = AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][questId]

    -- If we have quest data and it has Pages
    if questData and questData.Page and type(questData.Page) == "table" then
        local pageCount = questData.Page[1] -- The first element contains the total number of pages

        if pageCount and pageCount > 1 then
            -- Show the navigation button for additional pages
            AtlasCFM.Quest.UI.NextPageButtonRight:Show()
            -- Set the current page type to "Quest" for proper navigation handling
            AtlasCFM.Quest.NextPageCount = "Quest"
            -- Initialize to the first page
            AtlasCFM.QCurrentPage = 1
            -- Update the page counter display with current/total format
            AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. pageCount)
            return
        end
    end
end

---
--- Retrieves and formats item information for quest rewards
--- @param count number - Index of the item in the quest rewards list
--- @return string, string, string, string - Formatted item name, texture, description text, quantity
--- @usage Called when displaying quest reward items
---
local function kQuestGetItemInf(count)
    -- Local AtlasCFM
    local instance = AtlasCFM.QCurrentInstance
    local faction = AtlasCFM.Faction

    -- Validate input parameters
    if not count or count < 1 then
        return nil
    end

    -- Get quest data from new database structure
    local questData = AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][AtlasCFM.QCurrentQuest]

    if not questData or not questData.Rewards then
        return nil
    end

    -- Get the specific reward item by index
    local rewardItem = questData.Rewards[count]
    if not rewardItem then
        return nil
    end

    -- Extract item data from the new structure
    local itemId = rewardItem.id
    local itemDescription = AtlasCFM.ItemDB.ParseTooltipForItemInfo(itemId, rewardItem.desc)
    local itemName = grey .. L["Item not found in cache"]
    local itemQuantity = rewardItem.quantity or ""

    -- Try to get item info from the game
    if itemId and GetItemInfo(itemId) then
        -- Item exists in cache, format with proper quality color
        local gameItemName, _, itemQuality, _, _, _, _, _, itemTexture = GetItemInfo(itemId or 0)
        local _, _, _, hex = GetItemQualityColor(itemQuality)
        local itemtext = hex .. gameItemName

        -- Return requested information type
        return itemtext, itemTexture, itemDescription, itemQuantity
    else
        -- A cache miss while an asynchronous request is still live is a loading
        -- state, not an unsafe item. Keep the old warning only when no request
        -- is pending (for example an invalid/stale item ID or a timed-out load).
        local isPending = itemId and AtlasCFM.LootCache and AtlasCFM.LootCache.IsPending
            and AtlasCFM.LootCache.IsPending(itemId)
        if itemId and not isPending then
            itemDescription = itemDescription .. " " .. red .. L["This item is not safe!"]
        end
        return itemName, "Interface\\Icons\\INV_Misc_QuestionMark", itemDescription, itemQuantity
    end
end

---
--- Populates the quest reward items frame with icons, names and tooltips
--- Retrieves reward data for the current quest and updates up to 6 item slots
--- @return nil
--- @usage Called from AtlasCFM.Quest.SetQuestText when rewards are present
---
local function setQuestItemsFrame()
    local instanceData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance]
    if not instanceData then return end
    local faction = AtlasCFM.Faction
    local questData = instanceData[faction] and instanceData[faction][AtlasCFM.QCurrentQuest]
    if not questData or not questData.Rewards then return end
    -- Local AtlasCFM for item information
    local itemName, itemTexture, itemDiscription, itemQuantity
    -- Process each potential quest reward item (up to 6)
    for itemIndex = 1, AtlasCFM.QMAXQUESTITEMS do
        if questData.Rewards[itemIndex] then
            --Get item information
            itemName, itemTexture, itemDiscription, itemQuantity = kQuestGetItemInf(itemIndex)
            -- Set item texture
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Icon:SetTexture(itemTexture)
            -- Set item name and description
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Name:SetText(itemName)
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Extra:SetText(itemDiscription)
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Quantity:SetText(itemQuantity)
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Frame:Show()
        else
            -- hide item slot if no data
            AtlasCFM.Quest.UI.QuestItems[itemIndex].Frame:Hide()
        end
    end
end

--- Repaint only the currently open quest's reward items after asynchronous
--- item data arrives. This deliberately avoids SetQuestText(), which would
--- queue the same cache work again and could create a refresh loop.
function AtlasCFM.Quest.RefreshQuestItems()
    if not AtlasCFM.Quest.UI or not AtlasCFM.Quest.UI.InsideAtlasFrame then return end
    if not AtlasCFM.Quest.UI.InsideAtlasFrame:IsVisible() then return end
    if not AtlasCFM.QCurrentQuest or AtlasCFM.QCurrentButton ~= AtlasCFM.QCurrentQuest then return end
    setQuestItemsFrame()
end

-----------------------------------------------------------------------------
-- set the Quest text
-- executed when you push a button
-----------------------------------------------------------------------------
---
--- Sets up quest text display in the quest details frame
--- Handles multi-page quest descriptions and story text
--- @return nil
--- @usage Called when displaying quest information
---
function AtlasCFM.Quest.SetQuestText()
    -- Clear all previous quest information
    AtlasCFM.Quest.ClearAll()
    local color = AtlasCFM.isHorde and redHorde or blue
    -- Show the finished quest checkbox
    AtlasCFM.Quest.UI.FinishedQuestCheckbox:Show()
    AtlasCFM.Quest.UI.FinishedQuestText:SetText(color .. L["Quest finished:"])

    -- Get quest data from new structure
    local instanceData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance]
    if not instanceData then return end

    local faction = AtlasCFM.Faction
    local questData = instanceData[faction] and instanceData[faction][AtlasCFM.QCurrentQuest]

    if questData then
        -- Set quest name with appropriate color
        AtlasCFM.Quest.UI.QuestName:SetText(kQQuestColor .. questData.Title)

        -- Set quest level information
        AtlasCFM.Quest.UI.QuestLevel:SetText(color .. L["Level: "] .. white .. questData.Level)
        AtlasCFM.Quest.UI.QuestAttainLevel:SetText(color .. L["Attain: "] .. white .. questData.Attain)

        -- Set quest details
        AtlasCFM.Quest.UI.Prerequisite:SetText(
            color .. L["Prequest: "] .. white .. (questData.Prequest or L["No"]) .. "\n \n" ..
            color .. L["Quest follows: "] .. white .. (questData.Folgequest or L["No"]) .. "\n \n" ..
            color .. L["Starts at: \n"] .. white .. (questData.Location or "") .. "\n \n" ..
            color .. L["Objective: \n"] .. white .. (questData.Aim or "") .. "\n \n" ..
            color .. L["Note: \n"] .. white .. (questData.Note or "")
        )

        -- Set reward text from structure if available
        local rewards = questData.Rewards and questData.Rewards.Text
        if rewards then
            rewards = color .. rewards
            -- Cache entire page before updating
            if AtlasCFMOptions.QuestAutoQuery then
                AtlasCFM.LootCache.CacheAllItems(questData.Rewards, function()
                    setQuestItemsFrame()
                end)
            else
                setQuestItemsFrame()
            end
        else
            rewards = color .. L["No Rewards"]
            -- hide items frame if no rewards are available
            for itemIndex = 1, AtlasCFM.QMAXQUESTITEMS do
                AtlasCFM.Quest.UI.QuestItems[itemIndex].Frame:Hide()
            end
        end
        AtlasCFM.Quest.UI.Rewards:SetText(rewards)
    end

    -- Update finished quest checkbox state
    kQuestFinishedSetChecked()

    -- Check for and setup multi-page quest text
    kQuestExtendedPages()
end

---
--- Sets up story text display in the quest frame
--- Displays lore and background information for the current instance
--- @return nil
--- @usage Called when story button is clicked
---
function AtlasCFM.Quest.SetStoryText()
    -- Clear display
    AtlasCFM.Quest.ClearAll()

    local instanceData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance]
    local story = instanceData and instanceData.Story
    local caption = instanceData and instanceData.Caption

    -- Show story text if available
    if story then
        if type(story) == "table" then
            -- Display first page of multi-page story
            AtlasCFM.Quest.UI.QuestName:SetText(blue .. caption[1])
            AtlasCFM.Quest.UI.Story:SetText(white .. story["Page1"])

            -- Show navigation buttons if more than one page
            if story["Page2"] then
                AtlasCFM.Quest.UI.NextPageButtonRight:Show()
                AtlasCFM.QCurrentPage = 1

                -- Show page counter
                local maxPages = story["MaxPages"] or 0
                for i = 1, 20 do -- Reasonable upper limit
                    if not story["Page" .. i] then
                        maxPages = i - 1
                        break
                    end
                end
                AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. maxPages)

                -- Set page type
                AtlasCFM.Quest.NextPageCount = "Story"
            end
        elseif type(story) == "string" then
            -- Display single page story
            AtlasCFM.Quest.UI.QuestName:SetText(blue .. caption)
            AtlasCFM.Quest.UI.Story:SetText(white .. story)
        end
    else
        -- No story available
        AtlasCFM.Quest.UI.QuestName:SetText(L["Not Available"])
        AtlasCFM.Quest.UI.Story:SetText(L["Not Available"])
    end
end

-----------------------------------------------------------------------------
-- Loads the saved AtlasCFM
-----------------------------------------------------------------------------
---
--- Loads and displays finished quests for the current map
--- Filters quests based on faction and completion status
--- @return nil
--- @usage Called when loading quest data for a map
---
function AtlasCFM.Quest.LoadFinishedQuests()
    AtlasCFMCharDB = AtlasCFMCharDB or {}
    AtlasCFM.Q = AtlasCFM.Q or {}

    -- Iterate over all known instances from the new database
    if AtlasCFM.InstanceData then
        for instanceName, _ in pairs(AtlasCFM.InstanceData) do
            for _, faction in ipairs({ "_Alliance", "_Horde" }) do
                for questId = 1, AtlasCFM.QMAXQUESTS do
                    local key = "Completed_" .. instanceName .. "_Quest_" .. questId .. faction
                    if AtlasCFMCharDB[key] then
                        AtlasCFM.Q[key] = AtlasCFMCharDB[key]
                    end
                end
            end
        end
    end
end

--******************************************
-- Events: OnUpdate
--******************************************
---
--- Updates the quest display with current quest data
--- Refreshes quest buttons and handles page navigation
--- @return nil
--- @usage Called when quest data changes or page is switched
---
function AtlasCFM.Quest.Update()
    -- Update instance information
    AtlasCFM.QCurrentInstance = AtlasCFM.CurrentMap or ""
    -- Check if we need to hide/update the quest panels
    if AtlasCFM.QCurrentInstance == "" then
        AtlasCFM.Quest.UI_Main.Frame:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    else
        AtlasCFM.Quest.SetQuestButtons()
    end
end

---
--- Sets up quest buttons with current quest data
--- Configures button text, colors, and click handlers
--- @return nil
--- @usage Called when refreshing quest display
---
function AtlasCFM.Quest.SetQuestButtons()
    local instance = AtlasCFM.QCurrentInstance
    local faction = AtlasCFM.Faction
    local questName
    local playerLevel = UnitLevel("player")
    -- Hide inner frame if instance changed
    if kQuestInstChanged ~= instance then
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    end
    -- Update current instance
    kQuestInstChanged = instance
    -- Set quest count text
    local questCount = AtlasCFM.Quest.DataBase[instance] and AtlasCFM.Quest.DataBase[instance][faction]
        and getn(AtlasCFM.Quest.DataBase[instance][faction])
    if questCount then
        if questCount == 1 then
            questCount = "1 " .. L["Quest"]
        elseif questCount == 0 then
            questCount = nil
        else
            questCount = questCount .. " " .. L["Quests"]
        end
    end
    -- Process quests
    local uiIndex = 1
    local visibleQuestCount = 0

    for b = 1, AtlasCFM.QMAXQUESTS do
        -- Check for quest existence and server visibility
        local questData = AtlasCFM.Quest.DataBase[instance] and AtlasCFM.Quest.DataBase[instance][faction] and
            AtlasCFM.Quest.DataBase[instance][faction][b]

        if questData and AtlasCFM.Server.IsVisible(questData) then
            visibleQuestCount = visibleQuestCount + 1

            if uiIndex <= AtlasCFM.QMAXQUESTS then
                local finishedKey = "Completed_" .. instance .. "_Quest_" .. b .. "_" .. faction
                questName = questData.Title
                local followQuest = questData.Folgequest
                local preQuest = questData.Prequest
                local questLevel = tonumber(questData.Level)

                -- Set quest line arrows
                local arrowTexture
                if preQuest and preQuest ~= L["No"] then
                    arrowTexture = "Interface\\Glues\\Login\\UI-BackArrow"
                elseif followQuest and followQuest ~= L["No"] then
                    arrowTexture = "Interface\\GossipFrame\\PetitionGossipIcon"
                end

                -- Determine quest color based on level
                if questLevel then
                    local levelDiff = questLevel - playerLevel
                    if levelDiff >= -2 and levelDiff <= 2 then
                        kQQuestColor = yellow
                    elseif levelDiff > 2 and levelDiff <= 4 then
                        kQQuestColor = orange
                    elseif levelDiff > 4 and questLevel ~= 100 then
                        kQQuestColor = red
                    elseif levelDiff < -7 then
                        kQQuestColor = grey
                    elseif levelDiff >= -7 and levelDiff < -2 then
                        kQQuestColor = green
                    end

                    if not AtlasCFMOptions.QuestColourCheck then
                        kQQuestColor = yellow
                    end

                    if questLevel == 100 or kQCompareQuestLogtoQuest(b) then
                        kQQuestColor = blue
                        arrowTexture = "Interface\\QuestFrame\\UI-QuestLog-BookIcon"
                    end

                    if AtlasCFM.Q[finishedKey] == 1 then
                        kQQuestColor = white
                    end
                end

                if AtlasCFM.Q[finishedKey] == 1 then
                    arrowTexture = "Interface\\Buttons\\UI-CheckBox-Check"
                end

                local buttonFrame = AtlasCFM.Quest.UI_Main.QuestButtons[uiIndex]
                local arrow = buttonFrame.Arrow
                if arrowTexture then
                    arrow:SetTexture(arrowTexture)
                    arrow:Show()
                else
                    arrow:Hide()
                end

                buttonFrame.Button:Enable()
                -- Important: store the original quest index 'b' in the button so AtlasCFM.Quest.OnQuestClick knows which quest was clicked
                buttonFrame.Button:SetID(b)
                buttonFrame.Text:SetText(kQQuestColor .. visibleQuestCount .. ") " .. questName)

                uiIndex = uiIndex + 1
            end
        end
    end

    -- Update quest count text
    local questCountText
    if visibleQuestCount > 0 then
        if visibleQuestCount == 1 then
            questCountText = "1 " .. L["Quest"]
        else
            questCountText = visibleQuestCount .. " " .. L["Quests"]
        end
    else
        questCountText = L["No Quests"]
    end
    AtlasCFM.Quest.UI_Main.QuestCounter:SetText(questCountText)

    -- Deactivate remaining buttons
    for i = uiIndex, AtlasCFM.QMAXQUESTS do
        local buttonFrame = AtlasCFM.Quest.UI_Main.QuestButtons[i]
        buttonFrame.Button:Disable()
        buttonFrame.Button:SetID(0)
        buttonFrame.Text:SetText()
        buttonFrame.Arrow:Hide()
    end
end

-- Show version message
DEFAULT_CHAT_FRAME:AddMessage(red ..
    "A" ..
    yellow ..
    "t" ..
    green ..
    "l" .. orange .. "a" ..
    blue .. "s" .. white .. "-|cff800080TW |cff00FFFFv.|cffFFC0CB" .. AtlasCFM.Version .. L[" |cffA52A2Aloaded."])
