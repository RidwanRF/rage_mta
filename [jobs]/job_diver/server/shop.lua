

function buyShopItem(item)

	if exports.jobs_main:getPlayerWork(client) ~= Config.resourceName then
		return
	end

	local config = Config.shop[item]
	if config.cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	local flag = config.give(client)

	if flag then

		exports.money:takePlayerMoney(client, config.cost)
		exports.hud_notify:notify(client, 'Успешно', 'Вы приобрели предмет')

		exports.logs:addLog(
			'[DIVER][SHOP]',
			{
				data = {
					player = client.account.name,
					cost = config.cost,
				},	
			}
		)

	end


end
addEvent('diver.buyShopItem', true)
addEventHandler('diver.buyShopItem', resourceRoot, buyShopItem)