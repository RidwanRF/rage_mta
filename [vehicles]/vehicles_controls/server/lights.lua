function getXenonColor(vehicle)
	local type = vehicle:getData('xenon_type') or 1
	local alpha = vehicle:getData('xenon_alpha') or 1
	local types = exports.vehicles_tuning:getConfigSetting('xenonTypes')

	local r,g,b = unpack( types[type].color )
	r,g,b = r*alpha, g*alpha, b*alpha

	return {r,g,b}

end

local lightsActions = {
	['head']=function(vehicle)
		local xenon = {exports.vehicles_tuning:getXenonColor(vehicle)}
		setVehicleHeadLightColor(vehicle, xenon[1], xenon[2], xenon[3])
		setVehicleOverrideLights(vehicle, 2)

		vehicle:setData('vehicleLightsState', 'head')
	end,
	['hwd']=function(vehicle)
		setVehicleHeadLightColor(vehicle, 0, 0, 0)
		setVehicleOverrideLights(vehicle, 2)
		vehicle:setData('vehicleLightsState', 'hwd')
	end,
	['off']=function(vehicle)
		setVehicleOverrideLights(vehicle, 1)
		vehicle:setData('vehicleLightsState', 'off')
	end,
	['strobo']=function(vehicle)

		local xenon = {exports.vehicles_tuning:getXenonColor(vehicle)}
		setVehicleHeadLightColor(vehicle, xenon[1], xenon[2], xenon[3])
		setVehicleOverrideLights(vehicle, 2)

		vehicle:setData('vehicleLightsState', 'strobo')
	end,
}


function setHeadlightsState(vehicle, state)
	if not isElement(vehicle) then return end

	if lightsActions[state] then
		(lightsActions[state])(vehicle)
	end
end

addEvent("setHeadlightsState", true)
addEventHandler("setHeadlightsState", resourceRoot, setHeadlightsState)