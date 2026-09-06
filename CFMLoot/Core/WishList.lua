---
--- WishList.lua - Wish list management system
---
--- This module provides comprehensive wish list functionality for Atlas-CFM.
--- It allows players to create, manage, and organize their desired items with
--- categorization, search capabilities, and persistent storage across sessions.
---
--- Features:
--- • Personal item wish list management
--- • Categorized item organization
--- • Search and filter capabilities
--- • Cache optimization for performance
--- • Cross-session persistence
---
--- @compatible World of Warcraft 1.12
---

local L = AtlasCFM.Localization.UI
local LS = AtlasCFM.Localization.Spells

-- Forward declaration to use function before its definition
-- (Removed local _GetInstanceKeyByName as we use AtlasCFM.LootUtils.GetInstanceKeyByName)

---
--- Displays the WishList interface and normalizes wish list data
--- @return nil
--- @usage AtlasCFMLoot_ShowWishList()
---
function AtlasCFMLoot_ShowWishList()
	-- Initialize wish list if it doesn't exist
	if not AtlasCFMCharDB.WishList then
		AtlasCFMCharDB.WishList = {}
	end

	local m = table.getn(AtlasCFMCharDB.WishList)
	for i = 1, m do
		local v = AtlasCFMCharDB.WishList[i]
		if v then
			-- Normalize instance field: if name is recorded, replace with key
			if v.instance and v.instance ~= "" then
				if not (AtlasCFM and AtlasCFM.InstanceData and AtlasCFM.InstanceData[v.instance]) then
					local k = AtlasCFM.LootUtils.GetInstanceKeyByName(v.instance)
					if k then v.instance = k end
				end
			end
			-- Normalize sourcePage: second part should be a key
			if v.sourcePage and v.sourcePage ~= "" then
				local bossName, instPart = AtlasCFM.LootUtils.Strsplit("|", v.sourcePage)
				if instPart and instPart ~= "" then
					if not (AtlasCFM and AtlasCFM.InstanceData and AtlasCFM.InstanceData[instPart]) then
						local k = AtlasCFM.LootUtils.GetInstanceKeyByName(instPart)
						if k then
							v.sourcePage = (bossName or (v.element or "")) .. "|" .. k
							if not v.instance or v.instance == "" then v.instance = k end
						end
					end
				end
			elseif v.element and v.instance and v.element ~= "" and v.instance ~= "" then
				v.sourcePage = v.element .. "|" .. v.instance
			end
		end
	end

	-- Reset scroll position
	FauxScrollFrame_SetOffset(AtlasCFMLootScrollBar, 0)
	AtlasCFMLootScrollBarScrollBar:SetValue(0)

	-- Set data for displaying wish list
	AtlasCFMLootItemsFrame.StoredElement = "WishList"
	AtlasCFMLootItemsFrame.StoredMenu = nil
	AtlasCFMLootItemsFrame.activeElement = nil

	-- Invalidate cache after possible data normalization
	AtlasCFMLoot_InvalidateCategorizedList("WishList")

	-- Request the real item IDs represented by the wish list before the
	-- first paint. Spell/enchant rows are translated through SpellDB by the
	-- centralized cache manager.
	AtlasCFM.LootBrowserUI.ShowScrollBarLoading()
	AtlasCFM.LootCache.CacheAllItems(AtlasCFMCharDB.WishList, function()
		AtlasCFM.LootBrowserUI.HideScrollBarLoading()
		AtlasCFM.LootBrowserUI.ScrollBarLootUpdate()
	end)

	-- Show sort dropdown if it exists
	if AtlasCFMLootWishListSortDropDown then
		AtlasCFMLootWishListSortDropDown:Show()
	end
end

---
--- Adds an item to the player's wish list with context information
--- @param itemID number - The item/spell/enchant ID to add
--- @param elemFromSearch string|table - Element name from search results
--- @param instKeyFromSearch string - Instance key from search results
--- @param typeFromSearch string - Type of element (item/spell/enchant)
--- @param srcFromSearch string - Source information from search
--- @return nil
--- @usage AtlasCFMLoot_AddToWishlist(12345, "Thunderfury", "MC", "item", "Bindings")
---
function AtlasCFMLoot_AddToWishlist(itemID, elemFromSearch, instKeyFromSearch, typeFromSearch, srcFromSearch)
	-- Initialize wish list if it doesn't exist
	if not AtlasCFMCharDB.WishList then
		AtlasCFMCharDB.WishList = {}
	end
	-- Determine element type and get corresponding information
	local elementType = typeFromSearch or "item"
	local name = nil
	local actualItemID = itemID

	-- If type didn't come from search, determine by databases
	if not typeFromSearch then
		if AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[itemID] then
			elementType = "spell"
			local spellData = AtlasCFM.SpellDB.craftspells[itemID]
			name = spellData.name
			actualItemID = itemID
		elseif AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[itemID] then
			elementType = "enchant"
			local enchantData = AtlasCFM.SpellDB.enchants[itemID]
			name = enchantData.name
			actualItemID = itemID
		else
			name = GetItemInfo(itemID)
			actualItemID = itemID
		end
	else
		-- Type came from search: substitute name for debugging/name search if needed
		if elementType == "spell" and AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[itemID] then
			name = AtlasCFM.SpellDB.craftspells[itemID].name
		elseif elementType == "enchant" and AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[itemID] then
			name = AtlasCFM.SpellDB.enchants[itemID].name
		else
			name = GetItemInfo(itemID)
		end
	end
	-- Take data from search result if it was passed
	local currentElement = elemFromSearch
	local currentInstanceKey = instKeyFromSearch

	-- Normalization: if element came as table (e.g., { menuName = ... })
	if type(currentElement) == "table" then
		if currentElement.menuName then
			currentElement = currentElement.menuName
		elseif currentElement.name then
			currentElement = currentElement.name
		else
			currentElement = tostring(currentElement)
		end
	end

	-- UI fallback: if context not passed but boss loot page is currently open - use it
	if (not currentElement or currentElement == "") and (not currentInstanceKey or currentInstanceKey == "") then
		if AtlasCFMLootItemsFrame and AtlasCFMLootItemsFrame.StoredElement and AtlasCFMLootItemsFrame.StoredMenu then
			currentElement = AtlasCFMLootItemsFrame.StoredElement
			currentInstanceKey = AtlasCFMLootItemsFrame.StoredMenu
		end
	end

	-- Search fallback: if context not passed but we have sourcePage (e.g. from search), try to extract it
	if (not currentElement or currentElement == "") and (not currentInstanceKey or currentInstanceKey == "") then
		if type(srcFromSearch) == "string" and srcFromSearch ~= "" then
			if string.find(srcFromSearch, "|") then
				local parts = AtlasCFM.LootUtils.Strsplit("|", srcFromSearch)
				if parts and parts[1] then
					currentElement = parts[1]
					currentInstanceKey = parts[2]
				end
			else
				-- It's just a loot page key (like craft)
				currentInstanceKey = srcFromSearch
				currentElement = AtlasCFMLoot_GetLootPageDisplayName(srcFromSearch) or srcFromSearch
			end
		end
	end

	-- If still no context, try to find it for spells/enchants
	if (not currentElement or currentElement == "") and (not currentInstanceKey or currentInstanceKey == "") then
		if (elementType == "spell" or elementType == "enchant") and actualItemID and actualItemID ~= 0 then
			local lootPage = AtlasCFM.LootUtils.FindCraftLootPageForSpell(actualItemID)
			if lootPage then
				currentInstanceKey = lootPage
				currentElement = AtlasCFMLoot_GetLootPageDisplayName(lootPage)
			end
		end
	end

	-- If nothing came from search, try to determine location and source only for items
	if (not currentElement or currentElement == "") and (not currentInstanceKey or currentInstanceKey == "") and elementType == "item" then
		if AtlasCFM.DataIndex and AtlasCFM.DataIndex.LocationCache then
			-- Use centralized index
			if not AtlasCFM.DataIndex.isIndexed and not AtlasCFM.DataIndex.isIndexing then
				AtlasCFM.DataIndex.CheckAndBuildIndex()
			end
			local locs = AtlasCFM.DataIndex.LocationCache[actualItemID]
			if locs and locs[1] then
				-- Pick first location
				local loc = locs[1]
				currentElement = loc.boss or loc.displayName
				currentInstanceKey = loc.inst or loc.page
			end
		end
	end

	-- Form record for WishList
	local record = {
		id = actualItemID,
		element = currentElement,
		instance = currentInstanceKey,
		type = elementType,
	}

	-- Form sourcePage: prioritize value from search (e.g., craft page)
	if type(srcFromSearch) == "string" and srcFromSearch ~= "" then
		record.sourcePage = srcFromSearch
	elseif currentElement and currentInstanceKey then
		record.sourcePage = currentElement .. "|" .. currentInstanceKey
		-- Don't set sourcePage if only instance key is known: such key cannot be opened directly
	end

	-- If sourcePage is not set yet and there are valid elem/inst
	if not record.sourcePage and currentElement and currentInstanceKey then
		record.sourcePage = currentElement .. "|" .. currentInstanceKey
	end

	-- Check for duplicate addition (by type+id pair)
	local isDuplicate = false
	local m = table.getn(AtlasCFMCharDB.WishList)
	for i = 1, m do
		local w = AtlasCFMCharDB.WishList[i]
		if w and w.id == actualItemID then
			local wtype = w.type or "item"
			if wtype == elementType then
				isDuplicate = true
				break
			end
		end
	end
	if isDuplicate then
		if name and name ~= "" then
			PrintA(name .. L[" already in the WishList!"])
		else
			PrintA(tostring(actualItemID) .. L[" already in the WishList!"])
		end
		return
	end

	-- Save to wish list
	table.insert(AtlasCFMCharDB.WishList, record)

	-- Chat message about addition
	if name and name ~= "" then
		PrintA(name .. L[" added to the WishList."])
	else
		PrintA(tostring(actualItemID) .. L[" added to the WishList."])
	end

	-- Invalidate category cache for wish list
	if AtlasCFMLoot_InvalidateCategorizedList then
		AtlasCFMLoot_InvalidateCategorizedList("WishList")
	end

	-- Update only if WishList page is currently open
	if AtlasCFMLootItemsFrame and AtlasCFMLootItemsFrame.storedBoss and AtlasCFMLootItemsFrame.storedBoss.name == "WishList" then
		AtlasCFMLoot_ShowWishList()
	end
end

---
--- Group items with zone/event name etc, and format them by adding subheadings and empty lines
--- This function returns a single table with all items
--- @param wishList table - The wish list to categorize (e.g., AtlasCFMCharDB.WishList)
--- @return table - Categorized list with headers and items
--- @usage local categorized = AtlasCFMLoot_CategorizeWishList(AtlasCFMCharDB.WishList)
---
function AtlasCFMLoot_CategorizeWishList(wishList)
	local result = {}

	if not wishList then return result end
	-- Use cache for WishList/SearchResult
	local cacheKey = nil
	local sortMode = "Default"
	if AtlasCFMCharDB then
		if wishList == AtlasCFMCharDB.WishList then
			cacheKey = "WishList"
			sortMode = AtlasCFMCharDB.WishListSortMode or "Default"
			if sortMode == "Instance" then sortMode = "Source" end -- Migration
		elseif wishList == AtlasCFMCharDB.SearchResult then
			cacheKey = "SearchResult"
			sortMode = "Source" -- Always sort search results by group
		end
	end
	if cacheKey and AtlasCFM and AtlasCFM._CatCache and AtlasCFM._CatRev then
		local currRev = AtlasCFM._CatRev[cacheKey] or 0
		local c = AtlasCFM._CatCache[cacheKey]
		-- Cache key for wishlist now includes sort mode
		local effectiveCacheKey = cacheKey .. (cacheKey == "WishList" and ("_" .. sortMode) or "")
		if c and c.rev == currRev and c.data and (c.mode == sortMode or (c.mode == "Instance" and sortMode == "Source")) then
			return c.data
		end
	end

	-- Create a copy to work with if we need to sort
	local listToProcess = {}
	local m = table.getn(wishList)
	for i = 1, m do
		table.insert(listToProcess, wishList[i])
	end

	-- Apply sorting if needed
	if (cacheKey == "WishList" or cacheKey == "SearchResult") and sortMode == "Source" then
		local function GetItemNameLocal(id, elementType)
			if elementType == "spell" then
				return (AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[id] and AtlasCFM.SpellDB.craftspells[id].name) or
					"Unknown Spell"
			elseif elementType == "enchant" then
				return (AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[id] and AtlasCFM.SpellDB.enchants[id].name) or
					"Unknown Enchant"
			else
				local name = GetItemInfo(id)
				return name or "Unknown Item"
			end
		end

		local function GetSourceNameLocal(v)
			local instKey = v.instance or v[3]
			local src = v.sourcePage or v[5]

			if (not instKey or instKey == "") and src and src ~= "" then
				if string.find(src, "|") then
					local b, ik = AtlasCFM.LootUtils.Strsplit("|", src)
					if type(ik) == "table" then ik = ik[1] end
					if type(ik) == "string" and ik ~= "" then
						instKey = ik
					end
				else
					instKey = src
				end
			end

			if not instKey or instKey == "" then return L["Unknown"] or "Unknown" end

			-- 1. Try InstanceData (for instances)
			if AtlasCFM and AtlasCFM.InstanceData and AtlasCFM.InstanceData[instKey] then
				return AtlasCFM.InstanceData[instKey].Name or instKey
			end

			-- 2. Try LootPageDisplayName (for professions, events, etc.)
			local displayName = AtlasCFMLoot_GetLootPageDisplayName(instKey)
			if displayName and displayName ~= instKey then
				return displayName
			end

			return instKey
		end

		table.sort(listToProcess, function(a, b)
			local instA = GetSourceNameLocal(a)
			local instB = GetSourceNameLocal(b)
			if instA ~= instB then
				return instA < instB
			end
			local nameA = GetItemNameLocal(a.id or a[1], a.type or a[4] or "item")
			local nameB = GetItemNameLocal(b.id or b[1], b.type or b[4] or "item")
			return nameA < nameB
		end)
	end

	-- Go through list and add headers when category changes
	local lastCategoryKey = nil
	local m = table.getn(listToProcess)
	for i = 1, m do
		local v = listToProcess[i]
		local currentCategory
		local extratext = ""

		-- Support both formats: dictionary (WishList) and array (SearchResult)
		local elem = (v.element ~= nil) and v.element or v[2]
		local inst = (v.instance ~= nil) and v.instance or v[3]
		local src = (v.sourcePage ~= nil) and v.sourcePage or v[5]

		-- Element type and ID for additional definitions (spells/enchants)
		local elementType = (v.type ~= nil) and v.type or v[4] or "item"
		local elemId = (v.id ~= nil) and v.id or v[1]

		-- Type normalization: accept only strings/numbers; discard other types (tables, functions, bool)
		if not (type(elem) == "string" or type(elem) == "number") then elem = nil end
		if not (type(inst) == "string" or type(inst) == "number") then inst = nil end
		if type(src) ~= "string" then src = nil end

		if sortMode == "Source" and cacheKey == "WishList" then
			-- Grouping by source
			local effectiveInst = inst

			-- If inst is completely missing, try to extract it from src
			if (not inst or inst == "") and src and src ~= "" then
				if string.find(src, "|") then
					local b, ik = AtlasCFM.LootUtils.Strsplit("|", src)
					if type(ik) == "table" then ik = ik[1] end
					if type(ik) == "string" and ik ~= "" then
						effectiveInst = ik
					end
				else
					effectiveInst = src
				end
			end

			if effectiveInst and effectiveInst ~= "" then
				-- Try InstanceData first
				if AtlasCFM and AtlasCFM.InstanceData and AtlasCFM.InstanceData[effectiveInst] and AtlasCFM.InstanceData[effectiveInst].Name then
					currentCategory = AtlasCFM.InstanceData[effectiveInst].Name
				else
					-- Fallback to loot page display name (professions, events etc)
					local displayName = AtlasCFMLoot_GetLootPageDisplayName(effectiveInst)
					currentCategory = displayName or effectiveInst
				end
			else
				currentCategory = L["Unknown"] or "Unknown"
			end
			-- Subtitle for source mode: try to get meta-category (Crafting, Factions, etc.)
			if effectiveInst and effectiveInst ~= "" then
				extratext = AtlasCFM.LootUtils.GetMetaCategoryForMenu(effectiveInst) or ""
			else
				extratext = ""
			end
		elseif sortMode == "Default" or cacheKey == "SearchResult" then
			-- Default grouping (by boss/page)
			local elemOK = (elem ~= nil and elem ~= "")
			local instOK = (inst ~= nil and inst ~= "")

			local predefinedHeaderName = nil
			local predefinedExtraText = nil

			if elemOK and instOK then
				currentCategory = AtlasCFMLoot_GetWishListSubheadingBoss(elem, inst)
			elseif src and src ~= "" then
				-- Try to extract boss|instance from sourcePage
				local b, ik = AtlasCFM.LootUtils.Strsplit("|", src)
				-- Normalization: AtlasCFM.LootUtils.Strsplit returns table of parts
				if type(b) == "table" then
					if not ik then ik = b[2] end
					b = b[1]
				end
				if type(ik) == "table" then ik = ik[1] end
				if (type(ik) == "string" or type(ik) == "number") and ik ~= "" then
					currentCategory = AtlasCFMLoot_GetWishListSubheadingBoss(b, ik)
					if not elemOK then elem = b end
					if not instOK then inst = ik end
					elemOK = (elem ~= nil and elem ~= "")
					instOK = (inst ~= nil and inst ~= "")
				else
					-- src can be loot page key (e.g., craft) - localize name by page data
					local displayName = AtlasCFMLoot_GetLootPageDisplayName(src)
					-- For craft pages, make header the short category name without profession prefix
					local headerName = displayName
					local profName = GetProfessionByLootPageKey(src)
					if displayName and profName then
						local prefix = profName .. ": "
						if string.sub(displayName, 1, string.len(prefix)) == prefix then
							headerName = string.sub(displayName, string.len(prefix) + 1)
						end
					end
					currentCategory = (headerName and headerName ~= "") and headerName or
						(displayName and displayName ~= "" and displayName or src)
					if not elemOK then elem = currentCategory end
					-- Pre-fill subtitle with profession
					predefinedExtraText = GetProfessionByLootPageKey(src) or nil
				end
			else
				-- Try to calculate header/subtitle for spells/enchants by craft page
				if (elementType == "spell" or elementType == "enchant") and elemId and elemId ~= 0 then
					local lootPage = AtlasCFM.LootUtils.FindCraftLootPageForSpell(elemId)
					if lootPage then
						local displayName = AtlasCFMLoot_GetLootPageDisplayName(lootPage)
						local headerName = displayName
						local profName = GetProfessionByLootPageKey(lootPage)
						if displayName and profName then
							local prefix = profName .. ": "
							if string.sub(displayName, 1, string.len(prefix)) == prefix then
								headerName = string.sub(displayName, string.len(prefix) + 1)
							end
						end
						predefinedHeaderName = (headerName and headerName ~= "") and headerName or
							(displayName and displayName ~= "" and displayName or lootPage)
						predefinedExtraText = profName or nil
					end
				end
				-- If couldn't calculate - use neutral header
				currentCategory = predefinedHeaderName or L["Search Result"]
			end

			-- Now that currentCategory is determined, securely prepend the profession name if needed
			local workingInst = inst
			if not workingInst or workingInst == "" then
				-- If no inst, try extracting it similarly from src
				if src and src ~= "" then
					if string.find(src, "|") then
						local b, ik = AtlasCFM.LootUtils.Strsplit("|", src)
						if type(ik) == "table" then ik = ik[1] end
						if type(ik) == "string" and ik ~= "" then
							workingInst = ik
						end
					else
						workingInst = src
					end
				end
			end
			if workingInst and workingInst ~= "" then
				local profName = GetProfessionByLootPageKey(workingInst)
				if profName and profName ~= "" then
					local prefix = profName .. ": "
					if currentCategory and string.sub(currentCategory, 1, string.len(prefix)) ~= prefix then
						currentCategory = prefix .. currentCategory
					end
					predefinedExtraText = profName
				end
			end

			-- Pre-calculate extratext for forming category key
			if instOK then
				extratext = GetLootTableParent(elem, inst) or ""
			elseif src and src ~= "" then
				local b, ik = AtlasCFM.LootUtils.Strsplit("|", src)
				-- Normalization: AtlasCFM.LootUtils.Strsplit returns table of parts
				if type(b) == "table" then
					if not ik then ik = b[2] end
					b = b[1]
				end
				if type(ik) == "table" then ik = ik[1] end
				if (type(ik) == "string" or type(ik) == "number") and ik ~= "" then
					extratext = GetLootTableParent(b, ik) or ""
				else
					-- If this is craft page or special page, use Meta-Category name
					extratext = GetLootTableParent(nil, src) or ""
				end
			end
			-- Fallback: if subtitle is empty and this is spell/enchant, try to determine Meta-Category
			if (not extratext or extratext == "") and (elementType == "spell" or elementType == "enchant") then
				if predefinedExtraText and predefinedExtraText ~= "" then
					extratext = predefinedExtraText
				elseif elementType == "enchant" then
					extratext = LS and LS["Enchanting"] or "Enchanting"
				else
					local lootPage = AtlasCFM.LootUtils.FindCraftLootPageForSpell(elemId)
					if lootPage then
						extratext = GetLootTableParent(nil, lootPage) or ""
					end
				end
			end
		end

		-- Ensure header and subheader don't duplicate each other (e.g. "Alchemy" and "Alchemy" -> "Alchemy" and "Crafting")
		if currentCategory and extratext and currentCategory == extratext then
			local pKey = src or (v and (v.sourcePage or v[5] or v[3]))
			local metaCategory = GetLootTableParent(nil, pKey)
			if metaCategory and metaCategory ~= currentCategory then
				extratext = metaCategory
			elseif GetProfessionByLootPageKey(pKey) then
				extratext = L["Crafting"]
			end
		end

		local currentCategoryKey = tostring(currentCategory or "") .. "||" .. tostring(extratext or "")

		-- Logic for header insertion (New Category or Continuation at column boundary)
		local currentCount = table.getn(result)
		local isNewCategory = (currentCategoryKey ~= lastCategoryKey)
		local isBoundary = (currentCount > 0 and math.mod(currentCount, 15) == 0)

		if isNewCategory then
			if currentCount > 0 then
				-- Check if we are at the top of a column (16, 31, ...)
				local targetIndentPos = currentCount + 1
				local isIndentAtTop = (math.mod(targetIndentPos - 1, 15) == 0)

				if isIndentAtTop then
					-- At column start, skip indent to satisfy "no indent at top"
					-- UNLESS it's Page 2+ and the cell directly above has an item
					local needsTopSpacer = false
					if targetIndentPos > 16 then
						local abovePos = targetIndentPos - 16
						local aboveCell = result[abovePos]
						if aboveCell and aboveCell[1] and aboveCell[1] ~= 0 then
							needsTopSpacer = true
						end
					end

					if needsTopSpacer then
						table.insert(result, {})
						table.insert(result, { 0, currentCategory, extratext })
					else
						-- Header itself at the top acts as a separator
						table.insert(result, { 0, currentCategory, extratext })
					end
				else
					-- Normal case: ensure header doesn't end up at bottom of column
					local targetHeaderPos = currentCount + 2
					local needsPush = (math.mod(targetHeaderPos, 15) == 0)
					local isStandardTransfer = (math.mod(targetIndentPos, 15) == 0)

					if needsPush or isStandardTransfer then
						-- Determine which boundary we are crossing
						local boundaryPos = needsPush and targetHeaderPos or targetIndentPos
						local isCol2ToCol1 = (math.mod(boundaryPos, 30) == 0)

						local numSpacers = 2
						if isCol2ToCol1 then
							-- Check if the bottom of the first column on this page has an element
							local cell15Pos = boundaryPos - 15
							local cell15 = result[cell15Pos]
							local isElementAt15 = cell15 and cell15[1] and cell15[1] ~= 0
							if isElementAt15 then
								numSpacers = 3
							end
						end

						for s = 1, numSpacers do
							table.insert(result, {})
						end
						table.insert(result, { 0, currentCategory, extratext })
					else
						-- Normal case: 1 spacer + header
						table.insert(result, {})
						table.insert(result, { 0, currentCategory, extratext })
					end
				end
			else
				-- First category header
				table.insert(result, { 0, currentCategory, extratext })
			end
			lastCategoryKey = currentCategoryKey
		elseif isBoundary then
			-- Continuation of the same category at a column boundary
			-- If Page 2+ and cell above has an item, add spacer
			local targetPos = currentCount + 1
			local needsTopSpacer = false
			if targetPos > 16 then
				local abovePos = targetPos - 16
				local aboveCell = result[abovePos]
				if aboveCell and aboveCell[1] and aboveCell[1] ~= 0 then
					needsTopSpacer = true
				end
			end

			if needsTopSpacer then
				table.insert(result, {})
			end
			table.insert(result, { 0, currentCategory, extratext })
		end

		-- Before adding item, check if we need a continuation header at column start
		-- This handles categories that span multiple columns (e.g., 15+ items)
		local countBeforeItem = table.getn(result)
		if countBeforeItem > 0 and math.mod(countBeforeItem, 15) == 0 and not isNewCategory and not isBoundary then
			-- We're at a column boundary (15, 30, 45...) and about to add an item
			-- This item would be the first in the new column
			-- Insert header to maintain context
			table.insert(result, { 0, currentCategory, extratext })
		end

		-- Add item considering element type
		local displayItem = { (v.id ~= nil) and v.id or v[1], elem, inst, elementType }
		-- Pass through 5th element (sourcePage) only if it's a string
		local src2 = nil
		if type(v.sourcePage) == "string" then
			src2 = v.sourcePage
		elseif type(v[5]) == "string" then
			src2 = v[5]
		end
		-- Fallback: for spells/enchants, if sourcePage is missing, determine craft page
		if not src2 and (elementType == "spell" or elementType == "enchant") then
			local eid = (v.id ~= nil) and v.id or v[1]
			if eid and eid ~= 0 then
				local lp = AtlasCFM.LootUtils.FindCraftLootPageForSpell(eid)
				if lp then
					src2 = lp
				end
			end
		end
		if src2 then
			displayItem[5] = src2
		end
		table.insert(result, displayItem)
	end

	--collectgarbage()
	-- Save result to cache
	if cacheKey then
		if not AtlasCFM._CatCache then AtlasCFM._CatCache = {} end
		if not AtlasCFM._CatRev then AtlasCFM._CatRev = {} end
		AtlasCFM._CatCache[cacheKey] = { data = result, rev = AtlasCFM._CatRev[cacheKey] or 0, mode = sortMode }
	end
	return result
end

---
--- Gets the subheading for wish list boss entries
--- @param bossName string - The boss name
--- @param instanceName string - The instance name
--- @return string - The formatted subheading
--- @usage local heading = AtlasCFMLoot_GetWishListSubheadingBoss("Nefarian", "BWL")
---
function AtlasCFMLoot_GetWishListSubheadingBoss(bossName, instanceName)
	-- Return boss or page name as header
	if bossName and bossName ~= "" then
		return bossName
	end

	-- If no boss name, return instance name
	if instanceName and instanceName ~= "" then
		if AtlasCFM and AtlasCFM.InstanceData and AtlasCFM.InstanceData[instanceName] and AtlasCFM.InstanceData[instanceName].Name then
			return AtlasCFM.InstanceData[instanceName].Name
		end

		local displayName = AtlasCFMLoot_GetLootPageDisplayName(instanceName)
		if displayName and displayName ~= instanceName then
			return displayName
		end

		return instanceName
	end

	-- Return "Unknown" if nothing found
	return L["Unknown"] or "Unknown"
end

---
--- Removes an element from the wish list by its ID
--- @param elemID number - The ID of the element to remove
--- @return nil
--- @usage AtlasCFMLoot_DeleteFromWishList(12345)
---
function AtlasCFMLoot_DeleteFromWishList(elemID)
	-- Removes element by its ID from wish list (supports both record formats)
	if not elemID then return end
	if not AtlasCFMCharDB or not AtlasCFMCharDB.WishList then return end

	local removed = false
	local removedName = nil
	local removedType = nil
	local newList = {}
	local m = table.getn(AtlasCFMCharDB.WishList)
	for i = 1, m do
		local v = AtlasCFMCharDB.WishList[i]
		if v then
			local vId = v.id or v[1]
			if vId ~= elemID then
				table.insert(newList, v)
			else
				removed = true
				removedType = v.type or v[4] or "item"
				-- Get name before deletion
				if removedType == "spell" then
					if AtlasCFM.SpellDB and AtlasCFM.SpellDB.craftspells and AtlasCFM.SpellDB.craftspells[vId] then
						removedName = AtlasCFM.SpellDB.craftspells[vId].name
					end
				elseif removedType == "enchant" then
					if AtlasCFM.SpellDB and AtlasCFM.SpellDB.enchants and AtlasCFM.SpellDB.enchants[vId] then
						removedName = AtlasCFM.SpellDB.enchants[vId].name
					end
				else
					removedName = GetItemInfo(vId)
				end
			end
		end
	end
	AtlasCFMCharDB.WishList = newList

	if removed then
		if removedName and removedName ~= "" then
			PrintA(removedName .. L[" deleted from the WishList."])
		else
			PrintA(tostring(elemID) .. L[" deleted from the WishList."])
		end
	else
		PrintA(tostring(elemID) .. L[" not found in the WishList."])
	end

	-- Update display
	AtlasCFMLoot_InvalidateCategorizedList("WishList")
	AtlasCFMLoot_ShowWishList()
end
