
--------------------------------------------------------

	local tuningDataNames = {
		['color_1'] = { default = '#ffffff' },
		['pneumo'] = { default = 0 },
		['color_2'] = { default = '#ffffff' },
		['color_3'] = { default = '#ffffff' },
		['wheels_color'] = { default = '#ffffff' },
		['color_cover'] = { default = '#ffffff' },
		['color_smoke'] = { default = '#ffffff' },
		['color_tint'] = { default = '#000000' },
		['coverType'] = { default = 'default' },
		['wheel_coverType'] = { default = 'default' },
		['tuning'] = { default = {} },
		['paintjob'] = { default = {} },
		['wheels'] = { default = 0 },
		['sirens'] = { default = 0 },
		['fso'] = { default = 0 },
		['fso_position'] = { default = '0_0_0_0' },
		['sirens_position'] = { default = '0_0_0_0' },
		['strobo'] = { default = 0 },
		['tint_front'] = { default = 0.7 },
		['tint_side'] = { default = 0.7 },
		['tint_rear'] = { default = 0.7 },
		['tint_light_glass'] = { default = 0.7 },
		['xenon_color'] = { default = '#ffffff' },
		['license_frame'] = { default = 0 },
		['plate_curtain'] = { default = 0 },
		['wheels_tire'] = { default = 0 },
		['stages'] = { default = 0 },
	}

	addEventHandler('onClientResourceStart', resourceRoot, function()
		for _, parameter in pairs( Config.wheelsConfigParameters ) do
			tuningDataNames[parameter] = { default = getDefaultWheelProperty(parameter) or getWheelPropertyLimit(parameter, 'min') }
		end
	end)

	initialTuningData = {}

	function initializeTuning(initializeGui, tbl)

		if not tbl then
			initialTuningData = {}
		end

		for dataName, data in pairs( tuningDataNames ) do
			if tbl then
				if tbl[dataName] then
					initialTuningData[dataName] = tbl[dataName]
				end
			else
				initialTuningData[dataName] = (localPlayer.vehicle:getData(dataName) or data.default)
			end
		end


		for _, section in pairs(windowModel) do
			for _, element in pairs(section) do
				if element.onPreload then
					element.onPreload(element)
				end
			end
		end

		if initializeGui then
			initializeTuningGui()
		end

		reloadGui()


	end
	addEvent('tuning.client.init', true)
	addEventHandler('tuning.client.init', root, initializeTuning)


--------------------------------------------------------

	function loadInitialTuning()
		for name, value in pairs( initialTuningData ) do
			localPlayer.vehicle:setData(name, value, false)
		end
	end

	function hasVehicleInitialTuning()
		local dn = 'tuning'
		local defaultValue = (tuningDataNames[dn] or {}).default

		local value_1, value_2 =
			localPlayer.vehicle:getData(dn) or defaultValue,
			initialTuningData[dn]
	end

	function hasVehicleInitialValue(dn)
		local defaultValue = (tuningDataNames[dn] or {}).default

		local value_1, value_2 =
			localPlayer.vehicle:getData(dn) or defaultValue,
			initialTuningData[dn]


		if type(value_1) == 'number' then
			return value_1 == value_2
		elseif type(value_1) == 'string' then
			return compare_str_lower(value_1, value_2)
		end

	end

--------------------------------------------------------

	function getInitialTuningValue(dataName)

		if tuningDataNames[dataName] then
			value = initialTuningData[dataName] or (tuningDataNames[dataName] or {}).default
		else
			local tuning = initialTuningData.tuning or {}
			return tuning[dataName]
		end

		return value

	end

	function getTuningValue(dataName)

		if tuningDataNames[dataName] then
			return localPlayer.vehicle:getData(dataName) or (tuningDataNames[dataName] or {}).default
		else
			local tuning = localPlayer.vehicle:getData('tuning') or {}
			return tuning[dataName]
		end

	end

--------------------------------------------------------