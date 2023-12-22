
function putDepositMoney(sum)
	if not sum then return end
	if sum <= 0 then return end

	local bank = client:getData('bank.rub') or 0
	local deposits = client:getData('bank.deposits') or 0

	if bank < sum then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	if (deposits + sum) > Config.maxDepositsSum then
		return exports.hud_notify:notify(client, 'Ошибка', string.format('Лимит вкладов - %s $',
			splitWithPoints(Config.maxDepositsSum, '.')
		))
	end

	takePlayerBankMoney(client, sum)
	client:setData('bank.deposits', deposits + sum)
	
	appendPlayerHistory(client, 'Пополнение вкладов', -sum)

	exports.hud_notify:notify(client, 'Успешно', 'Вклады пополнены')

	exports.logs:addLog(
		'[BANK][DEPOSIT][PUT]',
		{
			data = {
				player = client.account.name,
				sum = sum,
			},	
		}
	)

end
addEvent('bank.putDepositMoney', true)
addEventHandler('bank.putDepositMoney', resourceRoot, putDepositMoney)

function takeDepositMoney(sum)

	if not sum then return end
	if sum <= 0 then return end

	local bank = client:getData('bank.rub') or 0
	local deposits = client:getData('bank.deposits') or 0

	if deposits < sum then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	client:setData('bank.deposits', deposits - sum)
	givePlayerBankMoney(client, sum)

	appendPlayerHistory(client, 'Вывод с вкладов', sum)

	exports.hud_notify:notify(client, 'Успешно', 'Вывод на банк. счет')

	exports.logs:addLog(
		'[BANK][DEPOSIT][TAKE]',
		{
			data = {
				player = client.account.name,
				sum = sum,
			},	
		}
	)

end
addEvent('bank.takeDepositMoney', true)
addEventHandler('bank.takeDepositMoney', resourceRoot, takeDepositMoney)

function updateDeposits()
	for _, account in pairs( getAccounts() ) do

		local deposits = account:getData('bank.deposits') or 0

		local state = exports.main_vip:isAccountVip(account) and 'vip' or 'default'

		deposits = math.floor(math.clamp(deposits + deposits * (Config.depositPercent[state]/100),
			0, Config.maxDepositsAddSum))

		account:setData('bank.deposits', deposits)

		if account.player then
			account.player:setData('bank.deposits', deposits)
		end

	end
end

addEventHandler('onServerDayCycle', root, updateDeposits)
