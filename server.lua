local currentWeather = Config.DefaultWeather or 'EXTRASUNNY'
local currentHour = Config.DefaultHour or 12
local currentMinute = Config.DefaultMinute or 0
local freezeTime = Config.FreezeTimeOnStart or false
local blackout = Config.BlackoutOnStart or false
local dynamicIndex = 1

GlobalState.weather = currentWeather
GlobalState.blackout = blackout
GlobalState.freezeTime = freezeTime
GlobalState.currentTime = { hour = currentHour, minute = currentMinute }

CreateThread(function()
    local interval = Config.TimeScale or 4000
    while true do
        Wait(interval)
        if not freezeTime then
            currentMinute = currentMinute + 1
            if currentMinute >= 60 then
                currentMinute = 0
                currentHour = currentHour + 1
                if currentHour >= 24 then
                    currentHour = 0
                end
            end
            GlobalState.currentTime = { hour = currentHour, minute = currentMinute }
        end
    end
end)

CreateThread(function()
    while true do
        local cycle = Config.DynamicWeatherCycle
        local currentStage = (cycle and cycle[dynamicIndex]) or nil
        local waitMinutes = (currentStage and currentStage.duration) or 30
        local sleepMs = waitMinutes * 60 * 1000

        Wait(sleepMs)

        if Config.DynamicWeather and not freezeTime and cycle and #cycle > 0 then
            dynamicIndex = dynamicIndex + 1
            if dynamicIndex > #cycle then
                dynamicIndex = 1
            end
            local nextStage = cycle[dynamicIndex]
            local nextWeather = type(nextStage) == 'table' and nextStage.weather or nextStage
            currentWeather = string.upper(nextWeather)
            GlobalState.weather = currentWeather
            TriggerClientEvent('ayerosu_weather:client:setWeather', -1, currentWeather)
        end
    end
end)

local function setServerWeather(weatherType, source)
    currentWeather = string.upper(weatherType)
    GlobalState.weather = currentWeather
    TriggerClientEvent('ayerosu_weather:client:setWeather', -1, currentWeather)
    if source and source > 0 then
        exports.qbx_core:Notify(source, _L('weather_changed', currentWeather), 'success')
    end
end

local function setServerTime(hour, minute, source)
    currentHour = tonumber(hour) or 12
    currentMinute = tonumber(minute) or 0
    if currentHour > 23 then currentHour = 0 end
    if currentMinute > 59 then currentMinute = 0 end
    GlobalState.currentTime = { hour = currentHour, minute = currentMinute }
    TriggerClientEvent('ayerosu_weather:client:setTime', -1, currentHour, currentMinute)
    if source and source > 0 then
        exports.qbx_core:Notify(source, _L('time_changed', currentHour, currentMinute), 'success')
    end
end

local function toggleServerFreeze(source)
    freezeTime = not freezeTime
    GlobalState.freezeTime = freezeTime
    TriggerClientEvent('ayerosu_weather:client:setFreezeTime', -1, freezeTime)
    local stateText = freezeTime and _L('state_on') or _L('state_off')
    if source and source > 0 then
        exports.qbx_core:Notify(source, _L('freeze_state', stateText), 'info')
    end
end

local function toggleServerBlackout(source)
    blackout = not blackout
    GlobalState.blackout = blackout
    TriggerClientEvent('ayerosu_weather:client:setBlackout', -1, blackout)
    local stateText = blackout and _L('state_on') or _L('state_off')
    if source and source > 0 then
        exports.qbx_core:Notify(source, _L('blackout_state', stateText), 'info')
    end
end

lib.addCommand({'hava', 'weather'}, {
    help = _L('weather_cmd_desc'),
    restricted = 'group.admin',
    params = {
        {
            name = 'tip',
            type = 'string',
            help = _L('weather_cmd_param'),
            optional = true
        }
    }
}, function(source, args)
    if not exports.qbx_core:IsOptin(source) then
        exports.qbx_core:Notify(source, _L('not_optin'), 'error')
        return
    end

    if args and args.tip then
        local target = string.upper(args.tip)
        if target == 'FOG' then target = 'FOGGY' end
        setServerWeather(target, source)
    else
        TriggerClientEvent('ayerosu_weather:client:openMenu', source, currentWeather, currentHour, currentMinute, freezeTime, blackout)
    end
end)

lib.addCommand({'saat', 'time'}, {
    help = _L('time_cmd_desc'),
    restricted = 'group.admin',
    params = {
        { name = 'saat', type = 'number', help = _L('time_cmd_hour') },
        { name = 'dakika', type = 'number', help = _L('time_cmd_min'), optional = true }
    }
}, function(source, args)
    if not exports.qbx_core:IsOptin(source) then
        exports.qbx_core:Notify(source, _L('not_optin'), 'error')
        return
    end
    setServerTime(args.saat, args.dakika or 0, source)
end)

lib.addCommand({'blackout'}, {
    help = _L('blackout_cmd_desc'),
    restricted = 'group.admin'
}, function(source)
    if not exports.qbx_core:IsOptin(source) then
        exports.qbx_core:Notify(source, _L('not_optin'), 'error')
        return
    end
    toggleServerBlackout(source)
end)

lib.addCommand({'freezetime', 'zamanidondur'}, {
    help = _L('freezetime_cmd_desc'),
    restricted = 'group.admin'
}, function(source)
    if not exports.qbx_core:IsOptin(source) then
        exports.qbx_core:Notify(source, _L('not_optin'), 'error')
        return
    end
    toggleServerFreeze(source)
end)

RegisterNetEvent('ayerosu_weather:server:setWeather', function(weatherType)
    local src = source
    if not IsPlayerAceAllowed(src, 'command.weather') or not exports.qbx_core:IsOptin(src) then return end
    setServerWeather(weatherType, src)
end)

RegisterNetEvent('ayerosu_weather:server:setTime', function(hour, minute)
    local src = source
    if not IsPlayerAceAllowed(src, 'command.weather') or not exports.qbx_core:IsOptin(src) then return end
    setServerTime(hour, minute, src)
end)

RegisterNetEvent('ayerosu_weather:server:toggleFreezeTime', function()
    local src = source
    if not IsPlayerAceAllowed(src, 'command.weather') or not exports.qbx_core:IsOptin(src) then return end
    toggleServerFreeze(src)
end)

RegisterNetEvent('ayerosu_weather:server:toggleBlackout', function()
    local src = source
    if not IsPlayerAceAllowed(src, 'command.weather') or not exports.qbx_core:IsOptin(src) then return end
    toggleServerBlackout(src)
end)

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-weathersync_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
    AddEventHandler(('__cfx_export_ayerosu_weather_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('setWeather', function(weather)
    setServerWeather(weather, 0)
end)

exportHandler('setTime', function(hour, minute)
    setServerTime(hour, minute, 0)
end)

exportHandler('setBlackout', function(state)
    blackout = state and true or false
    GlobalState.blackout = blackout
    TriggerClientEvent('ayerosu_weather:client:setBlackout', -1, blackout)
end)

exportHandler('setTimeFreeze', function(state)
    freezeTime = state and true or false
    GlobalState.freezeTime = freezeTime
    TriggerClientEvent('ayerosu_weather:client:setFreezeTime', -1, freezeTime)
end)

exportHandler('getWeatherState', function()
    return currentWeather
end)

exportHandler('getTime', function()
    return currentHour, currentMinute
end)

exportHandler('getBlackoutState', function()
    return blackout
end)

exportHandler('getTimeFreezeState', function()
    return freezeTime
end)

RegisterNetEvent('qb-weathersync:server:setWeather', function(weather)
    setServerWeather(weather, source)
end)

RegisterNetEvent('qb-weathersync:server:setTime', function(hour, minute)
    setServerTime(hour, minute, source)
end)

RegisterNetEvent('qb-weathersync:server:toggleBlackout', function()
    toggleServerBlackout(source)
end)

RegisterNetEvent('qb-weathersync:server:toggleFreezeTime', function()
    toggleServerFreeze(source)
end)
