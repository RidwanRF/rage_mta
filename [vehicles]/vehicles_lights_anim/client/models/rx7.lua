
local object = {
    { 0, 1.8099999427795, 0.24099999666214, 0, 0, 0 },
    { 0, 1.8099999427795, 0.24099999666214, 40, 0, 0 },
}

--------------------------------------------------------

    local function render(vehicle, data, curAnim, flag)

        local x1,y1,z1,rx1,ry1,rz1 = unpack(object[1])
        local x2,y2,z2,rx2,ry2,rz2 = unpack(object[2])

        local x,y,z = interpolateBetween(
            x1,y1,z1, x2,y2,z2, curAnim, 'InOutQuad'
        )

        local rx,ry,rz = interpolateBetween(
            rx1,ry1,rz1, rx2,ry2,rz2, curAnim, 'InOutQuad'
        )

        setVehicleComponentPosition(vehicle, 'head_lights0', x,y,z)
        setVehicleComponentRotation(vehicle, 'head_lights0', rx,ry,rz)
            
    end

--------------------------------------------------------    

    local function setup(vehicle)
        animatedLights[vehicle] = true
    end

    local function remove(vehicle, data)
    end

--------------------------------------------------------


animatedLightsModels[555] = {
    animationSpeed = 1400,
    disable = disable,
    enable = enable,
    remove = remove,
    setup = setup,
    render = render,
}
