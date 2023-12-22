

---------------------------------------------

	tops = {}

---------------------------------------------
	
	tops.db = dbConnect('sqlite', ':databases/coins_event.db')

---------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		dbExec(tops.db, 'CREATE TABLE IF NOT EXISTS players_data(id INTEGER PRIMARY KEY, account TEXT, key TEXT, value TEXT);')

	end)

---------------------------------------------

	function updatePlayersTop()

		for _, player in pairs( getElementsByType('player') ) do

			local coins = tonumber(player:getData('event_coins.coins')) or 0

			if coins > 0 then
				saver:savePlayerData( player, 'event_coins.coins', coins )
			end

		end

		local data = dbPoll(
			dbQuery(tops.db,
				'SELECT * FROM players_data WHERE CAST(value AS REAL) > 0 AND key="event_coins.coins" ORDER BY CAST(value AS REAL) DESC;'
			),
		-1 )

		local top = {}
		local places = {}

		for i = 1, 100 do

			if data[i] then

				local row = data[i]

				local account = getAccount( row.account )
				if account then
					row.level = account:getData('level') or 0
					table.insert(top, row)
				end
				
			end

		end

		for index, row in pairs( data ) do
			places[row.account] = { place = index, value = row.value }
		end


		resourceRoot:setData('players_top', {
			top = top,
			places = places,
		})

	end

	setTimer(updatePlayersTop, 5*60*1000, 0)

	addEventHandler('onResourceStart', resourceRoot, function()
		updatePlayersTop()
	end)

---------------------------------------------