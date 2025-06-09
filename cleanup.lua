-- Cleanup script for production
-- This will rename new files and remove old/test files

print("MysticalAgriculture Automation - Production Cleanup")
print("==================================================")

-- Files to remove
local filesToRemove = {
    "/mystical-automation/startup.lua",  -- Old startup
    "/mystical-automation/altar.lua",    -- Old altar
    "/mystical-automation/gui.lua",      -- Old gui
    "/mystical-automation/debug.lua",
    "/mystical-automation/me-bridge-docs.lua",
    "/mystical-automation/altar-debug.lua",
    "/mystical-automation/altar-craft-test.lua",
    "/mystical-automation/timer-test.lua",
    "/mystical-automation/debug-minimal.lua",
    "/debug-log.txt",
    "/me-debug.txt"
}

-- Files to rename
local filesToRename = {
    {from = "/mystical-automation/startup-new.lua", to = "/mystical-automation/startup.lua"},
    {from = "/mystical-automation/altar-new.lua", to = "/mystical-automation/altar.lua"},
    {from = "/mystical-automation/gui-new.lua", to = "/mystical-automation/gui.lua"}
}

-- Remove old files
print("\nRemoving old/debug files...")
for _, file in ipairs(filesToRemove) do
    if fs.exists(file) then
        fs.delete(file)
        print("  Removed: " .. file)
    end
end

-- Rename new files
print("\nRenaming production files...")
for _, rename in ipairs(filesToRename) do
    if fs.exists(rename.from) then
        if fs.exists(rename.to) then
            fs.delete(rename.to)
        end
        fs.move(rename.from, rename.to)
        print("  Renamed: " .. rename.from .. " -> " .. rename.to)
    end
end

print("\nCleanup complete!")
print("Run 'mystical' to start the automation system")