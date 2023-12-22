
local CURTAIN_ACTIVE_PROGRESS = 1
local CURTAIN_OPEN_TIME = 2000

curtains = {}

function getVehiclePlateShader(vehicle)
	return appliedShaders[vehicle]
end

function setupVehicleCurtain(eVehicle)
	local vehicle = eVehicle or source
	if vehicle.type ~= 'vehicle' then return end
	if not hasVehicleCurtain(vehicle) then return end

	curtains[vehicle] = getVehiclePlateShader(vehicle)
	timed_setAnimData(vehicle, CURTAIN_OPEN_TIME)
	timed_animate(vehicle, vehicle:getData('number.curtain.state'))
end

function removeVehicleCurtain(eVehicle)
	local vehicle = eVehicle or source
	if isElement(curtains[vehicle]) then
		dxSetShaderValue(curtains[vehicle], 'curtainProgress', 0)
	end
	curtains[vehicle] = nil
end

addEventHandler('onClientRender', root, function()


	local animData
	for vehicle, shader in pairs(curtains) do
		if isElement(vehicle) and shader and isElementOnScreen(vehicle) then
			if isElement(shader) then
				animData = timed_getAnimData(vehicle) or 0
				dxSetShaderValue(shader, 'curtainProgress', animData * CURTAIN_ACTIVE_PROGRESS)
			end
		end
	end

end)

addEventHandler('onClientElementStreamOut', root, removeVehicleCurtain)
addEventHandler('onClientElementDestroy', root, removeVehicleCurtain)

function applyCurtains()
	for _, vehicle in pairs( getElementsByType('vehicle') ) do
		if isElementStreamedIn(vehicle) then
			setupVehicleCurtain(vehicle)
		end
	end
end

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if dataName == 'number.curtain.state' then

		if not timed_getAnimData(source) then
			setupVehicleCurtain(source)
		end

		timed_animate(source, new)

	elseif dataName == 'plate_curtain' then

		if hasVehicleCurtain(source) then
			setupVehicleCurtain(source)
		else
			removeVehicleCurtain(source)
		end

	end
end)
