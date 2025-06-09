# MysticalAgriculture Seed Automation System with CC:Tweaked

## ⚠️ IMPORTANT DISCLAIMER

**This README contains theoretical design concepts and mock code examples only.** None of the code provided has been tested or confirmed to work. All code snippets are illustrative examples to demonstrate intended functionality and system design concepts.

**For actual implementation:**
- **PRIMARY REFERENCE:** All CC:Tweaked API calls, Lua syntax, and peripheral interactions MUST be verified against `docs/CCTweaked.md`
- All API calls, peripheral interactions, and Lua syntax should be verified against official documentation
- Code examples serve as design templates only and will require proper implementation based on actual API specifications
- Advanced Peripherals ME Bridge API should be verified against Advanced Peripherals documentation

## Project Overview

An advanced automation system that integrates MysticalAgriculture seed crafting with Applied Energistics 2 storage networks, controlled through CC:Tweaked computers with a sophisticated touch-screen GUI interface. This system provides fully automated seed production with real-time ingredient checking, automatic retrieval, and seamless ME network integration.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Hardware Requirements](#hardware-requirements)
3. [Software Dependencies](#software-dependencies)
4. [GitHub Installer Setup](#github-installer-setup)
5. [Installation Guide](#installation-guide)
5. [Configuration](#configuration)
6. [Code Structure](#code-structure)
7. [GUI Implementation](#gui-implementation)
8. [Database Schema](#database-schema)
9. [Automation Workflow](#automation-workflow)
10. [API Integration](#api-integration)
11. [Error Handling](#error-handling)
12. [Extensibility](#extensibility)
13. [Troubleshooting](#troubleshooting)
14. [References](#references)

## System Architecture

### Core Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Central Control Computer                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   GUI Manager   │  │ Automation Core │  │ ME Interface │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                   ┌──────────┼──────────┐
                   │          │          │
         ┌─────────▼───┐  ┌───▼────┐  ┌──▼──────────┐
         │ Monitor Array│  │Redstone│  │ ME Bridge   │
         │   (3x2)     │  │Integr. │  │ (Advanced   │
         │             │  │        │  │ Peripherals)│
         └─────────────┘  └────────┘  └─────────────┘
                              │              │
                    ┌─────────▼─────────┐    │
                    │ Infusion Altars   │    │
                    │ (with Pedestals)  │    │
                    └───────────────────┘    │
                                             │
                    ┌────────────────────────▼─────┐
                    │    AE2 ME Network            │
                    │  (Storage & Automation)      │
                    └──────────────────────────────┘
```

### Network Topology

- **Central Computer**: Main control unit with wired modem
- **Monitor Array**: 3x2 monitor configuration for GUI display (combines into one large monitor)
- **ME Bridge**: Advanced Peripherals block connecting to AE2 network
- **Infusion Infrastructure**: Multiple altars with 8 pedestals each
- **Redstone Integrators**: Advanced Peripherals blocks for remote altar activation via wired network

## Hardware Requirements

### Essential Components

**Computer Setup:**
- 1x Advanced Computer (CC:Tweaked)
- 1x Wired Modem (attached to computer)
- 6x Advanced Monitors (arranged in 3x2 configuration - these combine into one large monitor)
- Networking Cables (sufficient length for setup)

**MysticalAgriculture Infrastructure:**
- Multiple Infusion Altars (recommend 2-4 for throughput)
- 8x Infusion Pedestals per altar (positioned according to ghost blocks)
- Wired Modems for each pedestal
- Redstone Integrators (Advanced Peripherals) - one per altar for activation

**ME Network Integration:**
- 1x ME Bridge (Advanced Peripherals)
- 1x Redstone Integrator (Advanced Peripherals) - for altar activation
- AE2 ME Controller and storage infrastructure
- ME Import/Export buses (for manual backup integration)

### Physical Layout

```
Monitor Configuration (3x2 - combines into single large monitor):
┌───────┬───────┬───────┐
│       │       │       │
│    Combined Monitor   │
│     (Large Display)   │
│       │       │       │
├───────┼───────┼───────┤
│       │       │       │
└───────┴───────┴───────┘
         │
    ┌────▼────┐
    │Computer │
    └─────────┘

Infusion Altar Layout (per altar):
    P   P   P
      \ | /
    P - A - P
      / | \
    P   P   P
         |
      [R.I.] -- Redstone Integrator (Advanced Peripherals)
         |      with wired modem, positioned behind altar
    [Wired Modem Network]

Legend: A = Altar, P = Pedestal, R.I. = Redstone Integrator
```

**Redstone Setup Notes:**
- Each altar requires its own Redstone Integrator from Advanced Peripherals
- Position the Redstone Integrator behind the altar (any side that can send redstone signal to the altar)
- Connect the Redstone Integrator to the wired modem network
- The altar also needs a wired modem for pedestal connectivity (separate from redstone control)

## Software Dependencies

### Required Mods (ATM10)

- **CC:Tweaked**: Core computer functionality
- **Advanced Peripherals**: ME Bridge integration
- **MysticalAgriculture**: Seed crafting mechanics
- **Applied Energistics 2**: ME storage network
- **Cucumber Library**: MysticalAgriculture dependency

### API Requirements

> **⚠️ Code Disclaimer:** These are theoretical API usage examples. Refer to `docs/CCTweaked.md` for actual API specifications and proper implementation patterns.

```lua
-- Core CC:Tweaked APIs (THEORETICAL EXAMPLE)
local monitor = peripheral.find("monitor") -- Single combined monitor
local modem = peripheral.find("modem")

-- Advanced Peripherals APIs (THEORETICAL EXAMPLE)
local me_bridge = peripheral.find("meBridge")
local redstone_integrator = peripheral.find("redstoneIntegrator")

-- Peripheral connections (THEORETICAL EXAMPLE)
local pedestals = {peripheral.find("inventory")}
```

**Important Note:** Wired modems cannot directly output redstone signals. Remote redstone control requires Advanced Peripherals' Redstone Integrator blocks connected to the wired network.

## GitHub Installer Setup

The project includes a sophisticated GitHub installer with Docker-style progress tracking and animated download progress. Before installation, you'll need to configure the installer for the MysticalAgriculture automation system.

### Installer Features
- **Animated Progress Bars**: Real-time download progress with percentage indicators
- **Scrolling Log Window**: Docker-style pull messages for each file
- **Error Handling**: Comprehensive error reporting and recovery
- **Directory Management**: Automatic creation of project structure
- **Launcher Generation**: Creates convenient startup scripts

### Pre-Installation Configuration

The installer requires updating several configuration tables to download the correct files for this project instead of the default RedNet-Explorer files.

## Installation Guide

### Step 1: Hardware Assembly

1. **Place Central Computer**
   - Position with wired modem attached
   - Ensure clear sight lines to monitor array

2. **Configure Monitor Array**
   
   > **⚠️ Code Disclaimer:** The following is a theoretical example for design purposes only. Actual monitor detection and configuration should reference `docs/CCTweaked.md` for proper API usage.
   
   ```lua
   -- Monitor setup validation (THEORETICAL EXAMPLE)
   local monitor = peripheral.find("monitor") -- Combined monitor from 3x2 array
   if not monitor then
       error("Combined monitor not found")
   end
   
   -- Get dimensions of combined monitor
   local width, height = monitor.getSize()
   print("Monitor size: " .. width .. "x" .. height)
   ```

3. **Install Infusion Infrastructure**
   - Place altars with proper spacing
   - Position pedestals according to ghost block indicators
   - Connect all pedestals to wired modem network
   - Place Redstone Integrators behind each altar
   - Connect Redstone Integrators to wired modem network
   - Test redstone connectivity from integrators to altars

4. **ME Bridge Placement**
   - Connect ME Bridge to AE2 network
   - Attach wired modem to bridge
   - Verify ME network accessibility

### Step 2: Software Installation

**Option A: Using the Provided GitHub Installer (Recommended)**

The project includes a sophisticated GitHub installer that handles the complete installation process. To configure it for the MysticalAgriculture automation system:

1. **Update Installer Configuration**
   
   Modify the installer configuration variables:
   ```lua
   -- Update these values in the installer
   local REPO_OWNER = "[your-github-username]"
   local REPO_NAME = "mystical-agriculture-automation"
   local BRANCH = "main"
   local INSTALL_DIR = "/mystical-automation"
   ```

2. **Configure File Manifest**
   
   Replace the `FILES` table with the MysticalAgriculture system files:
   ```lua
   local FILES = {
       -- Main files
       {url = "startup.lua", path = "/startup.lua"},
       {url = "config.lua", path = "/config.lua"},
       
       -- Core modules
       {url = "modules/gui.lua", path = "/modules/gui.lua"},
       {url = "modules/automation.lua", path = "/modules/automation.lua"},
       {url = "modules/database.lua", path = "/modules/database.lua"},
       {url = "modules/me_interface.lua", path = "/modules/me_interface.lua"},
       {url = "modules/utils.lua", path = "/modules/utils.lua"},
       
       -- Data files
       {url = "data/seeds.lua", path = "/data/seeds.lua"},
       {url = "data/recipes.lua", path = "/data/recipes.lua"},
       
       -- Assets
       {url = "assets/icons.lua", path = "/assets/icons.lua"},
   }
   ```

3. **Update Directory Structure**
   
   Modify the `DIRECTORIES` table:
   ```lua
   local DIRECTORIES = {
       "/modules", "/data", "/assets", "/logs", "/cache"
   }
   ```

4. **Configure Launcher Scripts**
   
   Update the `LAUNCHERS` table:
   ```lua
   local LAUNCHERS = {
       {
           name = "mystical-auto",
           content = [[-- MysticalAgriculture Automation Launcher
   shell.run("startup")]]
       },
       {
           name = "mystical-config",
           content = [[-- Configuration Tool
   shell.run("modules/config_wizard")]]
       },
   }
   ```

**Option B: Manual Installation (Alternative)**

> **⚠️ Code Disclaimer:** Manual download examples are theoretical. Verify filesystem API usage in `docs/CCTweaked.md`.

1. **Download Core Files**
   ```lua
   -- Main startup file (THEORETICAL EXAMPLE)
   shell.run("wget", "https://[repository]/startup.lua", "startup")
   
   -- Core modules (THEORETICAL EXAMPLE)  
   shell.run("wget", "https://[repository]/modules/gui.lua", "modules/gui")
   shell.run("wget", "https://[repository]/modules/automation.lua", "modules/automation")
   shell.run("wget", "https://[repository]/modules/database.lua", "modules/database")
   shell.run("wget", "https://[repository]/config.lua", "config")
   ```

**Running the Installer**

The GitHub installer provides a sophisticated installation experience with:
- Real-time progress tracking with animated progress bars
- Scrolling download log with file-by-file status
- Docker-style pull messages for each component
- Automatic directory structure creation
- Launcher script generation

To use the installer:
1. Upload the configured installer script to your computer
2. Run: `installer` (or whatever you name the installer file)
3. The installer will automatically:
   - Create the required directory structure
   - Download all project files from GitHub
   - Set up launcher scripts
   - Provide completion status

**Running the Installer**

The GitHub installer provides a sophisticated installation experience with:
- Real-time progress tracking with animated progress bars
- Scrolling download log with file-by-file status
- Docker-style pull messages for each component
- Automatic directory structure creation
- Launcher script generation

To use the installer:
1. Upload the configured installer script to your computer
2. Run: `installer` (or whatever you name the installer file)
3. The installer will automatically:
   - Create the required directory structure
   - Download all project files from GitHub
   - Set up launcher scripts
   - Provide completion status

The installer includes error handling and will show detailed progress for all project files. 

> **Note:** Update the file count in the installer comments to match the actual number of files in your MysticalAgriculture project (the current installer mentions 96 files from the RedNet-Explorer project).

3. **Initial Configuration**

   > **⚠️ Code Disclaimer:** Shell execution example is theoretical. Verify proper shell API usage in `docs/CCTweaked.md`.

   ```lua
   -- Run setup wizard (THEORETICAL EXAMPLE)
   shell.run("startup", "setup")
   ```

## Configuration

### config.lua Template

> **⚠️ Code Disclaimer:** This configuration structure is a theoretical design template. Actual Lua table structures and configuration patterns should be validated against `docs/CCTweaked.md` for proper implementation.

```lua
-- MysticalAgriculture Automation Configuration (THEORETICAL TEMPLATE)
local config = {}

-- Display Settings
config.display = {
    scale = 0.5,
    background_color = colors.black, -- Verify colors API in docs
    text_color = colors.white,
    accent_color = colors.blue
}

-- Network Configuration  
config.network = {
    me_bridge_name = "meBridge_0", -- Verify peripheral naming conventions
    modem_side = "back"
}

-- Altar Configuration
config.altars = {
    {
        name = "altar_1",
        pedestals = {
            "inventory_0", "inventory_1", "inventory_2", "inventory_3",
            "inventory_4", "inventory_5", "inventory_6", "inventory_7"
        },
        redstone_integrator = "redstoneIntegrator_0", -- Advanced Peripherals
        redstone_side = "south" -- Side of integrator facing altar
    }
}

-- Performance Settings
config.performance = {
    gui_refresh_rate = 0.1,
    me_query_cache_time = 5,
    max_concurrent_crafts = 2
}

return config
```

## Code Structure

### File Organization

```
mystical_automation/
├── startup.lua          # Main entry point
├── config.lua          # Configuration settings
├── modules/
│   ├── gui.lua          # GUI management
│   ├── automation.lua   # Crafting automation
│   ├── database.lua     # Seed database
│   ├── me_interface.lua # ME Bridge integration
│   └── utils.lua        # Utility functions
├── data/
│   ├── seeds.lua        # Seed definitions
│   └── recipes.lua      # Crafting recipes
└── assets/
    └── icons.lua        # GUI icons and graphics
```

### Core Module Structure

**startup.lua**

> **⚠️ Code Disclaimer:** This is a theoretical system architecture example. Event handling, module loading, and main loop patterns should be verified against `docs/CCTweaked.md` for proper CC:Tweaked implementation.

```lua
-- System initialization and main loop (THEORETICAL EXAMPLE)
local config = require("config")
local gui = require("modules.gui")
local automation = require("modules.automation")

function main()
    -- Initialize systems
    gui.init()
    automation.init()
    
    -- Main event loop (verify event API in docs)
    while true do
        local event, data = os.pullEvent()
        
        if event == "monitor_touch" then
            gui.handleTouch(data)
        elseif event == "craft_complete" then
            automation.handleCraftComplete(data)
        end
        
        sleep(0.05)
    end
end

main()
```

## GUI Implementation

### Screen Layout System

> **⚠️ Code Disclaimer:** GUI implementation examples are theoretical design concepts. Monitor API calls, drawing functions, and touch event handling should be verified against `docs/CCTweaked.md` for proper implementation.

```lua
-- gui.lua - Core GUI functions (THEORETICAL EXAMPLE)
local gui = {}

function gui.init()
    -- Access combined monitor from 3x2 array
    gui.monitor = peripheral.find("monitor")
    if not gui.monitor then
        error("Monitor not found")
    end
    
    -- Get actual dimensions of combined monitor
    gui.width, gui.height = gui.monitor.getSize()
    
    gui.monitor.setTextScale(0.5) -- Verify scale API in docs
end

function gui.drawMainScreen()
    gui.clear()
    gui.drawHeader("MysticalAgriculture Automation")
    gui.drawSeedGrid()
    gui.drawStatusBar()
end

function gui.drawSeedGrid()
    local seeds = database.getAllSeeds()
    local grid_width = 8
    local grid_height = 6
    
    for i, seed in ipairs(seeds) do
        local x = ((i - 1) % grid_width) * 6 + 2
        local y = math.floor((i - 1) / grid_width) * 4 + 4
        
        gui.drawSeedButton(x, y, seed)
    end
end

function gui.drawSeedButton(x, y, seed)
    local available = automation.checkAvailability(seed)
    local color = available and colors.green or colors.gray
    
    gui.monitor.setBackgroundColor(color) -- Verify colors API
    gui.monitor.setTextColor(colors.white)
    
    -- Draw button background (verify drawing API in docs)
    for dx = 0, 5 do
        for dy = 0, 3 do
            gui.monitor.setCursorPos(x + dx, y + dy)
            gui.monitor.write(" ")
        end
    end
    
    -- Draw seed name
    gui.monitor.setCursorPos(x + 1, y + 1)
    gui.monitor.write(seed.name:sub(1, 4))
    
    -- Draw availability indicator
    if not available then
        gui.monitor.setCursorPos(x + 4, y + 3)
        gui.monitor.setTextColor(colors.red)
        gui.monitor.write("!")
    end
end
```

### Touch Event Handling

> **⚠️ Code Disclaimer:** Touch event handling is a theoretical example. Actual touch event structure and coordinate handling should be verified in `docs/CCTweaked.md`.

```lua
-- Touch event processing (THEORETICAL EXAMPLE)
function gui.handleTouch(x, y)
    -- Determine which button was pressed (verify touch event API)
    local button = gui.getButtonAt(x, y)
    
    if button then
        if button.type == "seed" then
            gui.showSeedDetails(button.seed)
        elseif button.type == "craft" then
            automation.startCraft(button.seed, button.quantity)
        elseif button.type == "back" then
            gui.showMainScreen()
        end
    end
end
```

## Database Schema

### Seed Database Structure

> **⚠️ Code Disclaimer:** Database structure and table operations are theoretical examples. Lua table manipulation and file operations should be verified against `docs/CCTweaked.md` for proper implementation.

```lua
-- database.lua - Seed definitions and queries (THEORETICAL EXAMPLE)
local database = {}

-- Core seed data structure (THEORETICAL TEMPLATE)
database.seeds = {
    -- Resource Seeds
    {
        id = "iron_seeds",
        name = "Iron Seeds",
        category = "resource",
        tier = 1,
        ingredients = {
            {item = "minecraft:iron_ingot", count = 1},
            {item = "mysticalagriculture:inferium_essence", count = 8},
            {item = "mysticalagriculture:prosperity_seed_base", count = 1}
        },
        output = {item = "mysticalagriculture:iron_seeds", count = 1},
        craft_time = 30
    },
    
    -- Mob Seeds
    {
        id = "zombie_seeds",
        name = "Zombie Seeds",
        category = "mob",
        tier = 1,
        ingredients = {
            {item = "mysticalagriculture:zombie_chunk", count = 1},
            {item = "mysticalagriculture:inferium_essence", count = 8},
            {item = "mysticalagriculture:soulium_seed_base", count = 1}
        },
        output = {item = "mysticalagriculture:zombie_seeds", count = 1},
        craft_time = 45
    }
}

-- Database query functions (THEORETICAL EXAMPLES)
function database.getSeed(id)
    for _, seed in ipairs(database.seeds) do
        if seed.id == id then
            return seed
        end
    end
    return nil
end

function database.getSeedsByCategory(category)
    local results = {}
    for _, seed in ipairs(database.seeds) do
        if seed.category == category then
            table.insert(results, seed)
        end
    end
    return results
end
```

## Automation Workflow

### Crafting Process Flow

> **⚠️ Code Disclaimer:** Automation logic examples are theoretical design concepts. Event handling, timing functions, and peripheral interactions should be verified against `docs/CCTweaked.md` for proper implementation.

```lua
-- automation.lua - Core automation logic (THEORETICAL EXAMPLE)
local automation = {}

function automation.startCraft(seed, quantity)
    -- Validate inputs (verify parameter handling in docs)
    if not seed or quantity <= 0 then
        return false, "Invalid craft parameters"
    end
    
    -- Check ingredient availability
    local available, missing = automation.checkIngredients(seed, quantity)
    if not available then
        return false, "Missing ingredients: " .. table.concat(missing, ", ")
    end
    
    -- Reserve altar
    local altar = automation.getAvailableAltar()
    if not altar then
        return false, "No altars available"
    end
    
    -- Start crafting process
    automation.executeCraft(altar, seed, quantity)
    return true
end

function automation.executeCraft(altar, seed, quantity)
    -- Step 1: Extract ingredients from ME (verify ME Bridge API)
    gui.updateStatus("Retrieving ingredients...")
    for _, ingredient in ipairs(seed.ingredients) do
        local success = me_interface.exportItem(
            ingredient.item,
            ingredient.count * quantity,
            altar.pedestals[1]
        )
        if not success then
            error("Failed to extract " .. ingredient.item)
        end
    end
    
    -- Step 2: Distribute to pedestals (verify inventory API)
    gui.updateStatus("Placing ingredients...")
    automation.distributeIngredients(altar, seed, quantity)
    
    -- Step 3: Activate altar (verify redstone integrator API)
    gui.updateStatus("Crafting...")
    automation.activateAltar(altar)
    
    -- Step 4: Monitor progress (verify timing functions)
    automation.monitorCrafting(altar, seed, quantity)
end

function automation.activateAltar(altar)
    -- Use Advanced Peripherals Redstone Integrator for remote activation
    local integrator = peripheral.wrap(altar.redstone_integrator)
    if not integrator then
        error("Redstone integrator not found: " .. altar.redstone_integrator)
    end
    
    -- Send redstone pulse to altar (verify integrator API in docs)
    integrator.setOutput(altar.redstone_side, true)
    sleep(0.1) -- Brief pulse
    integrator.setOutput(altar.redstone_side, false)
end

function automation.monitorCrafting(altar, seed, quantity)
    local start_time = os.clock() -- Verify timing API in docs
    local expected_duration = seed.craft_time
    
    while true do
        local elapsed = os.clock() - start_time
        local progress = math.min(elapsed / expected_duration, 1.0)
        
        gui.updateProgress(progress)
        
        -- Check if crafting complete (verify completion detection)
        if automation.isCraftComplete(altar) then
            automation.collectResults(altar, seed, quantity)
            break
        end
        
        -- Timeout check
        if elapsed > expected_duration * 2 then
            error("Crafting timeout exceeded")
        end
        
        sleep(1) -- Verify sleep function in docs
    end
end
```

## API Integration

### ME Bridge Interface

> **⚠️ Code Disclaimer:** ME Bridge API usage examples are theoretical. Advanced Peripherals API calls and peripheral interactions should be verified against Advanced Peripherals documentation and `docs/CCTweaked.md` for proper implementation patterns.

```lua
-- me_interface.lua - ME Bridge API wrapper (THEORETICAL EXAMPLE)
local me_interface = {}

function me_interface.init()
    -- Verify ME Bridge peripheral detection in docs
    me_interface.bridge = peripheral.find("meBridge")
    if not me_interface.bridge then
        error("ME Bridge not found")
    end
end

function me_interface.listItems()
    -- Verify Advanced Peripherals ME Bridge API
    return me_interface.bridge.listItems()
end

function me_interface.getItemCount(item_name)
    local items = me_interface.listItems()
    for _, item in ipairs(items) do
        if item.name == item_name then
            return item.amount
        end
    end
    return 0
end

function me_interface.exportItem(item_name, count, target_peripheral)
    -- Verify exportItemToPeripheral API structure
    local item_filter = {
        name = item_name,
        count = count
    }
    
    return me_interface.bridge.exportItemToPeripheral(
        item_filter,
        target_peripheral
    )
end

function me_interface.importItem(item_name, count, source_peripheral)
    -- Verify importItemFromPeripheral API structure  
    local item_filter = {
        name = item_name,
        count = count
    }
    
    return me_interface.bridge.importItemFromPeripheral(
        item_filter,
        source_peripheral
    )
end
```

### Peripheral Management

> **⚠️ Code Disclaimer:** All remaining code examples in this document are theoretical design templates only. Verify all API calls, peripheral interactions, and Lua syntax against `docs/CCTweaked.md` before implementation.

```lua
-- Peripheral discovery and management (THEORETICAL EXAMPLE)
function automation.discoverPeripherals()
    local peripherals = {
        monitors = {},
        pedestals = {},
        altars = {}
    }
    
    for _, name in ipairs(peripheral.getNames()) do
        local ptype = peripheral.getType(name)
        
        if ptype == "monitor" then
            table.insert(peripherals.monitors, name)
        elseif ptype == "inventory" then
            table.insert(peripherals.pedestals, name)
        end
    end
    
    return peripherals
end
```

## Error Handling

> **⚠️ Code Disclaimer:** Error handling patterns are theoretical examples only.

### Comprehensive Error Management

```lua
-- Error handling framework
local error_handler = {}

function error_handler.init()
    error_handler.log = {}
end

function error_handler.handleError(operation, error_msg)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_entry = {
        timestamp = timestamp,
        operation = operation,
        error = error_msg
    }
    
    table.insert(error_handler.log, log_entry)
    
    -- Display user-friendly error
    gui.showError(error_handler.getUserMessage(operation, error_msg))
    
    -- Log to file
    error_handler.writeToLog(log_entry)
end

function error_handler.getUserMessage(operation, error_msg)
    local messages = {
        ["me_network"] = "ME Network connection lost. Check ME Bridge.",
        ["missing_ingredients"] = "Required ingredients not available in storage.",
        ["altar_busy"] = "All altars are currently in use. Please wait.",
        ["peripheral_error"] = "Hardware connection issue. Check wiring."
    }
    
    return messages[operation] or "An unexpected error occurred: " .. error_msg
end
```

## Extensibility

### Adding New Seeds

```lua
-- Easy seed addition system
function database.addSeed(seed_data)
    -- Validate seed data structure
    if not seed_data.id or not seed_data.ingredients then
        error("Invalid seed data structure")
    end
    
    -- Check for duplicates
    if database.getSeed(seed_data.id) then
        error("Seed ID already exists: " .. seed_data.id)
    end
    
    -- Add to database
    table.insert(database.seeds, seed_data)
    
    -- Save to file
    database.save()
end

-- Example usage:
database.addSeed({
    id = "custom_seeds",
    name = "Custom Seeds",
    category = "resource",
    tier = 2,
    ingredients = {
        {item = "minecraft:custom_item", count = 1},
        {item = "mysticalagriculture:prudentium_essence", count = 8},
        {item = "mysticalagriculture:prosperity_seed_base", count = 1}
    },
    output = {item = "mysticalagriculture:custom_seeds", count = 1},
    craft_time = 40
})
```

### Configuration Management

```lua
-- Dynamic configuration updates
function config.update(key, value)
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end
    
    local current = config
    for i = 1, #keys - 1 do
        current = current[keys[i]]
    end
    current[keys[#keys]] = value
    
    config.save()
end
```

## Troubleshooting

### Common Issues and Solutions

**Issue: ME Bridge not responding**
```lua
-- Diagnostic function
function diagnostics.checkMEBridge()
    local bridge = peripheral.find("meBridge")
    if not bridge then
        return false, "ME Bridge peripheral not found"
    end
    
    local success, items = pcall(bridge.listItems)
    if not success then
        return false, "ME Bridge API call failed"
    end
    
    return true, "ME Bridge operational"
end
```

**Issue: Altar not activating**
```lua
function diagnostics.checkAltar(altar_name)
    local altar = config.altars[altar_name]
    
    -- Check redstone integrator connectivity
    local integrator = peripheral.wrap(altar.redstone_integrator)
    local integrator_working = integrator ~= nil
    
    -- Check pedestal connectivity
    local connected_pedestals = 0
    for _, pedestal in ipairs(altar.pedestals) do
        if peripheral.isPresent(pedestal) then
            connected_pedestals = connected_pedestals + 1
        end
    end
    
    return {
        integrator_connected = integrator_working,
        pedestals_connected = connected_pedestals,
        expected_pedestals = 8
    }
end
```

### Debug Mode

```lua
-- Debug configuration
config.debug = {
    enabled = false,
    log_level = "INFO", -- DEBUG, INFO, WARN, ERROR
    show_api_calls = false
}

function debug.log(level, message)
    if not config.debug.enabled then return end
    
    local timestamp = os.date("%H:%M:%S")
    local log_msg = string.format("[%s] %s: %s", timestamp, level, message)
    
    print(log_msg)
    
    -- Write to debug file
    local file = fs.open("debug.log", "a")
    file.writeLine(log_msg)
    file.close()
end
```

## Performance Optimization

### Caching and Optimization

```lua
-- ME Network query caching
local cache = {
    items = {},
    last_update = 0,
    ttl = 5 -- seconds
}

function me_interface.getCachedItems()
    local current_time = os.clock()
    
    if current_time - cache.last_update > cache.ttl then
        cache.items = me_interface.listItems()
        cache.last_update = current_time
    end
    
    return cache.items
end

-- Asynchronous processing
function automation.processAsync(func, callback)
    local co = coroutine.create(func)
    
    local function resume()
        local success, result = coroutine.resume(co)
        
        if coroutine.status(co) == "dead" then
            callback(success, result)
        else
            os.startTimer(0.05)
        end
    end
    
    resume()
end
```

## References

### API Documentation Links

- **CC:Tweaked Documentation**: https://tweaked.cc/
  - Monitor API: https://tweaked.cc/module/monitor.html
  - Peripheral API: https://tweaked.cc/module/peripheral.html
  - Redstone API: https://tweaked.cc/module/redstone.html

- **Advanced Peripherals**: https://docs.advanced-peripherals.de/latest/
  - ME Bridge: https://docs.advanced-peripherals.de/latest/peripherals/me_bridge/
  - Redstone Integrator: https://docs.advanced-peripherals.de/latest/peripherals/redstone_integrator/

- **MysticalAgriculture**: https://github.com/BlakeBr0/MysticalAgriculture
  - Wiki: https://github.com/BlakeBr0/MysticalAgriculture/wiki

- **Applied Energistics 2**: https://appliedenergistics.github.io/
  - ME System Guide: https://appliedenergistics.github.io/guides/me-system-basics

### Code Examples Repository

All example code and templates are available at:
`https://github.com/[username]/mystical-agriculture-automation`

### Support and Community

- CC:Tweaked Discord: https://discord.gg/H2UyJXe
- Advanced Peripherals Discord: https://discord.gg/xxx
- ATM Discord: https://discord.gg/allthemods

---

## License

This project is released under the MIT License. See LICENSE file for details.

## Contributing

Contributions are welcome! Please read CONTRIBUTING.md for guidelines on submitting improvements and bug fixes.

---

*This README provides comprehensive guidance for implementing a complete MysticalAgriculture automation system. Follow the sections in order for proper implementation, and refer to the troubleshooting section for common issues.*