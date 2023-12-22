
function openHouseWindow(data, section)
	currentHouseData = data
	openWindow(section)
end

addEventHandler('onClientElementDataChange', resourceRoot, function(dataName, old, new)
	if currentHouseData and windowOpened and
	dataName == 'house.data' and new.id == currentHouseData.id then
		currentHouseData = new
	end
end)

addEventHandler('onClientMarkerHit', resourceRoot, function(player, mDim)
	if source.interior == player.interior and player == localPlayer and mDim and not localPlayer.vehicle
	and math.abs( source.position.z - player.position.z ) < 1.5 then

		if source:getData('house.marker') then

			local data = source:getData('house.data') or {}
			local mType = 'manage'

			if data.owner == '' then
				openHouseWindow(data, 'enter_free')
			elseif data.owner == localPlayer:getData('unique.login') then
				currentHouseMarker = source
				openHouseWindow(data, 'main')
			else
				openHouseWindow(data, 'enter_bought')
			end

		elseif source:getData('flat.marker') then

			local data = source:getData('flat.data') or {}

			currentFlatData = data
			openWindow('flat')

		end


	end
end)


addCommandHandler('delhouse', function()

	if exports.acl:isAdmin(localPlayer) and not windowOpened then

		for _, marker in pairs( getElementsByType('marker', resourceRoot, true) ) do

			local h_data = marker:getData('house.data')
			local f_data = marker:getData('flat.data')

			if h_data and isElementWithinMarker(localPlayer, marker) then

				dialog('Удаление', 'Удалить этот дом?', function(result)

					if result then
						triggerServerEvent('house.delete', resourceRoot, h_data.id)
						closeWindow()
					end

				end)

				break

			elseif f_data and isElementWithinMarker(localPlayer, marker) then

				dialog('Удаление', 'Удалить эту квартиру?', function(result)

					if result then
						triggerServerEvent('flat.delete', resourceRoot, f_data.id)
						closeWindow()
					end

				end)

				break

			end

		end

	end

end)