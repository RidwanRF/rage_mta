
function doRespawn(player)

	player:setData('respawn.next_timestamp', false)
	triggerClientEvent(player, 'play.respawn.close', player)

	local stars = player:getData('police.stars') or 0
	if ( stars ) > 0 then
		exports.police_main:givePrisonByStars(player)
	else
		local hospital = getNearestHospital(player)

		exports.play_main:doPlayerSpawn(player, {
			x = hospital[1],
			y = hospital[2],
			z = hospital[3],
			r = hospital[4],
			int = 0,
			dim = 0,
		})

	end

end

function buyRespawn()

	if not client:getData('respawn.next_timestamp') then return end

	local money = exports.money:getPlayerMoney(client)
	if money < Config.respawnCost then
		return exports.hud_notify:notify(client, 'Респавн', 'Недостаточно денег')
	end

	exports.money:takePlayerMoney(client, Config.respawnCost)
	doRespawn(client)

	exports.hud_notify:notify(client, 'Госпиталь', 'Ваш персонаж возрожден', 3000)

	if client.account then
		outputDebugString(string.format('[RESPAWN] %s bought respawn for %s rub',
			client.account.name, Config.respawnCost
		))
	end


end
addEvent('play.respawn.buy', true)
addEventHandler('play.respawn.buy', resourceRoot, buyRespawn)

function createPlayerTimer(player)
	local timestamp = getRealTime().timestamp
	player:setData('respawn.next_timestamp', timestamp + Config.respawnTime)
end

function updatePlayerRespawnData(player)

	local timestamp = getRealTime().timestamp
	local respawnTimestamp = player:getData('respawn.next_timestamp')

	if not respawnTimestamp or timestamp > respawnTimestamp then
		doRespawn(player)
		exports.hud_notify:notify(player, 'Госпиталь', 'Ваш персонаж возрожден', 3000)
	end

end

setTimer(function()
	for _, player in pairs( getElementsByType('player') ) do
		--if isPedDead(player) then createPlayerTimer(player) end
		if player:getData('respawn.next_timestamp') and not player:getData ( 'is_on_event' ) then
			updatePlayerRespawnData(player)
		end
	end
end, 2000, 0)

addEventHandler('onPlayerWasted', root, function()
	if source:getData ( 'is_on_event' ) then return end
	if not source:getData('respawn.suppressed') then

		if source:getData('prison.time') then
			return exports.police_prison:givePlayerPrison(source, 0)
		end


		local x,y,z = getElementPosition(source)
		setCameraMatrix(source, x, y, z+5, x,y,z)

		if not source:getData ( 'is_on_event' ) then
			createPlayerTimer(source)
		end

		increaseElementData(source, 'deaths', 1)
	end
end)