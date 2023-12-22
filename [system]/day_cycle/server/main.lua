addEvent('onServerDayCycle', true)

db = dbConnect('sqlite', ':databases/daycycle.db')


addEventHandler('onResourceStart', root, function(resource)
	if resource.name == 'day_cycle_finish' then
		doDayCycle()
	end
end)


function doDayCycle()

	dbExec(db, string.format('CREATE TABLE IF NOT EXISTS daycycle(id INTEGER PRIMARY KEY, date TEXT);'))

	local realTime = getRealTime()
	local currentDate = string.format('%02d-%02d-%s',
		realTime.monthday,
		realTime.month,
		realTime.year + 1900
	)

	local dbData = dbPoll(dbQuery(db, string.format('SELECT * FROM daycycle WHERE date="%s";',
		currentDate
	)), -1)

	if not (dbData and dbData[1]) then
		dbExec(db, string.format('INSERT INTO daycycle(date) VALUES ("%s");',
			currentDate
		))
		triggerEvent('onServerDayCycle', root)
	end

end