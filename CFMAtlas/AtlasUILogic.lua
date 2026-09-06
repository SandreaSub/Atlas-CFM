---
--- AtlasUILogic.lua - Atlas UI logic and minimap button functionality
---
--- This file contains UI logic functions for Atlas-CFM including minimap button
--- management, position handling, and UI interaction logic. It provides the
--- core functionality for Atlas UI components and user interface behavior.
---
--- Features:
--- - Minimap button initialization and positioning
--- - UI state management and updates
--- - Button interaction handling
--- - Position calculation and storage
---
--- @compatible World of Warcraft 1.12
---

local _G = getfenv()
AtlasCFM = _G.AtlasCFM or {}

local L = AtlasCFM.Localization.UI

-- Minimap button logic
---
--- Sets the minimap button position
--- Updates the button position angle and refreshes the display
--- @param v number Position angle in degrees
--- @return nil
--- @usage AtlasCFMButtonSetPosition(45) -- Set button to 45 degrees
---
local function AtlasCFMButtonSetPosition(v)
	if v < 0 then
		v = v + 360
	end
	AtlasCFMOptions.AtlasButtonPosition = v
	AtlasCFM.MinimapButtonUpdatePosition()
end

---
--- Initializes the minimap button
--- Shows or hides the button based on settings and updates position
--- @return nil
--- @usage AtlasCFM.MinimapButtonInit() -- Called during addon initialization
---
function AtlasCFM.MinimapButtonInit()
	if AtlasCFMOptions.AtlasButtonShown then
		AtlasCFMButtonFrame:Show()
	else
		AtlasCFMButtonFrame:Hide()
	end
	AtlasCFM.MinimapButtonUpdatePosition()
end

---
--- Toggles minimap button visibility
--- Shows or hides the minimap button and saves the setting
--- @return nil
--- @usage AtlasCFM.MinimapButtonOnClick() -- Called by button click
---
function AtlasCFM.MinimapButtonOnClick()
	if AtlasCFMButtonFrame:IsVisible() then
		AtlasCFMButtonFrame:Hide()
		AtlasCFMOptions.AtlasButtonShown = false
	else
		AtlasCFMButtonFrame:Show()
		AtlasCFMOptions.AtlasButtonShown = true
	end
	AtlasCFM.OptionsInit()
end

---
--- Updates the minimap button position
--- Calculates and sets the button position based on radius and angle
--- @return nil
--- @usage AtlasCFM.MinimapButtonUpdatePosition() -- Called when position changes
---
function AtlasCFM.MinimapButtonUpdatePosition()
	local radius = AtlasCFMOptions.AtlasButtonRadius
	local position = AtlasCFMOptions.AtlasButtonPosition
	AtlasCFMButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (radius * cos(position)),
		(radius * sin(position)) - 55
	)
	AtlasCFM.OptionsInit()
end

-- Handles minimap button dragging
---
--- Handles minimap button dragging
--- Updates button position while being dragged around the minimap
--- @return nil
--- @usage AtlasCFM.MinimapButtonBeingDragged() -- Called during drag events
---
function AtlasCFM.MinimapButtonBeingDragged()
	local xpos, ypos = GetCursorPosition()
	local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
	local scale = UIParent:GetScale()
	xpos = xmin - xpos / scale + 70
	ypos = ypos / scale - ymin - 70
	AtlasCFMButtonSetPosition(math.deg(math.atan2(ypos, xpos)))
end

-- Minimap button OnEnter handler
---
--- Handles mouse enter events for minimap button
--- Shows tooltip with Atlas information when hovering over button
--- @return nil
--- @usage AtlasCFM.MinimapButtonOnEnter() -- Called on mouse enter
---
function AtlasCFM.MinimapButtonOnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT")
	GameTooltip:SetText(AtlasCFM.Name)
	GameTooltip:AddLine(
		L["Left-click to open Atlas-CFM.\nMiddle-click for Atlas-CFM options.\nRight-click and drag to move this button."],
		1,
		1, 1, true)
	GameTooltip:Show()
end

-- AtlasCFM logic
--Sets the transparency of the Atlas frame based on AtlasAlpha
---
--- Updates the Atlas frame transparency
--- Sets the frame alpha based on current option settings
--- @return nil
--- @usage AtlasCFM.OptionsUpdateAlpha() -- Called when alpha setting changes
---
function AtlasCFM.OptionsUpdateAlpha()
	AtlasCFMFrame:SetAlpha(AtlasCFMOptions.AtlasAlpha)
end

--Sets the scale of the Atlas frame based on AtlasScale
---
--- Updates the Atlas frame scale
--- Sets the frame scale based on current option settings
--- @return nil
--- @usage AtlasCFM.OptionsUpdateScale() -- Called when scale setting changes
---
function AtlasCFM.OptionsUpdateScale()
	AtlasCFMFrame:SetScale(AtlasCFMOptions.AtlasScale)
end

--Simple function to toggle the visibility of the Atlas frame
---
--- Toggles the Atlas frame visibility
--- Shows or hides the main Atlas frame
--- @return nil
--- @usage AtlasCFM.ToggleAtlas() -- Called by slash command or button
---
function AtlasCFM.ToggleAtlas()
	if AtlasCFMFrame:IsVisible() then
		AtlasCFMFrame:Hide()
	else
		AtlasCFMFrame:Show()
	end
end

--Parses slash commands
--If an unrecognized command is given, toggle Atlas
---
--- Handles Atlas slash commands
--- Processes slash command arguments and executes appropriate actions
--- @param msg string Command arguments from slash command
--- @return nil
--- @usage AtlasCFM.SlashCommand("toggle") -- Process slash command
---
---
function AtlasCFM.SlashCommand(msg)
	msg = string.lower(msg or '')
	if msg == "options" or msg == "opt" then
		AtlasCFM.OptionsOnClick()
	elseif msg == 'ver' then
		PrintA(format(L["Version: %s"], AtlasCFM.Version or GetAddOnMetadata(AtlasCFM.Name, "Version")))
	else
		AtlasCFM.ToggleAtlas()
	end
end

--Begin moving the Atlas frame if it's unlocked
---
--- Starts moving the Atlas frame
--- Initiates frame dragging if not locked
--- @return nil
--- @usage AtlasCFM.StartMoving() -- Called on drag start
---
function AtlasCFM.StartMoving()
	if not AtlasCFMOptions.AtlasLocked then
		AtlasCFMFrame:StartMoving()
		AtlasCFMFrame.isMoving = true
	end
end

--RightButton closes Atlas and open the World Map if the RightClick option is turned on
---
--- Handles Atlas frame click events
--- Processes mouse clicks on the Atlas frame
--- @return nil
--- @usage AtlasCFM.OnClick() -- Called on frame click
---
function AtlasCFM.OnClick()
	if arg1 == "RightButton" then
		if AtlasCFMOptions.AtlasRightClick then
			AtlasCFM.ToggleAtlas()
			ToggleWorldMap()
		end
	end
end
