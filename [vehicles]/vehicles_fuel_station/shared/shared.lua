
function getVehicleFuelFit(vehicle, fuelType)
	local config = exports.vehicles_main:getVehicleConfig(vehicle.model)
	return config.fuelTypes[fuelType]
end

function overrideConfig(player)

	local config = exports.vehicles_fuel:getFuelTypesConfig()

	return config
end