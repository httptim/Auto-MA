-- Simple ME Bridge test

print("ME Bridge Method Test")
print("====================")

-- Find ME Bridge
local bridge = peripheral.find("meBridge")
if not bridge then
    print("No ME Bridge found!")
    print("Available peripherals:")
    for _, name in ipairs(peripheral.getNames()) do
        print("  " .. name .. " = " .. peripheral.getType(name))
    end
    return
end

print("ME Bridge found!")
print("")

-- List all methods
print("Available methods:")
for name, _ in pairs(bridge) do
    print("  " .. name)
end

print("")
print("Testing listItems()...")

-- Try to list items
local ok, result = pcall(function()
    return bridge.listItems()
end)

if ok then
    print("Success! Found " .. #result .. " items")
    print("")
    print("First 10 items:")
    for i = 1, math.min(10, #result) do
        local item = result[i]
        print(string.format("%d. %s (x%d)", 
            i, 
            item.name or "unknown",
            item.amount or item.count or 0
        ))
    end
else
    print("Failed: " .. tostring(result))
end