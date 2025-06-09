-- Seeds Database
-- Complete MysticalAgriculture resource seeds (no mob seeds)

local seeds = {
    -- Define display order (by tier, then alphabetically)
    order = {
        -- Tier 1 seeds
        "stone_seeds",
        "dirt_seeds",
        "wood_seeds",
        "ice_seeds",
        "water_seeds",
        
        -- Tier 2 seeds
        "coal_seeds",
        "coral_seeds",
        "dye_seeds",
        "mystical_flower_seeds",
        "apatite_seeds",
        "marble_seeds",
        "limestone_seeds",
        "basalt_seeds",
        
        -- Tier 3 seeds
        "iron_seeds",
        "copper_seeds",
        "lead_seeds",
        "tin_seeds",
        "silver_seeds",
        "nickel_seeds",
        "aluminum_seeds",
        "obsidian_seeds",
        "redstone_seeds",
        "glowstone_seeds",
        "quartz_seeds",
        "certus_quartz_seeds",
        "fluix_seeds",
        
        -- Tier 4 seeds
        "gold_seeds",
        "lapis_seeds",
        "end_seeds",
        "experience_seeds",
        "uranium_seeds",
        "osmium_seeds",
        "fluorite_seeds",
        
        -- Tier 5 seeds
        "diamond_seeds",
        "emerald_seeds",
        "netherite_seeds",
        "wither_skeleton_seeds",
        "nether_star_seeds",
        "dragon_egg_seeds",
        "nitro_crystal_seeds"
    },
    
    -- TIER 1 SEEDS (Inferium Essence)
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
    
    ["wood_seeds"] = {
        name = "Wood Seeds",
        shortName = "Wood",
        output = "mysticalagriculture:wood_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:oak_log", count = 4},
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["ice_seeds"] = {
        name = "Ice Seeds",
        shortName = "Ice",
        output = "mysticalagriculture:ice_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:ice", count = 4},
            {name = "mysticalagriculture:tier1_crafting_seed", count = 1},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        }
    },
    
    ["water_seeds"] = {
        name = "Water Seeds",
        shortName = "Water",
        output = "mysticalagriculture:water_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:water_bucket", count = 4},
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
    
    ["coral_seeds"] = {
        name = "Coral Seeds",
        shortName = "Coral",
        output = "mysticalagriculture:coral_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:tube_coral", count = 4}, -- Any coral type works
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["dye_seeds"] = {
        name = "Dye Seeds",
        shortName = "Dye",
        output = "mysticalagriculture:dye_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:red_dye", count = 1},
            {name = "minecraft:yellow_dye", count = 1},
            {name = "minecraft:blue_dye", count = 1},
            {name = "minecraft:green_dye", count = 1},
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["mystical_flower_seeds"] = {
        name = "Mystical Flower Seeds",
        shortName = "Flower",
        output = "mysticalagriculture:mystical_flower_seeds",
        time = 20,
        ingredients = {
            {name = "botania:red_mystical_flower", count = 1}, -- Requires Botania
            {name = "botania:yellow_mystical_flower", count = 1},
            {name = "botania:blue_mystical_flower", count = 1},
            {name = "botania:white_mystical_flower", count = 1},
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["apatite_seeds"] = {
        name = "Apatite Seeds",
        shortName = "Apatit",
        output = "mysticalagriculture:apatite_seeds",
        time = 20,
        ingredients = {
            {name = "thermal:apatite", count = 4}, -- Thermal Series
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["marble_seeds"] = {
        name = "Marble Seeds",
        shortName = "Marble",
        output = "mysticalagriculture:marble_seeds",
        time = 20,
        ingredients = {
            {name = "quark:marble", count = 4}, -- Quark mod
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["limestone_seeds"] = {
        name = "Limestone Seeds",
        shortName = "Lime",
        output = "mysticalagriculture:limestone_seeds",
        time = 20,
        ingredients = {
            {name = "quark:limestone", count = 4}, -- Quark mod
            {name = "mysticalagriculture:tier2_crafting_seed", count = 1},
            {name = "mysticalagriculture:prudentium_essence", count = 4}
        }
    },
    
    ["basalt_seeds"] = {
        name = "Basalt Seeds",
        shortName = "Basalt",
        output = "mysticalagriculture:basalt_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:basalt", count = 4},
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
    
    ["lead_seeds"] = {
        name = "Lead Seeds",
        shortName = "Lead",
        output = "mysticalagriculture:lead_seeds",
        time = 20,
        ingredients = {
            {name = "thermal:lead_ingot", count = 4}, -- Thermal Series
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["tin_seeds"] = {
        name = "Tin Seeds",
        shortName = "Tin",
        output = "mysticalagriculture:tin_seeds",
        time = 20,
        ingredients = {
            {name = "thermal:tin_ingot", count = 4}, -- Thermal Series
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["silver_seeds"] = {
        name = "Silver Seeds",
        shortName = "Silver",
        output = "mysticalagriculture:silver_seeds",
        time = 20,
        ingredients = {
            {name = "thermal:silver_ingot", count = 4}, -- Thermal Series
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["nickel_seeds"] = {
        name = "Nickel Seeds",
        shortName = "Nickel",
        output = "mysticalagriculture:nickel_seeds",
        time = 20,
        ingredients = {
            {name = "thermal:nickel_ingot", count = 4}, -- Thermal Series
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["aluminum_seeds"] = {
        name = "Aluminum Seeds",
        shortName = "Alum",
        output = "mysticalagriculture:aluminum_seeds",
        time = 20,
        ingredients = {
            {name = "immersiveengineering:ingot_aluminum", count = 4}, -- Immersive Engineering
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["obsidian_seeds"] = {
        name = "Obsidian Seeds",
        shortName = "Obsid",
        output = "mysticalagriculture:obsidian_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:obsidian", count = 4},
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
    
    ["certus_quartz_seeds"] = {
        name = "Certus Quartz Seeds",
        shortName = "Certus",
        output = "mysticalagriculture:certus_quartz_seeds",
        time = 20,
        ingredients = {
            {name = "ae2:certus_quartz_crystal", count = 4}, -- Applied Energistics 2
            {name = "mysticalagriculture:tier3_crafting_seed", count = 1},
            {name = "mysticalagriculture:tertium_essence", count = 4}
        }
    },
    
    ["fluix_seeds"] = {
        name = "Fluix Seeds",
        shortName = "Fluix",
        output = "mysticalagriculture:fluix_seeds",
        time = 20,
        ingredients = {
            {name = "ae2:fluix_crystal", count = 4}, -- Applied Energistics 2
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
    
    ["end_seeds"] = {
        name = "End Seeds",
        shortName = "End",
        output = "mysticalagriculture:end_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:end_stone", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["experience_seeds"] = {
        name = "Experience Seeds",
        shortName = "Exp",
        output = "mysticalagriculture:experience_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:experience_bottle", count = 4},
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["uranium_seeds"] = {
        name = "Uranium Seeds",
        shortName = "Uran",
        output = "mysticalagriculture:uranium_seeds",
        time = 20,
        ingredients = {
            {name = "mekanism:ingot_uranium", count = 4}, -- Mekanism
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["osmium_seeds"] = {
        name = "Osmium Seeds",
        shortName = "Osmium",
        output = "mysticalagriculture:osmium_seeds",
        time = 20,
        ingredients = {
            {name = "mekanism:ingot_osmium", count = 4}, -- Mekanism
            {name = "mysticalagriculture:tier4_crafting_seed", count = 1},
            {name = "mysticalagriculture:imperium_essence", count = 4}
        }
    },
    
    ["fluorite_seeds"] = {
        name = "Fluorite Seeds",
        shortName = "Fluor",
        output = "mysticalagriculture:fluorite_seeds",
        time = 20,
        ingredients = {
            {name = "mekanism:fluorite_gem", count = 4}, -- Mekanism
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
    },
    
    ["wither_skeleton_seeds"] = {
        name = "Wither Skeleton Seeds",
        shortName = "Wither",
        output = "mysticalagriculture:wither_skeleton_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:wither_skeleton_skull", count = 1},
            {name = "mysticalagriculture:soul_dust", count = 3},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    },
    
    ["nether_star_seeds"] = {
        name = "Nether Star Seeds",
        shortName = "Star",
        output = "mysticalagriculture:nether_star_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:nether_star", count = 1},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 6}
        }
    },
    
    ["dragon_egg_seeds"] = {
        name = "Dragon Egg Seeds",
        shortName = "Dragon",
        output = "mysticalagriculture:dragon_egg_seeds",
        time = 20,
        ingredients = {
            {name = "minecraft:dragon_head", count = 1},
            {name = "minecraft:dragon_breath", count = 3},
            {name = "mysticalagriculture:tier5_crafting_seed", count = 1},
            {name = "mysticalagriculture:supremium_essence", count = 4}
        }
    },
    
    ["nitro_crystal_seeds"] = {
        name = "Nitro Crystal Seeds",
        shortName = "Nitro",
        output = "mysticalagriculture:nitro_crystal_seeds",
        time = 20,
        ingredients = {
            {name = "powah:crystal_nitro", count = 4}, -- Powah mod
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