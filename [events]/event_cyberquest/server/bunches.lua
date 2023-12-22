

-----------------------------------------------------------------------------------------------

	bunches = {}

-----------------------------------------------------------------------------------------------

	function getFreeBunchPosition()

		local used = {}
		local free = {}

		for marker, bunch in pairs( bunches ) do
			used[bunch.position_id] = true
		end

		for index, position in pairs( Config.markers.bunch.positions ) do

			if not used[index] then
				table.insert(free, { position = position, index = index, })
			end

		end

		if #free == 0 then return false end

		local free_pos = free[math.random( #free )]

		return free_pos.position, free_pos.index

	end

----------------------------------------------------------------------------------------------

	function spawnBunch()

		if ( getTableLength( bunches ) >= Config.markers.bunch.spawn_limit ) then
			return false
		end

		local position, position_id = getFreeBunchPosition()
		if not position then return end

		local bunch = {
			position_id = position_id,
		}

		local x,y,z = unpack( position )
		z = z + 1


		local color_templates = {
			red = { 230, 90, 90 },
			blue = { 60, 140, 255 },
			green = { 30, 210, 20 },
			yellow = { 255, 220, 0 },
			pink = { 215, 0, 150 },
		}

		local colors = { 'red', 'blue', 'green', 'yellow', 'pink' }
		local color_id = colors[ math.random(#colors) ]

		local r,g,b = unpack( color_templates[ color_id ] )

		bunch.marker = createMarker( x,y,z, 'corona', 2, r, g, b, 150 )
		bunch.object = createObject( 1169, x,y,z )

		bunch.color_id = color_id

		bunch.marker.parent = bunch.object

		bunch.marker:setData( 'cyberquest.bunch', true )

		bunch.blip_marker = createMarker( x,y,z, 'corona', 200, 0, 0, 0, 0 )

		bunch.blip = createBlipAttachedTo( bunch.blip_marker, 0, nil, nil, nil, nil, nil, nil, nil, resourceRoot )
		bunch.blip:setData('icon', 'bunch')

		addEventHandler('onMarkerHit', bunch.blip_marker, toggleBunchBlip)
		addEventHandler('onMarkerLeave', bunch.blip_marker, toggleBunchBlip)

		bunches[ bunch.marker ] = bunch
		return bunches[ bunch.marker ]

	end

----------------------------------------------------------------------------------------------

	function toggleBunchBlip( element, mDim )

		if element.type == 'player' and isElement(source) and mDim and source.interior == element.interior then

			local blip = getAttachedElements( source )[1]
			setElementVisibleTo(blip, element, eventName == 'onMarkerHit')

		end

	end

----------------------------------------------------------------------------------------------

	function collectBunch( marker )

		if client.vehicle then return end

		local bunch = bunches[marker]
		if not bunch then return end

		if bunch.collecting then return end
		bunch.collecting = true

		displayPedAnimation( client, 'int_shop', 'shop_cashier', 2000 )

		setTimer(function( player, marker )
 
			if isElement( player ) then

				local amount = math.random( unpack( Config.markers.bunch.energy ) )
				givePlayerEnergy( player, amount )

				exports.hud_notify:notify( player, 'Сгусток', ('Вы получили %s энергии'):format( amount ) )

				local bunch = bunches[marker]
				if not bunch then return end

				addPlayerSeries( player, 'bunch_collect', bunch.color_id )
				
			end

			destroyBunch( marker )

		end, 2000, 1, client, marker)

	end
	addEvent('cyberquest.collectBunch', true)
	addEventHandler('cyberquest.collectBunch', resourceRoot, collectBunch)

-----------------------------------------------------------------------------------------------

	function breakBunch( marker )

		if (
			not client.vehicle
			or (client.vehicle.model ~= 587)
		) then return end

		local abilities = exports.vehicles_quadra:getVehicleAbilities( client.vehicle )
		if not abilities then return end

		if abilities and not (abilities.impulse and abilities.impulse.start) then return end

		local bunch = bunches[marker]
		if not bunch then return end

		local max_fuel = exports.vehicles_main:getVehicleProperty( client.vehicle, 'fuel' )
		local fuel = client.vehicle:getData('fuel') or 0

		local fuel_add = math.min( math.random( 7,10 ), max_fuel - fuel )
		increaseElementData( client.vehicle, 'fuel', fuel_add )

		local f_add = math.floor(fuel_add)
		if f_add > 0 then
			exports.hud_notify:notify( client, 'Заправка', ('+%s %s бензина'):format(
				f_add, getWordCase( f_add, 'литр', 'литра', 'литров' )
			) )
		end

		triggerClientEvent(
			getElementsByType('player'), 'cyberquest.createBunchExplosion',
			resourceRoot, getElementPosition(marker)
		)

		addPlayerSeries( client, 'bunch_break', bunch.color_id )

		destroyBunch( marker )

	end	
	addEvent('cyberquest.breakBunch', true)
	addEventHandler('cyberquest.breakBunch', resourceRoot, breakBunch)

-----------------------------------------------------------------------------------------------

	function destroyBunch( marker )

		local bunch = bunches[marker]
		if not bunch then return end

		clearTableElements( bunch )
		bunches[marker] = nil

	end

-----------------------------------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		setTimer( spawnBunch, Config.markers.bunch.spawn_frequency, 0 )

	end)

	addCommandHandler('ec_spawnbunch', function( player, cn, _amount )

		if exports.acl:isAdmin( player ) then

			local amount = tonumber( _amount ) or 1

			if amount > 1 then

				for i = 1, amount do spawnBunch() end
				exports.hud_notify:notify( player, 'CyberQuest', 'Сгустки созданы' )

			else

				if spawnBunch() then
					exports.hud_notify:notify( player, 'CyberQuest', 'Сгусток создан' )
				else
					exports.hud_notify:notify( player, 'Ошибка', 'Сгусток не создан' )
				end

			end

		end

	end)

-----------------------------------------------------------------------------------------------
