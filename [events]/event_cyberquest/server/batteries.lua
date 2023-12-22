

-----------------------------------------------------------------------------------------------

	batteries = {}

-----------------------------------------------------------------------------------------------

	function getFreeBatteryPosition()

		local used = {}
		local free = {}

		for marker, battery in pairs( batteries ) do
			used[battery.position_id] = true
		end

		for index, position in pairs( Config.markers.battery.positions ) do

			if not used[index] then
				table.insert(free, { position = position, index = index, })
			end

		end

		if #free == 0 then return false end

		local free_pos = free[math.random( #free )]

		return free_pos.position, free_pos.index

	end

----------------------------------------------------------------------------------------------

	function spawnBattery()

		if ( getTableLength( batteries ) >= Config.markers.battery.spawn_limit ) then
			return false
		end

		local position, position_id = getFreeBatteryPosition()
		if not position then return end

		local battery = {
			position_id = position_id,
		}

		local x,y,z = unpack( position )
		z = z + 0.95

		battery.marker = createMarker( x,y,z, 'corona', 3, 0, 0, 0, 0 )
		battery.object = createObject( 1168, x,y,z-0.3, 0, 0, math.random(0,180) )

		battery.blip_marker = createMarker( x,y,z, 'corona', 150, 0, 0, 0, 0 )

		battery.blip = createBlipAttachedTo( battery.blip_marker, 0, nil, nil, nil, nil, nil, nil, nil, resourceRoot )
		battery.blip:setData('icon', 'battery')

		addEventHandler('onMarkerHit', battery.blip_marker, toggleBatteryBlip)
		addEventHandler('onMarkerLeave', battery.blip_marker, toggleBatteryBlip)

		addEventHandler('onMarkerHit', battery.marker, function( player, mDim )

			if isElement(source) and mDim and player.interior == source.interior then

				if player.vehicle then
					return exports.hud_notify:notify( player, 'Захват', 'Покиньте автомобиль' )
				else
					startBatteryCollect( source, player )
				end

			end

		end)

		addEventHandler('onMarkerLeave', battery.marker, function( player, mDim )

			if isElement(source) and mDim and player.interior == source.interior then

				finishBatteryCollect( source, player )

			end

		end)

		batteries[ battery.marker ] = battery
		return batteries[ battery.marker ]

	end

----------------------------------------------------------------------------------------------

	function toggleBatteryBlip( element, mDim )

		if element.type == 'player' and isElement(source) and mDim and source.interior == element.interior then

			local blip = getAttachedElements( source )[1]
			setElementVisibleTo(blip, element, eventName == 'onMarkerHit')

		end

	end

----------------------------------------------------------------------------------------------

	function startBatteryCollect( marker, player )

		local battery = batteries[marker]
		if not battery then return end

		if exports.jobs_main:getPlayerWork( player ) then
			return
		end

		battery.collect_timers = battery.collect_timers or {}

		clearTableElements( battery.collect_timers[player] or {} )

		local timestamp = getRealTime().timestamp

		battery.collect_timers[player] = {

			timer = setTimer(function( marker, player )

				if isElement(player) and isElement(marker) then
					collectBattery( marker, player )
				end

			end, Config.markers.battery.collect_timeout, 1, marker, player),

			started = timestamp,

		}

		triggerClientEvent( player, 'cyberquest.syncBatteryCollect', resourceRoot, timestamp )

	end

----------------------------------------------------------------------------------------------

	function finishBatteryCollect( marker, _player )

		local player = isElement(_player) and _player or source
		if not isElement(player) then return end

		if not marker then

			for b_marker, b_data in pairs( batteries ) do

				if b_data.collect_timers and b_data.collect_timers[player] then

					marker = b_marker
					break

				end

			end

		end

		local battery = batteries[marker]
		if not battery then return end

		battery.collect_timers = battery.collect_timers or {}

		clearTableElements( battery.collect_timers[player] or {} )
		battery.collect_timers[player] = nil

		triggerClientEvent( player, 'cyberquest.syncBatteryCollect', resourceRoot )

	end

----------------------------------------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, finishBatteryCollect)
	addEventHandler('onPlayerWasted', root, function() finishBatteryCollect( nil, source ) end)
	addEventHandler('onPlayerCamhack', root, finishBatteryCollect)

----------------------------------------------------------------------------------------------

	function collectBattery( marker, player )

		if not isElement( player ) then return end

		local battery = batteries[marker]
		if not battery then return end

		for c_player in pairs( battery.collect_timers or {} ) do
			finishBatteryCollect( marker, c_player )
		end

		local amount = math.random( unpack( Config.markers.battery.energy ) )
		givePlayerEnergy( player, amount )

		exports.hud_notify:notify( player, 'Аккумулятор', ('Вы получили %s энергии'):format( amount ) )

		destroyBattery( marker )

	end

-----------------------------------------------------------------------------------------------

	function destroyBattery( marker )

		local battery = batteries[marker]
		if not battery then return end

		clearTableElements( battery )
		batteries[marker] = nil

	end

-----------------------------------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		setTimer( spawnBattery, Config.markers.battery.spawn_frequency, 0 )

	end)

	addCommandHandler('ec_spawnbattery', function( player, cn )

		if exports.acl:isAdmin( player ) then

			if spawnBattery() then
				exports.hud_notify:notify( player, 'CyberQuest', 'Батарея создана' )
			else
				exports.hud_notify:notify( player, 'Ошибка', 'Батарея не создана' )
			end

		end

	end)

-----------------------------------------------------------------------------------------------
