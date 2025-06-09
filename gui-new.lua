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
local colors = {
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
    monitor.setBackgroundColor(colors.background)
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
    monitor.setBackgroundColor(colors.background)
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Draw header
local function drawHeader(title)
    monitor.setBackgroundColor(colors.header)
    monitor.setTextColor(colors.headerText)
    monitor.setCursorPos(1, 1)
    monitor.write(string.rep(" ", width))
    monitor.setCursorPos(math.floor((width - #title) / 2), 1)
    monitor.write(title)
    monitor.setBackgroundColor(colors.background)
end

-- Draw a button
local function drawButton(x, y, w, h, text, bgColor, textColor)
    bgColor = bgColor or colors.button
    textColor = textColor or colors.buttonText
    
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
    
    monitor.setBackgroundColor(colors.background)
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

-- Show main screen with seed list
function gui.showMainScreen()
    clear()
    buttons = {}
    currentScreen = "main"
    
    drawHeader("MysticalAgriculture Automation")
    
    -- Get seeds list
    local seedList = {}
    for id, seed in pairs(seeds) do
        table.insert(seedList, {id = id, seed = seed})
    end
    
    -- Sort by tier then name
    table.sort(seedList, function(a, b)
        if a.seed.tier == b.seed.tier then
            return a.seed.name < b.seed.name
        end
        return a.seed.tier < b.seed.tier
    end)
    
    -- Calculate pagination
    totalPages = math.ceil(#seedList / seedsPerPage)
    local startIdx = (currentPage - 1) * seedsPerPage + 1
    local endIdx = math.min(currentPage * seedsPerPage, #seedList)
    
    -- Draw seeds
    local y = 3
    for i = startIdx, endIdx do
        local item = seedList[i]
        local seed = item.seed
        local canCraft = me.hasIngredients(seed.ingredients)
        
        -- Determine color
        local bgColor = canCraft and colors.buttonActive or colors.button
        
        -- Draw button
        drawButton(2, y, width - 4, 2, "T" .. seed.tier .. " - " .. seed.name, bgColor)
        
        -- Register button
        addButton("seed_" .. i, 2, y, width - 4, 2, {type = "seed", id = item.id})
        
        y = y + 3
    end
    
    -- Pagination
    if totalPages > 1 then
        local pageText = "Page " .. currentPage .. "/" .. totalPages
        monitor.setCursorPos(math.floor((width - #pageText) / 2), height - 1)
        monitor.write(pageText)
        
        if currentPage > 1 then
            drawButton(2, height - 1, 8, 1, "< Prev", colors.button)
            addButton("prev", 2, height - 1, 8, 1, {type = "page", action = "prev"})
        end
        
        if currentPage < totalPages then
            drawButton(width - 9, height - 1, 8, 1, "Next >", colors.button)
            addButton("next", width - 9, height - 1, 8, 1, {type = "page", action = "next"})
        end
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
    drawButton(10, btnY, 8, 3, "-5", colors.button)
    addButton("minus5", 10, btnY, 8, 3, {type = "adjust", action = "-5"})
    
    drawButton(20, btnY, 8, 3, "-1", colors.button)
    addButton("minus1", 20, btnY, 8, 3, {type = "adjust", action = "-1"})
    
    drawButton(width - 28, btnY, 8, 3, "+1", colors.button)
    addButton("plus1", width - 28, btnY, 8, 3, {type = "adjust", action = "+1"})
    
    drawButton(width - 18, btnY, 8, 3, "+5", colors.button)
    addButton("plus5", width - 18, btnY, 8, 3, {type = "adjust", action = "+5"})
    
    -- Craft and Cancel buttons
    drawButton(math.floor(width/2) - 20, 20, 18, 3, "Craft", colors.buttonActive)
    addButton("craft", math.floor(width/2) - 20, 20, 18, 3, {type = "craft"})
    
    drawButton(math.floor(width/2) + 2, 20, 18, 3, "Cancel", colors.button)
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
    monitor.setBackgroundColor(colors.progressBar)
    for i = 0, barHeight - 1 do
        monitor.setCursorPos(barX, barY + i)
        monitor.write(string.rep(" ", barWidth))
    end
    
    -- Draw progress bar fill
    local fillWidth = math.floor(barWidth * progress)
    if fillWidth > 0 then
        monitor.setBackgroundColor(colors.progressFill)
        for i = 0, barHeight - 1 do
            monitor.setCursorPos(barX, barY + i)
            monitor.write(string.rep(" ", fillWidth))
        end
    end
    
    -- Draw percentage text
    monitor.setBackgroundColor(colors.background)
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
    
    monitor.setBackgroundColor(colors.background)
end

-- Show message
function gui.showMessage(msg)
    -- Save current cursor position
    local oldBg = monitor.getBackgroundColor()
    local oldText = monitor.getTextColor()
    
    -- Show message at bottom
    monitor.setCursorPos(2, height)
    monitor.setBackgroundColor(colors.background)
    monitor.setTextColor(colors.info)
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
    monitor.setBackgroundColor(colors.background)
    monitor.setTextColor(colors.error)
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