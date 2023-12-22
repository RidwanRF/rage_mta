
vehicleIds = {}

function getVehicleById(id)

	if isElement(vehicleIds[id]) and vehicleIds[id].type == 'vehicle' and vehicleIds[id]:getData('id') == id
	then
		return vehicleIds[id]
	end

	for _, vehicle in pairs( getElementsByType('vehicle', resoureRoot) ) do
		local _id = vehicle:getData('id')
		if _id == id then
			vehicleIds[id] = vehicle
			return vehicle
		end
	end
end

function convertVehicleToModel(vehicle)
	return isElement(vehicle) and vehicle.model or tonumber(vehicle)
end


function getVehicleModName(vehicle)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return string.format('%s %s',
			Config.vehicles[model].mark,
			Config.vehicles[model].name
		)
	else
		return getVehicleNameFromModel(model)
	end

end

function getVehicleCost(vehicle)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return Config.vehicles[model].cost, Config.vehicles[model].donate
	else
		return 0, false
	end

end

function getVehicleProperty(vehicle, property)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return Config.vehicles[model].properties[property]
	else
		return 0
	end

end

function getVehicleLots(vehicle)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return Config.vehicles[model].lots or 1
	else
		return 1
	end

end

function getVehicleSetting(vehicle, name)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return Config.vehicles[model][name]
	else
		return false
	end

end

function getVehicleConfig(vehicle)
	local model = convertVehicleToModel(vehicle)

	if Config.vehicles[model] then
		return Config.vehicles[model]
	else
		return 0
	end

end
