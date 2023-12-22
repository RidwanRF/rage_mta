
---------------------------------------------------------------

	function buyVinils(list)

		local cost = 0

		local vinils = {}
		local collection = client:getData('vinils.collection') or {}

		for _, layer in pairs( list ) do

			local config = Config.vinilsAssoc[ layer.data.path ]

			if layer.data.basket then
				cost = cost + config.cost
			end

			if layer.data.collection then

				for index, c_data in pairs( collection ) do
					if c_data.path == layer.data.path then

						c_data.count = c_data.count - 1

						if c_data.count <= 0 then
							table.remove(collection, index)
						end

					end
				end

			end

			layer.data.layer_name = nil
			layer.data.basket = nil

			table.insert(vinils, layer.data)

		end

		if cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end


		exports.money:takePlayerMoney(client, cost)

		
		triggerClientEvent(client, 'tuning.client.init', client, nil, { paintjob = vinils })

		client.vehicle:setData('paintjob', vinils, false)
		triggerClientEvent(client, 'vehicles.receiveSyncData', root, client.vehicle, { paintjob = vinils })

		exports.vehicles_main:saveVehicleData(client.vehicle)

		client:setData('vinils.collection', collection)

		triggerClientEvent(client, 'vinils.resetBasket', resourceRoot)

		exports.hud_notify:notify(client, 'Успешно', 'Наклейки обновлены')

		exports.logs:addLog(
			'[VINILS][BUY]',
			{
				data = {
					player = client.account.name,
					cost = cost,
					list = vinils,
				},	
			}
		)

	end
	addEvent('vinils.buy', true)
	addEventHandler('vinils.buy', resourceRoot, buyVinils)

---------------------------------------------------------------

	function addCollectionVinil(login, vinil, count)

		local account = getAccount(login)
		if not account then return end

		local collection

		if account.player then
			collection = account.player:getData('vinils.collection') or {}
		else
			collection = fromJSON( account:getData('vinils.collection') or '[[]]' ) or {}
		end

		local found = false

		for _, data in pairs( collection ) do

			if data.path == vinil then

				data.count = data.count + (count or 1)
				found = true
				break

			end

		end

		if not found then
			table.insert( collection, { count = count or 1, path = vinil } )
		end

		if account.player then
			account.player:setData('vinils.collection', collection)
		else
			account:setData('vinils.collection', toJSON(collection))
		end

	end

	addCommandHandler('addvinil', function(player, _, login, vinil, count)

		if exports.acl:isAdmin(player) then

			vinil = vinil .. '.png'

			addCollectionVinil( login, vinil, tonumber(count) or 1 )

		end

	end)

---------------------------------------------------------------
