
addEventHandler('onClientResourceStart', resourceRoot, function()

	for index, interior in pairs( Config.interiors ) do

		local x,y,z = unpack( interior.position.coords )

		local marker = createMarker( x,y,z, interior.position.coords.type or 'cylinder', interior.position.coords.size or 4,
			unpack( interior.color or {100,200,231,150} )
		)

		if interior.blip then

			local blip = createBlipAttachedTo(marker, 0)
			blip:setData('icon', interior.blip)

		end

		if interior.data then
			marker:setData(interior.data, true)
		end

		marker:setData('interior.id', index)
		marker:setData('3dtext', interior.text)

		marker.interior = interior.position.int or 0
		marker.dimension = interior.position.dim or 0

		addEventHandler('onClientMarkerHit', marker, function(player)

			if 
				player == localPlayer
				and source.dimension == player.dimension
				and source.interior == player.interior
				and not localPlayer.vehicle
			then

				triggerServerEvent('interior.doTeleport', resourceRoot, source:getData('interior.id'))

			end

		end)

	end

end)
