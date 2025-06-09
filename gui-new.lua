-- GUI Module - Rewritten
-- Clean implementation with working progress bar

local gui = {}
local monitor = nil
local config = nil
local me = nil
local seeds = nil

-- Display dimensions - will be set during init
local width = 0
local height = 0

-- GUI state
local buttons = {}
local currentScreen = "main"
local currentPage = 1
local totalPages = 1
local seedsPerPage = 1

-- Color scheme
local theme = {
    background = colors.black,
    header = colors.blue,
    headerText = colors.white,
    button = colors.gray,
    buttonText = colors.white,
    buttonActive = colors.lime,
    progressBar = colors.gray,
    progressFill = colors.lime,
    error = colors.red,
    success = colors.green,
    info = colors.lightBlue
}

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
    monitor.setBackgroundColor(theme.background)
    monitor.clear()
    
    -- Get dimensions ONCE during init
    width, height = monitor.getSize()
    print("GUI initialized on " .. width .. "x" .. height .. " monitor")
    
    -- Calculate seeds per page
    seedsPerPage = math.floor((height - 6) / 3)
    
    return true
end

-- Clear screen
local function clear()
    monitor.setBackgroundColor(theme.background)
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Draw header
local function drawHeader(title)
    monitor.setBackgroundColor(theme.header)
    monitor.setTextColor(theme.headerText)
    monitor.setCursorPos(1, 1)
    monitor.write(string.rep(" ", width))
    monitor.setCursorPos(math.floor((width - #title) / 2), 1)
    monitor.write(title)
    monitor.setBackgroundColor(theme.background)
end

-- Draw a button
local function drawButton(x, y, w, h, text, bgColor, textColor)
    bgColor = bgColor or theme.button
    textColor = textColor or theme.buttonText
    
    monitor.setBackgroundColor(bgColor)
    monitor.setTextColor(textColor)
    
    for i = 0, h - 1 do
        monitor.setCursorPos(x, y + i)
        monitor.write(string.rep(" ", w))
    end
    
    -- Center text
    local textY = y + math.floor(h / 2)
    local textX = x + math.floor((w - #text) / 2)
    monitor.setCursorPos(textX, textY)
    monitor.write(text)
    
    monitor.setBackgroundColor(theme.background)
end

-- Register a button
local function addButton(id, x, y, w, h, data)
    buttons[id] = {
        x = x,
        y = y,
        w = w,
        h = h,
        data = data
    }
end

-- Show main screen with seed grid
function gui.showMainScreen()
    clear()
    buttons = {}
    currentScreen = "main"
    
    drawHeader("MysticalAgriculture Automation")
    
    -- Use order from seeds if available, otherwise build list
    local seedList = {}
    if seeds.order then
        -- Use predefined order
        for _, id in ipairs(seeds.order) do
            if seeds[id] then
                table.insert(seedList, {id = id, seed = seeds[id]})
            end
        end
    else
        -- Fallback to building list
        for id, seed in pairs(seeds) do
            if id ~= "order" then  -- Skip the order field itself
                table.insert(seedList, {id = id, seed = seed})
            end
        end
        -- Sort by name
        table.sort(seedList, function(a, b)
            local aName = a.seed.name or a.id
            local bName = b.seed.name or b.id
            return aName < bName
        end)
    end
    
    -- Grid layout calculations
    local buttonWidth = 10
    local buttonHeight = 3
    local spacing = 2
    local cols = math.floor((width - spacing) / (buttonWidth + spacing))
    local rows = math.floor((height - 8) / (buttonHeight + spacing))
    seedsPerPage = cols * rows
    
    -- Calculate pagination
    totalPages = math.ceil(#seedList / seedsPerPage)
    local startIdx = (currentPage - 1) * seedsPerPage + 1
    local endIdx = math.min(currentPage * seedsPerPage, #seedList)
    
    -- Draw seed grid
    local seedIndex = startIdx
    local y = 3
    
    for row = 1, rows do
        local x = spacing
        
        for col = 1, cols do
            if seedIndex > endIdx then break end
            
            local item = seedList[seedIndex]
            if item then
                local seed = item.seed
                local canCraft, _ = me.checkIngredients(seed.ingredients, 1)
                
                -- Determine color (green if available, red if not)
                local bgColor = canCraft and colors.green or colors.red
                
                -- Use short name or truncate regular name
                local displayName = seed.shortName or seed.name:sub(1, 8)
                
                -- Draw button
                drawButton(x, y, buttonWidth, buttonHeight, displayName, bgColor, colors.white)
                
                -- Register button
                addButton("seed_" .. seedIndex, x, y, buttonWidth, buttonHeight, {type = "seed", id = item.id})
            end
            
            x = x + buttonWidth + spacing
            seedIndex = seedIndex + 1
        end
        
        y = y + buttonHeight + spacing
    end
    
    -- Navigation buttons
    local navY = height - 3
    
    if currentPage > 1 then
        drawButton(spacing, navY, 15, 3, "< Previous", colors.blue, colors.white)
        addButton("prev", spacing, navY, 15, 3, {type = "page", action = "prev"})
    end
    
    if currentPage < totalPages then
        drawButton(width - 15 - spacing, navY, 15, 3, "Next >", colors.blue, colors.white)
        addButton("next", width - 15 - spacing, navY, 15, 3, {type = "page", action = "next"})
    end
    
    -- Page indicator
    if totalPages > 1 then
        local pageText = "Page " .. currentPage .. " of " .. totalPages
        monitor.setCursorPos(math.floor((width - #pageText) / 2), navY + 1)
        monitor.setTextColor(colors.white)
        monitor.write(pageText)
    end
end

-- Show seed details
function gui.showSeedDetails(seed)
    clear()
    buttons = {}
    currentScreen = "details"
    
    drawHeader(seed.name)
    
    -- Current stock section
    local y = 3
    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.yellow)
    monitor.write("Current Stock:")
    monitor.setTextColor(colors.white)
    
    local currentStock = me.getItemCount(seed.output or ("mysticalagriculture:" .. seed.id))
    monitor.setCursorPos(4, y + 1)
    monitor.write(currentStock .. " seeds in ME system")
    
    -- Separator line
    y = y + 3
    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.gray)
    monitor.write(string.rep("-", width - 4))
    
    -- Ingredients section
    y = y + 2
    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.yellow)
    monitor.write("Ingredients Required (per seed):")
    y = y + 2
    
    -- Check what we have vs what we need
    local canCraft = true
    local maxCraftable = 999999  -- Start with a high number
    
    for _, ingredient in ipairs(seed.ingredients) do
        local have = me.getItemCount(ingredient.name)
        local need = ingredient.count
        local craftable = math.floor(have / need)
        
        -- Track minimum craftable
        if craftable < maxCraftable then
            maxCraftable = craftable
        end
        
        -- Determine color based on availability
        local textColor = colors.white
        local statusSymbol = " "
        if have >= need then
            textColor = colors.lime
            statusSymbol = "+"
        else
            textColor = colors.red
            statusSymbol = "-"
            canCraft = false
        end
        
        -- Display ingredient info with better formatting
        monitor.setCursorPos(4, y)
        monitor.setTextColor(textColor)
        monitor.write(statusSymbol .. " ")
        
        -- Extract readable name
        local displayName = ingredient.displayName or ingredient.name:match("([^:]+)$") or ingredient.name
        -- Capitalize first letter
        displayName = displayName:sub(1,1):upper() .. displayName:sub(2)
        displayName = displayName:gsub("_", " ")
        
        monitor.write(displayName)
        
        -- Right-align the numbers
        local numbers = string.format("%d / %d", have, need)
        local xPos = width - #numbers - 2
        monitor.setCursorPos(xPos, y)
        monitor.write(numbers)
        
        y = y + 1
    end
    
    -- Max craftable section
    y = y + 2
    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.yellow)
    monitor.write("Maximum Craftable: ")
    monitor.setTextColor(canCraft and colors.lime or colors.red)
    monitor.write(maxCraftable .. " seeds")
    
    -- Craft time
    y = y + 2
    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.yellow)
    monitor.write("Craft Time: ")
    monitor.setTextColor(colors.white)
    monitor.write("~5-7 seconds per seed")
    
    -- Buttons at bottom of screen
    local buttonY = height - 4
    local buttonWidth = 12
    local buttonHeight = 3
    
    -- Back button (bottom left)
    drawButton(2, buttonY, buttonWidth, buttonHeight, "Back", colors.gray, colors.white)
    addButton("back", 2, buttonY, buttonWidth, buttonHeight, {type = "back"})
    
    -- Craft button (bottom right)
    if canCraft then
        drawButton(width - buttonWidth - 2, buttonY, buttonWidth, buttonHeight, "Craft", colors.green, colors.white)
        addButton("craft", width - buttonWidth - 2, buttonY, buttonWidth, buttonHeight, {type = "craft", seed = seed})
    else
        drawButton(width - buttonWidth - 2, buttonY, buttonWidth, buttonHeight, "Can't Craft", colors.red, colors.white)
    end
end

-- Show quantity selector
function gui.showQuantitySelector(seed, quantity)
    clear()
    buttons = {}
    currentScreen = "quantity"
    
    drawHeader("Select Quantity: " .. seed.name)
    
    -- Quantity display
    local qtyText = "Quantity: " .. quantity
    monitor.setCursorPos(math.floor((width - #qtyText) / 2), 8)
    monitor.setTextColor(colors.white)
    monitor.write(qtyText)
    
    -- Adjustment buttons
    local btnY = 12
    drawButton(10, btnY, 8, 3, "-5", theme.button)
    addButton("minus5", 10, btnY, 8, 3, {type = "adjust", action = "-5"})
    
    drawButton(20, btnY, 8, 3, "-1", theme.button)
    addButton("minus1", 20, btnY, 8, 3, {type = "adjust", action = "-1"})
    
    drawButton(width - 28, btnY, 8, 3, "+1", theme.button)
    addButton("plus1", width - 28, btnY, 8, 3, {type = "adjust", action = "+1"})
    
    drawButton(width - 18, btnY, 8, 3, "+5", theme.button)
    addButton("plus5", width - 18, btnY, 8, 3, {type = "adjust", action = "+5"})
    
    -- Craft and Cancel buttons
    drawButton(math.floor(width/2) - 20, 20, 18, 3, "Craft", theme.buttonActive)
    addButton("craft", math.floor(width/2) - 20, 20, 18, 3, {type = "craft"})
    
    drawButton(math.floor(width/2) + 2, 20, 18, 3, "Cancel", theme.button)
    addButton("cancel", math.floor(width/2) + 2, 20, 18, 3, {type = "cancel"})
end

-- Show progress bar with working implementation
function gui.showProgress(seed, progress, status)
    clear()
    buttons = {}
    currentScreen = "crafting"
    
    drawHeader("Crafting: " .. seed.name)
    
    -- Status text
    monitor.setCursorPos(2, 4)
    monitor.setTextColor(colors.white)
    monitor.write(status or "Crafting...")
    
    -- Calculate progress bar position and size
    local barY = math.floor(height / 2)
    local barX = 4
    local barWidth = width - 8
    local barHeight = 3
    
    -- Draw progress bar background
    monitor.setBackgroundColor(theme.progressBar)
    for i = 0, barHeight - 1 do
        monitor.setCursorPos(barX, barY + i)
        monitor.write(string.rep(" ", barWidth))
    end
    
    -- Draw progress bar fill
    local fillWidth = math.floor(barWidth * progress)
    if fillWidth > 0 then
        monitor.setBackgroundColor(theme.progressFill)
        for i = 0, barHeight - 1 do
            monitor.setCursorPos(barX, barY + i)
            monitor.write(string.rep(" ", fillWidth))
        end
    end
    
    -- Draw percentage text
    monitor.setBackgroundColor(theme.background)
    monitor.setTextColor(colors.white)
    local percentText = math.floor(progress * 100) .. "%"
    monitor.setCursorPos(math.floor((width - #percentText) / 2), barY + barHeight + 2)
    monitor.write(percentText)
    
    -- Draw border around progress bar
    monitor.setTextColor(colors.gray)
    -- Top border
    monitor.setCursorPos(barX - 1, barY - 1)
    monitor.write("+" .. string.rep("-", barWidth) .. "+")
    -- Side borders
    for i = 0, barHeight - 1 do
        monitor.setCursorPos(barX - 1, barY + i)
        monitor.write("|")
        monitor.setCursorPos(barX + barWidth, barY + i)
        monitor.write("|")
    end
    -- Bottom border
    monitor.setCursorPos(barX - 1, barY + barHeight)
    monitor.write("+" .. string.rep("-", barWidth) .. "+")
    
    monitor.setBackgroundColor(theme.background)
end

-- Show message
function gui.showMessage(msg)
    -- Save current cursor position
    local oldBg = monitor.getBackgroundColor()
    local oldText = monitor.getTextColor()
    
    -- Show message at bottom
    monitor.setCursorPos(2, height)
    monitor.setBackgroundColor(theme.background)
    monitor.setTextColor(theme.info)
    monitor.clearLine()
    monitor.write(msg)
    
    -- Restore colors
    monitor.setBackgroundColor(oldBg)
    monitor.setTextColor(oldText)
end

-- Show error
function gui.showError(msg)
    -- Save current cursor position
    local oldBg = monitor.getBackgroundColor()
    local oldText = monitor.getTextColor()
    
    -- Show error at bottom
    monitor.setCursorPos(2, height)
    monitor.setBackgroundColor(theme.background)
    monitor.setTextColor(theme.error)
    monitor.clearLine()
    monitor.write("ERROR: " .. msg)
    
    -- Restore colors
    monitor.setBackgroundColor(oldBg)
    monitor.setTextColor(oldText)
end

-- Handle touch events
function gui.handleTouch(x, y, screen)
    for id, btn in pairs(buttons) do
        if x >= btn.x and x < btn.x + btn.w and
           y >= btn.y and y < btn.y + btn.h then
            -- Button clicked
            if btn.data.type == "page" then
                if btn.data.action == "prev" then
                    currentPage = math.max(1, currentPage - 1)
                elseif btn.data.action == "next" then
                    currentPage = math.min(totalPages, currentPage + 1)
                end
                gui.showMainScreen()
            elseif btn.data.type == "back" then
                -- Return the back action to the main handler
                return btn.data
            elseif btn.data.type == "craft" and screen == "details" then
                -- From details screen, go to quantity selector
                return {type = "quantity", seed = btn.data.seed}
            else
                return btn.data
            end
        end
    end
    return nil
end

-- Update availability (refresh main screen if needed)
function gui.updateAvailability()
    if currentScreen == "main" then
        gui.showMainScreen()
    end
end

return gui