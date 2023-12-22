db = dbConnect('sqlite', ':databases/house.db')

houseMarkers = {}

addEventHandler('onResourceStart', resourceRoot, function()

	-- dbExec(db, 'DROP TABLE houses;')
	dbExec(db, string.format('CREATE TABLE IF NOT EXISTS houses(id INTEGER PRIMARY KEY, owner TEXT, cost INTEGER, donate INTEGER, pos TEXT, lots INTEGER, default_lots INTEGER, interior INTEGER, key TEXT);'))

	-- dbExec(db, ('UPDATE houses SET owner="", key="", lots=default_lots;'))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=730;'):format( toJSON({ x = -2070.48, y = -2495.24, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=731;'):format( toJSON({ x = -2058.4, y = -2503.18, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=732;'):format( toJSON({ x = -2074.83, y = -2526.96, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=733;'):format( toJSON({ x = -2101.65, y = -2531.87, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=734;'):format( toJSON({ x = -2045.1, y = -2523.39, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=735;'):format( toJSON({ x = -2068.82, y = -2537.84, z = 30.48, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=736;'):format( toJSON({ x = -2053.36, y = -2544.3, z = 30.92, }) ))
	-- dbExec(db, ('UPDATE houses SET pos=\'%s\' WHERE id=737;'):format( toJSON({ x = -2069.8, y = -2561.58, z = 30.92, }) ))


	local houses = dbPoll(dbQuery(db, string.format('SELECT * FROM houses;')), -1)
	iprint("houses", #houses)

	for _, house in pairs(houses) do
		createHouse(house)
	end

end)

function updateLots(player)
	exports['vehicles_main']:updatePlayerParkingLots(player)
end

function createHouse(data)

	data.pos = fromJSON(data.pos or '[[]]') or {}

	local intData = Config.interiors[data.interior]
	local x,y,z = unpack(intData.marker)
	local marker = createMarker(data.pos.x, data.pos.y, data.pos.z, 'corona', 1, 0, 0, 0, 0)

	if data.flat then
		marker.dimension = data.flat
	end

	marker:setData('house.marker', true)

	local x,y,z = unpack(intData.exit)
	local exitMarker = createMarker(x,y,z, 'corona', 1, 30, 255, 30, 50)
	if intData.crypt and type ( intData.crypt ) == 'table' then
		local cryptMarker = Marker ( intData.crypt[1], intData.crypt[2], intData.crypt[3], 'cylinder', 1.5, 200, 100, 200 )
		cryptMarker.interior = intData.interior
		cryptMarker.dimension = data.id

		addEventHandler ( 'onMarkerHit', cryptMarker, function ( player, mDim ) 
			if mDim and player.interior == source.interior then
				if data.owner ~= player.account.name then return end
				player:triggerEvent ( 'ShowCryptUI', player )
			end
		end)
	end

	exitMarker.dimension = data.id
	exitMarker.interior = intData.interior

	exitMarker:setData('house.exit', true)
	exitMarker:setData('house.parentMarker', marker)

	addEventHandler('onMarkerHit', exitMarker, function(player, mDim)

		if mDim and player.interior == source.interior then

			local parent = source:getData('house.parentMarker')

			if isElement(parent) then

				local data = parent:getData('house.data') or {}
				exitHouse(data.id, player)

			end

		end

	end)

	houseMarkers[data.id] = {
		data = data,
		marker = marker,
	}

	marker:setData('house.data', data)

end

function setHouseData(id, key, value)
	houseMarkers[id].data[key] = value
	houseMarkers[id].marker:setData('house.data', houseMarkers[id].data)

	dbExec(db, string.format('UPDATE houses SET %s=? WHERE id=%s;', key, id), (
		type(value) == 'table' and toJSON(value) or value
	))
end


addCommandHandler('sethousedata', function(player, _, id, name, value)
	if exports['acl']:isAdmin(player) then
		setHouseData( tonumber(id), name, tonumber(value) or value )
	end
end)

addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)
	if dn == 'house.data' then
		source:setData('house.3dtext', string.format([=[
[ID - %s]
[%s]
[Стоимость - %s %s]
[Парковки - %s %s]
		]=],
			new.id,
			new.owner == '' and 'Свободная недвижимость' or ('Дом '..new.owner),
			splitWithPoints(new.cost, '.'),
			(new.donate == 1) and 'R-Coin' or '$',
			new.lots, getWordCase(new.lots, 'парковка', 'парковки', 'парковок')
		))

	end
end)

function buyHouse(id, key)

	local data = houseMarkers[id].data
	if not data then return end

	if data.owner ~= '' then return end

	local cost = data.cost
	local money = data.donate == 1
		and exports['main_bank']:getPlayerDonate(client)
		or exports['money']:getPlayerMoney(client)

	if money < cost then
		return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно денег', 3000)
	end

	local houses = dbPoll(dbQuery(db, string.format('SELECT * FROM houses WHERE owner="%s"',
		client.account.name
	)), -1)

	if #(houses or {}) >= Config.maxHouses then
		return exports['hud_notify']:notify(client, 'Превышен лимит', 'Лимит покупки - ' .. Config.maxHouses, 3000)
	end

	if data.donate == 1 then
		exports['main_bank']:takePlayerDonate(client, cost)
	else
		exports['money']:takePlayerMoney(client, cost)
	end

	setHouseData(id, 'owner', client.account.name)
	setHouseData(id, 'key', key)

	increaseElementData(client, 'houses.bought', 1)

	updateLots(client)

	exports['hud_notify']:notify(client, 'Имущество', 'Вы купили '..( data.flat and 'квартиру' or 'дом' ), 3000)

	exports.logs:addLog(
		'[HOUSE][BUY]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
				valute = donate == 1 and 'donate' or 'rub',
			},	
		}
	)


end
addEvent('house.buy', true)
addEventHandler('house.buy', resourceRoot, buyHouse)

function sellHouse(id)

	local data = houseMarkers[id].data
	if not data then return end

	if data.owner ~= client.account.name then return end

	local cost = data.cost
	if data.donate == 1 then
		cost = cost * Config.donateConvertMul
	end
	cost = math.floor(cost * Config.sellMul)

	setHouseData(id, 'owner', '')
	setHouseData(id, 'key', '')
	setHouseData(id, 'lots', data.default_lots)

	exports['money']:givePlayerMoney(client, cost)

	updateLots(client)

	exports['hud_notify']:notify(client, 'Недвижимость', 'Вы продали '..( data.flat and 'квартиру' or 'дом' ), 3000)

	exports.logs:addLog(
		'[HOUSE][SELL]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
			},	
		}
	)

end
addEvent('house.sell', true)
addEventHandler('house.sell', resourceRoot, sellHouse)

function sellHousePlayer(id, player, cost)

	local data = houseMarkers[id].data
	if not data then return end

	if data.owner ~= client.account.name then return end

	if not player then return end
	if not player.account then return end

	triggerClientEvent(player, 'house.sellOffer', player, data, client, cost)

	exports.logs:addLog(
		'[HOUSE][TRANSFER][OFFER]',
		{
			data = {
				player = client.account.name,
				buyer = player.account.name,
				id = id,
				cost = cost,
				valute = donate == 1 and 'donate' or 'rub',
			},	
		}
	)

end
addEvent('house.sellPlayer', true)
addEventHandler('house.sellPlayer', resourceRoot, sellHousePlayer)

function sellHouseResponse(id, seller, cost, result)

	local data = houseMarkers[id].data
	if not data then return end

	if data.owner ~= seller.account.name then return end

	if not isElement(seller) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Продавец вышел с сервера')
	end

	if exports.money:getPlayerMoney(client) < cost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if result then

		local houses = dbPoll(dbQuery(db, string.format('SELECT * FROM houses WHERE owner="%s"',
			client.account.name
		)), -1)

		if #(houses or {}) >= Config.maxHouses then
			return exports['hud_notify']:notify(client, 'Превышен лимит', 'Лимит покупки - ' .. Config.maxHouses, 3000)
		end

		exports['money']:takePlayerMoney(client, cost, false)
		exports['money']:givePlayerMoney(seller, cost)

		setHouseData(id, 'owner', client.account.name)

		updateLots(client)
		updateLots(seller)

		exports['hud_notify']:notify(seller, 'Недвижимость', 'Игрок купил '..( data.flat and 'вашу квартиру' or 'ваш дом' ), 3000)
		exports['hud_notify']:notify(client, 'Недвижимость', 'Вы приобрели '..( data.flat and 'квартиру' or 'дом' ), 3000)

		increaseElementData(client, 'houses.bought', 1)

		exports.logs:addLog(
			'[HOUSE][TRANSFER][ACCEPT]',
			{
				data = {
					player = client.account.name,
					seller = seller.account.name,
					id = id,
					cost = cost,
				},	
			}
		)


	else
		exports['hud_notify']:notify(seller, 'Недвижимость', 'Игрок отказался от покупки', 3000)

		exports.logs:addLog(
			'[HOUSE][TRANSFER][DENY]',
			{
				data = {
					player = client.account.name,
					seller = seller.account.name,
					id = id,
					cost = cost,
				},	
			}
		)

	end

end
addEvent('house.sellResponse', true)
addEventHandler('house.sellResponse', resourceRoot, sellHouseResponse)

function enterHouse(id)

	local data = houseMarkers[id].data
	if not data then return end

	local intData = Config.interiors[ data.interior ]
	local x,y,z = unpack(intData.enter)

	client:setData('house.currentHouse', data)

	fadeCamera(client, false, 0.5)

	setTimer(function(player, pos, int, dim)

		if not isElement(player) then return end

		setElementPosition(player, unpack(pos))
		player.interior = int
		player.dimension = dim

		fadeCamera(player, true, 0.5)

	end, 1000, 1, client, {x,y,z}, intData.interior, data.id)

end
addEvent('house.enter', true)
addEventHandler('house.enter', resourceRoot, enterHouse)

function exitHouse(id, _player)

	local player = _player or client

	local data = houseMarkers[id].data
	if not data then return end	

	local pos = data.pos
	if data.flat then
		local x,y,z = getElementPosition( flatMarkers[data.flat].marker )
		pos.x = x
		pos.y = y
		pos.z = z
	end

	player:setData('house.currentHouse', false)

	fadeCamera(player, false, 0.5)

	setTimer(function(player, pos)

		if not isElement(player) then return end

		setElementPosition(player, unpack(pos))
		player.interior = 0
		player.dimension = 0

		fadeCamera(player, true, 0.5)

	end, 1000, 1, player, {pos.x,pos.y,pos.z + 0.5})

end
addEvent('house.exit', true)
addEventHandler('house.exit', resourceRoot, exitHouse)

function changeKey(id, key)


	local data = houseMarkers[id].data
	if not data then return end	

	if data.owner ~= client.account.name then
		return
	end

	setHouseData(id, 'key', key)

	exports['hud_notify']:notify(client, 'Ключ', 'Вы сменили ключ', 3000)

	exports.logs:addLog(
		'[HOUSE][KEY]',
		{
			data = {
				player = client.account.name,
				id = id,
				key = key,
			},	
		}
	)


end
addEvent('house.changeKey', true)
addEventHandler('house.changeKey', resourceRoot, changeKey)


function extendParks(id, payType)

	local data = houseMarkers[id].data
	if not data then return end	

	if data.flat then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недоступно в квартире')
	end

	if data.owner ~= client.account.name then
		return
	end

	local money = payType == 'donate' and
		exports.main_bank:getPlayerDonate(client)
		or exports['money']:getPlayerMoney(client)

	local cost = Config.lotsExtend[payType][( data.lots - data.default_lots )+1]
	if not cost then return end

	if money < cost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end
	
	if (data.lots - data.default_lots) >= Config.maxLotsExtend then
		return exports.hud_notify:notify(client, 'Ошибка', 'Превышен лимит расширения')
	end

	if payType == 'donate' then
		exports.main_bank:takePlayerDonate(client, cost)
	else
		exports['money']:takePlayerMoney(client, cost)
	end


	setHouseData(id, 'lots', data.lots + 1)
	updateLots(client)

	exports['hud_notify']:notify(client, data.flat and 'Дом' or 'Квартира', 'Вы расширили парковки', 3000)

	exports.logs:addLog(
		'[HOUSE][PARKS]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
				value = payType,
			},	
		}
	)

end
addEvent('house.extendParks', true)
addEventHandler('house.extendParks', resourceRoot, extendParks)

