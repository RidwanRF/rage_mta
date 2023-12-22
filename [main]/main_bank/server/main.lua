
------------------------------------------------------------------------------------------

	function putMoney(sum)
		if not sum then return end
		if sum <= 0 then return end

		if exports.money:getPlayerMoney(client) < sum then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		givePlayerBankMoney(client, sum)
		exports.money:takePlayerMoney(client, sum, false)

		appendPlayerHistory(client, 'Пополнение счета', sum)

		exports.hud_notify:notify(client, 'Успешно', 'Счет пополнен')

		exports.logs:addLog(
			'[BANK][PUT]',
			{
				data = {
					player = client.account.name,
					sum = sum,
				},	
			}
		)

	end
	addEvent('bank.putMoney', true)
	addEventHandler('bank.putMoney', resourceRoot, putMoney)

------------------------------------------------------------------------------------------

	function takeMoney(sum)

		if not sum then return end
		if sum <= 0 then return end

		local bank = getPlayerBankMoney(client)

		if bank < sum then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		takePlayerBankMoney(client, sum)
		exports.money:givePlayerMoney(client, sum)

		appendPlayerHistory(client, 'Вывод денег', -sum)

		exports.hud_notify:notify(client, 'Успешно', 'Средства выведены')

		exports.logs:addLog(
			'[BANK][TAKE]',
			{
				data = {
					player = client.account.name,
					sum = sum,
				},	
			}
		)

	end
	addEvent('bank.takeMoney', true)
	addEventHandler('bank.takeMoney', resourceRoot, takeMoney)

------------------------------------------------------------------------------------------

	function sendMoney(sum, login)

		if not sum then return end
		if sum <= 0 then return end

		local comission = math.floor( sum * Config.sendComission / 100 )
		local n_sum = sum + comission

		if exports.acl:isPlayerInGroup(client, 'press') then
			return exports.chat_main:displayInfo(client, 'На пресс-аккаунте запрещен банк', {255, 20, 20})
		end

		local bank = getPlayerBankMoney(client)

		if bank < n_sum then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		local account = getAccount(login)

		if not account or not account.player then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игрок не найден')
		end

		if account.player == client then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нельзя перевести себе')
		end

		local player = account.player

		takePlayerBankMoney(client, n_sum)
		givePlayerBankMoney(player, sum)

		appendPlayerHistory(client, 'Перевод игроку', -n_sum)
		appendPlayerHistory(player, 'Перевод от игрока', sum)

		exports.hud_notify:notify(player, 'Банк',
			string.format('Пополнение +%s$', splitWithPoints(sum, '.'))
		)

		exports.hud_notify:notify(client, 'Успешно', 'Средства переведены')

		exports.logs:addLog(
			'[BANK][SEND]',
			{
				data = {

					sender = client.account.name,
					receiver = player.account.name,
					sum = sum,
					comission = comission,

				},	
			}
		)

	end
	addEvent('bank.sendMoney', true)
	addEventHandler('bank.sendMoney', resourceRoot, sendMoney)

------------------------------------------------------------------------------------------

	function payWithdraws(sum)


		if not sum then return end
		if sum <= 0 then return end

		local bank = getPlayerBankMoney(client)
		local withdraws = client:getData('police.withdraws') or 0

		if withdraws < sum then
			return exports.hud_notify:notify(client, 'Ошибка', 'Введите сумму меньше')
		end

		if bank < sum then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		takePlayerBankMoney(client, sum)
		increaseElementData(client, 'police.withdraws', -sum)

		appendPlayerHistory(client, 'Оплата штрафов', -sum)

		exports.hud_notify:notify(client, 'Успешно', 'Штрафы оплачены')

		exports.logs:addLog(
			'[BANK][WITHDRAWS]',
			{
				data = {
					player = client.account.name,
					sum = sum,
				},	
			}
		)

	end
	addEvent('bank.payWithdraws', true)
	addEventHandler('bank.payWithdraws', resourceRoot, payWithdraws)

------------------------------------------------------------------------------------------
