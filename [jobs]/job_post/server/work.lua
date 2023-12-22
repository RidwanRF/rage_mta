
	
----------------------------------------------------------------

	local playerSessions = {}

----------------------------------------------------------------

	function createPlayerSession(player)

		local session = playerSessions[player]
		if session then return end

		playerSessions[player] = {
			orders = {},
			iorders = {},
		}

		renewPlayerSession(player)

		player.model = Config.skin

	end

	function renewPlayerSession(_player)

		local player = _player or client

		local session = playerSessions[player]
		if not session then return end

		if getTableLength(session.orders) ~= 0 then
			return
		end

		for i = 1, Config.race_orders do
			createPlayerOrder(player)
		end

		exports.jobs_main:setPlayerSessionData(player, 'renew', false)
		exports.hud_notify:notify(player, 'Почта', 'Начните развозить посылки')

	end
	addEvent('post.renew', true)
	addEventHandler('post.renew', resourceRoot, renewPlayerSession)

----------------------------------------------------------------

	function createPlayerOrder(player)

		local session = playerSessions[player]
		if not session then return end

		local order, index 
		while (not index or session.iorders[index]) do
			order, index = getRandomValue(Config.orders)
		end

		local x,y,z = unpack(order.vehicle)

		local marker = createMarker( x,y,z, 'corona', 3, 0, 0, 0, 0, player )
		local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

		blip:setData('icon', 'target')
		marker:setData('controlpoint.3dtext', '[Доставьте почту]')
		marker:setData('post.delivery_awaiting', true)

		session.orders[marker] = {
			marker = marker,
			blip = blip,
			index = index,
		}

		session.iorders[index] = session.orders[marker]

		addEventHandler('onMarkerHit', marker, function(player, mDim)

			if not isElement(source) then return end

			if source:getData('post.delivery_awaiting') and mDim and player.interior == source.interior
				and player.vehicle and not player.vehicle:getData('post.loading')
			then

				local session = playerSessions[player]
				if not session then return end

				if not session.orders[source] then return end

				if isElement(session.current_order) and session.current_order ~= source then return end

				exports.hud_notify:notify(player, 'Почта', 'Покиньте скутер')
				session.current_order = source

			end

		end)

	end

----------------------------------------------------------------

	addEventHandler('onVehicleStartEnter', resourceRoot, function()

		if source:getData('post.loading') then
			return cancelEvent()
		end

	end)

	addEventHandler('onVehicleExit', resourceRoot, function(player, seat)

		local session = playerSessions[player]
		if not session then return end

		if not isElement(session.current_order) or getDistanceBetween(player, session.current_order) > 50 then return end

		local x,y,z = getElementPosition(source)

		session.current_order:setData('controlpoint.3dtext', '[Возьмите посылку]')
		session.current_order:setData('post.delivery_awaiting', false)

		attachElements(session.current_order, source)

		triggerClientEvent(player, 'post.createBind_takePost', resourceRoot, session.current_order)

		source:setData('post.loading', true)
		exports.hud_notify:notify(player, 'Почта', 'Возьмите посылку')

	end)

	function takePost(_player)

		local player = _player or client

		local session = playerSessions[player]
		if not session then return end

		if not isElement(session.current_order) or (getDistanceBetween(player, session.current_order) > 50) then return end

		local current_order = session.orders[session.current_order]
		clearTableElements({ current_order.marker, current_order.blip })

		local order_pos = Config.orders[current_order.index]
		local x,y,z = unpack(order_pos.deliver)

		current_order.marker = createMarker( x,y,z, 'corona', 3, 0, 0, 0, 0, player )
		current_order.blip = createBlipAttachedTo( current_order.marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

		current_order.blip:setData('icon', 'target')
		current_order.marker:setData('controlpoint.3dtext', '[Отнесите посылку]')

		local x,y,z = getElementPosition(player)

		current_order.crate = createObject(1084, x,y,z)

		current_order.crate:setData('crate.loader', player)
		player:setData('loader.crate', current_order.crate)

		exports['bone_attach']:attachElementToBone(current_order.crate, player, 12, 0.1, 0.26, -0.05, 20, -30, 90)

		exports.hud_notify:notify(player, 'Почта', 'Отнесите посылку')

		triggerClientEvent(player, 'post.createBind_deliverPost', resourceRoot, current_order.marker)

	end
	addEvent('post.takePost', true)
	addEventHandler('post.takePost', resourceRoot, takePost)

----------------------------------------------------------------

	function deliverPost(_player)


		local player = _player or client

		local session = playerSessions[player]
		if not session then return end

		if not session.orders[ session.current_order ] then return end

		completePlayerOrder(player, session.current_order)

		exports.jobs_main:addPlayerStats(player, 'post_delivered', 1)
		exports.jobs_main:addPlayerSessionMoney(player, math.random(unpack(Config.money)))

		local vehicle = exports.jobs_main:getPlayerSessionData(player, 'vehicle')
		vehicle:setData('post.loading', false)

	end
	addEvent('post.deliverPost', true)
	addEventHandler('post.deliverPost', resourceRoot, deliverPost)	

----------------------------------------------------------------

	function completePlayerOrder(player, marker)

		local session = playerSessions[player]
		if not session then return end

		destroyPlayerOrder(player, marker)

		if getTableLength(session.orders) == 0 then

			exports.jobs_main:setPlayerSessionData(player, 'renew', true)

			local station = exports.jobs_main:getPlayerSessionData(player, 'station')
			local x,y,z = unpack( Config.stations[station].marker )

			local marker = createMarker( x,y,z, 'corona', 5, 0, 0, 0, 0, player )
			local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

			blip:setData('icon', 'target')
			marker:setData('controlpoint.3dtext', '[Вернитесь в офис]')

			session.renew = {
				blip = blip,
				marker = marker,
			}

			addEventHandler('onMarkerHit', marker, function(player, mDim)

				local session = playerSessions[player]
				if not session then return end

				if not (session.renew and session.renew.marker == source) then return end

				clearTableElements(session.renew)

			end)

			exports.hud_notify:notify(player, 'Заказы выполнены', 'Вернитесь, чтобы взять новые')

		else

			exports.hud_notify:notify(player, 'Заказ выполнен', 'Продолжайте работу')

		end

	end

	function destroyPlayerOrder(player, marker)

		local session = playerSessions[player]
		if not session then return end

		local order = session.orders[marker]

		clearTableElements(order)

		if order and order.index then
			session.iorders[order.index] = nil
		end

		session.orders[marker] = nil

	end

----------------------------------------------------------------

	function destroyPlayerSession(player)

		player.model = player:getData('character.skin') or 0

		local session = playerSessions[player]
		if not session then return end

		clearTableElements(session)
		playerSessions[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerSession(source)
		end

	end)

----------------------------------------------------------------