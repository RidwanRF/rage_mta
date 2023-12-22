
db = dbConnect('sqlite', ':databases/serial_check.db')

dbExec(db, string.format('CREATE TABLE IF NOT EXISTS serial_check(id INTEGER PRIMARY KEY, login TEXT, serial TEXT);'))

function checkSerialUsage(serial)
	local data = dbPoll( dbQuery(db, string.format('SELECT * FROM serial_check WHERE serial="%s";', serial)), -1 )
	return (data and data[1]) and data[1].login or false
end

function addSerial(login, serial)
	dbExec(db, string.format('INSERT INTO serial_check(login, serial) VALUES ("%s", "%s");',
		login, serial
	))
end


function removeSerial(login)
	dbExec(db, string.format('DELETE FROM serial_check WHERE login="%s";',
		login
	))
end

addCommandHandler('ml_remove_serial', function(player, _, login)

	--if exports.acl:isAdmin(player) then
		removeSerial(login)
		exports.chat_main:displayInfo( player, 'ml_remove_serial succesfully', {255,255,255} )
	--end

end)
