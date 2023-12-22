

-------------------------------------------------------

	flowers = {}

-------------------------------------------------------

	function getFreeFlowerPosition()

		local used = {}
		local free = {}

		for marker, flower in pairs( flowers ) do
			used[flower.position_id] = true
		end

		for index, position in pairs( Config.positions ) do

			if not used[index] then
				table.insert(free, { position = position, index = index, })
			end

		end

		if #free == 0 then return false end

		local free_pos = free[math.random( #free )]

		return free_pos.position, free_pos.index

	end

-------------------------------------------------------

	function createFlower()

		local position, position_id = getFreeFlowerPosition()
		if not position then return end

		local flowerType = Config.flowerTypes[math.random( #Config.flowerTypes )]

		local flower = {
			position_id = position_id,
			type = flowerType.type,
		}

		local x,y,z = unpack( position )
		z = z + 0.2

		flower.marker = createMarker( x,y,z, 'corona', 2, 0, 0, 0, 0 )
		flower.object = createObject( flowerType.model, x,y,z, 0, 0, 0 )

		flower.blip_marker = createMarker( x,y,z, 'corona', 200, 0, 0, 0, 0 )

		flower.blip = createBlipAttachedTo( flower.blip_marker, 0, nil, nil, nil, nil, nil, nil, nil, resourceRoot )
		flower.blip:setData('icon', 'flower')

		-- flower.kill_timer = setTimer(destroyFlower, Config.flowerLifetime, 1, flower.marker)

		flowers[ flower.marker ] = flower

		addEventHandler('onMarkerHit', flower.blip_marker, toggleMarkerBlip)
		addEventHandler('onMarkerLeave', flower.blip_marker, toggleMarkerBlip)

		addEventHandler('onMarkerHit', flower.marker, function( element, mDim )

			if not isElement(source) then return end

			if element.type == 'player' and mDim and source.interior == element.interior then
				collectFlower( element, source )
			end

		end)

	end

	addCommandHandler('ef_createflower', function( player )

		if exports.acl:isAdmin( player ) then
			createFlower()
		end

	end)

-------------------------------------------------------

	function toggleMarkerBlip( element, mDim )

		if element.type == 'player' and isElement(source) and mDim and source.interior == element.interior then

			local blip = getAttachedElements( source )[1]
			setElementVisibleTo(blip, element, eventName == 'onMarkerHit')

		end

	end

-------------------------------------------------------

	function collectFlower( player, marker )

		local flower = flowers[marker]
		if not flower then return end

		if not handleFlowerCollect( player, flower.type ) then
			return false
		end

		exports.hud_notify:notify(player, 'Весенний движ', 'Вы подобрали цветок')

		destroyFlower( marker )

		exports.logs:addLog(
			'[FLOWER][COLLECT]',
			{
				data = {
					player = player.account.name,
					flower = flower.type,
				},	
			}
		)

	end

-------------------------------------------------------

	function destroyFlower( marker )

		local flower = flowers[marker]
		if not flower then return end

		triggerClientEvent(root, 'flower.displayDestroyEffect', resourceRoot, flower.object)

		setTimer(function(object)


			if isElement(object) then
				destroyElement(object)
			end

		end, 3000, 1, flower.object)
		flower.object = nil

		clearTableElements( flower )

		flowers[marker] = nil

	end

-------------------------------------------------------

	setTimer(function()

		if getTableLength( flowers ) < Config.spawnLimit then
			createFlower()
		end

	end, Config.spawnFrequency, 0)

-------------------------------------------------------
