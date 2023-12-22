
local movingLights = {
}

function toggleLights()
	if not localPlayer.vehicle then return end

	if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

	local curState = localPlayer.vehicle:getData('vehicleLightsState') or 'off'
	local state

	if curState == 'off' then
		state = 'hwd'
	elseif curState == 'hwd' then
		state = 'head'
	elseif curState == 'head' then

		if (localPlayer.vehicle:getData('strobo') or 0) > 0 then
			state = 'strobo'
		else
			state = 'off'
		end

	elseif curState == 'strobo' then
		state = 'off'
	end

	updateState(state)
end
-- addCommandHandler('lights', toggleLights)
-- bindKey("l", "down", 'lights')


function updateState(state, now)
	local vehicle = localPlayer.vehicle
	-- if (movingLights[vehicle.model]) and exports.core:isResourceRunning("car_activeparts") then
	-- 	exports.car_activeparts:setVehicleHeadLights(vehicle, state)
	-- else
		if now then
			triggerServerEvent("setHeadlightsState", resourceRoot, vehicle, state)
		else
			antiDOSsend("lights", 250, "setHeadlightsState", resourceRoot, vehicle, state)
		end
	-- end
end




local sendData = {}
local sendTimers = {}

function antiDOSsend(actionGroup, pause, ...)
	if isTimer(sendTimers[actionGroup]) then
		sendData[actionGroup] = {...}
	else
		triggerServerEvent(...)
		sendData[actionGroup] = false
		sendTimers[actionGroup] = setTimer(slowSend, pause, 1, actionGroup)
	end
end

function slowSend(actionGroup)
	if (sendData[actionGroup]) then
		triggerServerEvent(unpack(sendData[actionGroup]))
		sendData[actionGroup] = nil
	end
end
