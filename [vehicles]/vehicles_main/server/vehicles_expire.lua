

function checkVehicleExpire(vehicle)

	local realTime = getRealTime().timestamp

	if vehicle.expiry_date <= realTime then

		local vehicle_element = getVehicleById(vehicle.id)
		if isElement(vehicle_element) then
			destroyVehicle(vehicle_element)
		end

		-- dbExec(db, string.format('DELETE FROM vehicles WHERE id=%s;', vehicle.id))
		wipeVehicle(vehicle.id)

		local account = getAccount(vehicle.owner)
		if account and account.player then
			returnPlayerVehicles(account.player)
			exports.hud_notify:notify(account.player, 'Аренда', 'Срок действия авто истек')
		end
		
	end

end

function checkVehiclesExpire()

	local vehicles = dbPoll(dbQuery(db, 'SELECT * FROM vehicles WHERE expiry_date IS NOT NULL;'), -1)

	for _, vehicle in pairs(vehicles) do
		checkVehicleExpire(vehicle)
	end

end

setTimer(checkVehiclesExpire, 30000, 0)