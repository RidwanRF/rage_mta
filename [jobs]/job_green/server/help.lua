
----------------------------------------

	function createHelpMarker(player)

		local work = playersWork[player]
		if not work then return end

		destroyHelpMarkers(player)

		local help_markers = {}

		local x,y,z = unpack( greenSpace.position )
		local marker = createMarker( x,y,z, 'corona', 3, 0, 0, 0, 0, player )

		marker:setData('controlpoint.3dtext', '[Газон]')
		marker:setData('green.help', true)

		local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )
		blip:setData('icon', 'target')

		help_markers[marker] = { marker = marker, blip = blip }

		work.help_markers = help_markers

	end

----------------------------------------

	function destroyHelpMarker(player, marker, notify)

		local work = playersWork[player]
		if not work then return end

		if work.help_markers and work.help_markers[marker] then

			clearTableElements(work.help_markers[marker])
			work.help_markers[marker] = nil

			if notify ~= false then
				exports.hud_notify:notify(player, 'Подсказка', 'Начинайте косить газон')
				exports.hud_notify:notify(player, 'Зажмите ПКМ', 'Чтобы включить лезвие')
				exports.hud_notify:notify(player, 'Зажмите '..Config.helpKey:upper(), 'Чтобы подсветились газоны')
			end
			
		end

	end

	function destroyHelpMarkers(player)

		local work = playersWork[player]
		if not work then return end

		for marker in pairs( work.help_markers or {} ) do
			destroyHelpMarker(player, marker, false)
		end

		work.help_markers = nil

	end

----------------------------------------

	addEventHandler('onMarkerHit', resourceRoot, function( player, mDim )

		if player.interior == source.interior and isElement(source) and mDim and source:getData('green.help') then

			destroyHelpMarker( player, source )

		end 

	end)

----------------------------------------