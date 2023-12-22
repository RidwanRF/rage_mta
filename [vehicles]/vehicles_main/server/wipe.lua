
function wipeAccount(login)

	local data = dbPoll( dbQuery(db, ('SELECT * FROM vehicles WHERE owner="%s";'):format(login)), -1 )

	if data then
		for _, vehicle in pairs( data ) do
			cachedVehicles[vehicle.id] = nil
		end
	end

	dbExec(db, string.format('DELETE FROM vehicles WHERE owner="%s"',
		login
	))

end

function wipeVehicle(id, _player)

	local vehicle = getVehicleById(id)
	if isElement(vehicle) then destroyElement(vehicle) end
	cachedVehicles[id] = nil

	dbExec(db, string.format('DELETE FROM vehicles WHERE id="%s"',
		id
	))

	if isElement(_player) then
		returnPlayerVehicles(_player)
	end

end