
local trackingDB = dbConnect('sqlite', ':databases/ip_tracking.db')

addEventHandler('onResourceStart', resourceRoot, function()
    dbExec(trackingDB, 'CREATE TABLE IF NOT EXISTS tracking_data(id INTEGER PRIMARY KEY, ip_address TEXT, publisher TEXT);')
	dbExec(trackingDB, 'CREATE TABLE IF NOT EXISTS publisher_visits(id INTEGER PRIMARY KEY, ip_address TEXT, publisher TEXT);')
end)

function trackIpAddress(ipAddress, publisherKey)
    if (publisherKey or '') == '' then return end

    local data = dbPoll( dbQuery(trackingDB, string.format(
        'SELECT * FROM tracking_data WHERE ip_address="%s";', ipAddress
    )), -1 )

    if data and data[1] then
        dbExec(trackingDB,
        string.format('UPDATE tracking_data SET publisher="%s" WHERE ip_address="%s";',
            publisherKey, ipAddress
        ))
    else
    	dbExec(trackingDB,
		string.format('INSERT INTO tracking_data(ip_address, publisher) VALUES ("%s", "%s");',
			ipAddress, publisherKey
		))
    end

    dbExec(trackingDB, string.format('INSERT INTO publisher_visits(ip_address, publisher) VALUES ("%s", "%s");',
        ipAddress, publisherKey
    ))

end

function getTrackedIpAddress(ipAddress)
    local data = dbPoll( dbQuery(trackingDB, string.format(
        'SELECT * FROM tracking_data WHERE ip_address="%s";', ipAddress
    )), -1 )

    if data and data[1] then
    	return data[1].publisher
    end

end