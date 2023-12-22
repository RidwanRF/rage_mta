
function getCurrentExchangeTax(primPlayer, secPlayer)
	local sum = 0

	local items = {
		primPlayer:getData('exchange.items') or {},
		isElement(secPlayer) and (secPlayer:getData('exchange.items') or {}) or {},
	}

	for _, playerItems in pairs(items) do
		for _, item in pairs(playerItems) do
			if item.exchange then
				sum = sum + item.cost
			end
		end
	end

	return math.floor(sum * Config.tax / 100)
end


function getExchangeItemName(item)
	if item.exchange_type == 'money' then
		return string.format('%s $', splitWithPoints(item.cost, '.'))
	elseif item.exchange_type == 'vehicle' then
		return string.format('%s  %s',
			exports.vehicles_main:getVehicleModName(item.model),
			exports.vehicles_numbers:convertNumberplateToText(item.plate)
		)
	elseif item.exchange_type == 'number' then
		return string.format('%s',
			exports.vehicles_numbers:convertNumberplateToText(item.number)
		)
	end
end


function canPlayerPutMoney(sum)
	local money = exports.money:getPlayerMoney(localPlayer)

	local exchangeSum = 0

	local items = localPlayer:getData('exchange.items') or {}

	for _, item in pairs(items) do
		if item.exchange then
			exchangeSum = exchangeSum + item.cost
		end
	end

	return (exchangeSum + sum) <= money
end

function convertTypeToString(type)
	local types = {
		vehicle = 'Автомобиль',
		money = 'Деньги',
		number = 'Номер',
	}
	return types[type]
end


function isPlayerExchangeCompatible(player)

	if not root:getData('isTest') then
		if player == localPlayer then return false end
	end

	return getDistanceBetween( player, localPlayer ) < 10
end
