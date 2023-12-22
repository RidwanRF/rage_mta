
addEventHandler('onResourceStart', resourceRoot, function()

	for model, handling in pairs( Config.modelsHandling ) do
		for k,v in pairs( handling ) do
			setModelHandling(model, k,v)
		end
	end

end)

function loadVehicleDefaultHandling(vehicle)

	local handling = Config.modelsHandling[ vehicle.model ]

	if handling then
		for key, value in pairs( handling ) do
			_setVehicleHandling(vehicle, key, value)
		end
	end

	local max_velocity = exports.vehicles_main:getVehicleProperty(vehicle, 'max_velocity', location)
	_setVehicleHandling(vehicle, 'maxVelocity', max_velocity)

end


local h_override = {
	driveType = {
		f = 'fwd',
		r = 'rwd',
		['4'] = 'awd',
	},
	engineType = {
		P = 'petrol',
		e = 'electro',
		d = 'diesel',
	},
}

addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'handling' then

		local handling = getVehicleHandling(source)

		for key, value in pairs(new or {}) do
			if handling[key] ~= value then
				-- if tonumber(value) then
					-- _setVehicleHandling(source, key, clampHandlingValue(value, key, source))
				-- else
				local _value = h_override[key] and (h_override[key][value] or value) or value

				if isHandlingPropertyHexadecimal(key) and not tonumber(_value) then
					_value = tonumber('0x'.._value)
				end

				_setVehicleHandling(source, key, _value)


				-- end
			end
		end

	end
end)