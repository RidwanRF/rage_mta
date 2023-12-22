
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData.position)
		local marker = createMarker(
			x,y,z,
			'cylinder',
			markerData.size or 2,
			0, 200, 255, 150
		)

		if markerData.blip then
			local blip = createBlipAttachedTo(marker, 0)
			blip:setData('icon', 'numbers')
		end

		marker:setData('3dtext', '[Управление номерами]')

		marker:setData('numbers.marker', true)

		addEventHandler('onClientMarkerHit', marker, function(player, mDim)

			if player == localPlayer and localPlayer.vehicle and mDim and player.interior == source.interior
				and not localPlayer.vehicle:getData('expiry_date') and localPlayer.vehicle:getData('id')
			then

				if localPlayer.vehicle and not localPlayer.vehicle:getData('id') then
					return exports.hud_notify:notify('Номерной салон', 'Текущий автомобиль недоступен')
				end

				if localPlayer.vehicle and getVehicleType(localPlayer.vehicle) == 'Automobile' then

					if localPlayer.vehicle:getData('owner') ~= localPlayer:getData('unique.login') then
						return
					end

					openWindow('main')

					localPlayer.vehicle:setData('number.curtain.state', false)

				else
					exports.hud_notify:notify('Номерной салон', 'Нужно находиться в автомобиле')
				end

			end

		end)


	end

	addEventHandler('onClientPlayerVehicleExit', localPlayer, function()

		if windowOpened then closeWindow() end

	end)

end)