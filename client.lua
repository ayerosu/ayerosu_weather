local currentWeather = Config.DefaultWeather or 'EXTRASUNNY'
local syncWeather = true
local currentRain = 0.0
local rainThreadRunning = false
local freezeTimeClient = false

local function smoothRain(targetLevel, durationSeconds)
    rainThreadRunning = true
    CreateThread(function()
        local startLevel = currentRain
        local steps = math.floor(durationSeconds * 10)
        if steps < 1 then steps = 1 end
        local diff = (targetLevel - startLevel) / steps
        for i = 1, steps do
            if not rainThreadRunning then break end
            currentRain = currentRain + diff
            if currentRain < 0.0 then currentRain = 0.0 end
            if currentRain > 1.0 then currentRain = 1.0 end
            SetRainLevel(currentRain)
            Wait(100)
        end
        currentRain = targetLevel
        SetRainLevel(currentRain)
        rainThreadRunning = false
    end)
end

local function applyWeather(weatherName, instant)
    currentWeather = weatherName
    if not syncWeather then return end

    ClearOverrideWeather()
    ClearWeatherTypePersist()

    local duration = (Config.TransitionDuration and tonumber(Config.TransitionDuration)) or 20.0

    if instant then
        rainThreadRunning = false
        SetWeatherTypeNowPersist(weatherName)
        SetWeatherTypeNow(weatherName)
        if weatherName == 'RAIN' or weatherName == 'THUNDER' then
            currentRain = 0.8
            SetRainLevel(0.8)
        else
            currentRain = 0.0
            SetRainLevel(0.0)
        end
    else
        SetWeatherTypeOvertimePersist(weatherName, duration)
        local targetRain = (weatherName == 'RAIN' or weatherName == 'THUNDER') and 0.8 or 0.0
        smoothRain(targetRain, duration)
    end

    if Config.WeatherEffects and Config.WeatherEffects.windSpeed and Config.WeatherEffects.windSpeed[weatherName] then
        SetWind(Config.WeatherEffects.windSpeed[weatherName])
        SetWindSpeed(Config.WeatherEffects.windSpeed[weatherName])
    end

    local isSnow = (weatherName == 'SNOW' or weatherName == 'BLIZZARD' or weatherName == 'SNOWLIGHT' or weatherName == 'XMAS')
    if Config.WeatherEffects and Config.WeatherEffects.snowTracks then
        SetForceVehicleTrails(isSnow)
        SetForcePedFootstepsTracks(isSnow)
    end
end

RegisterNetEvent('ayerosu_weather:client:setWeather', function(weather)
    applyWeather(weather, false)
end)

RegisterNetEvent('ayerosu_weather:client:setTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

RegisterNetEvent('ayerosu_weather:client:setBlackout', function(state)
    SetArtificialLightsState(state)
    SetArtificialLightsStateAffectsVehicles(false)
end)

RegisterNetEvent('ayerosu_weather:client:setFreezeTime', function(state)
    freezeTimeClient = state and true or false
end)

AddStateBagChangeHandler('weather', 'global', function(_, _, value)
    if value then
        applyWeather(value, false)
    end
end)

AddStateBagChangeHandler('currentTime', 'global', function(_, _, value)
    if value and value.hour and value.minute then
        NetworkOverrideClockTime(value.hour, value.minute, 0)
    end
end)

AddStateBagChangeHandler('blackout', 'global', function(_, _, value)
    if type(value) == 'boolean' then
        SetArtificialLightsState(value)
        SetArtificialLightsStateAffectsVehicles(false)
    end
end)

AddStateBagChangeHandler('freezeTime', 'global', function(_, _, value)
    if type(value) == 'boolean' then
        freezeTimeClient = value
    end
end)

RegisterNetEvent('qb-weathersync:client:DisableSync', function()
    syncWeather = false
end)

RegisterNetEvent('qb-weathersync:client:EnableSync', function()
    syncWeather = true
    applyWeather(GlobalState.weather or Config.DefaultWeather, true)
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(100) end
    Wait(500)
    local initialWeather = GlobalState.weather or Config.DefaultWeather
    applyWeather(initialWeather, true)
    local initialTime = GlobalState.currentTime or { hour = Config.DefaultHour, minute = Config.DefaultMinute }
    NetworkOverrideClockTime(initialTime.hour, initialTime.minute, 0)
    if type(GlobalState.blackout) == 'boolean' then
        SetArtificialLightsState(GlobalState.blackout)
        SetArtificialLightsStateAffectsVehicles(false)
    end
    if type(GlobalState.freezeTime) == 'boolean' then
        freezeTimeClient = GlobalState.freezeTime
    end
end)

CreateThread(function()
    while true do
        if freezeTimeClient then
            local time = GlobalState.currentTime
            if time and time.hour and time.minute then
                NetworkOverrideClockTime(time.hour, time.minute, 0)
            end
            Wait(1000)
        else
            Wait(2500)
        end
    end
end)

RegisterNetEvent('ayerosu_weather:client:openMenu', function(currentW, hour, min, freeze, blackout)
    local weatherOptions = {}
    for i = 1, #Config.WeatherTypes do
        local w = Config.WeatherTypes[i]
        local isCurrent = (w.value == currentW)
        local label = _LWeather(w.value)
        weatherOptions[#weatherOptions + 1] = {
            title = label .. (isCurrent and (' ' .. _L('active')) or ''),
            description = w.value,
            icon = w.icon or 'cloud',
            iconColor = isCurrent and '#48bb78' or nil,
            onSelect = function()
                TriggerServerEvent('ayerosu_weather:server:setWeather', w.value)
            end
        }
    end

    lib.registerContext({
        id = 'ayerosu_weather_list',
        title = _L('menu_weather_title'),
        menu = 'ayerosu_weather_main',
        options = weatherOptions
    })

    local freezeStatus = freeze and _L('state_on') or _L('state_off')
    local blackoutStatus = blackout and _L('state_on') or _L('state_off')

    lib.registerContext({
        id = 'ayerosu_weather_main',
        title = _L('menu_main_title'),
        options = {
            {
                title = _L('menu_current_weather', _LWeather(currentW)),
                description = _L('menu_current_weather_desc'),
                icon = 'cloud-sun',
                arrow = true,
                menu = 'ayerosu_weather_list'
            },
            {
                title = _L('menu_set_time', hour, min),
                description = _L('menu_set_time_desc'),
                icon = 'clock',
                arrow = true,
                onSelect = function()
                    local input = lib.inputDialog(_L('dialog_set_time'), {
                        { type = 'number', label = _L('dialog_hour'), default = hour, min = 0, max = 23, required = true },
                        { type = 'number', label = _L('dialog_min'), default = min, min = 0, max = 59, required = true }
                    })
                    if input and input[1] and input[2] then
                        TriggerServerEvent('ayerosu_weather:server:setTime', input[1], input[2])
                    end
                end
            },
            {
                title = _L('menu_presets'),
                description = _L('menu_presets_desc'),
                icon = 'sun',
                arrow = true,
                onSelect = function()
                    lib.registerContext({
                        id = 'ayerosu_weather_presets',
                        title = _L('menu_presets_title'),
                        menu = 'ayerosu_weather_main',
                        options = {
                            {
                                title = _L('preset_morning'),
                                icon = 'coffee',
                                onSelect = function() TriggerServerEvent('ayerosu_weather:server:setTime', 9, 0) end
                            },
                            {
                                title = _L('preset_noon'),
                                icon = 'sun',
                                onSelect = function() TriggerServerEvent('ayerosu_weather:server:setTime', 12, 0) end
                            },
                            {
                                title = _L('preset_evening'),
                                icon = 'cloud-sun',
                                onSelect = function() TriggerServerEvent('ayerosu_weather:server:setTime', 18, 0) end
                            },
                            {
                                title = _L('preset_night'),
                                icon = 'moon',
                                onSelect = function() TriggerServerEvent('ayerosu_weather:server:setTime', 23, 0) end
                            }
                        }
                    })
                    lib.showContext('ayerosu_weather_presets')
                end
            },
            {
                title = _L('menu_freeze'),
                description = _L('menu_freeze_desc', freezeStatus),
                icon = 'snowflake',
                onSelect = function()
                    TriggerServerEvent('ayerosu_weather:server:toggleFreezeTime')
                end
            },
            {
                title = _L('menu_blackout'),
                description = _L('menu_blackout_desc', blackoutStatus),
                icon = 'bolt',
                onSelect = function()
                    TriggerServerEvent('ayerosu_weather:server:toggleBlackout')
                end
            }
        }
    })

    lib.showContext('ayerosu_weather_main')
end)
