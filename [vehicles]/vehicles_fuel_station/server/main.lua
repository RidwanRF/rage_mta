
------------------------------------------------------------------------------------

	fuelings = {}

	function fuelCar(fuelType, fuelCount)

		if not client.vehicle then return end

		client.vehicle.frozen = true
		client.vehicle:setData('engine.disabled', true)

		if fuelType == 'electro' then
			exports.hud_notify:notify(client, 'Зарядка', 'Идет зарядка', time)
		else
			exports.hud_notify:notify(client, 'Заправка', 'Идет заправка', time)
		end

		local amount = fuelCount

		local timer = setTimer(function(client, vehicle, fuelType)

			local fueling = fuelings[client]

			if not isElement(vehicle) or not isElement(client)
			or not fueling then
				return finishFueling(client)
			end

			local maxFuel = exports.vehicles_main:getVehicleProperty(vehicle, 'fuel')
			local fuel = vehicle:getData('fuel') or 0

			local config = overrideConfig(client)
			config = config[fuelType]


			if math.floor(fueling.amount) <= 0 then
				return finishFueling(client)
			end

			local amount = math.ceil( math.min(10, maxFuel-fuel) )

			local cost = amount * config.cost
			if cost > exports.money:getPlayerMoney(client) then
				exports.hud_notify:notify(client, 'Заправка', 'Недостаточно денег')
				return finishFueling(client, true)
			end

			fueling.amount = fueling.amount - amount
			fueling.total = fueling.total + amount

			exports.money:takePlayerMoney(client, cost, true, false)

			increaseElementData(vehicle, 'fuel', amount)
			vehicle:setData('fuel_type', fuelType)

			-- exports.logs:addLog(
			-- 	'[FUELING]',
			-- 	{
			-- 		data = {
			-- 			player = client.account.name,
			-- 			vehicle = vehicle:getData('id') or '---',
			-- 			amount = amount,
			-- 			fuelType = fuelType,
			-- 			cost = cost,
			-- 		},	
			-- 	}
			-- )

		end, 1000, 0, client, client.vehicle, fuelType)

		fuelings[client] = {
			vehicle = client.vehicle,
			total = 0,
			amount = amount,
			fuelType = fuelType,
			timer = timer,
		}

	end
	addEvent('fuel.fuelCar', true)
	addEventHandler('fuel.fuelCar', resourceRoot, fuelCar)

	function finishFueling(player, noNotify)
		local fueling = fuelings[player]

		if fueling then

			fueling.vehicle.frozen = false

			if not noNotify then
				if fueling.fuelType == 'electro' then
					exports.hud_notify:notify(player,
						'Зарядка', string.format('+%s Вт',
							fueling.total
						)
					)
				else
					exports.hud_notify:notify(player,
						'Заправка', string.format('+%s %s',
							fueling.total, getWordCase(fueling.total, 'литр', 'литра', 'литров')
						)
					)
				end
			end

			killTimer(fueling.timer)
		end

		fuelings[player] = nil

	end

	addEventHandler('onPlayerQuit', root, function()
		if fuelings[source] then
			finishFueling(source)
		end
	end)


------------------------------------------------------------------------------------

