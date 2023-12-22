
	
----------------------------------------------------------------

	playersWork = {}

---------------------------------------------------------------

	function setPlayerAxeState(player, state)
		
		player:setData('weapon.slot', 0)

		local inventoryConfig = exports.main_inventory:getConfigSetting('items')

		if state then
			exports.main_inventory:setPlayerCustomObject(player, inventoryConfig.job_lumberjack_axe)
		else
			exports.main_inventory:removePlayerCustomObject(player)
		end

	end

----------------------------------------------------------------

	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		playersWork[player] = {
		}

		createTreeMarker(player)

	end

----------------------------------------------------------------

	function getFreeTreePosition( player )

		local px,py,pz = getElementPosition( player )

		local free = {}
		local used = {}

		for _, work in pairs( playersWork ) do

			if work.tree then
				used[ work.tree.pos_index ] = true
			end

		end

		for index, position in pairs( Config.positions ) do

			if not used[index] then
				table.insert( free, index )
			end

		end

		if #free == 0 then return false end

		local rand_index = math.random( #free )
		local pos_index = free[ rand_index ]

		return pos_index, unpack( Config.positions[pos_index] )

	end

----------------------------------------------------------------

	function createTreeMarker( player )

		local work = playersWork[player]
		if not work then return end

		local index, x,y,z,fr,rz = getFreeTreePosition( player )

		if not index then

			exports.hud_notify:notify(player, 'На карте нет деревьев', 'Идет поиск...')
			work.tree_timer = setTimer( createTreeMarker, 10000, 1, player )
			return

		end

		work.tree = {
			pos_index = index
		}

		triggerClientEvent(player, 'lubmerjack.initializeTreeMarker', resourceRoot, {
			coords = {x,y,z,rz,fr},
			vehicle = exports.jobs_main:getPlayerSessionData( player, 'vehicle' )
		})

		exports.hud_notify:notify(player, 'На карте новое дерево', 'Направляйтесь к нему')

	end

----------------------------------------------------------------

	function completeTreeMarker( _player )

		local player = _player or client

		local work = playersWork[player]
		if not work then return end

		if not work.tree then return end

		clearTableElements( work.tree )
		work.tree = nil

		setPlayerAxeState( player, true )

		createDestination( player )
		exports.hud_notify:notify(player, 'Вы погрузили дерево', 'Везите его на переработку')

	end
	addEvent('lubmerjack.completeMarker', true)
	addEventHandler('lubmerjack.completeMarker', resourceRoot, completeTreeMarker)

----------------------------------------------------------------

	function createDestination( player )

		local work = playersWork[player]
		if not work then return end

		work.destination = {}

		local x,y,z = unpack( Config.destination )

		work.destination.marker = createMarker( x,y,z, 'corona', 4, 90, 255, 90, 0, player )
		work.destination.marker:setData('controlpoint.3dtext', '[Отвезите бревна]')

		work.destination.blip = createBlipAttachedTo( work.destination.marker, 0, nil, nil, nil, nil, nil, nil, nil, player )
		work.destination.blip:setData('icon', 'target')

		addEventHandler('onMarkerHit', work.destination.marker, function( player, mDim )

			if not isElement( source ) then return end

			if playersWork[player] and playersWork[player].destination
				and playersWork[player].destination.marker == source and mDim
				and exports.jobs_main:getPlayerSessionData( player, 'vehicle' ) == player.vehicle
				and player.interior == source.interior
			then

				local work = playersWork[player]
				if not work then return end

				clearTableElements( work.destination )
				work.destination = nil

				clearTableElements( work.vehicle_logs or {} )
				work.vehicle_logs = nil

				exports.jobs_main:addPlayerStats(player, 'routes_passed', 1)
				exports.jobs_main:addPlayerSessionMoney(player, Config.money)

				createTreeMarker( player )

			end

		end)

	end

----------------------------------------------------------------

	function destroyPlayerWork(player)

		local work = playersWork[player]
		
		if work then
			clearTableElements(work)
		end

		player.model = player:getData('character.skin') or 0

		playersWork[player] = nil

		setPlayerAxeState( player, false )
		setPlayerControlStates( player, true )

	end

----------------------------------------------------------------
	
	addEventHandler('onVehicleExit', resourceRoot, function( player )

		if playersWork[ player ] then
			setPlayerAxeState( player, true )
		end

	end)

	addEventHandler('onVehicleEnter', resourceRoot, function( player )

		if playersWork[ player ] then
			setPlayerAxeState( player, false )
		end

	end)

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerWork(source)
		end

	end)

----------------------------------------------------------------
