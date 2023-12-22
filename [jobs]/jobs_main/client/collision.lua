
function getResources()

	local resources = {}

	for name in pairs( Config.disableCollision ) do

		resources[getResourceRootElement(
			getResourceFromName(name)
		)] = true

	end

	return resources

end


addEventHandler('onClientElementDataChange', root, function()

	if source.type ~= 'vehicle' then return end

	local resources = getResources()

	if resources[source.parent.parent] then

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
			setElementCollidableWith(source, vehicle, false)
		end

	end

end)

addEventHandler('onClientElementStreamIn', root, function()

	if source.type ~= 'vehicle' then return end

	local resources = getResources()

	for resource in pairs( resources ) do

		for _, vehicle in pairs( getElementsByType('vehicle', resource, true) ) do
			setElementCollidableWith(source, vehicle, false)
		end

	end

end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	local resources = getResources()

	for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

		if resources[vehicle.parent.parent] then

			for _, _vehicle in pairs( getElementsByType('vehicle', root, true) ) do
				setElementCollidableWith(_vehicle, vehicle, false)
			end

		end

	end

end)

addEventHandler('onClientVehicleDamage', root, function()
	if not source:getData('id') then
		cancelEvent()
	end
end)

addEventHandler('onClientPlayerDamage', localPlayer, function( attacker )

	if getPlayerWork( localPlayer ) and isElement( attacker ) then
		cancelEvent()
	end

end)
