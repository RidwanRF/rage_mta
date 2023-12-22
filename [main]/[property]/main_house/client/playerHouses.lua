playerHouses = {}

function getPlayerHouseById(_id)
	for house, data in pairs(playerHouses) do
		if data.id == _id then
			return house, data
		end
	end
end

function loadPlayerHouses()
	localLogin = localPlayer:getData('unique.login')
	for _, house in pairs( getElementsByType('marker', resourceRoot) ) do
		local data = house:getData('house.data')
		if data and data.owner == localLogin then
			playerHouses[house] = data
		end
	end
end

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if dataName == 'house.data' then
		if new.owner == localPlayer:getData('unique.login') then
			playerHouses[source] = new
		else
			playerHouses[source] = nil
		end
	elseif dataName == 'unique.login' and source == localPlayer then
		loadPlayerHouses()
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, loadPlayerHouses)