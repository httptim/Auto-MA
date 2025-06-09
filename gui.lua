-- GUI Module
-- Handles monitor display and touch input

local gui = {}
local monitor = nil
local config = nil
local me = nil
local seeds = nil

-- Display dimensions
local width, height = 0, 0

-- GUI state
local buttons = {}
local currentScreen = "main"
local currentPage = 1
local totalPages = 1
local seedsPerPage = 1

-- Initialize GUI
function gui.init(cfg, meModule, seedsData)
    config = cfg
    me = meModule
    seeds = seedsData
    
    -- Connect to monitor
    monitor = peripheral.wrap(config.monitor)
    if not monitor then
        error("Failed to connect to monitor: " .. config.monitor)
    end
    
    -- Set up monitor
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    
    -- Get dimensions
    width, height = monitor.getSize()
    
    print("GUI initialized on " .. width .. "x" .. height .. " monitor")
    return true
end

-- Clear screen
local function clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Draw a button
local function drawButton(x, y, w, h, text, bgColor, textColor)
    monitor.setBackgroundColor(bgColor)
    monitor.setTextColor(textColor)
    
    -- Fill button area
    for dy = 0, h - 1 do
        monitor.setCursorPos(x, y + dy)
        monitor.write(string.rep(" ", w))
    end
    
    -- Center text
    local textX = x + math.floor((w - #text) / 2)
    local textY = y + math.floor(h / 2)
    monitor.setCursorPos(textX, textY)
    monitor.write(text)
    
    -- Store button for click detection
    table.insert(buttons, {
        x = x,
        y = y,
        w = w,
        h = h,
        text = text,
        data = nil
    })
    
    return #buttons -- Return button index
end

-- Draw header
local function drawHeader(title)
    local headerColor = colors.blue
    if config.settings and config.settings.colors and config.settings.colors.header then
        headerColor = config.settings.colors.header
    end
    monitor.setBackgroundColor(headerColor)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1, 1)
    monitor.write(string.rep(" ", width))
    
    local titleX = math.floor((width - #title) / 2)
    monitor.setCursorPos(titleX, 1)
    monitor.write(title)
end

-- Show main screen with seed grid
function gui.showMainScreen(page)
    clear()
    buttons = {}
    currentScreen = "main"
    currentPage = page or currentPage or 1
    
    drawHeader("MysticalAgriculture Automation")
    
    -- Calculate grid layout
    local buttonWidth = 8
    local buttonHeight = 3
    local spacing = 1
    local cols = math.floor((width - spacing) / (buttonWidth + spacing))
    local rows = math.floor((height - 5) / (buttonHeight + spacing)) -- Leave room for navigation
    
    -- Calculate pagination
    seedsPerPage = cols * rows
    totalPages = math.ceil(#seeds.order / seedsPerPage)
    currentPage = math.max(1, math.min(currentPage, totalPages))
    
    -- Calculate starting index for this page
    local startIndex = (currentPage - 1) * seedsPerPage + 1
    local endIndex = math.min(startIndex + seedsPerPage - 1, #seeds.order)
    
    -- Draw seed buttons
    local seedIndex = startIndex
    local y = 3
    
    for row = 1, rows do
        local x = spacing
        
        for col = 1, cols do
            if seedIndex > endIndex then break end
            
            local seedId = seeds.order[seedIndex]
            if seedId then
                local seed = seeds[seedId]
                if seed then
                    -- Check availability
                    local canCraft = me.checkIngredients(seed.ingredients, 1)
                    -- Use default colors if settings not present
                    local bgColor = canCraft and colors.green or colors.red
                    if config.settings and config.settings.colors then
                        bgColor = canCraft and config.settings.colors.available or config.settings.colors.unavailable
                    end
                    
                    -- Draw button
                    local btnIndex = drawButton(x, y, buttonWidth, buttonHeight, seed.shortName or seed.name:sub(1, 6), bgColor, colors.white)
                    buttons[btnIndex].data = {type = "seed", id = seedId}
                end
            end
            
            x = x + buttonWidth + spacing
            seedIndex = seedIndex + 1
        end
        
        y = y + buttonHeight + spacing
    end
    
    -- Navigation buttons
    local navY = height - 3
    monitor.setBackgroundColor(colors.black)
    
    -- Previous button
    if currentPage > 1 then
        local btnIndex = drawButton(2, navY, 10, 2, "< Previous", colors.lightGray, colors.black)
        buttons[btnIndex].data = {type = "nav", action = "prev"}
    end
    
    -- Page indicator
    monitor.setCursorPos(math.floor(width/2) - 5, navY)
    monitor.setTextColor(colors.white)
    monitor.write("Page " .. currentPage .. "/" .. totalPages)
    
    -- Next button
    if currentPage < totalPages then
        local btnIndex = drawButton(width - 11, navY, 10, 2, "Next >", colors.lightGray, colors.black)
        buttons[btnIndex].data = {type = "nav", action = "next"}
    end
    
    -- Status bar
    monitor.setCursorPos(1, height)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(" ", width))
    monitor.setCursorPos(2, height)
    monitor.write("Touch a seed to craft | Press Q on computer to quit")
end

-- Show quantity selector
function gui.showQuantitySelector(seed, quantity)
    clear()
    buttons = {}
    currentScreen = "quantity"
    
    drawHeader(seed.name)
    
    -- Check max craftable
    local canCraft, missing = me.checkIngredients(seed.ingredients, quantity)
    local maxCraftable = 64
    
    if not canCraft then
        -- Calculate max we can make
        for i = quantity, 1, -1 do
            if me.checkIngredients(seed.ingredients, i) then
                maxCraftable = i
                break
            end
        end
    end
    
    -- Display ingredients needed
    local y = 3
    monitor.setCursorPos(2, y)
    monitor.write("Ingredients for " .. quantity .. " seed" .. (quantity > 1 and "s:" or ":"))
    
    y = y + 2
    for _, ing in ipairs(seed.ingredients) do
        monitor.setCursorPos(4, y)
        local displayName = me.getItemDisplayName(ing.name)
        local needed = ing.count * quantity
        local available = me.getItemCount(ing.name)
        
        monitor.setTextColor(available >= needed and colors.lime or colors.red)
        monitor.write(string.format("%dx %s (have %d)", needed, displayName, available))
        y = y + 1
    end
    
    -- Quantity controls
    y = y + 2
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2, y)
    monitor.write("Quantity: " .. quantity .. " (max: " .. maxCraftable .. ")")
    
    -- Adjustment buttons
    y = y + 2
    local btnX = 2
    
    local btn = drawButton(btnX, y, 4, 3, "-5", colors.red, colors.white)
    buttons[btn].data = {type = "adjust", action = "-5"}
    btnX = btnX + 5
    
    btn = drawButton(btnX, y, 4, 3, "-1", colors.orange, colors.white)
    buttons[btn].data = {type = "adjust", action = "-1"}
    btnX = btnX + 5
    
    btn = drawButton(btnX, y, 4, 3, "+1", colors.green, colors.white)
    buttons[btn].data = {type = "adjust", action = "+1"}
    btnX = btnX + 5
    
    btn = drawButton(btnX, y, 4, 3, "+5", colors.lime, colors.white)
    buttons[btn].data = {type = "adjust", action = "+5"}
    
    -- Craft/Cancel buttons
    y = y + 4
    btn = drawButton(2, y, 12, 3, "CRAFT", canCraft and colors.green or colors.gray, colors.white)
    buttons[btn].data = {type = "craft"}
    
    btn = drawButton(16, y, 12, 3, "CANCEL", colors.red, colors.white)
    buttons[btn].data = {type = "cancel"}
end

-- Show progress bar
function gui.showProgress(seed, progress)
    print("DEBUG GUI: showProgress called with progress=" .. tostring(progress))
    if not monitor then
        print("ERROR: Monitor is nil!")
        return
    end
    
    clear()
    buttons = {}
    currentScreen = "crafting"
    
    drawHeader("Crafting: " .. seed.name)
    
    -- Progress bar
    local barY = math.floor(height / 2) - 1
    local barWidth = width - 4
    local filled = math.floor(barWidth * progress)
    
    print(string.format("DEBUG GUI: Drawing progress bar - width=%d, filled=%d", barWidth, filled))
    
    monitor.setCursorPos(2, barY)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(" ", barWidth))
    
    monitor.setCursorPos(2, barY)
    monitor.setBackgroundColor(colors.lime)
    monitor.write(string.rep(" ", filled))
    
    -- Progress text
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2, barY + 2)
    monitor.write(string.format("Progress: %d%%", math.floor(progress * 100)))
    
    -- Time remaining
    if seed.time then
        local remaining = math.ceil(seed.time * (1 - progress))
        monitor.setCursorPos(2, barY + 3)
        monitor.write("Time remaining: " .. remaining .. "s")
    end
end

-- Show error message
function gui.showError(message)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.red)
    
    local y = height - 2
    monitor.setCursorPos(1, y)
    monitor.write(string.rep(" ", width))
    monitor.setCursorPos(2, y)
    monitor.write("Error: " .. message)
end

-- Show info message
function gui.showMessage(message)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.yellow)
    
    local y = height - 2
    monitor.setCursorPos(1, y)
    monitor.write(string.rep(" ", width))
    monitor.setCursorPos(2, y)
    monitor.write(message)
end

-- Handle touch events
function gui.handleTouch(x, y, screen)
    -- Find which button was pressed
    for i, btn in ipairs(buttons) do
        if x >= btn.x and x < btn.x + btn.w and
           y >= btn.y and y < btn.y + btn.h then
            -- Handle navigation buttons
            if btn.data and btn.data.type == "nav" then
                if btn.data.action == "prev" then
                    gui.showMainScreen(currentPage - 1)
                elseif btn.data.action == "next" then
                    gui.showMainScreen(currentPage + 1)
                end
                return nil -- Don't return navigation as action
            end
            return btn.data
        end
    end
    
    return nil
end

-- Update availability colors on main screen
function gui.updateAvailability()
    if currentScreen ~= "main" then return end
    
    -- Just redraw the main screen to update colors
    gui.showMainScreen(currentPage)
end

return gui