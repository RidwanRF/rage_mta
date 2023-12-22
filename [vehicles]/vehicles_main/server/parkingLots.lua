
function calculatePlayerParkingLots(player)
	if not player.account then return 0, 1 end

	local lotsCurrent, lotsAll = 0, Config.defaultLotsCount

	local houses = exports.main_house:getPlayerHouses(player)

	for _, house in pairs( houses ) do
		lotsAll = lotsAll + house.lots

		if house.upgrades then
			local upgrades = fromJSON(house.upgrades)
			if upgrades.lots then
				lotsAll = lotsAll + 1
			end
		end
	end

	local login = player.account.name
	local vehicles = dbPoll(dbQuery(db, string.format('SELECT * FROM vehicles WHERE owner="%s" AND expiry_date IS NULL;', login)), -1)

	for _, vehicle in pairs( vehicles ) do
		local vehicleType = getVehicleType(vehicle.model)
		if not ((vehicleType == "Bike") or (vehicleType == "Quad") or (vehicleType == "BMX")) then
			lotsCurrent = lotsCurrent + 1
		end
	end

	lotsAll = lotsAll + (player:getData('parks.extended') or 0)

	player:setData('parks.loaded', lotsCurrent)
	player:setData('parks.all', lotsAll)

	return lotsCurrent, lotsAll
end

function updatePlayerParkingLots(player)

	if not player.account then return end

	local lotsCurrent, lotsAll = calculatePlayerParkingLots(player)
	player:setData('parks.loaded', lotsCurrent)
	player:setData('parks.all', lotsAll)

end

addEventHandler('onPlayerLogin', root, function()
	updatePlayerParkingLots(source)
end)

addEventHandler('onResourceStart', resourceRoot, function()
	for _, player in pairs( getElementsByType('player') ) do
		updatePlayerParkingLots(player)
	end
end)