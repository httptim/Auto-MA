-- MysticalAgriculture Automation System
-- Main startup file with setup wizard

-- Constants
local CONFIG_FILE = "config.lua"
local VERSION = "1.0.0"

-- Global modules (loaded after config)
local config = nil
local me = nil
local altar = nil
local gui = nil
local seeds = nil

-- Setup wizard functions
local function detectPeripherals()
    print("Detecting peripherals...")
    local peripherals = {}
    
    for _, name in ipairs(peripheral.getNames()) do
        local pType = peripheral.getType(name)
        if not peripherals[pType] then
            peripherals[pType] = {}
        end
        table.insert(peripherals[pType], name)
    end
    
    return peripherals
end

local function selectFromList(prompt, items)
    print("\n" .. prompt)
    for i, item in ipairs(items) do
        print(i .. ". " .. item)
    end
    
    while true do
        write("Select (1-" .. #items .. "): ")
        local choice = tonumber(read())
        if choice and choice >= 1 and choice <= #items then
            return items[choice]
        end
        print("Invalid selection. Please try again.")
    end
end

local function setupWizard()
    term.clear()
    term.setCursorPos(1, 1)
    print("=== MysticalAgriculture Automation Setup ===")
    print("Version " .. VERSION)
    print("")
    
    local peripherals = detectPeripherals()
    local selectedConfig = {}
    
    -- Select monitor
    if peripherals.monitor and #peripherals.monitor > 0 then
        selectedConfig.monitor = selectFromList("Select monitor for display:", peripherals.monitor)
    else
        error("No monitors found! Please attach a monitor.")
    end
    
    -- Select ME Bridge
    if peripherals.meBridge and #peripherals.meBridge > 0 then
        selectedConfig.meBridge = selectFromList("Select ME Bridge:", peripherals.meBridge)
    else
        error("No ME Bridge found! Please attach an ME Bridge from Advanced Peripherals.")
    end
    
    -- Select inventories for altar and pedestals
    -- MysticalAgriculture blocks might show as different types
    local inventories = {}
    
    -- Collect all inventory-like peripherals
    for pType, pList in pairs(peripherals) do
        -- Check for various inventory types
        if pType == "inventory" or 
           pType == "mysticalagriculture:inferium_altar" or
           pType == "mysticalagriculture:infusion_altar" or
           pType == "mysticalagriculture:awakening_altar" or
           pType == "mysticalagriculture:infusion_pedestal" or
           pType == "mysticalagriculture:awakening_pedestal" or
           pType:find("altar") or
           pType:find("pedestal") or
           pType:find("chest") or
           pType:find("barrel") then
            for _, name in ipairs(pList) do
                table.insert(inventories, name)
            end
        end
    end
    
    -- Debug: Show what we found
    print("\nFound " .. #inventories .. " inventory-like peripherals:")
    for pType, pList in pairs(peripherals) do
        if #pList > 0 then
            print("  " .. pType .. ": " .. #pList)
        end
    end
    
    if #inventories < 9 then
        print("\nDetected peripheral types:")
        for pType, _ in pairs(peripherals) do
            print("  - " .. pType)
        end
        error("Not enough inventories found! Need at least 9 (1 altar + 8 pedestals). Found: " .. #inventories)
    end
    
    print("\nNow we'll set up the altar and pedestals.")
    print("The altar should be the central inventory.")
    
    selectedConfig.altar = selectFromList("Select the ALTAR inventory:", inventories)
    
    -- Remove selected altar from list for pedestals
    local pedestalChoices = {}
    for _, inv in ipairs(inventories) do
        if inv ~= selectedConfig.altar then
            table.insert(pedestalChoices, inv)
        end
    end
    
    -- Select pedestals
    selectedConfig.pedestals = {}
    print("\nSelect 8 pedestals in order (starting from any position, going clockwise):")
    for i = 1, 8 do
        local pedestal = selectFromList("Select pedestal #" .. i .. ":", pedestalChoices)
        table.insert(selectedConfig.pedestals, pedestal)
        
        -- Remove from choices
        local newChoices = {}
        for _, p in ipairs(pedestalChoices) do
            if p ~= pedestal then
                table.insert(newChoices, p)
            end
        end
        pedestalChoices = newChoices
    end
    
    -- Select redstone integrator
    if peripherals.redstoneIntegrator and #peripherals.redstoneIntegrator > 0 then
        selectedConfig.redstoneIntegrator = selectFromList("Select Redstone Integrator for altar activation:", peripherals.redstoneIntegrator)
        
        -- Ask which side faces the altar
        print("\nWhich side of the Redstone Integrator faces the altar?")
        local sides = {"north", "south", "east", "west", "up", "down"}
        selectedConfig.redstoneSide = selectFromList("Select side:", sides)
    else
        error("No Redstone Integrator found! This is required for altar activation.")
    end
    
    return selectedConfig
end

local function saveConfig(configData)
    local file = fs.open("/mystical-automation/" .. CONFIG_FILE, "w")
    if not file then
        error("Failed to save configuration!")
    end
    
    file.write("-- MysticalAgriculture Automation Configuration\n")
    file.write("-- Generated by setup wizard\n\n")
    file.write("return {\n")
    file.write("    monitor = \"" .. configData.monitor .. "\",\n")
    file.write("    meBridge = \"" .. configData.meBridge .. "\",\n")
    file.write("    altar = \"" .. configData.altar .. "\",\n")
    file.write("    pedestals = {\n")
    for i, pedestal in ipairs(configData.pedestals) do
        file.write("        \"" .. pedestal .. "\",\n")
    end
    file.write("    },\n")
    file.write("    redstoneIntegrator = \"" .. configData.redstoneIntegrator .. "\",\n")
    file.write("    redstoneSide = \"" .. configData.redstoneSide .. "\"\n")
    file.write("}\n")
    
    file.close()
    print("\nConfiguration saved to /mystical-automation/" .. CONFIG_FILE)
end

-- Module loading
local function loadModules()
    -- Load configuration
    if not fs.exists("/mystical-automation/" .. CONFIG_FILE) then
        print("No configuration found. Starting setup wizard...")
        local configData = setupWizard()
        saveConfig(configData)
        print("\nPress any key to continue...")
        os.pullEvent("key")
    end
    
    -- Load config
    config = dofile("/mystical-automation/" .. CONFIG_FILE)
    if not config then
        error("Failed to load configuration!")
    end
    
    -- Load modules (using absolute paths)
    local baseDir = "/mystical-automation"
    me = dofile(baseDir .. "/me.lua")
    altar = dofile(baseDir .. "/altar.lua") 
    gui = dofile(baseDir .. "/gui.lua")
    seeds = dofile(baseDir .. "/seeds.lua")
    
    -- Initialize modules with config
    local success, err
    
    success, err = pcall(me.init, config)
    if not success then
        error("Failed to initialize ME system: " .. tostring(err))
    end
    
    success, err = pcall(altar.init, config, me)
    if not success then
        error("Failed to initialize altar system: " .. tostring(err))
    end
    
    success, err = pcall(gui.init, config, me, seeds)
    if not success then
        error("Failed to initialize GUI: " .. tostring(err))
    end
    
    print("All systems initialized successfully!")
end

-- Main program state
local state = {
    crafting = false,
    currentSeed = nil,
    currentQuantity = 0,
    craftStartTime = 0,
    screen = "main" -- main, quantity, crafting
}

-- Event handlers
local function handleTouch(x, y)
    if state.crafting then
        gui.showMessage("Craft in progress...")
        return
    end
    
    local result = gui.handleTouch(x, y, state.screen)
    
    if state.screen == "main" and result and result.type == "seed" then
        -- Check if we can craft this seed
        local seed = seeds[result.id]
        if not seed then
            gui.showError("Unknown seed: " .. result.id)
            return
        end
        
        -- Show quantity selector
        state.currentSeed = seed
        state.currentQuantity = 1
        state.screen = "quantity"
        gui.showQuantitySelector(seed, 1)
        
    elseif state.screen == "quantity" then
        if result.type == "adjust" then
            -- Adjust quantity
            local newQty = state.currentQuantity or 1
            if result.action == "+1" then newQty = newQty + 1
            elseif result.action == "-1" then newQty = math.max(1, newQty - 1)
            elseif result.action == "+5" then newQty = newQty + 5
            elseif result.action == "-5" then newQty = math.max(1, newQty - 5)
            end
            
            -- Cap at 64
            newQty = math.min(64, newQty)
            state.currentQuantity = newQty
            
            -- Update display
            gui.showQuantitySelector(state.currentSeed, newQty)
            
        elseif result.type == "craft" then
            -- Start crafting
            startCraft(state.currentSeed, state.currentQuantity)
            
        elseif result.type == "cancel" then
            -- Return to main screen
            state.screen = "main"
            state.currentSeed = nil
            state.currentQuantity = 0
            gui.showMainScreen()
        end
    end
end

function startCraft(seed, quantity)
    -- Check ingredients
    local canCraft, missing = me.checkIngredients(seed.ingredients, quantity)
    
    if not canCraft then
        gui.showError("Missing: " .. missing)
        sleep(2)
        state.screen = "main"
        gui.showMainScreen()
        return
    end
    
    -- Start the craft
    state.crafting = true
    state.craftStartTime = os.clock()
    state.screen = "crafting"
    
    -- Begin altar crafting
    local success, err = pcall(altar.startCraft, seed, quantity)
    if not success then
        gui.showError("Craft failed: " .. tostring(err))
        state.crafting = false
        state.screen = "main"
        gui.showMainScreen()
        return
    end
    
    -- Show progress
    gui.showProgress(seed, 0)
end

local function updateCraftProgress()
    if not state.crafting then return end
    
    local elapsed = os.clock() - state.craftStartTime
    local progress = math.min(1, elapsed / (state.currentSeed.time or 20))
    
    gui.showProgress(state.currentSeed, progress)
    
    -- Check if complete
    if altar.checkComplete() then
        state.crafting = false
        gui.showMessage("Craft complete!")
        sleep(1)
        state.screen = "main"
        gui.showMainScreen()
    elseif elapsed > ((state.currentSeed.time or 20) + 10) then
        -- Timeout
        state.crafting = false
        gui.showError("Craft timeout!")
        altar.cleanup()
        sleep(2)
        state.screen = "main"
        gui.showMainScreen()
    end
end

-- Main event loop
local function main()
    -- Initial display
    gui.showMainScreen()
    
    -- Start timer for updates
    local updateTimer = os.startTimer(0.5)
    
    while true do
        local event, p1, p2, p3 = os.pullEvent()
        
        if event == "monitor_touch" then
            handleTouch(p2, p3) -- p2=x, p3=y
            
        elseif event == "timer" and p1 == updateTimer then
            -- Update craft progress if needed
            updateCraftProgress()
            
            -- Update ingredient availability
            if state.screen == "main" and not state.crafting then
                gui.updateAvailability()
            end
            
            -- Restart timer
            updateTimer = os.startTimer(0.5)
            
        elseif event == "key" and p1 == keys.q then
            -- Quit
            gui.showMessage("Shutting down...")
            sleep(1)
            term.clear()
            term.setCursorPos(1, 1)
            print("MysticalAgriculture Automation stopped.")
            break
        end
    end
end

-- Error handling wrapper
local function safeMain()
    local success, err = pcall(function()
        loadModules()
        main()
    end)
    
    if not success then
        term.clear()
        term.setCursorPos(1, 1)
        print("FATAL ERROR:")
        print(err)
        print("")
        print("Press any key to exit...")
        os.pullEvent("key")
    end
end

-- Start the program
safeMain()