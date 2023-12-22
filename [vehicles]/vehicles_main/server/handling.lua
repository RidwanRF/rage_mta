

addEventHandler('onResourceStart', resourceRoot, function()

	for model, vehicle in pairs( Config.vehicles ) do

		if vehicle.properties and vehicle.properties.max_velocity then

			if vehicle.properties.max_velocity then
				setModelHandling(model, 'maxVelocity', vehicle.properties.max_velocity)
			end
		end
	end
end)