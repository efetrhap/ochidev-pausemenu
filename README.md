![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)
![Qbox](https://img.shields.io/badge/Qbox-supported-brightgreen.svg)
![QBCore](https://img.shields.io/badge/QBCore-supported-brightgreen.svg)

Modern Pause Menu for FiveM with full support for Qbox and QBCore frameworks.

---

## Features

- **Dynamic Camera Tracking:** Locks the camera onto the player character or vehicle upon opening; prevents framing issues while moving or sprinting.
- **Ultra-Low Resource Usage:** 0.00ms resmon consumption while idle, ~0.01ms while active.
- **Framework Compatibility:** Built-in automatic detection for Qbox (`qbx_core`) and QBCore (`qb-core`).
- **Data Safety & Performance:** Powered by `ox_lib` callbacks, player-based rate limiting, and server-side caching.
- **Native GTA V Integration:** Seamless transitions directly into the default GTA V map and settings menus.
- **Confirmation Dialogue:** Built-in confirmation modal to prevent accidental server disconnections.

---

## Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- Supported framework: `qbx_core` or `qb-core`

---

## Configuration

Core settings available inside `config.lua`:

```lua
Config = {}

-- Framework selection: 'qbox' | 'qbcore'
Config.Framework = 'qbox'

-- Camera settings
Config.Camera = {
    TransitionTime = 800,     
    ReturnTime = 600,          
    OffsetX = 0.0,             
    OffsetY = 1.35,           
    OffsetZ = 0.45,             
    DofStrength = 1.0,        
    BlurEffect = false,        
    Timecycle = 'hud_def_blur' 
}

-- Disconnect message
Config.DisconnectReason = 'Disconnected from server.'

-- Menu localization labels
Config.Labels = {
    Resume = 'Resume',
    Map = 'Map',
    Settings = 'SETTINGS',
    Disconnect = 'Disconnect',
    Job = 'JOB',
    Cash = 'CASH',
    Bank = 'BANK'
}
```

---
<img width="1917" height="1017" alt="pausemenu" src="https://github.com/user-attachments/assets/d42d1b1a-e640-4c43-90c2-356387169c13" />

## License

MIT License.
