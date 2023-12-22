
local db = dbConnect('sqlite', ':databases/fr_cars_bought.db')

addEventHandler('onResourceStart', resourceRoot, function()

	dbExec( db, 'CREATE TABLE IF NOT EXISTS cars_bought(id INTEGER PRIMARY KEY, account TEXT, model INTEGER, amount INTEGER);' )

end)

function getPlayerTotalCarsBought( login )

	local data = dbPoll( dbQuery( db, ('SELECT * FROM cars_bought WHERE account="%s";'):format(
		login
	) ), -1 )

	if data then
		return #data
	end

	return 0

end

function addBoughtCar( login, model )

	local data = dbPoll( dbQuery( db, ('SELECT * FROM cars_bought WHERE account="%s" AND model=%s;'):format(
		login, model
	) ), -1 )

	if data and data[1] then
		dbExec( db, ('UPDATE cars_bought SET amount=amount+1 WHERE id=%s;'):format( data[1].id ) )
	else
		dbExec( db, ('INSERT INTO cars_bought(account, model, amount) VALUES ("%s", %s, 1);'):format( login, model ) )
	end

end