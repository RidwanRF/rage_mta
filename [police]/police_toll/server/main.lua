
function handleTollPass(id)

	local tickets = client:getData('police.tollTickets') or 0
	local byTicket = tickets > 0

	local isVip = exports.main_vip:isVip(client) 

	local cost = getCurrentPassCost()

	if not isVip then
		if byTicket then
			increaseElementData(client, 'police.tollTickets', -1)
		else

			if cost > exports.money:getPlayerMoney(client) then
				return exports.chat_main:displayInfo(client, 'Недостаточно денег', {255, 20, 20})
			end

			exports.money:takePlayerMoney(client, cost)
			triggerClientEvent(client, 'police.toll.closeWindow', client)

		end
	end

	if byTicket then
		exports.hud_notify:notify(client, 'КПП', 'Пропуск использован')
	elseif isVip then
		exports.hud_notify:notify(client, 'КПП', 'VIP-пропуск активирован')
	else
		exports.hud_notify:notify(client, 'КПП', 'Пропуск оплачен')
	end

	openToll(id)
	exports.main_sounds:playSound(client, 'toll')

	outputDebugString(string.format('[TOLL] %s passed the toll (byTicket: %s, vip: %s)',
		client.account.name, tostring(byTicket), tostring(isVip)
	))

end
addEvent('toll.handlePass', true)
addEventHandler('toll.handlePass', resourceRoot, handleTollPass)


function buyTollTickets(count)

	local _, ticket = getCurrentPassCost()
	local cost = ticket * count

	if exports.money:getPlayerMoney(client) < cost then
		return exports.chat_main:displayInfo(client, 'Недостаточно денег', {255, 20, 20})
	end

	exports.money:takePlayerMoney(client, cost)
	increaseElementData(client, 'police.tollTickets', count)

	exports.hud_notify:notify(client, 'КПП', string.format('Вы купили проездных билетов: %s', count), 3000)

	outputDebugString(string.format('[TOLL] %s bought %s tickets for %s rub',
		client.account.name, count, cost
	))

end
addEvent('toll.buyTickets', true)
addEventHandler('toll.buyTickets', resourceRoot, buyTollTickets)