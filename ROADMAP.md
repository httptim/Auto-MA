# MysticalAgriculture Automation System - Simple Development Roadmap

## Project Overview
A lightweight CC:Tweaked automation system for MysticalAgriculture seed crafting with ME integration. Focus on simplicity and reliability within CC:Tweaked's disk space constraints.

## Core Features Only
- Touch-screen GUI for seed selection
- ME Bridge integration for inventory checking
- Single altar automation (expandable later)
- Basic seed database with common seeds
- Simple progress tracking

## Development Phases

### Phase 1: Core System (Week 1)
**Goal**: Get basic automation working

- [ ] **1.1 Setup Wizard**
  - Auto-detect all connected peripherals
  - Interactive setup on first run
  - Save selections to config.lua automatically
  - No manual config editing needed

- [ ] **1.2 Main Program**
  - Create `startup.lua` with basic event loop
  - Simple error handling with printError()
  - Initialize peripherals

- [ ] **1.3 ME Integration**
  - Create `me.lua` for ME Bridge functions
  - List items and export/import basics

### Phase 2: Basic Automation (Week 1-2)
**Goal**: Automate one altar successfully

- [ ] **2.1 Altar Control**
  - Create `altar.lua` for altar management
  - Pedestal item distribution
  - Redstone Integrator activation

- [ ] **2.2 Seed Data**
  - Create `seeds.lua` with 10-20 common seeds
  - Simple table structure with ingredients

- [ ] **2.3 Craft Logic**
  - Check ingredients in ME
  - Move items to pedestals
  - Activate altar and wait

### Phase 3: Simple GUI (Week 2)
**Goal**: Basic touch interface

- [ ] **3.1 Display**
  - Create `gui.lua` for monitor drawing
  - Simple button grid for seeds
  - Basic color coding (green=available, red=not)

- [ ] **3.2 Touch Handling**
  - Detect touch events
  - Map to seed selection
  - Show quantity selector screen
  - Handle quantity adjustment buttons
  - Start craft with selected amount

- [ ] **3.3 Progress Display**
  - Show current craft status
  - Simple progress bar
  - Clear completion message

### Phase 4: Polish & Testing (Week 3)
**Goal**: Make it reliable

- [ ] **4.1 Error Handling**
  - Handle missing ingredients gracefully
  - Retry failed operations
  - Clear error messages

- [ ] **4.2 Testing**
  - Test with common seeds
  - Verify altar timing
  - Check edge cases

- [ ] **4.3 Documentation**
  - Simple setup guide
  - Troubleshooting tips
  - Configuration examples

## File Structure (Simplified)
```
/mystical-automation/
├── startup.lua      # Main program (~200 lines)
├── config.lua       # User configuration (~50 lines)
├── me.lua          # ME Bridge interface (~100 lines)
├── altar.lua       # Altar control (~150 lines)
├── gui.lua         # Display and touch (~200 lines)
├── seeds.lua       # Seed database (~200 lines)
└── README.md       # Setup instructions
```

Total: ~900 lines of code, well within disk limits

## Simplified Features
1. **Auto Setup**: Detects peripherals and guides setup
2. **Main Screen**: Grid of seeds with availability colors
3. **Quantity Selection**: Touch seed to select amount (1-64)
4. **No Categories**: All seeds on one screen (scroll if needed)
5. **No History**: Just current status
6. **No Stats**: Keep it simple

## Hardware Requirements (Simplified)
- 1x Advanced Computer
- 1x 3x2 Monitor array (or 2x2 minimum)
- 1x ME Bridge (Advanced Peripherals)
- 1x Infusion Altar with 8 pedestals
- 1x Redstone Integrator
- Wired modems and cables

## Questions Before Starting

1. **Seed Priority**: Which 10-20 seeds are most important to automate?
2. **Altar Setup**: Is one altar sufficient to start?
3. **GUI Style**: Text-based buttons or attempt simple graphics?

## Success Criteria
- Can craft configured seeds with one touch
- Clear indication of what's available
- Handles common errors gracefully
- Fits comfortably in 1MB disk space
- Easy to expand later if needed

---

This simplified approach focuses on getting a working system quickly without over-engineering. We can always add features later once the core is solid.