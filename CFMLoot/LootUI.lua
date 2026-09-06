---
--- LootUI.lua - Atlas loot UI frame and component management
---
--- This file contains the loot UI frame creation and management for Atlas-CFM.
--- It handles loot window interface, item display components, frame templates,
--- and provides the visual foundation for the Atlas loot browser system.
---
--- Features:
--- - Loot frame creation and styling
--- - Item display templates
--- - UI component initialization
--- - Frame positioning and layout
--- - Loot interface management
---
--- @compatible World of Warcraft 1.12
---

local L = (AtlasCFM.Localization and AtlasCFM.Localization.UI) or {}
local Colors = AtlasCFM.Colors or {}

local function AtlasCFMLoot_ClosePredictDropdown(searchBox)
    if not searchBox then return end
    if searchBox._predictDrop then
        searchBox._predictDrop:Hide()
    end
    searchBox._predictSuggestions = nil
    searchBox._predictSelectedIndex = nil
end

local function AtlasCFMLoot_OpenPredictDropdown(searchBox)
    if not searchBox or not searchBox._predictDrop then return end
    if not searchBox._predictSuggestions or table.getn(searchBox._predictSuggestions) == 0 then
        AtlasCFMLoot_ClosePredictDropdown(searchBox)
        return
    end
    searchBox._predictDrop:Show()
end

local function AtlasCFMLoot_UpdatePredictDropdown(searchBox)
    if not searchBox or not searchBox._predictDrop then return end
    local drop = searchBox._predictDrop
    local suggestions = searchBox._predictSuggestions or {}
    local maxLines = drop._maxLines or 10
    local count = table.getn(suggestions)
    if count == 0 then
        AtlasCFMLoot_ClosePredictDropdown(searchBox)
        return
    end
    for i = 1, maxLines do
        local b = drop._buttons[i]
        local s = suggestions[i]
        if s then
            b._entry = s
            b:Show()
            b.text:SetText(s.displayText or "")
            if searchBox._predictSelectedIndex == i then
                b.highlight:Show()
            else
                b.highlight:Hide()
            end
        else
            b._entry = nil
            b:Hide()
        end
    end
    local visible = math.min(count, maxLines)
    drop:SetHeight(visible * 16 + 10)
    AtlasCFMLoot_OpenPredictDropdown(searchBox)
end

local function AtlasCFMLoot_BuildPredictSuggestionsFromSearchResult()
    local suggestions = {}
    local results = (AtlasCFMCharDB and AtlasCFMCharDB.SearchResult) or {}
    local n = table.getn(results)
    local max = 10
    for i = 1, n do
        local v = results[i]
        if type(v) == "table" then
            local id = v[1]
            local elementType = v[4] or "item"
            local sourcePage = v[5]
            local name = nil
            if elementType == "item" then
                name = GetItemInfo(id)
            elseif elementType == "spell" then
                local data = AtlasCFM and AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells and
                    AtlasCFM.SpellDB.craftspells[id]
                name = data and data.name
                if (not name or name == "") and data and data.item then
                    name = GetItemInfo(data.item)
                end
            elseif elementType == "enchant" then
                local data = AtlasCFM and AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and
                    AtlasCFM.SpellDB.enchants[id]
                name = data and data.name
                if (not name or name == "") and data and data.item then
                    name = GetItemInfo(data.item)
                end
            end
            if name and name ~= "" then
                table.insert(suggestions, {
                    id = id,
                    type = elementType,
                    sourcePage = sourcePage,
                    searchText = name,
                    displayText = name
                })
                if table.getn(suggestions) >= max then
                    break
                end
            end
        end
    end
    return suggestions
end

---
-- Function to copy properties from the parent template
-- @function AtlasCFMLoot_ApplyParentTemplate
-- @param frame Frame - The frame to apply template to
-- @usage AtlasCFMLoot_ApplyParentTemplate(myFrame)
---
local function AtlasCFMLoot_ApplyParentTemplate(frame)
    frame:SetWidth(236)
    frame:SetHeight(28)
    frame:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

    -- Icon texture
    local icon = frame:CreateTexture(frame:GetName() .. "_Icon", "ARTWORK")
    icon:SetWidth(26)
    icon:SetHeight(26)
    icon:SetPoint("TOPLEFT", frame, 2, -2)

    -- Quantity text
    local quantity = frame:CreateFontString(frame:GetName() .. "_Quantity", "ARTWORK", "GameFontNormal")
    quantity:SetWidth(25)
    quantity:SetHeight(0)
    quantity:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
    quantity:SetJustifyH("RIGHT")
    quantity:SetPoint("BOTTOMRIGHT", icon, 0, 1)

    -- Name text
    local name = frame:CreateFontString(frame:GetName() .. "_Name", "ARTWORK", "GameFontNormal")
    name:SetWidth(205)
    name:SetHeight(12)
    name:SetJustifyH("LEFT")
    name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 3, 0)

    -- Extra text
    local extra = frame:CreateFontString(frame:GetName() .. "_Extra", "ARTWORK", "GameFontNormalSmall")
    extra:SetWidth(205)
    extra:SetHeight(10)
    extra:SetJustifyH("LEFT")
    extra:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -1)
    extra:Hide()
    -- Price elements (5 sets of text + icon)
    for i = 1, 5 do
        local priceText = frame:CreateFontString(frame:GetName() .. "_PriceText" .. i, "ARTWORK", "GameFontNormalSmall")
        priceText:SetJustifyH("RIGHT")
        priceText:Hide()

        local priceIcon = frame:CreateTexture(frame:GetName() .. "_PriceIcon" .. i, "ARTWORK")
        priceIcon:SetWidth(12)
        priceIcon:SetHeight(12)
        priceIcon:Hide()
        priceText:SetWidth(30)
        priceText:SetHeight(5)
        priceText:SetText("")
        priceText:Hide()
        -- Position will be set dynamically when elements are shown
        priceIcon:SetPoint("TOPRIGHT", name, "BOTTOMRIGHT", 20, -2)
        priceText:SetPoint("TOPRIGHT", priceIcon, 2, 2)
    end

    -- Border texture for item with container
    local border = frame:CreateTexture(frame:GetName() .. "Border", "BACKGROUND")
    border:SetWidth(33)
    border:SetHeight(33)
    border:SetTexture(AtlasCFM.PATH .. "Images\\Container-Border")
    border:SetPoint("TOPLEFT", frame, -2, 2)
    border:Hide()
end

---
-- Function to apply navigation button properties
-- @function AtlasCFMLoot_ApplyNavigationButtonTemplate
-- @param button Button - The button to apply template to
-- @param buttonType string - Type of navigation button ("prev" or "next")
-- @usage AtlasCFMLoot_ApplyNavigationButtonTemplate(myButton, "prev")
---
local function AtlasCFMLoot_ApplyNavigationButtonTemplate(button, buttonType)
    button:SetWidth(32)
    button:SetHeight(32)
    if buttonType == "next" then
        button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
        button:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
        button:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
    elseif buttonType == "prev" then
        button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
        button:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
        button:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
    end
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
end

---
-- Function to apply AtlasCFMLootContainerItemTemplate properties
-- @function AtlasCFMLoot_ApplyContainerItemTemplate
-- @param button Button - The button to apply container item template to
-- @usage AtlasCFMLoot_ApplyContainerItemTemplate(myButton)
---
function AtlasCFMLoot_ApplyContainerItemTemplate(button)
    button:SetWidth(40)
    button:SetHeight(40)

    -- Create backdrop
    button:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 19,
        tileSize = 8,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })

    -- Create icon texture
    local icon = button:CreateTexture(button:GetName() .. "Icon", "BACKGROUND")
    icon:SetWidth(32)
    icon:SetHeight(32)
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 4, -4)

    -- Create quantity text
    local quantity = button:CreateFontString(button:GetName() .. "_Quantity", "BACKGROUND", "GameFontNormal")
    quantity:SetWidth(25)
    quantity:SetHeight(0)
    quantity:SetFont("Fonts\\ARIALN.TTF", 11, "OUTLINE")
    quantity:SetJustifyH("RIGHT")
    quantity:SetPoint("BOTTOMRIGHT", icon)

    -- Set click script
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function()
        AtlasCFM.Interactions.ContainerItem_OnClick(arg1)
    end)
end

---
-- Create Preset buttons (QuickLook buttons)
-- @function AtlasCFMLoot_CreatePresetButtons
-- @param frame Frame - The parent frame to attach preset buttons to
-- @return table - Table containing all created preset buttons
-- @usage local presetButtons = AtlasCFMLoot_CreatePresetButtons(parentFrame)
---
local function AtlasCFMLoot_CreatePresetButtons(frame)
    local presetButton = {}
    for i = 1, 6 do
        presetButton[i] = CreateFrame("Button", frame:GetName() .. "_Preset" .. i, frame, "OptionsButtonTemplate")
        presetButton[i]:SetText(L["QuickLook"] .. " " .. i)
        if i == 1 then
            presetButton[i]:SetPoint("LEFT", 15, 1)
        else
            presetButton[i]:SetPoint("LEFT", presetButton[i - 1], "RIGHT", 0, 0)
        end

        -- Use a local variable to capture the correct index
        local buttonIndex = i
        presetButton[i]:SetScript("OnEnter", function()
            if this:IsEnabled() then
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 5)
                local entry = AtlasCFMCharDB and AtlasCFMCharDB["QuickLooks"] and
                    AtlasCFMCharDB["QuickLooks"][buttonIndex] or
                    nil
                if type(entry) == "table" and entry[3] then
                    GameTooltip:AddLine(entry[3])
                elseif type(entry) == "string" then
                    GameTooltip:AddLine(entry)
                end
                GameTooltip:AddLine(Colors.GREY2 .. L["ALT+Click to clear"])
                GameTooltip:Show()
            end
        end)

        presetButton[i]:SetScript("OnLeave", function()
            if GameTooltip:IsVisible() then
                GameTooltip:Hide()
            end
        end)

        presetButton[i]:SetScript("OnMouseUp", function()
            if IsAltKeyDown() then
                AtlasCFM.QuickLook.ClearButton(buttonIndex)
            end
        end)

        presetButton[i]:SetScript("OnClick", function()
            if not AtlasCFMCharDB or not AtlasCFMCharDB["QuickLooks"] then return end
            local entry = AtlasCFMCharDB["QuickLooks"][buttonIndex]
            if not entry then return end
            local dataID, storedMenu
            if type(entry) == "table" then
                dataID = entry[1]
                storedMenu = entry[2]
            else
                dataID = entry
                storedMenu = nil
            end
            if not dataID then return end
            FauxScrollFrame_SetOffset(AtlasCFMLootScrollBar, 0)
            AtlasCFMLootScrollBarScrollBar:SetValue(0)
            AtlasCFMLootItemsFrame.StoredElement = dataID
            AtlasCFMLootItemsFrame.StoredMenu = storedMenu

            local quickData = nil
            if type(dataID) == "string" then
                quickData = AtlasCFMLoot_Data and AtlasCFMLoot_Data[dataID]
                if not quickData and storedMenu then
                    quickData = AtlasCFM.DataResolver.GetLootByElemName(dataID, storedMenu)
                end
                if not quickData then
                    quickData = AtlasCFM.DataResolver.GetLootByElemName(dataID)
                end
            end

            if quickData then
                AtlasCFM.LootBrowserUI.ShowScrollBarLoading()
                AtlasCFM.LootCache.CacheAllItems(quickData, function()
                    AtlasCFM.LootBrowserUI.HideScrollBarLoading()
                    AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
                end)
            else
                AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
            end
            AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        end)

        presetButton[i]:SetScript("OnShow", function()
            this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
            local enable = false
            if AtlasCFMCharDB and AtlasCFMCharDB["QuickLooks"] then
                local entry = AtlasCFMCharDB["QuickLooks"][buttonIndex]
                if type(entry) == "table" then
                    if entry[1] ~= nil then
                        enable = true
                    end
                elseif type(entry) == "string" then
                    if entry ~= "" then
                        enable = true
                    end
                end
            end
            if enable then this:Enable() else this:Disable() end
        end)
    end

    return presetButton
end

---
-- Create Search Box and related buttons
-- @function AtlasCFMLoot_CreateSearchElements
-- @param frame Frame - The parent frame to attach search elements to
-- @return table - Table containing all created search elements
-- @usage local searchElements = AtlasCFMLoot_CreateSearchElements(parentFrame)
---
local function AtlasCFMLoot_CreateSearchElements(frame)
    -- Search Box
    local searchBox = CreateFrame("EditBox", "AtlasCFMLootSearchBox", frame, "InputBoxTemplate")
    searchBox:SetWidth(214)
    searchBox:SetHeight(20)
    searchBox:SetPoint("BOTTOMLEFT", 112, 13)
    searchBox:SetAutoFocus(false)
    searchBox:SetTextInsets(0, 8, 0, 0)
    searchBox:SetMaxLetters(100)

    searchBox:SetScript("OnEnterPressed", function()
        AtlasCFM.SearchLib.Search(this:GetText())
        AtlasCFMLoot_ClosePredictDropdown(this)
        this:ClearFocus()
    end)

    searchBox:SetScript("OnEscapePressed", function()
        AtlasCFMLoot_ClosePredictDropdown(this)
        this:ClearFocus()
    end)

    searchBox:SetScript("OnEditFocusLost", function()
        AtlasCFMLoot_ClosePredictDropdown(this)
    end)

    searchBox:SetScript("OnTabPressed", function()
        AtlasCFMLoot_ClosePredictDropdown(this)
    end)

    searchBox:SetScript("OnKeyDown", function()
        if not this._predictDrop or not this._predictDrop:IsShown() then return end
        local key = arg1
        local suggestions = this._predictSuggestions or {}
        local n = table.getn(suggestions)
        if n == 0 then return end
        if key == "UP" then
            this._predictSelectedIndex = (this._predictSelectedIndex or 1) - 1
            if this._predictSelectedIndex < 1 then this._predictSelectedIndex = n end
            AtlasCFMLoot_UpdatePredictDropdown(this)
        elseif key == "DOWN" then
            this._predictSelectedIndex = (this._predictSelectedIndex or 0) + 1
            if this._predictSelectedIndex > n then this._predictSelectedIndex = 1 end
            AtlasCFMLoot_UpdatePredictDropdown(this)
        end
    end)

    -- Predict dropdown (suggestions)
    local drop = CreateFrame("Frame", nil, frame)
    drop:SetFrameStrata("FULLSCREEN_DIALOG")
    drop:SetWidth(214)
    drop:SetHeight(10)
    drop:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, -2)
    drop:Hide()

    local bg = CreateFrame("Frame", nil, drop)
    bg:SetAllPoints(drop)
    bg:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    bg:SetBackdropColor(0, 0, 0, 1)
    bg:SetBackdropBorderColor(1, 1, 1)

    drop._maxLines = 10
    drop._buttons = {}
    for i = 1, drop._maxLines do
        local lineIndex = i
        local b = CreateFrame("Button", nil, drop)
        b:SetHeight(16)
        b:SetPoint("TOPLEFT", drop, "TOPLEFT", 8, -8 - ((i - 1) * 16))
        b:SetPoint("TOPRIGHT", drop, "TOPRIGHT", -8, -8 - ((i - 1) * 16))
        b:Hide()

        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        hl:SetBlendMode("ADD")
        hl:SetAllPoints(b)
        hl:Hide()
        b.highlight = hl

        local textFS = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        textFS:SetJustifyH("LEFT")
        textFS:SetPoint("LEFT", b, "LEFT", 2, 0)
        textFS:SetPoint("RIGHT", b, "RIGHT", -2, 0)
        b.text = textFS

        b:SetScript("OnEnter", function()
            if searchBox then
                searchBox._predictSelectedIndex = lineIndex
                AtlasCFMLoot_UpdatePredictDropdown(searchBox)
            end
        end)
        b:SetScript("OnClick", function()
            if not searchBox then return end
            local entry = this._entry
            if entry then
                AtlasCFM.SearchLib.Search(entry.searchText or entry.displayText or searchBox:GetText())
                AtlasCFMLoot_ClosePredictDropdown(searchBox)
                searchBox:ClearFocus()
            end
        end)

        table.insert(drop._buttons, b)
    end

    searchBox._predictDrop = drop

    searchBox:SetScript("OnTextChanged", function()
        if not AtlasCFMCharDB or AtlasCFMCharDB.PredictSearch == false then
            AtlasCFMLoot_ClosePredictDropdown(this)
            return
        end
        local t = this:GetText()
        if not t or t == "" or string.len(t) < 3 then
            this._predictPendingText = nil
            this._predictElapsed = nil
            this:SetScript("OnUpdate", nil)
            AtlasCFMLoot_ClosePredictDropdown(this)
            return
        end
        AtlasCFMLoot_ClosePredictDropdown(this)
        this._predictPendingText = t
        this._predictElapsed = 0
        this:SetScript("OnUpdate", function()
            this._predictElapsed = (this._predictElapsed or 0) + arg1
            if this._predictElapsed >= 0.35 then
                this:SetScript("OnUpdate", nil)
                local textToSearch = this._predictPendingText
                this._predictPendingText = nil
                this._predictElapsed = nil
                if textToSearch and textToSearch ~= "" and textToSearch ~= this._predictLastRunText then
                    this._predictLastRunText = textToSearch
                    AtlasCFM.SearchLib.Search(textToSearch, function()
                        this._predictSuggestions = AtlasCFMLoot_BuildPredictSuggestionsFromSearchResult()
                        this._predictSelectedIndex = 1
                        AtlasCFMLoot_UpdatePredictDropdown(this)
                    end)
                end
            end
        end)
    end)

    -- Search Button
    local searchButton = CreateFrame("Button", nil, searchBox, "OptionsButtonTemplate")
    searchButton:SetWidth(55)
    searchButton:SetPoint("LEFT", searchBox, "RIGHT", 2, 0)

    searchButton:SetScript("OnShow", function()
        this:SetText(L["Search"])
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    searchButton:SetScript("OnClick", function()
        AtlasCFM.SearchLib.Search(AtlasCFMLootSearchBox:GetText())
        AtlasCFMLootSearchBox:ClearFocus()
        CloseDropDownMenus()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLoot_QuickLooks:Hide()
    end)

    -- Search Options Button
    local searchOptionsButton = CreateFrame("Button", nil, searchButton)
    searchOptionsButton:SetWidth(28)
    searchOptionsButton:SetHeight(28)
    searchOptionsButton:SetPoint("LEFT", searchButton, "RIGHT", -2, 0)

    searchOptionsButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    searchOptionsButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    searchOptionsButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
    searchOptionsButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

    searchOptionsButton:SetScript("OnShow", function()
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    searchOptionsButton:SetScript("OnClick", function()
        AtlasCFM.SearchLib.ShowOptions(this)
    end)

    -- Clear Button
    local clearButton = CreateFrame("Button", nil, searchBox, "OptionsButtonTemplate")
    clearButton:SetWidth(58)
    clearButton:SetPoint("LEFT", searchOptionsButton, "RIGHT", -2, 0)

    clearButton:SetScript("OnShow", function()
        this:SetText(L["Clear"])
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    clearButton:SetScript("OnClick", function()
        AtlasCFMLootSearchBox:SetText("")
        AtlasCFMLootSearchBox:ClearFocus()
        CloseDropDownMenus()
    end)

    -- Last Result Button
    local lastResultButton = CreateFrame("Button", nil, searchBox, "OptionsButtonTemplate")
    lastResultButton:SetPoint("LEFT", clearButton, "RIGHT", 0, 0)

    lastResultButton:SetScript("OnShow", function()
        this:SetText(L["Last Result"])
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    lastResultButton:SetScript("OnClick", function()
        AtlasCFM.SearchLib.ShowResult()
        CloseDropDownMenus()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLoot_QuickLooks:Hide()
    end)

    -- WishList Button
    local wishListButton = CreateFrame("Button", nil, frame, "OptionsButtonTemplate")
    wishListButton:SetPoint("RIGHT", searchBox, "LEFT", -7, 0)

    wishListButton:SetScript("OnClick", function()
        AtlasCFMLoot_ShowWishList()
        CloseDropDownMenus()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLoot_QuickLooks:Hide()
    end)

    wishListButton:SetScript("OnShow", function()
        this:SetText(L["WishList"])
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    wishListButton:SetScript("OnEnter", function()
        if this:IsEnabled() then
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 5)
            GameTooltip:AddLine(Colors.WHITE .. L["WishList"] .. "|r")
            GameTooltip:AddLine(L["ALT+Click on item to add or remove it from WishList"])
            GameTooltip:Show()
        end
    end)

    wishListButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- WishList Sort DropDown (Custom Hewdrop-based)
    local sortDropDown = CreateFrame("Button", "AtlasCFMLootWishListSortDropDown", AtlasCFMLootItemsFrame)
    sortDropDown:SetWidth(110)
    sortDropDown:SetHeight(20)
    sortDropDown:SetPoint("TOPRIGHT", "AtlasCFMLootItemsFrame", "TOPRIGHT", -60, -8)

    -- Background texture
    local dropDownBg = sortDropDown:CreateTexture(nil, "BACKGROUND")
    dropDownBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    dropDownBg:SetVertexColor(0.1, 0.1, 0.1, 0.8)
    dropDownBg:SetAllPoints(sortDropDown)

    -- Text display for current selection
    local dropDownText = sortDropDown:CreateFontString("AtlasCFMLootWishListSortDropDownText", "OVERLAY",
        "GameFontHighlightSmall")
    dropDownText:SetPoint("LEFT", sortDropDown, "LEFT", 8, 0)
    dropDownText:SetPoint("RIGHT", sortDropDown, "RIGHT", -20, 0)
    dropDownText:SetJustifyH("LEFT")

    -- Arrow texture
    local dropDownArrow = sortDropDown:CreateTexture(nil, "OVERLAY")
    dropDownArrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    dropDownArrow:SetWidth(16)
    dropDownArrow:SetHeight(16)
    dropDownArrow:SetPoint("RIGHT", sortDropDown, "RIGHT", -2, 0)

    -- Highlight texture
    local dropDownHighlight = sortDropDown:CreateTexture(nil, "HIGHLIGHT")
    dropDownHighlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    dropDownHighlight:SetBlendMode("ADD")
    dropDownHighlight:SetAllPoints(sortDropDown)

    sortDropDown:SetScript("OnClick", function()
        if AtlasCFMLoot_Hewdrop and AtlasCFMLoot_Hewdrop:IsOpen(this) then
            AtlasCFMLoot_Hewdrop:Close()
        else
            if AtlasCFM.HewdropMenus and AtlasCFM.HewdropMenus.OpenWishListSortMenu then
                AtlasCFM.HewdropMenus:OpenWishListSortMenu(this)
            end
        end
    end)

    sortDropDown:SetScript("OnShow", function()
        if not AtlasCFMLootItemsFrame or AtlasCFMLootItemsFrame.StoredElement ~= "WishList" then
            this:Hide()
            return
        end
        if AtlasCFM.HewdropMenus and AtlasCFM.HewdropMenus.UpdateWishListSortLabel then
            AtlasCFM.HewdropMenus.UpdateWishListSortLabel()
        end
    end)

    return {
        searchBox = searchBox,
        searchButton = searchButton,
        searchOptionsButton = searchOptionsButton,
        clearButton = clearButton,
        lastResultButton = lastResultButton,
        wishListButton = wishListButton,
        wishListSortDropDown = sortDropDown
    }
end

---
-- Create FontStrings for the frame
-- @function AtlasCFMLoot_CreateFontStrings
-- @param frame Frame - The parent frame to attach font strings to
-- @return table - Table containing all created font strings
-- @usage local fontStrings = AtlasCFMLoot_CreateFontStrings(parentFrame)
---
local function AtlasCFMLoot_CreateFontStrings(frame)
    -- Selected Category text
    local selectedCategory = frame:CreateFontString(frame:GetName() .. "_SelectedCategory", "OVERLAY", "GameFontNormal")
    selectedCategory:SetPoint("TOP", "AtlasCFMLootItemsFrame_Menu", "TOP", 0, 15)
    selectedCategory:SetText("")

    return {
        selectedCategory = selectedCategory
    }
end

---
-- Create tooltips for AtlasCFMLoot
-- @function AtlasCFMLoot_CreateTooltips
-- @return table - Table containing created tooltip frames
-- @usage local tooltips = AtlasCFMLoot_CreateTooltips()
---
local function AtlasCFMLoot_CreateTooltips()
    --[[     AtlasCFMLootTooltip = GameTooltip
    AtlasCFMLootTooltip2 = ItemRefTooltip ]]
    local tooltip1 = CreateFrame("GameTooltip", "AtlasCFMLootTooltip", UIParent, "GameTooltipTemplate")
    tooltip1:Hide()
    local tooltip2 = CreateFrame("GameTooltip", "AtlasCFMLootTooltip2", UIParent, "GameTooltipTemplate")
    tooltip2:Hide()

    return {
        tooltip1 = tooltip1,
        tooltip2 = tooltip2
    }
end

---
-- Function to create buttons based on templates
-- @function AtlasCFMLoot_CreateButtonFromTemplate
-- @param name string - The name for the button
-- @param parent Frame - The parent frame for the button
-- @param templateType string - The template type to apply
-- @return Button - The created button with applied template
-- @usage local button = AtlasCFMLoot_CreateButtonFromTemplate("MyButton", parentFrame, "AtlasCFMLootItem_Template")
---
function AtlasCFMLoot_CreateButtonFromTemplate(name, parent, templateType)
    local button

    if templateType == "AtlasCFMLootItem_Template" then
        button = CreateFrame("Button", name, parent)
        AtlasCFMLoot_ApplyParentTemplate(button)
        button:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        button:SetScript("OnEnter", function() AtlasCFM.Interactions.Item_OnEnter() end)
        button:SetScript("OnLeave", function() AtlasCFM.Interactions.Item_OnLeave() end)
        button:SetScript("OnClick", function()
            AtlasCFM.Interactions.Item_OnClick(arg1); CloseDropDownMenus()
        end)
        button:SetScript("OnShow", function() this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1) end)
    elseif templateType == "AtlasCFMLootMenuItem_Template" then
        button = CreateFrame("Button", name, parent)
        AtlasCFMLoot_ApplyParentTemplate(button)

        button:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        button:SetScript("OnClick", function() AtlasCFM.Interactions.MenuItem_OnClick(this) end)
        button:SetScript("OnShow", function() this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1) end)
    elseif templateType == "AtlasCFMLootNewBossLineTemplate" then
        button = CreateFrame("Button", name, parent)
        button:SetWidth(336)
        button:SetHeight(15)
        button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

        -- Add elements as in the original template
        local text = button:CreateFontString(button:GetName() .. "_Text", "ARTWORK", "GameFontNormal")
        text:SetWidth(320)
        text:SetHeight(15)
        text:SetJustifyH("LEFT")
        text:SetPoint("LEFT", button, "LEFT")

        local lootIcon = button:CreateTexture(button:GetName() .. "_Loot", "ARTWORK")
        lootIcon:SetWidth(14)
        lootIcon:SetHeight(14)
        lootIcon:SetTexture("Interface\\Icons\\inv_holiday_christmas_present_02")
        lootIcon:SetPoint("RIGHT", button, "RIGHT")
        lootIcon:Hide()

        local selectedIcon = button:CreateTexture(button:GetName() .. "_Selected", "ARTWORK")
        selectedIcon:SetWidth(16)
        selectedIcon:SetHeight(16)
        selectedIcon:SetTexture("Interface\\Icons\\spell_arcane_teleportorgrimmar")
        selectedIcon:SetPoint("RIGHT", button, "RIGHT")
        selectedIcon:Hide()

        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        button:SetScript("OnClick", function() AtlasCFM.Interactions.ElementList_OnClick(this:GetName()) end)
        button:SetScript("OnShow", function() this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1) end)
    end

    return button
end

---
-- Create frame with all item buttons
-- @function AtlasCFMLoot_CreateItemsFrame
-- @return Frame - The created items frame with all UI elements
-- @usage local itemsFrame = AtlasCFMLoot_CreateItemsFrame()
---
local function AtlasCFMLoot_CreateItemsFrame()
    local frame = CreateFrame("Frame", "AtlasCFMLootItemsFrame", AtlasCFMFrame)
    frame:SetWidth(512)
    frame:SetHeight(512)
    frame:SetPoint("TOPLEFT", "AtlasCFMFrame", "TOPLEFT", 18, -84)
    frame:EnableMouse(true)
    frame:EnableMouseWheel(true)
    frame:RegisterEvent("VARIABLES_LOADED")
    frame:SetScript("OnEvent", function()
        AtlasCFMLoot_OnEvent()
    end)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        AtlasCFM.StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        AtlasCFMFrame:StopMovingOrSizing()
        AtlasCFMFrame.isMoving = false
    end)
    frame:SetScript("OnMouseUp", function()
        AtlasCFMFrame:StopMovingOrSizing()
        AtlasCFMFrame.isMoving = false
    end)
    frame:Hide()

    -- Create scrollbar
    local scrollBar = CreateFrame("ScrollFrame", "AtlasCFMLootScrollBar", frame, "FauxScrollFrameTemplate")
    scrollBar:SetPoint("TOPLEFT", frame, -14, -1)
    scrollBar:SetWidth(500)
    scrollBar:SetHeight(509)
    scrollBar:EnableMouseWheel(true)
    scrollBar:SetScript("OnMouseWheel", function()
        local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar) or 0
        local step = 2
        local newOffset = offset - (arg1 * step)
        if newOffset < 0 then newOffset = 0 end
        local maxOffset = AtlasCFMLootScrollBar.scrollMax or 0
        if newOffset > maxOffset then newOffset = maxOffset end
        FauxScrollFrame_SetOffset(AtlasCFMLootScrollBar, newOffset)
        AtlasCFMLootScrollBarScrollBar:SetValue(newOffset * 15)
        AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
    end)
    scrollBar:SetScript("OnVerticalScroll", function()
        FauxScrollFrame_OnVerticalScroll(15, AtlasCFM.LootBrowserUI.ScrollBarLootUpdate)
    end)
    scrollBar:SetScript("OnShow", function()
        AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
    end)

    local scrollHint = CreateFrame("Frame", "AtlasCFMLootScrollHint", frame)
    scrollHint:SetWidth(24)
    scrollHint:SetHeight(58)
    scrollHint:SetPoint("LEFT", frame)
    scrollHint:SetFrameLevel(frame:GetFrameLevel() + 1)
    scrollHint:Hide()
    local scrollHintTexture = scrollHint:CreateTexture("AtlasCFMLootScrollHintTexture", "ARTWORK")
    scrollHintTexture:SetAllPoints(scrollHint)
    scrollHintTexture:SetTexture(AtlasCFM.PATH .. "Images\\Scrolldown")

    -- Background texture
    local backTexture = frame:CreateTexture(frame:GetName() .. "_Back", "BACKGROUND")
    backTexture:SetAllPoints(frame)
    backTexture:SetVertexColor(0, 0, 0, 0.7)

    -- Boss Name FontString
    local pageName = frame:CreateFontString("AtlasCFMLoot_LootPageName", "OVERLAY", "GameFontHighlightLarge")
    pageName:SetWidth(512)
    pageName:SetHeight(30)
    pageName:SetJustifyH("CENTER")
    pageName:SetPoint("TOP", frame, "TOP", 0, 0)

    -- QuickLooks FontString
    local quickLooks = frame:CreateFontString("AtlasCFMLoot_QuickLooks", "OVERLAY", "GameFontNormal")
    quickLooks:SetWidth(200)
    quickLooks:SetHeight(25)
    quickLooks:SetJustifyH("RIGHT")
    quickLooks:SetPoint("BOTTOM", frame, "BOTTOM", -130, 8)

    -- Close button
    local closeButton = CreateFrame("Button", frame:GetName() .. "_CloseButton", frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, -20, -5)
    closeButton:SetScript("OnClick", function()
        AtlasCFM.Interactions.OnCloseButton()
    end)
    closeButton:SetScript("OnShow", function()
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    -- QuickLooks button
    local quickLooksButton = CreateFrame("Button", "AtlasCFMLootQuickLooksButton", frame)
    quickLooksButton:SetWidth(32)
    quickLooksButton:SetHeight(32)
    quickLooksButton:SetPoint("BOTTOM", frame, "BOTTOM", -20, 5)
    quickLooksButton:Hide()

    quickLooksButton:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
    quickLooksButton:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
    quickLooksButton:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
    quickLooksButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

    quickLooksButton:SetScript("OnShow", function()
        if (AtlasCFMLootItemsFrame.StoredElement == "SearchResult")
            or (AtlasCFMLootItemsFrame.StoredElement == "WishList") then
            this:Disable()
        else
            this:Enable()
        end
        this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)

    quickLooksButton:SetScript("OnClick", function()
        AtlasCFM.QuickLook.ShowMenu(this)
    end)
    quickLooksButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
        GameTooltip:SetText(L["Add to QuickLooks"])
        GameTooltip:Show()
    end)
    quickLooksButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Container frame
    local container = CreateFrame("Frame", frame:GetName() .. "Container", frame)
    container:SetWidth(40)
    container:SetHeight(40)
    container:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 0)
    container:EnableMouse(true)
    container:SetFrameStrata("DIALOG")
    container:Hide()
    container:SetMovable(true)
    container:SetClampedToScreen(true)

    -- Backdrop
    container:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        edgeSize = 16,
        tileSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    container:SetBackdropColor(1, 1, 1, 1)
    container:SetBackdropBorderColor(1, 0.82, 0, 1)

    -- Create 30 item buttons (2 columns, 15 rows each)
    local itemButtons = {}
    for i = 1, 30 do
        local itemButton = AtlasCFMLoot_CreateButtonFromTemplate("AtlasCFMLootItem_" .. i, frame,
            "AtlasCFMLootItem_Template")
        itemButton:SetID(i)
        itemButtons[i] = itemButton
        itemButton:SetAlpha(.85)
        if i == 1 then
            itemButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, -35)
        elseif i == 16 then
            itemButton:SetPoint("TOPLEFT", itemButtons[1], "TOPRIGHT", 0, 0)
        elseif i <= 15 then
            itemButton:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
        else
            itemButton:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
        end
    end

    -- Create 30 menu item buttons
    for i = 1, 30 do
        local menuButton = AtlasCFMLoot_CreateButtonFromTemplate("AtlasCFMLootMenuItem_" .. i, frame,
            "AtlasCFMLootMenuItem_Template")
        menuButton:SetID(i)
        menuButton:SetAlpha(.9)
        if i == 1 then
            menuButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, -35)
        elseif i == 16 then
            menuButton:SetPoint("TOPLEFT", itemButtons[1], "TOPRIGHT", 0, 0)
        elseif i <= 15 then
            if i == 2 then
                menuButton:SetPoint("TOPLEFT", itemButtons[1], "BOTTOMLEFT")
            else
                menuButton:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
            end
        else
            if i == 17 then
                menuButton:SetPoint("TOPLEFT", itemButtons[16], "BOTTOMLEFT")
            else
                menuButton:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
            end
        end
    end

    -- Back button
    local backButton = CreateFrame("Button", frame:GetName() .. "_BACK", frame, "OptionsButtonTemplate")
    backButton:SetPoint("BOTTOM", frame, "BOTTOM", 40, 10)
    backButton:Hide()
    backButton:SetText(L["Back"])
    backButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Back"] .. ".")
        GameTooltip:Show()
    end)
    backButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    backButton:SetScript("OnClick", function()
        AtlasCFM.Interactions.NavButton_OnClick()
        CloseDropDownMenus()
    end)

    -- Prev button
    local prevButton = CreateFrame("Button", frame:GetName() .. "_PREV", frame)
    AtlasCFMLoot_ApplyNavigationButtonTemplate(prevButton, "prev")
    prevButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 5)
    prevButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Previous"])
        GameTooltip:Show()
    end)
    prevButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    prevButton:SetScript("OnClick", function()
        AtlasCFM.Interactions.NavButton_OnClick()
        CloseDropDownMenus()
    end)

    -- Next button
    local nextButton = CreateFrame("Button", frame:GetName() .. "_NEXT", frame)
    AtlasCFMLoot_ApplyNavigationButtonTemplate(nextButton, "next")
    nextButton:SetPoint("BOTTOMRIGHT", frame, -20, 5)
    nextButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Next"])
        GameTooltip:Show()
    end)
    nextButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    nextButton:SetScript("OnClick", function()
        AtlasCFM.Interactions.NavButton_OnClick()
        CloseDropDownMenus()
    end)

    -- Menu button
    local menuButton = CreateFrame("Button", frame:GetName() .. "_Menu", frame, "OptionsButtonTemplate")
    menuButton:SetWidth(120)
    menuButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 10)
    menuButton:SetText(L["Select Loot Table"])
    menuButton:SetScript("OnClick", function()
        if AtlasCFMLoot_Hewdrop:IsOpen() then
            AtlasCFMLoot_Hewdrop:Close()
        else
            AtlasCFMLoot_Hewdrop:Open(this)
        end
    end)

    -- Font strings
    AtlasCFMLoot_CreateFontStrings(frame)

    return frame
end

---
-- Create the main AtlasCFMLoot panel with navigation buttons
-- @function AtlasCFMLoot_CreatePanel
-- @return Frame - The created panel frame with all navigation elements
-- @usage local panel = AtlasCFMLoot_CreatePanel()
---
local function AtlasCFMLoot_CreatePanel()
    local frame = CreateFrame("Frame", "AtlasCFMLootPanel", AtlasCFMFrame)
    frame:SetWidth(689)
    frame:SetHeight(90)

    local function IsPfUIStylingEnabled()
        return IsAddOnLoaded("pfUI") and pfUI and (not AtlasCFMOptions or AtlasCFMOptions.pfUIEnabled ~= false)
    end

    if IsPfUIStylingEnabled() then
        frame:SetPoint("TOP", "AtlasCFMFrame", "BOTTOM", 0, 1)
    else
        frame:SetPoint("TOP", "AtlasCFMFrame", "BOTTOM", 0, 9)
    end
    frame:Hide()
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        AtlasCFM.StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        AtlasCFMFrame:StopMovingOrSizing()
        AtlasCFMFrame.isMoving = false
    end)
    frame:SetScript("OnMouseUp", function()
        AtlasCFMFrame:StopMovingOrSizing()
        AtlasCFMFrame.isMoving = false
    end)

    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropBorderColor(0.80, 0.60, 0.25, 1)

    -- Top row buttons
    local world = CreateFrame("Button", frame:GetName() .. "_Instances", frame, "OptionsButtonTemplate")
    world:SetPoint("LEFT", frame, "LEFT", 15, 24)
    world:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLoot_WorldMenu()
    end)
    world:SetScript("OnShow", function()
        world:SetText(L["World"])
        world:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    world:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["World"])
        GameTooltip:Show()
    end)
    world:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local worldEvents = CreateFrame("Button", frame:GetName() .. "_WorldEvents", frame, "OptionsButtonTemplate")
    worldEvents:SetPoint("LEFT", world, "RIGHT", 0, 0)
    worldEvents:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLootWorldEventMenu()
    end)
    worldEvents:SetScript("OnShow", function()
        worldEvents:SetText(L["World Events"])
        worldEvents:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    worldEvents:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["World Events"])
        GameTooltip:Show()
    end)
    worldEvents:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local sets = CreateFrame("Button", frame:GetName() .. "_Sets", frame, "OptionsButtonTemplate")
    sets:SetPoint("LEFT", worldEvents, "RIGHT", 0, 0)
    sets:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFMLootSetMenu()
    end)
    sets:SetScript("OnShow", function()
        sets:SetText(L["Collections"])
        sets:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    sets:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Collections"])
        GameTooltip:Show()
    end)
    sets:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local reputation = CreateFrame("Button", frame:GetName() .. "_Reputation", frame, "OptionsButtonTemplate")
    reputation:SetPoint("LEFT", sets, "RIGHT", 0, 0)
    reputation:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFMLootRepMenu()
    end)
    reputation:SetScript("OnShow", function()
        reputation:SetText(L["Factions"])
        reputation:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    reputation:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Factions"])
        GameTooltip:Show()
    end)
    reputation:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local pvp = CreateFrame("Button", frame:GetName() .. "_PvP", frame, "OptionsButtonTemplate")
    pvp:SetPoint("LEFT", reputation, "RIGHT", 0, 0)
    pvp:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFMLootPvPMenu()
    end)
    pvp:SetScript("OnShow", function()
        pvp:SetText(L["PvP Rewards"])
        pvp:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    pvp:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["PvP Rewards"])
        GameTooltip:Show()
    end)
    pvp:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local crafting = CreateFrame("Button", frame:GetName() .. "_Crafting", frame, "OptionsButtonTemplate")
    crafting:SetPoint("LEFT", pvp, "RIGHT", 0, 0)
    crafting:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFMLoot_CraftingMenu()
    end)
    crafting:SetScript("OnShow", function()
        crafting:SetText(L["Crafting"])
        crafting:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    crafting:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Crafting"])
        GameTooltip:Show()
    end)
    crafting:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    local dungeons = CreateFrame("Button", frame:GetName() .. "_Dungeons", frame, "OptionsButtonTemplate")
    dungeons:SetWidth(120)
    dungeons:SetHeight(40)
    dungeons:SetPoint("LEFT", crafting, "RIGHT", 2, -20)
    dungeons:SetScript("OnClick", function()
        AtlasCFMLoot_QuickLooks:Hide()
        AtlasCFMLootQuickLooksButton:Hide()
        AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
        AtlasCFMLoot_DungeonsMenu()
    end)
    dungeons:SetScript("OnShow", function()
        dungeons:SetText(L["Dungeons & Raids"])
        dungeons:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
    end)
    dungeons:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Dungeons & Raids"])
        GameTooltip:Show()
    end)
    dungeons:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    -- Preset buttons
    AtlasCFMLoot_CreatePresetButtons(frame)
    -- Search elements
    AtlasCFMLoot_CreateSearchElements(frame)

    return frame
end

---
--- Hooks a script handler while preserving the original handler
--- Chains both the original and new handlers together
--- @param frame1 frame The frame to hook the script on
--- @param scriptType string The script type to hook (e.g., "OnShow", "OnHide")
--- @param handler function The new handler function to add
--- @return nil
--- @usage hookScript(AtlasCFM.Quest.Tooltip, "OnShow", pfUI.eqcompare.GameTooltipShow)
---
local function hookScript(frame1, scriptType, handler)
    -- Store original script handler
    local originalScript = frame1:GetScript(scriptType)
    -- Set new script that chains both handlers
    frame1:SetScript(scriptType, function()
        -- Call original handler if it exists
        if originalScript then
            originalScript()
        end
        -- Call our new handler
        handler()
    end)
end

---
--- Sets up pfUI tooltip integration for Atlas quest tooltips
--- Creates backdrops and equipment comparison functionality
--- @return nil
--- @usage setupPfUITooltip() -- Called during initialization
---
local function setupPfUITooltip()
    if not IsAddOnLoaded("pfUI") then
        return
    end
    -- Create pfUI tooltip backdrop
    pfUI.api.CreateBackdrop(AtlasCFMLootTooltip)
    pfUI.api.CreateBackdropShadow(AtlasCFMLootTooltip)
    pfUI.api.CreateBackdrop(AtlasCFMLootTooltip2)
    pfUI.api.CreateBackdropShadow(AtlasCFMLootTooltip2)
    -- Setup equipment comparison if available
    if pfUI.eqcompare then
        hookScript(AtlasCFMLootTooltip, "OnShow", pfUI.eqcompare.GameTooltipShow)
        hookScript(AtlasCFMLootTooltip, "OnHide", function()
            ShoppingTooltip1:Hide()
            ShoppingTooltip2:Hide()
        end)
    end
end

---
-- Initialize the AtlasCFMLoot UI components
-- @function AtlasCFMLoot_InitializeUI
-- @usage AtlasCFMLoot_InitializeUI()
---
function AtlasCFMLoot_InitializeUI()
    AtlasCFMLoot_CreateTooltips()
    AtlasCFMLoot_CreateItemsFrame()
    AtlasCFMLoot_CreatePanel()
    --setupPfUITooltip()
end
