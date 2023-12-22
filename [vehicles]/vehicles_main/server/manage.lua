

function doRespawnVehicle(player, id, cRot)

	if player and not player.account then return end

	if player and player.vehicle then
		return exports.hud_notify:notify(player, 'Ошибка', 'Покиньте текущий автомобиль')
	end

	if player and client == player then

		local count = 0

		for _, vehicle in pairs( getElementsByType('vehicle', resourceRoot) ) do
			if vehicle:getData('owner') == player.account.name then
				count = count + 1
			end
		end

		if count >= Config.maxSpawnedVehicles and not exports.acl:isAdmin(player) and not root:getData('isTest') then
			return exports.hud_notify:notify(player, 'Лимит автомобилей', string.format('Нельзя спавнить больше %s', Config.maxSpawnedVehicles))
		end

	end

	if getVehicleById(id) and player then
		return teleportVehicle(player, id, cRot)
	end

	local db_data = getVehicleDBData(id)
	if not db_data then return end
	local data = db_data

	if not data then return end

	if isElement(player) and data.owner ~= player.account.name then return end

	local pos = fromJSON(data.position or '') or {x = 0, y = 0, z = 0 , r = 0}
	local x,y,z, rz = pos.x, pos.y, pos.z, pos.r

	local vehicle = createVehicle(data.model, x,y,z, 0, 0, r)
	if not isElement(vehicle) then return end
	vehicle:setData('id', id)
	vehicle:setData('owner', data.owner)

	vehicle:setData('vehicleLightsState', 'off')

	local a1 = getTickCount(  )

	loadVehicleData(vehicle, data)
	vehicle:setData('engine.disabled', true)

	if player then
		teleportVehicle(player, id, cRot)
	end

	if debug then
		local a2 = getTickCount(  )
		print(getTickCount(  ), a2-a1)
	end

	return vehicle

end

function teleportVehicle(player, id, cRot)

	if player.vehicle then
		return exports.chat_main:displayError(player, 'Выйдите из автомобиля')
	end

	local vehicle = getVehicleById(id)
	if not isElement(vehicle) then return end

	if not isElement(vehicle) then
		return exports.chat_main:displayError(player, 'Автомобиль не заспавнен')
	end

    local x, y, z = getElementPosition(player)
    local prx, pry = getPointFromDistanceRotation(x, y, 3, cRot or 0)
    setElementPosition(vehicle, prx, pry, z+0.5)

	if not isElement(vehicle) then return end

    setElementRotation(vehicle, 0, 0, 0)

    vehicle:setData('doors.locked', false)
    vehicle:setData('vehicle.handbrake', false)

    return vehicle

end

function resetVehicleHandling(player, id, model)
	-- if not isElement( getVehicleById(id) ) then
	-- 	return exports.hud_notify:notify(player, 'Ошибка', 'Заспавните автомобиль')
	-- end

	setVehicleData(id, 'handling', getModelHandling(model))
	exports.hud_notify:notify(player, 'Успешно', 'Настройки сброшены')
	
end

function clearVehicle(player, id, _vehicle)

	local vehicle = _vehicle or getVehicleById(id)

	if isElement(vehicle) then

		if vehicle.parent.parent ~= resourceRoot then
			return destroyElement(vehicle)
		end

		saveVehicleData(vehicle)
		destroyVehicle(vehicle)

	end
end

function clearAllVehicles(player)

	local login = player.account.name

	for _, vehicle in pairs( getElementsByType('vehicle', resourceRoot) ) do
		local owner = vehicle:getData('temp_owner') or vehicle:getData('owner')
		if owner == login and not vehicle:getData('clan') then
			clearVehicle( player, _, vehicle )
		end
	end
end


local managerActions = {
	['respawn'] = doRespawnVehicle,
	['teleport'] = teleportVehicle,
	['clear'] = clearVehicle,
	['clearall'] = clearAllVehicles,
	['reset_handling'] = resetVehicleHandling,
}

function vehicleManagerAction(action, ...)
	local func = managerActions[action]

	func(client, ...)

end
addEvent('vehicles.manager.action', true)
addEventHandler('vehicles.manager.action', resourceRoot, vehicleManagerAction)
