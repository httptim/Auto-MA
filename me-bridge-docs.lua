-- ME Bridge API Documentation Generator
-- This will create a file with all available methods

local config = dofile("/mystical-automation/config.lua")

print("ME Bridge API Documentation Generator")
print("=====================================")
print("ME Bridge: " .. config.meBridge)

-- Connect to ME Bridge
local bridge = peripheral.wrap(config.meBridge)
if not bridge then
    error("Failed to connect to ME Bridge: " .. config.meBridge)
end

print("Connected successfully!")

-- Get all methods
local methods = peripheral.getMethods(config.meBridge)
print("Found " .. #methods .. " methods")

-- Sort methods alphabetically
table.sort(methods)

-- Open file for writing
local file = fs.open("/me-bridge-api.txt", "w")
file.writeLine("ME Bridge API Documentation")
file.writeLine("Generated: " .. os.date())
file.writeLine("Peripheral: " .. config.meBridge)
file.writeLine("Type: " .. peripheral.getType(config.meBridge))
file.writeLine("")
file.writeLine("Available Methods:")
file.writeLine("==================")

for _, method in ipairs(methods) do
    file.writeLine(method)
end

file.writeLine("")
file.writeLine("Method Details:")
file.writeLine("===============")

-- Try to call some common methods to see their output format
local testMethods = {
    "listItems",
    "getItem", 
    "getCraftingCPUs",
    "isItemCrafting",
    "getEnergyStorage",
    "getEnergyUsage"
}

for _, method in ipairs(testMethods) do
    file.writeLine("")
    file.writeLine(method .. "():")
    file.writeLine("-" .. string.rep("-", #method + 3))
    
    -- Check if method exists
    if bridge[method] then
        local ok, result = pcall(bridge[method])
        if ok then
            file.writeLine("Success!")
            if type(result) == "table" then
                if #result > 0 then
                    file.writeLine("Returns a table with " .. #result .. " entries")
                    file.writeLine("First entry structure:")
                    local first = result[1]
                    if first then
                        for k, v in pairs(first) do
                            file.writeLine("  " .. k .. " = " .. type(v) .. " (" .. tostring(v) .. ")")
                        end
                    end
                else
                    file.writeLine("Returns an empty table")
                end
            else
                file.writeLine("Returns: " .. type(result) .. " = " .. tostring(result))
            end
        else
            file.writeLine("Error: " .. tostring(result))
        end
    else
        file.writeLine("Method not found")
    end
end

file.close()

print("")
print("Documentation saved to: /me-bridge-api.txt")
print("")
print("You can view it with: edit /me-bridge-api.txt")
print("Or upload it with: pastebin put /me-bridge-api.txt")