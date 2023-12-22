


----------------------------------------
	
	local model = 587

	local config = {
		x = 0.4,
		y = 1.0,
		z = 0.1,
	}

	addEventHandler('onClientRender', root, function()

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

			if isElementOnScreen( vehicle ) and vehicle.model == 587 then

				local left_progress = getVehicleDoorOpenRatio( vehicle, 2 )

				resetVehicleComponentPosition( vehicle, 'door_l' )
				local x,y,z = getVehicleComponentPosition( vehicle, 'door_l' )

				setVehicleComponentPosition( vehicle, 'door_l',
					x - config.x * left_progress,
					y - config.y * left_progress,
					z + config.z * left_progress
				)

				local right_progress = getVehicleDoorOpenRatio( vehicle, 3 )

				resetVehicleComponentPosition( vehicle, 'door_r' )
				local x,y,z = getVehicleComponentPosition( vehicle, 'door_r' )

				setVehicleComponentPosition( vehicle, 'door_r',
					x + config.x * right_progress,
					y - config.y * right_progress,
					z + config.z * right_progress
				)


			end

		end

	end)

----------------------------------------