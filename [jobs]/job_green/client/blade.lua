
setAnimData('vehicle-blade', 0.01)

function isBladeActive()
	local anim = getAnimData('vehicle-blade')
	return anim >= 0.6 and localPlayer.vehicle.model == Config.vehicle
end

function renderBlade()

	animate('vehicle-blade', (getKeyState('mouse2') and localPlayer.vehicle) and 1 or 0)

	setTimer(updateMow, 1000, 1)

	if localPlayer.vehicle and localPlayer.vehicle.model == Config.vehicle then

		local anim = getAnimData('vehicle-blade')

		local rx, ry, rz = getVehicleComponentRotation(localPlayer.vehicle, 'grass_blade')
		setVehicleComponentRotation(localPlayer.vehicle, 'grass_blade', rx,ry,rz + anim*30)

	end

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'work.current' then

		local func = ( new == Config.resourceName ) and addEventHandler or removeEventHandler
		func('onClientRender', root, renderBlade)

	end

end)