addEvent('backupVehiclePosition', true)
addEventHandler('backupVehiclePosition', resourceRoot, function(savedPos)

	local vehicle = getPedOccupiedVehicle(client)
	if not vehicle then return end

	spawnVehicle(vehicle,
		savedPos[1][1], savedPos[1][2], savedPos[1][3],
		savedPos[2][1], savedPos[2][2], savedPos[2][3]
	)

end)