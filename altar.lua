-- Altar Control Module
-- Manages infusion altar, pedestals, and crafting process

local altar = {}
local config = nil
local me = nil

-- Peripheral references
local altarInv = nil
local pedestals = {}
local redstoneIntegrator = nil

-- Current craft state
local craftState = {
    active = false,
    seed = nil,
    quantity = 0,
    startTime = 0
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
    
    -- Connect to redstone integrator
    redstoneIntegrator = peripheral.wrap(config.redstoneIntegrator)
    if not redstoneIntegrator then
        error("Failed to connect to redstone integrator: " .. config.redstoneIntegrator)
    end
    
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
    
    -- Activate altar with redstone pulse on all sides
    print("Waiting for items to settle...")
    sleep(0.5) -- Let items settle
    
    -- Pulse all sides of the Redstone Integrator
    print("Activating altar with redstone pulse...")
    local sides = {"north", "south", "east", "west", "up", "down"}
    for _, side in ipairs(sides) do
        redstoneIntegrator.setOutput(side, true)
    end
    
    sleep(0.1)
    
    for _, side in ipairs(sides) do
        redstoneIntegrator.setOutput(side, false)
    end
    
    -- Altar is now crafting
    craftState.craftStartTime = os.clock()
    print("Altar activated, crafting started")
end

-- Check if current craft is complete
function altar.checkComplete()
    if not craftState.active then
        return false
    end
    
    -- Check altar output slot (usually slot 1)
    local altarItems = altarInv.list()
    
    -- Look for the output seed
    for slot, item in pairs(altarItems) do
        if item.name == craftState.seed.output then
            -- Found output! Import to ME
            me.importItem(item.name, item.count, config.altar)
            
            -- Check if we need more crafts
            if craftState.currentCraft < craftState.quantity then
                craftState.currentCraft = craftState.currentCraft + 1
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
    if elapsed > (config.settings.craftTimeout or 30) then
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
    
    -- Test redstone on all sides
    print("Testing redstone pulse on all sides...")
    local sides = {"north", "south", "east", "west", "up", "down"}
    for _, side in ipairs(sides) do
        redstoneIntegrator.setOutput(side, true)
    end
    sleep(0.5)
    for _, side in ipairs(sides) do
        redstoneIntegrator.setOutput(side, false)
    end
    print("Redstone test complete")
    
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