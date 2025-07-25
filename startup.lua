-- MysticalAgriculture Automation System - Rewritten
-- Clean implementation with working progress tracking

-- Constants
local CONFIG_FILE = "config.lua"
local VERSION = "2.0.0"

-- Global modules (loaded after config)
local config = nil
local me = nil
local altar = nil
local gui = nil
local seeds = nil

-- Main program state
local state = {
    crafting = false,
    currentSeed = nil,
    currentQuantity = 0,
    craftStartTime = 0,
    screen = "main",
    updateTimer = nil
}

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
    
    -- Select ME Bridge - handle new naming pattern (me_bridge_#)
    local meBridges = {}
    
    -- Look for ME bridges with various possible type names
    for _, name in ipairs(peripheral.getNames()) do
        local pType = peripheral.getType(name)
        -- Check if it's an ME Bridge by type pattern
        if pType and (pType == "meBridge" or pType:match("^me_bridge") or pType:match("^mebridge")) then
            table.insert(meBridges, name)
        end
    end
    
    if #meBridges > 0 then
        selectedConfig.meBridge = selectFromList("Select ME Bridge:", meBridges)
    else
        error("No ME Bridge found! Please attach an ME Bridge from Advanced Peripherals.")
    end
    
    -- Select inventories for altar and pedestals
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
    file.write("    }\n")
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
    
    -- Load modules
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

-- Craft monitoring function - runs in parallel
local function monitorCraft()
    while state.crafting do
        -- Update progress
        local progress = altar.getProgress()
        local status = altar.getStatus()
        
        -- Update GUI
        gui.showProgress(state.currentSeed, progress, status)
        
        -- Check if complete
        if altar.checkComplete() then
            state.crafting = false
            gui.showMessage("Craft complete!")
            sleep(2)
            state.screen = "main"
            gui.showMainScreen()
            break
        end
        
        -- Check for timeout
        local elapsed = os.clock() - state.craftStartTime
        if elapsed > ((state.currentSeed.time or 20) + 10) then
            state.crafting = false
            gui.showError("Craft timeout!")
            altar.cleanup()
            sleep(2)
            state.screen = "main"
            gui.showMainScreen()
            break
        end
        
        -- Small delay to not spam updates
        sleep(0.2)  -- Faster updates for smoother progress bar
    end
end

-- Start crafting
local function startCraft(seed, quantity)
    -- Validate seed has required fields
    if not seed.ingredients then
        gui.showError("Invalid seed: no ingredients defined")
        sleep(2)
        state.screen = "main"
        gui.showMainScreen()
        return
    end
    
    -- Check ingredients
    local canCraft, missing = me.checkIngredients(seed.ingredients, quantity)
    
    if not canCraft then
        gui.showError("Missing: " .. missing)
        sleep(2)
        state.screen = "main"
        gui.showMainScreen()
        return
    end
    
    -- Set state
    state.crafting = true
    state.currentSeed = seed
    state.currentQuantity = quantity
    state.craftStartTime = os.clock()
    state.screen = "crafting"
    
    -- Start the craft
    local success, err = pcall(altar.startCraft, seed, quantity)
    if not success then
        gui.showError("Craft failed: " .. tostring(err))
        state.crafting = false
        sleep(2)
        state.screen = "main"
        gui.showMainScreen()
        return
    end
    
    -- Show initial progress
    gui.showProgress(seed, 0, "Starting craft...")
    
    -- Start monitoring in parallel
    parallel.waitForAny(
        monitorCraft,
        function()
            -- Keep main loop running for touch events
            while state.crafting do
                local event, p1, p2, p3 = os.pullEvent()
                if event == "monitor_touch" then
                    -- Show message that craft is in progress
                    gui.showMessage("Craft in progress...")
                elseif event == "key" and p1 == keys.q then
                    -- Allow canceling
                    state.crafting = false
                    altar.cancel()
                    gui.showMessage("Craft cancelled")
                    sleep(1)
                    state.screen = "main"
                    gui.showMainScreen()
                end
            end
        end
    )
    
    -- Ensure we're back to main screen after craft completes
    if state.screen == "crafting" then
        state.screen = "main"
        gui.showMainScreen()
    end
end

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
        
        -- Show seed details
        state.currentSeed = seed
        state.screen = "details"
        gui.showSeedDetails(seed)
        
    elseif state.screen == "details" and result then
        if result.type == "quantity" then
            -- From details, go to quantity selector
            state.currentQuantity = 1
            state.screen = "quantity"
            gui.showQuantitySelector(result.seed, 1)
        elseif result.type == "back" then
            -- Back to main
            state.screen = "main"
            state.currentSeed = nil
            gui.showMainScreen()
        end
        
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

-- Main event loop
local function main()
    -- Initial display
    gui.showMainScreen()
    
    -- Update timer for ingredient availability
    local updateTimer = os.startTimer(1)
    
    while true do
        local event, p1, p2, p3 = os.pullEvent()
        
        if event == "monitor_touch" then
            handleTouch(p2, p3)
            
        elseif event == "timer" and p1 == updateTimer then
            -- Update ingredient availability
            if state.screen == "main" and not state.crafting then
                gui.updateAvailability()
            end
            -- Restart timer
            updateTimer = os.startTimer(1)
            
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