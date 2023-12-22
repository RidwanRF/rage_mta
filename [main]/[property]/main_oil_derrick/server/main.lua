db = dbConnect('sqlite', ':databases/business.db')

businessMarkers = {}

addEventHandler('onResourceStart', resourceRoot, function()

	dbExec(db, string.format('CREATE TABLE IF NOT EXISTS derricks(id INTEGER PRIMARY KEY, owner TEXT, pos TEXT, balance INTEGER, upgrades_level INTEGER, health INTEGER, fix_amount INTEGER);'))
	
	 --dbExec(db, 'ALTER TABLE derricks ADD COLUMN cost INTEGER;')
	-- dbExec(db, 'UPDATE derricks SET cost=900000;')
	 --dbExec(db, 'ALTER TABLE derricks ADD COLUMN override_income INTEGER;')
	-- dbExec(db, ('UPDATE derricks SET pos=\'%s\' WHERE id=18;'):format( toJSON({ x=232.63, y=1271.33, z=16.46 }) ))

	local allBusiness = dbPoll(dbQuery(db, string.format('SELECT * FROM derricks;')), -1)

	for _, business in pairs(allBusiness) do
		createBusiness(business)
	end

end)

function createBusiness(data)

	data.pos = fromJSON(data.pos or '[[]]') or {}

	local marker = createMarker(
		data.pos.x,data.pos.y,data.pos.z,
		'corona', 2, 0, 0, 0, 0)

	marker:setData('derrick.data', data)
	marker:setData('derrick.marker', true)

	businessMarkers[data.id] = {
		data = data,
		marker = marker,
	}

end

function setBusinessData(id, key, value)
	businessMarkers[id].data[key] = value
	businessMarkers[id].marker:setData('derrick.data', businessMarkers[id].data)

	dbExec(db, string.format('UPDATE derricks SET %s=? WHERE id=%s;', key, id), (
		type(value) == 'table' and toJSON(value) or value
	))
end

addCommandHandler('setderrickdata', function(player, _, id, name, value)
	if exports['acl']:isAdmin(player) then
		setBusinessData( tonumber(id), name, tonumber(value) or value )
	end
end)

addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)
	if dn == 'derrick.data' then

		local payout = new.payment_sum

		source:setData('derrick.3dtext', string.format([=[
[Владелец - %s]
[ID - %s]
		]=],
			new.owner == '' and 'Отсутствует' or new.owner,
			new.id
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
	local money = exports.money:getPlayerMoney(client)

	if money < cost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	local businessCount = exports.main_business:getPlayerBusinessCount(client, 'derricks')
	local max = Config.maxOilDerricks

	if businessCount >= max then
		return exports.hud_notify:notify(client, 'Превышен лимит', 'Можно купить только ' .. max)
	end

	exports.money:takePlayerMoney(client, cost)

	setBusinessData(id, 'owner', client.account.name)
	setBusinessData(id, 'balance', 0)

	increaseElementData(client, 'derricks.bought', 1)

	exports.hud_notify:notify(client, 'Бизнес', 'Вы приобрели нефтевышку', 3000)

	exports.logs:addLog(
		'[DERRICK][BUY]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
			},	
		}
	)

end
addEvent('derrick.buy', true)
addEventHandler('derrick.buy', resourceRoot, buyBusiness)

function sellBusiness(id)

	local data = businessMarkers[id].data
	if not data then return end

	if data.owner ~= client.account.name then return end

	local cost = data.cost
	cost = math.floor(cost * Config.sellMul)

	setBusinessData(id, 'owner', '')
	setBusinessData(id, 'fix_amount', 0)
	setBusinessData(id, 'upgrades_level', 1)
	setBusinessData(id, 'health', Config.derrick.levels[1].health)

	exports.money:givePlayerMoney(client, cost)

	exports.hud_notify:notify(client, 'Бизнес', 'Вы продали бизнес', 3000)

	exports.logs:addLog(
		'[DERRICK][SELL]',
		{
			data = {
				player = client.account.name,
				id = id,
				cost = cost,
			},	
		}
	)

end
addEvent('derrick.sell', true)
addEventHandler('derrick.sell', resourceRoot, sellBusiness)

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

	triggerClientEvent(player, 'derrick.sellOffer', player, data, client, cost)

	exports.logs:addLog(
		'[DERRICK][TRANSFER][OFFER]',
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
addEvent('derrick.sellPlayer', true)
addEventHandler('derrick.sellPlayer', resourceRoot, sellBusinessPlayer)

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

	local businessCount = exports.main_business:getPlayerBusinessCount(client, 'derricks')
	local max = Config.maxOilDerricks

	if businessCount >= max and result then
		return exports.hud_notify:notify(client, 'Превышен лимит', 'Можно купить только ' .. max)
	end

	if result then

		exports.money:takePlayerMoney(client, cost)
		exports.money:givePlayerMoney(seller, cost)

		setBusinessData(id, 'owner', client.account.name)

		exports.hud_notify:notify(seller, 'Бизнес', 'Игрок купил ваш бизнес', 3000)
		exports.hud_notify:notify(client, 'Бизнес', 'Вы приобрели бизнес', 3000)

		increaseElementData(client, 'derricks.bought', 1)

		exports.logs:addLog(
			'[DERRICK][TRANSFER][ACCEPT]',
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
		exports.hud_notify:notify(seller, 'Недвижимость', 'Игрок отказался от покупки', 3000)

		exports.logs:addLog(
			'[DERRICK][TRANSFER][DENY]',
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
addEvent('derrick.sellResponse', true)
addEventHandler('derrick.sellResponse', resourceRoot, sellBusinessResponse)

function takeBusinessMoney(id, sum)

	if sum < 0 then return end

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
		'[DERRICK][TAKE]',
		{
			data = {
				player = client.account.name,
				id = id,
				sum = sum,
			},	
		}
	)

end
addEvent('derrick.takeMoney', true)
addEventHandler('derrick.takeMoney', resourceRoot, takeBusinessMoney)

function editBusiness(id, data)

	if not exports.acl:isAdmin(client) then return end

	for name, value in pairs(data) do
		setBusinessData(id, name, value)
	end

	exports.logs:addLog(
		'[DERRICK][EDIT]',
		{
			data = {
				player = client.account.name,
				id = id,
				data = data,
			},	
		}
	)

end
addEvent('derrick.edit', true)
addEventHandler('derrick.edit', resourceRoot, editBusiness)

-------------------------------------------------------

	function orderFix(id, amount)


		local data = businessMarkers[id].data
		if not data then return end

		local level = data.upgrades_level
		local level_data = Config.derrick.levels[level]

		amount = math.clamp( amount, 0, ( level_data.health - data.health ) )
		if amount <= 0 then return end

		if data.owner ~= client.account.name then return end

		local cost = amount*Config.derrick.fix_cost

		if cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег', 3000)
		end

		setBusinessData(id, 'fix_amount', amount)
		exports.money:takePlayerMoney(client, cost)

		exports.hud_notify:notify(client, 'Нефтевышка', 'Починка заказана', 3000)

		exports.logs:addLog(
			'[DERRICK][FIX][ORDER]',
			{
				data = {
					player = client.account.name,
					id = id,
					amount = amount,
					cost = cost,
				},	
			}
		)

	end
	addEvent('derrick.orderFix', true)
	addEventHandler('derrick.orderFix', resourceRoot, orderFix)


	setTimer(function()

		for id, derrick in pairs(businessMarkers) do

			if derrick.data and derrick.data.owner ~= '' and derrick.data.fix_amount > 0 then

				setBusinessData(id, 'health', derrick.data.health + 1)
				setBusinessData(id, 'fix_amount', derrick.data.fix_amount - 1)

			end

		end

	end, Config.fixTimeout, 0)

-------------------------------------------------------

	function buyUpgrade(id, level)

		local data = businessMarkers[id].data
		if not data then return end

		if data.owner ~= client.account.name then return end
		if level <= data.upgrades_level then return end

		local level_data = Config.derrick.levels[level]
		local cost = level_data.cost

		if cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег', 3000)
		end

		setBusinessData(id, 'upgrades_level', level)
		exports.money:takePlayerMoney(client, cost)

		exports.hud_notify:notify(client, 'Нефтевышка', 'Улучшение приобретено', 3000)

		exports.logs:addLog(
			'[DERRICK][UPGRADE]',
			{
				data = {
					player = client.account.name,
					id = id,
					level = level,
					cost = cost,
				},	
			}
		)

	end
	addEvent('derrick.buyUpgrade', true)
	addEventHandler('derrick.buyUpgrade', resourceRoot, buyUpgrade)

-------------------------------------------------------