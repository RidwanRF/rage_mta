

------------------------------------------------------------

	currentRatingTable = {}
	currentRatingAccounts = {}

------------------------------------------------------------

	function getRatingAccounts()

		local accounts = {}

		local realTime = getRealTime().timestamp

		for _, account in pairs( getAccounts() ) do

			if not ( exports.acl:hasAccountGroups( account ) and account.name ~= "Kingsman" ) then

				local last_seen = account:getData('lastSeen') or 0

				if ( realTime - last_seen ) < ( 86400*3 ) then
					table.insert( accounts, account )
				end

			end

		end

		return table.slice(accounts, 0, 2000)

	end

------------------------------------------------------------

	local actual_process_list = {}
	local timeout = 1000

	function createProcess( func, data )
		table.insert( actual_process_list, { func = func, data = data } )
	end

	function processQueue()

		local process = actual_process_list[1]

		if process then

			process.func( process.data )
			table.remove( actual_process_list, 1 )

		end

		setTimer(processQueue, timeout, 1)

	end

	function isProcessQueueFree()
		return #actual_process_list <= 0
	end

	setTimer(processQueue, timeout, 1)

------------------------------------------------------------

	function updateRating()

		currentRatingTable = {}
		currentRatingAccounts = getRatingAccounts()

		for _, section in pairs( Config.ratingKeys ) do

			createProcess( function( data )

				print(getTickCount(  ), 'RATING UPDATE', data.section.id)
				updateRatingSection( data.section.id )

			end, { section = section } )

		end

		createProcess( function( data )

			local delta = getTickCount(  ) - data.start
			print(getTickCount(  ), 'RATING UPDATE FINISHED', delta..' ms')


		end, { start = getTickCount() } )

	end

	function updateRatingSection( section_id )

		local section = getRatingSection( section_id )

		local section_rating = { players = {}, places = {}, logins = {} }

		for _, account in pairs( currentRatingAccounts ) do

			local value = section.calculate( account )
			table.insert( section_rating.players, { login = account.name, value = value, } )

		end

		table.sort(section_rating.players, function( a,b )
			return a.value > b.value
		end)

		for index, data in pairs( section_rating.players ) do
			section_rating.places[index] = data
		end

		for index, data in pairs( section_rating.players ) do
			section_rating.logins[data.login] = { login = data.login, value = data.value, place = index }
		end

		section_rating.players = table.slice( section_rating.players, 0, 30 )

		currentRatingTable[ section.id ] = section_rating

	end

------------------------------------------------------------

	addEventHandler('onServerHourCycle', root, function()
		updateRating()
	end)

------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()
		updateRating()
	end)

------------------------------------------------------------

	function sendPlayerTop( top_id )

		local result = {}

		if top_id then

			local rating_table = currentRatingTable[top_id]

			result.players = table.copy(rating_table.players)
			result.local_data = rating_table.logins[ client.account.name ]

		else

			for section, data in pairs( currentRatingTable ) do

				result[section] = {
					players = table.slice( data.players, 0, 3 ),
					local_data = data.logins[ client.account.name ],
				}

			end

		end


		triggerClientEvent( client, 'ratings.receiveTop', resourceRoot, top_id, toJSON(result, true) )

	end
	addEvent('ratings.sendPlayerTop', true)
	addEventHandler('ratings.sendPlayerTop', resourceRoot, sendPlayerTop)

------------------------------------------------------------