
function openBusinessWindow(data, section)
	currentBusinessData = data
	openWindow(section)
end

addEventHandler('onClientElementDataChange', resourceRoot, function(dataName, old, new)
	if currentBusinessData and windowOpened and
	dataName == 'derrick.data' and new.id == currentBusinessData.id then
		currentBusinessData = new
	end
end)

addEventHandler('onClientMarkerHit', resourceRoot, function(player, mDim)
	if source.interior == player.interior and player == localPlayer and mDim and not localPlayer.vehicle then

		local data 
		local mType

		local data = source:getData('derrick.data') or {}

		if data.owner == '' then

			dialog('Покупка', {
				string.format('Вы действительно хотите купить'),
				string.format('нефтевышку за $%s?',  splitWithPoints(data.cost, '.') ),
			}, function(result)

				if result then
					triggerServerEvent('derrick.buy', resourceRoot, data.id)
					closeWindow()
				end

			end)

		elseif data.owner == localPlayer:getData('unique.login') then
			openBusinessWindow(data, 'main')
		else

			if exports.acl:isAdmin(localPlayer) then
				currentBusinessData = data
				openBusinessEdit()
			else
				dialog('Нефтевышка', string.format('Эта вышка принадлежит игроку %s',
					data.owner
				))
			end

		end

	end
end)



bindKey('delete', 'down', function()

	if exports.acl:isAdmin(localPlayer) and not windowOpened then

		for _, marker in pairs( getElementsByType('marker', resourceRoot, true) ) do

			local d_data = marker:getData('derrick.data')
			if d_data and isElementWithinMarker(localPlayer, marker) then

				dialog('Удаление', 'Удалить эту вышку?', function(result)

					if result then
						triggerServerEvent('derrick.delete', resourceRoot, d_data.id)
						closeWindow()
					end

				end)

				break

			end

		end

	end

end)