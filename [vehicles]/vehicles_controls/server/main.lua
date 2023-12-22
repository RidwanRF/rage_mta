
controlNames = {
	['engine.disabled'] = function(vehicle, value)
		setVehicleEngineState(vehicle, not value)
	end,
	['doors.locked'] = function(vehicle, value)
		setVehicleLocked(vehicle, value)
	end,
	['trunk.opened'] = function(vehicle, value)
		setVehicleDoorOpenRatio(vehicle, 1, value and 1 or 0, 500)
	end,
	['hood.opened'] = function(vehicle, value)
		setVehicleDoorOpenRatio(vehicle, 0, value and 1 or 0, 500)
	end,
}

addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if controlNames[dataName] then
		local func = controlNames[dataName]
		func(source, new)
	end
end)