-- Debug tool to list ME items and find correct names
-- Run this to see all items in your ME system

local config = dofile("/mystical-automation/config.lua")
local me = dofile("/mystical-automation/me.lua")

-- Initialize ME
me.init(config)

print("Connecting to ME system...")
sleep(1)

-- Get all items
local items = me.listItems()

print("Found " .. #items .. " item types in ME system")
print("")
print("Searching for common MysticalAgriculture items...")
print("=" .. string.rep("=", 50))

-- Search patterns
local patterns = {
    "iron",
    "gold", 
    "inferium",
    "prudentium",
    "tertium",
    "imperium",
    "supremium",
    "prosperity",
    "soulium",
    "essence",
    "seed",
    "ingot",
    "mystical"
}

-- Store found items
local found = {}

for _, item in ipairs(items) do
    local itemName = item.name:lower()
    for _, pattern in ipairs(patterns) do
        if itemName:find(pattern) then
            table.insert(found, {
                name = item.name,
                displayName = item.displayName or item.name,
                amount = item.amount or item.count or 0
            })
            break
        end
    end
end

-- Sort by name
table.sort(found, function(a, b) return a.name < b.name end)

-- Display results
for _, item in ipairs(found) do
    print(string.format("%-60s x%-8d %s", 
        item.name, 
        item.amount,
        item.displayName ~= item.name and "(" .. item.displayName .. ")" or ""
    ))
end

print("=" .. string.rep("=", 50))
print("")
print("To see ALL items, type: all")
print("To search for specific items, type the search term")
print("Type 'exit' to quit")

-- Interactive search
while true do
    write("> ")
    local input = read()
    
    if input == "exit" then
        break
    elseif input == "all" then
        print("\nALL ITEMS IN ME SYSTEM:")
        print("=" .. string.rep("=", 50))
        for _, item in ipairs(items) do
            print(string.format("%-60s x%-8d", 
                item.name, 
                item.amount or item.count or 0
            ))
        end
        print("=" .. string.rep("=", 50))
    elseif input ~= "" then
        print("\nSearching for: " .. input)
        print("=" .. string.rep("=", 50))
        local searchResults = {}
        for _, item in ipairs(items) do
            if item.name:lower():find(input:lower()) then
                table.insert(searchResults, item)
            end
        end
        
        if #searchResults == 0 then
            print("No items found matching: " .. input)
        else
            for _, item in ipairs(searchResults) do
                print(string.format("%-60s x%-8d", 
                    item.name, 
                    item.amount or item.count or 0
                ))
            end
        end
        print("=" .. string.rep("=", 50))
    end
end

print("Debug session ended.")