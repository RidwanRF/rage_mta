
--------------------------------------------------------

    local function applyShaders(vehicle, list, data)
        local listStr = table.concat(list)
        if data.list == listStr then return end

        data.list = listStr
        for k,v in pairs(list) do
            if data[v] then
                engineApplyShaderToWorldTexture(data[v],
                    'camry_turn_right_'..k, vehicle)
                engineApplyShaderToWorldTexture(data[v],
                    'camry_turn_left_'..k, vehicle)

                engineRemoveShaderFromWorldTexture(data[3-v],
                    'camry_turn_right_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[3-v],
                    'camry_turn_left_'..k, vehicle)
            else
                engineRemoveShaderFromWorldTexture(data[1],
                    'camry_turn_right_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[2],
                    'camry_turn_right_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[1],
                    'camry_turn_left_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[2],
                    'camry_turn_left_'..k, vehicle)
            end
        end
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)
        dxSetShaderValue(data[3], 'progress', getEasingValue(curAnim, 'InOutQuad'))

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
    end

--------------------------------------------------------

    local function setup(vehicle)
        animatedLights[vehicle] = {
            dxCreateShader('assets/shaders/camry.fx', -1, 0, true),
            dxCreateShader('assets/shaders/camry.fx', -1, 0, true),
            dxCreateShader('assets/shaders/camry_rear.fx', -1, 0, true),
            list = '',
        }
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 1)
        dxSetShaderValue(animatedLights[vehicle][2], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][3], 'progress', 0)

        engineApplyShaderToWorldTexture(animatedLights[vehicle][3], 'camry_rear_light_0', vehicle)
    end

    local function remove(vehicle, data)
        destroyElement(data[1])
        destroyElement(data[2])
        destroyElement(data[3])
    end

--------------------------------------------------------

animatedLightsModels[426] = {
    animationSpeed = 1000,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}