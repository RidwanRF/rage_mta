
vehiclesSaveData = {
	['fuel'] = true,
	['fuel_type'] = true,
	['odometer'] = true,
	['plate'] = true,
	['expiry_date'] = true,
	['flag'] = true,
	-- ['health'] = 'property',
	['position'] = 'json',
	['handling'] = 'json',
	['appearance_upgrades'] = 'json',
--	['stages'] = true,
}

appearanceUpgrades = {
	['tuning'] = true,
	['pneumo'] = true,
	['wheels'] = true,
	['wheels_radius'] = true,
	['wheels_tire'] = true,
	['wheels_radius_f'] = true,
	['wheels_radius_r'] = true,
	['wheels_offset_f'] = true,
	['wheels_offset_r'] = true,
	['wheels_razval_f'] = true,
	['wheels_razval_r'] = true,
	['wheels_width_f'] = true,
	['wheels_width_r'] = true,
	['wheels_height'] = true,
	['color_1'] = true,
	['color_2'] = true,
	['color_3'] = true,
	['wheels_color'] = true,
	['color_cover'] = true,
	['coverType'] = true,
	['paintjob'] = true,
	['tint_front'] = true,
	['tint_side'] = true,
	['tint_rear'] = true,
	['tint_light_glass'] = true,
	['xenon_color'] = true,
	['sirens'] = true,
	['sirens_position'] = true,
	['fso_position'] = true,
	['plate_curtain'] = true,
	['license_frame'] = true,
	['strobo'] = true,
	['color_smoke'] = true,
	['color_tint'] = true,
	['fso'] = true,
	['tuning_block'] = true,
	['wheel_coverType'] = true,
	
}

----------------------------------------

	debug = false
	addCommandHandler('vm_toggle_debug', function(player)

		if exports.acl:isAdmin(player) then
			debug = not debug
		end

	end)

----------------------------------------

function returnVehicleSyncData(vehicle)

	if not isElement(vehicle) then return end

	local data = {}

	for key in pairs( Config.squeeze ) do

		local d

		if squeezed[vehicle] and squeezed[vehicle][key] then
			d = squeezed[vehicle][key]
		else
			d = vehicle:getData(key) or nil
		end

		data[key] = d

	end

	triggerClientEvent(client, 'vehicles.receiveSyncData', resourceRoot, vehicle, data)

end
addEvent('vehicles.returnSyncData', true)
addEventHandler('vehicles.returnSyncData', resourceRoot, returnVehicleSyncData)

----------------------------------------

addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)

	if Config.squeeze[dn] and source.type == 'vehicle' then
		squeezed[source] = squeezed[source] or {}
		squeezed[source][dn] = new
	end

end)

----------------------------------------

squeezed = {}

function getSqueezedData(vehicle, name)

	local d

	if squeezed[vehicle] and squeezed[vehicle][name] then
		d = squeezed[vehicle][name]
	else
		d = vehicle:getData(name) or nil
	end

	return d

end

function loadVehicleAppearance(vehicle, appearance)
	local data = appearance or ( vehicle:getData('appearance_upgrades') or {} )
	-- local data = vehicle:getData('appearance_upgrades') or {}
	local cUpgrades = {}

	for key in pairs( appearanceUpgrades ) do
		cUpgrades[key] = vehicle:getData(key)
	end

	for key, value in pairs( data ) do

		if Config.squeeze[key] then

			squeezed[vehicle] = squeezed[vehicle] or {}
			squeezed[vehicle][key] = value
			-- vehicle:setData(key, value, false)

		else
			vehicle:setData ( key, value )
		end

	end

	-- for key, value in pairs( data ) do
	-- 	vehicle:setData(key, value)
	-- end

	local r1,g1,b1 = hexToRGB(data.color_1 or '#ffffff')
	local r2,g2,b2 = hexToRGB(data.color_2 or '#ffffff')
	local r3,g3,b3 = hexToRGB(data.color_3 or '#ffffff')

	vehicle:setColor(r1,g1,b1, r2,g2,b2, r3,g3,b3)
end

-- addEventHandler('onElementDataChange', root, function(dataName, old, new)

-- 	if dataName == 'appearance_upgrades' then

		-- local ugpradesJSON = toJSON(new)
		-- local cUpgrades = {}

		-- for key in pairs( appearanceUpgrades ) do
		-- 	cUpgrades[key] = source:getData(key)
		-- end

		-- if toJSON(cUpgrades) ~= upgradesJSON then
		-- 	for key, value in pairs( new ) do
		-- 		source:setData(key, value)
		-- 	end
		-- end

		-- local r1,g1,b1 = hexToRGB(new.color_1)
		-- local r2,g2,b2 = hexToRGB(new.color_2)

		-- source:setColor(r1,g1,b1, r2,g2,b2)

-- 	elseif appearanceUpgrades[dataName] then

-- 		local upgrades = source:getData('appearance_upgrades') or {}
-- 		local upgradesJSON = toJSON(upgrades)

-- 		upgrades[dataName] = new

-- 		if toJSON(upgrades) ~= upgradesJSON then
-- 			source:setData('appearance_upgrades', upgrades)
-- 		end

-- 	end

-- end)

-- addEventHandler('onElementDataChange', root, function(dataName, old, new)
-- 	if source.type == 'vehicle' and dataName:find('vehicle.') then

-- 		local id = vehicle:getData('id')
-- 		if id then
-- 			setVehicleData(id, dataName, new)
-- 		end

-- 	end
-- end)

-- function setVehicleData(id, name, value)
-- 	dbExec(db, string.format('UPDATE vehicles SET %s=? WHERE id=%s;',
-- 		name, id
-- 	), value)
-- end



function loadVehicleData(vehicle, data)
	for name, str in pairs(vehiclesSaveData) do

		if name ~= 'appearance_upgrades' then
			if str == 'property' then
				vehicle[name] = data[name]
			elseif str == 'json' then
				local value = fromJSON(data[name] or '')

				local _value = {}
				for k,v in pairs(value or {}) do
					_value[tonumber(k) or k] = v
				end

				vehicle:setData(name, _value)
			else
				vehicle:setData(name, data[name])
			end
		end

	end
	loadVehicleAppearance(vehicle, fromJSON(data.appearance_upgrades or '[[]]') or {})
	exports.vehicle_c_handling:LoadStage ( vehicle:getData ( 'id' ) )
end

function saveVehicleData(vehicle)

	local id = vehicle:getData('id')

	local x,y,z = getElementPosition(vehicle)
	local _, _, r = getElementRotation(vehicle)
	
	vehicle:setData('position', {
		x = x, y = y, z = z, r = r,
	})

	local appUpgrades = {}
	for dn in pairs( appearanceUpgrades ) do

		local data

		if squeezed[vehicle] and squeezed[vehicle][dn] then
			data = squeezed[vehicle][dn]
		else
			data = vehicle:getData(dn) or nil
		end

		appUpgrades[dn] = data

	end

	-- vehicle:setData('appearance_upgrades', appUpgrades)

	for name, str in pairs(vehiclesSaveData) do

		local data

		if squeezed[vehicle] and squeezed[vehicle][name] then
			data = squeezed[vehicle][name]
		else
			data = vehicle:getData(name) or nil
		end

		if name == 'appearance_upgrades' then
			data = appUpgrades
		end

		local value

		if str == 'property' then
			data = true
			value = vehicle[name]
		end

		if data then

			if str == 'json' then
				value = toJSON(data or '[[]]') or {}
			else
				value = value or data
			end
			
			setVehicleData(id, name, value, true)
		end

	end
	exports.vehicle_c_handling:SaveStage ( vehicle )
end

function saveVehicleOnExitFromIt(_, seat, _) 

	if isElement(source) then
		if source.type == 'vehicle' then
			if source:getData('id') and (seat == 0) then
				saveVehicleData(source)
			end
		end
	end

end
addEventHandler("onVehicleExit", root, saveVehicleOnExitFromIt)
