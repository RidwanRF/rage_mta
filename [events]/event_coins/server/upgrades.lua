
------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		saver:addSaveKey('event_coins.upgrades', 'table', true)

	end)

------------------------------------------
	
	function buyUpgrade( upgrade_id )

		local config = Config.upgrades[upgrade_id]
		local upgrades = client:getData('event_coins.upgrades') or {}

		if (upgrades[upgrade_id] or 0) >= config.limit then
			return exports.hud_notify:notify(client, 'Ошибка', 'Превышен лимит')
		end

		if config.cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		upgrades[upgrade_id] = ( upgrades[upgrade_id] or 0 ) + 1
		client:setData('event_coins.upgrades', upgrades)

		exports.money:takePlayerMoney(client, config.cost)

		-- exports.hud_notify:notify(client, 'Успешно', 'Улучшение приобретено')

		exports.logs:addLog(
			'[COINS][UPGRADE]',
			{
				data = {
					player = client.account.name,
					cost = config.cost,
					upgrade = upgrade_id,
				},	
			}
		)

	end
	addEvent('event_coins.buyUpgrade', true)
	addEventHandler('event_coins.buyUpgrade', resourceRoot, buyUpgrade)

------------------------------------------