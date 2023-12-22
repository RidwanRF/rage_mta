
local db = dbConnect('sqlite', ':databases/exchanges.db')

function alterTable()

	local info = dbPoll(dbQuery(db, 'PRAGMA table_info(exchanges);'), -1)

	for _, column in pairs(info) do
		if column.name == 'exchange_data' then
			return
		end
	end

	dbExec(db, 'ALTER TABLE exchanges ADD COLUMN exchange_data TEXT;')

end

addEventHandler('onResourceStart', resourceRoot, function()
	dbExec(db, 'CREATE TABLE IF NOT EXISTS exchanges(id INTEGER PRIMARY KEY, player_1 TEXT, player_2 TEXT, timestamp INTEGER);')
	alterTable()
end)

function addLastExchange(players, exchange_data)

	dbExec(db, string.format('INSERT INTO exchanges(player_1, player_2, timestamp, exchange_data) VALUES ("%s", "%s", %s, \'%s\');',
		players[1].account.name,
		players[2].account.name,
		getRealTime().timestamp,
		toJSON(exchange_data)
	))
	
end