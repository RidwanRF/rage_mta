
function wipeAccount(login)

	for id, data in pairs(businessMarkers) do
		if data.data.owner == login then

			setBusinessData(id, 'owner', '')
			setBusinessData(id, 'upgrades_level', 1)
			setBusinessData(id, 'fix_amount', 0)
			setBusinessData(id, 'health', Config.derrick.levels[1].health)

		end
	end

end