---
--- QuestLogic.lua - Atlas quest logic and event handling
---
--- This file contains the quest logic and event handling for Atlas-CFM.
--- It handles quest item interactions, tooltip management, quest reward display,
--- and provides the core logic for quest-related UI interactions.
---
--- Features:
--- - Quest item event handling
--- - Tooltip management for quest items
--- - Quest reward display logic
--- - Mouse interaction handling
--- - Quest data processing
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()

local LU = AtlasCFM.Localization.UI

AtlasCFM = _G.AtlasCFM
local Colors = AtlasCFM.Colors


---
--- Handles mouse enter event for quest reward items
--- Displays detailed tooltip information when the mouse enters a quest reward item
--- @param itemIndex number Index of the reward item (1-6)
--- @return nil
--- @usage Called automatically on mouse enter event
---
function AtlasCFM.Quest.OnItemEnter(itemIndex)
    if not itemIndex then
        return PrintA("AtlasCFM.Quest.OnItemEnter failed itemIndex!")
    end
    local frame = this
    -- Get the frame that triggered this event
    if not frame then
        return PrintA("AtlasCFM.Quest.OnItemEnter failed frame and name!")
    end
    -- Get current quest data
    local instance = AtlasCFM.QCurrentInstance
    local faction = AtlasCFM.Faction

    -- Get quest data from new database structure
    local questData = AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][AtlasCFM.QCurrentQuest]

    if not questData or not questData.Rewards then
        return
    end

    -- Get the specific reward item by index
    local rewardItem = questData.Rewards[itemIndex]
    if not rewardItem then
        return
    end

    -- Extract item data
    local itemId = rewardItem.id

    -- Set up tooltip
    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", -(frame:GetWidth() / 2), 24)
    GameTooltip:SetHyperlink("item:" .. itemId .. ":0:0:0")
    GameTooltip:Show()
end

---
--- Handles mouse leave event for quest reward items
--- Hides the tooltip when the mouse leaves a quest reward item
--- @return nil
--- @usage Called automatically on mouse leave event
---
function AtlasCFM.Quest.OnItemLeave()
    GameTooltip:Hide()
end

---
--- Handles mouse click events on quest reward items
--- Processes clicks on quest reward items for various actions like linking to chat
--- @param mouseButton string Mouse button pressed ("LeftButton", "RightButton")
--- @param itemIndex number Index of the clicked reward item (1-6)
--- @return nil
--- @usage Called automatically on item click event
---
function AtlasCFM.Quest.OnItemClick(mouseButton, itemIndex)
    if not itemIndex then
        return PrintA("AtlasCFM.Quest.OnItemClick failed itemIndex!")
    end
    local frame = this
    if not frame then
        return PrintA("AtlasCFM.Quest.OnItemClick failed frame or name!")
    end
    -- Get current quest data
    local instance = AtlasCFM.QCurrentInstance
    local faction = AtlasCFM.Faction

    -- Get quest data from new database structure
    local questData = AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][AtlasCFM.QCurrentQuest]

    if questData and not questData.Rewards then
        return
    end

    -- Get the specific reward item by index
    local rewardItem = questData.Rewards[itemIndex]
    if not rewardItem then
        return
    end

    -- Extract item data
    local itemId = rewardItem.id

    -- Handle right click - search in pfQuest
    if mouseButton == "RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() then
        local itemName = GetItemInfo(itemId)
        if itemName then
            AtlasCFM.Integrations.SearchPfQuest(itemName)
        end
        return
    end

    -- Handle shift click - insert item link
    if IsShiftKeyDown() then
        local itemName, _, itemQuality = GetItemInfo(itemId)
        if itemName then
            local _, _, _, hex = GetItemQualityColor(itemQuality)
            local itemLink = string.format("%s|Hitem:%d:0:0:0|h[%s]|h|r",
                hex, itemId, itemName)
            if WIM_EditBoxInFocus then
                WIM_EditBoxInFocus:Insert(itemLink)
            elseif MessageBox and MessageBox.isInputFocused and MessageBox.whisperInput then
                MessageBox.whisperInput:Insert(itemLink)
            else
                ChatFrameEditBox:Insert(itemLink)
            end
        else
            ChatFrameEditBox:Insert(string.format("%s [%s]", Colors.GREY2, LU["Item not found in cache"]))
        end
        return
    end
    -- Handle control click - dress up item
    if IsControlKeyDown() and GetItemInfo(itemId) then
        DressUpItemLink(itemId)
        return
    end
end

---
--- Closes the quest details frame
--- Hides the quest information display and resets current button state
--- @return nil
--- @usage Called when closing quest details
---
function AtlasCFM.Quest.CloseDetails()
    AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    AtlasCFM.QCurrentButton = 0
    AtlasCFM.Quest.ClearAll()
end

---
--- Inserts a quest link into the chat frame
--- Creates a clickable quest link for sharing with other players
--- @return nil
--- @usage Called internally when Shift+clicking quest buttons
---
local function AtlasCFMQuestInsertQuestLink()
    local questID = AtlasCFM.QCurrentQuest
    local instance = AtlasCFM.QCurrentInstance
    local faction = AtlasCFM.Faction

    local questData = AtlasCFM.Quest.DataBase and
        AtlasCFM.Quest.DataBase[instance] and
        AtlasCFM.Quest.DataBase[instance][faction] and
        AtlasCFM.Quest.DataBase[instance][faction][questID]

    if questData and questData.Title then
        local questName = questData.Title
        --        local levelPattern = "^%d+%) "
        --        questName = string.gsub(questName, levelPattern, "")
        if pfQuestCompat then
            pfQuestCompat.InsertQuestLink(0, questName)
        else
            ChatFrameEditBox:Insert("[" .. questName .. "]")
        end
    end
end


---
--- Hides the highlight textures and unlocks the highlight for all quest buttons.
---
--- @return nil
--- @usage Called internally by other quest logic functions to reset button states.
---
function AtlasCFM.Quest.HideQuestButtonHighlights()
    for i = 1, AtlasCFM.QMAXQUESTS do
        local b = AtlasCFM.Quest.UI_Main.QuestButtons[i].Button
        --local h = b:GetHighlightTexture()
        --h:Hide()
        b:UnlockHighlight()
    end
end

---
--- Handles click events on quest buttons
--- Toggles quest details display or inserts quest link to chat if Shift is held
--- @param questIndex number Index of the clicked quest button
--- @return nil
--- @usage Called automatically when quest button is clicked
---
function AtlasCFM.Quest.OnQuestClick(questIndex, button)
    if not questIndex then return PrintA("AtlasCFM.Quest.OnQuestClick without questIndex.") end
    AtlasCFM.QCurrentQuest = questIndex
    if not AtlasCFM.Quest.UI or not AtlasCFM.Quest.UI.InsideAtlasFrame then
        return PrintA("AtlasCFM.Quest.OnQuestClick: Quest UI not fully loaded.")
    end

    -- Handle Right Click - Show in pfQuest
    if button == "RightButton" then
        local questData = AtlasCFM.Quest.DataBase and
            AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance] and
            AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance][AtlasCFM.Faction] and
            AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance][AtlasCFM.Faction][questIndex]

        if questData and questData.Title then
            AtlasCFM.Integrations.ShowQuestInPfQuest(questData.Title, questData.Id)
        end
        return
    end

    if ChatFrameEditBox:IsVisible() and IsShiftKeyDown() then
        AtlasCFMQuestInsertQuestLink()
    else
        AtlasCFM.Quest.HideAtlasCFMLootFrame()
        AtlasCFM.Quest.UI.Story:SetText("")
        local button = this
        local highlightTexture = button:GetHighlightTexture()
        AtlasCFM.Quest.HideQuestButtonHighlights()
        if AtlasCFM.Quest.UI.InsideAtlasFrame:IsVisible() and AtlasCFM.QCurrentButton == AtlasCFM.QCurrentQuest then
            AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
            AtlasCFM.QCurrentButton = nil
        else
            AtlasCFM.Quest.UI.InsideAtlasFrame:Show()
            AtlasCFM.QCurrentButton = AtlasCFM.QCurrentQuest
            AtlasCFM.Quest.SetQuestText()
            highlightTexture:Show()
            button:LockHighlight()
        end
    end
end

---
--- Toggles the finished status of the current quest
--- Updates quest completion state and saves it to character database
--- @return nil
--- @usage Called when finished quest checkbox is clicked
---
function AtlasCFM.Quest.ToggleFinishedFilter()
    -- Build the quest key based on faction
    local questKey = "Completed_" .. AtlasCFM.QCurrentInstance .. "_Quest_" .. AtlasCFM.QCurrentQuest
    questKey = questKey .. (AtlasCFM.isHorde and "_Horde" or "_Alliance")
    -- Update quest completion status
    AtlasCFM.Q[questKey] = AtlasCFM.Quest.UI.FinishedQuestCheckbox:GetChecked() and 1 or nil
    -- Save to player options
    AtlasCFMCharDB[questKey] = AtlasCFM.Q[questKey]
    -- Update UI
    AtlasCFM.Quest.SetQuestButtons()
    AtlasCFM.Quest.SetQuestText()
end

---
--- Advances to the next page of quest or story content
--- Handles both story pages and multi-page quest descriptions
--- @return nil
--- @usage Called when next page button is clicked
---
function AtlasCFM.Quest.NextPage()
    local SideAfterThis = AtlasCFM.QCurrentPage + 2
    AtlasCFM.QCurrentPage = AtlasCFM.QCurrentPage + 1

    -- Clear display
    AtlasCFM.Quest.ClearAll()

    -- Handle story text pages
    if AtlasCFM.Quest.NextPageCount == "Story" then
        local story = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Story
        local caption = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Caption

        if type(story) == "table" then
            -- Display current page content
            AtlasCFM.Quest.UI.Story:SetText(Colors.WHITE .. story["Page" .. AtlasCFM.QCurrentPage])
            AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. story["MaxPages"])

            -- Handle page-specific captions if available
            local pageCaption = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Caption[AtlasCFM.QCurrentPage]
            AtlasCFM.Quest.UI.QuestName:SetText(Colors.BLUE .. (pageCaption or caption))

            -- Hide next button if we're on the last page
            if not story["Page" .. SideAfterThis] then
                AtlasCFM.Quest.UI.NextPageButtonRight:Hide()
            else
                AtlasCFM.Quest.UI.NextPageButtonRight:Show()
            end
        end
    end

    -- Handle quest text pages
    if AtlasCFM.Quest.NextPageCount == "Quest" then
        local faction = AtlasCFM.Faction
        local questData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance][faction][AtlasCFM.QCurrentQuest]

        -- Check for Page
        if questData and questData.Page then
            local pageContent = questData.Page[AtlasCFM.QCurrentPage]
            local pageCount = questData.Page[1] or 1

            if pageContent then
                AtlasCFM.Quest.UI.Story:SetText(Colors.WHITE .. pageContent)
                AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. pageCount)

                -- Hide next button if we're on the last page
                if AtlasCFM.QCurrentPage >= pageCount then
                    AtlasCFM.Quest.UI.NextPageButtonRight:Hide()
                else
                    AtlasCFM.Quest.UI.NextPageButtonRight:Show()
                end
            end
        end
    end
    -- Show back button
    AtlasCFM.Quest.UI.NextPageButtonLeft:Show()
end

---
--- Goes back to the previous page of quest or story content
--- Handles both story pages and multi-page quest descriptions
--- @return nil
--- @usage Called when previous page button is clicked
---
---
--- Goes back to the previous page of quest or story content
--- Handles both story pages and multi-page quest descriptions
--- @return nil
--- @usage Called when previous page button is clicked
---
function AtlasCFM.Quest.PreviousPage()
    AtlasCFM.QCurrentPage = AtlasCFM.QCurrentPage - 1

    -- Handle story text pages
    if AtlasCFM.Quest.NextPageCount == "Story" then
        local story = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Story
        local caption = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Caption

        if type(story) == "table" then
            -- Display current page content
            AtlasCFM.Quest.UI.Story:SetText(Colors.WHITE .. story["Page" .. AtlasCFM.QCurrentPage])
            AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. story["MaxPages"])

            -- Handle page-specific captions if available
            local pageCaption = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance].Caption[AtlasCFM.QCurrentPage]
            AtlasCFM.Quest.UI.QuestName:SetText(Colors.BLUE .. (pageCaption or caption))

            -- Hide back button if we're on the first page
            if AtlasCFM.QCurrentPage == 1 then
                AtlasCFM.Quest.UI.NextPageButtonLeft:Hide()
            end
        end
    end
    -- Handle quest text pages
    if AtlasCFM.Quest.NextPageCount == "Quest" then
        local faction = AtlasCFM.Faction
        local questData = AtlasCFM.Quest.DataBase[AtlasCFM.QCurrentInstance][faction][AtlasCFM.QCurrentQuest]
        -- Go back to main quest text if we're returning to page 1
        if AtlasCFM.QCurrentPage == 1 then
            AtlasCFM.Quest.SetQuestText()
        else
            -- Check for Page
            if questData and questData.Page then
                local pageContent = questData.Page[AtlasCFM.QCurrentPage]
                local pageCount = questData.Page[1] or 1
                if pageContent then
                    AtlasCFM.Quest.UI.Story:SetText(Colors.WHITE .. pageContent)
                    AtlasCFM.Quest.UI.PageCount:SetText(AtlasCFM.QCurrentPage .. "/" .. pageCount)
                end
            end
        end
    end
    -- Always show next button when going back
    AtlasCFM.Quest.UI.NextPageButtonRight:Show()
end

---
--- Handles the quest frame show event
--- Initializes faction checkboxes and refreshes quest buttons
--- @return nil
--- @usage Called automatically when quest frame is shown
---
---
--- Handles the quest frame show event
--- Initializes faction checkboxes and refreshes quest buttons
--- @return nil
--- @usage Called automatically when quest frame is shown
---
function AtlasCFM.Quest.OnQuestFrameShow()
    if not AtlasCFM.Quest.UI_Main then
        return PrintA("AtlasCFM.Quest.OnQuestFrameShow: Quest UI not fully loaded.")
    end

    if AtlasCFM.isHorde then
        AtlasCFM.Quest.UI_Main.HordeButton:SetAlpha(1.0)
        AtlasCFM.Quest.UI_Main.AllianceButton:SetAlpha(0.5)
    else
        AtlasCFM.Quest.UI_Main.HordeButton:SetAlpha(0.5)
        AtlasCFM.Quest.UI_Main.AllianceButton:SetAlpha(1.0)
    end

    AtlasCFM.Quest.SetQuestButtons()
end

---
--- Handles click events on the story button
--- Toggles story text display in the quest details frame
--- @return nil
--- @usage Called when story button is clicked
---
---
--- Handles click events on the story button
--- Toggles story text display in the quest details frame
--- @return nil
--- @usage Called when story button is clicked
---
function AtlasCFM.Quest.OnStoryClick()
    AtlasCFM.Quest.HideAtlasCFMLootFrame()
    if not AtlasCFM.Quest.UI.InsideAtlasFrame:IsVisible() then
        AtlasCFM.Quest.UI.InsideAtlasFrame:Show()
        AtlasCFM.QCurrentButton = -1
        AtlasCFM.Quest.SetStoryText()
    elseif AtlasCFM.QCurrentButton == -1 then
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    else
        AtlasCFM.QCurrentButton = -1
        AtlasCFM.Quest.SetStoryText()
    end
end

---
--- Handles click events on the Alliance faction button
--- Switches to Alliance faction and refreshes quest display
--- @return nil
--- @usage Called when Alliance checkbox is clicked
---
---
--- Handles click events on the Alliance faction button
--- Switches to Alliance faction and refreshes quest display
--- @return nil
--- @usage Called when Alliance checkbox is clicked
---
function AtlasCFM.Quest.OnAllianceClick()
    if not AtlasCFM.Quest.UI_Main then
        return PrintA("AtlasCFM.Quest.OnAllianceClick: Quest UI not fully loaded.")
    end
    AtlasCFM.isHorde = false
    AtlasCFM.Faction = "Alliance"
    AtlasCFM.Quest.UI_Main.AllianceButton:SetAlpha(1.0)
    AtlasCFM.Quest.UI_Main.HordeButton:SetAlpha(0.5)
    AtlasCFM.Quest.CloseDetails()
    AtlasCFM.OptionsInit()
    AtlasCFM.Quest.SetQuestButtons()
end

---
--- Handles click events on the Horde faction button
--- Switches to Horde faction and refreshes quest display
--- @return nil
--- @usage Called when Horde checkbox is clicked
---
function AtlasCFM.Quest.OnHordeClick()
    if not AtlasCFM.Quest.UI_Main then
        return PrintA("AtlasCFM.Quest.OnHordeClick: Quest UI not fully loaded.")
    end
    AtlasCFM.isHorde = true
    AtlasCFM.Faction = "Horde"
    AtlasCFM.Quest.UI_Main.AllianceButton:SetAlpha(0.5)
    AtlasCFM.Quest.UI_Main.HordeButton:SetAlpha(1.0)
    AtlasCFM.Quest.CloseDetails()
    AtlasCFM.OptionsInit()
    AtlasCFM.Quest.SetQuestButtons()
end

---
--- Closes the quest frame and updates options
--- Toggles quest display option and hides all quest UI elements
--- @return nil
--- @usage Called when quest frame close button is clicked
---
---
--- Closes the quest frame and updates options
--- Toggles quest display option and hides all quest UI elements
--- @return nil
--- @usage Called when quest frame close button is clicked
---
function AtlasCFM.Quest.CloseQuestFrame()
    AtlasCFMOptions.QuestWithAtlas = not AtlasCFMOptions.QuestWithAtlas
    AtlasCFM.Quest.UI_Main.Frame:Hide()
    AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    AtlasCFMOptionAutoshow:SetChecked(AtlasCFMOptions.QuestWithAtlas)
    AtlasCFM.Quest.CloseDetails()
    AtlasCFM.OptionsInit()
end

---
--- Toggles the visibility of the main quest frame
--- Shows or hides the quest UI based on current state
--- @return nil
--- @usage Called when quest frame toggle button is clicked
---
---
--- Toggles the visibility of the main quest frame
--- Shows or hides the quest UI based on current state
--- @return nil
--- @usage Called when quest frame toggle button is clicked
---
function AtlasCFM.Quest.ToggleQuestFrame()
    AtlasCFMOptions.QuestWithAtlas = not AtlasCFMOptions.QuestWithAtlas
    if not AtlasCFMOptions.QuestWithAtlas then
        AtlasCFM.Quest.UI_Main.Frame:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
    else
        AtlasCFM.Quest.UI_Main.Frame:Show()
    end
    AtlasCFMOptionAutoshow:SetChecked(AtlasCFMOptions.QuestWithAtlas)
    AtlasCFM.Quest.ClearAll()
    AtlasCFM.OptionsInit()
end

local SearchPattern = gsub(ERR_QUEST_COMPLETE_S, "%%s", "(.+)")

---
--- Marks a quest as completed by name
--- @param questName string The name of the completed quest
--- @return nil
---
function AtlasCFM.Quest.MarkQuestComplete(questName)
    if not questName or not AtlasCFM.Quest.DataBase then return end

    local found = false
    -- We need to check both factions because the player might be tracking quests for the other faction
    -- or the DB might be structured in a way where we need to search all.
    -- However, usually we only care about the current faction's quests.
    -- But let's be safe and check all instances.

    for instanceName, instanceData in pairs(AtlasCFM.Quest.DataBase) do
        for _, faction in ipairs({ "Alliance", "Horde" }) do
            if instanceData[faction] then
                for i, quest in ipairs(instanceData[faction]) do
                    -- Check exact match
                    local match = (quest.Title == questName)

                    -- Check with number stripping if exact match failed
                    if not match then
                        -- Escape special characters in title for pattern matching
                        local escapedTitle = string.gsub(quest.Title, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
                        -- Check if questName matches "1. Title" pattern
                        if string.find(questName, "^%d+%.%s*" .. escapedTitle .. "$") then
                            match = true
                        end
                        -- Check if Title matches "1. questName" (unlikely but possible)
                        if string.find(quest.Title, "^%d+%.%s*" .. string.gsub(questName, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1") .. "$") then
                            match = true
                        end
                    end

                    if match then
                        local questKey = "Completed_" .. instanceName .. "_Quest_" .. i .. "_" .. faction
                        AtlasCFMCharDB[questKey] = 1
                        AtlasCFM.Q[questKey] = 1
                        if AtlasCFM.QCurrentInstance == instanceName then
                            found = true
                        end
                        break
                    end
                end
            end
        end
    end

    if found then
        AtlasCFM.Quest.SetQuestButtons()
    end
end

---
--- Marks a quest as completed by ID
--- @param questID number The ID of the completed quest
--- @return nil
---
function AtlasCFM.Quest.MarkQuestCompleteByID(questID)
    if not questID or not AtlasCFM.Quest.DataBase then return end

    local needsUIUpdate = false

    for instanceName, instanceData in pairs(AtlasCFM.Quest.DataBase) do
        for _, factionName in ipairs({ "Alliance", "Horde" }) do
            if instanceData[factionName] then
                for i, quest in ipairs(instanceData[factionName]) do
                    if quest.Id == questID then
                        local questKey = "Completed_" .. instanceName .. "_Quest_" .. i .. "_" .. factionName
                        AtlasCFMCharDB[questKey] = 1
                        AtlasCFM.Q[questKey] = 1

                        if AtlasCFM.QCurrentInstance == instanceName then
                            needsUIUpdate = true
                        end
                        break -- Found for this faction, move to next
                    end
                end
            end
        end
    end

    if needsUIUpdate then
        AtlasCFM.Quest.SetQuestButtons()
    end
end

---
--- Handles quest-related game events and initialization
--- Loads finished quests and configures tooltip settings
--- @return nil
--- @usage Called automatically when the player starts the game
---
function AtlasCFM.Quest.OnEvent(event, arg1, arg2, arg3)
    if not event and this then event = this.event end -- Fallback if not passed

    if event == "PLAYER_ENTERING_WORLD" then
        if type(AtlasCFMCharDB) == "table" then
            AtlasCFM.Quest.LoadFinishedQuests()
        else
            PrintA(Colors.GREEN .. "Atlas-CFM Quest:|r|cff00ffffAtlasCFM not loaded!|r")
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        if (arg1 and strfind(arg1, SearchPattern)) then
            local _, _, questName = strfind(arg1, SearchPattern)
            AtlasCFM.Quest.MarkQuestComplete(questName)
        end
    elseif event == "CHAT_MSG_ADDON" and arg1 == "TWQUEST" then
        -- Parse IDs from arg2 (space separated)
        if arg2 then
            for id in string.gfind(arg2, "%S+") do
                local questID = tonumber(id)
                if questID then
                    AtlasCFM.Quest.MarkQuestCompleteByID(questID)
                end
            end
        end
    end
end
