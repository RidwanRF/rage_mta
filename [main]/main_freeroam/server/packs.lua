
------------------------------------------------------------------------------------------------------------

	exports.save:addParameter('packs', true, true)

------------------------------------------------------------------------------------------------------------

	db = dbConnect('sqlite', ':databases/packs.db')

	addEventHandler('onResourceStart', resourceRoot, function()

		dbExec(db, string.format('CREATE TABLE IF NOT EXISTS packs_balance(id INTEGER PRIMARY KEY, pack INTEGER, count INTEGER, maxCount INTEGER);'))

		resourceRoot:setData('packs.balance', getPacksBalance())

	end)

	function getPacksBalance()
		local data = dbPoll(dbQuery(db, 'SELECT * FROM packs_balance;'), -1)

		local packsBalance = {}

		for _, row in pairs(data) do
			packsBalance[row.pack] = {count = row.count, max = row.maxCount }
		end

		return packsBalance
	end

	function addPackBalance(pack, count, maxCount)

		local pCount = getPacksCount(pack)

		if pCount ~= -1 then
			dbExec(db, string.format('UPDATE packs_balance SET count=count+%s WHERE pack=%s;',
				count, pack
			))
			if maxCount then
				dbExec(db, string.format('UPDATE packs_balance SET maxCount=%s WHERE pack=%s;',
					maxCount, pack
				))
			end
		else
			dbExec(db, string.format('INSERT INTO packs_balance(pack, count, maxCount) VALUES (%s, %s, %s);',
				pack, count, maxCount or count
			))
		end

		resourceRoot:setData('packs.balance', getPacksBalance())

	end

	addCommandHandler('setpackbalance', function(player, _, pack, count, maxCount)
		if exports['acl']:isAdmin(player) then
			pack, count, maxCount = tonumber(pack), tonumber(count), tonumber(maxCount)
			if pack and count then
				local pCount = getPacksCount(pack)
				if pCount ~= -1 then
					addPackBalance(pack, count - pCount.count, maxCount)
				else
					addPackBalance(pack, count, maxCount)
				end
			end
		end
	end)

	addCommandHandler('delpackbalance', function(player, _, pack)
		if exports['acl']:isAdmin(player) then
			pack = tonumber(pack)
			if pack then
				dbExec(db, string.format('DELETE FROM packs_balance WHERE pack=%s',
					pack
				))
				resourceRoot:setData('packs.balance', getPacksBalance())
			end
		end
	end)

------------------------------------------------------------------------------------------------------------

	function updateDatabase()
		-- dbExec(db, 'DROP TABLE pack_steps;')
		dbExec(db, 'CREATE TABLE IF NOT EXISTS pack_steps(steps TEXT);')
		local result = dbPoll(dbQuery(db, 'SELECT * FROM pack_steps;'), -1)
		if not (result and result[1]) then
			dbExec(db, 'INSERT INTO pack_steps(steps) VALUES (\'[ [ ] ]\');')
		end 
	end
	addEventHandler('onResourceStart', resourceRoot, updateDatabase)

	function increasePackStep(packName)
		local query = dbPoll(dbQuery(db, string.format('SELECT * FROM pack_steps')), -1)
		local array = fromJSON(query[1]['steps'], true)
		array[packName] = (array[packName] or 1) + 1
		dbExec(db, string.format('UPDATE pack_steps SET steps=\'%s\';', toJSON(array)))
	end

	function getPackStep(packName)
		local query = dbPoll(dbQuery(db, string.format('SELECT * FROM pack_steps;')), -1)
		local array = fromJSON(query[1]['steps'], true)
		return array[packName] or 1
	end


------------------------------------------------------------------------------------------------------------

	function getWinItem(pack)

		increasePackStep(pack.index)
		local step = getPackStep(pack.index)

		local isTopPrize = false
		if pack.top_step and (step % pack.top_step) == 0 then
			isTopPrize = true
		end


		local prizes = {}

		for _, item in pairs(pack.items) do

			if (item.top and isTopPrize) or (not item.top and not isTopPrize) then

				for i = 1, item.chance do
					table.insert(prizes, item)
				end

			end

		end

		prizes = randomSort(prizes)

		local item = prizes[math.random(#prizes)]
		local itemId = item.index

		return itemId, isTopPrize, step, item

	end

	function openPack(pack)

		if client:getData('freeroam.pack.currentPrize') then return end

		local cost = pack.cost

		local packs = client:getData('packs') or {}
		local packBalance = packs[pack.index] or 0

		if packBalance > 0 then
			cost = 0
		end

		if cost > (client:getData('bank.donate') or 0) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		local count = getPacksCount(pack)
		if count ~= -1 and count.count == 0 then
			return exports.hud_notify:notify(client, 'Ошибка', 'Кейсов нет в наличии')
		end

		if count ~= -1 and count.count > 0 then
			addPackBalance(pack.index, -1)
		end

		if packBalance > 0 then
			givePlayerPack(client, pack.index, -1)
		end

		increaseElementData(client, 'bank.donate', -cost)

		local itemId, isTopPrize, step, item = getWinItem(pack)

		if item.notify then

			local colors = { {100, 150, 250}, {255, 80, 160}, {135,255,80} }
			local color = colors[math.random(#colors)]

			setTimer(function( p_name, item_name, color )

				exports.chat_main:displayInfo( root, ('Игрок %s выиграл %s в кейсах! Испытай удачу - F1 >> Кейсы'):format(
					p_name, item_name
				), color )


			end, 10000, 1, client.name, item.name, color)

		end

		increaseElementData(client, 'packs.opened', 1)
		increaseElementData(client, 'packs.opened.'..pack.index, 1)

		triggerClientEvent(client, 'freeroam.pack.openResult', client, itemId)
		client:setData('freeroam.pack.currentPrize', {pack = pack.index, item = itemId})

		exports.logs:addLog(
			'[FREEROAM][PACK]',
			{
				data = {
					player = client.account.name,
					win = itemId,
					pack = pack.name,
					cost = cost,
					is_top = isTopPrize,
					step = step,
				},
			}
		)

	end
	addEvent('freeroam.openPack', true)
	addEventHandler('freeroam.openPack', resourceRoot, openPack)

	function takePackPrize(_player)

		local player = _player or client

		local currentPrize = player:getData('freeroam.pack.currentPrize')
		if not currentPrize then return end

		local item = Config.packs[currentPrize.pack].items[currentPrize.item]
		item.give(player)

		player:setData('freeroam.pack.currentPrize', nil)

		exports.hud_notify:notify(player, 'Кейсы', 'Вы забрали приз')

		exports.logs:addLog(
			'[FREEROAM][PACKTAKE]',
			{
				data = {
					player = player.account.name,
					item = currentPrize.item,
					pack = currentPrize.pack,
				},
			}
		)

	end
	addEvent('freeroam.takePackPrize', true)
	addEventHandler('freeroam.takePackPrize', resourceRoot, takePackPrize)

	function sellPackPrize()

		local currentPrize = client:getData('freeroam.pack.currentPrize')
		if not currentPrize then return end

		local config = Config.packs[currentPrize.pack].items[currentPrize.item]
		local cost = config.sellCost or 0

		exports.money:givePlayerMoney(client, cost)

		client:setData('freeroam.pack.currentPrize', nil)

		exports.hud_notify:notify(client, 'Кейсы', 'Вы продали приз')

		exports.logs:addLog(
			'[FREEROAM][PACKSELL]',
			{
				data = {
					player = client.account.name,
					item = currentPrize.item,
					pack = currentPrize.pack,
					cost = cost
				},
			}
		)

	end
	addEvent('freeroam.sellPackPrize', true)
	addEventHandler('freeroam.sellPackPrize', resourceRoot, sellPackPrize)

	addEventHandler('onPlayerQuit', root, function()

		if source:getData('freeroam.pack.currentPrize') then
			takePackPrize(source)
		end

	end)

	addEventHandler('onResourceStop', resourceRoot, function()

		for _, player in pairs( getElementsByType('player') ) do

			if player:getData('freeroam.pack.currentPrize') then
				takePackPrize(player)
			end
			
		end

	end)

------------------------------------------------------------------------------------------------------------

	function giveAccountPack(account, pack, count)

		if account.player then
			return givePlayerPack(account.player, pack, count)
		end

		local packs = fromJSON( account:getData('packs') or '[[]]', true ) or {}
		packs[pack] = (packs[pack] or 0) + count
		account:setData('packs', toJSON(packs))

	end

	function givePlayerPack(player, pack, count)

		local packs = player:getData('packs') or {}
		packs[pack] = (packs[pack] or 0) + count

		player:setData('packs', packs)
	end

	addCommandHandler('fr_givepack', function(player, _, login, pack, count)
		if exports['acl']:isAdmin(player) then
			pack, count = tonumber(pack), tonumber(count)
			if pack and count then
				local account = getAccount(login)
				if account then
					giveAccountPack(account, pack, count)
				end
			end
		end
	end)