function getFuelTypesConfig()
	return Config.fuelTypes
end

function getFuelSpeedAdd(vehicle)
	local fuelType = vehicle:getData('fuel_type') or ''

	local config = Config.fuelTypes[fuelType]
	if config then
		return config.maxSpeedAdd
	end
end