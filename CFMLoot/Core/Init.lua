---
--- Initialization and event handling for AtlasCFMLoot
--- Sets up SavedVariables, options, UISpecialFrames and integrations on VARIABLES_LOADED
---

local tinsert = table.insert

---
--- Handles VARIABLES_LOADED event and initializes addon
--- Sets up character database, wish lists, UI special frames and addon integrations
--- Disables unavailable addon integration options with fallback handling
--- @return nil
--- @usage Called automatically on VARIABLES_LOADED event via AtlasCFMLootInitFrame
---
function AtlasCFMLoot_OnEvent()
	-- Ensure global/per-character saved variables are valid without overwriting
	-- any existing user settings.
	if AtlasCFM.EnsureSavedOptions then
		AtlasCFM.EnsureSavedOptions()
	end

	-- Initialize character database structure
	AtlasCFMLoot_InitializeCharacterDatabase()

	-- Initialize UI special frames and panel windows
	AtlasCFMLoot_InitializeUIFrames()

	-- Initialize addon integrations
	AtlasCFM.Integrations.Initialize()

	-- Set up options frame and validate options
	AtlasCFM.OptionsInit()
	AtlasCFM.Integrations.ValidateOptions()

	-- Apply visual options (background opacity)
	AtlasCFMLoot_ApplyVisualOptions()

	-- Set up the menu in the loot browser
	AtlasCFMLoot_HewdropRegister()

	-- Apply addon integrations based on current options
	AtlasCFM.Integrations.ApplyEquipCompareIntegration()

	if AtlasButton_LoadAtlas then
		AtlasButton_LoadAtlas()
	end
end

---
--- Initializes character database structure
--- Sets up SavedVariables tables and invalidates category caches
--- @return nil
--- @usage AtlasCFMLoot_InitializeCharacterDatabase() -- Called during initialization
---
function AtlasCFMLoot_InitializeCharacterDatabase()
	if not AtlasCFMCharDB then AtlasCFMCharDB = {} end
	if not AtlasCFMCharDB["WishList"] then AtlasCFMCharDB["WishList"] = {} end
	if not AtlasCFMCharDB["QuickLooks"] then AtlasCFMCharDB["QuickLooks"] = {} end
	if not AtlasCFMCharDB["SearchResult"] then AtlasCFMCharDB["SearchResult"] = {} end
	if not AtlasCFMCharDB["LastOpened"] then AtlasCFMCharDB["LastOpened"] = nil end -- Explicitly nil init effectively
	if not AtlasCFMCharDB["WishListSortMode"] then AtlasCFMCharDB["WishListSortMode"] = "Default" end
	if AtlasCFMCharDB["WishListSortMode"] == "Instance" then AtlasCFMCharDB["WishListSortMode"] = "Source" end

	-- Invalidate category cache after initialization
	if AtlasCFMLoot_InvalidateCategorizedList then
		AtlasCFMLoot_InvalidateCategorizedList("WishList")
		AtlasCFMLoot_InvalidateCategorizedList("SearchResult")
	end
end

---
--- Initializes UI special frames and panel windows
--- Adds frames to UISpecialFrames and sets up UIPanelWindows
--- @return nil
--- @usage AtlasCFMLoot_InitializeUIFrames() -- Called during initialization
---
function AtlasCFMLoot_InitializeUIFrames()
	-- Add the loot browser to the special frames tables to enable closing with the ESC key
	tinsert(UISpecialFrames, "AtlasCFMLootOptionsFrame")

	-- Set up panel window configuration
	UIPanelWindows['AtlasCFMLootOptionsFrame'] = { area = 'center', pushable = 0 }
end

---
--- Applies visual options based on current settings
--- Handles background opacity and other visual customizations
--- @return nil
--- @usage AtlasCFMLoot_ApplyVisualOptions() -- Called during initialization
---
function AtlasCFMLoot_ApplyVisualOptions()
	-- If using an opaque items frame, change the alpha value of the backing texture
	if AtlasCFMOptions.LootOpaque then
		AtlasCFMLootItemsFrame_Back:SetTexture(0, 0, 0, 1)
	else
		AtlasCFMLootItemsFrame_Back:SetTexture(0, 0, 0, 0.65)
	end
end

-- Create a hidden frame to bind VARIABLES_LOADED to AtlasCFMLoot_OnEvent
local AtlasCFMLootInitFrame = CreateFrame("Frame", "AtlasCFMLootInitFrame")
AtlasCFMLootInitFrame:RegisterEvent("VARIABLES_LOADED")
-- Global function call wrapper is recommended for WoW 1.12 style
AtlasCFMLootInitFrame:SetScript("OnEvent", function()
	AtlasCFMLoot_OnEvent()
end)
