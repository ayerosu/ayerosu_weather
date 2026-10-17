# ayerosu_weather

A modern, standalone, lightweight weather and time synchronization resource for FiveM (built for Qbox / ox_lib). Designed to replace bloated weather scripts with smooth transitions, realistic rain/wind physics, multi-language support, and zero performance overhead.

---

## Key Features

- Smooth Weather Transitions
- Progressive Rain & Thunder Interpolation
- Per-Weather Duration & Sequential Cycles
- Dynamic Wind & Snow Physics
- Multi-Language Support
- Easily Customizable
- Modern ox_lib Context Menu

- **Bilingual Command Support:**
  - `/weather [type]`
  - `/time [hour] [minute]`
  - `/blackout`
  - `/freezetime`
- **Drop-in `qb-weathersync` Compatibility:** Completely backward-compatible with all scripts calling `qb-weathersync` exports and server events.

---

## Installation

1. Place the folder into your `resources/[standalone]/` directory as `ayerosu_weather`.
2. Add the resource to your `server.cfg` (if not auto-loaded via `[standalone]`):
   ```cfg
   ensure ayerosu_weather
   ```
3. Ensure `@ox_lib` is started before this resource.

---

## Configuration (`config.lua`)

| Option | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `Config.Language` | String | `'tr'` | Interface and notification language (`'en'` or `'tr'`) |
| `Config.DefaultWeather` | String | `'EXTRASUNNY'` | Initial weather on server start |
| `Config.DefaultHour` | Number | `12` | Initial hour on server start (0-23) |
| `Config.DefaultMinute` | Number | `0` | Initial minute on server start (0-59) |
| `Config.TimeScale` | Number | `4000` | Real-world milliseconds per in-game minute |
| `Config.TransitionDuration` | Number | `20.0` | Duration in seconds for smooth weather blending |
| `Config.DynamicWeather` | Boolean | `false` | Enable automatic background weather progression |
| `Config.DynamicWeatherCycle` | Table | Configured | Weather progression list with custom `duration` (in minutes) per phase |
| `Config.WeatherEffects.snowTracks` | Boolean | `true` | Enable footprint and tire tracks during snow weather |
| `Config.WeatherEffects.windSpeed` | Table | Configured | Wind speed multipliers per weather type |

### Example Dynamic Cycle:
```lua
Config.DynamicWeatherCycle = {
    { weather = 'EXTRASUNNY', duration = 45 }, -- 45 minutes
    { weather = 'CLEAR',       duration = 30 }, -- 30 minutes
    { weather = 'CLOUDS',      duration = 20 }, -- 20 minutes
    { weather = 'OVERCAST',    duration = 15 }, -- 15 minutes
    { weather = 'RAIN',        duration = 10 }, -- 10 minutes
    { weather = 'CLEARING',    duration = 15 }  -- 15 minutes
}
```

---

## Commands & Permissions

Requires `group.admin` ace permission and QBX admin duty (`/optin`):

- `/weather` Opens the management GUI menu.
- `/weather <type>`: Changes weather directly (e.g., `/weather clear`, `/weather rain`).
- `/time <hour> <minute>`: Changes in-game time (e.g., `/time 21 00`).
- `/blackout` : Toggles citywide blackout.
- `/freezetime`: Freezes or unfreezes time progression.

---

## Exports

Fully compatible with both `ayerosu_weather` and standard `qb-weathersync` exports:

```lua
exports['ayerosu_weather']:setWeather('CLEAR')
exports['ayerosu_weather']:setTime(14, 0)
exports['ayerosu_weather']:setBlackout(true)
exports['ayerosu_weather']:setTimeFreeze(true)

local currentWeather = exports['ayerosu_weather']:getWeatherState()
local hour, minute = exports['ayerosu_weather']:getTime()
local isBlackout = exports['ayerosu_weather']:getBlackoutState()
local isFrozen = exports['ayerosu_weather']:getTimeFreezeState()
```

---

## License

This project is licensed under the **Apache License 2.0**. For more details, see the [LICENSE](LICENSE) file.

Copyright (c) 2026 **ayerosu**