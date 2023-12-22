db = dbConnect('sqlite', ':databases/business.db')

businessMarkers = {}

addEventHandler('onResourceStart', resourceRoot, function()

	-- dbExec(db, 'DROP TABLE business;')
	dbExec(db, string.format('CREATE TABLE IF NOT EXISTS business(id INTEGER PRIMARY KEY, owner TEXT, name TEXT, pos TEXT, cost INTEGER, donate INTEGER, balance INTEGER, payment_sum INTEGER, clan INTEGER, clan_bank INTEGER, clan_war TEXT, clan_area_type INTEGER);'))

	-- dbExec(db, ('ALTER TABLE business ADD COLUMN clan_war TEXT;'))
	-- dbExec(db, ('ALTER TABLE business ADD COLUMN clan INTEGER;'))
	-- dbExec(db, ('ALTER TABLE business ADD COLUMN clan_bank INTEGER;'))
	-- dbExec(db, ('ALTER TABLE business ADD COLUMN clan_area_type INTEGER;'))
	-- dbExec(db, ('UPDATE business SET clan_bank=0;'))
	
	-- dbExec(db, ('UPDATE derricks SET owner="", upgrades_level=1, health=8, fix_amount=0, balance=0;'))
	-- dbExec(db, ('UPDATE business SET owner="", balance=0, clan=NULL, clan_bank=0;'))

	local allBusiness = dbPoll(dbQuery(db, string.format('SELECT * FROM business;')), -1)
	iprint("allBusiness", #allBusiness)
	for _, business in pairs(allBusiness) do
		createBusiness(business)
	end

end)

function getBusinessFromId(id)
	return businessMarkers[id]
end

function getPlayerBusiness(player)

	if not player.account then return {} end

	local business = {}

	local default = dbPoll(dbQuery(db, string.format('SELECT * FROM business WHERE owner="%s"',
		player.account.name
	)), -1)

	local derricks = dbPoll(dbQuery(db, string.format('SELECT * FROM derricks WHERE owner="%s"',
		player.account.name
	)), -1)

	for _type, _business in pairs( { default=default, derricks=derricks } ) do

		for _, _data in pairs(_business) do
			_data.b_type = _type
			table.insert(business, _data)
		end

	end

	return business

end

function getPlayerBusinessCount(player, type)

	local business = getPlayerBusiness(player)
	local count = 0

	for _, _business in pairs( business ) do
		if _business.b_type == type then
			count = count + 1
		end
	end

	return count

end

function createBusiness(data)

	data.pos = fromJSON(data.pos or '[[]]') or {}
	data.clan_war = data.clan_war and (fromJSON(data.clan_war or '[[]]') or {}) or nil

	local marker = createMarker(
		data.pos.x,data.pos.y,data.pos.z+0.1,
		'corona', 1, 0, 0, 0, 0)

	marker:setData('business.data', data)
	marker:setData('business.marker', true)

	businessMarkers[data.id] = {
		data = data,
		marker = marker,
	}

end

function setBusinessData(id, key, value)

	if value == 'false' then value = nil end
	if value == 'nil' then value = nil end

	businessMarkers[id].data[key] = value
	businessMarkers[id].marker:setData('business.data', businessMarkers[id].data)

	dbExec(db, string.format('UPDATE business SET %s=? WHERE id=%s;', key, id), (
		type(value) == 'table' and toJSON(value) or value
	))
end

addCommandHandler('setbusinessdata', function(player, _, id, name, value)
	if exports['acl']:isAdmin(player) then
		setBusinessData( tonumber(id), name, tonumber(value) or value )
	end
end)

addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)
	if dn == 'business.data' then

		local payout = new.payment_sum

		source:setData('business.3dtext', string.format([=[
[ID - %s]
[%s]
[Стоимость - %s %s]
[Прибыль - %s $]
		]=],
			new.id,
			new.owner == '' and 'Свободный бизнес' or ('Бизнес '..new.owner),
			splitWithPoints(new.cost, '.'),
			(new.donate == 1) and 'R-Coin' or '$',
			splitWithPoints(payout, '.')
		))

	end
end)

function buyBusiness(id)

	local data = businessMarkers[id].data
	if not data then return end

	if data.owner ~= '' then return end

	if exports.acl:isPlayerInGroup(client, 'press') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
	end

	local cost = data.cost
	local money = data.donate == 1
		and exports.main_bank:getPlayerDonate(client)
		or exports.money:getPlayerMoney(client)

	if money < cost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	local businessCount = getPlayerBusinessCount(client, 'default')

	if businessCount >= Config.maxBusiness then
		return exports.hud_notify:notify(client, 'Превышен лимит', 'Можно купить только ' ..Config.maxBusiness)
	end

	if data.donate == 1 then
		exports.main_bank:takePlayerDonate(client, cost)
	else
		exports.money:takePlayerMoney(client, cost)
	end

	setBusinessData(id, 'owner', client.account.name)
	setBusinessData(id, 'balance', 0)

	exports.hud_notify:notify(client, 'Бизнес', 'Вы приобрели бизнес', 3000)
	increaseElementData(client, 'business.bought', 1)

	exports.logs:addLog(
		'[BUSINESS][BUY]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
				valute = donate == 1 and 'donate' or 'dollar',
			},	
		}
	)

end
addEvent('business.buy', true)
addEventHandler('business.buy', resourceRoot, buyBusiness)

function sellBusiness(id)

	local data = businessMarkers[id].data
	if not data then return end

	if data.owner ~= client.account.name then return end

	local cost = data.cost
	if data.donate == 1 then
		cost = cost * Config.donateConvertMul
	end
	cost = math.floor(cost * Config.sellMul)

	setBusinessData(id, 'owner', '')

	exports.money:givePlayerMoney(client, cost)

	exports.hud_notify:notify(client, 'Бизнес', 'Вы продали бизнес', 3000)

	exports.logs:addLog(
		'[BUSINESS][SELL]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
			},	
		}
	)

end
addEvent('business.sell', true)
addEventHandler('business.sell', resourceRoot, sellBusiness)

function sellBusinessPlayer(id, player, cost)

	local data = businessMarkers[id].data
	if not data then return end

	if exports.acl:isPlayerInGroup(client, 'press') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
	end
	
	if exports.acl:isPlayerInGroup(player, 'press') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Пресс-аккаунт')
	end

	if data.owner ~= client.account.name then return end

	if not player then return end
	if not player.account then return end

	triggerClientEvent(player, 'business.sellOffer', player, data, client, cost)

	exports.logs:addLog(
		'[BUSINESS][TRANSFER][OFFER]',
		{
			data = {
				player = client.account.name,
				buyer = player.account.name,
				id = id,
				cost = cost,
			},	
		}
	)

end
addEvent('business.sellPlayer', true)
addEventHandler('business.sellPlayer', resourceRoot, sellBusinessPlayer)

function sellBusinessResponse(id, seller, cost, result)

	local data = businessMarkers[id].data
	if not data then return end

	if not isElement(seller) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Продавец вышел с сервера')
	end
	
	if data.owner ~= seller.account.name then return end

	if exports.money:getPlayerMoney(client) < cost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	local businessCount = getPlayerBusinessCount(client, 'default')

	if businessCount >= Config.maxBusiness and result then
		return exports.hud_notify:notify(client, 'Превышен лимит', 'Можно купить только ' ..Config.maxBusiness)
	end

	if result then

		exports.money:takePlayerMoney(client, cost, false)
		exports.money:givePlayerMoney(seller, cost)

		setBusinessData(id, 'owner', client.account.name)

		exports.hud_notify:notify(seller, 'Бизнес', 'Игрок купил ваш бизнес', 3000)
		exports.hud_notify:notify(client, 'Бизнес', 'Вы приобрели бизнес', 3000)

		increaseElementData(client, 'business.bought', 1)

		exports.logs:addLog(
			'[BUSINESS][TRANSFER][ACCEPT]',
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
		exports.hud_notify:notify(seller, 'Недвижимость', 'Игрок отказался от покупки дома', 3000)

		exports.logs:addLog(
			'[BUSINESS][TRANSFER][DENY]',
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
addEvent('business.sellResponse', true)
addEventHandler('business.sellResponse', resourceRoot, sellBusinessResponse)

function takeBusinessMoney(id, sum)

	if not sum or sum < 0 then return end

	local data = businessMarkers[id].data
	if not data then return end

	if data.owner ~= client.account.name then return end

	if sum > data.balance then
		return exports.hud_notify:notify(client, 'Ошибка', 'Нет денег на балансе', 3000)
	end

	setBusinessData(id, 'balance', data.balance - sum)
	exports.money:givePlayerMoney(client, sum)

	exports.hud_notify:notify(client, 'Бизнес', 'Деньги успешно выведены', 3000)

	exports.logs:addLog(
		'[BUSINESS][TAKE]',
		{
			data = {
				player = client.account.name,
				id = id,
				sum = sum,
			},	
		}
	)

end
addEvent('business.takeMoney', true)
addEventHandler('business.takeMoney', resourceRoot, takeBusinessMoney)

function editBusiness(id, data)

	if not exports.acl:isAdmin(client) then return end

	for name, value in pairs(data) do
		setBusinessData(id, name, value)
	end

	exports.logs:addLog(
		'[BUSINESS][EDIT]',
		{
			data = {
				player = client.account.name,
				id = id,
				data = data,
			},	
		}
	)

end
addEvent('business.edit', true)
addEventHandler('business.edit', resourceRoot, editBusiness)

addEvent('business.sendPlayerBusiness', true)
addEventHandler('business.sendPlayerBusiness', root, function()

	triggerClientEvent(client, 'business.receivePlayerBusiness', root, getPlayerBusiness(client))

end)

addCommandHandler( "deletebusiness", function( self, cmd, id ) 
	if exports.acl:isAdmin( self ) then
		db:exec( "DELETE FROM business WHERE id=?", tonumber( id ) )

		local conf = businessMarkers[ tonumber( id ) ]
		if conf then
			if conf.marker then
				conf.marker:destroy( )
			end
		end
		businessMarkers[ tonumber( id ) ] = nil
	end
end)