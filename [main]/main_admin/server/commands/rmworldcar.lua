
local lastCommandUse = 0

function removeWorldCars(resp, nearest)

	if ( getTickCount() - lastCommandUse ) < 5*60000 and not nearest then

		if isElement(resp) then
			exports.hud_notify:notify(resp, 'Ошибка', 'Нельзя чаще раза в 5 минут')
		end

		return false

	end

	lastCommandUse = getTickCount(  )


	for _, vehicle in pairs( getElementsByType('vehicle', getResourceRoot('vehicles_main')) ) do

		if getTableLength( getVehicleOccupants( vehicle ) ) == 0 and not vehicle:getData('used.data')
			and (not nearest or getDistanceBetween( vehicle, resp ) < 100 )
		then

			exports.vehicles_main:clearVehicle(nil, nil, vehicle)

		end

	end

	return true

end

addCommandHandler('rmworldcar', function( player, cn, nearest )

	if exports.acl:isModerator( player ) then

		if removeWorldCars(player, nearest == 'true') then
			exports.chat_main:displayInfo( root, string.format('Модератор %s очистил весь транспорт', player.name), { 255, 0, 255 } )
		end


	end

end)

-- setTimer(function()

-- 	if removeWorldCars() then
-- 		exports.chat_main:displayInfo( root, 'На сервере был очищен незанятый транспорт', { 255, 0, 255 } )
-- 	end

-- end, 30*60*1000, 0)