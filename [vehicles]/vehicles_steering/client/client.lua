
setAnimData(localPlayer.vehicle, 0.1)

function updateCarSteering()
	-- for k,v in pairs() do
		-- if isElementStreamedIn(v) then
	local animData = getAnimData(localPlayer.vehicle)
	
	if animData then
		setVehicleComponentRotation(localPlayer.vehicle, 'steeringwheel_ok', 0, animData, 0)
		setVehicleComponentRotation(localPlayer.vehicle, 'steeringwheel_ok1', 0, animData, 0)
		setVehicleComponentRotation(localPlayer.vehicle, 'rpb_sw', 0, animData, 0)
	else
		setAnimData(localPlayer.vehicle, 0.1)
	end
		-- end
	-- end
end

addEventHandler('onClientRender', root, function()

	if localPlayer.vehicleSeat ~= 0 then return end

	if not exitingFromVehicle then
		local steeringVehicleData = {80, -80}
		local newSteeringAngle = 0

		local state = false

		if getControlState(localPlayer, 'vehicle_right') then
			state = 'right'
			newSteeringAngle = steeringVehicleData[1]
		elseif getControlState(localPlayer, 'vehicle_left') then
			state = 'left'
			newSteeringAngle = steeringVehicleData[2]
		end

		-- localPlayer.vehicle:setData('steering.state', state)

		animate(localPlayer.vehicle, newSteeringAngle)
	end

	updateCarSteering()

end)

addEventHandler('onClientVehicleStartExit', root, function(player, seat)
	if player == localPlayer and seat == 0 then
		exitingFromVehicle = true
	end
end)

addEventHandler('onClientVehicleEnter', root, function(player, seat)
	if player == localPlayer and seat == 0 then
		exitingFromVehicle = false
	end
end)