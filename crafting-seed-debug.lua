-- Crafting Seed Debug Tool
-- Helps identify the correct crafting seed names in your ME system

local config = dofile("/mystical-automation/config.lua")
local me = dofile("/mystical-automation/me.lua")

print("Crafting Seed Debug Tool")
print("========================")

-- Initialize ME
me.init(config)

-- Search patterns for crafting seeds
local patterns = {
    "crafting_seed",
    "craft_seed", 
    "seed_base",
    "prosperity",
    "inferium",
    "prudentium",
    "tertium",
    "imperium",
    "supremium",
    "intermedium",
    "superium",
    "insanium"
}

print("\nSearching for crafting seeds and essences...\n")

-- Get all items
local items = me.listItems()
local foundSeeds = {}
local foundEssences = {}

-- Search for matching items
for _, item in ipairs(items) do
    local nameLower = item.name:lower()
    
    -- Check for crafting seeds
    for _, pattern in ipairs(patterns) do
        if nameLower:find(pattern) and (nameLower:find("seed") or nameLower:find("base")) then
            foundSeeds[item.name] = item.count
        end
    end
    
    -- Check for essences
    if nameLower:find("essence") then
        foundEssences[item.name] = item.count
    end
end

-- Display results
print("Found Crafting Seeds/Bases:")
print("---------------------------")
if next(foundSeeds) == nil then
    print("No crafting seeds found!")
else
    for name, count in pairs(foundSeeds) do
        print(string.format("  %s (x%d)", name, count))
    end
end

print("\nFound Essences:")
print("---------------")
if next(foundEssences) == nil then
    print("No essences found!")
else
    -- Sort by name for easier reading
    local sortedEssences = {}
    for name in pairs(foundEssences) do
        table.insert(sortedEssences, name)
    end
    table.sort(sortedEssences)
    
    for _, name in ipairs(sortedEssences) do
        print(string.format("  %s (x%d)", name, foundEssences[name]))
    end
end

print("\nCommon crafting seed patterns:")
print("------------------------------")
print("MA 1.16+: mysticalagriculture:prosperity_seed_base")
print("MA 1.12:  mysticalagriculture:crafting:16-21")
print("MA newer: mysticalagriculture:tier[1-5]_crafting_seed")

-- Write detailed results to file
local file = fs.open("/crafting-seeds.txt", "w")
file.writeLine("Crafting Seed Debug Results")
file.writeLine("===========================")
file.writeLine("")

file.writeLine("All items containing 'seed' or 'base':")
for _, item in ipairs(items) do
    if item.name:lower():find("seed") or item.name:lower():find("base") then
        file.writeLine(string.format("%s (x%d)", item.name, item.count))
    end
end

file.close()

print("\nDetailed results written to /crafting-seeds.txt")
print("You can upload this with: pastebin put /crafting-seeds.txt")