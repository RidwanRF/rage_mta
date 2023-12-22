
------------------------------------------------------------------------

	local db = dbConnect('sqlite', ':databases/nicklogin.db')

	addEventHandler('onResourceStart', resourceRoot, function()
		dbExec(db, 'CREATE TABLE IF NOT EXISTS actions(id INTEGER PRIMARY KEY, nick TEXT, login TEXT, serial TEXT, ip TEXT, action TEXT, timestamp INTEGER);')
	end)

------------------------------------------------------------------------

	function addNickloginRow(player, action)

		if not player.account then return end

		local nick = player:getData('character.nickname') or player.name
		if not nick then return end

		local serial = player.serial
		local login = player.account.name
		local ip = player.ip

		dbExec(db, string.format('INSERT INTO actions(nick, login, serial, ip, action, timestamp) VALUES ("%s", "%s", "%s", "%s", "%s", %s);',
			nick, login, serial, ip, action, getRealTime().timestamp
		))
	end

------------------------------------------------------------------------

	functions.nickLoginSearch = function(filter, column)

		local rows = {}

		if #filter > 0 then

			local excludeSerials_tbl = {}
			for _serial in pairs( excludeSerials ) do
				table.insert( excludeSerials_tbl, ('"%s"'):format(_serial) )
			end

			rows = dbPoll( dbQuery(db,
				string.format('SELECT * FROM actions WHERE %s LIKE "%%%s%%" AND serial NOT IN (%s);', column, filter, table.concat(excludeSerials_tbl, ', '))
			), -1 )

		end

		clientEvent(client, 'admin.receiveNicklogin', rows)

	end

------------------------------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()
		addNickloginRow(source, 'Login')
	end, true, 'low-100')

	addEventHandler('onPlayerQuit', root, function()
		addNickloginRow(source, 'Quit')
	end)

------------------------------------------------------------------------