Config = {}

Config.Language = 'en' -- en, tr

Config.DefaultWeather = 'EXTRASUNNY'
Config.DefaultHour = 12
Config.DefaultMinute = 0
Config.TimeScale = 4000
Config.TransitionDuration = 20.0
Config.FreezeTimeOnStart = false
Config.BlackoutOnStart = false

Config.DynamicWeather = false
Config.DynamicWeatherCycle = {
    { weather = 'EXTRASUNNY', duration = 45 },
    { weather = 'CLEAR',       duration = 30 },
    { weather = 'CLOUDS',      duration = 20 },
    { weather = 'OVERCAST',    duration = 15 },
    { weather = 'RAIN',        duration = 10 },
    { weather = 'CLEARING',    duration = 15 }
}

Config.WeatherEffects = {
    snowTracks = true,
    smoothRain = true,
    windSpeed = {
        ['EXTRASUNNY'] = 0.0,
        ['CLEAR'] = 0.5,
        ['CLOUDS'] = 1.0,
        ['OVERCAST'] = 2.0,
        ['RAIN'] = 5.0,
        ['THUNDER'] = 10.0,
        ['BLIZZARD'] = 12.0
    }
}

Config.WeatherTypes = {
    { value = 'EXTRASUNNY', icon = 'sun' },
    { value = 'CLEAR', icon = 'sun' },
    { value = 'CLOUDS', icon = 'cloud-sun' },
    { value = 'OVERCAST', icon = 'cloud' },
    { value = 'CLEARING', icon = 'cloud-sun-rain' },
    { value = 'RAIN', icon = 'cloud-rain' },
    { value = 'THUNDER', icon = 'bolt' },
    { value = 'SMOG', icon = 'smog' },
    { value = 'FOGGY', icon = 'smog' },
    { value = 'NEUTRAL', icon = 'cloud' },
    { value = 'SNOW', icon = 'snowflake' },
    { value = 'BLIZZARD', icon = 'wind' },
    { value = 'SNOWLIGHT', icon = 'snowflake' },
    { value = 'XMAS', icon = 'gifts' }
}

Config.Locales = {
    ['tr'] = {
        weather_cmd_desc = 'Hava durumu ve zaman yönetim arayüzü',
        weather_cmd_param = 'clear, extrasunny, rain, thunder vb. (Boş: Menü)',
        time_cmd_desc = 'Oyun saatini ayarla (Örn: /saat 12 00 veya /time 12 00)',
        time_cmd_hour = '0-23 arası saat',
        time_cmd_min = '0-59 arası dakika',
        blackout_cmd_desc = 'Elektrik kesintisini aç veya kapat',
        freezetime_cmd_desc = 'Zaman akışını dondur veya başlat',
        not_optin = 'Admin mesaisinde değilsiniz (/optin).',
        weather_changed = 'Hava durumu "%s" olarak ayarlandı.',
        time_changed = 'Saat %02d:%02d olarak ayarlandı.',
        blackout_state = 'Elektrik Kesintisi (Blackout): %s',
        freeze_state = 'Zaman Dondurma: %s',
        state_on = 'Açık',
        state_off = 'Kapalı',
        active = '(Aktif)',
        menu_main_title = 'Hava & Zaman Kontrolü',
        menu_weather_title = 'Hava Durumu Seçimi',
        menu_current_weather = 'Mevcut Hava Durumu: %s',
        menu_current_weather_desc = 'Hava durumunu seçmek için tıklayın',
        menu_set_time = 'Saat: %02d:%02d',
        menu_set_time_desc = 'Oyun saatini manuel ayarlamak için tıklayın',
        menu_presets = 'Hızlı Saat Seçimleri',
        menu_presets_desc = 'Sabah, Öğle, Akşam veya Gece yap',
        menu_presets_title = 'Hızlı Saatler',
        preset_morning = 'Sabah (09:00)',
        preset_noon = 'Öğle (12:00)',
        preset_evening = 'Akşamüstü (18:00)',
        preset_night = 'Gece (23:00)',
        menu_freeze = 'Zaman Akışı',
        menu_freeze_desc = 'Şu an: %s',
        menu_blackout = 'Elektrik Kesintisi',
        menu_blackout_desc = 'Şu an: %s',
        dialog_set_time = 'Saat Ayarla',
        dialog_hour = 'Saat (0 - 23)',
        dialog_min = 'Dakika (0 - 59)',
        weather_labels = {
            ['EXTRASUNNY'] = 'Açık Güneşli (Tertemiz)',
            ['CLEAR'] = 'Açık / Berrak',
            ['CLOUDS'] = 'Parçalı Bulutlu',
            ['OVERCAST'] = 'Kapalı / Bulutlu',
            ['CLEARING'] = 'Açılan Hava',
            ['RAIN'] = 'Yağmurlu',
            ['THUNDER'] = 'Fırtına / Şimşekli',
            ['SMOG'] = 'Hafif Dumanlı / Sisli',
            ['FOGGY'] = 'Yoğun Sisli',
            ['NEUTRAL'] = 'Nötr Hava',
            ['SNOW'] = 'Kar Yağışlı',
            ['BLIZZARD'] = 'Tipi / Şiddetli Kar',
            ['SNOWLIGHT'] = 'Hafif Kar',
            ['XMAS'] = 'Yılbaşı (Xmas Modu)'
        }
    },
    ['en'] = {
        weather_cmd_desc = 'Weather and time management interface',
        weather_cmd_param = 'clear, extrasunny, rain, thunder etc. (Empty: Menu)',
        time_cmd_desc = 'Set in-game time (e.g. /time 12 00)',
        time_cmd_hour = 'Hour between 0-23',
        time_cmd_min = 'Minute between 0-59',
        blackout_cmd_desc = 'Toggle citywide blackout',
        freezetime_cmd_desc = 'Toggle freeze game time',
        not_optin = 'You are not in admin duty mode (/optin).',
        weather_changed = 'Weather has been set to "%s".',
        time_changed = 'Time has been set to %02d:%02d.',
        blackout_state = 'Blackout: %s',
        freeze_state = 'Freeze Time: %s',
        state_on = 'Enabled',
        state_off = 'Disabled',
        active = '(Active)',
        menu_main_title = 'Weather & Time Management',
        menu_weather_title = 'Select Weather',
        menu_current_weather = 'Current Weather: %s',
        menu_current_weather_desc = 'Click to choose a weather type',
        menu_set_time = 'Time: %02d:%02d',
        menu_set_time_desc = 'Click to manually set clock',
        menu_presets = 'Quick Time Presets',
        menu_presets_desc = 'Morning, Noon, Evening or Night',
        menu_presets_title = 'Time Presets',
        preset_morning = 'Morning (09:00)',
        preset_noon = 'Noon (12:00)',
        preset_evening = 'Evening (18:00)',
        preset_night = 'Night (23:00)',
        menu_freeze = 'Time Progression',
        menu_freeze_desc = 'Currently: %s',
        menu_blackout = 'City Blackout',
        menu_blackout_desc = 'Currently: %s',
        dialog_set_time = 'Set Clock Time',
        dialog_hour = 'Hour (0 - 23)',
        dialog_min = 'Minute (0 - 59)',
        weather_labels = {
            ['EXTRASUNNY'] = 'Extra Sunny',
            ['CLEAR'] = 'Clear Sky',
            ['CLOUDS'] = 'Cloudy',
            ['OVERCAST'] = 'Overcast',
            ['CLEARING'] = 'Clearing Skies',
            ['RAIN'] = 'Rainy',
            ['THUNDER'] = 'Thunderstorm',
            ['SMOG'] = 'Smog',
            ['FOGGY'] = 'Dense Fog',
            ['NEUTRAL'] = 'Neutral',
            ['SNOW'] = 'Snowing',
            ['BLIZZARD'] = 'Blizzard',
            ['SNOWLIGHT'] = 'Light Snow',
            ['XMAS'] = 'Christmas Snow'
        }
    }
}

function _L(key, ...)
    local lang = Config.Language or 'tr'
    local dict = Config.Locales[lang] or Config.Locales['tr']
    local str = dict[key] or key
    if select('#', ...) > 0 then
        return string.format(str, ...)
    end
    return str
end

function _LWeather(weatherType)
    local lang = Config.Language or 'tr'
    local dict = Config.Locales[lang] or Config.Locales['tr']
    if dict.weather_labels and dict.weather_labels[weatherType] then
        return dict.weather_labels[weatherType]
    end
    return weatherType
end
