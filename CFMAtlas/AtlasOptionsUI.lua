---
--- AtlasOptionsUI.lua - Atlas options UI frame and components
---
--- This file contains the options UI frame creation and management for Atlas-CFM.
--- It handles the options window interface, UI controls, frame positioning,
--- and provides the visual components for Atlas configuration settings.
---
--- Features:
--- - Options frame creation and styling
--- - UI control initialization
--- - Frame positioning and movement
--- - Visual component management
--- - Options interface layout
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = AtlasCFM or {}

local L = AtlasCFM.Localization.UI
local LS = AtlasCFM.Localization.Spells

do
    -- Create the main options frame
    local optionsFrame = CreateFrame("Frame", "AtlasCFMOptionsFrame", UIParent)
    optionsFrame:SetFrameStrata("DIALOG")
    optionsFrame:SetHeight(570)
    optionsFrame:SetWidth(570)
    optionsFrame:SetPoint("CENTER", 0, 0)
    optionsFrame:SetMovable(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:EnableMouse(true)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:Hide()
    tinsert(UISpecialFrames, "AtlasCFMOptionsFrame")
    optionsFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    optionsFrame:SetBackdropColor(0, 0, 0, 1)
    optionsFrame:SetBackdropBorderColor(0.80, 0.60, 0.25, 1)

    -- Frame scripts
    optionsFrame:SetScript("OnDragStart", function()
        this:StartMoving()
        this.isMoving = true
    end)
    optionsFrame:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
        this.isMoving = false
    end)
    -- Set up frame show script to initialize values
    optionsFrame:SetScript("OnShow", function()
        AtlasCFM.OptionsInit()

        if AtlasCFMOptionProfessionInfo then
            AtlasCFMOptionProfessionInfo:SetChecked(AtlasCFMOptions.ProfessionInfo)
        end

        -- Reagent Options
        if AtlasCFMOptionReagentRowsSlider then
            AtlasCFMOptionReagentRowsSlider:SetValue(AtlasCFMOptions.ReagentRows or 20)
            AtlasOptions_UpdateSlider(L["Reagent Rows"])
        end

        if AtlasCFMOptions.ReagentProfessions then
            if AtlasCFMOptionReagentAlchemy then
                AtlasCFMOptionReagentAlchemy:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Alchemy"])
            end
            if AtlasCFMOptionReagentBS then
                AtlasCFMOptionReagentBS:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Blacksmithing"])
            end
            if AtlasCFMOptionReagentEnchant then
                AtlasCFMOptionReagentEnchant:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Enchanting"])
            end
            if AtlasCFMOptionReagentEngi then
                AtlasCFMOptionReagentEngi:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Engineering"])
            end
            if AtlasCFMOptionReagentLW then
                AtlasCFMOptionReagentLW:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Leatherworking"])
            end
            if AtlasCFMOptionReagentTailor then
                AtlasCFMOptionReagentTailor:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Tailoring"])
            end
            if AtlasCFMOptionReagentCooking then
                AtlasCFMOptionReagentCooking:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Cooking"])
            end
            if AtlasCFMOptionReagentFirstAid then
                AtlasCFMOptionReagentFirstAid:SetChecked(AtlasCFMOptions
                    .ReagentProfessions["First Aid"])
            end
            if AtlasCFMOptionReagentJC then
                AtlasCFMOptionReagentJC:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Jewelcrafting"])
            end
            if AtlasCFMOptionReagentMining then
                AtlasCFMOptionReagentMining:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Mining"])
            end
            if AtlasCFMOptionReagentPoisons then
                AtlasCFMOptionReagentPoisons:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Poisons"])
            end
            if AtlasCFMOptionReagentSurvival then
                AtlasCFMOptionReagentSurvival:SetChecked(AtlasCFMOptions.ReagentProfessions
                    ["Survival"])
            end
        end
    end)

    optionsFrame:SetScript("OnHide", function()
        if AtlasCFM.SyncOptionsBackup then
            AtlasCFM.SyncOptionsBackup()
        end
    end)

    -- Title
    local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", optionsFrame, "TOP", 0, -15)
    title:SetText(L["Options"])

    -- AtlasOptionsText
    local atlasOptionText = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    atlasOptionText:SetPoint("BOTTOM", title, "BOTTOM", -160, -25)
    atlasOptionText:SetText("AtlasCFM")

    -- Atlas Options Checkboxes Data
    local atlasCheckboxes = {
        {
            name = "AtlasCFMOptionToggleButton",
            text = L["Show Button on Minimap"],
            script = function()
                AtlasCFM.MinimapButtonOnClick()
            end
        },
        {
            name = "AtlasCFMOptionAutoSelect",
            text = L["Auto-Select Instance Map"],
            script = function()
                AtlasCFM.OptionsAutoSelectOnClick()
            end
        },
        {
            name = "AtlasCFMOptionRightClick",
            text = L["Right-Click for World Map"],
            script = function()
                AtlasCFM.OptionsWorldMapOnClick()
            end
        },
        {
            name = "AtlasCFMOptionAcronyms",
            text = L["Show Acronyms"],
            script = function()
                AtlasCFM.OptionsAcronymsOnClick()
            end
        },
        {
            name = "AtlasCFMOptionClamped",
            text = L["Clamp window to screen"],
            script = function()
                AtlasCFM.OptionsClampedOnClick()
            end
        },
        {
            name = "AtlasCFMOptionCursorCoords",
            text = L["Show Cursor Coordinates on Map"],
            script = function()
                AtlasCFM.OptionsCursorCoordsOnClick()
            end
        },
        {
            name = "AtlasCFMOptionMapMarkers",
            text = L["Show Map Markers"],
            script = function()
                AtlasCFM.OptionMapMarkersOnClick()
            end
        },
        {
            name = "AtlasCFMOptionPfUI",
            text = L["Enable pfUI Styling"],
            script = function()
                AtlasCFM.OptionsPfUIOnClick()
            end
        },
    }

    for i, config in ipairs(atlasCheckboxes) do
        local checkbox = CreateFrame("CheckButton", config.name, optionsFrame, "OptionsCheckButtonTemplate")
        _G[checkbox:GetName() .. "Text"]:SetText(config.text)
        checkbox:SetScript("OnClick", config.script)
        config.frame = checkbox
    end

    local function UpdateAtlasCheckboxes()
        local previousElement = atlasOptionText
        local firstInColumn = true
        for i, config in ipairs(atlasCheckboxes) do
            if AtlasCFM.Server.IsVisible(config, false) then
                config.frame:Show()
                config.frame:ClearAllPoints()
                if firstInColumn then
                    config.frame:SetPoint("BOTTOM", previousElement, "BOTTOM", -80, -35)
                    firstInColumn = false
                else
                    config.frame:SetPoint("BOTTOM", previousElement, "BOTTOM", 0, -25)
                end
                previousElement = config.frame
            else
                config.frame:Hide()
            end
        end
        return previousElement
    end

    -- Atlas Options Sliders Data
    local atlasSliders = {
        {
            name = "AtlasCFMOptionSliderButtonPos",
            label = L["Button Position"],
            min = 0,
            max = 360,
            step = 1,
            value = 336,
            option = "AtlasButtonPosition",
            updateFunc = AtlasCFM.MinimapButtonUpdatePosition
        },
        {
            name = "AtlasCFMOptionSliderButtonRad",
            label = L["Button Radius"],
            min = 0,
            max = 200,
            step = 1,
            value = 78,
            option = "AtlasButtonRadius",
            updateFunc = AtlasCFM.MinimapButtonUpdatePosition
        },
        {
            name = "AtlasCFMOptionSliderAlpha",
            label = L["Transparency"],
            min = 0.25,
            max = 1.0,
            step = 0.01,
            value = 1.0,
            option = "AtlasAlpha",
            updateFunc = AtlasCFM.OptionsUpdateAlpha
        },
        {
            name = "AtlasCFMOptionSliderScale",
            label = L["Scale"],
            min = 0.25,
            max = 1.5,
            step = 0.01,
            value = 1.0,
            option = "AtlasScale",
            updateFunc = AtlasCFM.OptionsUpdateScale
        }
    }
    -- Creates slider controls for Atlas options
    -- @param startElement - The UI element to position sliders relative to
    -- @return The last created slider element for further positioning
    -- Each slider controls different Atlas settings like button position, transparency etc.
    local function CreateAtlasSliders(startElement)
        local previousElement = startElement
        local xOffset, yOffset = 0, -27
        for i, config in ipairs(atlasSliders) do
            if config and config.name and config.label then
                local slider = CreateFrame("Slider", config.name, optionsFrame, "OptionsSliderTemplate")
                slider:SetWidth(180)
                xOffset = (i == 1) and 78 or 0
                slider:SetPoint("BOTTOM", previousElement, "BOTTOM", xOffset, yOffset)
                slider:SetMinMaxValues(config.min or 0, config.max or 1)
                slider:SetValueStep(config.step or 0.01)
                slider:SetValue(config.value or 0)
                _G[slider:GetName() .. "Text"]:SetText(config.label .. " (" .. slider:GetValue() .. ")")
                _G[slider:GetName() .. "Low"]:SetText(tostring(config.min or 0))
                _G[slider:GetName() .. "High"]:SetText(tostring(config.max or 1))
                local sliderLabel = config.label
                local optionName = config.option
                local updateFunc = config.updateFunc
                slider:SetScript("OnValueChanged", function()
                    AtlasOptions_UpdateSlider(sliderLabel)
                    AtlasCFMOptions[optionName] = this:GetValue()
                    updateFunc()
                end)
                config.frame = slider
                previousElement = slider
            end
        end
        return previousElement
    end

    local function UpdateAtlasSliders(startElement)
        local previousElement = startElement
        local xOffset, yOffset = 0, -27
        for i, config in ipairs(atlasSliders) do
            if config.frame then
                xOffset = (i == 1) and 78 or 0
                config.frame:ClearAllPoints()
                config.frame:SetPoint("BOTTOM", previousElement, "BOTTOM", xOffset, yOffset)
                previousElement = config.frame
            end
        end
        return previousElement
    end

    local lastElement = UpdateAtlasCheckboxes()
    CreateAtlasSliders(lastElement)
    lastElement = UpdateAtlasSliders(lastElement)

    -- Reset position button
    local resetPosition = CreateFrame("Button", nil, optionsFrame, "OptionsButtonTemplate")
    resetPosition:SetPoint("BOTTOMLEFT", 20, 15)
    resetPosition:SetWidth(120)
    resetPosition:SetText(L["Reset Position"])
    resetPosition:SetScript("OnClick", function()
        AtlasCFM.OptionResetPosition()
    end)

    -- Default settings button
    local defaultSettingsButton = CreateFrame("Button", nil, resetPosition, "OptionsButtonTemplate")
    defaultSettingsButton:SetPoint("RIGHT", 150, 0)
    defaultSettingsButton:SetWidth(140)
    defaultSettingsButton:SetText(L["Reset Settings"])
    defaultSettingsButton:SetScript("OnClick", function()
        AtlasCFM.OptionDefaultSettings()
    end)
    -- Done button
    local doneButton = CreateFrame("Button", nil, optionsFrame, "OptionsButtonTemplate")
    doneButton:SetPoint("BOTTOMRIGHT", -20, 15)
    doneButton:SetText(L["Done"])
    doneButton:SetScript("OnClick", function()
        AtlasCFM.OptionsOnClick()
    end)

    -- Categories dropdown (Hewdrop-based)
    local dropDownCats = CreateFrame("Button", "AtlasCFMOptionsFrameDropDownCats", optionsFrame)
    dropDownCats:SetWidth(100)
    dropDownCats:SetHeight(20)
    dropDownCats:SetPoint("TOP", doneButton, "TOP", 5, 30)

    -- Background texture
    local dropDownCatsBg = dropDownCats:CreateTexture(nil, "BACKGROUND")
    dropDownCatsBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    dropDownCatsBg:SetVertexColor(0.1, 0.1, 0.1, 0.8)
    dropDownCatsBg:SetAllPoints(dropDownCats)

    -- Text display
    local dropDownCatsText = dropDownCats:CreateFontString("AtlasCFMOptionsFrameDropDownCatsText", "OVERLAY",
        "GameFontHighlightSmall")
    dropDownCatsText:SetPoint("RIGHT", dropDownCats, "RIGHT", -20, 0)
    dropDownCatsText:SetJustifyH("LEFT")

    -- Arrow texture
    local dropDownCatsArrow = dropDownCats:CreateTexture(nil, "OVERLAY")
    dropDownCatsArrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    dropDownCatsArrow:SetWidth(16)
    dropDownCatsArrow:SetHeight(16)
    dropDownCatsArrow:SetPoint("RIGHT", dropDownCats, "RIGHT", -2, 0)

    -- Highlight
    local dropDownCatsHighlight = dropDownCats:CreateTexture(nil, "HIGHLIGHT")
    dropDownCatsHighlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    dropDownCatsHighlight:SetBlendMode("ADD")
    dropDownCatsHighlight:SetAllPoints(dropDownCats)

    dropDownCats:SetScript("OnClick", function()
        if AtlasCFM.HewdropMenus:IsOpen(dropDownCats) then
            AtlasCFM.HewdropMenus:Close()
        else
            AtlasCFM.HewdropMenus:OpenSortByMenu(dropDownCats)
        end
    end)

    local dropDownCatsLabel = dropDownCats:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
    dropDownCatsLabel:SetText(L["Sort Instance by:"])
    dropDownCatsLabel:SetPoint("TOP", 0, 12)

    dropDownCats:SetScript("OnShow", function()
        AtlasCFM.OptionFrameDropDownCatsOnShow()
    end)

    -- Server selection dropdown
    local dropDownServer = CreateFrame("Button", "AtlasCFMOptionsFrameDropDownServer", optionsFrame)
    dropDownServer:SetWidth(100)
    dropDownServer:SetHeight(20)
    dropDownServer:SetPoint("RIGHT", dropDownCats, "LEFT", -15, 0)

    -- Background texture
    local dropDownServerBg = dropDownServer:CreateTexture(nil, "BACKGROUND")
    dropDownServerBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    dropDownServerBg:SetVertexColor(0.1, 0.1, 0.1, 0.8)
    dropDownServerBg:SetAllPoints(dropDownServer)

    -- Text display
    local dropDownServerText = dropDownServer:CreateFontString("AtlasCFMOptionsFrameDropDownServerText", "OVERLAY",
        "GameFontHighlightSmall")
    dropDownServerText:SetPoint("RIGHT", dropDownServer, "RIGHT", -20, 0)
    dropDownServerText:SetJustifyH("LEFT")

    -- Arrow texture
    local dropDownServerArrow = dropDownServer:CreateTexture(nil, "OVERLAY")
    dropDownServerArrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    dropDownServerArrow:SetWidth(16)
    dropDownServerArrow:SetHeight(16)
    dropDownServerArrow:SetPoint("RIGHT", dropDownServer, "RIGHT", -2, 0)

    -- Highlight
    local dropDownServerHighlight = dropDownServer:CreateTexture(nil, "HIGHLIGHT")
    dropDownServerHighlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    dropDownServerHighlight:SetBlendMode("ADD")
    dropDownServerHighlight:SetAllPoints(dropDownServer)

    dropDownServer:SetScript("OnClick", function()
        if AtlasCFM.HewdropMenus:IsOpen(dropDownServer) then
            AtlasCFM.HewdropMenus:Close()
        else
            AtlasCFM.HewdropMenus:OpenServerMenu(dropDownServer)
        end
    end)

    local dropDownServerLabel = dropDownServer:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
    dropDownServerLabel:SetText(L["Server:"])
    dropDownServerLabel:SetPoint("TOP", 0, 12)

    dropDownServer:SetScript("OnShow", function()
        if AtlasCFM.HewdropMenus and AtlasCFM.HewdropMenus.UpdateServerLabel then
            AtlasCFM.HewdropMenus.UpdateServerLabel()
        end
    end)

    -- QuestOptionsText
    local questOptionText = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    questOptionText:SetPoint("BOTTOM", title, "BOTTOM", 120, -25)
    questOptionText:SetText(L["Quest"])

    -- Quest Checkboxes Data
    local questCheckboxes = {
        {
            name = "AtlasCFMOptionAutoshow",
            text = L["Show the Quest Panel with AtlasCFM"],
            script = function()
                AtlasCFM.OptionAutoshowOnClick()
            end
        },
        {
            name = "AtlasCFMOptionLeftSide",
            text = L["Show Quest Panel on the Left"],
            script = function()
                AtlasCFM.OptionLeftSideOnClick()
            end
        },
        {
            name = "AtlasCFMOptionColor",
            text = L["Color Quests by Level"],
            script = function()
                AtlasCFM.OptionColorOnClick()
            end
        },
        {
            name = "AtlasCFMOptionQuestlog",
            text = L["Color Quests from the Questlog"],
            script = function()
                AtlasCFM.OptionQuestlogOnClick()
            end
        },
        {
            name = "AtlasCFMOptionAutoQuery",
            text = L["Auto-Query Unknown Items"],
            script = function()
                AtlasCFM.OptionAutoQueryOnClick()
            end
        },
    }

    for i, config in ipairs(questCheckboxes) do
        local checkbox = CreateFrame("CheckButton", config.name, optionsFrame, "OptionsCheckButtonTemplate")
        _G[config.name .. "Text"]:SetText(config.text)
        checkbox:SetScript("OnClick", config.script)
        config.frame = checkbox
    end

    local function UpdateQuestCheckboxes()
        local previousCheckbox = nil
        local firstInColumn = true
        for i, config in ipairs(questCheckboxes) do
            if AtlasCFM.Server.IsVisible(config, false) then
                config.frame:Show()
                config.frame:ClearAllPoints()
                if firstInColumn then
                    config.frame:SetPoint("BOTTOM", questOptionText, "BOTTOM", -125, -35)
                    firstInColumn = false
                else
                    config.frame:SetPoint("BOTTOM", previousCheckbox, "BOTTOM", 0, -25)
                end
                previousCheckbox = config.frame
            else
                config.frame:Hide()
            end
        end
    end

    -- Loot Options Text
    local lootOptionText = optionsFrame:CreateFontString("", "ARTWORK", "GameFontNormal")
    lootOptionText:SetPoint("BOTTOM", lastElement, "BOTTOM", 0, -25)
    lootOptionText:SetText(L["Loot"])

    -- Checkbox configuration
    local lootCheckboxes = {
        {
            name = "AtlasCFMOptionShowPanel",
            text = L["Show Loot Panel with AtlasCFM"],
            script = function()
                AtlasCFM.OptionShowPanelOnClick()
            end
        },
        {
            name = "AtlasCFMOptionEquipCompare",
            text = L["Use EquipCompare"],
            script = function()
                AtlasCFM.OptionEquipCompareOnClick()
            end
        },
        {
            name = "AtlasCFMOptionOpaque",
            text = L["Make Loot Table Opaque"],
            script = function()
                AtlasCFM.OptionOpaqueOnClick()
            end
        },
        {
            name = "AtlasCFMOptionTooltipID",
            text = L["Show IDs in Tooltips"],
            script = function()
                AtlasCFM.OptionTooltipIDOnClick()
            end
        },
        {
            name = "AtlasCFMOptionTooltipIcon",
            text = L["Show Icon in Tooltips"],
            script = function()
                AtlasCFM.OptionTooltipIconOnClick()
            end
        },
        {
            name = "AtlasCFMOptionShowSource",
            text = L["Show Source on Tooltips"],
            script = function()
                AtlasCFM.OptionShowSourceOnClick()
            end
        },
        {
            name = "AtlasCFMOptionProfessionInfo",
            text = L["Enable Profession Info"],
            script = function()
                AtlasCFM.OptionProfessionInfoOnClick()
            end
        }
    }

    for i, config in ipairs(lootCheckboxes) do
        local checkbox = CreateFrame("CheckButton", config.name, optionsFrame, "OptionsCheckButtonTemplate")
        _G[config.name .. "Text"]:SetText(config.text)
        checkbox:SetScript("OnClick", config.script)
        config.frame = checkbox
    end

    local function UpdateLootCheckboxes()
        local previousCheckbox = nil
        local visibleCount = 0
        local visibleFrames = {}
        for i, config in ipairs(lootCheckboxes) do
            if AtlasCFM.Server.IsVisible(config, false) then
                config.frame:Show()
                config.frame:ClearAllPoints()
                visibleCount = visibleCount + 1
                visibleFrames[visibleCount] = config.frame

                if visibleCount == 1 then
                    config.frame:SetPoint("BOTTOM", lootOptionText, "BOTTOM", -78, -35)
                elseif visibleCount <= 5 then
                    config.frame:SetPoint("BOTTOM", previousCheckbox, "BOTTOM", 0, -25)
                else
                    local referenceCheckbox = visibleFrames[visibleCount - 5]
                    config.frame:SetPoint("RIGHT", referenceCheckbox, "RIGHT", 235, 0)
                end
                previousCheckbox = config.frame
            else
                config.frame:Hide()
            end
        end
    end

    do
        -- Reagent Options Section
        local reagentOptionText = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        reagentOptionText:SetPoint("BOTTOM", title, "BOTTOM", 130, -170)
        reagentOptionText:SetText(L["Reagent Tooltip Options"])

        -- Reagent Rows Slider
        local reagentRowsSlider = CreateFrame("Slider", "AtlasCFMOptionReagentRowsSlider", optionsFrame,
            "OptionsSliderTemplate")
        reagentRowsSlider:SetPoint("TOPLEFT", reagentOptionText, "BOTTOMLEFT", -120, -25)
        reagentRowsSlider:SetMinMaxValues(0, 30)
        reagentRowsSlider:SetValueStep(1)
        reagentRowsSlider:SetWidth(180)
        _G[reagentRowsSlider:GetName() .. "Text"]:SetText(L["Reagent Rows"])
        _G[reagentRowsSlider:GetName() .. "Low"]:SetText("0")
        _G[reagentRowsSlider:GetName() .. "High"]:SetText("30")

        reagentRowsSlider:SetScript("OnValueChanged", function()
            AtlasOptions_UpdateSlider(L["Reagent Rows"])
            AtlasCFMOptions.ReagentRows = this:GetValue()
            if AtlasCFM.DataIndex and AtlasCFM.DataIndex.CheckAndBuildIndex then
                AtlasCFM.DataIndex.CheckAndBuildIndex()
            end
        end)

        -- Profession Filters
        local profData = {
            { name = "Alchemy",  text = LS["Alchemy"],        key = "Alchemy" },
            { name = "BS",       text = LS["Blacksmithing"],  key = "Blacksmithing" },
            { name = "Enchant",  text = LS["Enchanting"],     key = "Enchanting" },
            { name = "Survival", text = LS["Survival"],       key = "Survival",      servers = { AtlasCFM.Server.TURTLE1 } },
            { name = "Engi",     text = LS["Engineering"],    key = "Engineering" },
            { name = "LW",       text = LS["Leatherworking"], key = "Leatherworking" },
            { name = "Tailor",   text = LS["Tailoring"],      key = "Tailoring" },
            { name = "Cooking",  text = LS["Cooking"],        key = "Cooking" },
            { name = "FirstAid", text = LS["First Aid"],      key = "First Aid" },
            { name = "JC",       text = LS["Jewelcrafting"],  key = "Jewelcrafting", servers = { AtlasCFM.Server.TURTLE1 } },
            { name = "Mining",   text = LS["Mining"],         key = "Mining" },
            { name = "Poisons",  text = LS["Poisons"],        key = "Poisons" }
        }

        for _, data in ipairs(profData) do
            local cb = CreateFrame("CheckButton", "AtlasCFMOptionReagent" .. data.name, optionsFrame,
                "OptionsCheckButtonTemplate")
            _G[cb:GetName() .. "Text"]:SetText(data.text)
            local key = data.key
            cb:SetScript("OnClick", function()
                if not AtlasCFMOptions then return end
                if not AtlasCFMOptions.ReagentProfessions then AtlasCFMOptions.ReagentProfessions = {} end
                AtlasCFMOptions.ReagentProfessions[key] = this:GetChecked() and true or false
            end)
            data.frame = cb
        end

        local function UpdateProfCheckboxes()
            local col1X, col2X = -10, 100

            local cols = { {}, {}, {} }

            local function AddToCol(colIdx, name)
                for _, data in ipairs(profData) do
                    if data.name == name and AtlasCFM.Server.IsVisible({ servers = data.servers }, false) then
                        table.insert(cols[colIdx], data)
                    end
                end
            end

            AddToCol(1, "Alchemy")
            AddToCol(1, "BS")
            AddToCol(1, "Enchant")
            AddToCol(1, "Survival")

            AddToCol(2, "Engi")
            AddToCol(2, "LW")
            AddToCol(2, "Tailor")

            AddToCol(3, "Cooking")
            AddToCol(3, "FirstAid")
            AddToCol(3, "JC")
            AddToCol(3, "Mining")
            AddToCol(3, "Poisons")

            for _, data in ipairs(profData) do
                data.frame:Hide()
            end

            local function LayoutCol(col, anchorFrame, offsetX, offsetY, nextOffsetY)
                local prev = nil
                for i, data in ipairs(col) do
                    data.frame:Show()
                    data.frame:ClearAllPoints()
                    if i == 1 then
                        if offsetX then
                            data.frame:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", offsetX, offsetY or 0)
                        else
                            data.frame:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", -10, offsetY or 0)
                        end
                    else
                        data.frame:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, nextOffsetY or -5)
                    end
                    prev = data.frame
                end
                return col[1] and col[1].frame or nil
            end

            local c1 = LayoutCol(cols[1], reagentRowsSlider, nil, -15, -5)
            local c2 = LayoutCol(cols[2], c1, col2X, 0, -5)
            local c3 = LayoutCol(cols[3], c2, col2X, 0, -5)
        end

        AtlasCFM.UpdateOptionsUI = function()
            local lastE = UpdateAtlasCheckboxes()
            lastE = UpdateAtlasSliders(lastE)
            if lootOptionText then
                lootOptionText:ClearAllPoints()
                lootOptionText:SetPoint("BOTTOM", lastE, "BOTTOM", 0, -25)
            end
            UpdateQuestCheckboxes()
            UpdateLootCheckboxes()
            UpdateProfCheckboxes()
        end

        -- Call initially
        AtlasCFM.UpdateOptionsUI()
    end
end
