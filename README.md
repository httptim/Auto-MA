# MysticalAgriculture Automation System

Automated seed crafting system for MysticalAgriculture using CC:Tweaked and Advanced Peripherals.

**Version 2.0** - Production Ready

## Features

- **Touch Screen Interface** - Easy-to-use monitor GUI with seed grid
- **Real-time Inventory Tracking** - Shows which seeds you can craft
- **Automated Crafting** - Places items and monitors progress
- **ME Integration** - Pulls items from and stores results in ME system
- **Multi-craft Support** - Craft up to 64 seeds at once
- **Smart Progress Tracking** - Accurate progress bar during crafting

## Requirements

### Mods
- ComputerCraft: Tweaked
- Advanced Peripherals (for ME Bridge)
- MysticalAgriculture
- Applied Energistics 2

### Hardware Setup
1. **Computer** - Advanced Computer recommended
2. **Monitor** - A 3x2 setup
3. **ME Bridge** - Connected to your ME network
4. **Infusion Altar** - The central crafting block
5. **8 Infusion Pedestals** - Arranged around the altar
6. **Redstone Block** - Placed touching the altar for activation

## Installation

1. Run the installer on your CC:Tweaked computer:
```
wget run https://raw.githubusercontent.com/httptim/Auto-MA/main/installer.lua
```

2. Follow the setup wizard:
   - Select your monitor
   - Select your ME Bridge
   - Select the altar (central block)
   - Select 8 pedestals in clockwise order

3. Run the program:
```
startup
```

## Usage

### Main Screen
- Shows all available seeds in a grid
- **Green** = You have ingredients
- **Red** = Missing ingredients
- Click any seed to see details

### Details Screen
- Shows current stock in ME
- Lists all required ingredients
- Shows how many you have vs need
- Shows maximum craftable amount
- Click **Craft** to proceed or **Back** to return

### Quantity Selection
- Use +/- buttons to adjust amount
- Maximum 64 per craft session
- Click **Craft** to start

### Crafting
- Progress bar shows completion
- Automatically imports results to ME
- Returns to main screen when done

## Tips

- Place the Infusion Altar and pedestals in the standard 3x3 pattern
- Put a redstone block touching the altar to keep it activated
- Ensure ME Bridge has access to your main ME network
- Larger monitors provide better visibility

## Troubleshooting

**Seeds show red but I have materials**
- Check that items are in ME network (not in inventories)
- Ensure ME Bridge is connected properly

**Craft doesn't start**
- Verify redstone block is touching the altar
- Check all pedestals are within range

**Progress bar stuck at 0%**
- Make sure altar has power (redstone signal)
- Verify all pedestals are properly detected

## Support

Report issues at: https://github.com/httptim/Auto-MA/issues

---

Created by HttpTim