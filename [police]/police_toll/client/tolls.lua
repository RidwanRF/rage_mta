
policeTolls = {}

local blips = {
	createBlip(48.16, -1531.24, 5.32, 42, 2, 255,255,255,255, 0, 250),
	createBlip(-1137.1, 1097.75, 38.54, 42, 2, 255,255,255,255, 0, 250),
	createBlip(1800.47, 810.74, 10.64, 42, 2, 255,255,255,255, 0, 250),
}
for _, blip in pairs(blips) do
	blip:setData('icon', 'toll')
end

local allowedTypes = {
	['Automobile'] = true,
	['Bike'] = true,
	['Monster Truck'] = true
}

addEvent('onBridgeTollHit', true)

function onColShapeHit(theElement, matchingDimension)
	if (theElement == localPlayer) and localPlayer.vehicle and (matchingDimension) then
		local vehicle = localPlayer.vehicle


		if vehicle.controller == localPlayer and allowedTypes[ getVehicleType(vehicle) ] then

			local _, _, z = getElementPosition(localPlayer)
			local actualCollision

			for name, toll in pairs(policeTolls) do
				if source == toll.colshape then
					actualCollision = name
					break
				end
			end

			if not actualCollision then return end

			local tickets = localPlayer:getData('police.tollTickets') or 0

			if tickets > 0 or exports.main_vip:isVip(localPlayer) then
				triggerServerEvent('toll.handlePass', resourceRoot, actualCollision)
			else
				tempToll = actualCollision
				setElementVelocity(vehicle, 0, 0, 0)
				openWindow('main')
			end

			triggerEvent('onBridgeTollHit', root)

		end
	end
end
addEventHandler('onClientColShapeHit', resourceRoot, onColShapeHit)

addEventHandler('onClientResourceStart', resourceRoot, function()

	local objects = getElementsByType('object', resourceRoot)
	policeTolls = {}
	for _, object in pairs(objects) do
		if object.model == 2933 then

			local x,y,z = getElementPosition(object)
			local colshape = createColSphere(x,y,z, 8)

			policeTolls[object] = {
				colshape = colshape,
			}
		end
	end

end)