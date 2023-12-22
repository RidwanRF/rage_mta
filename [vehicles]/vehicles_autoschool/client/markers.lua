
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData)
		local marker = createMarker(
			x,y,z,
			'cylinder',
			markerData.size or 1.5,
			50, 50, 255, 150
		)

		marker:setData('3dtext', '[Автошкола]')
		marker:setData('3dtext.size', 1.5)

		marker.interior = markerData.int or 0
		marker.dimension = markerData.dim or 0

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'autoschool')

		marker:setData('autoschool.marker', true)

		addEventHandler('onClientMarkerHit', marker, function(player, mDim)

			if mDim and player == localPlayer and player.interior == source.interior then
				openWindow('main')
			end

		end)

		addEventHandler('onClientMarkerLeave', marker, function(player, mDim)

			if player == localPlayer and mDim and player.interior == source.interior and windowOpened then
				closeWindow()
			end

		end)

	end

end)

addEventHandler('onClientPlayerVehicleEnter', localPlayer, function()

	if windowOpened then
		closeWindow()
	end

end)