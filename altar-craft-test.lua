-- Altar Craft Test Tool
-- Tests the complete crafting flow step by step

local config = dofile("/mystical-automation/config.lua")
local me = dofile("/mystical-automation/me.lua")
local altar = dofile("/mystical-automation/altar.lua")
local seeds = dofile("/mystical-automation/seeds.lua")

print("Altar Craft Test Tool")
print("====================")

-- Initialize modules
me.init(config)
altar.init(config, me)

-- Test with a simple seed (stone seeds)
local testSeed = seeds["stone_seeds"]
if not testSeed then
    error("Stone seeds not found in database")
end

print("\nTesting with: " .. testSeed.name)
print("Ingredients needed:")
for _, ing in ipairs(testSeed.ingredients) do
    print("  - " .. ing.count .. "x " .. ing.name)
end

-- Check if we have ingredients
print("\nChecking ingredients...")
local canCraft, missing = me.checkIngredients(testSeed.ingredients, 1)
if not canCraft then
    print("Cannot craft - missing: " .. missing)
    print("Please ensure you have all ingredients in ME")
    return
end

print("All ingredients available!")

-- Start the craft
print("\nStarting craft...")
local success, err = pcall(altar.startCraft, testSeed, 1)
if not success then
    print("Failed to start craft: " .. tostring(err))
    return
end

-- Monitor the craft
print("\nMonitoring craft progress...")
local startTime = os.clock()
local lastProgress = 0

while true do
    -- Check progress
    local progress = altar.getProgress()
    local status = altar.getStatus()
    
    -- Only print when progress changes significantly
    if math.abs(progress - lastProgress) >= 0.05 then
        print(string.format("[%.1fs] %s - Progress: %d%%", 
            os.clock() - startTime, 
            status, 
            math.floor(progress * 100)))
        lastProgress = progress
    end
    
    -- Check if complete
    if altar.checkComplete() then
        print("\nCraft completed successfully!")
        break
    end
    
    -- Check for timeout
    if os.clock() - startTime > 60 then
        print("\nTest timeout after 60 seconds")
        altar.cancel()
        break
    end
    
    sleep(0.5)
end

-- Check altar contents
print("\nFinal altar contents:")
local altarInv = peripheral.wrap(config.altar)
local items = altarInv.list()
if next(items) == nil then
    print("  Altar is empty")
else
    for slot, item in pairs(items) do
        print(string.format("  Slot %d: %s x%d", slot, item.name, item.count))
    end
end

print("\nTest complete!")