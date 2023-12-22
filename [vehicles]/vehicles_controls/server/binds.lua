
addEvent("fixVehicle", true)
addEventHandler("fixVehicle", resourceRoot, function(vehicle)
	if isElement(vehicle) then
		for i = 0, 5 do
			setVehicleDoorOpenRatio(vehicle, i, 0, 0.5)
			setVehicleDoorState(vehicle, i, 0)
		end
		fixVehicle(vehicle)
	end
end)