
--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)

        local parts = divideAnim(curAnim, 3)

        for index, part in pairs(parts) do

            local _index = index-1

            if part >= 0.99 then

                engineApplyShaderToWorldTexture(data[2], 'cherokee_light_f'.._index, vehicle)
                engineApplyShaderToWorldTexture(data[2], 'cherokee_light_r'.._index, vehicle)
                engineRemoveShaderFromWorldTexture(data[1], 'cherokee_light_f'.._index, vehicle)
                engineRemoveShaderFromWorldTexture(data[1], 'cherokee_light_r'.._index, vehicle)

            else

                dxSetShaderValue(data[1], 'progress', getEasingValue(part, 'InOutQuad'))

                engineRemoveShaderFromWorldTexture(data[2], 'cherokee_light_f'.._index, vehicle)
                engineRemoveShaderFromWorldTexture(data[2], 'cherokee_light_r'.._index, vehicle)
                engineApplyShaderToWorldTexture(data[1], 'cherokee_light_f'.._index, vehicle)
                engineApplyShaderToWorldTexture(data[1], 'cherokee_light_r'.._index, vehicle)

                for _i = _index+1, #parts-1 do
                    engineRemoveShaderFromWorldTexture(data[1], 'cherokee_light_f'.._i, vehicle)
                    engineRemoveShaderFromWorldTexture(data[1], 'cherokee_light_r'.._i, vehicle)
                end

                break

            end

        end

    end

--------------------------------------------------------

    local function setup(vehicle)

        animatedLights[vehicle] = {
            dxCreateShader('assets/shaders/x6m.fx', 0, 0, true),
            dxCreateShader('assets/shaders/x6m.fx', 0, 0, true),
        }
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][2], 'progress', 1)

    end

    local function remove(vehicle, data)
        destroyElement(data[1])
        destroyElement(data[2])
    end

--------------------------------------------------------

animatedLightsModels[422] = {
    animationSpeed = 500,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}