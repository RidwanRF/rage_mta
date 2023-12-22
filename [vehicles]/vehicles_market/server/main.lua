
	local db = dbConnect('sqlite', ':databases/used.db')
	local vehicles_db = dbConnect('sqlite', ':databases/vehicles.db')

------------------------------------------------------------------------------------------------

	used_slots = {}

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(db, 'DROP TABLE used;')
		dbExec(db, 'CREATE TABLE IF NOT EXISTS used(id INTEGER PRIMARY KEY, vehicle_id INTEGER, slot INTEGER, owner TEXT, cost INTEGER, expiry_date INTEGER);')

		local data = dbPoll( dbQuery(db, string.format('SELECT * FROM used;')), -1 )

		for _, row in pairs( data ) do
			updateUsedSlot(row.slot)
		end

	end)

------------------------------------------------------------------------------------------------

	function getFreeUsedSlot()

		for index in pairs(Config.slots) do
			if not used_slots[index] then return index end
		end

		return false

	end

------------------------------------------------------------------------------------------------

	function updateUsedSlot( slot )

		local data = dbPoll( dbQuery(db, string.format('SELECT * FROM used WHERE slot=%s;', slot)), -1 )
		if not (data and data[1]) then

			clearTableElements(used_slots[slot] or {})
			used_slots[slot] = nil

			return

		end

		data = data[1]

		local vehicle = exports.vehicles_main:doRespawnVehicle(nil, data.vehicle_id)

		data.vehicle = vehicle

		local vehicle_data = dbPoll( dbQuery( vehicles_db, string.format('SELECT * FROM vehicles WHERE id=%s;', data.vehicle_id) ), -1 )
		if not (vehicle_data and vehicle_data[1]) then return end

		vehicle_data = vehicle_data[1]

		data.tuning = fromJSON( vehicle_data.appearance_upgrades or '[[]]' ) or {}

		local slot_config = Config.slots[data.slot]

		vehicle.dimension = slot_config.dimension or 0
		vehicle.interior = slot_config.interior or 0

		local x,y,z = unpack(slot_config.position)
		local rx,ry,rz = unpack(slot_config.rotation)

		setElementPosition(vehicle, x,y,z)
		setElementRotation(vehicle, rx,ry,rz)

		vehicle.frozen = true
		vehicle:setData('vehicle.handbrake', true)

		local marker = createMarker( x,y,z, 'corona', 3, 0, 0, 0, 0 )
		attachElements(marker, vehicle)

		marker.dimension = slot_config.dimension or 0
		marker.interior = slot_config.interior or 0

		local list = {
			string.format('[%s]', exports['vehicles_main']:getVehicleModName(vehicle.model)),
			string.format('Стоимость - %s $', splitWithPoints(data.cost, ' ')),
			string.format('Продавец - %s', data.owner),
		}
		marker:setData('3dtext', table.concat(list, '\n'))

		vehicle:setData('used.data', data)
		marker:setData('used.data', data)

		used_slots[data.slot] = {
			vehicle = vehicle,
			marker = marker,
			data = data,
		}

	end

------------------------------------------------------------------------------------------------

	function sellVehicleToUsed( vehicle_id, cost )


		local days = Config.rentDays

		if client:getData('exchange.player') then return end

		local slot = getFreeUsedSlot()

		if not slot then
			return exports.hud_notify:notify(client, 'Авторынок', 'Нет свободных мест')
		end

		if exports.acl:isPlayerInGroup(client, 'press') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
		end

		local vehicle_data = dbPoll( dbQuery( vehicles_db, string.format('SELECT * FROM vehicles WHERE id=%s;', vehicle_id) ), -1 )
		if not (vehicle_data and vehicle_data[1]) then return end

		vehicle_data = vehicle_data[1]

		if vehicle_data.expiry_date then
			return exports.hud_notify:notify(client, 'Авторынок', 'Недоступно для продажи')
		end

		local g_cost = exports.vehicles_main:getVehicleCost( vehicle_data.model )

		if cost > ( g_cost*3 ) then
			return exports.hud_notify:notify(client, 'Авторынок', 'Слишком высокая цена')
		end


		if vehicle_data.owner ~= client.account.name then
			return exports.hud_notify:notify(client, 'Авторынок', 'Вы не владелец')
		end

		local rent_cost = Config.rentCost

		if rent_cost > (exports.money:getPlayerMoney(client) or 0) then
			return exports.hud_notify:notify(client, 'Авторынок', 'Недостаточно денег')
		end

		exports.money:takePlayerMoney( client, rent_cost )
		
		exports.vehicles_main:clearVehicle( client, vehicle_id )


		exports.vehicles_main:setVehicleData( vehicle_id, 'owner', '--used--' )

		dbExec(db, string.format('INSERT INTO used(vehicle_id, slot, owner, cost, expiry_date) VALUES (%s, %s, "%s", %s, %s);',
			vehicle_id, slot, client.account.name, cost, getRealTime().timestamp + days*86400
		))

		updateUsedSlot(slot)
		
		exports.vehicles_main:returnPlayerVehicles( client )

		increaseElementData(client, 'vehicles_market.sold', 1, false)

		exports.hud_notify:notify(client, 'Авторынок', 'Вы выставили автомобиль')

		exports.logs:addLog(
			'[MARKET][SELL]',
			{
				data = {

					player = client.account.name,
					vehicle = vehicle_data.model,
					vehicle_id = vehicle_id,

					days = days,
					cost = cost,
					-- rent_cost = rent_cost,

				},	
			}
		)

	end
	addEvent('used.sellVehicle', true)
	addEventHandler('used.sellVehicle', resourceRoot, sellVehicleToUsed)

------------------------------------------------------------------------------------------------

	function orderVehicleBreak()

		if (not client.vehicle) then
			return exports.hud_notify:notify(client, 'Авторынок', 'Вы не в транспорте')
		end

		local vehicle_id = client.vehicle:getData('id')

		if (not vehicle_id) then
			return exports.hud_notify:notify(client, 'Авторынок', 'Вы не в транспорте')
		end

		if client:getData('exchange.player') then return end

		if exports.acl:isPlayerInGroup(client, 'press') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
		end

		local vehicle_data = dbPoll( dbQuery( vehicles_db, string.format('SELECT * FROM vehicles WHERE id=%s;', vehicle_id) ), -1 )
		if not (vehicle_data and vehicle_data[1]) then return end

		vehicle_data = vehicle_data[1]

		if vehicle_data.expiry_date then
			return exports.hud_notify:notify(client, 'Авторынок', 'Недоступно для продажи')
		end

		if vehicle_data.owner ~= client.account.name then
			return exports.hud_notify:notify(client, 'Авторынок', 'Вы не владелец')
		end

		local d_cost = exports.vehicles_main:getVehicleCost( client.vehicle )
		local t_cost = exports.vehicles_tuning:getTuningCost( client.vehicle.model, fromJSON( vehicle_data.appearance_upgrades or '[[]]' ) or {} )
		t_cost = math.floor( t_cost * Config.destroy_cost_percent/100 )
		local s_cost = math.floor( d_cost * Config.destroy_cost_percent/100 ) + t_cost

		exports.vehicles_main:clearVehicle( client, vehicle_id )
		exports.money:givePlayerMoney( client, s_cost )

		exports.vehicles_main:wipeVehicle( vehicle_id )

		exports.vehicles_main:returnPlayerVehicles( client )

		increaseElementData(client, 'vehicles_market.destroyed', 1, false)

		exports.hud_notify:notify(client, 'Разборка', 'Вы разобрали автомобиль')

		exports.logs:addLog(
			'[MARKET][DESTROY]',
			{
				data = {

					player = client.account.name,
					vehicle = vehicle_data.model,
					vehicle_id = vehicle_id,

					cost = d_cost,

				},	
			}
		)

	end
	addEvent('used.orderVehicleBreak', true)
	addEventHandler('used.orderVehicleBreak', resourceRoot, orderVehicleBreak)

------------------------------------------------------------------------------------------------

	function returnUsedVehicle( slot_id, alert )

		local data = dbPoll( dbQuery(db, string.format('SELECT * FROM used WHERE slot=%s;', slot_id)), -1 )
		if not (data and data[1]) then return end

		data = data[1]

		local used_data = used_slots[slot_id]
		if not used_data then return end

		local vehicle_data = dbPoll( dbQuery( vehicles_db, string.format('SELECT * FROM vehicles WHERE id=%s;', data.vehicle_id) ), -1 )
		if not (vehicle_data and vehicle_data[1]) then return end

		vehicle_data = vehicle_data[1]

		if vehicle_data.owner ~= '--used--' then
			return
		end

		dbExec( db, string.format('DELETE FROM used WHERE id=%s;', data.id) )
		exports.vehicles_main:setVehicleData( data.vehicle_id, 'owner', data.owner )

		if alert ~= false then
			exports.main_alerts:addAccountAlert( data.owner, 'info', 'Авторынок',
				string.format('Срок аренды завершен\nВам возвращен %s',
					exports.vehicles_main:getVehicleModName( vehicle_data.model )
				)
			)
		end

		local account = getAccount( data.owner )
		if account.player then
			exports.vehicles_main:returnPlayerVehicles( account.player )
		end

		exports.logs:addLog(
			'[MARKET][TAKE]',
			{
				data = {

					player = data.owner,
					slot_id = slot_id,
					used_data = used_data,
					vehicle = used_data.vehicle.model,

				},	
			}
		)

		updateUsedSlot( slot_id )

		return true

	end

	function takeVehicleFromUsed( slot_id )

		if client:getData('exchange.player') then return end

		if returnUsedVehicle( slot_id, false ) then
			exports.hud_notify:notify( client, 'Авторынок', 'Вы забрали автомобиль' )
		end

	end
	addEvent('used.takeVehicle', true)
	addEventHandler('used.takeVehicle', resourceRoot, takeVehicleFromUsed)

	setTimer(function()

		local expired = dbPoll( dbQuery( db, ('SELECT * FROM used WHERE expiry_date <= %s;'):format(
			getRealTime().timestamp
		) ), -1 )

		for _, slot in pairs( expired ) do
			returnUsedVehicle( slot.slot )
		end

	end, 15000, 0)

------------------------------------------------------------------------------------------------

	function buyVehicleFromUsed( slot_id )

		if client:getData('exchange.player') then return end

		local data = dbPoll( dbQuery(db, string.format('SELECT * FROM used WHERE slot=%s;', slot_id)), -1 )
		if not (data and data[1]) then return end

		data = data[1]

		local used_data = used_slots[slot_id]
		if not used_data then return end

		if used_data.data.cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		local current, all = client:getData('parks.loaded') or 0, client:getData('parks.all') or 0
		if (current + 1) > all then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно парковок')
		end

		local vehicle_data = dbPoll( dbQuery( vehicles_db, string.format('SELECT * FROM vehicles WHERE id=%s;', data.vehicle_id) ), -1 )
		if not (vehicle_data and vehicle_data[1]) then return end

		vehicle_data = vehicle_data[1]

		if vehicle_data.owner ~= '--used--' then
			return
		end

		exports.money:takePlayerMoney(client, used_data.data.cost)

		local owner_account = getAccount( data.owner )

		if owner_account.player then
			exports.hud_notify:notify(owner_account.player, 'Авторынок', 'Ваш автомобиль продан >> F5')
		end

		local comission = math.floor( used_data.data.cost * Config.sellComission / 100 )
		local n_cost = used_data.data.cost - comission

		increaseUserData( data.owner, 'money', n_cost )
		increaseUserData( data.owner, 'money', Config.rentCost )

		exports.main_alerts:addAccountAlert( data.owner, 'info', 'Авторынок',
			string.format('Вы получили $%s за продажу\n%s + возвращен залог $%s',
				splitWithPoints( n_cost, '.' ),
				exports.vehicles_main:getVehicleModName( vehicle_data.model ), splitWithPoints( Config.rentCost, '.' )
			)
		)

		dbExec( db, string.format('DELETE FROM used WHERE id=%s;', data.id) )
		exports.vehicles_main:setVehicleData( data.vehicle_id, 'owner', client.account.name )

		exports.vehicles_main:returnPlayerVehicles( client )

		exports.hud_notify:notify(client, 'Авторынок', 'Вы купили автомобиль')

		increaseElementData(client, 'vehicles_market.bought', 1, false)

		exports.logs:addLog(
			'[MARKET][BUY]',
			{
				data = {

					player = client.account.name,
					vehicle = used_data.vehicle.model,
					used_data = used_data,
					slot_id = slot_id,

					n_cost = n_cost,

				},	
			}
		)

		updateUsedSlot( slot_id )

	end
	addEvent('used.buyVehicle', true)
	addEventHandler('used.buyVehicle', resourceRoot, buyVehicleFromUsed)

------------------------------------------------------------------------------------------------

	function goToFloor(floor, _player, timer)

		local player = _player or client

		if not Config.floors[floor] then return end
		local position = Config.floors[floor].position

		if floor > 0 then
			player:setData('used.floor', floor)
		else
			player:setData('used.floor', false)
		end

		if floor ~= 0 then

			exports.engine:replaceModel( player, ':vehicles_market/assets/models/by_int', Config.byInteriorModel )

			
		else

			function handle_restore(player)

				if isElement(player) then
					exports.engine:restoreModel( player, Config.byInteriorModel )
				end

			end

			if timer ~= false then
				setTimer(handle_restore, 1000, 1, player)
			else
				handle_restore(player)
			end


		end

		function handle_teleport(player, position, floor)

			if not isElement(player) then return end

			fadeCamera(player, true, 0.5)

			local x,y,z = unpack(position.coords)
			setElementPosition(player, x,y,z + 1)

			player.interior = position.int or 0
			player.dimension = position.dim or 0


		end

		if timer ~= false then
			fadeCamera(player, false, 0.5)
			setTimer(handle_teleport, 600, 1, player, position, floor)
		else
			handle_teleport(player, position, floor)
		end


	end
	addEvent('used.goToFloor', true)
	addEventHandler('used.goToFloor', resourceRoot, goToFloor)

	addEventHandler('onResourceStop', resourceRoot, function()

		for _, player in pairs( getElementsByType('player') ) do

			if (player:getData('used.floor') or 0) ~= 0 then
				goToFloor(0, player, false)
			end

		end

	end)

	addEventHandler('onPlayerQuit', root, function()

		if (source:getData('used.floor') or 0) ~= 0 then
			goToFloor(0, source, false)
		end

	end, true, 'high+100')

------------------------------------------------------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()

		clearTableElements(used_slots)

	end)

------------------------------------------------------------------------------------------------

	addEventHandler('onVehicleDamage', root, function()

		if source:getData('used.data') then
			fixVehicle(source)
		end

	end)

------------------------------------------------------------------------------------------------

	addEventHandler('onVehicleStartEnter', root, function()

		if source:getData('used.data') then
			cancelEvent()
		end

	end)

------------------------------------------------------------------------------------------------