-- Seeds Database
-- Common MysticalAgriculture seeds and their recipes with CORRECT tiers

local seeds = {
    -- Define display order
    order = {
        -- Tier 1-2 seeds
        "dirt_seeds",
        "stone_seeds",
        "wood_seeds",
        "coal_seeds",
        
        -- Tier 3 seeds
        "iron_seeds",
        "copper_seeds",
        "redstone_seeds",
        "glowstone_seeds",
        "quartz_seeds",
        
        -- Tier 4 seeds
        "gold_seeds",
        "lapis_seeds",
        
        -- Tier 5 seeds
        "diamond_seeds",
        "emerald_seeds",
        "netherite_seeds",
        
        -- Mob seeds (various tiers)
        "zombie_seeds",
        "skeleton_seeds",
        "creeper_seeds",
        "spider_seeds",
        "blaze_seeds",
        "enderman_seeds",
    },
    
    -- TIER 1 SEEDS (Inferium Essence)
    ["dirt_seeds"] = {
        name = "Dirt Seeds",
        shortName = "Dirt",
        output = "mysticalagriculture:dirt_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:dirt", count = 4},
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["stone_seeds"] = {
        name = "Stone Seeds",
        shortName = "Stone",
        output = "mysticalagriculture:stone_seeds", 
        time = 20,
        ingredients = {
            {name = "minecraft:stone", count = 4},
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["wood_seeds"] = {
        name = "Wood Seeds",
        shortName = "Wood",
        output = "mysticalagriculture:wood_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:oak_log", count = 4}, -- Could be any wood type
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["zombie_seeds"] = {
        name = "Zombie Seeds",
        shortName = "Zombie",
        output = "mysticalagriculture:zombie_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:zombie_chunk", count = 4}, -- Requires mob chunks
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    -- TIER 2 SEEDS (Prudentium Essence)
    ["coal_seeds"] = {
        name = "Coal Seeds",
        shortName = "Coal",
        output = "mysticalagriculture:coal_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:coal", count = 4},
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    -- TIER 3 SEEDS (Tertium Essence)
    ["iron_seeds"] = {
        name = "Iron Seeds",
        shortName = "Iron",
        output = "mysticalagriculture:iron_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:iron_ingot", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["copper_seeds"] = {
        name = "Copper Seeds",
        shortName = "Copper",
        output = "mysticalagriculture:copper_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:copper_ingot", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["redstone_seeds"] = {
        name = "Redstone Seeds",
        shortName = "Redst",
        output = "mysticalagriculture:redstone_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:redstone", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["glowstone_seeds"] = {
        name = "Glowstone Seeds",
        shortName = "Glow",
        output = "mysticalagriculture:glowstone_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:glowstone_dust", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["quartz_seeds"] = {
        name = "Nether Quartz Seeds",
        shortName = "Quartz",
        output = "mysticalagriculture:nether_quartz_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:quartz", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["skeleton_seeds"] = {
        name = "Skeleton Seeds",
        shortName = "Skele",
        output = "mysticalagriculture:skeleton_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:skeleton_chunk", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["creeper_seeds"] = {
        name = "Creeper Seeds",
        shortName = "Creep",
        output = "mysticalagriculture:creeper_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:creeper_chunk", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["spider_seeds"] = {
        name = "Spider Seeds", 
        shortName = "Spider",
        output = "mysticalagriculture:spider_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:spider_chunk", count = 4},
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    -- TIER 4 SEEDS (Imperium Essence)
    ["gold_seeds"] = {
        name = "Gold Seeds",
        shortName = "Gold",
        output = "mysticalagriculture:gold_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:gold_ingot", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["lapis_seeds"] = {
        name = "Lapis Lazuli Seeds",
        shortName = "Lapis",
        output = "mysticalagriculture:lapis_lazuli_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:lapis_lazuli", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["blaze_seeds"] = {
        name = "Blaze Seeds",
        shortName = "Blaze",
        output = "mysticalagriculture:blaze_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:blaze_chunk", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["enderman_seeds"] = {
        name = "Enderman Seeds",
        shortName = "Ender",
        output = "mysticalagriculture:enderman_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:enderman_chunk", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    -- TIER 5 SEEDS (Supremium Essence)
    ["diamond_seeds"] = {
        name = "Diamond Seeds",
        shortName = "Diamnd",
        output = "mysticalagriculture:diamond_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:diamond", count = 4},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    },
    
    ["emerald_seeds"] = {
        name = "Emerald Seeds",
        shortName = "Emrld",
        output = "mysticalagriculture:emerald_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:emerald", count = 4},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    },
    
    ["netherite_seeds"] = {
        name = "Netherite Seeds",
        shortName = "Nether",
        output = "mysticalagriculture:netherite_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:netherite_ingot", count = 4},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    }
}

-- Validate all seeds have required fields
for id, seed in pairs(seeds) do
    if type(seed) == "table" then
        assert(seed.name, "Seed " .. id .. " missing name")
        assert(seed.output, "Seed " .. id .. " missing output")
        assert(seed.ingredients, "Seed " .. id .. " missing ingredients")
    end
end

return seeds