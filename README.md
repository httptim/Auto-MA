# MysticalAgriculture Automation System

A simple touch-screen automation system for MysticalAgriculture seed crafting in Minecraft with CC:Tweaked.

## Features

- **Auto-Setup Wizard**: Automatically detects and configures peripherals
- **Touch Interface**: Simple grid of seeds - touch to craft
- **ME Integration**: Real-time checking of available ingredients
- **Quantity Selection**: Craft 1-64 seeds at once
- **Visual Feedback**: Green = can craft, Red = missing ingredients

## Requirements

### Mods Required
- CC:Tweaked
- Advanced Peripherals
- MysticalAgriculture
- Applied Energistics 2

### Hardware Setup
1. **Advanced Computer** with Wired Modem
2. **Monitor** (3x2 or 2x2 array, combines into one display)
3. **ME Bridge** (from Advanced Peripherals) connected to your ME network
4. **Infusion Altar** with 8 Infusion Pedestals around it
5. **Redstone Integrator** (from Advanced Peripherals) positioned to activate altar
6. **Wired Modems** on all peripherals, connected with Networking Cable

## Installation

### Method 1: GitHub Installer (Recommended)
1. On your CC:Tweaked computer, run:
   ```
   pastebin run [installer_pastebin_id]
   ```
   Or download installer.lua and run it

2. The installer will download all files automatically

### Method 2: Manual Installation
1. Download all files to `/mystical-automation/`:
   - startup.lua
   - config.lua
   - me.lua
   - altar.lua
   - gui.lua
   - seeds.lua

2. Create launcher script:
   ```lua
   -- Save as 'mystical'
   shell.run("/mystical-automation/startup.lua")
   ```

## First Time Setup

1. Run `mystical` on your computer
2. The setup wizard will start automatically:
   - Detects all connected peripherals
   - Asks you to identify each component
   - Saves configuration automatically

3. System starts after setup completes

## Usage

### Basic Operation
1. Look at the monitor - seeds are displayed in a grid
2. **Green buttons** = ingredients available
3. **Red buttons** = missing ingredients
4. Touch a green seed to select it
5. Adjust quantity with +/- buttons
6. Touch CRAFT to start

### Controls
- **On Monitor**: Touch interface for all operations
- **On Computer**: Press Q to quit the program

## Troubleshooting

### "ME Bridge not found"
- Check wired modem is attached to ME Bridge
- Ensure ME Bridge is connected to ME Controller
- Right-click modem to enable (red band)

### "Altar not responding"
- Verify Redstone Integrator placement
- Check altar has power (RF/FE)
- Ensure all pedestals have wired modems

### Seeds showing red when ingredients available
- ME system might be lagging
- Try waiting a few seconds for cache refresh
- Check ME system has power

### Craft not starting
- Make sure no items are in pedestals
- Verify altar isn't already processing
- Check redstone signal reaches altar

## Configuration

The `config.lua` file stores your peripheral connections. It's auto-generated but can be edited manually if needed.

## Adding More Seeds

Edit `seeds.lua` to add more seed recipes. Follow the existing format:

```lua
["new_seeds"] = {
    name = "Display Name",
    shortName = "Short",
    output = "modid:seed_name",
    time = 20,
    ingredients = {
        {name = "minecraft:item", count = 4},
        {name = "mysticalagriculture:seed_base", count = 1},
        {name = "mysticalagriculture:essence", count = 4}
    }
}
```

Don't forget to add the seed ID to the `order` table!

## Tips

1. **Stock Essences**: Keep prosperity/soulium seed bases and essences stocked
2. **Power Check**: Ensure altar has sufficient RF/FE
3. **Pedestal Order**: During setup, select pedestals in clockwise order
4. **ME Organization**: Keeping a tidy ME system helps performance

## Known Limitations

- Crafts one seed type at a time
- Requires wired connections (no wireless)
- Limited to ~20 seed types on screen (can be modified)

## Credits

Created for the ATM10 modpack community.

## License

MIT - Feel free to modify and share!