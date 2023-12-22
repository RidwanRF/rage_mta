
---------------------------------------------------------------------------------------------------------

	function createMarkerBuyHandler( marker )

		createBindHandler( marker, 'f', 'перейти к покупке', function( marker )

			local data = marker:getData('used.data')
			
			if data then

				data.vehicle_name = exports.vehicles_main:getVehicleModName(data.vehicle)
				currentVehicleMarketData = data

				openWindow('buy_vehicle')

			end

		end )

	end

---------------------------------------------------------------------------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()

		if source.type == 'marker' and source:getData('used.data') then
			createMarkerBuyHandler( source )
		end

	end)

---------------------------------------------------------------------------------------------------------

	addEventHandler('onClientElementDataChange', resourceRoot, function( dn, old, new )

		if source.type == 'marker' and dn == 'used.data' then
			createMarkerBuyHandler( source )
		end

	end)

---------------------------------------------------------------------------------------------------------