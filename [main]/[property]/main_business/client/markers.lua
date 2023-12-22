
function openBusinessWindow(data, section)
	currentBusinessData = data
	openWindow(section)
end

addEventHandler('onClientElementDataChange', resourceRoot, function(dataName, old, new)
	if currentBusinessData and windowOpened and
	dataName == 'business.data' and new.id == currentBusinessData.id then
		currentBusinessData = new
	end
end)

addEventHandler('onClientMarkerHit', resourceRoot, function(player, mDim)
	if source.interior == player.interior and player == localPlayer and mDim and not localPlayer.vehicle then

		local data 
		local mType

		local data = source:getData('business.data') or {}
		currentBusinessData = data

		if data.owner == '' then

			dialog('Покупка', {
				string.format('Вы действительно хотите купить бизнес'),
				string.format('за %s %s?', splitWithPoints(data.cost, '.'), data.donate == 1 and 'R-Coin' or '$'),
			}, function(result)

				if result then
					triggerServerEvent('business.buy', resourceRoot, data.id)
					closeWindow()
				end

			end)

		else

			openBusinessWindow(data, 'main')
			
		end

	end
end)

bindKey('delete', 'down', function()

	if exports.acl:isAdmin(localPlayer) and not windowOpened then

		for _, marker in pairs( getElementsByType('marker', resourceRoot, true) ) do

			local b_data = marker:getData('business.data')
			if b_data and isElementWithinMarker(localPlayer, marker) then

				dialog('Удаление', 'Удалить этот бизнес?', function(result)

					if result then
						triggerServerEvent('business.delete', resourceRoot, b_data.id)
						closeWindow()
					end

				end)

				break

			end

		end

	end

end)