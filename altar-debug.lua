-- Altar Debug Tool
-- Helps diagnose altar crafting issues

local config = dofile("/mystical-automation/config.lua")

print("Altar Debug Tool")
print("================")

-- Connect to peripherals
local altar = peripheral.wrap(config.altar)
local redstone = peripheral.wrap(config.redstoneIntegrator)

if not altar then
    error("Failed to connect to altar: " .. config.altar)
end

if not redstone then
    error("Failed to connect to redstone integrator: " .. config.redstoneIntegrator)
end

print("Connected to altar and redstone integrator")
print("")

-- Test 1: Check altar inventory
print("1. Checking altar inventory:")
local items = altar.list()
print("   Altar has " .. altar.size() .. " slots")
for slot, item in pairs(items) do
    print("   Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
end

if next(items) == nil then
    print("   Altar is empty")
end

print("")

-- Test 2: Check pedestals
print("2. Checking pedestals:")
for i, pedName in ipairs(config.pedestals) do
    local ped = peripheral.wrap(pedName)
    if ped then
        local pedItems = ped.list()
        local itemCount = 0
        for _, _ in pairs(pedItems) do
            itemCount = itemCount + 1
        end
        print("   Pedestal " .. i .. " (" .. pedName .. "): " .. itemCount .. " items")
        for slot, item in pairs(pedItems) do
            print("      Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
        end
    else
        print("   Pedestal " .. i .. " (" .. pedName .. "): FAILED TO CONNECT")
    end
end

print("")

-- Test 3: Test redstone pulse
print("3. Testing redstone pulse (watch the altar):")
print("   Pulsing all sides in 3 seconds...")
sleep(3)

local sides = {"north", "south", "east", "west", "up", "down"}
print("   Setting all sides HIGH")
for _, side in ipairs(sides) do
    redstone.setOutput(side, true)
end

sleep(1)

print("   Setting all sides LOW")
for _, side in ipairs(sides) do
    redstone.setOutput(side, false)
end

print("   Redstone pulse complete")
print("")

-- Test 4: Monitor altar for changes
print("4. Monitoring altar for 10 seconds...")
print("   (Try manually placing items and activating)")

local startItems = altar.list()
local changes = false

for i = 1, 20 do
    sleep(0.5)
    local currentItems = altar.list()
    
    -- Check for changes
    for slot = 1, altar.size() do
        local before = startItems[slot]
        local after = currentItems[slot]
        
        if (before and not after) or (not before and after) or 
           (before and after and (before.name ~= after.name or before.count ~= after.count)) then
            changes = true
            print("   Change in slot " .. slot .. "!")
            if before then
                print("     Was: " .. before.name .. " x" .. before.count)
            else
                print("     Was: empty")
            end
            if after then
                print("     Now: " .. after.name .. " x" .. after.count)
            else
                print("     Now: empty")
            end
        end
    end
    
    startItems = currentItems
end

if not changes then
    print("   No changes detected in altar")
end

print("")
print("Debug complete!")
print("")
print("Common issues:")
print("- Make sure the Redstone Integrator is adjacent to the altar")
print("- Check that the altar has power (if required)")
print("- Verify all pedestals have items before activation")
print("- Some altars need specific patterns or all pedestals filled")