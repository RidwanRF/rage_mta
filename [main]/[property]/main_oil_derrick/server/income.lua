

addEventHandler('onServerHourCycle', root, function()

	local oil_course = getCurrentCourse()

	for id, derrick in pairs(businessMarkers) do

		if derrick.data and derrick.data.owner ~= '' and derrick.data.health > 0 then

			local level_data = Config.derrick.levels[derrick.data.upgrades_level]
			local mul = level_data.payment_mul

			local add = derrick.data.override_income or oil_course*mul

			local data = derrick.data

			setBusinessData(id, 'balance', math.floor(derrick.data.balance + add))
			setBusinessData(id, 'health', data.health - 1)

		end

	end
	
end)