
vehiclesTint = {}

function getTintValue(vehicle)
	local tint = {}

	for name in pairs( Config.tint ) do
		tint[name] = vehicle:getData('tint_' .. name) or 0.5
	end

	return tint
end

function setVehicleTint(vehicle, tint, value)
	if vehiclesTint[vehicle] and vehiclesTint[vehicle].shaders then
		dxSetShaderValue(vehiclesTint[vehicle].shaders[tint], 'alpha', value)
	else
		handleTintCreate(vehicle)
	end
end

function setVehicleTintColor(vehicle, color)

	if vehiclesTint[vehicle] and vehiclesTint[vehicle].shaders then

		for name, shader in pairs( vehiclesTint[vehicle].shaders ) do

			local r,g,b = hexToRGB( color or '#000000' )

			if name ~= 'light_glass' then
				dxSetShaderValue(
					shader, 'mColor', { r/255, g/255, b/255 }
				)
			end
			
		end

	else

		handleTintCreate(vehicle)

	end

end

function handleTintCreate(_vehicle)
	local vehicle = _vehicle or source
	if vehicle.type ~= 'vehicle' then return end

	if not vehiclesTint[vehicle] then

		vehiclesTint[vehicle] = {}
		vehiclesTint[vehicle].shaders = {}

		local vehicleTint = getTintValue(vehicle)
		local r,g,b = hexToRGB( vehicle:getData('color_tint') or '#000000' )

		for name, data in pairs(Config.tint) do
			vehiclesTint[vehicle].shaders[name] = createCoverShader('car_glass', true, 1)

			dxSetShaderValue(
				vehiclesTint[vehicle].shaders[name],
				'alpha', vehicleTint[name] * (data.coef or 1)
			)
			dxSetShaderValue(
				vehiclesTint[vehicle].shaders[name],
				'power', data.power or 1
			)

			if name ~= 'light_glass' then

				dxSetShaderValue(
					vehiclesTint[vehicle].shaders[name],
					'mColor', { r/255, g/255, b/255 }
				)

			end

			for _, textureName in pairs(Config.tint[name].textures) do
				engineApplyShaderToWorldTexture(
					vehiclesTint[vehicle].shaders[name],
					textureName,
					vehicle
				)
			end

		end

	end
end

function handleTintDestroy(_vehicle)
	local vehicle = _vehicle or source

	if not vehiclesTint[vehicle] then return end

	for _, shader in pairs( vehiclesTint[vehicle].shaders ) do
		if isElement(shader) then
			destroyElement(shader)
		end
	end

	vehiclesTint[vehicle] = nil

end

local possibleDataNames = {}
for name in pairs( Config.tint ) do
	possibleDataNames['tint_'..name] = name
end
addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if possibleDataNames[dataName] and source.type == 'vehicle' then
		if isElementOnScreen(source) and getDistanceBetween(source, localPlayer) < 50 then
			setVehicleTint(source, possibleDataNames[dataName], new)
		end
	end
end)

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if dataName == 'color_tint' and source.type == 'vehicle' then
		if isElementOnScreen(source) and getDistanceBetween(source, localPlayer) < 50 then
			setVehicleTintColor(source, new)
		end
	end
end)

addEventHandler('onClientVehicleScreenStreamIn', root, handleTintCreate)

addEventHandler('onClientElementStreamOut', root, handleTintDestroy)
addEventHandler('onClientElementDestroy', root, handleTintDestroy)

addEventHandler('onClientResourceStart', resourceRoot, function()
	for _, vehicle in pairs( getElementsByType('vehicle') ) do
		if isElementStreamedIn(vehicle) then
			handleTintCreate(vehicle)
		end
	end	
end)
