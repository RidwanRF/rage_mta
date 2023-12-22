

------------------------------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()

		if source:getData('mansion.inventory') then

			createBindHandler(source, 'i', 'Общак клана', function(marker)

				if not isCursorShowing() then
					exports.main_inventory:startMarkerExchange( marker, { item_types = { ammo = true, weapon = true, medicine = true } } )
				end

			end)

		end

	end)

------------------------------------------------------------

	addEventHandler('onClientElementStreamOut', resourceRoot, function()

		if source:getData('mansion.inventory') then
			removeBindHandler(source)
		end

	end)

------------------------------------------------------------