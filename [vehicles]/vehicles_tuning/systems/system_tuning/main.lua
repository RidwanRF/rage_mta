

function showTuning(vehicle, name)
	for _, cNname in pairs(split(name, ' ')) do
		vehicle:setComponentVisible(cNname, true)
	end
end

function hideTuning(vehicle, name)
	for _, cNname in pairs(split(name, ' ')) do
		vehicle:setComponentVisible(cNname, false)
	end
end

function updateVehicleTuning(vehicle)
	local vehicle = vehicle or source
	if vehicle.type ~= 'vehicle' then return end
	
	local tuning = vehicle:getData('tuning') or {}

	if Config.componentsTuning[vehicle.model] then
		for section, components in pairs( Config.componentsTuning[vehicle.model] ) do

			if tuning[section] then

				for cName, component in pairs( components ) do
					hideTuning(vehicle, component.componentName)
				end

				local _tuning = Config.componentsTuning
					[vehicle.model]
					[section]
					[ tuning[section] ]

				showTuning(vehicle,
					(_tuning or {}).componentName or tuning[section]
				)

			else

				local show

				for cName, component in pairs( components ) do

					if component.default then
						show = component.componentName
					else
						hideTuning(vehicle, component.componentName)
					end

				end

				if show then
					showTuning(vehicle, show)
				end

			end

		end
	end

end

addEventHandler('onClientVehicleScreenStreamIn', root, updateVehicleTuning)
addEventHandler('onClientElementDataChange', root, function(dataName)
	if dataName == 'tuning' then
		updateVehicleTuning(source)
	end
end)