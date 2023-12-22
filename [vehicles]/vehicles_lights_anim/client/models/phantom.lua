

local object = {
    { 0, 2.739045381546, 0.30372109532356 },
    { 0, 2.739045381546, 0.43372109532356 },
}

local object2 = {
    { 0, 2.739045381546, 0.43372109532356 },
    { 0, 2.239045381546, 0.43372109532356 },
}


local frontColors = {
    {
        progress=0,
        color={100, 100, 100},
    },
    {
        progress=0.1,
        color={200,200,200},
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
        progress=0.4,
        name='rolls_lights_r_1',
    },
}

local frontLightsCount = 4

--------------------------------------------------------

    local function applyShaders(vehicle, list, data)
        local listStr = table.concat(list)
        if data.list == listStr then return end

        data.list = listStr
        for k,v in pairs(list) do
            if data[v] then
                engineApplyShaderToWorldTexture(data[v],
                    'rolls_lights_f_'..k, vehicle)

                engineRemoveShaderFromWorldTexture(data[3-v],
                    'rolls_lights_f_'..k, vehicle)
            else
                engineRemoveShaderFromWorldTexture(data[1],
                    'rolls_lights_f_'..k, vehicle)
                engineRemoveShaderFromWorldTexture(data[2],
                    'rolls_lights_f_'..k, vehicle)
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

        dxSetShaderValue(data[5], 'progress', curAnim)

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

            local x1,y1,z1 = unpack(object[1])
            local x2,y2,z2 = unpack(object[2])

            local x,y,z = interpolateBetween(
                x1,y1,z1, x2,y2,z2, curAnim, 'InOutQuad'
            )

            setVehicleComponentPosition(vehicle, 'rolls', x,y,z)

            local x1,y1,z1 = unpack(object2[1])
            local x2,y2,z2 = unpack(object2[2])

            local x,y,z = interpolateBetween(
                x1,y1,z1, x2,y2,z2, curAnim, 'InOutQuad'
            )

            setVehicleComponentPosition(vehicle, 'rolls2', x,y,z)
            
        end
    end

--------------------------------------------------------    

    local function setup(vehicle)
        animatedLights[vehicle] = {
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            dxCreateShader('assets/shaders/cadillac.fx', 0, 0, true),
            '',
            dxCreateShader('assets/shaders/phantom_1.fx', 1, 0, true),
        }
            
        dxSetShaderValue(animatedLights[vehicle][1], 'progress', 1)
        dxSetShaderValue(animatedLights[vehicle][2], 'progress', 0)
        dxSetShaderValue(animatedLights[vehicle][3], 'progress', 0)

        dxSetShaderValue(animatedLights[vehicle][5], 'progress', 0)

        engineApplyShaderToWorldTexture(animatedLights[vehicle][5], 'wheel_logo', vehicle)

    end

    local function remove(vehicle, data)
        destroyElement(data[1])
        destroyElement(data[2])
        destroyElement(data[3])
    end

--------------------------------------------------------

animatedLightsModels[604] = {
    animationSpeed = 800,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}
