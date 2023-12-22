

function openPlayerWindow(player)
	triggerClientEvent(player, 'play.spawn_select.openWindow', resourceRoot, 'main')
end

function closePlayerWindow(player)
	triggerClientEvent(player, 'play.spawn_select.close', resourceRoot)
end

function displayError(player, text)
	exports.hud_notify:notify(player, 'Ошибка', text)
	-- triggerClientEvent(player, 'play.spawn_select.displayError', resourceRoot, text)
end

function selectSpawn( s_type )

	if s_type == 'last_exit' then

		local data = client:getData('player.save_data') or {}

		if getDistanceBetweenPoints3D(0, 0, 0, data.x, data.y, data.z) < 10 or data.int ~= 0 then
			return selectSpawn( 'spawn' )
		end

		data.int = 0
		data.dim = 0

		exports.play_main:doPlayerSpawn(client, data)
		closePlayerWindow(client)

	elseif s_type == 'home' then

		for _, house in pairs( getElementsByType('marker', getResourceRoot('main_house')) ) do

			if not house:getData('house.exit') then

				local h_data = house:getData('house.data') or {}
				if h_data.owner == client.account.name then
					
					local data = client:getData('player.save_data') or {}

					local x,y,z = getElementPosition(house)

					if h_data.flat then
						x,y,z = getElementPosition( exports.main_house:getFlatById(h_data.flat) )
					end

					data.x = x; data.y = y; data.z = z + 0.05; data.r = 0
					data.int = 0; data.dim = 0

					exports.play_main:doPlayerSpawn(client, data)	
					return closePlayerWindow(client)	

				end

			end

		end

		if not nearest_house then
			return displayError(client, 'У вас нет домов')
		end

	elseif s_type == 'mansion' then

		if client.team then

			local mansion = exports.teams_main:getClanMansion( client.team )

			local x,y,z = getElementPosition( mansion )

			local data = client:getData('player.save_data') or {}

			data.x = x; data.y = y; data.z = z + 0.05; data.r = 0
			data.int = 0; data.dim = 0

			exports.play_main:doPlayerSpawn(client, data)	

		end
		
		closePlayerWindow(client)

	elseif s_type == 'spawn' then

		local data = client:getData('player.save_data') or {}

		local coords = exports.play_main:getConfigSetting('defaultCoords')
		local x,y,z,r = unpack(coords[ math.random(#coords) ])

		data.x = x; data.y = y; data.z = z; data.r = r
		data.int = 0; data.dim = 0
		exports.play_main:doPlayerSpawn(client, data)	
		closePlayerWindow(client)

	end

end
addEvent('play.spawn_select.selectSpawn', true)
addEventHandler('play.spawn_select.selectSpawn', resourceRoot, selectSpawn)