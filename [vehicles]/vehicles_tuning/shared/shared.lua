function getXenonColor(vehicle)

	local color = vehicle:getData('xenon_color') or '#ffffff'
	return hexToRGB(color)

end

function getTuningCost(model, tuning)
	
	local config = Config.componentsTuning[model]
	local cost = 0

	for section, value in pairs(tuning) do

		if section == 'tuning' then

			for tuningName, tuningValue in pairs( value ) do
				if config[tuningName] and config[tuningName][tuningValue] then

					local _cost = config[tuningName][tuningValue].price or 0
					cost = cost + _cost

				end
			end

		elseif Config.defaultTuning[section] then
			if Config.defaultTuning[section].components[value] then

				local _cost = Config.defaultTuning[section].components[value].price or 0
				cost = cost + _cost

			end
		end

	end

	return cost

end