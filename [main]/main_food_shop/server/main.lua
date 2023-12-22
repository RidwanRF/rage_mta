

function buyItem(item)

	local config = Config.items[item]

	if config.cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	exports.money:takePlayerMoney(client, config.cost)

	exports.main_inventory:addInventoryItem({
		player = client,
		item = config.item,
		count = 1,	
	})

	exports.hud_notify:notify(client, 'Магазин', 'Вы купили еду')
	exports.hud_notify:notify(client, 'Магазин', 'Еда помещена в инвентарь')

	exports.logs:addLog(
		'[FOOD][BUY]',
		{
			data = {
				player = client.account.name,
				cost = config.cost,
				item = item,
			},	
		}
	)

end
addEvent('food_shop.buyItem', true)
addEventHandler('food_shop.buyItem', resourceRoot, buyItem)