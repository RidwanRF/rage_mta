----------------------------------------------
--
-- Изменение цвета дисков
--
----------------------------------------------

local vehicleColorShaders = {}
local textureNames = {
    'wheel_color', 'rimpaint'
    -- "rimpaint", "minerva1", "cherebrus3", "Cerberus1", "Cerberus",
    -- "57", "hrep40", "cv201", "kf", "rays", "rotiformsjc", "rotiformtmb",
    -- "vossen1", "vossen2",  "work",  "zero",  "watanabe", "vishu", 


    -- "tws-tire", "te37al", "te37", "5Zg2", "AD08_Sidewall", "ADR", "ADVAN", "ADVAN_RacingV2", "ADVAN_RacingV2al", "ADVAN_RGII", "BBS", "BBS_RS_GT", "Boyd_Slayer", "ByMatheus340", "CHROME_07", "CRKai", "cromado", "enkei", "enkei2", "fikse_pro", "freio", "gram_t57", "gram_t57al", "grid", "hamman_editrace", "iForged", "offroad", "Oz1", "rays", "Reflexo", "roda_003", "roda_004", "roda_007", "roda_008", "roda_012", "roda_rv", "Rota_Tamarc", "TE37", "TE37al", "tenzor", "tenzor3", "thread", "Tire(DirT)", "Tire(R)", "Tire", "TireSim", "TireSim_Sidewall", "WED_105", "wed_sa97", "wed_sa97al", "work2", "work4", "work5", "zen_dynm"
}
-- Шейдер яркости
local brightnessShader
-- Максимальное значение цвета колеса (определяет яркость)
local MAX_COLOR_VALUE = 150
-- Частота обновления глобального шейдера яркости
local BRIGHTNESS_UPDATE_INTERVAL = 60 * 60 * 1000

local function getColorTexture(r, g, b)
    -- Текстура для смены цвета
    local texture = dxCreateTexture(1, 1, "argb")
    -- Пустые пиксели
    local pixels = string.char(0, 0, 0, 0, 1, 0, 1, 0)
    dxSetPixelColor(pixels, 0, 0, r, g, b)
    texture:setPixels(pixels)
    return texture
end

-- Зависимость яркости от времени суток
local function getBrightnessMul()
    return 1+(math.abs(getTime()-12)/12)*1.25
end

local function getVehicleColorShader(vehicle, r, g, b)

    local shader_data = vehicleColorShaders[vehicle]
    local cover_type = vehicle:getData('wheel_coverType') or 'default'

    if not shader_data or (shader_data.cover_type ~= cover_type) then

        removeVehicleShaders(vehicle)

        shader_data = {
            cover_type = cover_type,
            shader = dxCreateShader(
                WheelShaderSources[ cover_type ] or ("assets/shader/wheel_%s.fx"):format( cover_type )
            ),
        }

        vehicleColorShaders[vehicle] = shader_data

    end

    -- Передать текстуру в шейдер и удалить её
    local texture = getColorTexture(r, g, b)
    shader_data.shader:setData("wheel_coverShader", true)

    shader_data.shader:setValue("wheelColor", {r/255,g/255,b/255,1})
    -- shader:setValue("gTexture", texture)
    -- shader:setValue("sReflectionTexture", whiteTexture)
    shader_data.shader:setValue("sReflectionTexture", wheels_getCurrentCoverTexture())
    -- destroyElement(texture)
    return shader_data.shader

end

function applyWheelColor(vehicle, object, color)

    -- Уменьшение яркости цвета
    local brightness = getBrightnessMul()
    for i, c in ipairs(color) do
        color[i] = c/255*MAX_COLOR_VALUE/brightness
        color[i] = math.max( 0, color[i] )
    end
    local shader = getVehicleColorShader(vehicle, unpack(color))

    for _, textureName in pairs( textureNames ) do
        shader:applyToWorldTexture(textureName, object)
    end

end

function removeVehicleShaders(vehicle)
    clearTableElements( vehicleColorShaders[vehicle] or {} )
    vehicleColorShaders[vehicle] = nil
end

function getVehicleWheelsColor(vehicle)
    local color = vehicle:getData("wheels_color")
    if type(color) ~= "string" then
        color = "#FFFFFF"
    end
    return getColorFromString(color)
end

function setVehicleWheelsColor(vehicle, r, g, b)
    if r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 then
        return nil
    end
    vehicle:setData("wheels_color", string.format("#%.2X%.2X%.2X", r, g, b), false)
end
