# Atlas‑CFM — Documentation (WoW 1.12)

Overview: Atlas‑CFM is a dungeon map browser with an integrated loot panel and quests module. It is compatible with World of Warcraft 1.12 and includes localization support.

![main](https://github.com/user-attachments/assets/fb4b69fc-158c-4f55-a0dd-bfd0a7967170)


1) Compatibility and Requirements
- Client: WoW 1.12 (Interface: 11200)
- Addon folder: Interface\AddOns\Atlas-CFM
- Saved variables:
  - Account-wide: AtlasCFMOptions
  - Per-character: AtlasCFMCharDB
- Optional dependencies (detected if installed): EquipCompare, EQCompare, pfQuest, pfUI

2) Installation
- Copy the Atlas‑CFM folder to Interface\AddOns
- Enable the addon on the character selection screen

3) Quick Start and Controls
- Open/Close Atlas‑CFM: /atlas
- Open options: /atlas options (or /atlas opt)
- Minimap button (if enabled):
  - Left-click — open Atlas‑CFM
  - Middle-click — open Atlas‑CFM options
  - Right-click + drag — move the button
- The AtlasCFM window can be dragged when unlocked (lock button on the frame)
- Right-click on the AtlasCFM window (if enabled) — close AtlasCFM and open the World Map

- **World Map Markers**:
  - Icons for Dungeons, Raids, World Bosses, and Transport routes (Zeppelins, Boats, Tram) directly on the World Map.
  - Interactive tooltips showing level ranges and destinations.
  - Clicking a marker automatically opens the corresponding map in Atlas‑CFM.
- **Profession & Crafting Integration**:
  - Comprehensive catalogs for all professions and world events.
  - Automatic detection of player professions and recipe knowledge (Known/Unknown).
  - Filtering of loot and recipes based on your character's professions.
  - Reagent requirements and crafting information displayed in item tooltips.
- **Enhanced Item Tooltips**:
  - Displays loot sources, drop rates, and boss names.
  - Integrated recipe information (reagents, skill required).
  - Support for comparison addons (EquipCompare, EQCompare).
- **Server Specialization**: Switch the target server (e.g., TurtleWoW, Vanilla+) to adapt loot tables, quest data, and display server-specific markers.
- **Wishlist System**: Save desired items to a personal wishlist for quick tracking.
- **pfQuest Integration**:
  - Right-click on an item to search for it in the pfQuest database.
  - Search quest starters and rewards directly from the Atlas interface.
- Optional: cursor coordinates overlay on the default World Map.

5) Window and UI Elements
- Main frame: AtlasCFMFrame
- Drop-downs:
  - Map Type (category)
  - Instance selection
- Top buttons:
  - Lock/Unlock — toggle window movement
  - Options — open Atlas‑TW options
  - Quests — show/hide quests panel
  - Loot Panel — show/hide bottom loot panel
- Loot panel: section buttons and items area with scrolling
- Quests panel: quest counter, quest entries, faction buttons, "Story" button

6) Options (highlights)
- Show Button on Minimap — show the minimap button
- Auto‑Select Instance Map — auto-select instance map by current zone
- Right‑Click for World Map — right-click closes Atlas and opens the World Map
- Show Acronyms — show instance acronyms
- Clamp window to screen — keep the window within the screen
- **Server Selection** — Change the target server specialization for data and markers.
- **Show Map Markers** — Toggle icons for dungeons and transport on the World Map.
- **Profession Filters** — Filter tooltip info based on chosen professions.
- Show cursor coordinates on World Map — toggle AtlasCFMOptions.AtlasCursorCoords

7) Commands
- /atlascfm — toggle Atlas‑CFM window
- /atlascfm options (or /atlascfm opt) — open options
- /atlascfm ver — print your local Atlas‑CFM version to chat
- /atlascfm ver check — immediately publish your version to LFT and print confirmation

8) First Run
- On the first run, a setup prompt may be shown once
- AtlasCFMCharDB.FirstTime controls only the per-character one-time greeting behavior
- Account-wide AtlasCFMOptions are migrated non-destructively: missing settings receive defaults, while existing choices are preserved

9) FAQ
- The window is invisible
  - Check Scale/Transparency in options
  - Type /atlascfm
- Minimap button is missing
  - Enable "Show Button on Minimap" in options
- Right‑click opens the World Map
  - Disable "Right‑Click for World Map"
- No quests for the instance
  - Check your faction (Alliance/Horde)
  - Some instances may have no quests

10) Tips
- Auto‑select is handy when farming: the correct map opens automatically when you enter an instance
- For item comparison, enable the appropriate tooltip integration (EquipCompare)
- Hide the loot panel temporarily to save space inside the Atlas window

11) Localization
- Atlas-CFM uses a modular localization system based on namespaces
- Structure:
  - `Locales/LocalizationFramework.lua` — Core localization system
  - `Locales/[locale]/` — Language-specific files (enUS, deDE, esES, ptBR, zhCN)
  - Each locale has 9 modules: Core, Zones, Bosses, Classes, Factions, Spells, ItemSets, MapData, QuestData
- Automatic fallback to English for missing translations
- To add/update translations: edit the corresponding file in `Locales/[locale]/`

12) Technical Details
- No external Babble libraries required (replaced by modular system)
- All localization data is loaded via `Locales/locales.xml`

Feedback
- Report bugs and requests: which maps/quests/rewards are incorrect, your client language, and client version