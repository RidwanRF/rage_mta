
addEventHandler('onClientResourceStart', resourceRoot, function()

	for index, markerData in pairs( Config.shops ) do

		local x,y,z = unpack(markerData)
		local marker = createMarker(
			x,y,z,
			'cylinder',
			markerData.size or 1,
			117,56,255, 100
		)

		if markerData.blip then
			local blip = createBlipAttachedTo(marker, 0)
			blip:setData('icon', 'clothes_shop')
		end

		marker.interior = markerData.int or 0
		marker.dimension = markerData.dim or 0

		marker:setData('clothes.shop', true)
		
		marker:setData('clothes.shop.id', index)
		marker:setData('clothes.shop.exit', markerData.exit)

		marker:setData('3dtext', '[Магазин одежды]')

		addEventHandler('onClientMarkerHit', marker, function(player, mDim)

			if player == localPlayer and mDim and player.interior == source.interior then

				enterShop( marker:getData('clothes.shop.exit') )
				currentShopId = marker:getData('clothes.shop.id')		

			end

		end)

	end

end)