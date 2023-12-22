-------------------------------------------------------------------
-- Название: custom_lights.lua
-- Описание: Описание дополнительных фар и кастомного поведения
-------------------------------------------------------------------

CustomLights = {}

-- CustomLights[модель] = {
--
--     Вызывается, когда фары создались. Здесь можно переопределить интервал поворотников и т.д.
--     init = function (anim, vehicle)
--         anim.turnLightsInterval = 0.25
--     end
--
--     Обработка обновления фар. Вызывается после стандартного updateVehicle в lights_anim.lua
--     update = function (anim, deltaTime, vehicle)
--
--         Через таблицу 'anim' можно управлять светом:
--         anim.setLightState("turn_left", true)
--         anim.getLightState("turn_left")
--         anim.setLightColor("rear", 1, 0, 0)
--         anim.getLightColor("rear")
--
--         Также можно получать состояние поворотников
--         anim.turnLightsTime      - время в текущем состоянии поворотников
--         anim.turnLightsState     - состояние поворотников
--         anim.turnLightsInterval  - интервал мигания поворотников
--
--         Таблица 'anim' создается в LightsAnim.addVehicle(vehicle)
--     end
--
--     Обработчики изменения состояния конкретных фар
--     Могут использоваться для дублирования стандартных поворотников кастомными
--     stateHandlers = {
--         ["turn_left"] = function (anim, state, vehicle)
--             Передается такая же таблица 'anim', состояние и элемент автомобиля
--         end
--     }
--
--     Обработчики включения/выключения поворотников и т. д.
--     dataHandlers = {
--         ["turn_left"] = function (anim, state, vehicle)
--             Передается такая же таблица 'anim', состояние и элемент автомобиля
--         end
--     }
--
--     Таблица кастомных фонарей
--     lights = {
--         {name = "название" [, color = {r, g, b}, brightness = <0-1>, material = "название материала"] },
--         {name = "custom_light_1",  color = {1, 0.5, 0}},
--     }
-- }

-- Создание поворотников, которые будут дублировать габариты
local function makeTurnMirrorFront(model, leftLight, rightLight, frontColor, turnColor)
    if not frontColor then
        frontColor = {1, 1, 1}
    end
    if not turnColor then
        turnColor = {1, 0.5, 0}
    end
    CustomLights[model] = {
    
        stateHandlers = {
            ["turn_left"] = function (anim, state)
                if state then
                    anim.setLightColor(leftLight.name, unpack(turnColor))
                end
                anim.setLightState(leftLight.name, state)
            end,
            ["turn_right"] = function (anim, state)
                if state then
                    anim.setLightColor(rightLight.name, unpack(turnColor))
                end
                anim.setLightState(rightLight.name, state)
            end,
            ["front"] = function (anim, state)
                -- Если включен поворотник, состояние не обновляется
                if not anim.getLightState("turn_left") then
                    if state then
                        anim.setLightColor(leftLight.name, unpack(frontColor))
                    end
                    anim.setLightState(leftLight.name, state)
                end
                if not anim.getLightState("turn_right") then
                    if state then
                        anim.setLightColor(rightLight.name, unpack(frontColor))
                    end
                    anim.setLightState(rightLight.name, state)
                end
            end
        },

        dataHandlers = {
            ["turn_left"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(leftLight.name, unpack(frontColor))
                    anim.setLightState(leftLight.name, true)
                end
            end,
            ["turn_right"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(rightLight.name, unpack(frontColor))
                    anim.setLightState(rightLight.name, true)
                end
            end,
            ["emergency_light"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(leftLight.name, unpack(frontColor))
                    anim.setLightState(leftLight.name, true)
                    anim.setLightColor(rightLight.name, unpack(frontColor))
                    anim.setLightState(rightLight.name, true)
                end
            end
        },

        lights = {
            leftLight,
            rightLight,
        }
    }
end

local function makeTurnMirror(model, leftLight, rightLight, leftRLight, rightRLight, frontColor, turnColor, rearColor)

    if not frontColor then
        frontColor = {1, 1, 1}
    end
    if not turnColor then
        turnColor = {1, 0.5, 0}
    end
    if not rearColor then
        rearColor = {1, 0, 0}
    end

    CustomLights[model] = {

        stateHandlers = {
            ["turn_left"] = function (anim, state)
                if state then
                    anim.setLightColor(leftLight.name, unpack(turnColor))
                    anim.setLightColor(leftRLight.name, unpack(turnColor))
                end
                anim.setLightState(leftLight.name, state)
                anim.setLightState(leftRLight.name, state)
            end,
            ["turn_right"] = function (anim, state)
                if state then
                    anim.setLightColor(rightLight.name, unpack(turnColor))
                    anim.setLightColor(rightRLight.name, unpack(turnColor))
                end
                anim.setLightState(rightLight.name, state)
                anim.setLightState(rightRLight.name, state)
            end,
            ["front"] = function (anim, state)

                -- Если включен поворотник, состояние не обновляется
                if not anim.getLightState("turn_left") then
                    if state then
                        anim.setLightColor(leftLight.name, unpack(frontColor))
                        anim.setLightColor(leftRLight.name, unpack(rearColor))
                    end
                    anim.setLightState(leftLight.name, state)
                    anim.setLightState(leftRLight.name, state)
                end

                if not anim.getLightState("turn_right") then
                    if state then
                        anim.setLightColor(rightLight.name, unpack(frontColor))
                        anim.setLightColor(rightRLight.name, unpack(rearColor))
                    end
                    anim.setLightState(rightLight.name, state)
                    anim.setLightState(rightRLight.name, state)
                end

            end,
        },

        dataHandlers = {
            ["turn_left"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(leftLight.name, unpack(frontColor))
                    anim.setLightState(leftLight.name, true)
                    anim.setLightColor(leftRLight.name, unpack(rearColor))
                    anim.setLightState(leftRLight.name, true)
                end
            end,
            ["turn_right"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(rightLight.name, unpack(frontColor))
                    anim.setLightState(rightLight.name, true)
                    anim.setLightColor(rightRLight.name, unpack(rearColor))
                    anim.setLightState(rightRLight.name, true)
                end
            end,
            ["emergency_light"] = function (anim, state)
                if not state and anim.getLightState("front") then
                    anim.setLightColor(leftLight.name, unpack(frontColor))
                    anim.setLightState(leftLight.name, true)
                    anim.setLightColor(rightLight.name, unpack(frontColor))
                    anim.setLightState(rightLight.name, true)
                    anim.setLightColor(leftRLight.name, unpack(rearColor))
                    anim.setLightState(leftRLight.name, true)
                    anim.setLightColor(rightRLight.name, unpack(rearColor))
                    anim.setLightState(rightRLight.name, true)
                end
            end
        },

        lights = {
            leftLight,
            rightLight,
            leftRLight,
            rightRLight,
        }
    }
end

-- Porsche tayCAN turbo S
-- demon_turn работает как стопы и повороты
CustomLights[409] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_left", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_left_r", state)
            anim.setLightState("demon_turn_left", state)
        end,
        ["rear"] = function (anim, state)
            if not anim.getLightState("rear") then
                anim.setLightColor("demon_turn_left_r", 1, 1, 1)
                anim.setLightColor("demon_turn_right_r", 1, 1, 1)
            end
            anim.setLightState("demon_turn_left_r", state)
            anim.setLightState("demon_turn_right_r", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_right", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_right_r", state)
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 0.3, 0.3, 0.3)
                end
                anim.setLightState("demon_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 0.3, 0.3, 0.3)
                end
                anim.setLightState("demon_turn_right", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_left_r", 1, 1, 1)
                anim.setLightState("demon_turn_left_r", true)
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_right_r", 1, 1, 1)
                anim.setLightState("demon_turn_right_r", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "taycan_l*",   brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "taycan_r*", brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_left_r",  material = "vrs_turn_left_*",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "vrs_turn_right_*", brightness = 0.8, color = {1, 0.5, 0}},
        {name = "regera_shader_1", material = "regera_shader_*", brightness = 0.8, color = {1, 0.5, 0}},
    }
}

-- Bugatti Chiron
CustomLights[506] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local time1 = 1
            local timePause = 0.4
            local time2 = 0.4
            if currentTime < time1 then
                local progress = currentTime * 4 / time1
                local index = math.ceil(progress)
                progress = progress - index + 1
                local color = 0.3 * progress
                anim.setLightState("headlight"..index, true)
                anim.setLightColor("headlight"..index, color, color, color)
            elseif currentTime > time1 + timePause and currentTime < time1 + timePause + time2 then
                local progress = (currentTime - time1 - timePause) * 4 / time2
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = 5 - index
                local color = 0.3 + progress * 0.7
                anim.setLightColor("headlight"..index, color, color, color)
            elseif currentTime > time1 + timePause + time2 then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" then
            local time1 = 1
            local time2 = 1
            local timePause = 0.2
            if currentTime < time1 then
                local progress = currentTime * 4 / time1
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = 5 - index
                local color = 1 - 0.7 * progress
                anim.setLightState("headlight"..index, true)
                anim.setLightColor("headlight"..index, color, color, color)
            elseif currentTime > time1 and currentTime < time1 + time2 then
                local progress = (currentTime - time1) * 4 / time2
                local index = math.ceil(progress)
                progress = progress - index + 1
                local color = 0.3 - progress * 0.3
                anim.setLightColor("headlight"..index, color, color, color)
            elseif currentTime > time1 + time2 + timePause then
                for i = 0, 4 do
                    anim.setLightState("headlight"..i, false)
                end
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "disable" then
            for i = 0, 4 do
                anim.setLightState("headlight"..i, false)
            end
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 4 do
                anim.setLightState("headlight"..i, true)
                anim.setLightColor("headlight"..i, 1, 1, 1)
            end
            anim.stopSpecialAnimation()
        end
    end,

    lights = {
        {name = "headlight1", material = "chiron_headlight_1", color = {1, 1, 1}},
        {name = "headlight2", material = "chiron_headlight_2", color = {1, 1, 1}},
        {name = "headlight3", material = "chiron_headlight_3", color = {1, 1, 1}},
        {name = "headlight4", material = "chiron_headlight_4", color = {1, 1, 1}},
    }
}


-- Camry
CustomLights[426] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.3
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.38
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if not state then
                for i = 1, 3 do
                    anim.setLightState("camry_turn_left_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("camry_turn_left_"..i, 1, 0.5, 0)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state then
                for i = 1, 3 do
                    anim.setLightState("camry_turn_right_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("camry_turn_right_"..i, 1, 0.5, 0)
                end
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            if anim.getLightState("turn_left") then
                anim.setLightState("camry_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("camry_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- Плавное затухание всех блоков
            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)
            if anim.getLightState("turn_left") then
                for i = 1, 3 do
                    anim.setLightColor("camry_turn_left_"..i, progress, progress * 0.5, 0)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 1, 3 do
                    anim.setLightColor("camry_turn_right_"..i, progress, progress * 0.5, 0)
                end
            end
        end
    end,

    lights = {
        {name = "camry_turn_left_1", material = "camry_turn_left_1",   brightness = 1, color = {1, 0.5, 0}},
        {name = "camry_turn_left_2", material = "camry_turn_left_2",   brightness = 1, color = {1, 0.5, 0}},
        {name = "camry_turn_left_3", material = "camry_turn_left_3",   brightness = 1, color = {1, 0.5, 0}},

        {name = "camry_turn_right_1", material = "camry_turn_right_1", brightness = 1, color = {1, 0.5, 0}},
        {name = "camry_turn_right_2", material = "camry_turn_right_2", brightness = 1, color = {1, 0.5, 0}},
        {name = "camry_turn_right_3", material = "camry_turn_right_3", brightness = 1, color = {1, 0.5, 0}},
    }
}


-- Audi R8
CustomLights[422] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.3
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.38
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("audi_turn_left_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("audi_turn_left_"..i, 1, 0.5, 0)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("audi_turn_right_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("audi_turn_right_"..i, 1, 0.5, 0)
                end
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            if anim.getLightState("turn_left") then
                anim.setLightState("audi_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("audi_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- Плавное затухание всех блоков
            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)
            if anim.getLightState("turn_left") then
                for i = 0, 4 do
                    anim.setLightColor("audi_turn_left_"..i, progress, progress * 0.5, 0)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 0, 4 do
                    anim.setLightColor("audi_turn_right_"..i, progress, progress * 0.5, 0)
                end
            end
        end
    end,

    lights = {
        {name = "audi_turn_left_0", material = "audi_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_1", material = "audi_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_2", material = "audi_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_3", material = "audi_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_4", material = "audi_turn_left_4",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_0", material = "audi_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_1", material = "audi_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_2", material = "audi_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_3", material = "audi_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_4", material = "audi_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}},
    }
}

CustomLights[496] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left", state)
            end
           if not anim.getLightState("brake") then
                if state then
                    anim.setLightColor("demon_turn_left_l", 1, 1, 1)
                    anim.setLightColor("demon_turn_left_r", 0.3, 0, 0)
                end
                anim.setLightState("demon_turn_left_r", state)
                anim.setLightState("demon_turn_left_l", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right", state)
            end
         end
    },

    dataHandlers = {
         ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "vrs_turn_left_0",   brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "vrs_turn_right_0", brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_left_l",  material = "ez_front1",   brightness = 0.2, color = {1, 0.5, 0}},
        {name = "demon_turn_left_r",  material = "g82_taillight_0",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "vrs_turn_right_2", brightness = 0.8, color = {1, 0.5, 0}},
    }
}


-- RS7
CustomLights[561] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.3
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.38
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if not state then
                for i = 0, 3 do
                    anim.setLightState("audi_turn_left_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("audi_turn_left_"..i, 1, 0.5, 0)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state then
                for i = 0, 3 do
                    anim.setLightState("audi_turn_right_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("audi_turn_right_"..i, 1, 0.5, 0)
                end
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            if anim.getLightState("turn_left") then
                anim.setLightState("audi_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("audi_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- Плавное затухание всех блоков
            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)
            if anim.getLightState("turn_left") then
                for i = 0, 3 do
                    anim.setLightColor("audi_turn_left_"..i, progress, progress * 0.5, 0)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 0, 3 do
                    anim.setLightColor("audi_turn_right_"..i, progress, progress * 0.5, 0)
                end
            end
        end
    end,

    lights = {
        {name = "audi_turn_left_0", material = "RS7*_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_1", material = "RS7*_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_2", material = "RS7*_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_3", material = "RS7*_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_0", material = "RS7*_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_1", material = "RS7*_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_2", material = "RS7*_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_3", material = "RS7*_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},
    }
}

CustomLights[598] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left", 1, 0.3, 0)
                anim.setLightColor("demon_turn_left_r", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_left_r", state)
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right", 1, 0.3, 0)
                anim.setLightColor("demon_turn_right_r", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_right_r", state)
            anim.setLightState("demon_turn_right", state)
        end,
        ["rear"] = function (anim, state)
           if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left_r", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left_r", state)
            end
             if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right_r", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right_r", state)
            end
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left", state)
            end
            if not anim.getLightState("rear") then
                if state then
                    anim.setLightColor("jepa", 0.4, 0, 0)
                    anim.setLightColor("pered", 1, 1, 1)
                end
                anim.setLightState("pered", state)
                anim.setLightState("jepa", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right", state)
            end
        end
    },

    dataHandlers = {
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "pered",  material = "eska",   brightness = 0.6, color = {1, 1, 1}},
        {name = "jepa",  material = "e63_tail_1",   brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_left",  material = "vrs_turn_left_*",   brightness = 0.6, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "vrs_turn_right_*", brightness = 0.6, color = {1, 1, 1}},
        {name = "demon_turn_left_r",  material = "e63_rear_left_*",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "e63_rear_right_*", brightness = 0.8, color = {1, 0.5, 0}},
    }
}


-- Lexus LX70
CustomLights[567] = {
    init = function (anim)
        anim.turnLightsInterval = 0.4
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.3
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("LX570_turn_left_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("LX570_turn_left_"..i, 1, 0.5, 0)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("LX570_turn_right_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("LX570_turn_right_"..i, 1, 0.5, 0)
                end
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            if anim.getLightState("turn_left") then
                anim.setLightState("LX570_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("LX570_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- Плавное затухание всех блоков
            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)
            if anim.getLightState("turn_left") then
                for i = 0, 4 do
                    anim.setLightColor("LX570_turn_left_"..i, progress, progress * 0.5, 0)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 0, 4 do
                    anim.setLightColor("LX570_turn_right_"..i, progress, progress * 0.5, 0)
                end
            end
        end
    end,

    lights = {
        {name = "LX570_turn_left_0", material = "LX570_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_1", material = "LX570_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_2", material = "LX570_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_3", material = "LX570_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_4", material = "LX570_turn_left_4",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "LX570_turn_right_0", material = "LX570_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_1", material = "LX570_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_2", material = "LX570_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_3", material = "LX570_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_4", material = "LX570_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}},
    }
}


-- -- F90
-- CustomLights[479] = {
    -- init = function (anim)
        -- anim.turnLightsInterval = 0.5
        -- -- Время, за которое загораются все блоки
        -- anim.rearLightsTime = 0.3
        -- -- Время, после которого свет начинает плавно затухать
        -- anim.rearLightsFadeAfter = 0.38
    -- end,

    -- stateHandlers = {
        -- ["turn_left"] = function (anim, state)
            -- if not state then
                -- anim.setLightState("f90_turn_left", state)
                -- anim.setLightColor("f90_turn_left", 1, 0.5, 0)
            -- end
        -- end,
        -- ["turn_right"] = function (anim, state)
            -- if not state then
                -- anim.setLightState("f90_turn_right", state)
                -- anim.setLightColor("f90_turn_right", 1, 0.5, 0)
            -- end
        -- end
    -- },

    -- -- Задние поворотники
    -- update = function (anim)
        -- if not anim.turnLightsState then
            -- return
        -- end

        -- if anim.turnLightsTime < anim.rearLightsTime then
            -- -- Включение блоков по очереди
            -- local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            -- if anim.getLightState("turn_left") then
                -- anim.setLightState("f90_turn_left", true)
            -- end

            -- if anim.getLightState("turn_right") then
                -- anim.setLightState("f90_turn_right", true)
            -- end

        -- elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- -- Плавное затухание всех блоков
            -- local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)

            -- if anim.getLightState("turn_left") then
                -- anim.setLightColor("f90_turn_left", progress, progress * 0.5, 0)
            -- end

            -- if anim.getLightState("turn_right") then
                -- anim.setLightColor("f90_turn_right", progress, progress * 0.5, 0)
            -- end

        -- end
    -- end,

    -- lights = {
        -- {name = "f90_turn_left", material = "*_turn_left*",   brightness = 0.9, color = {1, 0, 0}},
        -- {name = "f90_turn_right", material = "*_turn_right*",   brightness = 0.9, color = {1, 0, 0}},
    -- }
-- }

-- bentayga
makeTurnMirrorFront(580,
    {name = "bentley_turn_left",  material = "tex_hwdmixed_left_*" },
    {name = "bentley_turn_right", material = "tex_hwdmixed_right_*" }
)

CustomLights[458] = {
	stateHandlers = {
        ["front"] = function (anim, state)
            if state then
                anim.setLightColor("light_bnw", 0,0,0)
                anim.setLightColor("light_bnw2", 0,0,0)
            end
            anim.setLightState("light_bnw", state)
			anim.setLightState("light_bnw2", state)
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("bnw_brake", 1, 0.02, 0)
                    anim.setLightState("bnw_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("bnw_brake", state)
                end
            end
        end,
    },
    lights = {
        {name = "light_bnw",  material = "ezbyrage", colorMul = 20,brightness = 0.01},
	{name = "light_bnw2",  material = "bmw_shader_3*", colorMul = 10,brightness = 0.01},
        {name = "bnw_brake",      material = "bugatti_turn_rear_0", color = {1, 0, 0}},
    }
}
-- supra
makeTurnMirror(429,
    {name = "supra_turn_left",  material = "tex_hwdmixed_left_*" },
    {name = "supra_turn_right", material = "tex_hwdmixed_right_*" },
    {name = "supra_turn_left_r",  material = "tex_rhwdmixed_left_*" },
    {name = "supra_turn_right_r", material = "tex_rhwdmixed_right_*" }
)

-- supra
CustomLights[479] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_left", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_left_r", state)
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_right", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_right_r", state)
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left_l", 1, 1, 0)
                    anim.setLightColor("demon_turn_left_ll", 1, 1, 1)
                    anim.setLightColor("demon_turn_left_r", 1, 1, 0)
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left_r", state)
                anim.setLightState("demon_turn_left_l", state)
                anim.setLightState("demon_turn_left_ll", state)
                anim.setLightState("demon_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right_r", 1, 1, 0)
                    anim.setLightColor("demon_turn_right_l", 1, 1, 0)
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right_r", state)
                anim.setLightState("demon_turn_right_l", state)
                anim.setLightState("demon_turn_right", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_left_r", 1, 1, 0)
                anim.setLightState("demon_turn_left_r", true)
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_right_r", 1, 1, 0)
                anim.setLightState("demon_turn_right_r", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left_r", 1, 1, 0)
                anim.setLightState("demon_turn_left_r", true)
                anim.setLightColor("demon_turn_left_l", 1, 1, 0)
                anim.setLightState("demon_turn_left_l", true)
                anim.setLightColor("demon_turn_left_ll", 1, 1, 1)
                anim.setLightState("demon_turn_left_ll", true)
                anim.setLightColor("demon_turn_right_r", 1, 1, 0)
                anim.setLightState("demon_turn_right_r", true)
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "f90a_turn_left_0",   brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "f90a_turn_right_0", brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_left_l",  material = "m5cs",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_left_ll",  material = "m5necs",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_left_r",  material = "f90b_turn_left_0",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "f90b_turn_right_0", brightness = 0.8, color = {1, 0.5, 0}},
    }
}


-- Shelby GT500
makeTurnMirrorFront(500,
    {name = "shelby_turn_left",  material = "shelby_turn_left_*" },
    {name = "shelby_turn_right", material = "shelby_turn_right_*" }
)

-- Veyron
makeTurnMirrorFront(533,
    {name = "veyron_turn_left",  material = "veyron_turn_left_*" },
    {name = "veyron_turn_right", material = "veyron_turn_right_*" }
)

-- Veyron
makeTurnMirrorFront(508,
    {name = "a7_turn_left",  material = "a7_turn_left" },
    {name = "a7_turn_right", material = "a7_turn_right" }
)

-- Lamborghini Huracan
-- huracan_turn - и габариты, и поворотники
-- huracan_brake - стопы и габариты
CustomLights[415] = {
    init = function (anim)
        anim.turnLightsInterval = 0.38
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("huracan_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("huracan_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("huracan_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("huracan_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("huracan_turn_left", 1, 1, 1)
                end
                anim.setLightState("huracan_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("huracan_turn_right", 1, 1, 1)
                end
                anim.setLightState("huracan_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("huracan_brake", 0.55, 0, 0)
                    anim.setLightState("huracan_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("huracan_brake", state)
                end
            end
        end,
        ["brake"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_brake", 0.55, 0, 0)
            else
                anim.setLightColor("huracan_brake", 1, 0.25, 0.25)
                anim.setLightState("huracan_brake", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_left", 1, 1, 1)
                anim.setLightState("huracan_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_right", 1, 1, 1)
                anim.setLightState("huracan_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_left", 1, 1, 1)
                anim.setLightState("huracan_turn_left", true)
                anim.setLightColor("huracan_turn_right", 1, 1, 1)
                anim.setLightState("huracan_turn_right", true)
            end
        end
    },

    lights = {
        {name = "huracan_turn_left",  material = "huracan_turn_left_*" , colorMul = 1.3 },
        {name = "huracan_turn_right", material = "huracan_turn_right_*", colorMul = 1.3 },
        {name = "huracan_brake",      material = "huracan_brake_*" },
    }
}

-- G63
CustomLights[554] = {
    init = function (anim)
    end,

    stateHandlers = {
        ["front"] = function (anim, state)
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("g500_brake", 0.55, 0, 0)
                    anim.setLightState("g500_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("g500_brake", state)
                end
            end
        end,
        ["brake"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("g500_brake", 0.55, 0, 0)
            else
                anim.setLightColor("g500_brake", 1, 0.25, 0.25)
                anim.setLightState("g500_brake", state)
            end
        end
    },

    lights = {
        {name = "g500_brake",      material = "g500_brake" },
    }
}

CustomLights[560] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left", state)
            end
           if not anim.getLightState("brake") then
                if state then
                    anim.setLightColor("demon_turn_left_l", 1, 1, 1)
                    anim.setLightColor("demon_turn_left_r", 0.3, 0, 0)
                end
                anim.setLightState("demon_turn_left_r", state)
                anim.setLightState("demon_turn_left_l", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right", state)
            end
         end
    },

    dataHandlers = {
         ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "vrs_turn_left_0",   brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "vrs_turn_right_0", brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_left_l",  material = "ez_front1",   brightness = 0.2, color = {1, 0.5, 0}},
        {name = "demon_turn_left_r",  material = "g82_taillight_0",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "vrs_turn_right_2", brightness = 0.8, color = {1, 0.5, 0}},
    }
}


-- Maybach S600 X222
-- s650_brake_0 работает как стопы и габариты
-- s650_turn_left_0 работает как поворот и ближний
CustomLights[418] = {

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 1, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 1, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },

    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left_*"  },
        {name = "s650_turn_right", material = "s650_turn_right_*" },
        {name = "s650_brake1",     material = "s650_brake_0" },
        {name = "s650_brake2",     material = "s650_brake_1" },
        {name = "s650_brake3",     material = "s650_brake_2" },
        {name = "s650_brake4",     material = "s650_brake_3" },
        {name = "s650_brake5",     material = "s650_brake_4" },
        {name = "s650_brake6",     material = "s650_brake_5" },
        {name = "s650_brake7",     material = "s650_brake_6" },
        {name = "s650_brake8",     material = "s650_brake_7" },
        {name = "s650_brake9",     material = "s650_brake_8" },
    }
}

CustomLights[550] = {
  stateHandlers = {
    front = function(anim, deltaTime)
      anim.setLightState("bmw_brake", deltaTime)
      anim.setLightState("bmw_front", deltaTime)
	  anim.setLightState("bmw_fronts", deltaTime)
    end
  },
  lights = {
    {
      name = "bmw_brake",
      material = "bmw_brake_0",
      color = {
        1,
        0.2,
        0.2
      }
    },
    {
      name = "bmw_front",
      material = "bmw_front_1",
      color = {
        0.5,
        0.1,
        0.1
      }
    },
	{
      name = "bmw_fronts",
      material = "bmw_front_0",
      color = {
        1,
        1,
        1
      }
    }
  }
}

CustomLights[419] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right", 1, 0.65, 0)
            end
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left", state)
            end
           if not anim.getLightState("brake") then
                if state then
                    anim.setLightColor("demon_turn_left_l", 1, 1, 1)
                    anim.setLightColor("demon_turn_left_r", 0.3, 0, 0)
                end
                anim.setLightState("demon_turn_left_r", state)
                anim.setLightState("demon_turn_left_l", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right", state)
            end
         end
    },

    dataHandlers = {
         ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "ez_left",   brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "ez_right", brightness = 0.2, color = {1, 1, 1}},
        {name = "demon_turn_left_l",  material = "ez_front1",   brightness = 0.2, color = {1, 0.5, 0}},
        {name = "demon_turn_left_r",  material = "g82_taillight_0",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "vrs_turn_right_2", brightness = 0.8, color = {1, 0.5, 0}},
    }
}




CustomLights[426] = {
	stateHandlers = {
        ["front"] = function (anim, state)
            if state then
                anim.setLightColor("light_bnw", 0,0,0)
                anim.setLightColor("light_bnw2", 0,0,0)
            end
            anim.setLightState("light_bnw", state)
			anim.setLightState("light_bnw2", state)
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("bnw_brake", 0.6, 0.02, 0)
                    anim.setLightState("bnw_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("bnw_brake", state)
                end
            end
        end,
    },
    lights = {
        {name = "light_bnw",  material = "ez_cumry_front_0*", colorMul = 20,brightness = 0.01},
	{name = "light_bnw2",  material = "bmw_shader_3*", colorMul = 10,brightness = 0.01},
        {name = "bnw_brake",      material = "ez_rear_lights_0" },
    }
}

-- Shelby GT500
CustomLights[500] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.4
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.45
    end,

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 3)

            if anim.getLightState("turn_left") then
                anim.setLightState("shelby_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("shelby_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            if anim.getLightState("turn_left") then
                for i = 0, 2 do
                    anim.setLightState("shelby_turn_left_"..i, false)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 0, 2 do
                    anim.setLightState("shelby_turn_right_"..i, false)
                end
            end
        end
    end,

    -- Задний ход = задние поворотники
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            for i = 0, 2 do
                anim.setLightColor("shelby_turn_left_"..i, 1, 0.25, 0)
                if not state then
                    anim.setLightState("shelby_turn_left_"..i, state)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            for i = 0, 2 do
                anim.setLightColor("shelby_turn_right_"..i, 1, 0.25, 0)
                if not state then
                    anim.setLightState("shelby_turn_right_"..i, state)
                end
            end
        end,
        ["rear"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shelby_turn_left_0", 1, 1, 1)
                    anim.setLightColor("shelby_turn_left_1", 1, 1, 1)
                    anim.setLightColor("shelby_turn_left_2", 1, 1, 1)
                end
                anim.setLightState("shelby_turn_left_0", state)
                anim.setLightState("shelby_turn_left_1", state)
                anim.setLightState("shelby_turn_left_2", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shelby_turn_right_0", 1, 1, 1)
                    anim.setLightColor("shelby_turn_right_1", 1, 1, 1)
                    anim.setLightColor("shelby_turn_right_2", 1, 1, 1)
                end
                anim.setLightState("shelby_turn_right_0", state)
                anim.setLightState("shelby_turn_right_1", state)
                anim.setLightState("shelby_turn_right_2", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("rear") then
                for i = 0, 2 do
                    anim.setLightColor("shelby_turn_left_"..i, 1, 1, 1)
                    anim.setLightState("shelby_turn_left_"..i, true)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("rear") then
                for i = 0, 2 do
                    anim.setLightColor("shelby_turn_right_"..i, 1, 1, 1)
                    anim.setLightState("shelby_turn_right_"..i, true)
                end
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("rear") then
                for i = 0, 2 do
                    anim.setLightColor("shelby_turn_left_"..i, 1, 1, 1)
                    anim.setLightState("shelby_turn_left_"..i, true)
                    anim.setLightColor("shelby_turn_right_"..i, 1, 1, 1)
                    anim.setLightState("shelby_turn_right_"..i, true)
                end
            end
        end
    },

    lights = {
        {name = "shelby_turn_left_0", material = "shelby_turn_left_0",   brightness = 0.8, color = {1, 0.25, 0}},
        {name = "shelby_turn_left_1", material = "shelby_turn_left_1",   brightness = 0.8, color = {1, 0.25, 0}},
        {name = "shelby_turn_left_2", material = "shelby_turn_left_2",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "shelby_turn_right_0", material = "shelby_turn_right_0", brightness = 0.8, color = {1, 0.25, 0}},
        {name = "shelby_turn_right_1", material = "shelby_turn_right_1", brightness = 0.8, color = {1, 0.25, 0}},
        {name = "shelby_turn_right_2", material = "shelby_turn_right_2", brightness = 0.8, color = {1, 0.25, 0}},
    }
}

-- Bugatti Veyron
CustomLights[533] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.4
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.45
    end,

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 3)

            if anim.getLightState("turn_left") then
                anim.setLightState("veyron_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("veyron_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            if anim.getLightState("turn_left") then
                for i = 1, 2 do
                    anim.setLightState("veyron_turn_left_"..i, false)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 1, 2 do
                    anim.setLightState("veyron_turn_right_"..i, false)
                end
            end
        end
    end,

    -- Задний ход = задние поворотники
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            for i = 1, 2 do
                anim.setLightColor("veyron_turn_left_"..i, 1, 0.25, 0)
                if not state then
                    anim.setLightState("veyron_turn_left_"..i, state)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            for i = 1, 2 do
                anim.setLightColor("veyron_turn_right_"..i, 1, 0.25, 0)
                if not state then
                    anim.setLightState("veyron_turn_right_"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("rear") then
                for i = 1, 2 do
                    anim.setLightColor("veyron_turn_left_"..i, 1, 1, 1)
                    anim.setLightState("veyron_turn_left_"..i, true)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("rear") then
                for i = 1, 2 do
                    anim.setLightColor("veyron_turn_right_"..i, 1, 1, 1)
                    anim.setLightState("veyron_turn_right_"..i, true)
                end
            end
        end
    },

    lights = {
        {name = "veyron_turn_left_1", material = "veyron_turn_left_1",   brightness = 0.9, color = {1, 0.8, 0}},
        {name = "veyron_turn_left_2", material = "veyron_turn_left_2",   brightness = 0.9, color = {1, 0.8, 0}},

        {name = "veyron_turn_right_1", material = "veyron_turn_right_1", brightness = 0.9, color = {1, 0.8, 0}},
        {name = "veyron_turn_right_2", material = "veyron_turn_right_2", brightness = 0.9, color = {1, 0.8, 0}},
    }
}

-- Audi A7
CustomLights[508] = {
    init = function (anim)
        anim.turnLightsInterval = 0.5
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.4
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.45
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            anim.setLightColor("a7_turn_left", 1, 0.25, 0)
            anim.setLightColor("a7_turn_left2", 1, 0.25, 0)
            if not state then
                anim.setLightState("a7_turn_left", state)
                anim.setLightState("a7_turn_left2", state)
            end
        end,
        ["turn_right"] = function (anim, state)
            anim.setLightColor("a7_turn_right", 1, 0.25, 0)
            anim.setLightColor("a7_turn_right2", 1, 0.25, 0)
            if not state then
                anim.setLightState("a7_turn_right", state)
                anim.setLightState("a7_turn_right2", state)
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            if anim.getLightState("turn_left") then
                anim.setLightState("a7_turn_left", true)
                anim.setLightState("a7_turn_left2", true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("a7_turn_right", true)
                anim.setLightState("a7_turn_right2", true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            if anim.getLightState("turn_left") then
                anim.setLightState("a7_turn_left", false)
                anim.setLightState("a7_turn_left2", false)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("a7_turn_right", false)
                anim.setLightState("a7_turn_right2", false)
            end
        end
    end,

    lights = {
        {name = "a7_turn_left", material = "a7_turn_left",   brightness = 0.9, color = {1, 0.8, 0}},
        {name = "a7_turn_right", material = "a7_turn_right",   brightness = 0.9, color = {1, 0.8, 0}},
        {name = "a7_turn_left2", material = "leftflash",   brightness = 0.9, color = {1, 0.8, 0}},
        {name = "a7_turn_right2", material = "rightflash",   brightness = 0.9, color = {1, 0.8, 0}},
    }
}


-- Dodge Demon
-- demon_turn работает как стопы и повороты
CustomLights[589] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("demon_turn_right", state)
        end,
        ["brake"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left", 1, 0, 0)
                end
                anim.setLightState("demon_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right", 1, 0, 0)
                end
                anim.setLightState("demon_turn_right", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_left", 1, 0, 0)
                anim.setLightState("demon_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_right", 1, 0, 0)
                anim.setLightState("demon_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_left", 1, 0, 0)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 0, 0)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "demon_turn_left_*",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right", material = "demon_turn_right_*", brightness = 0.8, color = {1, 0.5, 0}},
    }
}
