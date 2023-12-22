
------------------------------------------

	client_requests = {}

	function buyTuningBasket( basket )

		if not client.vehicle then return end

		if client_requests[client] and ( getTickCount() - client_requests[client] ) < 1000 then
			return
		end

		client_requests[client] = getTickCount()

		local sum = 0

		local tuning = {
			defaultTuning = {},
			componentsTuning = {},
		}


		------------------------------------------

		for _, component in pairs( basket ) do

			local config = findTuningComponent(component.component.config_link)
			sum = sum + config.price

			tuning[ component.component.config_link[1] ][component.section] = component.value or component.component.index
		end

		------------------------------------------

		if exports['money']:getPlayerMoney( client ) < sum then
			return exports['hud_notify']:notify(client, 'Тюнинг', 'Недостаточно денег')
		end

		exports['money']:takePlayerMoney(client, sum)

		------------------------------------------

		for key, value in pairs( tuning.defaultTuning ) do
			client.vehicle:setData(key, value)
		end

		local componentsTuning = exports.vehicles_main:getSqueezedData(client.vehicle, 'tuning') or {}
		-- local componentsTuning = client.vehicle:getData('tuning') or {}
		for key, value in pairs( tuning.componentsTuning or {} ) do
			componentsTuning[key] = value
		end

		tuning.componentsTuning = componentsTuning

		client.vehicle:setData('tuning', componentsTuning, false)
		triggerClientEvent(client, 'vehicles.receiveSyncData', root, client.vehicle, { tuning = componentsTuning })

		------------------------------------------

		exports.vehicles_main:saveVehicleData(client.vehicle)

		initializeClientTuning(client, tuning)

		exports['hud_notify']:notify(client, 'Автомобиль', 'Вы приобрели тюнинг')

		exports.logs:addLog(
			'[TUNING][BUY]',
			{
				data = {
					player = client.account.name,
					sum = sum,
					tuning = tuning,
				},	
			}
		)



	end
	addEvent('tuning.buy', true)
	addEventHandler('tuning.buy', resourceRoot, buyTuningBasket)

------------------------------------------

	function initializeClientTuning(player, tuning)

		local result = tuning.defaultTuning
		result.tuning = getTableLength(tuning.componentsTuning) > 0 and tuning.componentsTuning or nil

		triggerClientEvent(player, 'tuning.client.init', player, nil, result)
	end

------------------------------------------