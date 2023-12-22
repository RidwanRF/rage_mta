
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z,r = unpack(markerData)
		local marker = createMarker(
			x,y,z,
			'corona',
			4,
			0,0,0,0
		)

		marker.interior = markerData.interior
		marker.dimension = markerData.dim

		marker:setData('weapon_shop.marker', true)

		exports.main_peds:createWorldPed({

			position = {
				coords = { x,y,z, 0 },
				int = markerData.interior,
				dim = markerData.dim,
			},

			attachToLocalPlayer = true,
			text = 'Продавец',

			model = 19,

		})

		createBindHandler(marker, 'f', 'Магазин оружия', function()
			openWindow('main')
		end)

		addEventHandler('onClientMarkerLeave', marker, function(player, mDim)
			if player == localPlayer and mDim and player.interior == source.interior then
				closeWindow()
			end
		end)


	end

end)
