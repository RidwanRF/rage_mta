function doRepairVehicle(vehicle)
	antiDOSsend("fix", 500, "fixVehicle", resourceRoot, vehicle)
end
addEvent('doRepairVehicle', true)
addEventHandler('doRepairVehicle', root, doRepairVehicle)

function doFlipVehicle(vehicle)
	local rX, rY, rZ = getElementRotation(vehicle)
	setElementRotation(vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)    
	setVehicleTurnVelocity(vehicle, 0, 0, 0)
end
addEvent('doFlipVehicle', true)
addEventHandler('doFlipVehicle', root, doFlipVehicle)

function repairVehicle()

	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then

		if localPlayer:getData('binds.disabled') then return end

		doRepairVehicle(vehicle)
	end
end
addCommandHandler("repair", repairVehicle)
bindKey("1", "down", repairVehicle)

function flipVehicle()

	if localPlayer.vehicle then

		if localPlayer:getData('binds.disabled') then return end

		doFlipVehicle(localPlayer.vehicle)
	end

end
addCommandHandler("flip", flipVehicle)
bindKey("2", "down", flipVehicle)

----------------------------------------------------------------

	addEventHandler('onClientPlayerVehicleEnter', localPlayer, function(vehicle, seat)
		if seat == 0 and vehicle:getData('engine.disabled') then
			exports.hud_notify:notify('Нажмите X', 'Чтобы запустить двигатель', 6000)
		end
	end)

----------------------------------------------------------------
	
	-- фиксит е70
	addEventHandler('onClientKey', root, function(button)

		if localPlayer.vehicle and localPlayer.vehicle.model == 490 and button == 'h' then
			cancelEvent()
		end

	end	)

----------------------------------------------------------------