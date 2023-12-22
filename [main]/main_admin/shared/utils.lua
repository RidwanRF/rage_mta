
function getVehicleFreeSeat(vehicle)

	for seat = 0, getVehicleMaxPassengers(vehicle) do
		if not getVehicleOccupant(vehicle, seat) then
			return seat
		end
	end

	return false
	
end

function teleport(from, to)

	if isElement(from) and isElement(to) then

		if (to.vehicle and getVehicleFreeSeat( to.vehicle ) ) then
			warpPedIntoVehicle(from, to.vehicle, freeSeat)
		else
			local x,y,z = getElementPosition(to)
			spawnPlayer(from, x + 0.5, y + 0.5, z + 0.5, 0, from.model, 0, 0)
		end

	end

end

function giveLicenses( login )

	local account = getAccount(login)
	if not account then return end

	local list = {'B', 'C', 'D', 'W'}

	for _, license in pairs(list) do

		local license_name = 'license.'..license

		if account.player then
			account.player:setData(license_name, true)
		else
			account:setData(license_name, true)
		end

	end

end

function giveLevel( login, amount )

	local account = getAccount(login)
	if not account then return end

	if account.player then
		account.player:setData('xp', tonumber(amount)*3600)
	else
		account:setData('xp', tonumber(amount)*3600)
		account:setData('level', tonumber(amount))
	end

end