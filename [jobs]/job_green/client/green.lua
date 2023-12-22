
----------------------------------------------------------------

	local currentMarkers = {}

	function handleMarkerEvent( player, mDim )

		if player == localPlayer and mDim and source.interior == player.interior and source:getData('green.index') then

			local hit = eventName == 'onClientMarkerHit'
			currentMarkers[source] = hit

			if hit then
				createMarkerTimer( source )
			else
				removeMarkerTimer( source )
			end

		end

	end

	for _, eventName in pairs( {'onClientMarkerHit', 'onClientMarkerLeave'} ) do
		addEventHandler(eventName, resourceRoot, handleMarkerEvent)
	end

----------------------------------------------------------------

	function getCurrentGreenMarker()

		local markers = {}

		for marker in pairs( currentMarkers ) do
			if isElement(marker) then
				table.insert(markers, marker)
			else
				currentMarkers[marker] = nil
			end
		end

		table.sort(markers, function(a,b)
			return getDistanceBetween(a,localPlayer) < getDistanceBetween(b,localPlayer)
		end)

		return markers[1]

	end

----------------------------------------------------------------

	local markerTimers = {}

	function createMarkerTimer( marker )

		if
			isElementWithinMarker( localPlayer, marker ) and marker == getCurrentGreenMarker()
			and not isTimer( markerTimers[marker] ) and isBladeActive()
		then

			markerTimers[marker] = setTimer(function(marker)

				if marker == getCurrentGreenMarker() and isBladeActive() then
					handleMarkerMow( marker )
				end

			end, 200, 1, marker)

		end

	end

	function removeMarkerTimer( marker )

		if isTimer(markerTimers[marker]) then
			killTimer(markerTimers[marker])
		end

	end

----------------------------------------------------------------

	function handleMarkerMow( marker )

		local index = marker:getData('green.index')

		displayMoneyAnimation( marker )

		triggerServerEvent('green.mowObject', resourceRoot, index)

		setTimer(updateMow, 200, 1)

	end

----------------------------------------------------------------

	function updateMow()

		local marker = getCurrentGreenMarker()

		if marker then
			createMarkerTimer( marker )
		end

	end

----------------------------------------------------------------

	function green_onClick( button, state )

		if button == 'mouse2' and state == 'down' then

			updateMow()

		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'work.current' then

			local func = ( new == Config.resourceName ) and addEventHandler or removeEventHandler
			func('onClientClick', root, green_onClick)

		end

	end)

----------------------------------------------------------------