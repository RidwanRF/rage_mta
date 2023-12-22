
function updateVehicleXenon(vehicle)
	local r,g,b = getXenonColor(vehicle)

	setVehicleHeadLightColor(vehicle, r,g,b)
end

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if source.type == 'vehicle' and isElementStreamedIn(source) then
		if dataName == 'xenon_color' then
			updateVehicleXenon(source)
		end
	end
end, true, 'low')

addEventHandler('onClientElementStreamIn', root, function()

	if source.type ~= 'vehicle' then return end

	updateVehicleXenon(source)

end, true, 'low')