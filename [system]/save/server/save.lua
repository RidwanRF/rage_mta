
saveDataNames = {}
clientCancelDataNames = {}
cancelSyncDataNames = {}

------------------------------------

	addEventHandler('onElementDataChange', root, function(dataName, old, new)

		if clientCancelDataNames[dataName] then
			if client then return source:setData(dataName, old) end
		end

		if saveDataNames[dataName] and source.account then
			if source.account:getData(dataName) ~= new then

				local value = new
				if saveDataNames[dataName] == 'json' and new then
					value = toJSON(new, true)
				end
				source.account:setData(dataName, value)

			end
		end

	end)

	function loadPlayerData(player)

		for dataName, saveType in pairs(saveDataNames) do
			local value = player.account:getData(dataName)

			if saveType == 'json' and value then
				value = fromJSON(value, true)
			end

			player:setData( dataName, value, not cancelSyncDataNames[dataName] )

		end
		
	end

	addEventHandler('onPlayerLogin', root, function()
		if not source.account then return end

		loadPlayerData(source)

	end, true, 'high+5')

	addCommandHandler('save_load_data', function(player)
		local a1 = getTickCount()
		loadPlayerData(player)
		local a2 = getTickCount()
		print(getTickCount(  ), 'LOAD PLAYER DATA', a2-a1)
	end)

------------------------------------

	addEvent('save.requireSyncData', true)
	addEventHandler('save.requireSyncData', resourceRoot, function()

		local _sync = {}

		for key in pairs( cancelSyncDataNames ) do
			_sync[key] = client:getData(key)
		end

		triggerClientEvent(client, 'save.syncData', resourceRoot, _sync)

	end)

------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()
		root:setData('save.saved_data', {
			saveDataNames,
			clientCancelDataNames,
			cancelSyncDataNames,
		})
	end)

	addEventHandler('onResourceStart', resourceRoot, function()
		local data = root:getData('save.saved_data') or {}


		saveDataNames = data[1] or {}
		clientCancelDataNames = data[2] or {}
		cancelSyncDataNames = data[3] or {}

		
		-- local file = fileCreate('pidr.txt')

		-- fileWrite( file, inspect(saveDataNames) )
		-- fileWrite( file, inspect(clientCancelDataNames) )

		-- fileClose( file )

	end)

------------------------------------
