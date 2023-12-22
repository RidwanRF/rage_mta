

------------------------------------------------

	sessions = {}

------------------------------------------------

	function getOrderPosition( player )

		local x,y,z = getElementPosition(player)
		local possible = {}

		for _, order in pairs( Config.orders ) do

			local ox,oy,oz = unpack(order)

			if getDistanceBetweenPoints3D( x,y,z, ox,oy,oz ) > Config.work.min_dist then
				table.insert( possible, { ox,oy,oz } )
			end

		end

		if #possible == 0 then return false end
		return unpack( possible[math.random(#possible)] )

	end

------------------------------------------------

	function createPlayerMarker( player )

		local session = sessions[player]
		if not session then return end

		local x,y,z = getOrderPosition( player )

		session.marker = createMarker( x,y,z, 'cylinder', 4, 50, 200, 50, 150, resourceRoot )
		session.blip = createBlipAttachedTo( session.marker, 0, 2, 255, 0, 0, 255, 0, 99999, resourceRoot)

		setElementVisibleTo(session.marker, player, true)
		setElementVisibleTo(session.blip, player, true)

		session.blip:setData('icon', 'target')
		session.marker:setData('controlpoint.3dtext', '[Соберите деньги]')

		addEventHandler('onMarkerHit', session.marker, function( player, mDim )

			if not isElement(source) then return end

			local session = sessions[player]
			if not session then return end

			if mDim and player.interior == source.interior
				and player.vehicle == exports.jobs_main:getPlayerSessionData(player, 'vehicle')
				and source == session.marker
			then

				local sum = ( math.random( unpack( Config.work.checkpoint ) ) * Config.work.mul )

				session.money = math.clamp(
					session.money + sum,
					0, session.plan
				)

				clearTableElements( session )

				if session.money >= session.plan then
					createSessionDestination( player )
				else
					exports['hud_notify']:notify(player, 'Инкассатор', 'Продолжайте сбор денег')
					createPlayerMarker( player )
				end

			end


		end)

	end

------------------------------------------------

	function createPlayerSession( player, pos_id )

		if sessions[player] then return end

		sessions[player] = {
			plan = math.random( unpack( Config.work.plan ) ) * Config.work.mul,
			money = 0,
			pos_id = pos_id,
		}

		createPlayerMarker( player )

	end

------------------------------------------------

	function destroyPlayerSession( player )

		local session = sessions[player]
		if not session then return end

		clearTableElements( session )
		sessions[player] = nil

	end

------------------------------------------------

	function createSessionDestination( player )

		local session = sessions[player]
		if not session then return end

		local x,y,z = unpack( Config.positions[ session.pos_id ].destination )

		session.destination = createMarker( x,y,z, 'cylinder', 4, 255, 220, 0, 150, resourceRoot )
		session.destination_blip = createBlipAttachedTo( session.destination, 0, 2, 255, 0, 0, 255, 0, 99999, resourceRoot )

		setElementVisibleTo(session.destination, player, true)
		setElementVisibleTo(session.destination_blip, player, true)

		session.destination:setData('controlpoint.3dtext', '[Завершите задание]')
		session.destination_blip:setData('icon', 'target')

		exports['hud_notify']:notify(player, 'Инкассатор', 'Возвращайтесь в офис')

		addEventHandler('onMarkerHit', session.destination, function( player, mDim )

			if not isElement(source) then return end

			local session = sessions[player]
			if not session then return end

			if mDim and player.interior == source.interior
				and player.vehicle == exports.jobs_main:getPlayerSessionData(player, 'vehicle')
				and source == session.destination
			then

				clearTableElements( session )
				completePlayerSession( player )

			end

		end)

	end


------------------------------------------------

	function completePlayerSession( player )

		local session = sessions[player]
		if not session then return end

		local pos_id = session.pos_id

		local money = math.random( unpack( Config.money ) )
		local level, nextLevel, xpProgress, data = getPlayerLevel( player )

		money = money + math.floor(money * data.add / 100)

		increaseElementData( player, 'incassator.xp', 1 )
		exports.jobs_main:addPlayerSessionMoney(player, money)

		exports['hud_notify']:notify(player, 'Продолжайте сбор денег', 'Либо завершите работу')

		destroyPlayerSession(player)
		createPlayerSession(player, pos_id)

	end

------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerSession(source)
		end

	end)

------------------------------------------------