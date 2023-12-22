
function enterTuning(marker)

	if bVehicleExiting then return end
	if localPlayer.vehicle and localPlayer.vehicle.frozen then return end

	local exit = marker:getData('tuning.exit') or {}
	local window = marker:getData('tuning.window') or 'main'

	local x,y,z = getElementPosition(localPlayer)
	local mx,my,mz = getElementPosition(marker)

	if localPlayer.vehicle:getData('flag') == 1 then
		return exports['hud_notify']:notify('Тюнинг', 'Тюнинг недоступен')
	end

	if localPlayer.vehicle:getData('tuning_block') then
		return exports['hud_notify']:notify('Тюнинг', 'Тюнинг недоступен')
	end

	if getDistanceBetweenPoints3D(x,y,z, mx,my,mz) > 5 then
		return
	end

	if not Config.validTypes[getVehicleType(localPlayer.vehicle)] then 
		return
	end

	fadeCamera(false, 0.5)

	enterTimer = setTimer(function(exit)

		local x,y,z, rx,ry,rz = unpack(exit)

		localPlayer:setData('tuning.prevPos', {
			pos = {x,y,z},
			rot = {rx,ry,rz},
		})

		local dimension, interior, x,y,z,r =
			localPlayer:getData('dynamic.id') or 1,
			Config.interior.interior,
			unpack(Config.interior.pos)

		localPlayer.vehicle.dimension = dimension
		localPlayer.vehicle.interior = interior
		localPlayer.dimension = dimension
		localPlayer.interior = interior

		localPlayer.vehicle:setPosition(x,y,z)
		localPlayer.vehicle:setRotation(0, 0, r)

		triggerServerEvent('tuning.enter', resourceRoot, exit)
		fadeCamera(true, 0.5)

		openWindow(window)
		initializeTuning(true)

	end, 1000, 1, exit)
end

function loadPreviousPosition()
	local prevPos = localPlayer:getData('tuning.prevPos')
	if prevPos then
		localPlayer.vehicle:setPosition(unpack( prevPos.pos ))
		localPlayer.vehicle:setRotation(unpack( prevPos.rot ))

		localPlayer.interior = 0
		localPlayer.vehicle.interior = 0

		localPlayer.dimension = 0
		localPlayer.vehicle.dimension = 0
		setCameraTarget(localPlayer, localPlayer)

		localPlayer:setData('tuning.prevPos', false)

		triggerServerEvent('tuning.exit', resourceRoot)
	end
end

function exitTuning(handleResourceStop)

	if handleResourceStop then
		loadPreviousPosition()

		fadeCamera(true, 0.5)
		stopCamera()
		-- closeWindow()
	else
		fadeCamera(false, 0.5)
		setTimer(function()

			loadPreviousPosition()

			fadeCamera(true, 0.5)
			-- closeWindow()

		end, 1000, 1)
	end

end

-- addEventHandler('onClientResourceStop', resourceRoot, function()
-- 	if windowOpened then
-- 		exitTuning(true)
-- 	end
-- end)

addEventHandler('onClientKey', root, function()
	if windowOpened or isTimer(enterTimer) then cancelEvent() end
end)


------------------------------------------------

	bVehicleExiting = false

	addEventHandler('onClientVehicleStartExit', root, function(player)

		if player == localPlayer then
			bVehicleExiting = true
		end

	end)

	addEventHandler('onClientVehicleExit', root, function(player)

		if player == localPlayer then
			bVehicleExiting = false
		end

	end)

------------------------------------------------