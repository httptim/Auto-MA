-- ME Bridge Interface Module
-- Handles all interactions with the Applied Energistics 2 network

local me = {}
local bridge = nil
local config = nil

-- Cache for ME items (reduces lag)
local itemCache = {
    items = {},
    lastUpdate = 0,
    cacheTime = 5 -- seconds
}

-- Initialize the ME bridge connection
function me.init(cfg)
    config = cfg
    
    -- Connect to ME Bridge
    bridge = peripheral.wrap(config.meBridge)
    if not bridge then
        error("Failed to connect to ME Bridge: " .. config.meBridge)
    end
    
    -- Test connection
    local success, result = pcall(function() return bridge.listItems() end)
    if not success then
        error("ME Bridge is not responding. Check the connection: " .. tostring(result))
    end
    
    print("ME Bridge connected successfully")
    return true
end

-- Get all items in the ME system (with caching)
function me.listItems()
    local now = os.clock()
    
    -- Return cached items if still fresh
    if now - itemCache.lastUpdate < itemCache.cacheTime then
        return itemCache.items
    end
    
    -- Fetch fresh item list
    local success, items = pcall(function() return bridge.listItems() end)
    if not success then
        error("Failed to list ME items: " .. tostring(items))
    end
    
    -- Update cache
    itemCache.items = items or {}
    itemCache.lastUpdate = now
    
    return itemCache.items
end

-- Get count of specific item
function me.getItemCount(itemName)
    local items = me.listItems()
    
    for _, item in ipairs(items) do
        if item.name == itemName then
            return item.count or 0
        end
    end
    
    return 0
end

-- Check if ingredients are available for crafting
function me.checkIngredients(ingredients, quantity)
    local items = me.listItems()
    local itemCounts = {}
    
    -- Debug to file
    local debugFile = fs.open("/me-debug.txt", "w")
    debugFile.writeLine("ME Debug Log - " .. os.date())
    debugFile.writeLine("=====================================")
    debugFile.writeLine("")
    
    -- Log first 10 items to see structure
    debugFile.writeLine("First 10 ME items:")
    for i = 1, math.min(10, #items) do
        local item = items[i]
        debugFile.writeLine(string.format("Item %d:", i))
        for k, v in pairs(item) do
            debugFile.writeLine(string.format("  %s = %s (%s)", k, tostring(v), type(v)))
        end
        debugFile.writeLine("")
    end
    
    debugFile.writeLine("Total items in ME: " .. #items)
    debugFile.writeLine("")
    
    -- Build lookup table - use 'count' field (confirmed from ME Bridge data)
    for _, item in ipairs(items) do
        local quantity = item.count or 0
        itemCounts[item.name] = quantity
    end
    
    -- Log what we're checking
    debugFile.writeLine("Checking ingredients for quantity " .. quantity .. ":")
    
    -- Check each ingredient
    local missing = {}
    local canCraft = true
    
    for _, ingredient in ipairs(ingredients) do
        local required = ingredient.count * quantity
        local available = itemCounts[ingredient.name] or 0
        
        debugFile.writeLine(string.format("  Need %dx %s, have %d", 
            required, ingredient.name, available))
        
        if available < required then
            canCraft = false
            table.insert(missing, string.format("%dx %s (have %d)", 
                required - available, 
                ingredient.name:match("([^:]+)$"), -- Get item name without namespace
                available
            ))
        end
    end
    
    debugFile.writeLine("")
    debugFile.writeLine("Can craft: " .. tostring(canCraft))
    if not canCraft then
        debugFile.writeLine("Missing: " .. table.concat(missing, ", "))
    end
    
    debugFile.close()
    
    -- Print a message so user knows debug was written
    print("Debug info written to /me-debug.txt")
    
    if not canCraft then
        return false, table.concat(missing, ", ")
    end
    
    return true, nil
end

-- Export items from ME to a peripheral
function me.exportItem(itemName, count, targetPeripheral)
    if not bridge then
        error("ME Bridge not initialized")
    end
    
    -- Advanced Peripherals ME Bridge uses exportItemToPeripheral
    local item = {
        name = itemName,
        count = count
    }
    
    local success, result = pcall(function()
        return bridge.exportItemToPeripheral(item, targetPeripheral)
    end)
    
    if not success then
        error("Failed to export " .. itemName .. ": " .. tostring(result))
    end
    
    return result
end

-- Import items from a peripheral to ME
function me.importItem(itemName, count, sourcePeripheral)
    if not bridge then
        error("ME Bridge not initialized")
    end
    
    -- Advanced Peripherals ME Bridge uses importItemFromPeripheral
    local item = {
        name = itemName,
        count = count
    }
    
    local success, result = pcall(function()
        return bridge.importItemFromPeripheral(item, sourcePeripheral)
    end)
    
    if not success then
        error("Failed to import " .. itemName .. ": " .. tostring(result))
    end
    
    return result
end

-- Export all items from a list to a peripheral
function me.exportItems(itemList, targetPeripheral)
    local exported = {}
    
    for _, item in ipairs(itemList) do
        local result = me.exportItem(item.name, item.count, targetPeripheral)
        table.insert(exported, {
            name = item.name,
            count = result or item.count,
            success = result ~= nil
        })
    end
    
    return exported
end

-- Force cache refresh
function me.refreshCache()
    itemCache.lastUpdate = 0
    return me.listItems()
end

-- Get formatted item display name
function me.getItemDisplayName(itemName)
    -- Remove namespace (minecraft:, mysticalagriculture:, etc)
    local displayName = itemName:match("([^:]+)$")
    
    -- Replace underscores with spaces and capitalize
    displayName = displayName:gsub("_", " ")
    displayName = displayName:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
    
    return displayName
end

-- Check if ME system is accessible
function me.isConnected()
    if not bridge then
        return false
    end
    
    local success = pcall(function() return bridge.listItems() end)
    return success
end

return me