local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}
AtlasCFM.ProfessionHooks = AtlasCFM.ProfessionHooks or {}

local LS = AtlasCFM.Localization.Spells
local L = AtlasCFM.Localization.UI

-- Server mode helpers
function AtlasCFM.ProfessionHooks.IsTurtleLatest()
    if AtlasCFM.Server and AtlasCFM.Server.GetActive then
        return AtlasCFM.Server.GetActive() == AtlasCFM.Server.TURTLE
    end
    return false
end

-- Apply correct hooks based on active server
function AtlasCFM.ProfessionHooks.ApplyHooks()
    if not AtlasCFM.ProfessionHooks._blizzardTradeSkillFrame_Update then
        AtlasCFM.ProfessionHooks._blizzardTradeSkillFrame_Update = TradeSkillFrame_Update
    end
    -- Restore Blizzard original
    TradeSkillFrame_Update = AtlasCFM.ProfessionHooks._blizzardTradeSkillFrame_Update

    if AtlasCFM.ProfessionHooks.IsTurtleLatest() then
        local orig = TradeSkillFrame_Update
        TradeSkillFrame_Update = function()
            orig()
            AtlasCFM.ProfessionHooks.OnTradeSkillUpdate_TurtleLatest()
        end
    else
        AtlasCFM.TradeSkillFilter_Hooked = nil
        AtlasCFM.ProfessionHooks.TradeSkillFilter.HookTradeSkillFrameUpdate()
    end
end

-- Configuration
local TABS_ORDER = {
    "Alchemy", "Blacksmithing", "Enchanting", "Engineering",
    "Leatherworking", "Tailoring", "Jewelcrafting",
    "Cooking", "First Aid", "Mining", "Poisons", "Smelting",
    "Disguise", "Survival"
}

-- Cache logic moved to Core/DataIndex.lua
-- This module now only handles UI hooking and display

-- Register callback to update UI when indexing progresses
if AtlasCFM.DataIndex and AtlasCFM.DataIndex.RegisterCallback then
    AtlasCFM.DataIndex.RegisterCallback(function()
        if TradeSkillFrame and TradeSkillFrame:IsVisible() then
            AtlasCFM.ProfessionHooks.OnTradeSkillUpdate()
        end
        if CraftFrame and CraftFrame:IsVisible() then
            CraftFrame_Update()
        end
    end)
end


-- Side Tabs Implementation
local sideTabs = {}

function AtlasCFM.ProfessionHooks.UpdateSideTabs(frame)
    if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
        for _, tab in ipairs(sideTabs) do tab:Hide() end
        return
    end

    local playerProfessions = {}
    local numTabs = GetNumSpellTabs()

    -- Scan spellbook
    for i = 1, numTabs do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for s = offset + 1, offset + numSpells do
            local spellName, _ = GetSpellName(s, "BOOKTYPE_SPELL")
            local texture = GetSpellTexture(s, "BOOKTYPE_SPELL")

            local found = false
            for _, engName in ipairs(TABS_ORDER) do
                local locName = LS[engName] or engName
                if spellName == locName then
                    found = true
                    break
                end
            end

            if found then
                table.insert(playerProfessions, { name = spellName, texture = texture })
            end
        end
    end

    -- Create/Update Tabs
    for i, prof in ipairs(playerProfessions) do
        if not sideTabs[i] then
            local tab = CreateFrame("CheckButton", "AtlasCFMProfessionTab" .. i, frame, "SpellBookSkillLineTabTemplate")
            tab:SetWidth(32)
            tab:SetHeight(32)

            local bg = tab:CreateTexture(nil, "BACKGROUND")
            bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
            bg:SetWidth(64)
            bg:SetHeight(64)
            bg:SetPoint("TOPLEFT", -3, 11)
            tab.bg = bg

            -- No mouseover highlight on profession side tabs.
            tab:SetHighlightTexture("")

            -- No selected-state yellow overlay/border either.
            -- Keep a valid checked texture object, but make it fully invisible so
            -- the profession icon and tab background remain unchanged.
            tab:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
            local checkedTexture = tab:GetCheckedTexture()
            checkedTexture:SetBlendMode("BLEND")
            checkedTexture:SetAlpha(0)

            tab:SetScript("OnEnter", function()
                GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
                GameTooltip:SetText(this.spellName)
            end)
            tab:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            sideTabs[i] = tab
        end

        local tab = sideTabs[i]
        tab:SetParent(frame)
        tab:SetFrameLevel(frame:GetFrameLevel() + 5)
        tab:Show()
        tab:ClearAllPoints()
        local closeBtn = _G[frame:GetName() .. "CloseButton"]
        if closeBtn then
            local firstTabXOffset = -3
            if IsAddOnLoaded("pfUI") then
                firstTabXOffset = 10
            end
            if i == 1 then
                tab:SetPoint("TOPLEFT", closeBtn, "TOPRIGHT", firstTabXOffset, -22)
            else
                tab:SetPoint("TOPLEFT", sideTabs[i - 1], "BOTTOMLEFT", 0, -17)
            end
        else
            tab:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -30 + (i - 1) * -50)
        end

        tab:SetNormalTexture(prof.texture)
        tab.spellName = prof.name

        local currentName = nil
        if frame == TradeSkillFrame then
            currentName = GetTradeSkillLine()
        elseif frame == CraftFrame then
            currentName = GetCraftDisplaySkillLine()
        end

        tab:SetChecked(currentName == prof.name)

        tab:SetScript("OnClick", function()
            -- Clicking the profession that is already open must not toggle the
            -- Blizzard profession window closed. CastSpellByName() acts as a
            -- toggle for an active profession, so detect that case first and
            -- leave the current window/state untouched.
            local activeName = nil
            if TradeSkillFrame and TradeSkillFrame:IsVisible() then
                activeName = GetTradeSkillLine()
            elseif CraftFrame and CraftFrame:IsVisible() then
                activeName = GetCraftDisplaySkillLine()
            end

            if activeName == this.spellName then
                this:SetChecked(true)
                return
            end

            -- Flag to prevent session termination
            AtlasCFM.ProfessionHooks.IsSwitching = true

            -- Save position of the current window
            local currentFrame
            if TradeSkillFrame and TradeSkillFrame:IsVisible() then
                currentFrame = TradeSkillFrame
            elseif CraftFrame and CraftFrame:IsVisible() then
                currentFrame = CraftFrame
            end

            if currentFrame then
                local point, relativeTo, relativePoint, xOfs, yOfs = currentFrame:GetPoint()
                AtlasCFM.ProfessionHooks.SavedPosition = { point, relativeTo, relativePoint, xOfs, yOfs }

                -- Close the current frame before switching if we are changing type (TradeSkill vs Craft)
                -- This prevents multiple profession frames from being open at once.
                -- Using HideUIPanel is safe now because we've hooked CloseTradeSkill/CloseCraft.
                local isTargetCraft = (this.spellName == LS["Enchanting"] or this.spellName == LS["Disguise"])
                local isCurrentCraft = (currentFrame == CraftFrame)

                if isTargetCraft ~= isCurrentCraft then
                    HideUIPanel(currentFrame)
                end
            end

            -- Let CastSpellByName handle the switch naturally
            -- The IsSwitching flag will prevent OnHide hooks from calling CloseTradeSkill/CloseCraft
            CastSpellByName(this.spellName)

            -- Reset caches immediately to prevent showing old data
            AtlasCFM.ProfessionHooks.StartTSScan()
            AtlasCFM.ProfessionHooks.StartCraftScan()

            -- Reset flag after a short delay to ensure events are processed
            if AtlasCFM.Timer and AtlasCFM.Timer.Start then
                AtlasCFM.Timer.Start(0.5, function()
                    AtlasCFM.ProfessionHooks.IsSwitching = false
                end)
            else
                -- Fallback if Timer not available (should be loaded though)
                AtlasCFM.ProfessionHooks.IsSwitching = false
            end
        end)
    end

    for i = table.getn(playerProfessions) + 1, table.getn(sideTabs) do
        sideTabs[i]:Hide()
    end
end

-- Hook for TradeSkillFrame
AtlasCFM.ProfessionHooks.LinkCache = AtlasCFM.ProfessionHooks.LinkCache or {}

-- Async availability scanner for TradeSkill
AtlasCFM.ProfessionHooks.TSAvailCache = {}
AtlasCFM.ProfessionHooks.TSRealCache = {} -- Cache for real availability (accounting for all reagents)
AtlasCFM.ProfessionHooks.TSScanIndex = 0
AtlasCFM.ProfessionHooks.TSScanTotal = 0
AtlasCFM.ProfessionHooks.TSScanLine = nil
AtlasCFM.ProfessionHooks.TSScanActive = false

local RECIPES_PER_FRAME = 2

local tsScanFrame = CreateFrame("Frame")
tsScanFrame:Hide()
tsScanFrame:SetScript("OnUpdate", function()
    if not AtlasCFM.ProfessionHooks.TSScanActive then
        tsScanFrame:Hide()
        return
    end
    if not TradeSkillFrame or not TradeSkillFrame:IsVisible() then
        AtlasCFM.ProfessionHooks.TSScanActive = false
        tsScanFrame:Hide()
        return
    end

    local numSkills = GetNumTradeSkills()
    local currentLine = GetTradeSkillLine()
    if numSkills ~= AtlasCFM.ProfessionHooks.TSScanTotal or currentLine ~= AtlasCFM.ProfessionHooks.TSScanLine then
        -- Recipe list or profession changed, restart
        AtlasCFM.ProfessionHooks.TSAvailCache = {}
        AtlasCFM.ProfessionHooks.TSRealCache = {}
        AtlasCFM.ProfessionHooks.TSScanIndex = 0
        AtlasCFM.ProfessionHooks.TSScanTotal = numSkills
        AtlasCFM.ProfessionHooks.TSScanLine = currentLine
    end

    local processed = 0
    local idx = AtlasCFM.ProfessionHooks.TSScanIndex

    while processed < RECIPES_PER_FRAME and idx < numSkills do
        idx = idx + 1
        local skillName, skillType, numAvailable = GetTradeSkillInfo(idx)

        if skillName and skillType ~= "header" and numAvailable and numAvailable >= 0 then
            local minCrafts = 99999
            local realMinCrafts = 99999
            local hasNonVendorReagent = false

            for r = 1, GetTradeSkillNumReagents(idx) do
                local _, _, rCount, playerRCount = GetTradeSkillReagentInfo(idx, r)
                local rLink = GetTradeSkillReagentItemLink(idx, r)
                if rLink then
                    local rID = AtlasCFM.ProfessionHooks.LinkCache[rLink]
                    if rID == nil then
                        local _, _, parsedID = string.find(rLink, "item:(%d+)")
                        rID = tonumber(parsedID)
                        AtlasCFM.ProfessionHooks.LinkCache[rLink] = rID or false
                    end

                    local crafts = math.floor(playerRCount / rCount)
                    if crafts < realMinCrafts then
                        realMinCrafts = crafts
                    end

                    if rID and AtlasCFM.Integrations and AtlasCFM.Integrations.IsVendorItem(rID) then
                        -- skip vendor items for minCrafts
                    else
                        hasNonVendorReagent = true
                        if crafts < minCrafts then
                            minCrafts = crafts
                        end
                    end
                end
            end

            if not hasNonVendorReagent then
                minCrafts = realMinCrafts
            end

            if realMinCrafts == 99999 then realMinCrafts = numAvailable end
            if minCrafts == 99999 then minCrafts = realMinCrafts end

            -- Cache real count if it differs from numAvailable
            if realMinCrafts ~= numAvailable then
                AtlasCFM.ProfessionHooks.TSRealCache[idx] = realMinCrafts
            else
                AtlasCFM.ProfessionHooks.TSRealCache[idx] = nil
            end

            -- Cache possible count if it differs from real count
            if minCrafts ~= 99999 and minCrafts > realMinCrafts then
                AtlasCFM.ProfessionHooks.TSAvailCache[idx] = minCrafts
            else
                AtlasCFM.ProfessionHooks.TSAvailCache[idx] = nil
            end

            processed = processed + 1
        end
    end

    AtlasCFM.ProfessionHooks.TSScanIndex = idx

    if idx >= numSkills then
        AtlasCFM.ProfessionHooks.TSScanActive = false
        tsScanFrame:Hide()
        -- Refresh display with final results
        if TradeSkillFrame and TradeSkillFrame:IsVisible() then
            AtlasCFM.ProfessionHooks.OnTradeSkillUpdate()
        end
    end
end)

function AtlasCFM.ProfessionHooks.StartTSScan()
    AtlasCFM.ProfessionHooks.TSAvailCache = {}
    AtlasCFM.ProfessionHooks.TSRealCache = {}
    AtlasCFM.ProfessionHooks.TSScanIndex = 0
    AtlasCFM.ProfessionHooks.TSScanTotal = 0
    AtlasCFM.ProfessionHooks.TSScanActive = true
    tsScanFrame:Show()
end

local function EnsureSingleProfessionFrame(shownEvent)
    if shownEvent == "TRADE_SKILL_SHOW" then
        if CraftFrame and CraftFrame:IsVisible() then
            HideUIPanel(CraftFrame)
        end
    elseif shownEvent == "CRAFT_SHOW" then
        if TradeSkillFrame and TradeSkillFrame:IsVisible() then
            HideUIPanel(TradeSkillFrame)
        end
    end
end

-- Event-driven scan triggers
local tsEventFrame = CreateFrame("Frame")
tsEventFrame:RegisterEvent("BAG_UPDATE")
--tsEventFrame:RegisterEvent("TRADE_SKILL_UPDATE")
tsEventFrame:RegisterEvent("TRADE_SKILL_SHOW")
tsEventFrame:SetScript("OnEvent", function()
    if event == "TRADE_SKILL_SHOW" then
        EnsureSingleProfessionFrame(event)
    end

    -- Only scan if the frame is truly visible and not in combat/shapeshift spam
    if TradeSkillFrame and TradeSkillFrame:IsVisible() then
        -- Throttle BAG_UPDATE to avoid spamming during rapid events (like Druid shapeshift)
        if event == "BAG_UPDATE" then
            if not AtlasCFM.ProfessionHooks._tsBagThrottle then
                AtlasCFM.ProfessionHooks._tsBagThrottle = true
                if AtlasCFM.Timer and AtlasCFM.Timer.Start then
                    AtlasCFM.Timer.Start(1.0, function()
                        AtlasCFM.ProfessionHooks._tsBagThrottle = nil
                        if TradeSkillFrame and TradeSkillFrame:IsVisible() then
                            AtlasCFM.ProfessionHooks.StartTSScan()
                        end
                    end)
                else
                    AtlasCFM.ProfessionHooks.StartTSScan()
                    AtlasCFM.ProfessionHooks._tsBagThrottle = nil
                end
            end
        else
            AtlasCFM.ProfessionHooks.StartTSScan()
        end
    end
end)

function AtlasCFM.ProfessionHooks.OnTradeSkillUpdate()
    if AtlasCFM.ProfessionHooks.IsTurtleLatest() then
        AtlasCFM.ProfessionHooks.OnTradeSkillUpdate_TurtleLatest()
    else
        -- Delegate to the main hooked function to ensure consistent styling and filtering
        TradeSkillFrame_Update()
    end
end

-- Async availability scanner for CraftFrame
AtlasCFM.ProfessionHooks.CraftAvailCache = {}
AtlasCFM.ProfessionHooks.CraftRealCache = {} -- Cache for real availability
AtlasCFM.ProfessionHooks.CraftScanIndex = 0
AtlasCFM.ProfessionHooks.CraftScanTotal = 0
AtlasCFM.ProfessionHooks.CraftScanLine = nil
AtlasCFM.ProfessionHooks.CraftScanActive = false

local craftScanFrame = CreateFrame("Frame")
craftScanFrame:Hide()
craftScanFrame:SetScript("OnUpdate", function()
    if not AtlasCFM.ProfessionHooks.CraftScanActive then
        craftScanFrame:Hide()
        return
    end
    if not CraftFrame or not CraftFrame:IsVisible() then
        AtlasCFM.ProfessionHooks.CraftScanActive = false
        craftScanFrame:Hide()
        return
    end

    local numCrafts = GetNumCrafts()
    local currentLine = GetCraftDisplaySkillLine()
    if numCrafts ~= AtlasCFM.ProfessionHooks.CraftScanTotal or currentLine ~= AtlasCFM.ProfessionHooks.CraftScanLine then
        AtlasCFM.ProfessionHooks.CraftAvailCache = {}
        AtlasCFM.ProfessionHooks.CraftRealCache = {}
        AtlasCFM.ProfessionHooks.CraftScanIndex = 0
        AtlasCFM.ProfessionHooks.CraftScanTotal = numCrafts
        AtlasCFM.ProfessionHooks.CraftScanLine = currentLine
    end

    local processed = 0
    local idx = AtlasCFM.ProfessionHooks.CraftScanIndex

    while processed < RECIPES_PER_FRAME and idx < numCrafts do
        idx = idx + 1
        local craftName, _, craftType, numAvailable = GetCraftInfo(idx)

        if craftName and craftType ~= "header" and numAvailable and numAvailable >= 0 then
            local minCrafts = 99999
            local realMinCrafts = 99999
            local hasNonVendorReagent = false

            for r = 1, GetCraftNumReagents(idx) do
                local _, _, rCount, playerRCount = GetCraftReagentInfo(idx, r)
                local rLink = GetCraftReagentItemLink(idx, r)
                if rLink then
                    local rID = AtlasCFM.ProfessionHooks.LinkCache[rLink]
                    if rID == nil then
                        local _, _, parsedID = string.find(rLink, "item:(%d+)")
                        rID = tonumber(parsedID)
                        AtlasCFM.ProfessionHooks.LinkCache[rLink] = rID or false
                    end

                    local crafts = math.floor(playerRCount / rCount)
                    if crafts < realMinCrafts then
                        realMinCrafts = crafts
                    end

                    if rID and AtlasCFM.Integrations and AtlasCFM.Integrations.IsVendorItem(rID) then
                        -- skip vendor items for minCrafts
                    else
                        hasNonVendorReagent = true
                        if crafts < minCrafts then
                            minCrafts = crafts
                        end
                    end
                end
            end

            if not hasNonVendorReagent then
                minCrafts = realMinCrafts
            end

            if realMinCrafts == 99999 then realMinCrafts = numAvailable end
            if minCrafts == 99999 then minCrafts = realMinCrafts end

            -- Cache real count if it differs from numAvailable
            if realMinCrafts ~= numAvailable then
                AtlasCFM.ProfessionHooks.CraftRealCache[idx] = realMinCrafts
            else
                AtlasCFM.ProfessionHooks.CraftRealCache[idx] = nil
            end

            -- Cache possible count if it differs from real count
            if minCrafts ~= 99999 and minCrafts > realMinCrafts then
                AtlasCFM.ProfessionHooks.CraftAvailCache[idx] = minCrafts
            else
                AtlasCFM.ProfessionHooks.CraftAvailCache[idx] = nil
            end

            processed = processed + 1
        end
    end

    AtlasCFM.ProfessionHooks.CraftScanIndex = idx

    if idx >= numCrafts then
        AtlasCFM.ProfessionHooks.CraftScanActive = false
        craftScanFrame:Hide()
        if CraftFrame and CraftFrame:IsVisible() then
            CraftFrame_Update()
        end
    end
end)

function AtlasCFM.ProfessionHooks.StartCraftScan()
    AtlasCFM.ProfessionHooks.CraftAvailCache = {}
    AtlasCFM.ProfessionHooks.CraftRealCache = {}
    AtlasCFM.ProfessionHooks.CraftScanIndex = 0
    AtlasCFM.ProfessionHooks.CraftScanTotal = 0
    AtlasCFM.ProfessionHooks.CraftScanActive = true
    craftScanFrame:Show()
end

-- Event-driven craft scan triggers
local craftEventFrame = CreateFrame("Frame")
craftEventFrame:RegisterEvent("BAG_UPDATE")
-- craftEventFrame:RegisterEvent("CRAFT_UPDATE")
craftEventFrame:RegisterEvent("CRAFT_SHOW")
craftEventFrame:SetScript("OnEvent", function()
    if event == "CRAFT_SHOW" then
        EnsureSingleProfessionFrame(event)
    end

    -- Only scan if the frame is truly visible and not in combat/shapeshift spam
    if CraftFrame and CraftFrame:IsVisible() then
        -- Throttle BAG_UPDATE to avoid spamming during rapid events (like Druid shapeshift)
        if event == "BAG_UPDATE" then
            if not AtlasCFM.ProfessionHooks._craftBagThrottle then
                AtlasCFM.ProfessionHooks._craftBagThrottle = true
                if AtlasCFM.Timer and AtlasCFM.Timer.Start then
                    AtlasCFM.Timer.Start(1.0, function()
                        AtlasCFM.ProfessionHooks._craftBagThrottle = nil
                        if CraftFrame and CraftFrame:IsVisible() then
                            AtlasCFM.ProfessionHooks.StartCraftScan()
                        end
                    end)
                else
                    AtlasCFM.ProfessionHooks.StartCraftScan()
                    AtlasCFM.ProfessionHooks._craftBagThrottle = nil
                end
            end
        else
            AtlasCFM.ProfessionHooks.StartCraftScan()
        end
    end
end)

-- Create Atlas Button
function AtlasCFM.ProfessionHooks.CreateAtlasButton(frame)
    local btnName = frame:GetName() .. "AtlasButton"
    local btn = _G[btnName]

    if not btn then
        btn = CreateFrame("Button", btnName, frame, "UIPanelButtonTemplate")
        btn:SetScript("OnClick", function()
            if AtlasCFMFrame and AtlasCFMFrame:IsVisible() then
                AtlasCFMFrame:Hide()
            else
                AtlasCFMFrame:Show()

                -- Hide Quest UI if visible
                if AtlasCFM.Quest and AtlasCFM.Quest.UI and AtlasCFM.Quest.UI.InsideAtlasFrame then
                    AtlasCFM.Quest.UI.InsideAtlasFrame:Hide()
                end

                -- Navigation Logic
                local profName = nil
                if frame == TradeSkillFrame then
                    profName = GetTradeSkillLine()
                elseif frame == CraftFrame then
                    profName = GetCraftDisplaySkillLine()
                end

                if profName and AtlasCFM.MenuData and AtlasCFM.MenuData.Crafting then
                    local foundPage = nil
                    local function clean(s) return string.lower(s or "") end

                    for _, entry in ipairs(AtlasCFM.MenuData.Crafting) do
                        if entry.name and entry.lootpage then
                            local entryName = clean(entry.name)
                            local targetName = clean(profName)

                            -- Exact match or partial match (for "Mining, Smelting")
                            if entryName == targetName or string.find(entryName, targetName, 1, true) then
                                foundPage = entry.lootpage
                                break
                            end
                        end
                    end

                    if foundPage then
                        if type(_G[foundPage]) == "function" then
                            _G[foundPage]()
                            if AtlasCFMFrame and not AtlasCFMFrame:IsVisible() then
                                AtlasCFMFrame:Show()
                            end
                            if AtlasCFMLootItemsFrame then
                                AtlasCFMLootItemsFrame:Show()
                            end
                        elseif AtlasCFM.LootBrowserUI.ShowLootPage then
                            AtlasCFM.LootBrowserUI.ShowLootPage(foundPage)
                        else
                            -- Cache-aware fallback for profession pages that do
                            -- not have a legacy global page function.
                            if AtlasCFMLootItemsFrame then
                                FauxScrollFrame_SetOffset(AtlasCFMLootScrollBar, 0)
                                AtlasCFMLootScrollBarScrollBar:SetValue(0)
                                AtlasCFMLootItemsFrame.StoredElement = foundPage
                                AtlasCFMLootItemsFrame.StoredMenu = nil

                                if AtlasCFMFrame and not AtlasCFMFrame:IsVisible() then
                                    AtlasCFMFrame:Show()
                                end
                                AtlasCFMLootItemsFrame:Show()

                                local pageData = AtlasCFMLoot_Data and AtlasCFMLoot_Data[foundPage]
                                if AtlasCFM.LootBrowserUI.ShowScrollBarLoading then
                                    AtlasCFM.LootBrowserUI.ShowScrollBarLoading()
                                end
                                AtlasCFM.LootCache.CacheAllItems(pageData, function()
                                    if AtlasCFM.LootBrowserUI.HideScrollBarLoading then
                                        AtlasCFM.LootBrowserUI.HideScrollBarLoading()
                                    end
                                    if AtlasCFM.LootBrowserUI.ScrollBarLootUpdate then
                                        AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)

        -- Style for pfUI if needed
        if AtlasCFM.pfUI and AtlasCFM.pfUI.RestyleButton then
            AtlasCFM.pfUI.RestyleButton(btnName)
        end
    end

    -- Check if Profession Info option is enabled
    if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
        if btn then btn:Hide() end
        return btn
    end

    btn:Show()
    btn:SetText("AtlasCFM")

    -- Auto-resize width based on text
    local fontString = btn:GetFontString()
    if fontString then
        local width = fontString:GetStringWidth()
        btn:SetWidth(width + 20) -- Add padding
    else
        btn:SetWidth(70)         -- Fallback
    end
    btn:SetHeight(22)

    -- Position next to Close Button
    local closeBtn = _G[frame:GetName() .. "CloseButton"]
    if closeBtn then
        btn:SetPoint("RIGHT", closeBtn, "LEFT", -2, 0)
    else
        btn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -8)
    end

    return btn
end

-- Hook Reagent Buttons for clicking
function AtlasCFM.ProfessionHooks.HookReagentButtons(prefix)
    for i = 1, 8 do
        local btn = _G[prefix .. i]
        if btn and not btn.atlasHooked then
            btn.atlasHooked = true
            btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            local origOnClick = btn:GetScript("OnClick")
            btn:SetScript("OnClick", function()
                if origOnClick then origOnClick() end

                if not IsShiftKeyDown() and AtlasCFM.Integrations and AtlasCFM.Integrations.HasPfQuest() then
                    local nameStr = nil
                    if prefix == "TradeSkillReagent" then
                        local skillIndex = GetTradeSkillSelectionIndex()
                        if skillIndex > 0 then
                            nameStr = GetTradeSkillReagentInfo(skillIndex, this:GetID())
                        end
                    else
                        local craftIndex = GetCraftSelectionIndex()
                        if craftIndex > 0 then
                            nameStr = GetCraftReagentInfo(craftIndex, this:GetID())
                        end
                    end

                    if nameStr then
                        AtlasCFM.Integrations.SearchPfQuest(nameStr)
                    end
                end
            end)
        end
    end
end

-- --- TradeSkill Filter System ---
AtlasCFM.ProfessionHooks.TradeSkillFilter = {
    SearchText = "",
    HaveMaterials = false,
    ImprovesSkill = false,
    ShowSkillLevels = true,
    List = {}
}

local TSF = AtlasCFM.ProfessionHooks.TradeSkillFilter

function TSF.BuildList()
    TSF.List = {}
    local numNative = GetNumTradeSkills()
    if numNative == 0 then return end

    local searchText = TSF.SearchText or ""
    local hasMaterials = TSF.HaveMaterials
    local improvesSkill = TSF.ImprovesSkill
    local isFiltering = (searchText ~= "" or hasMaterials or improvesSkill)

    local pendingHeader = nil
    local currentGroupExpanded = true

    for i = 1, numNative do
        local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i)
        if skillType == "header" then
            pendingHeader = { isHeader = true, name = skillName, expanded = isExpanded, index = i }
            currentGroupExpanded = isExpanded and true or false
            if not isFiltering then
                table.insert(TSF.List, pendingHeader)
                pendingHeader = nil
            end
        else
            local keep = true
            if hasMaterials and numAvailable <= 0 then keep = false end
            if improvesSkill and (skillType == "trivial" or skillType == "used" or skillType == "none") then keep = false end
            if searchText ~= "" and not string.find(string.lower(skillName or ""), searchText, 1, true) then keep = false end

            if not isFiltering and not currentGroupExpanded then
                keep = false
            end

            if keep then
                if pendingHeader then
                    table.insert(TSF.List, pendingHeader)
                    pendingHeader = nil
                end
                table.insert(TSF.List,
                    { isHeader = false, index = i, name = skillName, type = skillType, num = numAvailable })
            end
        end
    end
end

function AtlasCFM.ProfessionHooks.OnTradeSkillUpdate_TurtleLatest()
    -- Reentrancy guard: SetText() can trigger TradeSkillFrame_Update again
    if AtlasCFM.ProfessionHooks._updatingTS then return end

    -- Only update if frame is visible to prevent stealing tabs
    if not TradeSkillFrame or not TradeSkillFrame:IsVisible() then return end

    -- Restore position if switching professions
    if AtlasCFM.ProfessionHooks.SavedPosition then
        local p = AtlasCFM.ProfessionHooks.SavedPosition
        TradeSkillFrame:ClearAllPoints()
        TradeSkillFrame:SetPoint(p[1], p[2], p[3], p[4], p[5])
        AtlasCFM.ProfessionHooks.SavedPosition = nil
    end

    AtlasCFM.ProfessionHooks.UpdateSideTabs(TradeSkillFrame)

    -- Style with pfUI if present
    if AtlasCFM.pfUI and AtlasCFM.pfUI.StyleProfessionFrames then
        AtlasCFM.pfUI.StyleProfessionFrames()
    end

    if not AtlasCFMOptions then AtlasCFMOptions = {} end
    if AtlasCFMOptions.TradeSkillShowLevels == nil then
        AtlasCFMOptions.TradeSkillShowLevels = true
    end

    local tradeSkillLevelToggle = _G["AtlasCFMTradeSkillShowLevels"]
    if not tradeSkillLevelToggle then
        tradeSkillLevelToggle = CreateFrame("CheckButton", "AtlasCFMTradeSkillShowLevels", TradeSkillFrame,
            "UICheckButtonTemplate")
        tradeSkillLevelToggle:SetWidth(20)
        tradeSkillLevelToggle:SetHeight(20)
        tradeSkillLevelToggle:SetScript("OnClick", function()
            AtlasCFMOptions.TradeSkillShowLevels = (this:GetChecked() == 1)
            TradeSkillFrame_Update()
        end)
        local tradeSkillLevelToggleText = _G["AtlasCFMTradeSkillShowLevelsText"]
        tradeSkillLevelToggleText:SetText(string.gsub(L["Skill:"], "[:%s]", ""))
        tradeSkillLevelToggleText:SetFontObject("GameFontHighlightSmall")
    end

    tradeSkillLevelToggle:ClearAllPoints()
    if IsAddOnLoaded("pfUI") then
        tradeSkillLevelToggle:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 0, 0)
    else
        tradeSkillLevelToggle:SetPoint("TOP", TradeSkillFrame, "TOP", 150, -15)
    end
    tradeSkillLevelToggle:SetChecked(AtlasCFMOptions.TradeSkillShowLevels and 1 or nil)
    tradeSkillLevelToggle:Show()

    -- Hide custom checkboxes if they exist (e.g. after server switch) — Turtle WoW has native filters
    local tsMatCheck = _G["AtlasCFMTradeSkillHaveMaterials"]
    local tsSkillCheck = _G["AtlasCFMTradeSkillImprovesSkill"]
    if tsMatCheck then tsMatCheck:Hide() end
    if tsSkillCheck then tsSkillCheck:Hide() end

    -- Check if Profession Info option is enabled
    if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
        tradeSkillLevelToggle:Hide()
        return
    end

    -- Start async scan if not already running or profession changed
    local currentLine = GetTradeSkillLine()
    if not AtlasCFM.ProfessionHooks.TSScanActive and (AtlasCFM.ProfessionHooks.TSScanIndex == 0 or currentLine ~= AtlasCFM.ProfessionHooks.TSScanLine) then
        AtlasCFM.ProfessionHooks.StartTSScan()
    end

    AtlasCFM.ProfessionHooks._updatingTS = true

    local numSkills = GetNumTradeSkills()
    local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)

    local numDisplayed = TRADE_SKILLS_DISPLAYED
    while _G["TradeSkillSkill" .. (numDisplayed + 1)] do numDisplayed = numDisplayed + 1 end

    for i = 1, numDisplayed do
        local skillButton = _G["TradeSkillSkill" .. i]
        local skillIndex = skillButton:GetID()
        local skillText = _G["TradeSkillSkill" .. i .. "Text"]
        -- Set button width like in CraftFrame
        if TradeSkillListScrollFrame:IsVisible() then
            skillButton:SetWidth(293)
            skillText:SetWidth(290)
        else
            skillButton:SetWidth(323)
            skillText:SetWidth(320)
        end
        -- Create icon if needed
        if not skillButton.atlasIcon then
            skillButton.atlasIcon = skillButton:CreateTexture(nil, "ARTWORK")
            skillButton.atlasIcon:SetWidth(12)
            skillButton.atlasIcon:SetHeight(12)
        end
        local icon = skillButton.atlasIcon
        icon:Hide()

        if skillButton:IsShown() and skillIndex and skillIndex > 0 then
            local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex)

            if skillName and skillType ~= "header" then
                -- Read from async cache
                -- customAvailable: possible count (if all vendor reagents were present)
                -- realAvailable: actual count player can craft right now
                local customAvailable = AtlasCFM.ProfessionHooks.TSAvailCache[skillIndex]
                local realAvailable = AtlasCFM.ProfessionHooks.TSRealCache[skillIndex] or numAvailable or 0

                -- If we don't have a custom count, use realAvailable as the base
                if not customAvailable then
                    customAvailable = realAvailable
                end

                -- Construct Text
                local countText = ""
                local displayNum = realAvailable
                if customAvailable > displayNum then
                    countText = "[" .. customAvailable .. "/" .. displayNum .. "] "
                elseif displayNum > 0 then
                    countText = "[" .. displayNum .. "] "
                end

                local nameText = skillName
                local levels = AtlasCFM.DataIndex and AtlasCFM.DataIndex.GetSkillLevels(skillName)
                if AtlasCFMOptions.TradeSkillShowLevels and levels and levels ~= "" then
                    nameText = nameText .. " " .. levels
                end

                local texture = GetTradeSkillIcon(skillIndex)
                if texture then
                    -- Add spacer for icon (7 spaces)
                    local spacer = "    "
                    if IsAddOnLoaded("pfUI") then
                        spacer = "       "
                    end

                    -- Measure width of countText to position icon correctly
                    skillText:SetText(countText)
                    local width = skillText:GetStringWidth()

                    skillText:SetText(countText .. spacer .. nameText)

                    icon:SetTexture(texture)
                    icon:ClearAllPoints()
                    icon:SetPoint("LEFT", skillText, "LEFT", width, 0)
                    icon:Show()
                else
                    skillText:SetText(countText .. nameText)
                end
            else
                -- Header: ensure default text is kept (TradeSkillFrame_Update handles it)
            end
        else
            -- Empty button
        end
    end

    AtlasCFM.ProfessionHooks._updatingTS = nil
end

function TSF.InitUI()
    if TSF.UIReady then return end
    TSF.UIReady = true

    local function ResetScroll()
        if TradeSkillListScrollFrameScrollBar then
            TradeSkillListScrollFrameScrollBar:SetValue(0)
        end
        TSF.ScrollValue = 0
    end

    -- Search Box
    local searchBox = _G["AtlasCFMTradeSkillSearchBox"]
    if not searchBox then
        searchBox = CreateFrame("EditBox", "AtlasCFMTradeSkillSearchBox", TradeSkillFrame)
        searchBox:SetHeight(20)
        searchBox:SetAutoFocus(false)
        searchBox:SetFontObject("ChatFontNormal")
        searchBox:SetTextInsets(26, 20, 0, 0)
        searchBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        searchBox:SetBackdropColor(0, 0, 0, 0.8)
        searchBox:SetBackdropBorderColor(0.4, 0.4, 0.4)

        if IsAddOnLoaded("pfUI") then
            searchBox:SetPoint("TOP", TradeSkillFrame, "BOTTOM", 0, -8)
            searchBox:SetWidth(330)
            if AtlasCFM.pfUI and AtlasCFM.pfUI.SkinEditBox then
                AtlasCFM.pfUI.SkinEditBox(searchBox)
            end
        else
            searchBox:SetWidth(170)
            searchBox:SetPoint("BOTTOMLEFT", TradeSkillFrame, 16, 50)
        end

        searchBox:SetFrameLevel(TradeSkillFrame:GetFrameLevel() + 5)

        local searchIcon = searchBox:CreateTexture(nil, "OVERLAY")
        searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
        searchIcon:SetWidth(14)
        searchIcon:SetHeight(14)
        searchIcon:SetPoint("LEFT", searchBox, "LEFT", 8, -1)
        searchIcon:SetVertexColor(0.6, 0.6, 0.6)
        searchBox.searchIcon = searchIcon

        local placeholder = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        placeholder:SetPoint("LEFT", searchIcon, "RIGHT", 4, 0)
        placeholder:SetText(L["Search"])
        placeholder:SetTextColor(0.6, 0.6, 0.6)
        searchBox.placeholder = placeholder

        local clearBtn = CreateFrame("Button", nil, searchBox)
        clearBtn:SetWidth(16)
        clearBtn:SetHeight(16)
        clearBtn:SetPoint("RIGHT", searchBox, "RIGHT", -6, 0)
        clearBtn:SetFrameLevel(searchBox:GetFrameLevel() + 5)
        local clearX = clearBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        clearX:SetText("x")
        clearX:SetPoint("CENTER", 0, 0)
        clearX:SetTextColor(1, 0.1, 0.1)
        clearBtn.text = clearX
        clearBtn:SetScript("OnClick", function()
            AtlasCFMTradeSkillSearchBox:SetText("")
            AtlasCFMTradeSkillSearchBox:ClearFocus()
        end)
        searchBox.clearBtn = clearBtn

        searchBox:SetScript("OnTextChanged", function()
            local text = this:GetText()
            TSF.SearchText = string.lower(text)
            if text ~= "" then
                this.placeholder:Hide()
                this.clearBtn:Show()
            else
                if not this._hasFocus then this.placeholder:Show() end
                this.clearBtn:Hide()
            end
            ResetScroll()
            TradeSkillFrame_Update()
        end)
        searchBox:SetScript("OnEditFocusGained", function()
            this._hasFocus = true
            this.placeholder:Hide()
            this.searchIcon:SetVertexColor(1, 1, 1)
        end)
        searchBox:SetScript("OnEditFocusLost", function()
            this._hasFocus = false
            if this:GetText() == "" then this.placeholder:Show() end
            this.searchIcon:SetVertexColor(0.6, 0.6, 0.6)
        end)
        searchBox:SetScript("OnEnterPressed", function() this:ClearFocus() end)
        searchBox:SetScript("OnEscapePressed", function() this:ClearFocus() end)
    end

    -- Have Materials Checkbox
    local matCheck = _G["AtlasCFMTradeSkillHaveMaterials"]
    if not matCheck then
        matCheck = CreateFrame("CheckButton", "AtlasCFMTradeSkillHaveMaterials", TradeSkillFrame, "UICheckButtonTemplate")
        matCheck:SetWidth(20)
        matCheck:SetHeight(20)

        if IsAddOnLoaded("pfUI") then
            matCheck:SetPoint("TOPLEFT", TradeSkillFrame, 90, 0)
        else
            matCheck:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 75, -50)
        end

        matCheck:SetScript("OnClick", function()
            TSF.HaveMaterials = (this:GetChecked() == 1)
            ResetScroll()
            TradeSkillFrame_Update()
        end)
        local matLabel = _G["AtlasCFMTradeSkillHaveMaterialsText"]
        matLabel:SetText("1+")
        matLabel:SetFontObject("GameFontHighlightSmall")
    end

    -- Improves Skill Checkbox
    local skillCheck = _G["AtlasCFMTradeSkillImprovesSkill"]
    if not skillCheck then
        skillCheck = CreateFrame("CheckButton", "AtlasCFMTradeSkillImprovesSkill", TradeSkillFrame,
            "UICheckButtonTemplate")
        skillCheck:SetWidth(20)
        skillCheck:SetHeight(20)
        skillCheck:SetPoint("LEFT", _G["AtlasCFMTradeSkillHaveMaterialsText"], "RIGHT", 5, 0)
        skillCheck:SetScript("OnClick", function()
            TSF.ImprovesSkill = (this:GetChecked() == 1)
            ResetScroll()
            TradeSkillFrame_Update()
        end)
        local skillLabel = _G["AtlasCFMTradeSkillImprovesSkillText"]
        skillLabel:SetText("^^^")
        skillLabel:SetFontObject("GameFontHighlightSmall")
    end

    -- Show Levels Checkbox
    local showLevelsCheck = _G["AtlasCFMTradeSkillShowLevels"]
    if not showLevelsCheck then
        showLevelsCheck = CreateFrame("CheckButton", "AtlasCFMTradeSkillShowLevels", TradeSkillFrame,
            "UICheckButtonTemplate")
        showLevelsCheck:SetWidth(20)
        showLevelsCheck:SetHeight(20)

        if IsAddOnLoaded("pfUI") then
            showLevelsCheck:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 0, 0)
        else
            showLevelsCheck:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 65, -15)
        end

        showLevelsCheck:SetScript("OnClick", function()
            AtlasCFMOptions.TradeSkillShowLevels = (this:GetChecked() == 1)
            TradeSkillFrame_Update()
        end)
        local showLevelsText = _G["AtlasCFMTradeSkillShowLevelsText"]
        showLevelsText:SetText(string.gsub(L["Skill:"], "[:%s]", ""))
        showLevelsText:SetFontObject("GameFontHighlightSmall")
    end
    if not AtlasCFMOptions then AtlasCFMOptions = {} end
    showLevelsCheck:SetChecked(AtlasCFMOptions.TradeSkillShowLevels and 1 or nil)

    -- On Turtle WoW, native TradeSkillFrame already has these filters
    if AtlasCFM.Server and AtlasCFM.Server.GetActive then
        local active = AtlasCFM.Server.GetActive()
        if active == AtlasCFM.Server.TURTLE or active == AtlasCFM.Server.TURTLE1 then
            if matCheck then matCheck:Hide() end
            if skillCheck then skillCheck:Hide() end
            if showLevelsCheck then showLevelsCheck:Hide() end
            if searchBox then searchBox:Hide() end
        end
    end
end

function TSF.HookTradeSkillFrameUpdate()
    if AtlasCFM.TradeSkillFilter_Hooked then return end
    AtlasCFM.TradeSkillFilter_Hooked = true

    local scrollBar = _G["TradeSkillListScrollFrameScrollBar"]
    if not TSF.ScrollHandlersHooked then
        TSF.ScrollHandlersHooked = true
        local origOnVerticalScroll = TradeSkillListScrollFrame:GetScript("OnVerticalScroll")
        TradeSkillListScrollFrame:SetScript("OnVerticalScroll", function()
            if arg1 then TSF.ScrollValue = arg1 end
            if origOnVerticalScroll then origOnVerticalScroll() end
        end)
        if scrollBar then
            local origOnValueChanged = scrollBar:GetScript("OnValueChanged")
            scrollBar:SetScript("OnValueChanged", function()
                TSF.ScrollValue = this:GetValue() or TSF.ScrollValue or 0
                if origOnValueChanged then origOnValueChanged() end
            end)
        end
    end

    local orig_TradeSkillFrame_Update = TradeSkillFrame_Update
    function TradeSkillFrame_Update()
        if AtlasCFM.ProfessionHooks._updatingTS then return end

        -- Restore position if switching professions
        if AtlasCFM.ProfessionHooks.SavedPosition then
            local p = AtlasCFM.ProfessionHooks.SavedPosition
            TradeSkillFrame:ClearAllPoints()
            TradeSkillFrame:SetPoint(p[1], p[2], p[3], p[4], p[5])
            AtlasCFM.ProfessionHooks.SavedPosition = nil
        end
        if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
            orig_TradeSkillFrame_Update()
            return
        end

        AtlasCFM.ProfessionHooks._updatingTS = true
        TSF.InitUI()
        TSF.BuildList()

        orig_TradeSkillFrame_Update()

        -- Start async scan if not already running or profession changed
        local currentLine = GetTradeSkillLine()
        if not AtlasCFM.ProfessionHooks.TSScanActive and (AtlasCFM.ProfessionHooks.TSScanIndex == 0 or currentLine ~= AtlasCFM.ProfessionHooks.TSScanLine) then
            AtlasCFM.ProfessionHooks.StartTSScan()
        end

        -- Update Side Panel and Styling
        if TradeSkillFrame:IsVisible() then
            AtlasCFM.ProfessionHooks.UpdateSideTabs(TradeSkillFrame)
            if AtlasCFM.pfUI and AtlasCFM.pfUI.StyleProfessionFrames then
                AtlasCFM.pfUI.StyleProfessionFrames()
            end
        end

        if not TradeSkillFrame:IsVisible() then
            AtlasCFM.ProfessionHooks._updatingTS = nil
            return
        end

        local numItems = table.getn(TSF.List)
        local numDisplayed = TRADE_SKILLS_DISPLAYED
        while _G["TradeSkillSkill" .. (numDisplayed + 1)] do numDisplayed = numDisplayed + 1 end

        local rowHeight = TRADE_SKILL_HEIGHT or 16
        FauxScrollFrame_Update(TradeSkillListScrollFrame, numItems, numDisplayed, rowHeight)

        local tsOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
        local selectionIndex = GetTradeSkillSelectionIndex()

        if TradeSkillHighlightFrame then TradeSkillHighlightFrame:Hide() end

        for i = 1, numDisplayed do
            local itemIndex = i + tsOffset
            local skillButton = _G["TradeSkillSkill" .. i]
            local skillText = _G["TradeSkillSkill" .. i .. "Text"]

            if not skillButton.atlasIcon then
                skillButton.atlasIcon = skillButton:CreateTexture(nil, "ARTWORK")
                skillButton.atlasIcon:SetWidth(12)
                skillButton.atlasIcon:SetHeight(12)
            end
            local icon = skillButton.atlasIcon
            icon:Hide()

            -- Set button width like in CraftFrame (Commented out to support double-wide UI)
            -- if TradeSkillListScrollFrame:IsVisible() then
            --     skillButton:SetWidth(293)
            --     skillText:SetWidth(290)
            -- else
            --     skillButton:SetWidth(323)
            --     skillText:SetWidth(320)
            -- end

            if itemIndex <= numItems then
                local data = TSF.List[itemIndex]
                if data.isHeader then
                    skillButton:SetID(data.index)
                    skillButton.isHeader = true
                    skillButton.isExpanded = data.expanded
                    skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
                    if not data.expanded then
                        skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
                    end
                    skillText:SetText(data.name)
                    skillText:ClearAllPoints()
                    skillText:SetPoint("LEFT", skillButton, "LEFT", 18, 0)
                    skillText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                    skillButton:Show()
                else
                    skillButton:SetID(data.index)
                    skillButton.isHeader = false
                    skillButton:SetNormalTexture("")

                    local _, _, numAvailable = GetTradeSkillInfo(data.index)
                    local customAvailable = AtlasCFM.ProfessionHooks.TSAvailCache[data.index]
                    local realAvailable = AtlasCFM.ProfessionHooks.TSRealCache[data.index] or numAvailable or 0
                    if not customAvailable then customAvailable = realAvailable end

                    local countText = ""
                    if customAvailable > realAvailable then
                        countText = "[" .. customAvailable .. "/" .. realAvailable .. "] "
                    elseif realAvailable > 0 then
                        countText = "[" .. realAvailable .. "] "
                    end

                    local nameText = data.name
                    local levels = AtlasCFM.DataIndex and AtlasCFM.DataIndex.GetSkillLevels(data.name)
                    if AtlasCFMOptions.TradeSkillShowLevels and levels and levels ~= "" then
                        nameText = nameText .. " " .. levels
                    end

                    local texture = GetTradeSkillIcon(data.index)
                    if texture then
                        skillText:SetText(countText .. nameText)
                        icon:SetTexture(texture)
                        icon:ClearAllPoints()
                        icon:SetPoint("RIGHT", skillButton, "RIGHT", -2, 0)
                        icon:Show()
                    else
                        skillText:SetText(countText .. nameText)
                    end

                    skillText:ClearAllPoints()
                    skillText:SetPoint("LEFT", skillButton, "LEFT", 0, 0)

                    local color = TradeSkillTypeColor[data.type] or { r = 1, g = 1, b = 1 }
                    skillText:SetTextColor(color.r, color.g, color.b)

                    if selectionIndex == data.index then
                        TradeSkillHighlightFrame:SetPoint("TOPLEFT", skillButton, "TOPLEFT")
                        TradeSkillHighlightFrame:Show()
                    end
                    skillButton:Show()
                end
            else
                skillButton:Hide()
            end
        end
        AtlasCFM.ProfessionHooks._updatingTS = nil
    end
end

-- --- Craft Filter System ---
AtlasCFM.ProfessionHooks.CraftFilter = {
    SearchText = "",
    HaveMaterials = false,
    ImprovesSkill = false,
    ShowSkillLevels = true,
    UseCategories = true,
    ExpandedCategories = {},
    List = {}
}

local CF = AtlasCFM.ProfessionHooks.CraftFilter

local L = AtlasCFM.Localization.UI

local patternsToHeaders = {
    [string.lower(L["Bracer"])] = L["Bracer"],
    [string.lower(L["Boots"])] = L["Boots"],
    [string.lower(L["Gloves"])] = L["Gloves"],
    [string.lower(L["2H Weapon"])] = L["2H Weapon"],
    [string.lower(L["Enchant weapon"])] = L["Weapon"],
    [string.lower(L["Wand"])] = L["Wand"],
    [string.lower(L["Cloak"])] = L["Cloak"],
    [string.lower(L["Chest"])] = L["Chest"],
    [string.lower(L["Shield"])] = L["Shield"],
    [string.lower(L["mana oil"])] = L["Consumable"],
    [string.lower(L["wizard oil"])] = L["Consumable"],
}

local function GetCraftButtonsCount()
    local count = 0
    while true do
        if not _G["Craft" .. (count + 1)] then
            break
        end
        count = count + 1
        if count >= 64 then
            break
        end
    end

    if count == 0 then
        count = CRAFTS_DISPLAYED or 8
    end

    return count
end

function CF.BuildList()
    CF.List = {}

    local numNative = GetNumCrafts()
    if numNative == 0 then return end

    local searchText, hasMaterials, improvesSkill

    if AtlasCFM.ProfessionHooks.IsTurtleLatest() then
        -- Read native search text for auto-expansion
        local searchBox = _G["CraftFrameSearchBox"] or _G["CraftFrameEditBox"]
        searchText = searchBox and searchBox:GetText() or ""
        searchText = string.lower(searchText)

        -- Detect standard filters
        hasMaterials = false
        improvesSkill = false
        local matCheck = _G["CraftFrameAvailableFilterCheckButton"] or _G["CraftMatsCheckButton"] or
            _G["CraftFrameMatsCheckButton"]
        local skillCheck = _G["CraftSkillCheckButton"] or _G["CraftFrameSkillCheckButton"]
        if matCheck and matCheck:GetChecked() then hasMaterials = true end
        if skillCheck and skillCheck:GetChecked() then improvesSkill = true end
    else
        -- Use custom filters
        searchText = CF.SearchText or ""
        hasMaterials = CF.HaveMaterials
        improvesSkill = CF.ImprovesSkill
    end

    -- If categories are ON, we need to expand all native headers to see all items
    if CF.UseCategories then
        local expandedSomething = true
        local safetyLimit = 0
        while expandedSomething and safetyLimit < 50 do
            expandedSomething = false
            numNative = GetNumCrafts()
            for i = 1, numNative do
                local _, _, skillType, _, isExpanded = GetCraftInfo(i)
                if skillType == "header" and not isExpanded then
                    ExpandCraftHeader(i)
                    expandedSomething = true
                    safetyLimit = safetyLimit + 1
                    break
                end
            end
        end
    end

    numNative = GetNumCrafts()
    local filtered = {}
    for i = 1, numNative do
        local craftName, _, craftType, numAvailable = GetCraftInfo(i)

        if craftName and craftType ~= "header" then
            local keep = true
            if hasMaterials and numAvailable <= 0 then keep = false end
            if improvesSkill and (craftType == "trivial" or craftType == "used" or craftType == "none") then keep = false end
            if searchText ~= "" and not string.find(string.lower(craftName), searchText, 1, true) then keep = false end

            if keep then
                table.insert(filtered, {
                    index = i,
                    name = craftName,
                    type = craftType,
                    num = numAvailable
                })
            end
        end
    end

    if CF.UseCategories then
        local grouped = {}
        for _, craft in ipairs(filtered) do
            local cat = L["Miscellaneous"]
            for p, h in pairs(patternsToHeaders) do
                if string.find(string.lower(craft.name), p) then
                    cat = h
                    break
                end
            end
            if not grouped[cat] then grouped[cat] = {} end
            table.insert(grouped[cat], craft)
        end

        -- Sort categories alphabetically, but keep Miscellaneous at the end
        local sortedCats = {}
        local hasMisc = false
        local miscName = L["Miscellaneous"]
        for catName in pairs(grouped) do
            if catName == miscName then
                hasMisc = true
            else
                table.insert(sortedCats, catName)
            end
        end
        table.sort(sortedCats)
        if hasMisc then
            table.insert(sortedCats, miscName)
        end

        -- Flatten the grouped list into our sequential display list
        for _, catName in ipairs(sortedCats) do
            local items = grouped[catName]
            local expanded = CF.ExpandedCategories[catName]
            if expanded == nil then expanded = true end

            -- Force expand categories if search text is present to show matches
            if searchText ~= "" then
                expanded = true
            end

            table.insert(CF.List, { isHeader = true, name = catName, expanded = expanded })
            if expanded then
                for _, craft in ipairs(items) do
                    table.insert(CF.List,
                        { isHeader = false, index = craft.index, name = craft.name, type = craft.type, num = craft.num })
                end
            end
        end
    else
        -- If categories are disabled, we should include native headers to "not break standard"
        for i = 1, numNative do
            local craftName, _, craftType, numAvailable, isExpanded = GetCraftInfo(i)
            if craftType == "header" then
                table.insert(CF.List,
                    { isHeader = true, name = craftName, expanded = isExpanded, isNativeHeader = true, index = i })
            else
                local keep = true
                if hasMaterials and numAvailable <= 0 then keep = false end
                if improvesSkill and (craftType == "trivial" or craftType == "used" or craftType == "none") then keep = false end
                if searchText ~= "" and not string.find(string.lower(craftName), searchText, 1, true) then keep = false end

                if keep then
                    table.insert(CF.List,
                        { isHeader = false, index = i, name = craftName, type = craftType, num = numAvailable })
                end
            end
        end
    end
end

function CF.InitUI()
    if CF.UIReady then return end
    CF.UIReady = true

    local function ResetScroll()
        if CraftListScrollFrameScrollBar then
            CraftListScrollFrameScrollBar:SetValue(0)
        end
        CF.ScrollValue = 0
    end

    -- All (Collapse/Expand All) Button
    local allBtn = CreateFrame("Button", "AtlasCFMCraftCollapseAll", CraftFrame)
    allBtn:SetWidth(60) -- Increased width for better click area
    allBtn:SetHeight(16)

    -- Save original methods to override them with texture constraints
    local _SetNormalTexture = allBtn.SetNormalTexture
    local _SetPushedTexture = allBtn.SetPushedTexture
    local _SetHighlightTexture = allBtn.SetHighlightTexture

    local function FixTexture(tex)
        if tex then
            tex:SetWidth(16)
            tex:SetHeight(16)
            tex:ClearAllPoints()
            tex:SetPoint("LEFT", allBtn, "LEFT")
        end
    end

    allBtn.SetNormalTexture = function(self, tex)
        _SetNormalTexture(self, tex)
        FixTexture(self:GetNormalTexture())
    end

    allBtn.SetPushedTexture = function(self, tex)
        _SetPushedTexture(self, tex)
        FixTexture(self:GetPushedTexture())
    end

    allBtn.SetHighlightTexture = function(self, tex)
        _SetHighlightTexture(self, tex)
        local ht = self:GetHighlightTexture()
        if ht then
            FixTexture(ht)
            ht:SetBlendMode("ADD")
        end
    end

    allBtn:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
    allBtn:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
    allBtn:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")

    local allText = allBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    allText:SetText(L["All"])
    allText:SetPoint("LEFT", allBtn, "LEFT", 18, 0)
    allText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    allBtn.text = allText

    allBtn:SetScript("OnClick", function()
        local anyExpanded = false
        -- Check if any category in the current list is expanded
        for _, item in ipairs(CF.List) do
            if item.isHeader and item.expanded then
                anyExpanded = true
                break
            end
        end

        local newState = not anyExpanded

        -- Force all categories in current list to the new state
        for _, item in ipairs(CF.List) do
            if item.isHeader then
                CF.ExpandedCategories[item.name] = newState
            end
        end

        ResetScroll()
        CraftFrame_Update()
    end)

    if IsAddOnLoaded("pfUI") then
        allBtn:SetPoint("TOPLEFT", CraftFrame, 10, -50)
    else
        allBtn:SetPoint("TOPLEFT", CraftFrame, 25, -78)
    end

    -- Search Box (styled to match TradeSkillFrame search bar)
    local searchBox = _G["AtlasCFMCraftSearchBox"]
    if not searchBox then
        searchBox = CreateFrame("EditBox", "AtlasCFMCraftSearchBox", CraftFrame)
        searchBox:SetHeight(20)
        searchBox:SetAutoFocus(false)
        searchBox:SetFontObject("ChatFontNormal")
        searchBox:SetTextInsets(26, 20, 0, 0)
        --[[         searchBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        searchBox:SetBackdropColor(0, 0, 0, 0.8)
        searchBox:SetBackdropBorderColor(0.4, 0.4, 0.4) ]]

        if IsAddOnLoaded("pfUI") then
            searchBox:SetPoint("TOP", CraftFrame, "BOTTOM", 0, -8)
            searchBox:SetWidth(330)
            if AtlasCFM.pfUI and AtlasCFM.pfUI.SkinEditBox then
                AtlasCFM.pfUI.SkinEditBox(searchBox)
            end
        else
            searchBox:SetWidth(170)
            searchBox:SetPoint("BOTTOMLEFT", CraftFrame, 16, 82)
        end

        searchBox:SetFrameLevel(CraftFrame:GetFrameLevel() + 5)

        -- Magnifying glass icon
        local searchIcon = searchBox:CreateTexture(nil, "OVERLAY")
        searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
        searchIcon:SetWidth(14)
        searchIcon:SetHeight(14)
        searchIcon:SetPoint("LEFT", searchBox, "LEFT", 8, -1)
        searchIcon:SetVertexColor(0.6, 0.6, 0.6)
        searchBox.searchIcon = searchIcon

        -- Placeholder
        local placeholder = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        placeholder:SetPoint("LEFT", searchIcon, "RIGHT", 4, 0)
        placeholder:SetText(L["Search"])
        placeholder:SetTextColor(0.6, 0.6, 0.6)
        searchBox.placeholder = placeholder

        -- Clear button (X)
        local clearBtn = CreateFrame("Button", nil, searchBox)
        clearBtn:SetWidth(16)
        clearBtn:SetHeight(16)
        clearBtn:SetPoint("RIGHT", searchBox, "RIGHT", -6, 0)
        clearBtn:SetFrameLevel(searchBox:GetFrameLevel() + 5)

        local clearX = clearBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        clearX:SetText("x")
        clearX:SetPoint("CENTER", 0, 0)
        clearX:SetTextColor(1, 0.1, 0.1) -- Bright red X
        clearBtn.text = clearX

        clearBtn:SetScript("OnEnter", function() this.text:SetTextColor(1, 1, 1) end)
        clearBtn:SetScript("OnLeave", function() this.text:SetTextColor(1, 0.1, 0.1) end)

        clearBtn:Hide()
        clearBtn:SetScript("OnClick", function()
            AtlasCFMCraftSearchBox:SetText("")
            AtlasCFMCraftSearchBox:ClearFocus()
        end)
        searchBox.clearBtn = clearBtn

        searchBox:SetScript("OnTextChanged", function()
            local text = this:GetText()
            CF.SearchText = string.lower(text)
            if text ~= "" then
                this.placeholder:Hide()
                this.clearBtn:Show()
            else
                if not this._hasFocus then
                    this.placeholder:Show()
                end
                this.clearBtn:Hide()
            end
            ResetScroll()
            CraftFrame_Update()
        end)
        searchBox:SetScript("OnEditFocusGained", function()
            this._hasFocus = true
            this.placeholder:Hide()
            this.searchIcon:SetVertexColor(1, 1, 1)
        end)
        searchBox:SetScript("OnEditFocusLost", function()
            this._hasFocus = false
            if this:GetText() == "" then
                this.placeholder:Show()
            end
            this.searchIcon:SetVertexColor(0.6, 0.6, 0.6)
        end)
        searchBox:SetScript("OnEnterPressed", function() this:ClearFocus() end)
        searchBox:SetScript("OnEscapePressed", function() this:ClearFocus() end)
    end

    -- Have Materials Checkbox
    local matCheck = _G["AtlasCFMCraftHaveMaterials"]
    if not matCheck then
        matCheck = CreateFrame("CheckButton", "AtlasCFMCraftHaveMaterials", CraftFrame, "UICheckButtonTemplate")
        matCheck:SetWidth(20)
        matCheck:SetHeight(20)

        if IsAddOnLoaded("pfUI") then
            matCheck:SetPoint("TOPLEFT", CraftFrame, 90, 0)
        else
            matCheck:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 75, -50)
        end

        matCheck:SetScript("OnClick", function()
            CF.HaveMaterials = (this:GetChecked() == 1)
            ResetScroll()
            CraftFrame_Update()
        end)
        local matLabel = _G["AtlasCFMCraftHaveMaterialsText"]
        matLabel:SetText("1+")
        matLabel:SetFontObject("GameFontHighlightSmall")
    end

    -- Improves Skill Checkbox
    local skillCheck = _G["AtlasCFMCraftImprovesSkill"]
    if not skillCheck then
        skillCheck = CreateFrame("CheckButton", "AtlasCFMCraftImprovesSkill", CraftFrame, "UICheckButtonTemplate")
        skillCheck:SetWidth(20)
        skillCheck:SetHeight(20)
        skillCheck:SetPoint("LEFT", _G["AtlasCFMCraftHaveMaterialsText"], "RIGHT", 5, 0)
        skillCheck:SetScript("OnClick", function()
            CF.ImprovesSkill = (this:GetChecked() == 1)
            ResetScroll()
            CraftFrame_Update()
        end)
        local skillLabel = _G["AtlasCFMCraftImprovesSkillText"]
        skillLabel:SetText("^^^")
        skillLabel:SetFontObject("GameFontHighlightSmall")
    end

    -- Category Checkbox
    local catCheck = CreateFrame("CheckButton", "AtlasCFMCraftCategories", CraftFrame, "UICheckButtonTemplate")
    catCheck:SetWidth(20)
    catCheck:SetHeight(20)
    if IsAddOnLoaded("pfUI") then
        catCheck:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 0, 0)
    else
        if AtlasCFM.ProfessionHooks.IsTurtleLatest() then
            catCheck:SetPoint("TOP", CraftFrame, "TOP", 100, -15)
        else
            catCheck:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 65, -15)
        end
    end
    catCheck:SetChecked(CF.UseCategories and 1 or nil)
    catCheck:SetScript("OnClick", function()
        CF.UseCategories = (this:GetChecked() == 1)
        ResetScroll()
        CraftFrame_Update()
    end)
    local catLabel = _G["AtlasCFMCraftCategoriesText"]
    catLabel:SetText(L["Type"])
    catLabel:SetFontObject("GameFontHighlightSmall")

    local showSkillCheck = CreateFrame("CheckButton", "AtlasCFMCraftShowSkillLevels", CraftFrame, "UICheckButtonTemplate")
    showSkillCheck:SetWidth(20)
    showSkillCheck:SetHeight(20)
    showSkillCheck:SetPoint("LEFT", _G["AtlasCFMCraftCategoriesText"], "RIGHT", 5, 0)

    if not AtlasCFMOptions then AtlasCFMOptions = {} end
    if AtlasCFMOptions.CraftSkillShowLevels == nil then
        AtlasCFMOptions.CraftSkillShowLevels = true
    end
    CF.ShowSkillLevels = AtlasCFMOptions.CraftSkillShowLevels
    showSkillCheck:SetChecked(CF.ShowSkillLevels and 1 or nil)
    showSkillCheck:SetScript("OnClick", function()
        CF.ShowSkillLevels = (this:GetChecked() == 1)
        AtlasCFMOptions.CraftSkillShowLevels = CF.ShowSkillLevels
        ResetScroll()
        CraftFrame_Update()
    end)
    local showSkillLabel = _G["AtlasCFMCraftShowSkillLevelsText"]
    showSkillLabel:SetText(string.gsub(L["Skill:"], "[:%s]", ""))
    showSkillLabel:SetFontObject("GameFontHighlightSmall")

    -- Style with pfUI if present
    if AtlasCFM.pfUI and AtlasCFM.pfUI.StyleProfessionFrames then
        AtlasCFM.pfUI.StyleProfessionFrames()
    end

    -- Update All button icon based on state
    local allBtn = _G["AtlasCFMCraftCollapseAll"]
    local catCheck = _G["AtlasCFMCraftCategories"]
    local showSkillCheck = _G["AtlasCFMCraftShowSkillLevels"]

    if allBtn then
        local anyExpanded = false
        local hasHeaders = false
        for _, item in ipairs(CF.List) do
            if item.isHeader then
                hasHeaders = true
                if item.expanded then
                    anyExpanded = true
                    break
                end
            end
        end

        -- Default to minus if list is empty or any header is expanded
        if not hasHeaders or anyExpanded then
            allBtn:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
            allBtn:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
        else
            allBtn:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
            allBtn:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
        end

        -- Check if Profession Info option is enabled
        if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
            allBtn:Hide()
            catCheck:Hide()
            showSkillCheck:Hide()
        else
            if CF.UseCategories then
                allBtn:Show()
            else
                allBtn:Hide()
            end
            catCheck:Show()
            showSkillCheck:Show()
        end
    end

    -- Hook clicks on Craft Buttons
    local numCraftsDisplayed = GetCraftButtonsCount()

    for i = 1, numCraftsDisplayed do
        local btn = _G["Craft" .. i]
        if btn then
            local origOnClick = btn:GetScript("OnClick")
            btn:SetScript("OnClick", function()
                local id = this:GetID()
                if id == 0 and this.catName then
                    -- It's our custom header! Toggle it.
                    local cat = this.catName
                    local isExpanded = CF.ExpandedCategories[cat]
                    if isExpanded == nil then isExpanded = true end -- Default to expanded
                    CF.ExpandedCategories[cat] = not isExpanded
                    CraftFrame_Update()
                    return -- skip native click
                end
                if id > 0 and this.isNativeHeader then
                    -- It's a native header! Toggle it.
                    if this.expanded then
                        CollapseCraftHeader(id)
                    else
                        ExpandCraftHeader(id)
                    end
                    return
                end
                if origOnClick then origOnClick() end
            end)
        end
    end
end

function CF.HookCraftFrameUpdate()
    if AtlasCFM.CraftFilter_Hooked then return end
    AtlasCFM.CraftFilter_Hooked = true

    local scrollBar = _G[CraftListScrollFrame:GetName() .. "ScrollBar"]
    if not CF.ScrollHandlersHooked then
        CF.ScrollHandlersHooked = true

        local origOnVerticalScroll = CraftListScrollFrame:GetScript("OnVerticalScroll")
        CraftListScrollFrame:SetScript("OnVerticalScroll", function()
            if arg1 then
                CF.ScrollValue = arg1
            end
            if origOnVerticalScroll then
                origOnVerticalScroll()
            end
        end)

        if scrollBar then
            local origOnValueChanged = scrollBar:GetScript("OnValueChanged")
            scrollBar:SetScript("OnValueChanged", function()
                CF.ScrollValue = this:GetValue() or CF.ScrollValue or 0
                if origOnValueChanged then
                    origOnValueChanged()
                end
            end)
        end
    end

    local orig_CraftFrame_Update = CraftFrame_Update
    function CraftFrame_Update()
        if AtlasCFM.ProfessionHooks._updatingCraft then return end

        if not AtlasCFMOptions or not AtlasCFMOptions.ProfessionInfo then
            orig_CraftFrame_Update()
            if CraftFrame:IsVisible() then
                AtlasCFM.ProfessionHooks.UpdateSideTabs(CraftFrame)
                if AtlasCFM.pfUI and AtlasCFM.pfUI.StyleProfessionFrames then
                    AtlasCFM.pfUI.StyleProfessionFrames()
                end
            end
            if CF.UIReady then
                if _G["AtlasCFMCraftCollapseAll"] then _G["AtlasCFMCraftCollapseAll"]:Hide() end
                if _G["AtlasCFMCraftCategories"] then _G["AtlasCFMCraftCategories"]:Hide() end
                if _G["AtlasCFMCraftShowSkillLevels"] then _G["AtlasCFMCraftShowSkillLevels"]:Hide() end
            end
            return
        end

        AtlasCFM.ProfessionHooks._updatingCraft = true
        scrollBar = _G[CraftListScrollFrame:GetName() .. "ScrollBar"]
        local preUpdateScrollValue = CF.ScrollValue or 0
        if scrollBar and CF.ScrollValue == nil then
            preUpdateScrollValue = scrollBar:GetValue() or preUpdateScrollValue
        end

        CF.InitUI()
        CF.BuildList()

        -- Let default logic run first so native state is updated (selection, ingredients)
        -- We run BuildList BEFORE this to ensure headers are expanded, preventing FauxScrollFrame from clamping to 0
        orig_CraftFrame_Update()

        -- Update Side Panel and Styling (Essential for visibility)
        if CraftFrame:IsVisible() then
            AtlasCFM.ProfessionHooks.UpdateSideTabs(CraftFrame)
            if AtlasCFM.pfUI and AtlasCFM.pfUI.StyleProfessionFrames then
                AtlasCFM.pfUI.StyleProfessionFrames()
            end
        end

        if not CraftFrame:IsVisible() then
            AtlasCFM.ProfessionHooks._updatingCraft = nil
            return
        end

        local numItems = table.getn(CF.List)
        local numDisplayed = GetCraftButtonsCount()

        local rowHeight = CRAFT_SKILL_HEIGHT or 16
        if rowHeight < 1 then rowHeight = 16 end

        FauxScrollFrame_Update(CraftListScrollFrame, numItems, numDisplayed, rowHeight)
        if scrollBar then
            local minVal, maxVal = scrollBar:GetMinMaxValues()
            local targetValue = preUpdateScrollValue
            if targetValue < minVal then targetValue = minVal end
            if targetValue > maxVal then targetValue = maxVal end
            if math.abs((scrollBar:GetValue() or 0) - targetValue) > 0.5 then
                scrollBar:SetValue(targetValue)
            end
        end

        local craftOffset = FauxScrollFrame_GetOffset(CraftListScrollFrame)
        local selectionIndex = GetCraftSelectionIndex()

        if CraftHighlightFrame then CraftHighlightFrame:Hide() end

        for i = 1, numDisplayed do
            local itemIndex = i + craftOffset
            local craftButton = _G["Craft" .. i]
            local craftText = _G["Craft" .. i .. "Text"]

            -- Create icon if needed (merged from OnCraftUpdate logic)
            if not craftButton.atlasIcon then
                craftButton.atlasIcon = craftButton:CreateTexture(nil, "ARTWORK")
                craftButton.atlasIcon:SetWidth(12)
                craftButton.atlasIcon:SetHeight(12)
            end
            local icon = craftButton.atlasIcon
            icon:Hide()

            if itemIndex and itemIndex <= numItems then
                local data = CF.List[itemIndex]

                if data.isHeader then
                    craftButton:SetID(data.isNativeHeader and data.index or 0)
                    craftButton.catName = not data.isNativeHeader and data.name or nil
                    craftButton.isNativeHeader = data.isNativeHeader
                    craftButton.expanded = data.expanded
                    craftText:ClearAllPoints()
                    craftText:SetPoint("LEFT", craftButton, "LEFT", 18, 0)
                    -- craftText:SetWidth(craftButton:GetWidth() - 14)
                    craftText:SetText(data.name)
                    craftText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

                    if data.expanded then
                        craftButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
                    else
                        craftButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
                    end
                    _G["Craft" .. i .. "Highlight"]:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight")

                    craftButton:Show()
                else
                    craftButton:SetID(data.index)
                    craftButton.catName = nil
                    craftButton.isNativeHeader = nil
                    craftButton.expanded = nil


                    -- Force update width for all buttons to prevent alignment issues
                    if CraftListScrollFrame:IsVisible() then
                        craftButton:SetWidth(293)
                        craftText:SetWidth(290)
                    else
                        craftButton:SetWidth(323)
                        craftText:SetWidth(320)
                    end

                    craftText:ClearAllPoints()
                    craftText:SetPoint("LEFT", craftButton, "LEFT", 0, 0)
                    --  craftText:SetWidth(craftButton:GetWidth() - 14)

                    -- Setup text with extra info (skill levels and counts)
                    local _, _, _, numAvailable = GetCraftInfo(data.index)

                    local customAvailable = AtlasCFM.ProfessionHooks.CraftAvailCache[data.index]
                    local realAvailable = AtlasCFM.ProfessionHooks.CraftRealCache[data.index] or numAvailable or 0
                    if not customAvailable then customAvailable = realAvailable end

                    local countText = ""
                    if customAvailable > realAvailable then
                        countText = "[" .. customAvailable .. "/" .. realAvailable .. "] "
                    elseif realAvailable > 0 then
                        countText = "[" .. realAvailable .. "] "
                    end

                    local nameText = data.name
                    local levels = AtlasCFM.DataIndex and AtlasCFM.DataIndex.GetSkillLevels(data.name)
                    if CF.ShowSkillLevels and levels and levels ~= "" then
                        nameText = nameText .. " " .. levels
                    end

                    local texture = GetCraftIcon(data.index)
                    if texture then
                        craftText:SetText(countText .. nameText)

                        icon:SetTexture(texture)
                        icon:ClearAllPoints()
                        -- Position icon on the right end of the button to keep them in a line
                        icon:SetPoint("RIGHT", craftButton, "RIGHT", -2, 0)
                        icon:Show()
                    else
                        craftText:SetText(countText .. nameText)
                    end

                    -- Setup color
                    local color = CraftTypeColor[data.type] or { r = 1, g = 1, b = 1 }
                    craftText:SetTextColor(color.r, color.g, color.b)

                    -- Setup textures for normal buttons
                    craftButton:SetNormalTexture("")
                    _G["Craft" .. i .. "Highlight"]:SetTexture("")

                    if selectionIndex == data.index then
                        CraftHighlightFrame:SetPoint("TOPLEFT", craftButton, "TOPLEFT")
                        CraftHighlightFrame:Show()
                    end

                    craftButton:Show()
                end
            else
                craftButton:Hide()
            end
        end
        if scrollBar then
            CF.ScrollValue = scrollBar:GetValue() or preUpdateScrollValue
        else
            CF.ScrollValue = preUpdateScrollValue
        end
        AtlasCFM.ProfessionHooks._updatingCraft = nil
    end
end

-- Initialize Hooks
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" then
        if arg1 == "Blizzard_TradeSkillUI" then
            AtlasCFM.ProfessionHooks.ApplyHooks()
            AtlasCFM.ProfessionHooks.CreateAtlasButton(TradeSkillFrame)
            AtlasCFM.ProfessionHooks.HookReagentButtons("TradeSkillReagent")
        elseif arg1 == "Blizzard_CraftUI" then
            AtlasCFM.ProfessionHooks.CraftFilter.HookCraftFrameUpdate()
            AtlasCFM.ProfessionHooks.CreateAtlasButton(CraftFrame)
            AtlasCFM.ProfessionHooks.HookReagentButtons("CraftReagent")
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if IsAddOnLoaded("Blizzard_TradeSkillUI") then
            AtlasCFM.ProfessionHooks.ApplyHooks()
            AtlasCFM.ProfessionHooks.CreateAtlasButton(TradeSkillFrame)
            AtlasCFM.ProfessionHooks.HookReagentButtons("TradeSkillReagent")
        end

        if IsAddOnLoaded("Blizzard_CraftUI") then
            AtlasCFM.ProfessionHooks.CraftFilter.HookCraftFrameUpdate()
            AtlasCFM.ProfessionHooks.CreateAtlasButton(CraftFrame)
            AtlasCFM.ProfessionHooks.HookReagentButtons("CraftReagent")
        end
    end
end)

-- 1.12 Hook Compatibility
if not hooksecurefunc then
    function hooksecurefunc(name, func)
        local original = _G[name]
        _G[name] = function(...)
            if original then original(unpack(arg)) end
            func(unpack(arg))
        end
    end
end

-- Refresh hooks and UI when server is changed on the fly
function AtlasCFM.ProfessionHooks.RefreshHooks()
    if IsAddOnLoaded("Blizzard_TradeSkillUI") then
        AtlasCFM.ProfessionHooks.ApplyHooks()
    end

    local isTurtle = AtlasCFM.ProfessionHooks.IsTurtleLatest()
    local searchBox = _G["AtlasCFMCraftSearchBox"]
    local matCheck = _G["AtlasCFMCraftHaveMaterials"]
    local skillCheck = _G["AtlasCFMCraftImprovesSkill"]
    local catCheck = _G["AtlasCFMCraftCategories"]

    if searchBox then
        if isTurtle then searchBox:Hide() else searchBox:Show() end
    end
    if matCheck then
        if isTurtle then matCheck:Hide() else matCheck:Show() end
    end
    if skillCheck then
        if isTurtle then skillCheck:Hide() else skillCheck:Show() end
    end
    if catCheck then
        catCheck:ClearAllPoints()
        if IsAddOnLoaded("pfUI") then
            catCheck:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 0, 0)
        else
            if isTurtle then
                catCheck:SetPoint("TOP", CraftFrame, "TOP", 100, -15)
            else
                catCheck:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 65, -15)
            end
        end
    end

    -- TradeSkillFrame elements
    local tsSearchBox = _G["AtlasCFMTradeSkillSearchBox"]
    local tsMatCheck = _G["AtlasCFMTradeSkillHaveMaterials"]
    local tsSkillCheck = _G["AtlasCFMTradeSkillImprovesSkill"]
    local tsShowLevels = _G["AtlasCFMTradeSkillShowLevels"]

    if tsSearchBox then
        if isTurtle then tsSearchBox:Hide() else tsSearchBox:Show() end
    end
    if tsMatCheck then
        if isTurtle then tsMatCheck:Hide() else tsMatCheck:Show() end
    end
    if tsSkillCheck then
        if isTurtle then tsSkillCheck:Hide() else tsSkillCheck:Show() end
    end
    if tsShowLevels then
        if isTurtle then tsShowLevels:Hide() else tsShowLevels:Show() end
    end
end

-- Hook OnHide to prevent session termination during switch
-- This mimics Artisan behavior where the session is kept alive
local function HookOnHide(funcName)
    local original = _G[funcName]
    if original then
        _G[funcName] = function()
            if AtlasCFM.ProfessionHooks.IsSwitching then
                -- Skip calling CloseTradeSkill/CloseCraft
                return
            end
            original()
        end
    end
end

HookOnHide("TradeSkillFrame_OnHide")
HookOnHide("CraftFrame_OnHide")
