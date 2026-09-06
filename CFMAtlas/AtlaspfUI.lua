---
--- AtlasCFMpfUI.lua - pfUI Integration for Atlas-CFM
---
--- This file contains pfUI styling integration for Atlas-CFM frames and components.
--- It applies pfUI's CreateBackdrop and CreateBackdropShadow functions to all Atlas
--- frames when pfUI is detected, creating a unified visual style.
---
--- Features:
--- - Automatic detection of pfUI addon
--- - Application of pfUI backdrops to main Atlas frame
--- - Styling of dropdown menus and buttons
--- - Integration with pfUI's border and color system
--- - Styling of loot panel and quest frames
--- - pfUI tooltip integration
---
--- @compatible World of Warcraft 1.12
--- @requires pfUI addon
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM

-- Initialize pfUI integration module
AtlasCFM.pfUI = {}

---
--- Checks if pfUI addon is loaded and available
--- @return boolean - true if pfUI is loaded
---
local function IsPfUIBaseLoaded()
    return (IsAddOnLoaded("pfUI") and pfUI)
end

---
--- Checks if pfUI addon is loaded and styling is enabled in Atlas options
--- @return boolean - true if pfUI is loaded and styling is enabled
---
local function IsPfUIStylingEnabled()
    if not IsPfUIBaseLoaded() or not pfUI.api or not pfUI.api.CreateBackdrop then
        return false
    end

    -- Check if user has disabled pfUI styling in options
    if AtlasCFMOptions and AtlasCFMOptions.pfUIEnabled == false then
        return false
    end

    return true
end

---
--- Gets the pfUI border background color safely
--- @return number, number, number, number - r, g, b, a
---
local function GetPfUIBackgroundColor()
    if pfUI_config and pfUI_config.appearance and pfUI_config.appearance.border and pfUI_config.appearance.border.background then
        return pfUI.api.GetStringColor(pfUI_config.appearance.border.background)
    end
    return 0, 0, 0, 0.8 -- Default fallback
end

---
--- Applies pfUI styling to the main Atlas frame
--- Removes default textures and applies pfUI backdrop
---
local function StyleMainFrame()
    if not AtlasCFMFrame then return end

    -- Hide default Atlas textures
    -- Note: We keep the border textures visible as they define the Atlas window shape
    -- Only hide background if user wants full pfUI integration

    local textures = {
        "AtlasCFMFrameTop",
        "AtlasCFMFrameLeft",
        "AtlasCFMFrameBottom",
        "AtlasCFMFrameBottom2",
        "AtlasCFMFrameRight"
    }

    for _, texName in ipairs(textures) do
        local tex = _G[texName]
        if tex then
            tex:Hide()
        end
    end

    -- Create pfUI backdrop
    if pfUI.api.CreateBackdrop then
        pfUI.api.CreateBackdrop(AtlasCFMFrame, nil, nil, 0.9)
        pfUI.api.CreateBackdropShadow(AtlasCFMFrame)

        -- Apply border color if available
        if AtlasCFMFrame.backdrop then
            local r, g, b, a = GetPfUIBackgroundColor()
            AtlasCFMFrame.backdrop:SetBackdropColor(r, g, b, 0.9)
        end
    end

    -- Adjust frame strata to work with pfUI
    if AtlasCFMFrame.backdrop then
        AtlasCFMFrame.backdrop:SetFrameStrata("HIGH")
        AtlasCFMFrame.backdrop:SetFrameLevel(AtlasCFMFrame:GetFrameLevel() - 1)

        -- Ensure backdrop doesn't capture mouse if main frame is mouse-disabled (locked)
        AtlasCFMFrame.backdrop:EnableMouse(false)
    end

    -- Style the close button (X button)
    if AtlasCFMCloseButton then
        -- Close button needs special handling - it's a UIPanelCloseButton template
        -- User requested no large black contour. pfUI might auto-skin it, so we hide its backdrop.
        if AtlasCFMCloseButton.backdrop then
            AtlasCFMCloseButton.backdrop:Hide()
        end

        AtlasCFMCloseButton:SetNormalTexture("")
        AtlasCFMCloseButton:SetPushedTexture("")
        AtlasCFMCloseButton:SetHighlightTexture("")

        -- Create custom X texture
        if not AtlasCFMCloseButton.customX then
            local customX = AtlasCFMCloseButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            customX:SetPoint("CENTER", 0, 0)
            customX:SetText("×")
            customX:SetTextColor(1, 0.2, 0.2)
            customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            AtlasCFMCloseButton.customX = customX
        end

        -- Set fixed size to avoid wide background if any
        AtlasCFMCloseButton:SetWidth(20)
        AtlasCFMCloseButton:SetHeight(20)
        AtlasCFMCloseButton:ClearAllPoints()
        AtlasCFMCloseButton:SetPoint("TOPRIGHT", AtlasCFMFrame, "TOPRIGHT", -1, -14)

        -- Hover effect
        AtlasCFMCloseButton:SetScript("OnEnter", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.4, 0.4)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
            end
        end)
        AtlasCFMCloseButton:SetScript("OnLeave", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.2, 0.2)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            end
        end)

        AtlasCFMCloseButton.pfui_skinned = true
    end

    -- Style the lock button
    if AtlasCFMLockButton then
        -- No backdrop for lock button as requested. Hide pfUI auto-backdrop if present.
        if AtlasCFMLockButton.backdrop then
            AtlasCFMLockButton.backdrop:Hide()
        end

        -- Use textures instead of text for better reliability
        AtlasCFMLockButton:SetWidth(20)
        AtlasCFMLockButton:SetHeight(20)
        AtlasCFMLockButton:ClearAllPoints()
        AtlasCFMLockButton:SetPoint("RIGHT", AtlasCFMCloseButton, "LEFT", 0, 0)

        -- Hook the toggle function to update display
        local originalOnClick = AtlasCFMLockButton:GetScript("OnClick")
        AtlasCFMLockButton:SetScript("OnClick", function()
            if originalOnClick then originalOnClick() end
            if AtlasCFM.UpdateLock then
                AtlasCFM.UpdateLock()
            end
        end)

        if AtlasCFM.UpdateLock then
            AtlasCFM.UpdateLock()
        end
        AtlasCFMLockButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")

        AtlasCFMLockButton.pfui_skinned = true
    end
end

---
--- Re-applies pfUI styling to a button
--- @param buttonName string - Name of the button to restyle
---
function AtlasCFM.pfUI.RestyleButton(buttonName)
    if not IsPfUIStylingEnabled() then return end
    local button = _G[buttonName]
    if not button then return end

    if pfUI.api.SkinButton then
        -- If not already skinned, skin it
        if not button.pfui_skinned then
            pfUI.api.SkinButton(button)
            button.pfui_skinned = true
        end

        -- If it was already skinned but textures became visible (e.g. after Show/SetText)
        -- we just hide them instead of re-skinning to avoid multiple backdrops
        if button:GetNormalTexture() and button:GetNormalTexture():IsShown() then
            button:GetNormalTexture():Hide()
        end
        if button:GetPushedTexture() and button:GetPushedTexture():IsShown() then
            button:GetPushedTexture():Hide()
        end
        if button:GetDisabledTexture() and button:GetDisabledTexture():IsShown() then
            button:GetDisabledTexture():Hide()
        end
    end
end

function AtlasCFM.pfUI.SkinCollapseAllButton(button)
    if not IsPfUIStylingEnabled() then return end
    if not button then return end

    if pfUI.api.SkinCollapseButton and not button.pfui_collapse_base then
        pfUI.api.SkinCollapseButton(button, true)
        button.pfui_collapse_base = true
    end

    if not button.icon then return end

    if button.icon.EnableMouse then
        button.icon:EnableMouse(false)
    end
    button.icon:ClearAllPoints()
    button.icon:SetPoint("LEFT", button, "LEFT", 2, 0)
    button:SetHitRectInsets(0, 0, 0, 0)

    if button.text then
        button.text:ClearAllPoints()
        button.text:SetPoint("LEFT", button, "LEFT", 18, 0)
    end

    if not button.pfui_set_normaltexture then
        button.pfui_set_normaltexture = button.SetNormalTexture
    end
    if not button.pfui_set_pushedtexture then
        button.pfui_set_pushedtexture = button.SetPushedTexture
    end

    local normalTexture = button:GetNormalTexture()
    local currentTexture = normalTexture and normalTexture:GetTexture()

    local function UpdateCollapseIcon(self, texture)
        if not self.icon or not self.icon.text then return end
        if not texture or texture == "" then
            self.icon:Hide()
            return
        end
        self.icon.text:SetText(strfind(texture, "MinusButton") and "-" or "+")
        self.icon:Show()
    end

    button.pfui_set_normaltexture(button, nil)
    button.pfui_set_pushedtexture(button, nil)
    button.SetNormalTexture = UpdateCollapseIcon
    button.SetPushedTexture = UpdateCollapseIcon
    button:SetNormalTexture(currentTexture)
end

---
--- Skins an arrow button with pfUI style but keeps arrow indication
--- @param button Button - The button to skin
--- @param direction string - Direction of arrow ("left", "right", "up", "down")
---
function AtlasCFM.pfUI.SkinArrowButton(button, direction)
    if not IsPfUIStylingEnabled() then return end
    if not button then return end

    -- Fix button size (increase clickbox size, was 18)
    button:SetWidth(24)
    button:SetHeight(24)

    -- Ensure no backdrop is applied (pfUI arrows are floating textures)
    if button.backdrop then
        button.backdrop:Hide()
    end
    button.pfui_skinned = true

    -- Set pfUI arrow textures
    -- Note: We assume standard pfUI directory structure
    local texturePath = "Interface\\AddOns\\pfUI\\img\\"

    -- Helper to constrain texture size
    local function SkinTexture(tex)
        if tex then
            tex:ClearAllPoints()
            tex:SetPoint("CENTER", 0, 0)
            tex:SetWidth(16)
            tex:SetHeight(16)
        end
    end

    if direction == "left" or direction == "right" or direction == "up" or direction == "down" then
        local tex = texturePath .. direction
        button:SetNormalTexture(tex)
        button:SetPushedTexture(tex)
        button:SetDisabledTexture(tex)

        SkinTexture(button:GetNormalTexture())
        SkinTexture(button:GetPushedTexture())
        SkinTexture(button:GetDisabledTexture())
    end

    -- Adjust Pushed/Disabled visual feedback
    if button:GetPushedTexture() then
        button:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5)
        button:GetPushedTexture():SetPoint("CENTER", 1, -1) -- Simulate button press offset
    end

    if button:GetDisabledTexture() then
        button:GetDisabledTexture():SetDesaturated(true)
        button:GetDisabledTexture():SetAlpha(0.5)
    end

    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
end

---
--- Skins an editbox with pfUI style
--- @param editbox EditBox - The editbox to skin
---
function AtlasCFM.pfUI.SkinEditBox(editbox)
    if not IsPfUIStylingEnabled() then return end
    if not editbox then return end
    if editbox.pfui_skinned then return end

    -- Hide standard WoW editbox textures to prevent "strange border" look
    local name = editbox:GetName()
    if name then
        local left = _G[name .. "Left"]
        local middle = _G[name .. "Middle"]
        local right = _G[name .. "Right"]

        if left then left:Hide() end
        if middle then middle:Hide() end
        if right then right:Hide() end
    end

    -- Also hide any textures attached directly to regions if they are standard borders
    -- (This is a fallback if names don't match or for anonymous frames)
    for _, region in ipairs({ editbox:GetRegions() }) do
        if region:GetObjectType() == "Texture" then
            local texture = region:GetTexture()
            if texture then
                -- Check for standard editbox textures
                if string.find(texture, "Interface\\Common\\Common-Input-Border") or
                    string.find(texture, "Interface\\ChatFrame\\UI-Chat-") then
                    region:Hide()
                end
            end
        end
    end

    if pfUI.api.CreateBackdrop then
        pfUI.api.CreateBackdrop(editbox, nil, true)
    end
    editbox.pfui_skinned = true
end

---
--- Applies pfUI styling to dropdown buttons
--- Styles the category and map selection dropdowns
---
local function StyleDropdowns()
    local dropdowns = {
        AtlasCFMFrameDropDownType,
        AtlasCFMFrameDropDown,
    }

    for _, dropdown in ipairs(dropdowns) do
        if dropdown then
            -- Apply pfUI backdrop
            pfUI.api.CreateBackdrop(dropdown, nil, true, 0.8)

            -- Adjust colors to match pfUI
            if dropdown.backdrop then
                local r, g, b, a = pfUI.api.GetStringColor(pfUI_config.appearance.border.background)
                dropdown.backdrop:SetBackdropColor(r, g, b, a)
            end
        end
    end
end

---
--- Applies pfUI styling to buttons
--- Styles all major buttons in the Atlas interface using pfUI.api.SkinButton
---
local function StyleButtons()
    -- Use pfUI's SkinButton function for proper button styling
    if not pfUI.api.SkinButton then return end

    -- Direct named buttons
    local namedButtons = {
        "AtlasCFMSwitchButton",
        "AtlasCFMLootFilterButton",
    }

    for _, buttonName in ipairs(namedButtons) do
        local button = _G[buttonName]
        if button then
            if not button.pfui_skinned then
                pfUI.api.SkinButton(button)
                button.pfui_skinned = true
            end
        end
    end

    -- Find and style all button children of AtlasCFMFrame
    if AtlasCFMFrame then
        for _, child in ipairs({ AtlasCFMFrame:GetChildren() }) do
            if not child.pfui_skinned then
                if child:GetObjectType() == "Button" then
                    -- Skip close and lock buttons as they are handled separately
                    if child ~= AtlasCFMCloseButton and child ~= AtlasCFMLockButton then
                        pfUI.api.SkinButton(child)
                        child.pfui_skinned = true
                    end
                elseif child:GetObjectType() == "CheckButton" and pfUI.api.SkinCheckbox then
                    pfUI.api.SkinCheckbox(child)
                    child.pfui_skinned = true
                end
            end
        end
    end

    -- Style search buttons in main frame
    if AtlasCFMSearchEditBox then
        -- The search and clear buttons are children of the edit box, not siblings!
        for _, child in ipairs({ AtlasCFMSearchEditBox:GetChildren() }) do
            if child:GetObjectType() == "Button" and not child.pfui_skinned then
                pfUI.api.SkinButton(child)
                child.pfui_skinned = true
            end
        end
    end
end

---
--- Applies pfUI styling to search box
--- Styles the loot search editbox WITHOUT backdrop (editboxes shouldn't have backdrop)
---
local function StyleSearchBox()
    -- Style the main Atlas search editbox
    if not AtlasCFMSearchEditBox then return end

    AtlasCFM.pfUI.SkinEditBox(AtlasCFMSearchEditBox)
    AtlasCFMSearchEditBox:SetHeight(20) -- Fix height for pfUI style

    -- Also style the search button in the loot panel (handled in StyleLootPanel, but just in case)
    if pfUI.api.SkinButton and AtlasCFMLootSearchBox then
        AtlasCFM.pfUI.SkinEditBox(AtlasCFMLootSearchBox)
    end
end

---
--- Skins a scrollbar with pfUI style
--- @param scrollFrame ScrollFrame - The scrollframe to skin
---
function AtlasCFM.pfUI.SkinScrollBar(scrollFrame)
    if not IsPfUIStylingEnabled() then return end
    if not scrollFrame then return end
    if scrollFrame.pfui_skinned then return end

    -- Detect if this is a FauxScrollFrame or similar wrapper where the actual scrollbar is a child
    local scrollBarWidget = scrollFrame
    local name = scrollFrame:GetName()
    if name then
        -- Check for "ScrollBar" suffix child, which is standard for FauxScrollFrameTemplate
        local childScrollBar = _G[name .. "ScrollBar"]
        if childScrollBar then
            scrollBarWidget = childScrollBar
        end
    end

    -- Use pfUI's built-in scrollbar skinner if available
    if pfUI.api.SkinScrollbar then
        -- Wrap in pcall to prevent errors if the scrollbar structure is unexpected
        -- Pass the widget that is likely the slider/scrollbar
        local success, err = pcall(pfUI.api.SkinScrollbar, scrollBarWidget)
        -- if not success then PrintA("AtlasCFM: pfUI SkinScrollbar error: " .. tostring(err)) end
    else
        -- Manual fallback if pfUI doesn't expose SkinScrollbar
        local sbName = scrollBarWidget:GetName()
        if sbName then
            local upButton = _G[sbName .. "ScrollUpButton"]
            local downButton = _G[sbName .. "ScrollDownButton"]

            if upButton then AtlasCFM.pfUI.SkinArrowButton(upButton, "up") end
            if downButton then AtlasCFM.pfUI.SkinArrowButton(downButton, "down") end
        end
    end

    scrollFrame.pfui_skinned = true
    -- Also mark the child as skinned to prevent double skinning if called directly later
    if scrollBarWidget ~= scrollFrame then
        scrollBarWidget.pfui_skinned = true
    end
end

---
--- Applies pfUI styling to the scrollbar frame
--- Styles the loot items scrollbar
---
local function StyleScrollBar()
    if AtlasCFMScrollBar then
        -- Style scrollbar background
        pfUI.api.CreateBackdrop(AtlasCFMScrollBar, nil, nil, 0.3)
        AtlasCFM.pfUI.SkinScrollBar(AtlasCFMScrollBar)
    end

    if AtlasCFMLootScrollBar then
        AtlasCFM.pfUI.SkinScrollBar(AtlasCFMLootScrollBar)
    end
end

---
--- Applies pfUI styling to loot items frame
--- Styles the main loot display area with black background
---
local function StyleLootItemsFrame()
    if not AtlasCFMLootItemsFrame then return end

    -- Apply backdrop to loot items frame
    pfUI.api.CreateBackdrop(AtlasCFMLootItemsFrame, nil, nil, 1.0)

    -- Use pfUI background color if available
    local r, g, b, a = GetPfUIBackgroundColor()
    if AtlasCFMLootItemsFrame.backdrop then
        -- Make the backdrop background transparent so we don't double-draw with the texture
        AtlasCFMLootItemsFrame.backdrop:SetBackdropColor(r, g, b, 0)
    end

    -- Style the original background texture
    -- We use the original texture but color it to match pfUI
    local backTexture = _G["AtlasCFMLootItemsFrame_Back"]
    if backTexture then
        -- Restore it if it was hidden
        backTexture.Show = nil -- Remove the dummy function if present
        backTexture:Show()

        -- Reset vertex color to white so it doesn't tint our texture black
        -- (LootUI.lua sets it to 0,0,0,0.7 which causes the "always black" issue)
        backTexture:SetVertexColor(1, 1, 1, 1)

        -- Set the texture to the pfUI background color
        backTexture:SetTexture(r, g, b, a)
        backTexture:SetAlpha(a)
    end

    -- Fallback: iterate and fix any other background textures if the named one wasn't found
    -- (This part is just a safety measure)
    if not backTexture then
        for _, region in ipairs({ AtlasCFMLootItemsFrame:GetRegions() }) do
            if region:GetObjectType() == "Texture" and region:GetDrawLayer() == "BACKGROUND" then
                local p1, p2, p3, p4, p5 = region:GetPoint()
                if p1 == "TOPLEFT" or p1 == "BOTTOMLEFT" or p1 == "TOPRIGHT" or p1 == "BOTTOMRIGHT" or p1 == "CENTER" or p1 == "ALL" then
                    region:SetVertexColor(1, 1, 1, 1)
                    region:SetTexture(r, g, b, a)
                    region:SetAlpha(a)
                end
            end
        end
    end

    -- Style the loot items frame close button
    local itemsCloseButton = _G["AtlasCFMLootItemsFrame_CloseButton"]
    if itemsCloseButton then
        -- Hide pfUI auto-backdrop if present.
        if itemsCloseButton.backdrop then
            itemsCloseButton.backdrop:Hide()
        end

        itemsCloseButton:SetNormalTexture("")
        itemsCloseButton:SetPushedTexture("")
        itemsCloseButton:SetHighlightTexture("")

        -- Create custom X texture
        if not itemsCloseButton.customX then
            local customX = itemsCloseButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            customX:SetPoint("CENTER", 0, 0)
            customX:SetText("×")
            customX:SetTextColor(1, 0.2, 0.2)
            customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            itemsCloseButton.customX = customX
        end

        -- Position and size to match main frame buttons
        itemsCloseButton:SetWidth(20)
        itemsCloseButton:SetHeight(20)
        itemsCloseButton:ClearAllPoints()
        itemsCloseButton:SetPoint("TOPRIGHT", AtlasCFMLootItemsFrame, "TOPRIGHT", -15, -3)

        -- Hover effect
        itemsCloseButton:SetScript("OnEnter", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.4, 0.4)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
            end
        end)
        itemsCloseButton:SetScript("OnLeave", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.2, 0.2)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            end
        end)

        itemsCloseButton.pfui_skinned = true
    end

    -- Style all item buttons in the loot frame
    for i = 1, 30 do
        local button = _G["AtlasCFMLootItem" .. i]
        if button and not button.pfui_styled then
            -- Item buttons should have subtle backdrop
            pfUI.api.CreateBackdrop(button, nil, true, 0.3)
            button.pfui_styled = true
        end
    end

    -- Style Select Loot Table button
    if AtlasCFMLootItemsFrame_Menu and not AtlasCFMLootItemsFrame_Menu.pfui_skinned then
        pfUI.api.SkinButton(AtlasCFMLootItemsFrame_Menu)
        AtlasCFMLootItemsFrame_Menu.pfui_skinned = true
    end

    -- Style Back/Prev/Next buttons and QuickLooks button
    local navButtons = {
        "AtlasCFMLootItemsFrame_BACK",
        "AtlasCFMLootItemsFrame_PREV",
        "AtlasCFMLootItemsFrame_NEXT",
        "AtlasCFMLootQuickLooksButton"
    }

    for _, btnName in ipairs(navButtons) do
        local btn = _G[btnName]
        if btn and not btn.pfui_skinned then
            if btnName == "AtlasCFMLootItemsFrame_BACK" then
                pfUI.api.SkinButton(btn)
            elseif btnName == "AtlasCFMLootItemsFrame_PREV" then
                AtlasCFM.pfUI.SkinArrowButton(btn, "left")
            elseif btnName == "AtlasCFMLootItemsFrame_NEXT" then
                AtlasCFM.pfUI.SkinArrowButton(btn, "right")
            elseif btnName == "AtlasCFMLootQuickLooksButton" then
                AtlasCFM.pfUI.SkinArrowButton(btn, "down")
            end
            btn.pfui_skinned = true
        end
    end
end

---
--- Applies pfUI styling to loot panel
--- Styles the bottom panel with navigation buttons
---
local function StyleLootPanel()
    if not AtlasCFMLootPanel then return end

    -- Position Loot Panel relative to AtlasCFMFrame for pfUI
    AtlasCFMLootPanel:ClearAllPoints()
    AtlasCFMLootPanel:SetPoint("TOP", "AtlasCFMFrame", "BOTTOM", 0, 1)

    -- Apply pfUI backdrop
    pfUI.api.CreateBackdrop(AtlasCFMLootPanel, nil, nil, 1.0)
    pfUI.api.CreateBackdropShadow(AtlasCFMLootPanel)

    -- Use pfUI background color if available, otherwise pure black
    if AtlasCFMLootPanel.backdrop then
        local r, g, b, a = GetPfUIBackgroundColor()
        AtlasCFMLootPanel.backdrop:SetBackdropColor(r, g, b, 1)
    end

    -- Style the original background texture to match the backdrop in loot panel
    for _, region in ipairs({ AtlasCFMLootPanel:GetRegions() }) do
        if region:GetObjectType() == "Texture" then
            local r, g, b, a = 0, 0, 0, 1
            if AtlasCFMLootPanel.backdrop then
                r, g, b, a = AtlasCFMLootPanel.backdrop:GetBackdropColor()
            end
            region:SetTexture(r, g, b, 1) -- Set alpha to 1 for "completely black"
            region:SetAlpha(1)
        end
    end

    -- Style all named loot panel buttons
    local panelButtons = {
        "AtlasCFMLootPanel_Instances",   -- World
        "AtlasCFMLootPanel_WorldEvents", -- World Events
        "AtlasCFMLootPanel_Sets",        -- Collections
        "AtlasCFMLootPanel_Reputation",  -- Factions
        "AtlasCFMLootPanel_PvP",         -- PvP Rewards
        "AtlasCFMLootPanel_Crafting",    -- Crafting
        "AtlasCFMLootPanel_Dungeons",    -- Dungeons & Raids
    }

    if pfUI.api.SkinButton then
        for _, buttonName in ipairs(panelButtons) do
            local button = _G[buttonName]
            if button and not button.pfui_skinned then
                pfUI.api.SkinButton(button)
                button.pfui_skinned = true
            end
        end
    end

    -- Style menu item buttons (numbered buttons in panel)
    if pfUI.api.SkinButton then
        for i = 1, 20 do
            local button = _G["AtlasCFMLootMenuItem" .. i]
            if button and not button.pfui_skinned then
                pfUI.api.SkinButton(button)
                button.pfui_skinned = true
            end
        end
    end

    -- Style all button children of the loot panel (includes Search, Clear, Last Result, WishList, etc)
    if pfUI.api.SkinButton and AtlasCFMLootPanel then
        for _, child in ipairs({ AtlasCFMLootPanel:GetChildren() }) do
            if child:GetObjectType() == "Button" and not child.pfui_skinned then
                pfUI.api.SkinButton(child)
                child.pfui_skinned = true
            end
        end
    end

    -- Style checkboxes in loot panel if any (like "Safe Links" etc are in options, but maybe some here)
    if pfUI.api.SkinCheckbox and AtlasCFMLootPanel then
        for _, child in ipairs({ AtlasCFMLootPanel:GetChildren() }) do
            if child:GetObjectType() == "CheckButton" and not child.pfui_skinned then
                pfUI.api.SkinCheckbox(child)
                child.pfui_skinned = true
            end
        end
    end

    -- Also style buttons that are children of the search box
    if pfUI.api.SkinButton and AtlasCFMLootSearchBox then
        -- Style the search box itself
        AtlasCFM.pfUI.SkinEditBox(AtlasCFMLootSearchBox)

        for _, child in ipairs({ AtlasCFMLootSearchBox:GetChildren() }) do
            if child:GetObjectType() == "Button" and not child.pfui_skinned then
                pfUI.api.SkinButton(child)
                child.pfui_skinned = true
            end
        end

        -- Style children of button children (for searchOptionsButton which is child of searchButton)
        for _, child in ipairs({ AtlasCFMLootSearchBox:GetChildren() }) do
            if child:GetObjectType() == "Button" then
                for _, subchild in ipairs({ child:GetChildren() }) do
                    if subchild:GetObjectType() == "Button" and not subchild.pfui_skinned then
                        -- Check if this is the search options arrow button
                        local normalTexture = subchild:GetNormalTexture()
                        local texPath = normalTexture and normalTexture:GetTexture() or ""
                        if string.find(texPath, "NextPage") then
                            AtlasCFM.pfUI.SkinArrowButton(subchild, "right")
                        elseif string.find(texPath, "PrevPage") then
                            AtlasCFM.pfUI.SkinArrowButton(subchild, "left")
                        else
                            pfUI.api.SkinButton(subchild)
                        end
                        subchild.pfui_skinned = true
                    end
                end
            end
        end
    end
end

---
--- Applies pfUI styling to container window
--- Styles the item set/container popup
---
local function StyleContainerFrame()
    if not AtlasCFMLootItemsFrameContainer then return end

    -- Apply pfUI backdrop to container
    pfUI.api.CreateBackdrop(AtlasCFMLootItemsFrameContainer, nil, nil, 0.9)
    pfUI.api.CreateBackdropShadow(AtlasCFMLootItemsFrameContainer)

    -- Style container item buttons
    for i = 1, 50 do
        local button = _G["AtlasCFMLootItemsFrameContainerButton" .. i]
        if button and not button.pfui_styled then
            -- Container item buttons get subtle backdrop
            pfUI.api.CreateBackdrop(button, nil, true, 0.5)
            button.pfui_styled = true
        end
    end
end

---
--- Applies pfUI styling to quest frame
--- Styles the quest display panel
---
local function StyleQuestFrame()
    -- Get the quest frame reference
    local questFrame = AtlasCFM.Quest and AtlasCFM.Quest.UI_Main and AtlasCFM.Quest.UI_Main.Frame
    if not questFrame then return end

    -- Position Quest frame relative to AtlasCFMFrame for pfUI
    -- We adjust this here because pfUI styling changes the visual borders
    if questFrame:IsVisible() then
        questFrame:ClearAllPoints()
        if AtlasCFMOptions and AtlasCFMOptions.QuestCurrentSide then -- true is Left
            questFrame:SetPoint("TOPRIGHT", "AtlasCFMFrame", "TOPLEFT", -1, 0)
        else
            questFrame:SetPoint("TOPLEFT", "AtlasCFMFrame", "TOPRIGHT", 1, 0)
        end
    end

    -- Clear existing backdrop if any (QuestUI.lua sets a DialogBox backdrop)
    questFrame:SetBackdrop(nil)

    -- Apply pfUI backdrop
    pfUI.api.CreateBackdrop(questFrame, nil, nil, 1.0)
    pfUI.api.CreateBackdropShadow(questFrame)

    -- Use pfUI background color if available, otherwise pure black
    if questFrame.backdrop then
        local r, g, b, a = GetPfUIBackgroundColor()
        questFrame.backdrop:SetBackdropColor(r, g, b, 1) -- Ensure alpha is 1 for "completely black"
    end

    -- Style the close button
    if AtlasCFM.Quest.UI_Main.CloseButton then
        local closeButton = AtlasCFM.Quest.UI_Main.CloseButton

        -- User requested no large black contour. Hide pfUI auto-backdrop if present.
        if closeButton.backdrop then
            closeButton.backdrop:Hide()
        end

        closeButton:SetNormalTexture("")
        closeButton:SetPushedTexture("")
        closeButton:SetHighlightTexture("")

        -- Create custom X texture
        if not closeButton.customX then
            local customX = closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            customX:SetPoint("CENTER", 0, 0)
            customX:SetText("×")
            customX:SetTextColor(1, 0.2, 0.2)
            customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            closeButton.customX = customX
        end

        -- Position and size
        closeButton:SetWidth(20)
        closeButton:SetHeight(20)
        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", questFrame, "TOPRIGHT", -3, -3)

        -- Hover effect
        closeButton:SetScript("OnEnter", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.4, 0.4)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
            end
        end)
        closeButton:SetScript("OnLeave", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.2, 0.2)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            end
        end)
    end

    -- Style the Story button
    if AtlasCFM.Quest.UI_Main.StoryButton and pfUI.api.SkinButton then
        pfUI.api.SkinButton(AtlasCFM.Quest.UI_Main.StoryButton)
    end

    -- Style the Check Completed Quests button
    if AtlasCFM.Quest.UI_Main.CheckCompletedQuestsButton and pfUI.api.SkinButton then
        pfUI.api.SkinButton(AtlasCFM.Quest.UI_Main.CheckCompletedQuestsButton)
    end

    -- Style all quest buttons
    if AtlasCFM.Quest.UI_Main.QuestButtons and pfUI.api.SkinButton then
        for i, questBtn in ipairs(AtlasCFM.Quest.UI_Main.QuestButtons) do
            if questBtn.Button and not questBtn.Button.pfui_styled then
                pfUI.api.CreateBackdrop(questBtn.Button, nil, true, 0.3)
                questBtn.Button.pfui_styled = true
            end
        end
    end
end

---
--- Styles the embedded quest display (InsideAtlasFrame)
---
local function StyleInsideAtlasFrame()
    if not AtlasCFM.Quest or not AtlasCFM.Quest.UI or not AtlasCFM.Quest.UI.InsideAtlasFrame then return end
    local frame = AtlasCFM.Quest.UI.InsideAtlasFrame

    -- Apply pfUI backdrop
    pfUI.api.CreateBackdrop(frame, nil, nil, 1.0)
    pfUI.api.CreateBackdropShadow(frame)

    -- Use pfUI background color if available, otherwise pure black
    if frame.backdrop then
        local r, g, b, a = GetPfUIBackgroundColor()
        frame.backdrop:SetBackdropColor(r, g, b, 1) -- Ensure alpha is 1 for "completely black"
    end

    -- Hide or style the original background texture if it exists
    -- In QuestUIinAtlas.lua, it's an anonymous texture created with CreateTexture(nil, "BACKGROUND")
    -- We can iterate through regions to find it or just set all textures to match
    for _, region in ipairs({ frame:GetRegions() }) do
        if region:GetObjectType() == "Texture" then
            local r, g, b, a = 0, 0, 0, 1
            if frame.backdrop then
                r, g, b, a = frame.backdrop:GetBackdropColor()
            end
            region:SetTexture(r, g, b, 1) -- Set alpha to 1 for "completely black"
            region:SetAlpha(1)
        end
    end

    -- Style the close button on InsideAtlasFrame
    if AtlasCFM.Quest.UI.CloseButton then
        local closeButton = AtlasCFM.Quest.UI.CloseButton

        -- Hide pfUI auto-backdrop if present.
        if closeButton.backdrop then
            closeButton.backdrop:Hide()
        end

        closeButton:SetNormalTexture("")
        closeButton:SetPushedTexture("")
        closeButton:SetHighlightTexture("")

        -- Create custom X texture
        if not closeButton.customX then
            local customX = closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            customX:SetPoint("CENTER", 0, 0)
            customX:SetText("×")
            customX:SetTextColor(1, 0.2, 0.2)
            customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            closeButton.customX = customX
        end

        -- Position and size to match main frame buttons
        closeButton:SetWidth(20)
        closeButton:SetHeight(20)
        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

        -- Hover effect
        closeButton:SetScript("OnEnter", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.4, 0.4)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
            end
        end)
        closeButton:SetScript("OnLeave", function()
            if this.customX then
                this.customX:SetTextColor(1, 0.2, 0.2)
                this.customX:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
            end
        end)
    end

    -- Style navigation buttons if they exist
    if AtlasCFM.Quest.UI.NextPageButtonRight and not AtlasCFM.Quest.UI.NextPageButtonRight.pfui_skinned then
        AtlasCFM.Quest.UI.NextPageButtonRight:SetNormalTexture("Interface\\Glues\\Common\\Glue-RightArrow-Button-Up")
        AtlasCFM.Quest.UI.NextPageButtonRight:SetPushedTexture("Interface\\Glues\\Common\\Glue-RightArrow-Button-Down")
        AtlasCFM.Quest.UI.NextPageButtonRight:SetHighlightTexture(
            "Interface\\Glues\\Common\\Glue-RightArrow-Button-Highlight", "ADD")
        AtlasCFM.Quest.UI.NextPageButtonRight.pfui_skinned = true
    end

    if AtlasCFM.Quest.UI.NextPageButtonLeft and not AtlasCFM.Quest.UI.NextPageButtonLeft.pfui_skinned then
        AtlasCFM.Quest.UI.NextPageButtonLeft:SetNormalTexture("Interface\\Glues\\Common\\Glue-LeftArrow-Button-Up")
        AtlasCFM.Quest.UI.NextPageButtonLeft:SetPushedTexture("Interface\\Glues\\Common\\Glue-LeftArrow-Button-Down")
        AtlasCFM.Quest.UI.NextPageButtonLeft:SetHighlightTexture(
            "Interface\\Glues\\Common\\Glue-LeftArrow-Button-Highlight", "ADD")
        AtlasCFM.Quest.UI.NextPageButtonLeft.pfui_skinned = true
    end
end

---
--- Adds comparison support to Atlas tooltips
--- Works regardless of pfUI styling setting if pfUI is loaded
---
local function SetupTooltipComparison()
    if not IsPfUIBaseLoaded() then return end

    if AtlasCFMLootTooltip then
        -- Add comparison support
        if pfUI.eqcompare and pfUI.eqcompare.GameTooltipShow then
            -- Check if comparison is enabled in pfUI settings
            -- In pfUI, if the module is active, eqcompare.GameTooltipShow exists.
            -- We hook it directly.
            local origOnShow = AtlasCFMLootTooltip:GetScript("OnShow")
            AtlasCFMLootTooltip:SetScript("OnShow", function()
                if origOnShow then origOnShow() end
                pfUI.eqcompare.GameTooltipShow()
            end)

            local origOnHide = AtlasCFMLootTooltip:GetScript("OnHide")
            AtlasCFMLootTooltip:SetScript("OnHide", function()
                if origOnHide then origOnHide() end
                if ShoppingTooltip1 then ShoppingTooltip1:Hide() end
                if ShoppingTooltip2 then ShoppingTooltip2:Hide() end
            end)
        end
    end
end

---
--- Applies pfUI styling to tooltips
--- Already handled in LootUI.lua via setupPfUITooltip()
--- This function ensures consistency if tooltips are created later
---
local function StyleTooltips()
    if not IsPfUIStylingEnabled() then return end

    if AtlasCFMLootTooltip then
        pfUI.api.CreateBackdrop(AtlasCFMLootTooltip)
        pfUI.api.CreateBackdropShadow(AtlasCFMLootTooltip)
    end

    if AtlasCFMLootTooltip2 then
        pfUI.api.CreateBackdrop(AtlasCFMLootTooltip2)
        pfUI.api.CreateBackdropShadow(AtlasCFMLootTooltip2)
    end
end

---
--- Skins a Hewdrop menu level with pfUI style
--- @param level number - The level number to skin
---
function AtlasCFM.pfUI.StyleHewdropLevel(level)
    if not IsPfUIStylingEnabled() then return end

    local frame = _G["Hewdrop20Level" .. level]
    if frame and not frame.pfui_styled then
        -- The backdrop is a child frame created in AcquireLevel
        -- It's the first child that is a frame and has a backdrop
        for _, child in ipairs({ frame:GetChildren() }) do
            if child:GetObjectType() == "Frame" and child.SetBackdrop then
                -- Apply pfUI backdrop
                pfUI.api.CreateBackdrop(child, nil, true, 0.95)
                pfUI.api.CreateBackdropShadow(child)

                -- Adjust color to match pfUI standard
                if child.backdrop then
                    local r, g, b, a = GetPfUIBackgroundColor()
                    child.backdrop:SetBackdropColor(r, g, b, 0.95)
                end
                break
            end
        end
        frame.pfui_styled = true
    end
end

---
--- Applies pfUI styling to Hewdrop menu frames
--- Styles dropdown menu popups
---
local function StyleHewdropMenus()
    -- Hewdrop menus are created dynamically
    -- We mainly rely on the hook in AtlasCFMHewdrop.lua calling AtlasCFM.pfUI.StyleHewdropLevel
    -- But we check existing ones here just in case

    for i = 1, 10 do
        AtlasCFM.pfUI.StyleHewdropLevel(i)
    end
end

---
--- Applies pfUI styling to checkboxes
--- Styles all checkboxes in Atlas-CFM using pfUI.api.SkinCheckbox
---
local function StyleCheckboxes()
    if not pfUI.api.SkinCheckbox then return end

    -- Style checkboxes in options frame
    if AtlasCFMOptionsFrame then
        local function SkinCheckboxesRecursive(frame)
            for _, child in ipairs({ frame:GetChildren() }) do
                if child:GetObjectType() == "CheckButton" then
                    if not child.pfui_skinned then
                        pfUI.api.SkinCheckbox(child)
                        child.pfui_skinned = true
                    end
                end
                SkinCheckboxesRecursive(child)
            end
        end
        SkinCheckboxesRecursive(AtlasCFMOptionsFrame)
    end

    -- Style "Finished Quest" checkbox in embedded quest display
    if AtlasCFM.Quest and AtlasCFM.Quest.UI and AtlasCFM.Quest.UI.FinishedQuestCheckbox then
        local finishedCheck = AtlasCFM.Quest.UI.FinishedQuestCheckbox
        if not finishedCheck.pfui_skinned then
            pfUI.api.SkinCheckbox(finishedCheck)
            finishedCheck.pfui_skinned = true
        end
    end
end

---
--- Applies pfUI styling to options frame
--- Styles the options/settings window
---
local function StyleOptionsFrame()
    if not AtlasCFMOptionsFrame then return end

    -- Apply pfUI backdrop
    pfUI.api.CreateBackdrop(AtlasCFMOptionsFrame, nil, nil, 0.85)
    pfUI.api.CreateBackdropShadow(AtlasCFMOptionsFrame)

    -- Style all buttons and checkboxes in options frame using SkinButton/SkinCheckbox
    if pfUI.api.SkinButton then
        local function SkinElementsRecursive(frame)
            for _, child in ipairs({ frame:GetChildren() }) do
                if not child.pfui_skinned then
                    if child:GetObjectType() == "Button" then
                        pfUI.api.SkinButton(child)
                        child.pfui_skinned = true
                    elseif child:GetObjectType() == "CheckButton" and pfUI.api.SkinCheckbox then
                        pfUI.api.SkinCheckbox(child)
                        child.pfui_skinned = true
                    end
                end
                SkinElementsRecursive(child)
            end
        end
        SkinElementsRecursive(AtlasCFMOptionsFrame)
    end

    -- Style checkboxes (calls the dedicated function for any missed or external ones)
    StyleCheckboxes()
end

---
--- Applies pfUI styling to profession frames and their Atlas components
---
function AtlasCFM.pfUI.StyleProfessionFrames()
    if not IsPfUIStylingEnabled() then return end

    -- Style AtlasCFM buttons in profession frames
    if TradeSkillFrameAtlasButton then
        AtlasCFM.pfUI.RestyleButton("TradeSkillFrameAtlasButton")
    end
    if CraftFrameAtlasButton then
        AtlasCFM.pfUI.RestyleButton("CraftFrameAtlasButton")
    end


    if AtlasCFMCraftCategories and not AtlasCFMCraftCategories.pfui_skinned then
        pfUI.api.SkinCheckbox(AtlasCFMCraftCategories)
        AtlasCFMCraftCategories.pfui_skinned = true
    end
    if AtlasCFMCraftShowSkillLevels and not AtlasCFMCraftShowSkillLevels.pfui_skinned then
        pfUI.api.SkinCheckbox(AtlasCFMCraftShowSkillLevels)
        AtlasCFMCraftShowSkillLevels.pfui_skinned = true
    end
    if AtlasCFMTradeSkillShowLevels and not AtlasCFMTradeSkillShowLevels.pfui_skinned then
        pfUI.api.SkinCheckbox(AtlasCFMTradeSkillShowLevels)
        AtlasCFMTradeSkillShowLevels.pfui_skinned = true
    end

    local allBtn = _G["AtlasCFMCraftCollapseAll"]
    if allBtn then
        AtlasCFM.pfUI.SkinCollapseAllButton(allBtn)
        allBtn.pfui_skinned = true
    end

    -- Style search boxes
    if AtlasCFMTradeSkillSearchBox then
        AtlasCFM.pfUI.SkinEditBox(AtlasCFMTradeSkillSearchBox)
    end
    if AtlasCFMCraftSearchBox then
        AtlasCFM.pfUI.SkinEditBox(AtlasCFMCraftSearchBox)
    end

    -- Style side tabs
    for i = 1, 20 do -- Scan up to 20 potential tabs
        local tab = _G["AtlasCFMProfessionTab" .. i]
        if tab then
            if not tab.pfui_skinned then
                if pfUI.api.CreateBackdrop then
                    pfUI.api.CreateBackdrop(tab, nil, true)
                end

                -- Hide original background texture/textures
                if tab.bg then tab.bg:Hide() end

                -- The template uses these textures
                local textures = {
                    tab:GetNormalTexture(),
                    tab:GetPushedTexture(),
                    tab:GetHighlightTexture(),
                    tab:GetDisabledTexture(),
                    tab:GetCheckedTexture(),
                }

                for _, tex in ipairs(textures) do
                    if tex then
                        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                        tex:ClearAllPoints()
                        tex:SetPoint("TOPLEFT", tab, "TOPLEFT", 2, -2)
                        tex:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -2, 2)
                    end
                end

                tab.pfui_skinned = true
            end
        end
    end
end

---
--- Main initialization function
--- Applies all pfUI styling when pfUI is detected
---
function AtlasCFM.pfUI.Initialize()
    if not IsPfUIBaseLoaded() then
        return
    end

    -- Setup tooltip comparison (works even if styling is disabled)
    SetupTooltipComparison()

    -- Apply styling only if enabled in options
    if not IsPfUIStylingEnabled() then
        return
    end

    -- Apply styling to all components
    StyleMainFrame()
    StyleDropdowns()
    StyleButtons()
    StyleSearchBox()
    StyleScrollBar()
    StyleLootItemsFrame()
    StyleLootPanel()
    StyleContainerFrame()
    StyleQuestFrame()
    StyleInsideAtlasFrame()
    StyleTooltips()
    StyleHewdropMenus()
    StyleOptionsFrame()
    StyleCheckboxes()
    AtlasCFM.pfUI.StyleProfessionFrames()

    -- Create a delayed hook for dynamically created frames
    -- Some frames are created after ADDON_LOADED
    local delayedStyle = CreateFrame("Frame")
    delayedStyle:RegisterEvent("PLAYER_ENTERING_WORLD")
    delayedStyle:SetScript("OnEvent", function()
        -- Restyle components that might be created late
        StyleLootPanel()
        StyleContainerFrame()
        StyleQuestFrame()
        StyleInsideAtlasFrame()
        StyleButtons()
        StyleCheckboxes()
        StyleHewdropMenus()
        this:UnregisterAllEvents()
    end)
end

local init = CreateFrame("Frame")
init:RegisterEvent("ADDON_LOADED")
init:RegisterEvent("PLAYER_ENTERING_WORLD")
init:SetScript("OnEvent", function()
    if arg1 == "Atlas-CFM" then
        this.atlasLoaded = true
    elseif arg1 == "pfUI" then
        this.pfuiLoaded = true
    elseif arg1 == "Blizzard_TradeSkillUI" or arg1 == "Blizzard_CraftUI" then
        if AtlasCFM.pfUI and AtlasCFM.pfUI.Initialize then
            AtlasCFM.pfUI.Initialize()
        end
    end

    if (this.atlasLoaded or IsAddOnLoaded("Atlas-CFM")) and (this.pfuiLoaded or IsAddOnLoaded("pfUI")) then
        this:SetScript("OnUpdate", function()
            AtlasCFM.pfUI.Initialize()
            this:SetScript("OnUpdate", nil)
        end)
        this:UnregisterAllEvents()
    end
end)
