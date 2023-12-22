streamedVehicles = {}
streamedVehicles_models = {}

local function toggleVehicleStream( vehicle, flag )

	if flag then

		streamedVehicles[vehicle] = {}
		streamedVehicles_models[vehicle.model] = streamedVehicles_models[vehicle.model] or {}
		streamedVehicles_models[vehicle.model][vehicle] = {}
		
	else

		streamedVehicles[vehicle] = nil
		streamedVehicles_models[vehicle.model] = streamedVehicles_models[vehicle.model] or {}
		streamedVehicles_models[vehicle.model][vehicle] = nil

	end

end

local events = {
	onClientElementStreamIn = true,
	onClientElementStreamOut = false,
	onClientElementDestroy = false,
}

for ev_name in pairs( events ) do
	addEventHandler(ev_name, root, function()

		if source.type == 'vehicle' then
			toggleVehicleStream(source, events[eventName])
		end

	end)
end

addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, vehicle in pairs(getElementsByType('vehicle', root, true)) do
		if isElement(vehicle) and isElementOnScreen(vehicle) then

			streamedVehicles[vehicle] = {}
			streamedVehicles_models[vehicle.model] = streamedVehicles_models[vehicle.model] or {}
			streamedVehicles_models[vehicle.model][vehicle] = {}

		end
	end

end)