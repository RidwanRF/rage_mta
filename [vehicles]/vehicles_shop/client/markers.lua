
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, markerData in pairs( Config.shops ) do

		local x,y,z = unpack(markerData.position)

		local marker

		if markerData.visible then

			marker = createMarker(
				x,y,z,
				'cylinder',
				markerData.size or 3,
				200, 200, 200, 150
			)

			marker:setData('3dtext', markerData.text)

		else

			marker = createMarker(
				x,y,z,
				'corona',
				markerData.size or 3,
				0, 0, 0, 0
			)

		end


		if markerData.blip then
			local blip = createBlipAttachedTo(marker)
			blip:setData('icon', markerData.blip)
			marker:setData(markerData.blip..'.marker', true)
		end

		marker.interior = markerData.int or 0
		marker.dimension = markerData.int or 0

		marker:setData('vehicles.shop.id', id)

		addEventHandler('onClientMarkerHit', marker, function(player, mDim)

			if mDim and player == localPlayer and player.interior == source.interior and not localPlayer.vehicle then

				local id = source:getData('vehicles.shop.id')
				if id == currentShopId then return end
				enterShop(id)

			end

		end)

	end

end)