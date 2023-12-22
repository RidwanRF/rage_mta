
addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'fuel_type' then

		setTimer(function(source, old, new)

			if not isElement(source) then return end

			local change = 0

			if old then
				local config = Config.fuelTypes[old] or {}
				change = change - (config.maxSpeedAdd or 0)
			end

			if new then
				local config = Config.fuelTypes[new] or {}
				change = change + (config.maxSpeedAdd or 0)
			end

			local curr_velocity = getVehicleHandling ( source )[ 'maxVelocity' ]
			setVehicleHandling(source, 'maxVelocity',
				curr_velocity + change
			)

		end, 500, 1, source, old, new)

	end
end)

addEventHandler('onVehicleEnter', root, function(player, seat)
	if seat == 0 then
		if source:getData('engine.disabled') then
			source:setEngineState(false)
		end
	end
end)