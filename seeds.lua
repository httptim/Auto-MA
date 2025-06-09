-- Seeds Database
-- Common MysticalAgriculture seeds and their recipes

local seeds = {
    -- Define display order
    order = {
        -- Resource seeds (Tier 1-2)
        "iron_seeds",
        "gold_seeds",
        "copper_seeds",
        "coal_seeds",
        "redstone_seeds",
        "lapis_seeds",
        "quartz_seeds",
        "glowstone_seeds",
        
        -- Mob seeds (Tier 2-3)
        "zombie_seeds",
        "skeleton_seeds",
        "creeper_seeds",
        "spider_seeds",
        "blaze_seeds",
        "enderman_seeds",
        
        -- Higher tier resources (Tier 3-4)
        "diamond_seeds",
        "emerald_seeds",
        "netherite_seeds",
        
        -- Nature seeds
        "wood_seeds",
        "stone_seeds",
        "dirt_seeds"
    },
    
    -- Tier 1-2 Resource Seeds
    ["iron_seeds"] = {
        name = "Iron Seeds",
        shortName = "Iron",
        output = "mysticalagriculture:iron_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:iron_ingot", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["gold_seeds"] = {
        name = "Gold Seeds",
        shortName = "Gold",
        output = "mysticalagriculture:gold_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:gold_ingot", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["copper_seeds"] = {
        name = "Copper Seeds",
        shortName = "Copper",
        output = "mysticalagriculture:copper_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:copper_ingot", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["coal_seeds"] = {
        name = "Coal Seeds",
        shortName = "Coal",
        output = "mysticalagriculture:coal_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:coal", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["redstone_seeds"] = {
        name = "Redstone Seeds",
        shortName = "Redst",
        output = "mysticalagriculture:redstone_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:redstone", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["lapis_seeds"] = {
        name = "Lapis Lazuli Seeds",
        shortName = "Lapis",
        output = "mysticalagriculture:lapis_lazuli_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:lapis_lazuli", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["quartz_seeds"] = {
        name = "Nether Quartz Seeds",
        shortName = "Quartz",
        output = "mysticalagriculture:nether_quartz_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:quartz", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["glowstone_seeds"] = {
        name = "Glowstone Seeds",
        shortName = "Glow",
        output = "mysticalagriculture:glowstone_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:glowstone_dust", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    -- Mob Seeds
    ["zombie_seeds"] = {
        name = "Zombie Seeds",
        shortName = "Zombie",
        output = "mysticalagriculture:zombie_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:zombie_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["skeleton_seeds"] = {
        name = "Skeleton Seeds",
        shortName = "Skele",
        output = "mysticalagriculture:skeleton_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:skeleton_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["creeper_seeds"] = {
        name = "Creeper Seeds",
        shortName = "Creep",
        output = "mysticalagriculture:creeper_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:creeper_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["spider_seeds"] = {
        name = "Spider Seeds",
        shortName = "Spider",
        output = "mysticalagriculture:spider_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:spider_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["blaze_seeds"] = {
        name = "Blaze Seeds",
        shortName = "Blaze",
        output = "mysticalagriculture:blaze_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:blaze_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["enderman_seeds"] = {
        name = "Enderman Seeds",
        shortName = "Ender",
        output = "mysticalagriculture:enderman_seeds",
        time = 20,
        ingredients = {
            {name = "mysticalagriculture:enderman_essence", count = 4},
            {name = "mysticalagriculture:soulium_seed_base", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    -- Higher Tier Resource Seeds
    ["diamond_seeds"] = {
        name = "Diamond Seeds",
        shortName = "Diamnd",
        output = "mysticalagriculture:diamond_seeds",
        time = 25,
        ingredients = {
            {name = "minecraft:diamond", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["emerald_seeds"] = {
        name = "Emerald Seeds", 
        shortName = "Emrald",
        output = "mysticalagriculture:emerald_seeds",
        time = 25,
        ingredients = {
            {name = "minecraft:emerald", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["netherite_seeds"] = {
        name = "Netherite Seeds",
        shortName = "Nether",
        output = "mysticalagriculture:netherite_seeds",
        time = 30,
        ingredients = {
            {name = "minecraft:netherite_ingot", count = 2},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    },
    
    -- Basic Nature Seeds
    ["wood_seeds"] = {
        name = "Wood Seeds",
        shortName = "Wood",
        output = "mysticalagriculture:wood_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:oak_log", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
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
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["dirt_seeds"] = {
        name = "Dirt Seeds",
        shortName = "Dirt",
        output = "mysticalagriculture:dirt_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:dirt", count = 4},
            {name = "mysticalagriculture:prosperity_seed_base", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    }
}

-- Note: Recipe patterns may vary by modpack
-- Common patterns:
-- - Resource seeds: 4x resource + 1x seed base + 4x essence
-- - Mob seeds: 4x mob drops + 1x soulium seed base + 4x essence
-- - Essence seeds use soul jars or mob chunks instead of drops

-- Validate seeds table
for id, _ in pairs(seeds) do
    if id ~= "order" and type(seeds[id]) ~= "table" then
        error("Invalid seed entry: " .. id)
    end
end

return seeds