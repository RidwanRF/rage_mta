

actions = {
	sirens = function(vehicle, player)
		if not vehicle then return end
		if vehicle:getData('sirens') then

	        local sirensType = vehicle:getData('sirens')
	        if not sirensType then return end

	        if player.vehicleSeat ~= 0 then return end

	        if sirensType == 3 or sirensType == 4 then
	            local curSirenMode = vehicle:getData('curSirenMode') or 0
	            if curSirenMode == 3 then
	                curSirenMode = 0
	                vehicle:setData('sirensOn', false)
	            else
	                curSirenMode = curSirenMode + 1
	                vehicle:setData('sirensOn', true)
	            end
	            vehicle:setData('curSirenMode', curSirenMode)
	        else
	            vehicle:setData('sirensOn', not vehicle:getData('sirensOn'))
	        end

			exports.hud_notify:notify(player, 'Автомобиль',
				toggleData(vehicle, 'sirens.state')
					and 'СГУ включена'
					or 'СГУ выключена'
			)
		end
	end,
	engine = function(vehicle, player)
		if not vehicle then return end

		if (vehicle:getData('fuel') or 0) <= 0 then
			return exports.hud_notify:notify(player, 'Автомобиль', 'У вас закончилось топливо')
		end

		local prev_state = toggleData(vehicle, 'engine.disabled')

		-- if not prev_state then

		-- 	exports.main_sounds:playSound( player, 'engine' )

		-- end

		exports.hud_notify:notify(player, 'Автомобиль',
			prev_state
				and 'Двигатель выключен'
				or 'Двигатель включен'
		)
	end,
	fso = function(vehicle, player)

		if not vehicle then return end

		if (vehicle:getData('fso') or 0) > 0 then

			exports.hud_notify:notify(player, 'Автомобиль',
				toggleData(vehicle, 'fso.state')
					and 'ФСО вспышки включены'
					or 'ФСО вспышки выключены'
			)

		end

	end,
	strobo = function(vehicle, player)

		local state = vehicle:getData('vehicleLightsState') == 'strobo' and 'off' or 'strobo'
		exports.vehicles_controls:setHeadlightsState(vehicle, state)

		exports.hud_notify:notify(player, 'Автомобиль',
			state and 'Стробоскопы выключены'
			or 'Стробоскопы выключены'
		)

	end,
	first_aid_kit = function(vehicle, player)

		if isElement(vehicle) then return end

		local last_use = player:getData('first_aid_kit.last_use')

		if last_use and ( getTickCount() - last_use ) < 10000 then
			return exports.hud_notify:notify(player, 'Ограничение', 'Можно использовать раз в 8 сек.')
		end

		local section, slot = exports.main_inventory:hasInventoryItem( {
			player = player,
			item = 'first_aid_kit',
		} )

		exports.main_inventory:usePlayerItem( player, { section = section, slot = slot } )
		player:setData('first_aid_kit.last_use', getTickCount(), false)

	end,
	curtain = function(vehicle, player)
		if not vehicle then return end

		if vehicle:getData('plate_curtain') == 1 then
			exports.hud_notify:notify(player, 'Автомобиль',
				toggleData(vehicle, 'number.curtain.state')
					and 'Шторка опущена'
					or 'Шторка поднята'
			)
		end
	end,
	block = function(_vehicle, player)
		local vehicle = _vehicle or getNearestPlayerVehicle(player, 15)

		exports.hud_notify:notify(player, 'Автомобиль',
			toggleData(vehicle, 'doors.locked')
				and 'Автомобиль заблокирован'
				or 'Автомобиль разблокирован'
		)

	end,
	handbrake = function(vehicle, player)

		if not vehicle then return end

		if not isVehicleOnGround(vehicle) and not vehicle:getData('vehicle.handbrake') then
			return exports.hud_notify:notify(player, 'Ошибка', 'Автомобиль в воздухе')
		end

		if vehicle.frozen and not vehicle:getData('vehicle.handbrake') then
			return
		end

		if vehicle:getData('used.data') then
			return
		end

		if getElementSpeed( vehicle, 'kmh' ) > 0 then
			return exports.hud_notify:notify(player, 'Ошибка', 'Нужно остановиться')
		end

		exports.hud_notify:notify(player, 'Автомобиль',
			toggleData(vehicle, 'vehicle.handbrake')
				and 'Автомобиль на ручнике'
				or 'Автомобиль снят с ручника'
		)

	end,
	lights = function(vehicle, player)
		if not vehicle then return end

		local state = vehicle:getData('vehicleLightsState')
		local text = ''

		if state == 'off' then
			state = 'hwd'
			text = 'Включены габариты'
		elseif state == 'hwd' then
			state = 'head'
			text = 'Включены фары'
		else
			state = 'off'
			text = 'Фары выключены'
		end

		exports.hud_notify:notify(player, 'Автомобиль', text)


		exports.vehicles_controls:setHeadlightsState(vehicle, state)
	end,
	jetpack = function(vehicle, player)

		if vehicle then return end

		if not exports.main_weapon_zones:isPlayerInZone( player ) then
			return exports.hud_notify:notify(player, 'Ошибка', 'Недоступно в красной зоне')
		end

		if player.dimension > 0 then return end

		local flag = doesPedHaveJetPack(player)

		if not flag and exports.jobs_main:getPlayerWork( player ) then
			return exports.hud_notify:notify(player, 'Ошибка', 'Действие недоступно')
		end

		local func = flag and removePedJetPack or givePedJetPack
		func(player)

	end,
}

function toggleData(element, dataName)
	if not isElement(element) then return end
	local data = element:getData(dataName)
	element:setData(dataName, not data)
	return not data
end

function handleAction(selected)

	if not selected then return end
	actions[selected](client.vehicle, client)
	
end
addEvent('radmenu.handleAction', true)
addEventHandler('radmenu.handleAction', resourceRoot, handleAction)
