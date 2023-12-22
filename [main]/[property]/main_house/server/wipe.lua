
function wipeAccount(login)

	for id, data in pairs(houseMarkers) do
		if data.data.owner == login then

			setHouseData(id, 'owner', '')
			setHouseData(id, 'lots', data.data.default_lots)

		end
	end

end