local colors = {
    {
        progress=0,
        color={0,0,0},
    },
    {
        progress=0.4,
        color={0,255,255},
    },
    {
        progress=1,
        color={0,150,255},
    },
}

local rearGlassApplyData = {
    {
        progress=0.1,
        name='divo_rear_1',
    },
    {
        progress=0.2,
        name='divo_rear_2',
    },
    {
        progress=0.3,
        name='divo_rear_3',
    },
    {
        progress=0.4,
        name='divo_rear_4',
    },
    {
        progress=0.5,
        name='divo_rear_5',
    },
    {
        progress=0.6,
        name='divo_rear_6',
    },
    {
        progress=0.7,
        name='divo_rear_7',
    },
    {
        progress=0.8,
        name='divo_rear_8',
    },
    {
        progress=0.9,
        name='divo_rear_9',
    },
    {
        progress=0.95,
        name='divo_rear_10',
    },
}

--------------------------------------------------------

    local function applyShader(shader, vehicle)
        engineApplyShaderToWorldTexture(shader, 'divo_light_1', vehicle)
    end

    local function removeShader(shader, vehicle)
        engineRemoveShaderFromWorldTexture(shader, 'divo_light_1', vehicle)
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)
        for index, color in pairs(colors) do
            if curAnim > color['progress'] then
                nextColor = colors[index + 1] or colors[index]

                r,g,b = interpolateBetween(
                    color['color'][1], color['color'][2], color['color'][3],
                    nextColor['color'][1], nextColor['color'][2], nextColor['color'][3],
                    (curAnim-color['progress'])/(nextColor['progress']-color['progress']), 'InOutQuad')

                dxSetShaderValue(data.frontLights, 'r', r/255)
                dxSetShaderValue(data.frontLights, 'g', g/255)
                dxSetShaderValue(data.frontLights, 'b', b/255)
                dxSetShaderValue(data.frontLights, 'progress', curAnim)
            end
        end
        for _, applyData in pairs(rearGlassApplyData) do
            if curAnim > applyData['progress'] then
                engineApplyShaderToWorldTexture(data.rearLights, applyData['name'], vehicle)
            else
                engineRemoveShaderFromWorldTexture(data.rearLights, applyData['name'], vehicle)
            end
        end
    end

--------------------------------------------------------

    local function setup(vehicle)
        local frontShader = dxCreateShader('assets/shaders/divo.fx', -1, 0, true)
        local rearShader = dxCreateShader('assets/shaders/divo_rear.fx', -1, 0, true)

        dxSetShaderValue(frontShader, 'r', 0)
        dxSetShaderValue(frontShader, 'g', 0)
        dxSetShaderValue(frontShader, 'b', 0)

        applyShader(frontShader, vehicle)
        animatedLights[vehicle] = {
            frontLights = frontShader,
            rearLights = rearShader,
        }
    end

    local function remove(vehicle, data)
        removeShader(data.frontLights, vehicle)
        destroyElement(data.frontLights)
        removeShader(data.rearLights, vehicle)
        destroyElement(data.rearLights)
    end

--------------------------------------------------------

    local function enable(vehicle, data)
        applyShader(data.frontLights, vehicle)
    end

    local function disable(vehicle, data)
        removeShader(data.frontLights, vehicle)
    end

--------------------------------------------------------

animatedLightsModels[545] = {
    animationSpeed = 500,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}