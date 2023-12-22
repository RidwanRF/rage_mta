
function finishTestDrive(_player, quit)
	local player = _player or client

	local vehicle = player:getData('testdrive.vehicle')
	local shopId = player:getData('testdrive.shop')
	local model = vehicle.model

	setTimer(function(vehicle)
		if isElement(vehicle) then
			destroyElement(vehicle)
		end
	end, 500, 1, vehicle)

	player:setData('testdrive.vehicle', false)
	player:setData('testdrive', false)

	if quit then
		local exit = Config.shops[shopId].exitPosition
		setElementPosition(player, unpack(exit))
		player.dimension = 0
		player.interior = 0
	else
		triggerClientEvent(player, 'vehicles.shop.open', player, shopId, model)
	end


end
addEvent('vehicles.shop.finishTestDrive', true)
addEventHandler('vehicles.shop.finishTestDrive', resourceRoot, finishTestDrive)

function testDrive(player, model, shopId)

	local vehicleCost = exports['vehicles_main']:getVehicleCost(model)
	local cost = Config.calcTestDriveCost(vehicleCost)

	if cost > exports['money']:getPlayerMoney(player) then
		player:setData('testdrive', false)
		return exports['chat_main']:displayInfo(player, '[ТЕСТ-ДРАЙВ] Недостаточно денег', {255, 20, 20})
	end

	exports['money']:takePlayerMoney(player, cost)

	local x,y,z,r = unpack(Config.shops[shopId].testdrive)

	local vehicle = createVehicle(model, x,y,z, 0, 0, r)
	vehicle.dimension = 20000 + (player:getData('dynamic.id') or 0)
	player.dimension = 20000 + (player:getData('dynamic.id') or 0)

	player:setData('testdrive.vehicle', vehicle)
	player:setData('testdrive.shop', shopId)

	vehicle:setData('testdrive', true)
	vehicle:setData('testdrive.player', player)
	vehicle:setData('fuel', 10000)

	warpPedIntoVehicle(player, vehicle)

	triggerClientEvent(player, 'vehicles.testdrive.start', player)

	exports.logs:addLog(
		'[VEHICLES][TESTDRIVE]',
		{
			data = {
				player = player.account.name,
				cost = cost,
				model = model,
			},
		}
	)


end

function startTestDrive(model, shop)

	if client:getData('testdrive') then return end

	client:setData('testdrive', true)

	triggerClientEvent(client, 'vehicles.shop.close', client)
	setTimer(testDrive, 1100, 1, client, model, shop)

end

addEvent('vehicles.shop.testDrive', true)
addEventHandler('vehicles.shop.testDrive', resourceRoot, startTestDrive)

addEventHandler('onVehicleDamage', root, function()
	if source and source:getData('testdrive') then
		fixVehicle(source)
	end
end)
addEventHandler('onVehicleStartExit', root, function()
	if source and source:getData('testdrive') then
		cancelEvent()
	end
end)

addEventHandler('onPlayerQuit', root, function()
	if source:getData('testdrive') then
		finishTestDrive(source, true)
	end
end, true, 'high+4')

addEventHandler('onPlayerWasted', root, function()
	if source:getData('testdrive') then
		triggerClientEvent(source, 'testdrive.finish', resourceRoot)
		setTimer(function(player)

			if isElement(player) then
				triggerClientEvent(player, 'vehicles.shop.close', resourceRoot)
			end

		end, 1000, 1, player)
	end
end, true, 'high+4')

