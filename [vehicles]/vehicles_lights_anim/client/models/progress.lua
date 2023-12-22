
--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)

        local config = animatedLightsModels[vehicle.model]

        local anim = getEasingValue(curAnim, 'InOutQuad')

        dxSetShaderValue(data[1], 'progress', anim)

        if config and config.activeAlpha then
            local alpha = massInterpolate( { config.alpha }, { config.activeAlpha }, anim, 'Linear' )
            dxSetShaderValue(data[1], 'alpha', alpha*anim)
        end

    end

--------------------------------------------------------

    local function setup(vehicle)

        local data = animatedLightsModels[vehicle.model]

        animatedLights[vehicle] = {
            dxCreateShader(string.format('assets/shaders/%s.fx', data.shader_name or 'x6m'), 0, 0, true),
        }
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][1], 'alpha', data.alpha or 1)

        local tex_name = data.tex_name or 'cherokee_light_*'

        if type(tex_name) == 'table' then

            for _, tex_name in pairs( tex_name ) do
                engineApplyShaderToWorldTexture(animatedLights[vehicle][1], tex_name, vehicle)
            end

        else
            engineApplyShaderToWorldTexture(animatedLights[vehicle][1], tex_name, vehicle)
        end


    end

    local function remove(vehicle, data)
        destroyElement(data[1])
    end

--------------------------------------------------------

    animatedLightsModels[439] = {
        animationSpeed = 700,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,
    }

    animatedLightsModels[402] = {
        animationSpeed = 700,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,
    }

    animatedLightsModels[540] = {

        animationSpeed = 700,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = 'mark2_lights_f_1',
        shader_name = 'mark2',

    }

    animatedLightsModels[561] = {

        animationSpeed = 700,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = {
            'RS7_white*',
            'RS7F_turn*',
        },
        shader_name = 'mark2',

    }

    animatedLightsModels[405] = {

        animationSpeed = 700,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = 'g63_lights_f_1',
        shader_name = 'g63',

    }

    animatedLightsModels[580] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = 'x6m_*_light*',
        shader_name = 'x6m',

    }

    animatedLightsModels[438] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = 'gt63_lights*',
        shader_name = 'gt63',

    }

    animatedLightsModels[559] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

    }
    
    animatedLightsModels[542] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = 'svj_light_*',
        shader_name = 'g63',

    }

    animatedLightsModels[479] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        alpha = 0,
        activeAlpha = 0.7,

        tex_name = {'std_light_*', 'f90_turn_*'},
        shader_name = 'progress',

    }

    animatedLightsModels[458] = {

        animationSpeed = 400,
        disable = disable,
        enable = enable,
        remove = remove,
        setup = setup,
        render = render,

        tex_name = {'tex_hwd*'},
        shader_name = 'progress',

    }

--------------------------------------------------------