
function openPlayerWindow(player, section)
	triggerClientEvent(player, 'exchange.openWindow', player, section)
end

function closePlayerWindow(player, section)
	triggerClientEvent(player, 'exchange.closeWindow', player, section)
end

function sendExchangeInvite(player)

	if getDistanceBetween( player, client ) > 30 then
		return exports.hud_notify:notify(client, 'Ошибка', 'Большое расстояние')
	end

	if (player:getData('police.withdraws') or 0) >= Config.withdrawsLimit then
		return exports.hud_notify:notify(client, 'Ошибка', 'У игрока имеются штрафы')
	end	

	if client:getData('exchange.invited') then return end

	if player:getData('exchange.inviter') or player:getData('exchange.invited') or player:getData('exchange.player') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Игрок в другой сделке')
	end

	player:setData('exchange.inviter', client)
	client:setData('exchange.invited', player)
	openPlayerWindow(client, 'waiting')
	openPlayerWindow(player, 'invite')


end
addEvent('exchange.invite', true)
addEventHandler('exchange.invite', resourceRoot, sendExchangeInvite)

function sendExchangeInviteResponse(flag)

	local inviter = client:getData('exchange.inviter')
	if not isElement(inviter) then return end

	if flag then

		openPlayerWindow(inviter, 'main')
		openPlayerWindow(client, 'main')

		clearExchangeFlags(client)
		clearExchangeFlags(inviter)

		loadPlayerExchangeItems(inviter)
		loadPlayerExchangeItems(client)

		inviter:setData('exchange.primaryPlayer', true)

		client:setData('exchange.inviter', false)
		inviter:setData('exchange.invited', false)

		client:setData('exchange.player', inviter)
		inviter:setData('exchange.player', client)

		triggerClientEvent({client,inviter}, 'exchange.clearLists', resourceRoot)

	else

		local inviter = client:getData('exchange.inviter')
		exports.hud_notify:notify(inviter, 'Обменник', 'Игрок отказался от сделки', 3000)

		closePlayerWindow(inviter, 'waiting')

		client:setData('exchange.inviter', false)
		inviter:setData('exchange.invited', false)

	end

end
addEvent('exchange.inviteResponse', true)
addEventHandler('exchange.inviteResponse', resourceRoot, sendExchangeInviteResponse)

function cancelExchange()

	local invited = client:getData('exchange.invited') or client:getData('exchange.player')
	if not isElement(invited) then return end

	local inviter = invited:getData('exchange.invited') or invited:getData('exchange.player')
	if inviter ~= client then return end

	client:setData('exchange.invited', false)
	invited:setData('exchange.inviter', false)
	client:setData('exchange.player', false)
	invited:setData('exchange.player', false)

	clearExchangeFlags(invited)
	clearExchangeFlags(client)

	closePlayerWindow(invited)

	exports.hud_notify:notify(invited, 'Обменник', 'Игрок отменил сделку', 3000)

end
addEvent('exchange.cancel', true)
addEventHandler('exchange.cancel', resourceRoot, cancelExchange)

function clearExchangeFlags(player)
	player:setData('exchange.items', nil)
	player:setData('exchange.ready1', nil)
	player:setData('exchange.ready2', nil)
	player:setData('exchange.primaryPlayer', false)
	player:setData('exchange.player', false)
	player:setData('exchange.timer', false)
end

function getExchangeMoney(player)

	local items = player:getData('exchange.items') or {}

	for _, item in pairs( items ) do
		if item.exchange_type == 'money' then
			return item.cost
		end
	end

	return 0

end

function isPlayerReady(player)
	return player:getData('exchange.ready1') and player:getData('exchange.ready2')
end

function doExchange()

	local primPlayer = client

	local secPlayer = primPlayer:getData('exchange.player')
	if not isElement(secPlayer) then return end

	local players = {primPlayer, secPlayer}

	local tax = getCurrentExchangeTax(primPlayer, secPlayer)


	for _, player in pairs( players ) do
		if not isPlayerReady(player) then
			return exports.hud_notify:notify(primPlayer, 'Ошибка', 'Участники не готовы')
		end
	end

	local exchangeItems = {
		{primPlayer, secPlayer, primPlayer:getData('exchange.items') or {}},
		{secPlayer, primPlayer, secPlayer:getData('exchange.items') or {}},
	}

	if exports.money:getPlayerMoney(primPlayer) < (tax + getExchangeMoney(primPlayer)) then
		return exports.hud_notify:notify(primPlayer, 'Ошибка', 'Нет денег для оплаты налога')
	end

	local flag, errorText = canExchangeBeCompleted(primPlayer, secPlayer)

	if not flag then
		exports.chat_main:displayInfo(primPlayer, errorText, {255,20,20})
		exports.chat_main:displayInfo(secPlayer, errorText, {255,20,20})
		return
	end

	local _exchange = {}
	for _, exchangeData in pairs( exchangeItems ) do

		_exchange[exchangeData[1].account.name] = {}

		for _, item in pairs( exchangeData[3] ) do
			if item.exchange then
				handlePropertyExchange(exchangeData[1], exchangeData[2], item)
				table.insert(_exchange[exchangeData[1].account.name], item)
			end
		end
		
		exports.vehicles_main:returnPlayerVehicles(exchangeData[1])

	end

	exports.money:takePlayerMoney(primPlayer, tax)


	-- addLastExchange({primPlayer, secPlayer}, _exchange)

	clearExchangeFlags(primPlayer)
	clearExchangeFlags(secPlayer)

	for _, player in pairs(players) do
		triggerClientEvent(player, 'exchange.closeWindow', player)
		exports.hud_notify:notify(player, 'Обменник', 'Вы совершили сделку', 3000)
	end


end
addEvent('exchange.doExchange', true)
addEventHandler('exchange.doExchange', resourceRoot, doExchange)