
-----------------------------------------------

	function createVehicleManipulator(vehicle)

		if manipulators[vehicle] then return end

		local manipulator = Manipulator( {
			vehicle = vehicle,
		} )

	end

-----------------------------------------------

	addEventHandler('onClientVehicleScreenStreamIn', root, function()

		if source.model == Config.vehicle then

			createVehicleManipulator(source)
			
		end

	end)

-------------------------------------------------------

	function destroyVehicleManipulator()

		if manipulators[source] then
			manipulators[source]:destroy()
		end

	end

	addEventHandler('onClientElementStreamOut', root, destroyVehicleManipulator)
	addEventHandler('onClientElementDestroy', root, destroyVehicleManipulator)

-------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

			if isElementOnScreen(vehicle) and getDistanceBetween( vehicle, localPlayer ) < 50
			and vehicle.model == Config.vehicle then
				createVehicleManipulator(vehicle)
			end

		end

	end)

-------------------------------------------------------
