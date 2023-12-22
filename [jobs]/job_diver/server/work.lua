
	
----------------------------------------------------------------

	playersWork = {}

----------------------------------------------------------------


	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		player.model = Config.skin

		playersWork[player] = {}

		createPlayerSource(player)

		player:setData('diver.inventory_size', Config.defaultInventorySize)

		givePlayerOxygen( player, Config.defaultOxygen )

		exports.hud_notify:notify(player, 'Посетите склад снаряжения', 'Для улучшения работы')

		exports.hud_notify:notify(player, 'Кислород', string.format('Вы получили баллон на %s сек', Config.defaultOxygen))

	end

----------------------------------------------------------------

	function createPlayerSource(player)

		local work = playersWork[player]
		if not work then return end

		local position = Config.points[math.random(#Config.points)]
		local x,y,z = unpack(position)

		local marker = createMarker(x,y,z, 'corona', 3, 0, 0, 0, 0, player)
		marker:setData('controlpoint.3dtext', '[Обыщите точку]')

		local blip = createBlipAttachedTo(marker, 0, nil, nil, nil, nil, nil, nil, nil, player)
		blip:setData('icon', 'target')

		work.source = { marker = marker, blip = blip }

		exports.hud_notify:notify(player, 'На карте новая точка', 'Обыщите ее')

		triggerClientEvent(player, 'diver.createLootBind', resourceRoot, marker)

	end

----------------------------------------------------------------

	function lootMarker(marker)

		local work = playersWork[client]
		if not work then return end

		if work.source and work.source.marker == marker then

			local inventory = client:getData('diver.inventory') or {}
			local inventory_size = client:getData('diver.inventory_size') or {}

			if #inventory >= inventory_size then

				exports.hud_notify:notify(client, 'Ошибка', 'Рабочий рюкзак полон')

			else

				work.stats = work.stats or { found = 0, loses = 0, }

				if math.random(1,2) == 2 and ( work.stats.loses/math.max( 0.1, work.stats.found ) < ( 1/5 ) ) then

					exports.hud_notify:notify(client, 'Неудача', 'Вы ничего не нашли')
					work.stats.loses = work.stats.loses + 1

				else

					local id = math.random(#Config.loot)
					local config = Config.loot[id]

					table.insert(inventory, { id = id, cost = math.random(unpack(config.cost)) })

					client:setData('diver.inventory', inventory)

					work.stats.found = work.stats.found + 1

					exports.hud_notify:notify(client, 'Найден ценный предмет', config.name)

				end

			end

			clearTableElements(work.source)
			work.source = nil

			setTimer(function(player)

				if isElement(player) then
					createPlayerSource(player)
				end

			end, 1000, 1, client)

		end

	end
	addEvent('diver.lootMarker', true)
	addEventHandler('diver.lootMarker', resourceRoot, lootMarker)

----------------------------------------------------------------

	function takePlayerInventory(_player)

		local player = _player or client

		local inventory = player:getData('diver.inventory') or {}

		if #inventory == 0 and client then
			return exports.hud_notify:notify(player, 'Ошибка', 'Рюкзак пуст')
		end

		local totalCost = 0

		for _, item in pairs(inventory) do
			totalCost = totalCost + math.floor(item.cost)
		end


		player:setData('diver.inventory', {})

		exports.jobs_main:addPlayerSessionMoney(player, totalCost)
		exports.jobs_main:addPlayerStats(player, 'items_found', getTableLength(inventory))

	end
	addEvent('diver.takeInventory', true)
	addEventHandler('diver.takeInventory', resourceRoot, takePlayerInventory)

----------------------------------------------------------------

	function destroyPlayerWork(player)

		local boat_id = exports.jobs_main:getPlayerSessionData(player, 'boat_id')

		if boat_id then
			exports.vehicles_main:wipeVehicle(boat_id, player)
		end

		local work = playersWork[player]
		if not work then return end

		player.model = player:getData('character.skin') or 0

		player:setData('diver.inventory', nil)
		player:setData('diver.inventory_size', nil)
		player:setData('diver.oxygen', nil)
		player:setData('diver.oxygen_max', nil)

		clearTableElements(work)
		playersWork[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then

			takePlayerInventory(source)
			destroyPlayerWork(source)

		end

	end)

----------------------------------------------------------------