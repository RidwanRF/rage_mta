
function clearStars()

	local count = client:getData('police.stars') or 0
	-- local stars = client:getData('police.stars') or 0
	-- if stars < count then return end

	if count == 0 then
		return exports.hud_notify:notify(client, 'Снять звезды', 'У вас нет звезд')
	end

	local cost = Config.starCost * count


	if cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Снять звезды', 'Недостаточно денег')
	end

	exports.money:takePlayerMoney(client, cost)
	exports.police_main:addPlayerStars(client, -count)

	exports.hud_notify:notify(client, 'Полиция', 'Вы сняли розыск', 3000)

	exports.logs:addLog(
		'[POLICE][STARS]',
		{
			data = {
				player = client.account.name,
				count = count,
				sum = cost,
			},	
		}
	)

end
addEvent('police.clearStars', true)
addEventHandler('police.clearStars', root, clearStars)

function payWithdraws(amount)

	if amount <= 0 then return end

	local withdraws = client:getData('police.withdraws') or 0
	if withdraws < amount then return end

	if exports.money:getPlayerMoney(client) < amount then
		return exports.hud_notify:notify(client, 'Оплата штрафов', 'Недостаточно денег')
	end

	exports.money:takePlayerMoney(client, amount)


	client:setData('police.withdraws', withdraws - amount)

	exports.hud_notify:notify(client, 'Полиция', 'Вы оплатили штрафы', 3000)

	exports.logs:addLog(
		'[POLICE][STARS]',
		{
			data = {
				player = client.account.name,
				sum = cost,
			},	
		}
	)

end
addEvent('police.payWithdraws', true)
addEventHandler('police.payWithdraws', root, payWithdraws)