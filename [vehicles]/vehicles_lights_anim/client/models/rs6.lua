
local frontColors = {
    {
        progress=0,
        color={100, 100, 100},
    },
    {
        progress=0.2,
        color={100,100,100},
    },
    {
        progress=0.9,
        color={255,255,255},
    },
}

local rearColors = {
    {
        progress=0,
        color={80, 0, 0},
    },
    {
        progress=0.5,
        color={0,0,100},
    {
    },
        progress=0.9,
        color={255,0,0},
    },
}

local rearGlassApplyData = {
    {
        progress=0.2,
        name='rs6_light_r_1',
    },
    {
        progress=0.4,
        name='rs6_light_r_2',
    },
    {
        progress=0.6,
        name='rs6_light_r_3',
    },
    {
        progress=0.8,
        name='rs6_light_r_4',
    },
    {
        progress=0.9,
        name='rs6_light_r_5',
    },
}

local frontLightsCount = 6

--------------------------------------------------------

    local function applyShaders(vehicle, list, data)
        local listStr = table.concat(list)
        if data.list == listStr then return end

        data.list = listStr
        for k,v in pairs(list) do
            if data[v] then
                engineApplyShaderToWorldTexture(data[v],
                    'rs6_light_f_'..k, vehicle)

                engineRemoveShaderFromWorldTexture(data[3-v],
                    'rs6_light_f_'..k, vehicle)
            else
                engineRemoveShaderFromWorldTexture(data[1],
                    'rs6_light_f_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[2],
                    'rs6_light_f_'..k, vehicle)
            end
        end
    end

--------------------------------------------------------

    local function setColor(shader, progress)
        for index, color in pairs(frontColors) do
            if progress > color['progress'] then
                nextColor = frontColors[index + 1] or frontColors[index]

                r,g,b = interpolateBetween(
                    color['color'][1], color['color'][2], color['color'][3],
                    nextColor['color'][1], nextColor['color'][2], nextColor['color'][3],
                    (progress-color['progress'])/(nextColor['progress']-color['progress']), 'InOutQuad')

                dxSetShaderValue(shader, 'r', r/255)
                dxSetShaderValue(shader, 'g', g/255)
                dxSetShaderValue(shader, 'b', b/255)
                dxSetShaderValue(shader, 'progress', progress)
            end
        end
    end

    local function setRearColor(shader, progress)
        for index, color in pairs(rearColors) do
            if progress > color['progress'] then
                nextColor = rearColors[index + 1] or rearColors[index]

                r,g,b = interpolateBetween(
                    color['color'][1], color['color'][2], color['color'][3],
                    nextColor['color'][1], nextColor['color'][2], nextColor['color'][3],
                    (progress-color['progress'])/(nextColor['progress']-color['progress']), 'InOutQuad')

                dxSetShaderValue(shader, 'r', r/255)
                dxSetShaderValue(shader, 'g', g/255)
                dxSetShaderValue(shader, 'b', b/255)
                dxSetShaderValue(shader, 'progress', progress)
            end
        end
    end

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)

        setColor(data[1], 1)

        local curList = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

        if curAnim < 0.01 then
            applyShaders(vehicle, curList, data)
        else

            local step = 1/frontLightsCount

            for i = 1, frontLightsCount do
                if curAnim < (step*i) then

                    local anim = (curAnim - step*(i - 1))*frontLightsCount

                    dxSetShaderValue(data[2], 'progress', anim)
                    setColor(data[2], anim)


                    curList[i] = 2
                    for i1 = 1, i do
                        if i1 > 1 then
                            curList[i1-1] = 1
                        end
                    end
                    applyShaders(vehicle, curList, data)

                    break
                end
            end

            setRearColor(data[3], curAnim)
            for _, applyData in pairs(rearGlassApplyData) do
                if curAnim > applyData['progress'] then

                    engineApplyShaderToWorldTexture(data[3], applyData['name'], vehicle)
                else
                    engineRemoveShaderFromWorldTexture(data[3], applyData['name'], vehicle)
                end
            end
        end
    end

--------------------------------------------------------    

    local function setup(vehicle)
        animatedLights[vehicle] = {
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            '',
        }
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 1)
        dxSetShaderValue(animatedLights[vehicle][2], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][3], 'progress', 0)
    end

    local function remove(vehicle, data)
        destroyElement(data[1])
        destroyElement(data[2])
        destroyElement(data[3])
    end

--------------------------------------------------------

animatedLightsModels[492] = {
    animationSpeed = 400,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}