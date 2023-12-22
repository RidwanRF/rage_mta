
loadstring( exports.core:include('common'))()

local db = dbConnect('sqlite', ':databases/logs.db')

addEventHandler('onResourceStart', resourceRoot, function()

	dbExec(db, 'CREATE TABLE IF NOT EXISTS logs(id INTEGER PRIMARY KEY, tag TEXT, timestamp INTEGER, date TEXT, data TEXT);')

end)

function addLog(tag, data)

	local realTime = getRealTime()
	local timestamp = realTime.timestamp
	local date = string.format('%02d.%02d.%s %02d:%02d:%02d',
		realTime.monthday,
		realTime.month+1,
		realTime.year+1900,
		realTime.hour, realTime.minute, realTime.second
	)

	clearTableElements(data, false)
	exports.nrp_webhook:SendMessage( tag, inspect( data ), date )

	dbExec(db, string.format('INSERT INTO logs(tag, timestamp, date, data) VALUES ("%s", %s, "%s", \'%s\');',
		tag, timestamp, date, inspect(data)
	))

end

--[[local str = "[FREEROAM][BUY_VIP]"
local str1 = utf8.find( str, "]", 1 )
local str2 = utf8.find( str, str1 )
iprint(str1, str2, string.sub(str, 1, str1))]]