---
--- LootBrowserUI.lua - Loot browser user interface functionality
---
--- This module handles the user interface components for the loot browser.
--- It manages scrollbar updates, boss line rendering, and visual state management
--- for the Atlas loot display system.
---
--- Features:
--- - Boss list scrollbar management
--- - Loot items scrollbar management
--- - Visual state indicators (loot available, selected)
--- - Boss line element creation and updates
--- - Frame visibility and interaction handling
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM
AtlasCFM.LootBrowserUI = AtlasCFM.LootBrowserUI or {}

-- Instance required libraries
local L = AtlasCFM.Localization.UI

local GREEN = AtlasCFM.Colors.GREEN
local GREY = AtlasCFM.Colors.GREY
local ORANGE = AtlasCFM.Colors.ORANGE
local YELLOW = AtlasCFM.Colors.YELLOW

---
--- Updates the scroll bar display for Atlas boss list
--- Manages visibility and state of boss line elements based on scroll position
--- Handles loot indicators and selection highlighting
--- @return void
--- @usage AtlasCFM.LootBrowserUI.ScrollBarUpdate()
---
function AtlasCFM.LootBrowserUI.ScrollBarUpdate()
	local lineplusoffset
	local highlightTexture
	if _G["AtlasCFMBossLine1_Text"] ~= nil then
		local zoneID = AtlasCFM.DropDowns[AtlasCFMOptions.AtlasType][AtlasCFMOptions.AtlasZone]

		-- Update the contents of the Atlas scroll frames
		FauxScrollFrame_Update(AtlasCFMScrollBar, AtlasCFM.CurrentLine, AtlasCFM.NUM_LINES, 15)

		-- Now show only needed elements
		for line = 1, AtlasCFM.NUM_LINES do
			lineplusoffset = line + FauxScrollFrame_GetOffset(AtlasCFMScrollBar)
			local bossLine = _G["AtlasCFMBossLine" .. line]

			if bossLine and lineplusoffset <= AtlasCFM.CurrentLine then
				-- Enable interactivity and texture for visible buttons
				bossLine:Show()
				bossLine:EnableMouse(true)
				highlightTexture = bossLine:GetHighlightTexture()
				highlightTexture:Show()

				local loot = _G["AtlasCFMBossLine" .. line .. "_Loot"]
				local selected = _G["AtlasCFMBossLine" .. line .. "_Selected"]
				_G["AtlasCFMBossLine" .. line .. "_Text"]:SetText(AtlasCFM.ScrollList[lineplusoffset].line)

				-- Check if this boss has loot data
				local hasLoot = AtlasCFM.DataResolver.GetLootByID(zoneID, lineplusoffset)

				if AtlasCFMLootItemsFrame.activeElement == lineplusoffset then
					bossLine:Enable()
					loot:Hide()
					selected:Show()
				elseif hasLoot then
					bossLine:Enable()
					loot:Show()
					selected:Hide()
				else
					bossLine:Disable()
					loot:Hide()
					selected:Hide()
				end

				bossLine.idnum = lineplusoffset
				bossLine:Show()
			elseif bossLine then
				-- Hide lines that are not needed
				bossLine:Hide()
				-- Completely disable interactivity
				bossLine:EnableMouse(false)
				-- Hide HighlightTexture explicitly
				highlightTexture = bossLine:GetHighlightTexture()
				if highlightTexture then
					highlightTexture:Hide()
				end
			end
		end
	end
end

---
--- Formats skill text with appropriate color coding
--- Applies color codes to skill level requirements for display
--- @param skilltext table Table containing skill level values [1-4]
--- @return string Formatted skill text with color codes
--- @usage local formatted = formSkillStyle({"100", "150", "200", "250"})
---
local function formSkillStyle(skilltext)
	if not skilltext or type(skilltext) ~= "table" then return "" end
	return L["Skill:"] .. " " .. ORANGE .. skilltext[1] .. ", " .. YELLOW .. skilltext[2] .. ", " ..
		GREEN .. skilltext[3] .. ", " .. GREY .. skilltext[4]
end

-- Helper function to count maximum numeric index (sparse array support)
local function GetMaxNumericIndex(tbl)
	local maxIndex = 0
	for k, v in pairs(tbl) do
		if type(k) == "number" and k > maxIndex and v then
			maxIndex = k
		end
	end
	return maxIndex
end

-- OnUpdate handler for triple blink
local function AtlasCFMLoot_Blink_OnUpdate()
	this._blinkElapsed = (this._blinkElapsed or 0) + arg1
	if this._blinkElapsed >= .7 then
		if this._blinkPhase == "on" then
			this:SetAlpha(0)
			this._blinkPhase = "off"
			this._blinkElapsed = 0
		else
			if (this._blinkRemaining or 0) > 1 then
				this._blinkRemaining = this._blinkRemaining - 1
				this._blinkPhase = "on"
				this._blinkElapsed = 0
				this:SetAlpha(1)
			else
				-- Final state: visible, stop OnUpdate to avoid CPU overhead
				this._blinkElapsed = nil
				this._blinkPhase = nil
				this._blinkRemaining = nil
				this._blinkActive = nil
				this:SetScript("OnUpdate", nil)
				this:SetAlpha(0)
			end
		end
	end
end

-- Implement triple blink using OnUpdate (arg1 is elapsed time).
-- Note: OnUpdate does not run while a frame is hidden in WoW 1.12,
-- so we toggle alpha instead of Hide/Show to keep the handler active.
local function AtlasCFMLoot_BlinkScrollHint()
	local f = AtlasCFMLootScrollHint
	if f._blinkActive then return end
	f._blinkActive = true
	f:Show()
	f:SetAlpha(1)
	f._blinkRemaining = 2 -- set to 2 for triple blink
	f._blinkPhase = "on"
	f._blinkElapsed = 0
	f:SetScript("OnUpdate", AtlasCFMLoot_Blink_OnUpdate)
end

-- Helper function to apply server-specific border or container border
local function UpdateElementBorder(borderFrame, element, link)
	if not borderFrame then return end
	
	local hasTurtle = false
	local hasVPlus = false
	
	local function checkServers(src)
		if not src or type(src) ~= "table" then return end
		local servers = src.servers or src.Servers
		if not servers and src[8] and type(src[8]) == "table" then
			servers = src[8]
		end
		if servers and type(servers) == "table" then
			for k, s in pairs(servers) do
				local target = nil
				if type(k) == "number" and type(s) == "string" and string.sub(s, 1, 1) ~= "!" then
					target = s
				elseif type(k) == "string" and s ~= false then
					target = k
				end
				if target then
					if string.sub(target, 1, 1) == "=" then target = string.sub(target, 2) end
					if target == AtlasCFM.Server.TURTLE or target == AtlasCFM.Server.TURTLE1 then
						hasTurtle = true
					elseif target == AtlasCFM.Server.VANILLA_PLUS then
						hasVPlus = true
					end
				end
			end
		end
	end

	checkServers(element)
	if link then checkServers(link) end

	if hasTurtle then
		borderFrame:SetTexture(AtlasCFM.PATH .. "Images\\Turtle-Border")
		borderFrame:SetDrawLayer("BACKGROUND")
		borderFrame:SetAlpha(1)
		borderFrame:Show()
	elseif hasVPlus then
		borderFrame:SetTexture(AtlasCFM.PATH .. "Images\\V+Border")
		borderFrame:SetDrawLayer("BACKGROUND")
		borderFrame:SetAlpha(1)
		borderFrame:Show()
	elseif element and element.container then
		borderFrame:SetTexture(AtlasCFM.PATH .. "Images\\Container-Border")
		borderFrame:SetDrawLayer("BACKGROUND")
		borderFrame:SetAlpha(1)
		borderFrame:Show()
	else
		borderFrame:Hide()
	end
end

---
--- Updates the scrollbar and content for the loot items frame
--- Loads and displays loot data for the currently selected element
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.ScrollBarLootUpdate() -- Called when loot data changes
---
function AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
	--Load data for the current clicked element line
	local dataID = AtlasCFMLootItemsFrame.StoredElement

	-- The global loot suitability filter (Class / Available) is intended for
	-- equippable loot browsing.  Crafting pages describe recipes, not a list
	-- of gear the current character can equip right now.  Applying the filter
	-- there made recipes disappear progressively as their result items finished
	-- loading from the item cache (especially visible on the three Leatherworking
	-- specialization pages).  Resolve the page category once per repaint and
	-- keep all crafting recipes visible.
	local isCraftingPage = false
	if type(dataID) == "string" and AtlasCFM.LootUtils and AtlasCFM.LootUtils.GetMetaCategoryForMenu then
		isCraftingPage = AtlasCFM.LootUtils.GetMetaCategoryForMenu(dataID) == L["Crafting"]
	end

	-- Hide sort dropdown by default if we're not in WishList
	if AtlasCFMLootWishListSortDropDown then
		if dataID == "WishList" then
			AtlasCFMLootWishListSortDropDown:Show()
		else
			AtlasCFMLootWishListSortDropDown:Hide()
		end
	end
	local instanceKey = (AtlasCFMLootItemsFrame and type(AtlasCFMLootItemsFrame.StoredMenu) == "string") and
		AtlasCFMLootItemsFrame.StoredMenu or nil
	local dataSource = AtlasCFM.DataResolver.GetLootByElemName(dataID, instanceKey) or AtlasCFMLootItemsFrame.StoredMenu

	-- Special handling for wish list and search results
	if dataID == "WishList" or dataID == "SearchResult" then
		if dataID == "WishList" and not AtlasCFMCharDB["WishList"] then
			AtlasCFMCharDB["WishList"] = {}
		end
		if dataID == "SearchResult" and not AtlasCFMCharDB["SearchResult"] then
			AtlasCFMCharDB["SearchResult"] = {}
		end
		-- Create categorized list for display
		local list = (dataID == "WishList") and AtlasCFMCharDB["WishList"] or AtlasCFMCharDB["SearchResult"]
		dataSource = AtlasCFMLoot_CategorizeWishList(list)
	else
		if type(dataID) == "string" and (AtlasCFMLoot_Data[dataID] or AtlasCFMLoot_Data[dataSource]) then
			dataSource = AtlasCFMLoot_Data[dataID] or AtlasCFMLoot_Data[dataSource]
		end
		if type(dataSource) == "string" then
			dataSource = AtlasCFM.DataResolver.GetLootByElemName(dataSource, instanceKey) or dataSource
		end
	end
	--Check if dataID and dataSource are valid
	if not dataID and not dataSource then
		return --PrintA("AtlasCFM.LootBrowserUI.ScrollBarLootUpdate: No dataID and No dataSource!")
	end

	-- Filter dataSource by server compatibility
	if type(dataSource) == "table" then
		local filtered = {}
		local maxIdx = GetMaxNumericIndex(dataSource)
		for i = 1, maxIdx do
			local element = dataSource[i]
			if element == nil then
				-- Preserve original sparse array gaps (nil holes) as empty rows for layout
				table.insert(filtered, {})
			elseif type(element) == "table" and not next(element) then
				-- Preserve original empty tables `{}` (spacers)
				table.insert(filtered, element)
			else
				local isVisible = AtlasCFM.Server.IsVisible(element)
				local el_type = AtlasCFM.Server.GetDataField(element, "type")
				if isVisible and type(element) == "table" and element.id and not (el_type == "item") then
					local spellID = element.id
					local wlType = element._wlType
					local link = nil
					if AtlasCFM.SpellDB then
						if wlType == "enchant" then
							link = AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[spellID]
						elseif wlType == "spell" then
							link = AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[spellID]
						else
							link = (AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[spellID]) or
								(AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[spellID])
						end
					end
					if link then
						isVisible = AtlasCFM.Server.IsVisible(link)
					end
				end
				if isVisible then
					table.insert(filtered, element)
				end
			end
			-- If AtlasCFM.Server.IsVisible(element) is false, we don't insert anything,
			-- effectively compacting the list and removing the row entirely.
		end
		-- Keep non-numeric fields (metadata like wishlist, etc)
		for k, v in pairs(dataSource) do
			if type(k) ~= "number" then
				filtered[k] = v
			end
		end
		dataSource = filtered
	end
	-- Hide navigation buttons by default
	_G["AtlasCFMLootItemsFrame_BACK"]:Hide()
	_G["AtlasCFMLootItemsFrame_NEXT"]:Hide()
	_G["AtlasCFMLootItemsFrame_PREV"]:Hide()
	if type(dataSource) == "table" then
		local LZ = AtlasCFM.Localization.Zones
		local quantityFrame, menuButton, extraText, defaultIcon, itemButton, iconFrame, nameFrame, extraFrame, borderFrame

		local totalItems = GetMaxNumericIndex(dataSource)

		if totalItems > AtlasCFM.LOOT_NUM_LINES then
			AtlasCFMLoot_BlinkScrollHint()
		else
			AtlasCFMLootScrollHint:SetAlpha(0)
		end
		-- Set scroll bar range
		local scrollLines = math.floor(totalItems / 30) * 15 + math.min(math.mod(totalItems, 30), 15)

		AtlasCFMLootScrollBar.scrollMax = math.max(0, scrollLines - 15)
		FauxScrollFrame_Update(AtlasCFMLootScrollBar, scrollLines, 15, 15)

		local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar)
		-- Update content and visibility of AtlasCFMLootItem buttons
		for i = 1, AtlasCFM.LOOT_NUM_LINES do
			itemButton = _G["AtlasCFMLootItem_" .. i]
			menuButton = _G["AtlasCFMLootMenuItem_" .. i]
			-- Calculate correct index for two columns
			local itemIndex = i + offset
			if offset > 0 then
				local col_size = 15

				local i_zero = i - 1
				local col_idx = math.floor(i_zero / col_size)
				local offset_block = math.floor((offset - 1) / col_size)
				local item_block = math.floor((itemIndex - 1) / col_size)

				local expected_block = col_idx + offset_block
				local adjustment = 0

				if item_block == expected_block and offset_block > 0 then
					adjustment = offset_block * col_size
				elseif item_block == expected_block + 1 then
					adjustment = (offset_block + 1) * col_size
				end

				if adjustment > 0 then
					itemIndex = itemIndex + adjustment
				end
			end
			if itemIndex <= totalItems and dataSource[itemIndex] then
				if menuButton and type(dataID) == "table" then
					nameFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Name"]
					iconFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Icon"]
					extraFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Extra"]
					borderFrame = _G["AtlasCFMLootMenuItem_" .. i .. "Border"]
					quantityFrame = nil
					local element = dataSource[itemIndex]
					defaultIcon = dataID.defaultIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
					if element.name then
						if element.extra then
							extraText = LZ[element.extra]
						elseif element.Extra then
							extraText = element.Extra
						else
							extraText = ""
						end
						nameFrame:SetText(element.name)
						extraFrame:SetText(extraText)
						extraFrame:Show()
						iconFrame:SetTexture(element.icon or defaultIcon)
						menuButton.name = element.name_orig or element.name
						menuButton.lootpage = element.lootpage
						menuButton.container = element.container
						menuButton.firstBoss = element.firstBoss
						UpdateElementBorder(borderFrame, element, nil)
						menuButton:Show()
					else
						-- Clear fields to prevent stale data usage
						menuButton.name = nil
						menuButton.lootpage = nil
						menuButton.container = nil
						menuButton.firstBoss = nil
						menuButton:Hide()
					end
					-- Hide item and container buttons
					if itemButton then
						itemButton:Hide()
					end
				elseif itemButton then
					nameFrame = _G["AtlasCFMLootItem_" .. i .. "_Name"]
					iconFrame = _G["AtlasCFMLootItem_" .. i .. "_Icon"]
					extraFrame = _G["AtlasCFMLootItem_" .. i .. "_Extra"]
					borderFrame = _G["AtlasCFMLootItem_" .. i .. "Border"]
					quantityFrame = _G["AtlasCFMLootItem_" .. i .. "_Quantity"]

					local shouldShow = false

					local element = dataSource[itemIndex]
					-- Normalize WishList/SearchResult elements (excluding headers) to common format of regular elements
					local sourcePageVal = nil
					if (dataID == "WishList" or dataID == "SearchResult") and element and type(element) == "table" then
						sourcePageVal = element[5]
						-- In 1.12 there are entries where [5] or [2]/[3] can be tables; protect concatenation
						if type(sourcePageVal) ~= "string" then
							sourcePageVal = nil
						end
						if not sourcePageVal then
							local e2, e3 = element[2], element[3]
							if (type(e2) == "string" or type(e2) == "number") and (type(e3) == "string" or type(e3) == "number") then
								sourcePageVal = tostring(e2) .. "|" .. tostring(e3)
							elseif type(e2) == "table" or type(e3) == "table" then
							end
						end
					end
					if (dataID == "WishList" or dataID == "SearchResult") and element and type(element) == "table" and element[1] and element[1] ~= 0 then
						local wlItemID = element[1]
						local wlElementType = element[4]
						-- Convert WishList/SearchResult element to regular element structure
						if wlElementType ~= "item" then
							-- For spells/enchants: ID may be 's123' or 'e456'; convert to number
							local elemNum = wlItemID
							if type(wlItemID) == "string" and string.len(wlItemID) > 1 then
								elemNum = tonumber(string.sub(wlItemID, 2)) or wlItemID
							end
							element = { id = elemNum, skill = 1, _wlType = wlElementType }
						else
							-- For regular items explicitly mark the type
							element = { id = wlItemID, type = "item" }
						end
					end
					-- Special handling ONLY for WishList/SearchResult headers (elements with id == 0)
					if (dataID == "WishList" or dataID == "SearchResult") and element and type(element) == "table" and element[1] == 0 then
						-- This is a separator/header
						local wlBossName = element[2]
						local wlInstanceName = element[3]
						local separator = AtlasCFM.ItemDB.CreateSeparator(wlBossName, "INV_Box_01", 6)
						nameFrame:SetText(separator.name ~= "" and separator.name or wlBossName)
						local r, g, b = GetItemQualityColor(6)
						nameFrame:SetTextColor(r, g, b)
						iconFrame:SetTexture("Interface\\Icons\\INV_Box_01")
						extraFrame:SetText(wlInstanceName or "")
						extraFrame:Show()
						quantityFrame:Hide()

						-- Clear button data for separators
						itemButton.itemID = 0
						itemButton.elemID = 0
						itemButton.typeID = nil
						itemButton.sourcePage = nil
						itemButton.container = nil
						itemButton.droprate = nil
						borderFrame:Hide()
						shouldShow = true
						-- Processing for other elements
					elseif element and (element.id or element.name) then
						local itemTexture, itemID, extratext, link, quantity = nil, nil, "", nil, ""
						local itemName = element.name
						local elemID = element.id
						local itemQuality = 0
						local el_type = AtlasCFM.Server.GetDataField(element, "type")
						local skill = AtlasCFM.Server.GetDataField(element, "skill")

						if elemID and elemID ~= 0 then
							if not (el_type and el_type == "item") then
								if element._wlType == "enchant" then
									link = AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[elemID]
								elseif element._wlType == "spell" then
									link = AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[elemID]
								else
									link = (AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[elemID]) or
										(AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[elemID])
								end
							else
								link = nil
							end
							if skill and not (el_type and el_type == "item") then
								-- Set original ID for itemButton (enchant or spell)
								itemButton.elemID = elemID
								-- Set type for itemButton (enchant or spell)
								if element._wlType == "enchant" then
									itemButton.typeID = "enchant"
								elseif element._wlType == "spell" then
									itemButton.typeID = "spell"
								elseif AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[elemID] then
									itemButton.typeID = "enchant"
								else
									itemButton.typeID = "spell"
								end
								-- Set itemID from spell
								itemID = link and AtlasCFM.Server.GetDataField(link, "item")
								local reagents = link and AtlasCFM.Server.GetDataField(link, "reagents")
								local tools = link and AtlasCFM.Server.GetDataField(link, "tools")
								local resultItem = link and AtlasCFM.Server.GetDataField(link, "item")

								AtlasCFM.LootCache.CacheAllItems(reagents)
								AtlasCFM.LootCache.CacheAllItems(tools)
								if resultItem then
									AtlasCFM.LootCache.CacheAllItems({ resultItem })
								end
							else
								itemButton.typeID = "item"
							end
							-- Set skill text coz same items have skill discription like herbalism
							extratext = formSkillStyle(skill)
							-- dont want set itemID from elemID coz same ID have items
							if itemButton.typeID == "item" then
								itemID = elemID
							elseif itemButton.typeID == "spell" then
								-- Only use created item if the spell actually creates one.
								-- Otherwise keep itemID as nil/0 to avoid picking up an unrelated item with the same ID.
								-- EXCEPTION: if skill is 0, we treat it as a spell but allow using the ID for name/icon retrieval
								-- (used for spells that share IDs with items like Basic Campfire)
								if skill == 0 then
									itemID = elemID
								else
									itemID = (itemID and itemID ~= 0) and itemID or nil
								end
							end
							--set quantity for items and spells
							if itemButton.typeID == "item" then
								local elemQuantity = AtlasCFM.Server.GetDataField(element, "quantity")
								quantity = elemQuantity and type(elemQuantity) == "table" and
									elemQuantity[1] .. "-" .. elemQuantity[2] or elemQuantity
							else
								local spellQuantity = link and AtlasCFM.Server.GetDataField(link, "quantity")
								quantity = spellQuantity and type(spellQuantity) == "table" and
									spellQuantity[1] .. "-" .. spellQuantity[2] or spellQuantity
							end
							--get item name, texture and quality
							itemName, _, itemQuality, _, _, _, _, _, itemTexture = GetItemInfo(itemID or 0)
							if itemName then
								local r, g, b = GetItemQualityColor(itemQuality or 1)
								nameFrame:SetTextColor(r, g, b)
							else
								itemName = link and AtlasCFM.Server.GetDataField(link, "name")
								nameFrame:SetTextColor(1, 1, 1)
							end
							-- set name frame text for itemButton
							nameFrame:SetText(itemName or (GREY .. L["Item not found in cache"] .. "|r"))
						elseif element.name then
							-- Handle the case where item is a separator
							local separator = AtlasCFM.ItemDB.CreateSeparator(element.name, element.icon, element
							.quality)
							itemName = separator.name
							itemQuality = separator.quality
							itemTexture = separator.texture

							-- Clear itemButton data from item saves
							itemButton.itemID = 0
							itemButton.elemID = 0
							itemButton.typeID = element.container and "item" or nil

							local r, g, b = GetItemQualityColor(itemQuality)
							nameFrame:SetTextColor(r, g, b)
							nameFrame:SetText(itemName or (GREY .. L["Item not found in cache"] .. "|r"))
						end

						-- Set description text
						if not skill or (el_type and el_type == "item") then -- if item
							local disc = AtlasCFM.Server.GetDataField(element, "disc")
							local parsedText = AtlasCFM.ItemDB.ParseTooltipForItemInfo(itemID, disc)
							if parsedText and parsedText ~= "" then
								extratext = extratext and extratext .. parsedText or parsedText
							else
								local extra = AtlasCFM.Server.GetDataField(element, "extra")
								extratext = extra and extratext .. extra or extratext
							end
						else -- if spell
							local spellIcon = link and AtlasCFM.Server.GetDataField(link, "icon")
							itemTexture = itemTexture or (spellIcon and "Interface\\Icons\\" .. spellIcon)
							itemTexture = itemTexture or
							(AtlasCFM.Server.GetDataField(element, "icon") and "Interface\\Icons\\" .. AtlasCFM.Server.GetDataField(element, "icon"))
							itemTexture = itemTexture or "Interface\\Icons\\Spell_Holy_GreaterHeal"
							local parsedText = AtlasCFM.ItemDB.ParseTooltipForItemInfo(itemID)
							local extra = link and AtlasCFM.Server.GetDataField(link, "extra")
							parsedText = extra and (extra .. ", " .. parsedText) or parsedText
							if extratext ~= "" and parsedText ~= "" then
								extratext = extratext .. ", " .. parsedText
							elseif parsedText ~= "" then
								extratext = parsedText
							end
						end

						-- Set the description text
						if not itemName then extratext = L["The content patch isn't out yet"] end
						extraFrame:SetText(extratext or "")
						extraFrame:Show()

						-- Set the quantity
						if quantity and quantity ~= "" then
							quantityFrame:SetText(quantity)
							quantityFrame:Show()
						else
							quantityFrame:Hide()
						end

						-- Set the icon
						iconFrame:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark")

						-- Save the item button data
						itemButton.container = element.container
						UpdateElementBorder(borderFrame, element, link)

						-- Set the item drop rate
						itemButton.droprate = element.dropRate and element.dropRate .. "%"

						itemButton.itemID = itemID or 0
						itemButton.sourcePage = sourcePageVal

						shouldShow = true

						-- Apply loot filter
						local filterMode = AtlasCFMOptions.LootFilterMode or 0
						if not isCraftingPage and filterMode > 0 and itemID and itemID > 0 then
							if not AtlasCFM.ItemDB.IsItemSuitable(itemID, filterMode) then
								shouldShow = false
							end
						end
					end
					if shouldShow then
						itemButton:Show()
					else
						itemButton:Hide()
					end
					-- Hide menu buttons when displaying items
					if menuButton then
						menuButton:Hide()
					end
				end
			else
				nameFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Name"]
				iconFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Icon"]
				extraFrame = _G["AtlasCFMLootMenuItem_" .. i .. "_Extra"]
				borderFrame = _G["AtlasCFMLootMenuItem_" .. i .. "Border"]
				-- Clear button content if no data
				if iconFrame then iconFrame:SetTexture("") end
				if nameFrame then nameFrame:SetText("") end
				if extraFrame then
					extraFrame:SetText("")
					extraFrame:Hide()
				end
				if borderFrame then borderFrame:Hide() end
				menuButton.name = nil
				menuButton.name_orig = nil
				menuButton.lootpage = nil
				menuButton.container = nil
				menuButton.firstBoss = nil
				iconFrame = _G["AtlasCFMLootItem_" .. i .. "_Icon"]
				extraFrame = _G["AtlasCFMLootItem_" .. i .. "_Extra"]
				borderFrame = _G["AtlasCFMLootItem_" .. i .. "Border"]
				quantityFrame = _G["AtlasCFMLootItem_" .. i .. "_Quantity"]
				-- Clear button content if no data
				if iconFrame then iconFrame:SetTexture("") end
				if nameFrame then nameFrame:SetText("") end
				if extraFrame then
					extraFrame:SetText("")
					extraFrame:Hide()
				end
				if borderFrame then borderFrame:Hide() end
				if quantityFrame then quantityFrame:Hide() end
				itemButton.itemID = 0
				itemButton.elemID = 0
				itemButton.typeID = nil
				itemButton.itemLink = nil
				itemButton.container = nil
				itemButton.droprate = nil
				itemButton:Hide()
				menuButton:Hide()
			end
		end
	elseif type(_G[dataSource]) == "function" then
		_G[dataSource]()
	else
	end
	-- Show "Back" button if there is a parent menu
	if AtlasCFMLootItemsFrame.StoredBackMenuName then
		_G["AtlasCFMLootItemsFrame_BACK"]:Show()
		_G["AtlasCFMLootItemsFrame_BACK"].lootpage = "BackToMenu"
		_G["AtlasCFMLootItemsFrame_BACK"].title = AtlasCFMLootItemsFrame.StoredBackMenuName
	end

	local nav = nil
	if dataID ~= "SearchResult" and dataID ~= "WishList" then
		-- Navigation is handled except for Search/WishList
		-- Check if this is a rare mob
		local rareMobsData = AtlasCFM.InstanceData.RareMobs
		if rareMobsData and rareMobsData.Bosses then
			for i, bossData in ipairs(rareMobsData.Bosses) do
				if bossData.name == dataID then
					-- Create navigation for rare mobs
					nav = {}
					nav.Title = bossData.name
					local numEntries = table.getn(rareMobsData.Bosses)
					if numEntries > 1 then
						-- Previous rare mob
						local prevIndex = i - 1
						if prevIndex < 1 then prevIndex = numEntries end
						local prevBoss = rareMobsData.Bosses[prevIndex]
						if prevBoss then
							nav.Prev_Page = prevBoss.name
							nav.Prev_Title = prevBoss.name
						end
						-- Next rare mob
						local nextIndex = i + 1
						if nextIndex > numEntries then nextIndex = 1 end
						local nextBoss = rareMobsData.Bosses[nextIndex]
						if nextBoss then
							nav.Next_Page = nextBoss.name
							nav.Next_Title = nextBoss.name
						end
					end
					break
				end
			end
		end

		-- If not a rare mob, use regular navigation
		if not nav then
			nav = AtlasCFM.DataResolver.GetBossNavigation(dataID)
		end

		-- If boss navigation not found, try menu navigation
		if not nav then
			nav = AtlasCFM.DataResolver.GetMenuNavigation(dataID)
		end

		-- If navigation not found and we have StoredBackMenuName, try to find navigation for it
		if not nav and AtlasCFMLootItemsFrame.StoredBackMenuName then
			local backMenuKey = AtlasCFMLootItemsFrame.StoredBackMenuName
			nav = AtlasCFM.DataResolver.GetMenuNavigation(backMenuKey)
			if nav then
				-- Add "Back" button to parent menu
				nav.Back_Page = "BackToMenu"
				nav.Back_Title = backMenuKey
			end
		end

		if nav then
			if nav.Next_Page then
				_G["AtlasCFMLootItemsFrame_NEXT"]:Show()
				_G["AtlasCFMLootItemsFrame_NEXT"].lootpage = nav.Next_Page
				_G["AtlasCFMLootItemsFrame_NEXT"].title = nav.Next_Title
			end
			if nav.Prev_Page then
				_G["AtlasCFMLootItemsFrame_PREV"]:Show()
				_G["AtlasCFMLootItemsFrame_PREV"].lootpage = nav.Prev_Page
				_G["AtlasCFMLootItemsFrame_PREV"].title = nav.Prev_Title
			end
			if nav.Back_Page then
				_G["AtlasCFMLootItemsFrame_BACK"]:Show()
				_G["AtlasCFMLootItemsFrame_BACK"].lootpage = nav.Back_Page
				_G["AtlasCFMLootItemsFrame_BACK"].title = nav.Back_Title
			end
		end
	end

	-- QuickLooks display management: hide on search/wishlist, show on regular pages
	if dataID == "SearchResult" or dataID == "WishList" then
		AtlasCFMLoot_QuickLooks:Hide()
		AtlasCFMLootQuickLooksButton:Hide()
	else
		if AtlasCFMLoot_QuickLooks then
			AtlasCFMLoot_QuickLooks:SetText(L["QuickLook"])
			AtlasCFMLoot_QuickLooks:Show()
		end
		if AtlasCFMLootQuickLooksButton then
			AtlasCFMLootQuickLooksButton:Show()
		end
	end

	-- Set the loot page name
	if dataID == "SearchResult" then
		local text = AtlasCFMCharDB and AtlasCFMCharDB.LastSearchedText or ""
		AtlasCFMLoot_LootPageName:SetText(string.format(L["Search Result: %s"], text))
	elseif dataID == "WishList" then
		AtlasCFMLoot_LootPageName:SetText(L["Wish List"])
	else
		local pageTitle = nav and nav.Title or
			(dataID and type(dataID) == "string" and dataID or (dataID and dataID.menuName))
		AtlasCFMLoot_LootPageName:SetText(pageTitle)
	end

	--Hide the container frame
	AtlasCFMLootItemsFrameContainer:Hide()

	--Show the loot frame
	AtlasCFMLootItemsFrame:Show()
	--[[     -- Load data for the current clicked element line
    local dataID = AtlasCFMLootItemsFrame.StoredElement
    local instanceKey = (AtlasCFMLootItemsFrame and type(AtlasCFMLootItemsFrame.StoredMenu) == "string") and AtlasCFMLootItemsFrame.StoredMenu or nil
    local dataSource = AtlasCFM.DataResolver.GetLootByElemName(dataID, instanceKey) or AtlasCFMLootItemsFrame.StoredMenu

    -- Special handling for wish list and search results
    if type(dataSource) == "table" and dataSource.wishlist then
        AtlasCFM.LootBrowserUI.DisplayWishList(dataSource.wishlist)
        return
    end

    if type(dataSource) == "table" and dataSource.searchResults then
        AtlasCFM.LootBrowserUI.DisplaySearchResults(dataSource.searchResults)
        return
    end

    -- Handle menu data
    if type(dataSource) == "table" and not dataSource[1] then
        AtlasCFM.LootBrowserUI.DisplayMenuData(dataSource)
        return
    end

    -- Handle regular loot data
    if type(dataSource) == "table" then
        AtlasCFM.LootBrowserUI.DisplayLootData(dataSource)
    else
        AtlasCFM.LootBrowserUI.ClearLootDisplay()
    end

    -- Show the loot frame
    AtlasCFMLootItemsFrame:Show() ]]
end

---
--- Displays wish list items in the loot frame
--- @param wishlistData table Wish list data to display
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.DisplayWishList(wishlistData)
---
function AtlasCFM.LootBrowserUI.DisplayWishList(wishlistData)
	-- Implementation for wish list display
	-- This would handle the specific formatting and display of wish list items
	AtlasCFM.LootBrowserUI.ClearLootDisplay()

	if not wishlistData or table.getn(wishlistData) == 0 then
		return
	end

	-- Ensure item buttons are visible and menu buttons hidden
	if AtlasCFM.LootBrowserUI.ShowItemButtons then
		AtlasCFM.LootBrowserUI.ShowItemButtons()
	end

	-- Update scrollbar for wish list
	local numItems = table.getn(wishlistData)

	-- Set scroll bar range
	local scrollLines = math.floor(numItems / 30) * 15 + math.min(math.mod(numItems, 30), 15)

	AtlasCFMLootScrollBar.scrollMax = math.max(0, scrollLines - 15)
	FauxScrollFrame_Update(AtlasCFMLootScrollBar, scrollLines, 15, 15)

	local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar)

	-- Display wish list items with offset
	for i = 1, AtlasCFM.LOOT_NUM_LINES do
		local itemIndex = i + offset
		if itemIndex <= numItems then
			AtlasCFM.LootBrowserUI.SetLootLine(i, wishlistData[itemIndex])
		else
			AtlasCFM.LootBrowserUI.ClearLootLine(i)
		end
	end
end

---
--- Displays search results in the loot frame
--- @param searchResults table Search results data to display
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.DisplaySearchResults(searchResults)
---
function AtlasCFM.LootBrowserUI.DisplaySearchResults(searchResults)
	-- Implementation for search results display
	AtlasCFM.LootBrowserUI.ClearLootDisplay()

	if not searchResults or table.getn(searchResults) == 0 then
		return
	end

	-- Ensure item buttons are visible and menu buttons hidden
	if AtlasCFM.LootBrowserUI.ShowItemButtons then
		AtlasCFM.LootBrowserUI.ShowItemButtons()
	end

	-- Update scrollbar for search results
	local numItems = table.getn(searchResults)

	-- Set scroll bar range
	local scrollLines = math.floor(numItems / 30) * 15 + math.min(math.mod(numItems, 30), 15)

	AtlasCFMLootScrollBar.scrollMax = math.max(0, scrollLines - 15)
	FauxScrollFrame_Update(AtlasCFMLootScrollBar, scrollLines, 15, 15)
	local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar)

	-- Display search results with offset
	for i = 1, AtlasCFM.LOOT_NUM_LINES do
		local itemIndex = i + offset
		if itemIndex <= numItems then
			AtlasCFM.LootBrowserUI.SetLootLine(i, searchResults[itemIndex])
		else
			AtlasCFM.LootBrowserUI.ClearLootLine(i)
		end
	end
end

---
--- Displays menu data in the loot frame
--- @param menuData table Menu data to display
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.DisplayMenuData(menuData)
---
function AtlasCFM.LootBrowserUI.DisplayMenuData(menuData)
	-- Implementation for menu data display
	AtlasCFM.LootBrowserUI.ClearLootDisplay()

	if not menuData then
		return
	end

	-- Ensure menu buttons are visible and item buttons hidden
	AtlasCFM.LootBrowserUI.ShowMenuButtons()

	-- Convert associative table to array for deterministic scrolling
	local entries = {}
	local count = 0
	for _, item in pairs(menuData) do
		count = count + 1
		entries[count] = item
	end

	-- Update scrollbar for menu entries
	local numItems = count

	-- Set scroll bar range
	local scrollLines = math.floor(numItems / 30) * 15 + math.min(math.mod(numItems, 30), 15)

	AtlasCFMLootScrollBar.scrollMax = math.max(0, scrollLines - 15)
	FauxScrollFrame_Update(AtlasCFMLootScrollBar, scrollLines, 15, 15)
	local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar)

	for i = 1, AtlasCFM.LOOT_NUM_LINES do
		local itemIndex = i + offset
		if itemIndex <= numItems then
			AtlasCFM.LootBrowserUI.SetMenuLine(i, entries[itemIndex])
		else
			AtlasCFM.LootBrowserUI.ClearMenuLine(i)
		end
	end
end

---
--- Displays regular loot data in the loot frame
--- @param lootData table Loot data to display
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.DisplayLootData(lootData)
---
function AtlasCFM.LootBrowserUI.DisplayLootData(lootData)
	-- Implementation for regular loot data display
	AtlasCFM.LootBrowserUI.ClearLootDisplay()

	if not lootData or table.getn(lootData) == 0 then
		return
	end

	-- Update scrollbar for loot items
	local numItems = table.getn(lootData)

	-- Set scroll bar range
	local scrollLines = math.floor(numItems / 30) * 15 + math.min(math.mod(numItems, 30), 15)

	AtlasCFMLootScrollBar.scrollMax = math.max(0, scrollLines - 15)
	FauxScrollFrame_Update(AtlasCFMLootScrollBar, scrollLines, 15, 15)

	local offset = FauxScrollFrame_GetOffset(AtlasCFMLootScrollBar)

	-- Display loot items
	for i = 1, AtlasCFM.LOOT_NUM_LINES do
		local itemIndex = i + offset
		if itemIndex <= numItems then
			AtlasCFM.LootBrowserUI.SetLootLine(i, lootData[itemIndex])
		else
			AtlasCFM.LootBrowserUI.ClearLootLine(i)
		end
	end
end

---
--- Sets the content of a specific loot line
--- @param lineIndex number Line index to set (1-based)
--- @param itemData table Item data to display
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.SetLootLine(1, itemData)
---
function AtlasCFM.LootBrowserUI.SetLootLine(lineIndex, itemData)
	if not lineIndex or not itemData then
		return
	end

	local button = _G["AtlasCFMLootItem_" .. lineIndex]
	if not button then
		return
	end

	-- Persist raw data on the button and show it
	button.itemData = itemData
	button:Show()

	-- Decide what kind of entry this is and set button fields used by handlers
	if itemData.id or itemData.itemID then
		-- Regular item entry
		AtlasCFM.LootBrowserUI.UpdateItemButton(button, itemData)
	elseif itemData.spellID then
		-- Spell entry
		button.typeID = "spell"
		button.itemID = nil
		button.elemID = itemData.spellID
		button.droprate = itemData.dropRate or itemData.droprate
		AtlasCFM.LootBrowserUI.UpdateTextButton(button, itemData)
	elseif itemData.enchantID then
		-- Enchant entry
		button.typeID = "enchant"
		button.itemID = nil
		button.elemID = itemData.enchantID
		button.droprate = itemData.dropRate or itemData.droprate
		AtlasCFM.LootBrowserUI.UpdateTextButton(button, itemData)
	else
		-- Menu/text entry
		button.typeID = 0
		button.itemID = nil
		button.elemID = nil
		button.droprate = nil
		button.container = itemData.container
		button.name = itemData.name or itemData.text
		button.name_orig = itemData.name_orig
		button.lootpage = itemData.lootpage
		button.isheader = itemData.isheader
		AtlasCFM.LootBrowserUI.UpdateTextButton(button, itemData)
	end
end

---
--- Clears the content of a specific loot line
--- @param lineIndex number Line index to clear (1-based)
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.ClearLootLine(1)
---
function AtlasCFM.LootBrowserUI.ClearLootLine(lineIndex)
	if not lineIndex then
		return
	end

	local button = _G["AtlasCFMLootItem_" .. lineIndex]
	if button then
		-- Reset data and visuals
		button.itemData = nil
		button.typeID = nil
		button.itemID = nil
		button.elemID = nil
		button.droprate = nil
		local nameFS = _G[button:GetName() .. "_Name"]
		if nameFS then nameFS:SetText("") end
		local iconTx = _G[button:GetName() .. "_Icon"]
		if iconTx then iconTx:SetTexture(nil) end
		local extraFS = _G[button:GetName() .. "_Extra"]
		if extraFS then
			extraFS:SetText(""); extraFS:Hide()
		end
		button:Hide()
	end
end

---
--- Clears all loot display lines
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.ClearLootDisplay()
---
function AtlasCFM.LootBrowserUI.ClearLootDisplay()
	for i = 1, AtlasCFM.LOOT_NUM_LINES or 30 do
		-- Clear both item and menu buttons
		AtlasCFM.LootBrowserUI.ClearLootLine(i)
		if AtlasCFM.LootBrowserUI.ClearMenuLine then
			AtlasCFM.LootBrowserUI.ClearMenuLine(i)
		end
	end
end

---
--- Updates an item button with item data
--- @param button table Button frame to update
--- @param itemData table Item data containing itemID and other properties
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.UpdateItemButton(button, itemData)
---
function AtlasCFM.LootBrowserUI.UpdateItemButton(button, itemData)
	if not button or not itemData then
		return
	end

	-- Mark type for tooltip/click handlers
	button.typeID = "item"
	button.itemID = itemData.id or itemData.itemID or 0
	button.elemID = nil
	button.droprate = itemData.dropRate or itemData.droprate

	-- Set icon (prefer provided icon, otherwise try game item icon, else a question mark)
	local iconTx = _G[button:GetName() .. "_Icon"]
	if iconTx then
		local texture = itemData.icon
		if not texture and button.itemID ~= 0 then
			local _, _, _, _, _, _, _, _, _, invTexture = GetItemInfo(button.itemID)
			texture = invTexture
		end
		iconTx:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	end

	-- Set item name with embedded color prefix so Interactions.lua can parse it
	local nameFS = _G[button:GetName() .. "_Name"]
	if nameFS then
		local itemName, _, quality = GetItemInfo(button.itemID)
		local _, _, _, hex = GetItemQualityColor(quality or 1)
		if not hex then hex = "ffffffff" end
		if itemName then
			nameFS:SetText("|c" .. hex .. itemName)
		else
			nameFS:SetText("|c" .. hex .. "Item " .. tostring(button.itemID))
		end
	end

	-- Optional extra line: drop rate or explicit extra text
	local extraFS = _G[button:GetName() .. "_Extra"]
	if extraFS then
		local extraText
		if itemData.extra then
			extraText = itemData.extra
		elseif button.droprate then
			extraText = "(" .. tostring(button.droprate) .. "%)"
		end
		if extraText then
			extraFS:SetText(extraText)
			extraFS:Show()
		else
			extraFS:SetText("")
			extraFS:Hide()
		end
	end
end

---
--- Updates a text button with text data
--- @param button table Button frame to update
--- @param textData table Text data containing text and formatting
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.UpdateTextButton(button, textData)
---
function AtlasCFM.LootBrowserUI.UpdateTextButton(button, textData)
	if not button or not textData then
		return
	end

	-- Update icon if provided, otherwise clear it
	local iconTx = _G[button:GetName() .. "_Icon"]
	if iconTx then
		if textData.icon then
			iconTx:SetTexture(textData.icon)
		else
			iconTx:SetTexture(nil)
		end
	end

	-- Update visible label
	local nameFS = _G[button:GetName() .. "_Name"]
	if nameFS then
		local label = textData.name or textData.text or ""
		nameFS:SetText(label)
	end

	-- Extra line for text entries (if any)
	local extraFS = _G[button:GetName() .. "_Extra"]
	if extraFS then
		if textData.extra then
			extraFS:SetText(textData.extra)
			extraFS:Show()
		else
			extraFS:SetText("")
			extraFS:Hide()
		end
	end
end

-- Сlear a specific menu line content and hide button
-- @function ClearMenuLine
-- @brief Clears a specific menu line in the loot browser UI.
-- @param lineIndex The index of the menu line to clear.
function AtlasCFM.LootBrowserUI.ClearMenuLine(lineIndex)
	if not lineIndex then return end
	local button = _G["AtlasCFMLootMenuItem_" .. lineIndex]
	if button then
		button.container = nil
		button.name = nil
		button.name_orig = nil
		button.lootpage = nil
		button.firstBoss = nil
		button.isheader = nil
		local nameFS = _G[button:GetName() .. "_Name"]
		if nameFS then nameFS:SetText("") end
		local iconTx = _G[button:GetName() .. "_Icon"]
		if iconTx then iconTx:SetTexture(nil) end
		local extraFS = _G[button:GetName() .. "_Extra"]
		if extraFS then
			extraFS:SetText(""); extraFS:Hide()
		end
		button:Hide()
	end
end

---
--- Prepares and displays a menu in the loot browser
--- @param menuTitle string Title of the menu
--- @param menuItems table Menu items data
--- @param prevMenuText string|nil Previous menu text for back navigation
--- @param defIcon string|nil Default icon for the menu
--- @return nil
--- @usage AtlasCFM.LootBrowserUI.PrepMenu("Dungeons", menuData)
---
function AtlasCFM.LootBrowserUI.PrepMenu(menuTitle, menuItems, prevMenuText, defIcon)
	AtlasCFMLootItemsFrame.StoredElement = { menuName = menuTitle, defaultIcon = defIcon }
	AtlasCFMLootItemsFrame.StoredMenu = menuItems
	AtlasCFMLootItemsFrame.StoredBackMenuName = prevMenuText
	AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
end

-- Show item buttons, hide menu buttons
-- @function ShowItemButtons
-- @brief Shows the item buttons in the loot browser UI.
function AtlasCFM.LootBrowserUI.ShowItemButtons()
	for i = 1, AtlasCFM.LOOT_NUM_LINES or 30 do
		local itemBtn = _G["AtlasCFMLootItem_" .. i]
		local menuBtn = _G["AtlasCFMLootMenuItem_" .. i]
		if itemBtn then itemBtn:Show() end
		if menuBtn then menuBtn:Hide() end
	end
end

-- Show menu buttons, hide item buttons
-- @function ShowMenuButtons
-- @brief Shows the menu buttons in the loot browser UI.
function AtlasCFM.LootBrowserUI.ShowMenuButtons()
	for i = 1, AtlasCFM.LOOT_NUM_LINES or 30 do
		local itemBtn = _G["AtlasCFMLootItem_" .. i]
		local menuBtn = _G["AtlasCFMLootMenuItem_" .. i]
		if itemBtn then itemBtn:Hide() end
		if menuBtn then menuBtn:Show() end
	end
end

-- Set a specific menu line using menu button template
-- @function SetMenuLine
-- @brief Sets a specific menu line in the loot browser UI using the menu button template.
-- @param lineIndex The index of the menu line to set.
-- @param itemData The data for the menu line.
-- @return nil
-- @usage AtlasCFM.LootBrowserUI.SetMenuLine(1, { name = "Dungeons", container = "Dungeons" })
--
function AtlasCFM.LootBrowserUI.SetMenuLine(lineIndex, itemData)
	if not lineIndex or not itemData then return end
	local button = _G["AtlasCFMLootMenuItem_" .. lineIndex]
	if not button then return end

	-- Persist data for click handler
	button.container = itemData.container
	button.name = itemData.name or itemData.text
	button.name_orig = itemData.name_orig
	button.lootpage = itemData.lootpage
	button.firstBoss = itemData.firstBoss
	button.isheader = itemData.isheader

	-- Reuse text button updater to apply visuals
	AtlasCFM.LootBrowserUI.UpdateTextButton(button, itemData)
end

-- OnUpdate handler for spinner animation
local function LoadingFrame_OnUpdate()
	this.animTimer = this.animTimer + arg1
	if this.animTimer >= 0.15 then
		this.animTimer = 0
		this.spinnerIndex = this.spinnerIndex + 1
		if this.spinnerIndex > 4 then
			this.spinnerIndex = 1
		end
		this.text:SetText(this.spinnerChars[this.spinnerIndex])
	end
end

---
--- Creates a loading overlay frame with spinning indicator
--- @param frameName string Frame global name
--- @param parentFrame table Parent frame
--- @param debugName string|nil Optional name for debug prints
--- @usage AtlasCFM.LootBrowserUI.CreateLoadingFrame("AtlasCFMLootScrollBarLoadingFrame", AtlasCFMLootItemsFrame)
---
function AtlasCFM.LootBrowserUI.CreateLoadingFrame(frameName, parentFrame, debugName)
	local loadingFrame = getglobal(frameName)
	if not loadingFrame then
		loadingFrame = CreateFrame("Frame", frameName, parentFrame)
		loadingFrame:SetAllPoints(parentFrame)
		loadingFrame:SetFrameLevel(parentFrame:GetFrameLevel() + 1)
		loadingFrame:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			edgeSize = 16,
			tileSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		loadingFrame:SetBackdropColor(0, 0, 0, 0.5)
		loadingFrame:SetBackdropBorderColor(1, 0.82, 0, 0.8)

		local text = loadingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		text:SetPoint("CENTER", loadingFrame, "CENTER")
		text:SetTextColor(1, 1, 0)
		text:SetText("|")
		loadingFrame.text = text

		loadingFrame.animTimer = 0
		loadingFrame.spinnerIndex = 1
		loadingFrame.spinnerChars = { "|", "/", "-", "\\" }
		loadingFrame:SetScript("OnUpdate", LoadingFrame_OnUpdate)

		setglobal(frameName, loadingFrame)
	end
	loadingFrame:Show()
	if debugName then
		PrintA("AtlasCFMLoot: show " .. debugName .. " spinner")
	end
end

---
--- Hides a loading overlay frame
--- @param frameName string Frame global name
--- @param debugName string|nil Optional name for debug prints
--- @usage AtlasCFM.LootBrowserUI.HideLoadingFrame("AtlasCFMLootScrollBarLoadingFrame")
---
function AtlasCFM.LootBrowserUI.HideLoadingFrame(frameName, debugName)
	local loadingFrame = getglobal(frameName)
	if loadingFrame then
		loadingFrame:Hide()
		if debugName then
			PrintA("AtlasCFMLoot: hide " .. debugName .. " spinner")
		end
	end
end

---
--- Convenience wrapper to show scroll bar loading overlay
--- @usage AtlasCFM.LootBrowserUI.ShowScrollBarLoading()
---
function AtlasCFM.LootBrowserUI.ShowScrollBarLoading()
	AtlasCFM.LootBrowserUI.CreateLoadingFrame("AtlasCFMLootScrollBarLoadingFrame", AtlasCFMLootItemsFrame)
end

---
--- Convenience wrapper to hide scroll bar loading overlay
--- @usage AtlasCFM.LootBrowserUI.HideScrollBarLoading()
---
function AtlasCFM.LootBrowserUI.HideScrollBarLoading()
	AtlasCFM.LootBrowserUI.HideLoadingFrame("AtlasCFMLootScrollBarLoadingFrame")
end
