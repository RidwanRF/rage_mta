local savedPos = false
local lastBackup = getTickCount(  )

function backupVehicle()

	if ( getTickCount(  ) - lastBackup ) < 1000 then
		return
	end

	if not savedPos then return end
	if not isVip(localPlayer) then return end

	triggerServerEvent('backupVehiclePosition', resourceRoot, savedPos)
	lastBackup = getTickCount(  )

end

function isBetween(num, b1, b2)
	return num >= b1 and num <= b2
end


addEventHandler('onClientRender', root, function()
	if not isVip(localPlayer) then return end


	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then
		savedPos = false
		return
	end

	if isVehicleOnGround(vehicle) then
		for i = 0,3 do
			if not isVehicleWheelOnGround(vehicle, i) then
				return
			end
		end
		savedPos = {{getElementPosition(vehicle)}, {getElementRotation(vehicle)}}
	end

	if isElementInWater(vehicle) and getElementData(localPlayer, 'settings.water_safe') then
		backupVehicle()
	end
end)
