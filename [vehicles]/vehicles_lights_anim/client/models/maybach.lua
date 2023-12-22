
local colors = {
    {
        progress=0,
        color={0,0,0},
    },
    {
        progress=0.4,
        color={20,5,80},
    },
    {
        progress=1,
        color={255,255,255},
    },
}

local rearGlassApplyData = {
    {
        progress=0.05,
        name='s650_brake_0',
    },
    {
        progress=0.1,
        name='s650_brake_1',
    },
    {
        progress=0.15,
        name='s650_brake_2',
    },
    {
        progress=0.2,
        name='s650_brake_3',
    },
    {
        progress=0.25,
        name='s650_brake_4',
    },
    {
        progress=0.3,
        name='s650_brake_5',
    },
    {
        progress=0.35,
        name='s650_brake_6',
    },
    {
        progress=0.4,
        name='s650_brake_7',
    },
    {
        progress=0.45,
        name='s650_brake_8',
    },
}

--------------------------------------------------------

    local function applyShader(shader, vehicle)
        engineApplyShaderToWorldTexture(shader, 's650_turn_right_0', vehicle)
        engineApplyShaderToWorldTexture(shader, 's650_turn_left_0', vehicle)
    end

    local function removeShader(shader, vehicle)
        engineRemoveShaderFromWorldTexture(shader, 's650_turn_right_0', vehicle)
        engineRemoveShaderFromWorldTexture(shader, 's650_turn_left_0', vehicle)
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)
        local nextColor, r,g,b

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
        local frontShader = dxCreateShader('assets/shaders/maybach.fx', -1, 0, true)
        local rearShader = dxCreateShader('assets/shaders/maybach_rear.fx', -1, 0, true)

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

animatedLightsModels[418] = {
    animationSpeed = 1000,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}