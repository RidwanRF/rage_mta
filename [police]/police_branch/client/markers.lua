
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData)

		local marker = createMarker(
			x,y,z,
			'cylinder',
			1,
			30,130,240,150
		)

		marker:setData('police.marker', true)
		marker:setData('3dtext', '[Полицейский участок]')

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'police')

		addEventHandler('onClientMarkerHit', marker, function(player, mDim)

			if player == localPlayer and mDim and player.interior == source.interior
				and not player.vehicle
			then

				openWindow('main')

			end

		end)


	end

end)