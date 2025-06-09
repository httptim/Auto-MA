-- Altar Control Module
-- Manages infusion altar, pedestals, and crafting process

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
    craftStarted = false  -- Track if altar consumed items
}

-- Initialize altar system
function altar.init(cfg, meModule)
    config = cfg
    me = meModule -- Use the already initialized ME module
    
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
    
    -- No redstone integrator needed - using always-on redstone block
    
    print("Altar system initialized with " .. #pedestals .. " pedestals")
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
end

-- Distribute ingredients to pedestals
local function distributeIngredients(ingredients)
    -- MysticalAgriculture standard pattern:
    -- - Seed base goes in the altar (center)
    -- - Other ingredients distributed to pedestals
    -- - Common pattern: 4 material + 4 essence = 8 pedestals
    
    local distributed = {}
    local pedestalIngredients = {}
    local seedBase = nil
    
    -- Separate crafting seed from pedestal ingredients
    for _, ingredient in ipairs(ingredients) do
        -- Check for any tier crafting seed (tier1 through tier5)
        if ingredient.name:find("tier%d_crafting_seed") or 
           ingredient.name:find("crafting_seed") or 
           ingredient.name:find("seed_base") then
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
            error("Not enough pedestals for all ingredients! Need " .. pedestalIndex + remaining - 1)
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
    
    -- For multiple quantities, we'll craft them one at a time
    -- (Infusion altar only makes 1 seed at a time)
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
    print("Starting craft for: " .. seed.name)
    
    -- Calculate ingredients for one craft
    local ingredients = {}
    for _, ing in ipairs(seed.ingredients) do
        table.insert(ingredients, {
            name = ing.name,
            count = ing.count -- For 1 seed
        })
    end
    
    -- Distribute ingredients to pedestals
    local distributed, seedBase = distributeIngredients(ingredients)
    
    print("Distributed " .. #distributed .. " items to pedestals")
    
    -- Place seed base in altar if present
    if seedBase then
        print("Placing seed base in altar: " .. seedBase.name)
        local success = me.exportItem(seedBase.name, seedBase.count, config.altar)
        if not success then
            error("Failed to place seed base in altar")
        end
    end
    
    -- Altar should start automatically with redstone block
    craftState.craftStartTime = os.clock()
    print("Items placed, altar should start crafting")
    -- Note: Removed sleep to avoid blocking event loop
end

-- Check if current craft is complete
function altar.checkComplete()
    if not craftState.active then
        return false
    end
    
    -- Assume craft starts after a short delay with redstone block
    -- (Since we can't reliably detect when altar consumes items)
    if not craftState.craftStarted then
        local elapsed = os.clock() - craftState.craftStartTime
        if elapsed > 2 then  -- After 2 seconds, assume craft started
            craftState.craftStarted = true
            print("Assuming craft started after 2 second delay")
        end
    end
    
    -- Check altar for any output (anything other than base seed)
    local altarItems = altarInv.list()
    
    -- Look for any item that's not the prosperity seed base
    for slot, item in pairs(altarItems) do
        -- If we find any item that's not the base seed, it's the output
        if item.name ~= "mysticalagriculture:prosperity_seed_base" then
            -- Found output! Import to ME
            print("Craft complete! Found output: " .. item.name)
            me.importItem(item.name, item.count, config.altar)
            
            -- Check if we need more crafts
            if craftState.currentCraft < craftState.quantity then
                craftState.currentCraft = craftState.currentCraft + 1
                craftState.craftStarted = false  -- Reset for next craft
                altar.startSingleCraft(craftState.seed)
                return false -- Still crafting more
            else
                -- All done!
                craftState.active = false
                altar.cleanup() -- Clean up any remaining items
                return true
            end
        end
    end
    
    -- Check for timeout
    local elapsed = os.clock() - craftState.craftStartTime
    local timeout = config.settings and config.settings.craftTimeout or 30
    
    -- If craft hasn't started yet, don't timeout as quickly
    if not craftState.craftStarted and elapsed < 10 then
        return false
    end
    
    if elapsed > timeout then
        error("Craft timeout - no output detected")
    end
    
    return false
end

-- Get current craft progress (0-1)
function altar.getProgress()
    if not craftState.active then
        return 0
    end
    
    local elapsed = os.clock() - craftState.craftStartTime
    local expectedTime = craftState.seed.time or 20
    
    -- If craft hasn't started yet, show minimal progress
    if not craftState.craftStarted then
        return (craftState.currentCraft - 1) / craftState.quantity + (0.1 / craftState.quantity)
    end
    
    -- Add progress for completed crafts
    local baseProgress = (craftState.currentCraft - 1) / craftState.quantity
    local currentProgress = math.min(1, elapsed / expectedTime) / craftState.quantity
    
    return baseProgress + currentProgress
end

-- Get craft status
function altar.getStatus()
    if not craftState.active then
        return "idle"
    end
    
    return string.format("Crafting %s (%d/%d)", 
        craftState.seed.name,
        craftState.currentCraft,
        craftState.quantity
    )
end

-- Force stop current craft
function altar.cancel()
    if craftState.active then
        altar.cleanup()
        craftState.active = false
    end
end

-- Test altar connectivity
function altar.test()
    print("Testing altar system...")
    
    -- No redstone test needed - using always-on redstone block
    print("Using always-on redstone block - no test needed")
    
    -- Test pedestals
    print("Found " .. #pedestals .. " pedestals")
    for i, pedestal in ipairs(pedestals) do
        local size = pedestal.size()
        print("  Pedestal " .. i .. ": " .. size .. " slots")
    end
    
    -- Test altar
    local altarSize = altarInv.size()
    print("Altar has " .. altarSize .. " slots")
    
    return true
end

return altar