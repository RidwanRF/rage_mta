

local lowHPcars = {}
setTimer(function()
	for vehicle, _ in pairs(lowHPcars) do
		if isElement(vehicle) then
			if (getElementHealth(vehicle) > 256) then
				setVehicleDamageProof(vehicle, false)
				lowHPcars[vehicle] = nil
			else
				local rotX = getElementRotation(vehicle)
				if (rotX < 90) or (rotX > 270) then
					setVehicleDamageProof(vehicle, false)
					lowHPcars[vehicle] = nil
				end
			end
		else
			lowHPcars[vehicle] = nil
		end
	end
	for _, vehicle in ipairs(getElementsByType("vehicle", getResourceRoot('vehicles_main'))) do
		if (getElementHealth(vehicle) < 256) then
			setElementHealth(vehicle, 256)
			setVehicleDamageProof(vehicle, true)
			lowHPcars[vehicle] = true
		end
	end
end, 1000, 0)