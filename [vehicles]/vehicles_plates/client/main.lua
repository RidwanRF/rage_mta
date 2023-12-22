

setHeatHaze(0)

shaders = {}
textures = {}
appliedShaders = {}

addEventHandler('onClientVehicleScreenStreamIn', root, function()
    if source.type == 'vehicle' then
        applyPlateToVehicle(source)
    end
end)

addEventHandler('onClientElementStreamOut', root, function()
    if source.type == 'vehicle' then
		if isElement(appliedShaders[source]) then
			destroyElement(appliedShaders[source])
			appliedShaders[source] = nil
		end	
    end
end)

local possibleDataNames = {
	['plate'] = true,
}
addEventHandler('onClientElementDataChange', root, function(key, oldValue)
	if source.type == 'vehicle' and possibleDataNames[key] then
		if isElementOnScreen(source) and getDistanceBetween(source, localPlayer) < 50 then
			applyPlateToVehicle(source)
		end
	end
end)

function applyPlateToVehicle(vehicle, _plate)

	if not isElement(vehicle) then return end

	local plateID = _plate or getVehiclePlateText(vehicle)

	-- if (not plateID) then return end

	if not gameScreenState then
		return table.insert(delayedPlates, vehicle)
	end

	if not isElement(shaders[plateID]) then
		if not isElement(textures[plateID]) then
			if ( not generatePlate(plateID, vehicle.model) ) then return end
		end

		if vehicle:getData('noLoadShaders') then
			shaders[plateID] = dxCreateShader('assets/shaders/texreplace.fx', 0, 100, false, 'vehicle')
		else
			shaders[plateID] = dxCreateShader('assets/shaders/number.fx', 0, 100, false, 'vehicle')
		end

		-- dxSetShaderValue(shaders[plateID], 'gTexture', emptyTexture)
		dxSetShaderValue(shaders[plateID], 'gTexture', textures[plateID])
	end

	if isElement(appliedShaders[vehicle]) then
		engineRemoveShaderFromWorldTexture(appliedShaders[vehicle], 'Nomer', vehicle)
		engineRemoveShaderFromWorldTexture(appliedShaders[vehicle], 'nomer', vehicle)
		engineRemoveShaderFromWorldTexture(appliedShaders[vehicle], 'rpbox_nomer', vehicle)
	end

	appliedShaders[vehicle] = shaders[plateID]
    engineApplyShaderToWorldTexture(shaders[plateID], 'Nomer', vehicle)
    engineApplyShaderToWorldTexture(shaders[plateID], 'nomer', vehicle)
    engineApplyShaderToWorldTexture(shaders[plateID], 'rpbox_nomer', vehicle)

    setupVehicleCurtain(vehicle)

end

function apllyPlatesToAllCars()
	for _, vehicle in ipairs( getElementsByType('vehicle', root, true) ) do
		applyPlateToVehicle(vehicle)
	end
end