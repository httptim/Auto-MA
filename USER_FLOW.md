# MysticalAgriculture Automation - Simple User Flow

## Overview
This document describes the basic user interactions with the simplified MysticalAgriculture automation system.

---

## 1. Installation & Setup

### Installation
```
1. Run installer on computer
2. Watch progress bars
3. See "Installation complete"
4. Run 'mystical' to start
```

### First-Time Setup
```
1. Run 'mystical' for the first time
2. System detects no config.lua
3. Enters setup wizard:
   
   "Detecting peripherals..."
   Found: monitor_0, monitor_1, meBridge_0, 
          inventory_0-15, redstoneIntegrator_0
   
   "Which monitor to use?" 
   > User selects monitor_0
   
   "Which is the ME Bridge?"
   > User selects meBridge_0
   
   "Which is the altar?"
   > User selects inventory_0
   
   "Select 8 pedestals (in order):"
   > User selects inventory_1 through inventory_8
   
   "Which is the redstone integrator?"
   > User selects redstoneIntegrator_0
   
4. System saves config.lua automatically
5. Continues to main program
```

---

## 2. Basic Operation

### Starting the System
```
User: Type 'mystical' and press Enter
System: Connects to peripherals
System: Shows seed grid on monitor
Result: Ready to craft
```

### Main Screen
```
Monitor shows:
┌─────────────────────────┐
│ MysticalAgriculture Auto│
├─────────────────────────┤
│ [Iron]  [Gold] [Coal]   │
│ GREEN   RED    GREEN    │
│                         │
│ [Zombie][Blaze][Spider] │
│ RED     GREEN  GREEN    │
│                         │
│ Status: Ready           │
└─────────────────────────┘

GREEN = Can craft now
RED = Missing ingredients
```

---

## 3. Crafting Seeds

### Touch to Select Seed
```
1. User touches green seed button
2. System shows quantity selector:
   
   ┌─────────────────────────┐
   │ Iron Seeds              │
   │ Available: 16 ingots    │
   │                         │
   │ Quantity: [1]           │
   │ [-1] [-5] [+5] [+1]     │
   │                         │
   │ [CRAFT]    [CANCEL]     │
   └─────────────────────────┘
   
3. User adjusts quantity (1-64)
4. User touches [CRAFT]
5. System starts crafting:
   - Exports items from ME
   - Places on pedestals
   - Activates altar
   - Shows progress bar
6. When done:
   - Collects seeds
   - Returns to main screen
```

### Missing Ingredients
```
1. User touches red seed button
2. System shows error:
   "Missing: 4x Iron Ingot"
3. Returns to main screen
4. User must add items to ME first
```

---

## 4. While Crafting

### Progress Display
```
┌─────────────────────────┐
│ Crafting: Iron Seeds    │
│ [████████────] 66%      │
│ Time left: 10s          │
│                         │
│ (Other seeds grayed out)│
└─────────────────────────┘
```

### Craft Complete
```
System: Shows "Complete!"
System: Updates button colors
System: Ready for next craft
```

---

## 5. Common Issues

### Peripheral Not Found
```
Error: "ME Bridge not found"
Fix: Check config.lua names
Fix: Ensure wired modems attached
```

### Altar Not Working
```
Error: "Altar activation failed"
Fix: Check redstone integrator
Fix: Verify altar has power
```

### Items Stuck
```
Problem: Items in pedestals
Fix: Manually remove items
Fix: Restart program
```

---

## 6. Tips

1. **Check First**: Look for green buttons before touching
2. **Wait**: Let crafts finish before starting another
3. **Stock ME**: Keep common ingredients stocked
4. **Monitor Power**: Ensure altar has RF/FE power
5. **Check Wiring**: All peripherals need wired modems

---

## Simple Commands

- `mystical` - Start the automation system
- `edit config.lua` - Change settings
- `Ctrl+T` - Stop the program

---

This simplified system focuses on one-touch operation. Touch a green button to craft that seed. That's it!