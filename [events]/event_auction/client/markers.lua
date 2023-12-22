

----------------------------------------------------------------------

	function createMarkerHandler(marker)

		createBindHandler(marker, 'f', 'Участвовать в аукционе', function(marker)

			currentAuctionMarker = marker
			currentAuctionData = marker:getData('auction.data') or {}
			openWindow('main')

		end)

	end

----------------------------------------------------------------------

	addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

		if dn == 'auction.data' and source == currentAuctionMarker and windowOpened then
			currentAuctionData = new or {}
		end

	end)

----------------------------------------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()

		if source.type == 'marker' then
			createMarkerHandler(source)
		end

	end)

	addEventHandler('onClientElementDestroy', resourceRoot, function()

		if source.type == 'marker' and currentAuctionMarker == source and windowOpened then
			closeWindow()
		end

	end)

----------------------------------------------------------------------