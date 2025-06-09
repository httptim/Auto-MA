-- Seed Configuration
-- Allows customization of crafting seed names for different modpack versions

local seedConfig = {}

-- Default crafting seed names (MysticalAgriculture 1.16+)
seedConfig.craftingSeeds = {
    tier1 = "mysticalagriculture:prosperity_seed_base",
    tier2 = "mysticalagriculture:prosperity_seed_base",  
    tier3 = "mysticalagriculture:prosperity_seed_base",
    tier4 = "mysticalagriculture:prosperity_seed_base",
    tier5 = "mysticalagriculture:prosperity_seed_base"
}

-- Alternative configurations for different versions
seedConfig.alternativeSeeds = {
    -- Newer versions with tiered crafting seeds
    tiered = {
        tier1 = "mysticalagriculture:tier1_crafting_seed",
        tier2 = "mysticalagriculture:tier2_crafting_seed",
        tier3 = "mysticalagriculture:tier3_crafting_seed", 
        tier4 = "mysticalagriculture:tier4_crafting_seed",
        tier5 = "mysticalagriculture:tier5_crafting_seed"
    },
    
    -- Older 1.12 versions using metadata
    legacy = {
        tier1 = "mysticalagriculture:crafting:16", -- Inferium
        tier2 = "mysticalagriculture:crafting:17", -- Prudentium
        tier3 = "mysticalagriculture:crafting:18", -- Intermedium
        tier4 = "mysticalagriculture:crafting:19", -- Superium
        tier5 = "mysticalagriculture:crafting:20"  -- Supremium
    },
    
    -- All tiers use prosperity seed base
    prosperity = {
        tier1 = "mysticalagriculture:prosperity_seed_base",
        tier2 = "mysticalagriculture:prosperity_seed_base",
        tier3 = "mysticalagriculture:prosperity_seed_base",
        tier4 = "mysticalagriculture:prosperity_seed_base", 
        tier5 = "mysticalagriculture:prosperity_seed_base"
    }
}

-- Function to update seed recipes with correct crafting seeds
function seedConfig.updateRecipes(seeds, craftingSeedType)
    local seedMap = seedConfig.craftingSeeds
    
    -- Use alternative seed mapping if specified
    if craftingSeedType and seedConfig.alternativeSeeds[craftingSeedType] then
        seedMap = seedConfig.alternativeSeeds[craftingSeedType]
    end
    
    -- Update each seed recipe
    for seedId, seed in pairs(seeds) do
        if type(seed) == "table" and seed.ingredients then
            for i, ingredient in ipairs(seed.ingredients) do
                -- Find and replace crafting seed
                if ingredient.name:find("crafting_seed") or ingredient.name:find("seed_base") then
                    -- Determine tier from the seed
                    local tier = 1
                    if ingredient.name:find("tier1") then tier = 1
                    elseif ingredient.name:find("tier2") then tier = 2
                    elseif ingredient.name:find("tier3") then tier = 3
                    elseif ingredient.name:find("tier4") then tier = 4
                    elseif ingredient.name:find("tier5") then tier = 5
                    end
                    
                    -- Update with correct seed name
                    local tierKey = "tier" .. tier
                    if seedMap[tierKey] then
                        seed.ingredients[i].name = seedMap[tierKey]
                    end
                end
            end
        end
    end
    
    return seeds
end

-- Function to detect which crafting seed type to use based on available items
function seedConfig.detectCraftingSeedType(meModule)
    local items = meModule.listItems()
    local itemNames = {}
    
    -- Build lookup table
    for _, item in ipairs(items) do
        itemNames[item.name] = true
    end
    
    -- Check for tiered crafting seeds
    if itemNames["mysticalagriculture:tier1_crafting_seed"] or 
       itemNames["mysticalagriculture:tier3_crafting_seed"] then
        return "tiered"
    end
    
    -- Check for legacy metadata seeds
    if itemNames["mysticalagriculture:crafting:16"] or
       itemNames["mysticalagriculture:crafting:17"] then
        return "legacy"
    end
    
    -- Check for prosperity seed base
    if itemNames["mysticalagriculture:prosperity_seed_base"] then
        return "prosperity"
    end
    
    -- Default to prosperity
    return "prosperity"
end

return seedConfig