-- Altar Control Module - Rewritten
-- Clean implementation with proper progress tracking

local altar = {}
local config = nil
local me = nil

-- Peripheral references
local altarInv = nil
local pedestals = {}

-- Current craft state
local craftState = {
    active = false,
    seed = nil,
    quantity = 0,
    startTime = 0,
    currentCraft = 1,
    craftStartTime = 0,
    craftStarted = false
}

-- Initialize altar system
function altar.init(cfg, meModule)
    config = cfg
    me = meModule
    
    -- Connect to altar
    altarInv = peripheral.wrap(config.altar)
    if not altarInv then
        error("Failed to connect to altar: " .. config.altar)
    end
    
    -- Connect to pedestals
    for i, pedestalName in ipairs(config.pedestals) do
        local pedestal = peripheral.wrap(pedestalName)
        if not pedestal then
            error("Failed to connect to pedestal " .. i .. ": " .. pedestalName)
        end
        pedestals[i] = pedestal
    end
    
    return true
end

-- Clear all items from pedestals and altar
function altar.cleanup()
    -- Pull items from pedestals back to ME
    for i, pedestal in ipairs(pedestals) do
        local items = pedestal.list()
        for slot, item in pairs(items) do
            me.importItem(item.name, item.count, config.pedestals[i])
        end
    end
    
    -- Pull items from altar
    local altarItems = altarInv.list()
    for slot, item in pairs(altarItems) do
        me.importItem(item.name, item.count, config.altar)
    end
    
    craftState.active = false
    craftState.craftStarted = false
end

-- Distribute ingredients to pedestals
local function distributeIngredients(ingredients)
    local distributed = {}
    local pedestalIngredients = {}
    local seedBase = nil
    
    -- Separate crafting seed from pedestal ingredients
    for _, ingredient in ipairs(ingredients) do
        if ingredient.name:find("seed_base") then
            seedBase = ingredient
        else
            table.insert(pedestalIngredients, ingredient)
        end
    end
    
    -- Distribute non-base ingredients to pedestals
    local pedestalIndex = 1
    
    for _, ingredient in ipairs(pedestalIngredients) do
        local remaining = ingredient.count
        
        -- Distribute this ingredient across pedestals
        while remaining > 0 and pedestalIndex <= 8 do
            local toPlace = 1 -- Always 1 per pedestal for MysticalAgriculture
            
            -- Export to pedestal
            local success = me.exportItem(ingredient.name, toPlace, config.pedestals[pedestalIndex])
            if not success then
                error("Failed to export " .. ingredient.name .. " to pedestal " .. pedestalIndex)
            end
            
            table.insert(distributed, {
                pedestal = pedestalIndex,
                item = ingredient.name,
                count = toPlace
            })
            
            remaining = remaining - toPlace
            pedestalIndex = pedestalIndex + 1
        end
        
        if remaining > 0 then
            error("Not enough pedestals for all ingredients!")
        end
    end
    
    return distributed, seedBase
end

-- Start crafting process
function altar.startCraft(seed, quantity)
    if craftState.active then
        error("Craft already in progress")
    end
    
    -- Clean up any leftover items first
    altar.cleanup()
    
    -- Set craft state
    craftState.active = true
    craftState.seed = seed
    craftState.quantity = quantity
    craftState.currentCraft = 1
    craftState.startTime = os.clock()
    craftState.craftStarted = false
    
    -- Start first craft
    altar.startSingleCraft(seed)
end

-- Start a single craft iteration
function altar.startSingleCraft(seed)
    
    -- Calculate ingredients for one craft
    local ingredients = {}
    for _, ing in ipairs(seed.ingredients) do
        table.insert(ingredients, {
            name = ing.name,
            count = ing.count
        })
    end
    
    -- Distribute ingredients to pedestals
    local distributed, seedBase = distributeIngredients(ingredients)
    
    -- Items distributed to pedestals
    
    -- Place seed base in altar
    if seedBase then
        local success = me.exportItem(seedBase.name, seedBase.count, config.altar)
        if not success then
            error("Failed to place seed base in altar")
        end
    end
    
    -- Mark craft start time
    craftState.craftStartTime = os.clock()
end

-- Check if current craft is complete
function altar.checkComplete()
    if not craftState.active then
        return false
    end
    
    -- Wait a bit before checking (altar needs time to consume items)
    local elapsed = os.clock() - craftState.craftStartTime
    if elapsed < 1 then  -- Reduced from 2 to 1 second
        return false
    end
    
    -- Mark craft as started after 1 second
    if not craftState.craftStarted and elapsed >= 1 then
        craftState.craftStarted = true
    end
    
    -- Check altar for output
    local altarItems = altarInv.list()
    
    for slot, item in pairs(altarItems) do
        -- Any item that's not the seed base is output
        if item.name ~= "mysticalagriculture:prosperity_seed_base" then
            -- Found output!
            me.importItem(item.name, item.count, config.altar)
            
            -- Check if we need more crafts
            if craftState.currentCraft < craftState.quantity then
                craftState.currentCraft = craftState.currentCraft + 1
                craftState.craftStarted = false
                altar.startSingleCraft(craftState.seed)
                return false -- Still crafting more
            else
                -- All done!
                craftState.active = false
                altar.cleanup()
                return true
            end
        end
    end
    
    -- Check for timeout
    if elapsed > 30 then
        error("Craft timeout - no output detected after 30 seconds")
    end
    
    return false
end

-- Get current craft progress (0-1)
function altar.getProgress()
    if not craftState.active then
        return 0
    end
    
    local elapsed = os.clock() - craftState.craftStartTime
    -- Ignore seed time, use realistic altar craft time (about 5-7 seconds)
    local expectedTime = 6
    
    -- Base progress from completed crafts
    local baseProgress = (craftState.currentCraft - 1) / craftState.quantity
    
    -- Current craft progress
    local currentProgress = 0
    if craftState.craftStarted then
        -- After craft starts, show actual progress
        currentProgress = math.min(1, elapsed / expectedTime) / craftState.quantity
    else
        -- Before craft starts, show quick initial progress
        currentProgress = math.min(0.15, elapsed) / craftState.quantity
    end
    
    return baseProgress + currentProgress
end

-- Get craft status
function altar.getStatus()
    if not craftState.active then
        return "Idle"
    end
    
    local elapsed = os.clock() - craftState.craftStartTime
    
    if not craftState.craftStarted then
        return string.format("Preparing craft %d/%d...", craftState.currentCraft, craftState.quantity)
    else
        return string.format("Crafting %s (%d/%d) - %.1fs", 
            craftState.seed.name,
            craftState.currentCraft,
            craftState.quantity,
            elapsed
        )
    end
end

-- Cancel current craft
function altar.cancel()
    if craftState.active then
        altar.cleanup()
        craftState.active = false
    end
end

return altar