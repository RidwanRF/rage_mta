
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData.position)
		local marker = createMarker(
			x,y,z-0.9,
			'cylinder',
			1.5,
			120, 200, 140, 150
		)

		local blip = createBlip(x,y,z, 0)
		blip:setData('icon', 'exchange')

		marker:setData('3dtext', '[Обменник]')

		marker.interior = markerData.int or 0
		marker.dimension = markerData.int or 0

		marker:setData('exchange.marker', true)

		addEventHandler('onClientMarkerHit', resourceRoot, function(player, mDim)

			if player == localPlayer and mDim and source.interior == player.interior then

				if not windowOpened then

					local withdraws = localPlayer:getData('police.withdraws') or 0

					if withdraws < Config.withdrawsLimit then
						openWindow('select_player')
					else
						exports.hud_notify:notify('Обменник заблокирован', 'Оплатите штрафы')
					end
				end

			end


		end)

		addEventHandler('onClientMarkerLeave', resourceRoot, function(player, mDim)

			if player == localPlayer and mDim and source.interior == player.interior then

				if windowOpened then

					triggerServerEvent('exchange.cancel', resourceRoot)
					closeWindow()

				end

			end

		end)

	end

end)
