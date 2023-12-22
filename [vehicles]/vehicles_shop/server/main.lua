
function buyVehicle(model, color, payType)

	local vehiclesList = exports['vehicles_main']:getVehiclesList()
	local config = vehiclesList[model]

	local discount = getModelDiscount(model) + Config.gDiscount
	local cost = config.cost - config.cost*discount/100

	local money

	if payType == 'bank' then
		money = exports['main_bank']:getPlayerBankMoney(client)
	elseif payType == 'money' then
		money = exports['money']:getPlayerMoney(client)
	elseif payType == 'donate' then
		cost = config.donate_cost or 0
		money = exports['main_bank']:getPlayerDonate(client)
	end

	if cost > money then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if exports['vehicles_main']:getVehiclesOfModel(
	client.account.name, model) >= Config.maxVehiclesOfType then
		return exports.hud_notify:notify(client, 'Превышен лимит', string.format('%s %s',
			Config.maxVehiclesOfType, getWordCase(
				Config.maxVehiclesOfType,
				'одинакового автомобиля',
				'одинаковых автомобилей',
				'одинаковых автомобилей'
			)
		))
	end

	local current, all = client:getData('parks.loaded') or 0, client:getData('parks.all') or 0
	if (current + 1) > all then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно парковок')
	end

	if payType == 'bank' then
		money = exports['main_bank']:takePlayerBankMoney(client, cost)
	elseif payType == 'money' then
		money = exports['money']:takePlayerMoney(client, cost)
	elseif payType == 'donate' then
		money = exports['main_bank']:takePlayerDonate(client, cost)
	end

	triggerClientEvent(client, 'vehicles.shop.close', client)
	local vehicle_id = exports['vehicles_main']:giveAccountVehicle(client.account.name, model,
		{
			appearance_upgrades = {
				color_1 = color,
				color_2 = color,
			},
		}
	)

	exports.main_freeroam:addBoughtCar( client.account.name, model )
	exports.main_freeroam:updatePlayerAchievments( client )

	exports['hud_notify']:notify(client, 'Новый транспорт', string.format('%s %s',
		config.mark, config.name
	), 5000)

	increaseElementData(client, 'vehicles_shop.vehicles_bought', 1)

	exports.logs:addLog(
		'[CARSHOP][BUY]',
		{
			data = {
				player = client.account.name,
				cost = cost,
				valute = valute,
				model = model,
				vehicle_id = vehicle_id,
			},	
		}
	)

end
addEvent('vehicle.shop.buy', true)
addEventHandler('vehicle.shop.buy', resourceRoot, buyVehicle)
