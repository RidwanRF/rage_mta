
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.shops ) do

		local start, stop = unpack(markerData.dims or {0,0})
		for dim = start, stop do

			local x,y,z = unpack(markerData.position)
			local marker = createMarker(
				x,y,z,
				'cylinder',
				1,
				255, 0, 70, 150
			)

			if markerData.blip then
				local blip = createBlipAttachedTo(marker, 0)
				blip:setData('icon', 'food_shop')
			end

			marker.interior = markerData.int or 0
			marker.dimension = dim

			marker:setData('food_shop.marker', true)
			marker:setData('3dtext', '[Закусочная]')

			addEventHandler('onClientMarkerHit', marker, function(player, mDim)

				if player == localPlayer and mDim and player.interior == source.interior then
					openWindow('main')
					exports.jobs_main:handleJobVisit()
				end

			end)

			addEventHandler('onClientMarkerLeave', marker, function(player, mDim)

				if player == localPlayer and mDim and player.interior == source.interior and windowOpened then
					closeWindow()
				end

			end)

		end


	end

end)