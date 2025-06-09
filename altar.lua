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
function altar.init(cfg)
    config = cfg
    me = dofile("/mystical-automation/me.lua") -- Get ME reference
    
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
    -- MysticalAgriculture typically uses 8 pedestals with one ingredient type each
    -- Common pattern: 4 of material + 4 essence, or 8 essence + 1 base in center
    
    local distributed = {}
    local pedestalIndex = 1
    
    for _, ingredient in ipairs(ingredients) do
        local remaining = ingredient.count
        
        -- For ingredients that need to be split across pedestals
        while remaining > 0 and pedestalIndex <= 8 do
            local toPlace = math.min(remaining, 1) -- Usually 1 per pedestal
            
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
    end
    
    return distributed
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
    -- Calculate ingredients for one craft
    local ingredients = {}
    for _, ing in ipairs(seed.ingredients) do
        table.insert(ingredients, {
            name = ing.name,
            count = ing.count -- For 1 seed
        })
    end
    
    -- Distribute ingredients to pedestals
    local distributed = distributeIngredients(ingredients)
    
    -- If there's a center item (like prosperity seed base), put it in altar
    for _, ing in ipairs(ingredients) do
        if ing.name:find("seed_base") then
            me.exportItem(ing.name, 1, config.altar)
            break
        end
    end
    
    -- Activate altar with redstone pulse
    sleep(0.5) -- Let items settle
    redstoneIntegrator.setOutput(config.redstoneSide, true)
    sleep(0.1)
    redstoneIntegrator.setOutput(config.redstoneSide, false)
    
    -- Altar is now crafting
    craftState.craftStartTime = os.clock()
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
    
    -- Test redstone
    print("Testing redstone pulse...")
    redstoneIntegrator.setOutput(config.redstoneSide, true)
    sleep(0.5)
    redstoneIntegrator.setOutput(config.redstoneSide, false)
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