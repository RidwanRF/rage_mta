
function givePlayerPrison(player, time)

	if not player:getData('prison.prevPos') then

		local x,y,z = getElementPosition(player)
		local _, _, r = getElementRotation(player)

		local prevPos = { pos = {x,y,z,r}, int = player.interior, dim = player.dimension }

		player:setData('prison.prevPos', prevPos)
	end

	local pos = Config.prisonPositions[math.random(#Config.prisonPositions)]

	local x,y,z = unpack(pos.pos)

	exports.play_main:doPlayerSpawn(player, {
		x = x,
		y = y,
		z = z,
		r = 0,
		int = pos.int,
		dim = pos.dim,
	})

	player.model = 62

	increaseElementData(player, 'prison.time', time)

	player:setData('radar.hidden', true)
	player:setData('weapon.slot', 0)
	player:setData('hud.hidden', true)

end

function makePlayerFree(player)
	player:setData('prison.time', false)

	local prevPos = player:getData('prison.prevPos')

	if prevPos then

		local x,y,z,r = unpack(prevPos.pos)

		setElementPosition(player, x,y,z)
		player.dimension = prevPos.dim or 0
		player.interior = prevPos.int or 0

		player:setData('prison.prevPos', false)

	end

	player:setData('prison.time', false)
	player.model = player:getData('character.skin') or 0
	exports.hud_notify:notify(player, 'Тюрьма', 'Вы освобождены из тюрьмы', 3000)

	player:setData('radar.hidden', false)
	player:setData('hud.hidden', false)

end

function updatePlayerPrison(player)
	local time = player:getData('prison.time')

	if time and time <= 0 then
		makePlayerFree(player)
	else
		increaseElementData(player, 'prison.time', -10)
	end

end

setTimer(function()
	for _, player in pairs( getElementsByType('player') ) do
		if player:getData('prison.time') then
			updatePlayerPrison(player)
		end
	end
end, 10000, 0)

addCommandHandler('giveprison', function(player, _, login, time)
	if exports.acl:isAdmin(player) then
		local account = getAccount(login)
		if account.player then
			givePlayerPrison(account.player, tonumber(time))
		end
	end
end)

addEventHandler('onPlayerLogin', root, function()
	local time = source:getData('prison.time') or 0
	if time > 0 then
		givePlayerPrison(source, 0)
	end
end, true, 'low-2')

addEventHandler('onPlayerDamage', root, function()
	if source:getData('prison.time') then
		source.health = 100
	end
end)

addEvent('prison.useTicket', true)
addEventHandler('prison.useTicket', resourceRoot, function()

	local tickets = client:getData('prison.tickets') or 0
	if tickets <= 0 then return end

	increaseElementData(client, 'prison.tickets', -1)
	makePlayerFree(client)

	exports.logs:addLog(
		'[PRISON][TICKET]',
		{
			data = {
				player = client.account.name,
			},	
		}
	)


end)