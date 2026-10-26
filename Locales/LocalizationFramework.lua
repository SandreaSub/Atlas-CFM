---
--- LocalizationFramework.lua - Core Localization System
---
--- Simplified and robust localization system.
---

local _G = getfenv()

AtlasCFM = _G.AtlasCFM or {}

if not AtlasCFM.Localization then
    AtlasCFM.Localization = {
        currentLocale = "enUS",
        namespaces = {}
    }
end

---
--- Debug function to check loaded translations
---
function AtlasCFM.Localization:DebugPrint()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00AtlasCFM Localization Debug:|r")
    DEFAULT_CHAT_FRAME:AddMessage("Current Locale: " .. tostring(self.currentLocale))

    for name, data in pairs(self.namespaces) do
        local enCount = 0
        local curCount = 0
        if data.enUS then
            for _ in pairs(data.enUS) do enCount = enCount + 1 end
        end
        if data.current then
            for _ in pairs(data.current) do curCount = curCount + 1 end
        end
        DEFAULT_CHAT_FRAME:AddMessage(string.format("  - %s: enUS=%d, current=%d", name, enCount, curCount))
    end
end

function AtlasCFM.Localization:DebugMissing(limit)
    local frame = DEFAULT_CHAT_FRAME
    local out = function(msg) if frame then frame:AddMessage(msg) else PrintA(msg) end end
    limit = tonumber(limit) or 40
    out("|cff00ff00AtlasCFM Missing Keys:|r " .. tostring(self.currentLocale))
    for name, ns in pairs(self.namespaces) do
        local missing = {}
        local en = ns.enUS or {}
        local cur = ns.current or {}
        for k, _ in pairs(en) do
            if cur[k] == nil then table.insert(missing, k) end
        end
        out("  " .. name .. ": missing=" .. tostring(table.getn(missing)))
        if table.getn(missing) > 0 then
            local list = {}
            local n = math.min(limit, table.getn(missing))
            for i = 1, n do list[i] = missing[i] end
            out("    " .. table.concat(list, ", "))
        end
    end
end

---
--- Register a new localization namespace
---
function AtlasCFM.Localization:RegisterNamespace(namespace, locale, translations)
    if locale ~= "enUS" then return end
    if not self.namespaces[namespace] then
        local english = {}
        self.namespaces[namespace] = {
            enUS = english,
            current = english
        }
    end

    local ns = self.namespaces[namespace]

    -- Keep one English table; both fields alias it for existing consumers.
    for k, v in pairs(translations) do
        ns.enUS[k] = v
    end
end

---
--- Get a namespace for use
---
function AtlasCFM.Localization:GetNamespace(namespace)
    if not self.namespaces[namespace] then
        -- Initialize if accessed before registration
        self:RegisterNamespace(namespace, "enUS", {})
    end

    local t = {}
    local ns_data = self.namespaces[namespace]

    setmetatable(t, {
        __index = function(tab, key)
            -- 1. Try current locale
            local val = ns_data.current[key]
            if val then
                if val == true then return key end
                return val
            end

            -- 2. Try enUS fallback
            val = ns_data.enUS[key]
            if val then
                if val == true then return key end
                return val
            end

            -- 3. Return key (fallback)
            return key
        end
    })

    return t
end

-- Define standard namespaces
AtlasCFM.Localization.UI = AtlasCFM.Localization:GetNamespace("UI")
AtlasCFM.Localization.Zones = AtlasCFM.Localization:GetNamespace("Zones")
AtlasCFM.Localization.Bosses = AtlasCFM.Localization:GetNamespace("Bosses")
AtlasCFM.Localization.Classes = AtlasCFM.Localization:GetNamespace("Classes")
AtlasCFM.Localization.Factions = AtlasCFM.Localization:GetNamespace("Factions")
AtlasCFM.Localization.Spells = AtlasCFM.Localization:GetNamespace("Spells")
AtlasCFM.Localization.ItemSets = AtlasCFM.Localization:GetNamespace("ItemSets")
AtlasCFM.Localization.MapData = AtlasCFM.Localization:GetNamespace("MapData")
