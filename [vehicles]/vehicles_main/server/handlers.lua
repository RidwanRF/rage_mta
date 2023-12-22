

addEventHandler('onPlayerQuit', root, function()
	clearAllVehicles(source)
end)

addEventHandler('onVehicleExplode', root, function()
	if source:getData('id') then
		source.health = 1000
		clearVehicle(nil, nil, source)
	end
end)