
	
----------------------------------------------------------------

	local playersWork = {}

----------------------------------------------------------------

	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		playersWork[player] = {
			completed = 0,
		}

		createRubbishMarker(player)

	end

----------------------------------------------------------------

	function getFreeRubbishPosition( player )

		local px,py,pz = getElementPosition( player )

		local free = {}
		local used = {}

		-- for _, work in pairs( playersWork ) do

		-- 	if work.rubbish then
		-- 		used[ work.rubbish.pos_index ] = true
		-- 	end

		-- end

		for index, position in pairs( Config.positions ) do

			if not used[index] then

				local x,y,z = unpack( position )
				local dist = getDistanceBetweenPoints3D( x,y,z, px,py,pz )

				if isBetween( dist, 40, 500 ) then
					table.insert( free, index )
				end

			end

		end

		if #free == 0 then return false end

		local rand_index = math.random( #free )
		local pos_index = free[ rand_index ]

		return pos_index, unpack( Config.positions[pos_index] )

	end

----------------------------------------------------------------

	function createRubbishMarker( player )

		local work = playersWork[player]
		if not work then return end

		local index, x,y,z,rz = getFreeRubbishPosition( player )

		if not index then

			exports.hud_notify:notify(player, 'На карте нет мусора', 'Идет поиск...')
			work.rubbish_timer = setTimer( createRubbishMarker, 10000, 1, player )
			return

		end

		work.rubbish = {
			pos_index = index
		}

		work.rubbish.marker = createMarker( x,y,z+1, 'corona', 2, 0, 0, 0, 0, player )
		work.rubbish.marker:setData('controlpoint.3dtext', '[Соберите мусор]')

		work.rubbish.help_marker = createMarker( x,y,z, 'corona', 10, 0, 0, 0, 0, player )

		work.rubbish.blip = createBlipAttachedTo( work.rubbish.marker, 0, nil, nil, nil, nil, nil, nil, nil, player )
		work.rubbish.blip:setData('icon', 'target')

		triggerClientEvent(player, 'rubbisher.initializeRubbishMarker', resourceRoot, {

			coords = {x,y,z,rz},

			marker = work.rubbish.marker,
			help_marker = work.rubbish.help_marker,

		}, exports.jobs_main:getPlayerSessionData( player, 'vehicle' ))

		addEventHandler('onMarkerHit', work.rubbish.help_marker, function( player, mDim )

			if not isElement( source ) then return end

			if playersWork[player] and playersWork[player].rubbish
				and playersWork[player].rubbish.help_marker == source and mDim
				and exports.jobs_main:getPlayerSessionData( player, 'vehicle' ) == player.vehicle
				and player.interior == source.interior
			then
				exports.hud_notify:notify(player, 'Захватите мусорный бак', 'С помощью манипулятора', 10000)
				exports.hud_notify:notify(player, 'Подсказка', 'Наведитесь на магнит', 10000)
			end

		end)

		exports.hud_notify:notify(player, 'На карте новая метка', 'Направляйтесь к ней')

	end

----------------------------------------------------------------

	function completeRubbishMarker( player )

		local work = playersWork[player]
		if not work then return end

		if not work.rubbish then return end

		if isElement(work.rubbish.marker) and getDistanceBetween( work.rubbish.marker, player ) > 50 then
			return
		end

		work.completed = (work.completed or 0) + 1

		clearTableElements( work.rubbish )
		work.rubbish = nil

		if work.completed >= Config.rubbishLoad then

			createDestination( player )
			exports.hud_notify:notify(player, 'Вы собрали мусор', 'Везите его на переработку')

		else

			createRubbishMarker( player )

		end

		exports.jobs_main:addPlayerSessionMoney(player, Config.rubbishRaceMoney)

	end
	addEvent('rubbisher.completeMarker', true)
	addEventHandler('rubbisher.completeMarker', resourceRoot, completeRubbishMarker)

----------------------------------------------------------------

	function createDestination( player )

		local work = playersWork[player]
		if not work then return end

		work.destination = {}

		local x,y,z = unpack( Config.destination[ math.random(#Config.destination) ] )

		work.destination.marker = createMarker( x,y,z, 'corona', 4, 90, 255, 90, 0, player )
		work.destination.marker:setData('controlpoint.3dtext', '[Отвезите мусор]')

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
				work.completed = 0

				exports.jobs_main:addPlayerStats(player, 'routes_passed', 1)

				createRubbishMarker( player )

			end

		end)

	end

----------------------------------------------------------------

	function destroyPlayerWork(player)

		local work = playersWork[player]
		if not work then return end

		player.model = player:getData('character.skin') or 0

		clearTableElements(work)
		playersWork[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerWork(source)
		end

	end)

----------------------------------------------------------------