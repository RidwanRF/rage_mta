
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, marker_data in pairs( Config.markers ) do

		local x,y,z = unpack(marker_data)
		local marker = createMarker( x,y,z, 'cylinder', 3.5, 40, 70, 180, 150 )
		local blip = createBlipAttachedTo(marker, 0)

		blip:setData('icon', 'by')
		marker:setData('used.marker', true)

		marker:setData('3dtext', '[Авторынок]')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior
				and player.vehicle and player.vehicleSeat == 0
				and player.vehicle:getData('owner') == player:getData('unique.login')
			then

				openWindow('main')

			end

		end)

		addEventHandler('onClientMarkerLeave', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior then
				closeWindow()
			end

		end)

	end

	for _, marker_data in pairs( Config.destroy_markers ) do

		local x,y,z = unpack(marker_data)
		local marker = createMarker( x,y,z, 'cylinder', 3.5, 40, 70, 180, 150 )
		local blip = createBlipAttachedTo(marker, 0)

		blip:setData('icon', 'vehdestroy')
		marker:setData('vehicle_destroy.marker', true)

		marker:setData('3dtext', '[Разборка]')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior
				and player.vehicle and player.vehicleSeat == 0 and player.vehicle:getData('id') then

				openWindow('destroy')

			end

		end)

		addEventHandler('onClientMarkerLeave', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior then
				closeWindow()
			end

		end)

	end

	for floor, marker_data in pairs( Config.floors ) do

		local x,y,z = unpack(marker_data.position.coords)
		local marker = createMarker( x,y,z, 'cylinder', 1.5, 140, 70, 180, 150 )


		marker:setData('used.floor', floor)

		marker.interior = marker_data.position.int or 0
		marker.dimension = marker_data.position.dim or 0

		marker:setData('3dtext', marker.dimension == 0 and '[Вход в авторынок]' or '[Лифт]')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior and not player.vehicle then

				currentFloor = source:getData('used.floor') or 0
				openWindow('enter')

			end

		end)

		addEventHandler('onClientMarkerLeave', marker, function( player, mDim )

			if player == localPlayer and mDim and player.interior == source.interior then
				closeWindow()
			end

		end)

	end


end)