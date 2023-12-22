
--------------------------------------------------------

    local function applyShaders(vehicle, list, data)
        local listStr = table.concat(list)
        if data.list == listStr then return end

        data.list = listStr
        for k,v in pairs(list) do
            if data[v] then
                engineApplyShaderToWorldTexture(data[v],
                    'chiron_headlight_'..k, vehicle)
            else
                engineRemoveShaderFromWorldTexture(data[1],
                    'chiron_headlight_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[2],
                    'chiron_headlight_'..k, vehicle)
            end
        end
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)
        if curAnim < 0.25 then
            dxSetShaderValue(data[2], 'progress', curAnim*4)
            applyShaders(vehicle, {2, 0, 0, 0}, data)

        elseif curAnim < 0.5 then
            applyShaders(vehicle, {1, 2, 0, 0}, data)
            dxSetShaderValue(data[2], 'progress', (curAnim-0.25)*4)

        elseif curAnim < 0.75 then
            applyShaders(vehicle, {1, 1, 2, 0}, data)
            dxSetShaderValue(data[2], 'progress', (curAnim-0.5)*4)

        elseif curAnim <= 1 then
            applyShaders(vehicle, {1, 1, 1, 2}, data)
            dxSetShaderValue(data[2], 'progress', (curAnim-0.75)*4)
        end

        dxSetShaderValue(data[3], 'progress', curAnim)

    end

--------------------------------------------------------

    local function setup(vehicle)
        animatedLights[vehicle] = {
            dxCreateShader('assets/shaders/chiron.fx', 0, 0, true),
            dxCreateShader('assets/shaders/chiron.fx', 0, 0, true),
            list = '',
            dxCreateShader('assets/shaders/a7_rear.fx', 0, 0, true),
        }

        engineApplyShaderToWorldTexture(animatedLights[vehicle][3], 'cherokee_light_r1', vehicle)
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 1)
        dxSetShaderValue(animatedLights[vehicle][2], 'progress', 0)

        dxSetShaderValue(animatedLights[vehicle][3], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][3], 'r', 1)
        dxSetShaderValue(animatedLights[vehicle][3], 'g', 0)
        dxSetShaderValue(animatedLights[vehicle][3], 'b', 0)
    end

    local function remove(vehicle, data)
        destroyElement(data[1])
        destroyElement(data[2])
    end

--------------------------------------------------------

animatedLightsModels[506] = {
    animationSpeed = 700,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}