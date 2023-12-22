
pcall( loadstring( exports.core:include('common') ) )

function isBetween(val, min, max)
    return val >= min and val <= max
end

function setVehicleLightsColor(vehicle, coef)
	local xenon = {255,255,255}
	local data = vehicle:getData("xenon")
	if (data) then
		data = split(data, ",")
		if (#data >= 3) then
			xenon = data
		end
	end
	setVehicleHeadLightColor(vehicle, xenon[1]*coef, xenon[2]*coef, xenon[3]*coef)
end

local coloredStroboColor = {0, 0, 0}
local coloredStroboStep = 20
local coloredStroboDirection = false

local stroboFunctions = {
    [1]=(function(veh, coef)
    	setVehicleLightsColor(veh, coef)
    end),
    [2]=(function(veh, coef)

        local r,g,b = hexToRGB( veh:getData('xenon_color') or '#ffffff' )
        setVehicleHeadLightColor(veh, r*coef, g*coef, b*coef)

    end),
    [3]=(function(veh, coef)
        local r,g,b = unpack(coloredStroboColor)

        if coloredStroboDirection then
            r = r + coloredStroboStep
            if r >= 255 then
                r = 255
                g = g + coloredStroboStep
                if g >= 255 then
                    g = 255

                    b = b + coloredStroboStep

                    if b >= 255 then
                        b = 255
                        coloredStroboDirection = false
                    end
                end
            end
        else
            r = r - coloredStroboStep
            if r <= 0 then
                r = 0
                g = g - coloredStroboStep
                if g <= 0 then
                    g = 0

                    b = b - coloredStroboStep

                    if b <= 0 then
                        b = 0
                        coloredStroboDirection = true
                    end
                end
            end
        end
        coloredStroboColor = {r,g,b}
        setVehicleHeadLightColor(veh, r, g, b)
    end)
}

local tick = 0

local coefs = {
    [1]=0,
    [2]=0,
    [3]=0,
}
setTimer(function()
    tick = tick + 1

    coefs[1] = math.abs(math.sin(math.floor(tick/2)))
    coefs[2] = math.abs(math.sin(math.floor(getTickCount())))
    coefs[3] = math.abs(math.sin(math.floor(getTickCount())))
end, 75, 0)

addEventHandler('onClientRender', root, function()
    for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
        if isElementOnScreen(vehicle) then
            if vehicle:getData('vehicleLightsState') == 'strobo'
            and (vehicle:getData('strobo') or 0) > 0
            then
                local stroboType = vehicle:getData('strobo')
                if stroboType and stroboFunctions[stroboType] then
                    stroboFunctions[stroboType](vehicle, coefs[stroboType])
                end
            end
        end
    end
end)

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
    if source.type == 'vehicle' and dataName == 'strobo' and not new
    and source == localPlayer.vehicle then
        exports.vehicles_controls:updateState('head', true)
    end
end)
