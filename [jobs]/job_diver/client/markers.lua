
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, station in pairs( Config.stations ) do

		local x,y,z = unpack(station.marker)
		local marker = createMarker(x,y,z, 'cylinder', 1, 0, 200, 255, 150)

		marker:setData('station.id', id)
		marker:setData('diver.marker', id)
		marker:setData('3dtext', '[Водолаз]')
		marker:setData('3dtext.size', 1.3)
		marker:setData('3dtext.zAdd', 1)

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'job_diver')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				if currentWork == Config.resourceName then

					dialog('Водолаз', {
						'Вы действительно хотите',	
						'завершить работу?',	
					}, function(result)
						if result then
							triggerServerEvent('diver.finish', resourceRoot)
						end
					end)

				else
					
					openWindow('main')

					exports.jobs_main:handleJobVisit()

				end				

			end

		end)

		local x,y,z = unpack(station.shop)
		local marker = createMarker(x,y,z, 'cylinder', 1, 255, 120, 0, 150)

		marker:setData('station.id', id)
		marker:setData('diver.marker', id)
		marker:setData('3dtext', '[Сдать находки]')
		marker:setData('3dtext.size', 1.2)
		marker:setData('3dtext.zAdd', 1)

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				if currentWork == Config.resourceName then

					dialog('Водолаз', {
						'Вы действительно хотите',	
						'сдать находки?',
					}, function(result)
						if result then
							triggerServerEvent('diver.takeInventory', resourceRoot)
						end
					end)

				end				

			end

		end)

		local x,y,z = unpack(station.destination)
		local marker = createMarker(x,y,z, 'cylinder', 1, 180, 70, 70, 150)

		marker:setData('station.id', id)
		marker:setData('diver.marker', id)
		marker:setData('3dtext', '[Склад снаряжения]')
		marker:setData('3dtext.size', 1.1)
		marker:setData('3dtext.zAdd', 1)

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				if currentWork == Config.resourceName then

					openWindow('shop')

				else

					return exports['hud_notify']:notify('Ошибка', 'Устройтесь на работу')

				end				

			end

		end)

	end

end)


