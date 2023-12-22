
---------------------------------------------------------------

	addEventHandler('onVehicleStartEnter', root, function(player, seat)

		if seat == 0 and not source:getData('exam.player') then


			for category, data in pairs( Config.categories ) do
				if data.models[ source.model ] and
				not player:getData('license.' .. category) then

					exports.chat_main:displayInfo( player,
						string.format('У вас нет категории %s для управления этим т/с', category),
						{255, 20, 20} )
					
					cancelEvent()

				end
			end

		end

	end)

---------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function(dataName, old, new)
		if dataName == 'license.all' and new then
			source:setData('license.B', true)
			source:setData('license.C', true)
			source:setData('license.D', true)
			source:setData('license.W', true)
		end
	end)

---------------------------------------------------------------