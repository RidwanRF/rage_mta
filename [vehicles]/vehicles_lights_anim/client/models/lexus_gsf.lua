
local rearColors = {
    {
        progress=0,
        color={0,0,0},
    },
    {
        progress=0.4,
        color={100,100,100},
    },
    {
        progress=1,
        color={255,255,255},
    },
}
local frontColors = {
    {
        progress=0,
        color={0,0,0},
    },
    {
        progress=0.4,
        color={80,5,20},
    },
    {
        progress=1,
        color={255,255,255},
    },
}

--------------------------------------------------------

    local function applyShader(shaders, vehicle)
        engineApplyShaderToWorldTexture(shaders.frontLights, 'GSF_brake_0', vehicle)
        engineApplyShaderToWorldTexture(shaders.rearLights, 'GSF_brake_1', vehicle)
        engineApplyShaderToWorldTexture(shaders.rearLights, 'headlights', vehicle)
    end

    local function removeShader(shaders, vehicle)
        engineRemoveShaderFromWorldTexture(shaders.frontLights, 'GSF_brake_0', vehicle)
        engineRemoveShaderFromWorldTexture(shaders.rearLights, 'GSF_brake_1', vehicle)
        engineRemoveShaderFromWorldTexture(shaders.rearLights, 'headlights', vehicle)
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)
        local nextColor, r,g,b

        for index, color in pairs(frontColors) do
            if curAnim > color['progress'] then
                nextColor = frontColors[index + 1] or frontColors[index]

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
        for index, color in pairs(rearColors) do
            if curAnim > color['progress'] then
                nextColor = rearColors[index + 1] or rearColors[index]

                r,g,b = interpolateBetween(
                    color['color'][1], color['color'][2], color['color'][3],
                    nextColor['color'][1], nextColor['color'][2], nextColor['color'][3],
                    (curAnim-color['progress'])/(nextColor['progress']-color['progress']), 'InOutQuad')

                dxSetShaderValue(data.rearLights, 'r', r/255)
                dxSetShaderValue(data.rearLights, 'g', g/255)
                dxSetShaderValue(data.rearLights, 'b', b/255)
                dxSetShaderValue(data.rearLights, 'progress', curAnim)
            end
        end
    end

--------------------------------------------------------

    local function setup(vehicle)
        local frontShader = dxCreateShader('assets/shaders/fenyr.fx', 0, 0, true)
        local rearShader = dxCreateShader('assets/shaders/fenyr.fx', 0, 0, true)

        animatedLights[vehicle] = {
            frontLights = frontShader,
            rearLights = rearShader,
        }

        applyShader(animatedLights[vehicle], vehicle)
    end

    local function remove(vehicle, data)
        removeShader(data, vehicle)
        destroyElement(data.frontLights)
        destroyElement(data.rearLights)
    end

--------------------------------------------------------

    local function enable(vehicle, data)
        applyShader(data, vehicle)
    end

    local function disable(vehicle, data)
        removeShader(data, vehicle)
    end

--------------------------------------------------------

animatedLightsModels[596] = {
    animationSpeed = 1000,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}