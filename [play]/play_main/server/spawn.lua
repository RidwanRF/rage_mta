

function doPlayerSpawn(player, data)
	spawnPlayer(player,
		data.x,data.y,data.z,
		data.r or 0, player.model,
		data.int, data.dim)

	player.health = data.health or 100

	setCameraTarget(player, player)
	fadeCamera(player, true)
end

function doPlayerCome(player)
	if not player:getData('player.skin') then
		player:setData('player.skin', Config.defaultSkin)
	end

	local x,y,z = unpack(Config.defaultCoords[math.random(#Config.defaultCoords)])
	spawnPlayer(player, x,y,z, 0, player.model, 0, 0)

	setCameraTarget(player, player)
	fadeCamera(player, true)
end

----------------------------------------------------------------------

	addEvent('play_main.sendReady', true)
	addEventHandler('play_main.sendReady', resourceRoot, function()

		local data = client:getData('player.save_data')

		if data then

			if data.health and data.health <= 0 then

				local timestamp = getRealTime().timestamp
				local respawnTimestamp = client:getData('respawn.next_timestamp')

				if not (respawnTimestamp and respawnTimestamp > timestamp) then
					exports.play_respawn:createPlayerTimer(client)
				end

			end

			if (client:getData('prison.time') or 0) > 0 then
				doPlayerSpawn(client, data)
			elseif (data.health and data.health > 0) then
				exports.play_spawn_select:openPlayerWindow(client)
			else
				doPlayerSpawn(client, data)
			end
			
		else
			doPlayerCome(client)
		end

	end)


----------------------------------------------------------------------


addEventHandler('onPlayerQuit', root, function()

	local x,y,z = getElementPosition(source)
	local int, dim = source.interior, source.dimension

	local saveData = {
		x = x, y = y, z = z, int = int, dim = dim, health = source.health,
	}
	source:setData('player.save_data', saveData)

end)

-- addEventHandler('onResourceStart', resourceRoot, function()

-- 	for _, player in pairs( getElementsByType('player') ) do
-- 		if player:getData('unique.login') then
-- 			doPlayerCome(player)
-- 		end
-- 	end

-- end)

addEventHandler('onPlayerJoin', root, function()
	source.dimension = 1
end)