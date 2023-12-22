
databases = {
	vehicles = dbConnect('sqlite', ':databases/vehicles.db'),
	numbers = dbConnect('sqlite', ':databases/numbers.db'),
}

propertyExchangeFunctions = {

	money = function(from, to, data)

		exports.money:takePlayerMoney(from, data.cost, false)
		exports.money:givePlayerMoney(to, data.cost)

		exports.logs:addLog(
			'[EXCHANGE][MONEY]',
			{
				data = {
					from = from.account.name,
					to = to.account.name,
					amount = data.cost,
				},	
			}
		)

	end,

	number = function(from, to, data)

		local id = data.id
		exports.vehicles_numbers:updatePlateOwner(id, to.account.name)

		exports.logs:addLog(
			'[EXCHANGE][PLATE]',
			{
				data = {
					from = from.account.name,
					to = to.account.name,
					plate_id = id,
					plate = data.number,
				},	
			}
		)

	end,

	vehicle = function(from, to, data)
	
		if data.owner == from.account.name then
			local id = data.id
			exports.vehicles_main:setVehicleData(id, 'owner', to.account.name)

			exports.vehicles_main:returnPlayerVehicles(from)
			exports.vehicles_main:returnPlayerVehicles(to)

			exports.logs:addLog(
				'[EXCHANGE][VEHICLE]',
				{
					data = {
						from = from.account.name,
						to = to.account.name,
						id = id,
						model = data.model,
					},	
				}
			)
		end

	end,

}

function handlePropertyExchange(from, to, data)
	local func = propertyExchangeFunctions[data.exchange_type]
	func(from, to, data)
end

function canExchangeBeCompleted(primPlayer, secPlayer)

	local players = {primPlayer, secPlayer}

	for _, player in pairs(players) do
		if exports.acl:isPlayerInGroup(player, 'press') then
			return false, string.format('У игрока %s пресс-аккаунт',
				clearColorCodes(player.name)
			)
		end
	end

	if getDistanceBetween(primPlayer, secPlayer) > 30 then
		return false, string.format('Слишком большое расстояние')
	end

	local exchangesCount = {} -- сколько у игроков имущества разных типов на обмен
	local commonCount = {} -- сколько у игроков имущества разных типов всего

	local addings = {} -- сколько у игроков имущества разных типов добавится
	local propertyLimits = {} -- сколько у игроков имущества разных типов лимит

	local limits = {} -- если какой то тип имущества < 0 то ошибка

	local types = {'vehicle', 'number'}
	local typesStr = {
		number = 'номеров',
		vehicle = 'автомобилей',
	}

	for index, player in pairs(players) do

		exchangesCount[player] = {}
		commonCount[player] = {}

		local items = player:getData('exchange.items') or {}
		for _, item in pairs(items) do

			local add = (item.exchange_type == 'vehicle' and (item.needLots or 1) or 1)

			commonCount[player][item.exchange_type] = commonCount[player][item.exchange_type] or 0
			exchangesCount[player][item.exchange_type] = exchangesCount[player][item.exchange_type] or 0

			if item.exchange_type ~= 'vehicle' or getVehicleType(item.model) ~= 'Bike' then

				if item.exchange then

					exchangesCount[player][item.exchange_type] = (
						exchangesCount[player][item.exchange_type] or 0
					) + add

				end

				commonCount[player][item.exchange_type] = (
					commonCount[player][item.exchange_type] or 0
				) + add

			end

		end
	end

	for index, player in pairs(players) do
		local opPlayer = players[3-index]

		addings[player] = {}
		for _, type in pairs(types) do
			addings[player][type] = (
				(exchangesCount[opPlayer][type] or 0)
				- (exchangesCount[player][type] or 0)
			)
		end

		propertyLimits[player] = {

			vehicle = (player:getData('parks.all') or 0) - (commonCount[player].vehicle or 0),

			number = exports.vehicles_numbers:getConfigSetting('defaultRepositorySize') + (
				player:getData('numbers.repository_expand') or 0
				) - (commonCount[player].number or 0),
		}

		limits[player] = {}
		for _, type in pairs(types) do
			limits[player][type] = propertyLimits[player][type] - addings[player][type]
		end

	end

	for player, types in pairs(limits) do
		local opPlayer = player == players[1] and players[2] or players[1]
		for type, count in pairs(types) do
			if count < 0 and (exchangesCount[opPlayer][type] or 0) > 0 then
				return false, string.format('%s превысит лимит %s',
					clearColorCodes(player.name), typesStr[type]
				)
			end
		end
	end


	for index, player in pairs(players) do

		local items = player:getData('exchange.items') or {}

		local op_player = players[3-index]
		local op_player_items = op_player:getData('exchange.items') or {}

		local car_counts, car_breaks = {}, {}

		for _, item in pairs(items) do

			if item.exchange and item.exchange_type == 'vehicle' then

				if item.exchange then

					car_breaks[item.model] = ( car_breaks[item.model] or 0 ) + 1

				end

			end

		end

		for _, item in pairs( op_player_items ) do

			if not item.exchange and item.exchange_type == 'vehicle' and car_breaks[item.model] then
				car_counts[item.model] = ( car_counts[item.model] or 0 ) + 1
			end

		end

		for model, amount in pairs( car_counts ) do

			if ( amount + (car_breaks[model] or 0) ) > 2 then
				return false, string.format('%s превысит лимит одинаковых автомобилей',
					clearColorCodes(op_player.name)
				)
			end

		end

	end

	return true

end

function loadPlayerExchangeItems(player)

	local login = player.account.name

	local items = {
		numbers = dbPoll(dbQuery(databases.numbers,
			string.format('SELECT * FROM numbers WHERE owner="%s";', login)), -1),
		vehicles = dbPoll(dbQuery(databases.vehicles,
			string.format('SELECT * FROM vehicles WHERE owner="%s" AND expiry_date IS NULL AND flag IS NULL;',
				login)), -1),
	}

	local types = {
		numbers = 'number',
		vehicles = 'vehicle',
		money = 'money',
	}

	for _, number in pairs(items.numbers) do

		local donate, dollars = exports.vehicles_numbers:getPlateCost(number.number)
		if donate then
			dollars = exports.core:getDonateConvertMul() * donate
		end

		number.cost = dollars
		
	end

	for _, vehicle in pairs(items.vehicles) do
		vehicle.cost = exports.vehicles_main:getVehicleCost(vehicle.model)
		vehicle.needLots = exports.vehicles_main:getVehicleLots(vehicle.model)
	end

	local mixed = {}

	for itemType, itemsSection in pairs(items) do
		for _, item in pairs(itemsSection) do

			item.exchange_type = types[itemType]
			item.name = getExchangeItemName(item)

			item.color = nil

			table.insert(mixed, item)
		end
	end

	player:setData('exchange.items', mixed)
end