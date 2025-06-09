-- Minimal test to isolate the issue
-- Tests if gui.showProgress might be blocking

local config = dofile("/mystical-automation/config.lua")
local gui = dofile("/mystical-automation/gui.lua")
local me = dofile("/mystical-automation/me.lua")
local seeds = dofile("/mystical-automation/seeds.lua")

-- Initialize
me.init(config)
gui.init(config, me, seeds)

print("Testing gui.showProgress...")

-- Create a fake seed
local testSeed = {
    id = "test_seed",
    name = "Test Seed",
    tier = 1,
    time = 10
}

-- Test showing progress
print("Before gui.showProgress")
gui.showProgress(testSeed, 0.5)
print("After gui.showProgress")

-- Now test with a timer
print("\nTesting with timer...")
local timerId = os.startTimer(1)
print("Timer started with ID: " .. timerId)

-- Show progress again
gui.showProgress(testSeed, 0.75)

-- Wait for timer
local event, p1 = os.pullEvent("timer")
if p1 == timerId then
    print("Timer fired successfully!")
else
    print("Got different timer ID: " .. tostring(p1))
end

print("Test complete")