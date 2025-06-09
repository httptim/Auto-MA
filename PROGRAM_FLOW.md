# MysticalAgriculture Automation - Program Flow Documentation

## Overview
This document describes how the different Lua files interact in the simplified MysticalAgriculture automation system.

---

## File Structure & Responsibilities

### Core Files (7 total)
```
/mystical-automation/
├── startup.lua    # Main entry point and event loop
├── config.lua     # User configuration (peripherals, settings)
├── me.lua         # ME Bridge API wrapper
├── altar.lua      # Altar and pedestal control
├── gui.lua        # Monitor display and touch handling
├── seeds.lua      # Seed database and recipes
└── README.md      # Setup instructions
```

---

## Program Flow Diagrams

### 1. System Startup Flow
```
startup.lua (Entry Point)
    │
    ├─→ Check if config.lua exists
    │     ├─→ No: Run setup wizard
    │     │     ├─→ Detect all peripherals
    │     │     ├─→ Show selection menus
    │     │     ├─→ Save config.lua
    │     │     └─→ Continue startup
    │     └─→ Yes: Load config table
    │
    ├─→ Initialize me.lua
    │     ├─→ Find ME Bridge peripheral
    │     └─→ Test connection
    │
    ├─→ Initialize altar.lua
    │     ├─→ Find altar peripherals
    │     ├─→ Find pedestal peripherals
    │     └─→ Find redstone integrator
    │
    ├─→ Initialize gui.lua
    │     ├─→ Find monitor peripheral
    │     └─→ Draw initial screen
    │
    ├─→ Load seeds.lua
    │     └─→ Returns seed database
    │
    └─→ Enter main event loop
```

### 2. Main Event Loop (startup.lua)
```
while true do
    ├─→ os.pullEvent()
    │
    ├─→ "monitor_touch" event
    │     └─→ gui.handleTouch(x, y)
    │           └─→ Returns seed_id or nil
    │
    ├─→ "timer" event
    │     └─→ Check craft progress
    │           └─→ altar.checkProgress()
    │
    ├─→ "craft_request" event (custom)
    │     └─→ Process craft
    │           ├─→ me.checkIngredients(seed)
    │           ├─→ altar.startCraft(seed)
    │           └─→ gui.updateStatus()
    │
    └─→ "redstone" event
          └─→ altar.handleRedstone()
```

### 3. Touch Event Processing
```
User touches monitor
    │
    ├─→ gui.handleTouch(x, y)
    │     ├─→ Calculate button from x,y
    │     ├─→ Get seed_id from button
    │     └─→ Return seed_id or action
    │
    └─→ startup.lua receives seed_id
          ├─→ Lookup seed in seeds.lua
          ├─→ Check availability via me.lua
          ├─→ Show quantity selector screen
          │     ├─→ Display current quantity
          │     ├─→ Show +/- buttons
          │     └─→ Wait for CRAFT/CANCEL
          └─→ Start craft or return to main
```

### 3.1 Setup Wizard Flow
```
No config.lua found
    │
    ├─→ startup.detectPeripherals()
    │     ├─→ peripheral.getNames()
    │     ├─→ Group by type
    │     └─→ Return peripheral list
    │
    ├─→ startup.setupWizard(peripherals)
    │     ├─→ "Select monitor:"
    │     ├─→ "Select ME Bridge:"
    │     ├─→ "Select altar:"
    │     ├─→ "Select 8 pedestals:"
    │     └─→ "Select redstone integrator:"
    │
    └─→ startup.saveConfig(selections)
          ├─→ Create config table
          ├─→ Write to config.lua
          └─→ Continue normal startup
```

### 4. Crafting Process Flow
```
Craft Request (seed_id, quantity)
    │
    ├─→ seeds.lua lookup
    │     └─→ Get ingredient list
    │
    ├─→ Calculate total ingredients needed
    │     └─→ Multiply by quantity
    │
    ├─→ me.checkIngredients(ingredients, quantity)
    │     ├─→ Query ME Bridge
    │     └─→ Return true/false + missing items
    │
    ├─→ If available:
    │     ├─→ altar.startCraft(seed, quantity)
    │     │     ├─→ Export items from ME
    │     │     ├─→ Distribute to pedestals
    │     │     ├─→ Activate altar
    │     │     └─→ Start timer
    │     │
    │     └─→ gui.showProgress()
    │
    └─→ If not available:
          └─→ gui.showError(missing_items)
```

---

## File Interactions

### config.lua
```lua
-- Loaded by: startup.lua
-- Used by: All other files
-- Purpose: Central configuration

return {
    me_bridge = "meBridge_0",
    monitor = "monitor_0", 
    altar = {
        name = "altar_0",
        pedestals = {"chest_0", "chest_1", ...},
        integrator = "redstoneIntegrator_0"
    }
}
```

### me.lua
```lua
-- Loaded by: startup.lua
-- Uses: config.lua (for peripheral name)
-- Called by: startup.lua, altar.lua
-- Purpose: ME network interface

Functions:
- init() → Connect to ME Bridge
- listItems() → Get all items in ME
- checkIngredients(list) → Check availability
- exportItem(name, count, target) → Export to peripheral
```

### altar.lua
```lua
-- Loaded by: startup.lua
-- Uses: config.lua, me.lua
-- Called by: startup.lua
-- Purpose: Altar automation

Functions:
- init() → Connect to altar peripherals
- startCraft(seed) → Begin crafting process
- checkProgress() → Monitor craft status
- distribute(items) → Place items on pedestals
- activate() → Trigger altar with redstone
```

### gui.lua
```lua
-- Loaded by: startup.lua
-- Uses: config.lua, seeds.lua
-- Called by: startup.lua
-- Purpose: Display and touch interface

Functions:
- init() → Setup monitor
- draw() → Render seed grid
- handleTouch(x, y) → Process touch events
- updateStatus(message) → Show current state
- showProgress(percent) → Display progress bar
```

### seeds.lua
```lua
-- Loaded by: startup.lua
-- Used by: gui.lua, startup.lua, altar.lua
-- Purpose: Seed database

Structure:
return {
    ["iron_seeds"] = {
        name = "Iron Seeds",
        ingredients = {
            {name = "minecraft:iron_ingot", count = 4},
            {name = "mysticalagriculture:inferium_essence", count = 4}
        },
        output = "mysticalagriculture:iron_seeds",
        time = 20
    },
    -- ... more seeds
}
```

---

## Event Flow Examples

### Example 1: Successful Craft
```
1. User touches "Iron Seeds" button
2. gui.handleTouch() → returns "iron_seeds"
3. startup.lua receives touch event
4. Checks ingredients via me.lua
5. All available → calls altar.startCraft()
6. altar.lua exports items from ME
7. altar.lua distributes to pedestals
8. altar.lua activates with redstone
9. Timer started for 20 seconds
10. gui.lua shows progress bar
11. Timer expires → check altar output
12. Import crafted seed to ME
13. gui.lua shows completion
```

### Example 2: Missing Ingredients
```
1. User touches "Diamond Seeds" button
2. gui.handleTouch() → returns "diamond_seeds"
3. startup.lua receives touch event
4. Checks ingredients via me.lua
5. Missing diamonds → me.checkIngredients() returns false
6. gui.showError("Missing: 4x Diamond")
7. Button shown in red
8. No craft started
```

---

## Error Handling Chain

```
Any Error
    │
    ├─→ pcall() in calling function
    │     └─→ Return false, error_message
    │
    ├─→ Propagate to startup.lua
    │     └─→ Log error
    │
    └─→ Display to user
          └─→ gui.showError(message)
```

---

## Performance Considerations

1. **ME Queries**: Cache results for 5 seconds to reduce lag
2. **GUI Updates**: Only redraw changed portions
3. **Event Handling**: Process events quickly, use timers for long operations
4. **Memory**: Keep data structures simple, clear unused variables

---

## Extending the System

To add new features:

1. **New Seeds**: Add entries to seeds.lua
2. **Multiple Altars**: Modify config.lua and altar.lua
3. **Better GUI**: Enhance gui.lua drawing functions
4. **Statistics**: Add logging to startup.lua event handlers
5. **Remote Control**: Add rednet listener in startup.lua

---

This simplified architecture keeps all components loosely coupled and easy to understand. Each file has a clear purpose and minimal dependencies.