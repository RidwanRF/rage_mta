
db = dbConnect('sqlite', ':databases/numbers.db')
vehiclesDB = dbConnect('sqlite', ':databases/vehicles.db')

addEventHandler('onResourceStart', resourceRoot, function()
	dbExec(db, 'CREATE TABLE IF NOT EXISTS numbers(id INTEGER PRIMARY KEY, owner TEXT, number TEXT, expire INTEGER);')
end)

function givePlate(login, plate)
	local expire = getRealTime().timestamp + Config.expireTime
	dbExec(db, string.format('INSERT INTO numbers(owner, number, expire) VALUES ("%s", "%s", %s);',
		login, plate, expire
	))
end

function getFreeRepositorySlots(player)

	local slots = Config.defaultRepositorySize + (player:getData('numbers.repository_expand') or 0)
	local loaded = #(dbPoll( dbQuery(db, string.format('SELECT * FROM numbers WHERE owner="%s";',
		player.account.name
	)), -1 ) or {})

	return slots - loaded

end

function updatePlateOwner(id, owner)

	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers WHERE id=%s;', id)), -1)

	if data and data[1] then

		dbExec(db, string.format('UPDATE numbers SET owner="%s" WHERE id=%s;', owner, id))

		local oldOwnerAccount = getAccount(data[1].owner)
		if oldOwnerAccount.player then
			returnNumbersRepository(oldOwnerAccount.player)
		end

		local newOwnerAccount = getAccount(data[1].owner)
		if newOwnerAccount.player then
			returnNumbersRepository(newOwnerAccount.player)
		end

	end

end

function setPlateData(id, key, value)

	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers WHERE id=%s;', id)), -1)

	if data and data[1] then

		dbExec(db, string.format('UPDATE numbers SET ?=? WHERE id=%s;', id), key, value)

		local owner = getAccount(data[1].owner)
		if owner and owner.player then
			returnNumbersRepository(owner.player)
		end

		if key == 'owner' then
			
			local oldOwnerAccount = getAccount(value)
			if oldOwnerAccount.player then
				returnNumbersRepository(oldOwnerAccount.player)
			end
			
		end

	end

end


addCommandHandler('giveplate', function(player, _, login, plate)
	if exports.acl:isAdmin(player) then
		givePlate(login, plate)

		local account = getAccount(login)
		if account and account.player then
			returnNumbersRepository(account.player)
		end
	end
end)
addCommandHandler('clearrepository', function(player, _, login)
	if exports.acl:isAdmin(player) then
		dbExec(db, string.format('DELETE FROM numbers WHERE owner="%s";', login))

		local account = getAccount(login)
		if account.player then
			returnNumbersRepository(account.player)
		end
	end
end)

function expandRepository()

	local cost = Config.expandCost

	if cost > exports.main_bank:getPlayerDonate(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if (client:getData('numbers.expandRepository') or 0) >= (Config.maxRepositorySize - Config.defaultRepositorySize) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Превышен лимит расширения')
	end

	exports.main_bank:takePlayerDonate(client, cost)
	increaseElementData(client, 'numbers.repository_expand', 1)

	returnNumbersRepository(client)

	exports.hud_notify:notify(client, 'Хранилище', 'Добавлен 1 слот', 3000)

	exports.logs:addLog(
		'[NUMBERS][EXPAND]',
		{
			data = {
				player = client.account.name,
				cost = cost,
			},	
		}
	)

end
addEvent('numbers.expandRepository', true)
addEventHandler('numbers.expandRepository', resourceRoot, expandRepository)

function returnNumbersRepository(_player)
	local player = _player or client

	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers WHERE owner="%s";',
		player.account.name)), -1)

	triggerClientEvent(player, 'numbers.returnRepository', player, data)
end

addEvent('vehicles.sendPlayerNumbers', true)
addEventHandler('vehicles.sendPlayerNumbers', root, returnNumbersRepository)

function checkNumberExists(plate, flag_handled)

	local pType = string.sub(plate, 1, 1)
	if (pType == 'k' or pType == 'a') and not flag_handled then

		local plate_1 = 'a'..plate:sub(2)
		local plate_2 = 'k'..plate:sub(2)

		return checkNumberExists(plate_1, true) or checkNumberExists(plate_2, true)
	end


	local vData = dbPoll(dbQuery(vehiclesDB, string.format('SELECT * FROM vehicles WHERE plate="%s";',
		plate
	)), -1)

	local sData = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers WHERE number="%s";',
		plate
	)), -1)

	return (sData and sData[1]) or (vData and vData[1])
end

function returnCheckResult(plate)
	local result = checkNumberExists(plate)

	if result then
		return exports.hud_notify:notify(client, 'Проверка', 'Номер занят')
	else
		return exports.hud_notify:notify(client, 'Проверка', 'Номер свободен')
	end

end
addEvent('numbers.check', true)
addEventHandler('numbers.check', resourceRoot, returnCheckResult)

function buyNumber(plate)

	if plate == '' then return end
	if not isPlateCorrect(plate) then return end

	local donate, dollar, free, plateType = getPlateCost(plate, client)
	local cost = dollar or donate
	local money = dollar and exports.money:getPlayerMoney(client) or exports.main_bank:getPlayerDonate(client)

	if not client.vehicle then return end
	if not client.vehicle:getData('id') then return end

	local cur_plate = client.vehicle:getData('plate')

	if exports.acl:isPlayerInGroup(client, 'press') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
	end

	if cost > money then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if cur_plate and getFreeRepositorySlots(client) <= 0 then
		return exports.hud_notify:notify(client, 'Ошибка', 'Нет места в хранилище')
	end

	if checkNumberExists(plate) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Номер занят')
	end

	if dollar then
		exports.money:takePlayerMoney(client, cost)
	else
		exports.main_bank:takePlayerDonate(client, cost)
	end

	if free then 
		addFreeNumber(client.account.name, plateType, -1)
	end

	if cur_plate then

		givePlate(client.account.name, cur_plate)

		returnNumbersRepository(client)

		exports.hud_notify:notify(client, 'Успешно', 'Старый номер в хранилище')

	else

		exports.hud_notify:notify(client, 'Успешно', 'Номер установлен')

	end

	client.vehicle:setData('plate', plate)
	exports.vehicles_main:saveVehicleData(client.vehicle)

	exports.vehicles_main:returnPlayerVehicles(client)

	exports.logs:addLog(
		'[NUMBERS][BUY]',
		{
			data = {
				player = client.account.name,
				cost = cost,
				valute = dollar and 'dollars' or 'donate',
				free = free,
				plate = plate,

			},	
		}
	)

end
addEvent('numbers.buy', true)
addEventHandler('numbers.buy', resourceRoot, buyNumber)

function resetNumbers(id_from, id_to)

	if id_to == id_from then
		return exports.hud_notify:notify(client, 'Ошибка', 'Это один и тот же автомобиль')
	end

	local cost = Config.resetCost

	local data = dbPoll(dbQuery(vehiclesDB, string.format('SELECT * FROM vehicles WHERE id IN (%s, %s)',
		id_from, id_to
	)), -1)

	local data_from, data_to

	for _, row in pairs(data) do
		if id_from == row.id then
			data_from = row
		elseif id_to == row.id then
			data_to = row
		end
	end

	local cost_from, cost_to
	cost_from = exports.vehicles_main:getVehicleCost(data_from.model)
	cost_to = exports.vehicles_main:getVehicleCost(data_to.model)

	local minCost = math.min(cost_to, cost_from)
	
	if minCost <= Config.minResetCost then
		cost = Config.resetCost2
	end

	if cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if not data_from.plate or not data_to.plate then
		return exports.hud_notify:notify(client, 'Ошибка', 'На автомобиле нет номера')
	end

	-- dbExec(vehiclesDB, string.format('UPDATE vehicles SET plate=? WHERE id=%s;', id_to), data_from.plate)
	-- dbExec(vehiclesDB, string.format('UPDATE vehicles SET plate=? WHERE id=%s;', id_from), data_to.plate)
	exports.vehicles_main:setVehicleData( id_to, 'plate', data_from.plate )
	exports.vehicles_main:setVehicleData( id_from, 'plate', data_to.plate )


	local vehicle = findElementByData('vehicle', 'id', data_from.id)
	if isElement(vehicle) then vehicle:setData('plate', data_to.plate) end

	local vehicle = findElementByData('vehicle', 'id', data_to.id)
	if isElement(vehicle) then vehicle:setData('plate', data_from.plate) end


	returnNumbersRepository(client)
	exports.vehicles_main:returnPlayerVehicles(client)

	exports.money:takePlayerMoney(client, cost)

	exports.hud_notify:notify(client, 'Номера', 'Номера переустановлены', 3000)

	exports.logs:addLog(
		'[NUMBERS][RESET]',
		{
			data = {
				player = client.account.name,
				cost = cost,

				id_from = id_from,
				id_to = id_to,

				plate_from = data_from.plate,
				plate_to = data_to.plate,

			},	
		}
	)


end
addEvent('numbers.reset', true)
addEventHandler('numbers.reset', resourceRoot, resetNumbers)

function setNumber(plate, vehicleId)

	local vehicleData = dbPoll(dbQuery(vehiclesDB, string.format('SELECT * FROM vehicles WHERE id=%s;',
		vehicleId)), -1)

	if not (vehicleData and vehicleData[1]) then return end
	if not plate then return end

	-- if (exports.vehicles_main:getVehicleCost(vehicleData[1].model) or 0) <= Config.minResetCost then
	-- 	return exports.hud_notify:notify(client, string.format(
	-- 		'Автомобиль должен стоить больше %s $лей',
	-- 		splitWithPoints(Config.minResetCost, '.')
	-- 	), {255,20,20})
	-- end

	if vehicleData[1].plate then
		dbExec(db, string.format('UPDATE numbers SET number="%s", expire=%s WHERE number="%s";',
			vehicleData[1].plate, getRealTime().timestamp + Config.expireTime, plate))
	else
		dbExec(db, string.format('DELETE FROM numbers WHERE number="%s";', plate))
	end

	local vehicle = findElementByData('vehicle', 'id', vehicleId)
	if isElement(vehicle) then
		vehicle:setData('plate', plate)
	end

	-- dbExec(vehiclesDB, string.format('UPDATE vehicles SET plate="%s" WHERE id=%s;', plate, vehicleId))
	exports.vehicles_main:setVehicleData( vehicleId, 'plate', plate )

	returnNumbersRepository(client)
	exports.vehicles_main:returnPlayerVehicles(client)

	exports.hud_notify:notify(client, 'Хранилище', 'Вы установили номер', 3000)

	exports.logs:addLog(
		'[NUMBERS][SET]',
		{
			data = {

				player = client.account.name,
				plate = plate,

				id = vehicleId,

			},	
		}
	)

end
addEvent('numbers.set', true)
addEventHandler('numbers.set', resourceRoot, setNumber)

function clearNumber(vehicleId)

	local cost = Config.clearCost


	if getFreeRepositorySlots(client) <= 0 then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно места в хранилище', {255,20,20})
	end

	local vehicleData = dbPoll(dbQuery(vehiclesDB, string.format('SELECT * FROM vehicles WHERE id=%s;',
		vehicleId)), -1)

	if not (vehicleData and vehicleData[1]) then return end
	if not vehicleData[1].plate then return end

	if (exports.vehicles_main:getVehicleCost(vehicleData[1].model) or 0) <= Config.minResetCost then
		cost = Config.clearCost2
	end
	
	if cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег', {255,20,20})
	end

	exports.money:takePlayerMoney(client, cost)

	local vehicle = findElementByData('vehicle', 'id', vehicleId)
	if isElement(vehicle) then
		vehicle:setData('plate', nil)
	end

	-- dbExec(vehiclesDB, string.format('UPDATE vehicles SET plate=NULL WHERE id=%s;', vehicleId))
	exports.vehicles_main:setVehicleData( vehicleId, 'plate', nil )

	givePlate(client.account.name, vehicleData[1].plate)

	returnNumbersRepository(client)
	exports.vehicles_main:returnPlayerVehicles(client)

	exports.hud_notify:notify(client, 'Хранилище', 'Номер помещен в хранилище', 3000)

	exports.logs:addLog(
		'[NUMBERS][CLEAR]',
		{
			data = {

				player = client.account.name,
				plate = vehicleData[1].plate,

				id = vehicleId,

			},	
		}
	)

end
addEvent('numbers.clear', true)
addEventHandler('numbers.clear', resourceRoot, clearNumber)

function deleteNumber(plate)

	if not plate then return end

	dbExec(db, string.format('DELETE FROM numbers WHERE number="%s" AND owner="%s";',
		plate, client.account.name))

	returnNumbersRepository(client)

	exports.hud_notify:notify(client, 'Хранилище', 'Номер удален из хранилища', 3000)

	exports.logs:addLog(
		'[NUMBERS][DELETE]',
		{
			data = {

				player = client.account.name,
				plate = plate,

			},	
		}
	)

end
addEvent('numbers.delete', true)
addEventHandler('numbers.delete', resourceRoot, deleteNumber)

function updateNumbersExpire()
	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers;')), -1)
	local realTime = getRealTime().timestamp

	local loginsUpdate = {}

	for _, row in pairs(data) do
		if row.expire <= realTime then

			dbExec(db, string.format('DELETE FROM numbers WHERE id=%s;',
				row.id
			))

			loginsUpdate[row.owner] = true

		end
	end

	for login in pairs(loginsUpdate) do
		local account = getAccount(login)
		if account and account.player then
			returnNumbersRepository(account.player)
		end
	end

end
setTimer(updateNumbersExpire, 15000, 0)

-----------------------------------------------------------------

	-- фича для рос номеров, что можно убрать флаг
	function clearPlateFlag(plate, plate_id)

		if Config.clearFlagCost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		exports.money:takePlayerMoney(client, Config.clearFlagCost)

		local new_plate = 'k'..plate:sub(2)

		dbExec(db, string.format('UPDATE numbers SET number="%s" WHERE id=%s;',
			new_plate, plate_id
		))

		returnNumbersRepository(client)

		exports.hud_notify:notify(client, 'Успешно', 'Вы убрали флаг')

		exports.logs:addLog(
			'[NUMBERS][CLEAR_FLAG]',
			{
				data = {
					player = client.account.name,
					plate = plate,
					id = plate_id,
					cost = Config.clearFlagCost,
				},	
			}
		)

	end
	addEvent('numbers.clearPlateFlag', true)
	addEventHandler('numbers.clearPlateFlag', resourceRoot, clearPlateFlag)

-----------------------------------------------------------------