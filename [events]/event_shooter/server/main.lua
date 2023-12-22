

------------------------------------------------------------------

	local matches_queue = {}
	local matches_limit = 20

------------------------------------------------------------------

	local markers = {}
	local marker_players = {}

------------------------------------------------------------------

	local matchQueue_id = 0

	function generateMatchQueueId()

		matchQueue_id = matchQueue_id + 1
		return matchQueue_id

	end

------------------------------------------------------------------
	
	function checkPlayerWeapon( player )

		local inventory = exports.main_inventory:getConfigSetting('items')

		for item_id, item in pairs( inventory ) do

			if item.type == 'weapon' then

				if exports.main_inventory:hasInventoryItem( { player = player, item = item_id } ) then
					return true
				end

			end

		end

		return false

	end

------------------------------------------------------------------

	function createMatchQueue( match_type, map_id, bet )

		if getTableLength( matches_queue ) >= matches_limit then
			return exports.hud_notify:notify( client, 'Нельзя создать матч', 'Выберите любой из списка' )
		end

		if exports.money:getPlayerMoney( client ) < bet then
			return exports.hud_notify:notify( client, 'Недостаточно денег', 'Чтобы оплатить взнос' )
		end

		if not checkPlayerWeapon( client ) then
			return exports.hud_notify:notify( client, 'У вас нет оружия', 'Купите в магазине оружия' )
		end

		local match_id = generateMatchQueueId()

		local match = {}

		match.id = match_id
		match.map_id = map_id

		match.type = match_type
		match.bet = bet

		match.players = {}
		match.creator = client.account.name
		match.created = getRealTime().timestamp

		match.finish_timer = setTimer(function( match_id )

			local match_queue = matches_queue[ match_id ]
			if not match_queue then return end

			for player in pairs( match_queue.players or {} ) do
				exports.hud_notify:notify(player, 'Время вышло', 'Матч отменен')
			end

			destroyMatchQueue( match_id )

		end, Config.match_queue_time * 1000, 1, match_id)

		matches_queue[ match_id ] = match

		joinMatchQueue( match_id )

	end
	addEvent('event_shooter.createMatchQueue', true)
	addEventHandler('event_shooter.createMatchQueue', resourceRoot, createMatchQueue)

------------------------------------------------------------------

	function joinMatchQueue( match_id )

		if not checkPlayerWeapon( client ) then
			return exports.hud_notify:notify( client, 'У вас нет оружия', 'Купите в магазине оружия' )
		end

		local match_queue = matches_queue[ match_id ]
		if not match_queue then return end

		if match_queue.players[ client ] then return end

		if exports.money:getPlayerMoney( client ) < match_queue.bet then
			return exports.hud_notify:notify( client, 'Недостаточно денег', 'Чтобы оплатить взнос' )
		end
		
		local match_type_config = Config.match_types[ match_queue.type ]

		if getTableLength( match_queue.players ) >= match_type_config.players then
			return exports.hud_notify:notify( client, 'Матч собран', 'Нет свободного места' )
		end

		match_queue.players[ client ] = true
		
		openPlayerWindow( client, 'match_queue', match_queue )
		triggerClientEvent( client, 'event_shooter.receiveMatchQueue', resourceRoot, matches_queue[ match_id ]  )

		if getTableLength( match_queue.players ) >= match_type_config.players then

			processMatchQueue( match_id )

		else

			forceMatchUpdate( match_id )

		end


	end
	addEvent('event_shooter.joinMatchQueue', true)
	addEventHandler('event_shooter.joinMatchQueue', resourceRoot, joinMatchQueue)

------------------------------------------------------------------

	function leaveMatchQueue( match_id_or_player )

		local player, match_id

		if isElement(match_id_or_player) then

			player = match_id_or_player

			for id, match_queue in pairs( matches_queue ) do

				if match_queue.players[ player ] then
					match_id = id
					break
				end

			end

			if not match_id then return end

		else

			player = client
			match_id = match_id_or_player

		end

		local match_queue = matches_queue[ match_id ]
		if not match_queue then return end

		match_queue.players[ player ] = nil

		if getTableLength( match_queue.players ) <= 0 then
			destroyMatchQueue( match_id )
		else
			forceMatchUpdate( match_id )
		end

		exports.hud_notify:notify( player, 'Матч', 'Вы покинули матч' )

	end
	addEvent('event_shooter.leaveMatchQueue', true)
	addEventHandler('event_shooter.leaveMatchQueue', resourceRoot, leaveMatchQueue)

------------------------------------------------------------------

	function destroyMatchQueue( match_id, close )

		local match_queue = matches_queue[ match_id ]

		if match_queue then

			for player in pairs( match_queue.players ) do

				if close then
					closePlayerWindow( player )
				else
					openPlayerWindow( player, 'main', matches_queue )
				end

			end

		end

		clearTableElements( matches_queue[ match_id ] or {} )
		matches_queue[ match_id ] = nil

		forceMatchUpdate( match_id )

	end

------------------------------------------------------------------
	
	function processMatchQueue( match_id )

		local match_queue = matches_queue[ match_id ]
		if not match_queue then return end

		for player in pairs( match_queue.players ) do

			marker_players[ player ] = nil
			closePlayerWindow( player )

		end

		local r_players, bet = {}, 0

		for player in pairs( match_queue.players ) do

			exports.money:takePlayerMoney( player, match_queue.bet )
			bet = bet + match_queue.bet

			table.insert( r_players, player )

		end

		r_players = randomSort( r_players )

		local matchModes = {
			team = TeamMatch,
			mincer = MincerMatch,
		}

		local match_type_config = Config.match_types[ match_queue.type ]
		local s_match = matchModes[ match_type_config.type ]

		local match = s_match( {

			dimension = 30000 + match_queue.id,
			type = match_type_config.type,
			map_id = match_queue.map_id,

			bet = math.floor( bet * ( 100 - Config.comission ) / 100 ),

			callback = finishMatch,

		} )

		if match_type_config.type == 'team' then

			local players = {}

			local team_1_count = math.floor( #r_players/2 )
			local team_2_count = #r_players - team_1_count

			for index = 1, team_1_count do
				table.insert( players, { player = r_players[index], team = 'team_1' } )
			end

			for index = team_1_count + 1, team_1_count + team_2_count do
				table.insert( players, { player = r_players[index], team = 'team_2' } )
			end

			for _, player_data in pairs( players ) do

				if isElement(player_data.player) then
					match:addPlayer( player_data.player, player_data.team )
				end

			end

		elseif match_type_config.type == 'mincer' then

			for _, player in pairs( r_players ) do

				if isElement(player) then
					match:addPlayer( player )
				end

			end

		end

		match:start()

		local l_players = {}

		for _, player in pairs( r_players ) do
			table.insert( l_players, player.account.name )
		end

		exports.logs:addLog(
			'[SHOOTER][START]',
			{
				data = {

					players = l_players,
					bet = match_queue.bet,

				},	
			}
		)

		destroyMatchQueue( match_id, true )

	end

	function finishMatch( match, winner )

		local l_players = {}

		if match.type == 'team' then

			if winner then

				local win_sum = math.floor( match.bet / getTableLength( match.players[ winner ] ) )

				for player in pairs( match.players[ winner ] ) do
					l_players[ player.account.name ] = { win = win_sum }
				end

			else

				local win_sum = math.floor(
					match.bet / (

						getTableLength( match.players.team_1 ) +
						getTableLength( match.players.team_2 )

					)
				)

				for team_name, team in pairs( match.players ) do

					for player in pairs( team ) do
						l_players[ player.account.name ] = { win = win_sum }
					end

				end

			end


		elseif match.type == 'mincer' then
			
			local win_coefs

			if #winner == 3 then
				win_coefs = { 60, 30, 10 }
			elseif #winner == 2 then
				win_coefs = { 65, 35 }
			else
				win_coefs = { 100 }
			end

			local t_players = {}

			for index, player_data in pairs( winner ) do

				local win_sum = math.floor( match.bet * ( win_coefs[index] ) / 100 )
				l_players[ player_data.player.account.name ] = { win = win_sum }

			end

		end

		for player_login, data in pairs( l_players ) do

			local account = getAccount( player_login )

			if account.player then
				exports.money:givePlayerMoney( account.player, data.win )
				exports.hud_notify:notify( account.player, 'Вы победили', ('Награда - $%s'):format( splitWithPoints( data.win, '.' ) ) )
			end


		end

		exports.logs:addLog(
			'[SHOOTER][WIN]',
			{
				data = {

					players = l_players,

				},	
			}
		)

	end

	addCommandHandler('process_match', function( player, _, match_id )
		processMatchQueue( tonumber(match_id) )
	end)

------------------------------------------------------------------

	function sendMatchQueueList( _player )

		local player = _player or client
		triggerClientEvent( player, 'event_shooter.receiveMatchQueueList', resourceRoot, matches_queue )

	end
	addEvent('event_shooter.sendMatchQueueList', true)
	addEventHandler('event_shooter.sendMatchQueueList', resourceRoot, sendMatchQueueList)

------------------------------------------------------------------

	function forceMatchUpdate( match_id )

		for player, marker in pairs( marker_players ) do

			if isElement(player) and isElementWithinMarker( player, marker ) then
				triggerClientEvent( player, 'event_shooter.forceMatchUpdate', resourceRoot, match_id, matches_queue[ match_id ]  )
			end

		end

	end

------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, position in pairs( Config.markers ) do

			local x,y,z = unpack( position )

			local marker = createMarker( x,y,z, 'cylinder', 3, 255, 0, 0, 150 )
			local blip = createBlipAttachedTo(marker, 0)

			marker:setData('3dtext', '[DeathMatch War]')
			marker:setData('3dtext.size', 2)
			marker:setData('3dtext.zAdd', 2)

			blip:setData('icon', 'event_shooter')

			markers[marker] = {
				marker = marker, blip = blip
			}

			addEventHandler('onMarkerHit', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					openPlayerWindow( player, 'main', matches_queue )
					marker_players[ player ] = source

				end

			end)

			addEventHandler('onMarkerLeave', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					closePlayerWindow( player )
					marker_players[ player ] = nil

					leaveMatchQueue( player )

				end

			end)

		end

	end)

------------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()
		leaveMatchQueue( source )
	end)

	addEventHandler('onPlayerWasted', root, function()
		leaveMatchQueue( source )
	end)

------------------------------------------------------------------