
function transfer(position_id, side)

	if client.vehicle then return end

	local config = Config.positions[position_id]

	local cost = config.cost

	if exports.main_levels:getPlayerLevel( client ) <= Config.freeLevel then
		cost = 0
	end

	if cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	exports.money:takePlayerMoney(client, cost)

	setTimer(function(player)
		if isElement(player) then
			triggerClientEvent(player, 'transfer_system.transferDisplay', resourceRoot)
		end
	end, 100, 1, client)

	setTimer(function(player, position)
		if isElement(player) then
			
			local x,y,z = unpack(position)
			setElementPosition(player, x,y,z+1)
			triggerClientEvent(player, 'transfer_system.onTransfer', root)

		end
	end, 2000, 1, client, config[side])


	exports.logs:addLog(
		'[TRANSFER]',
		{
			data = {
				player = client.account.name,
				cost = cost,
				position_id = position_id,
				side = side,
			},	
		}
	)

end
addEvent('transfer_system.transfer', true)
addEventHandler('transfer_system.transfer', resourceRoot, transfer)