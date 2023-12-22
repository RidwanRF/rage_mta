
------------------------------------------------------------------------------------------

	function buyItem(item, amount, lc)

		if not amount then return end
		if amount <= 0 then return end

		local items_config = exports.main_inventory:getConfigSetting('items')
		if not items_config then return end

		local item_config = items_config[ item ]
		local shop_config = Config.shop_items[ lc.section ][ lc.index ]

		local cost = ( shop_config.cost )

		if exports.money:getPlayerMoney(client) < cost then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		exports.money:takePlayerMoney(client, cost)

		exports.main_inventory:addInventoryItem({
			player = client,
			count = amount,
			item = item,	
		})

		if item_config.type == 'weapon' then
			increaseElementData( client, 'weapons.bought', 1, false )
		end

		exports.hud_notify:notify(client, 'Успешно', 'Покупка совершена')

		exports.logs:addLog(
			'[WEAPON][BUY]',
			{
				data = {
					player = client.account.name,
					cost = cost,
					item = item,
					amount = amount,
				},	
			}
		)

	end
	addEvent('weapon_shop.buyItem', true)
	addEventHandler('weapon_shop.buyItem', resourceRoot, buyItem)

------------------------------------------------------------------------------------------