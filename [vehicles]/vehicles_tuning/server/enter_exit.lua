
function enterTuning(exit)

	if not client.vehicle then return end

	-- client:setData('tuning.prevPos', {
	-- 	pos = {getElementPosition(client.vehicle)},
	-- 	rot = {getElementRotation(client.vehicle)},
	-- })

	-- local dimension = client:getData('dynamic.id') or 1

	-- client.interior = Config.interior.interior
	-- client.vehicle.interior = Config.interior.interior

	-- client.dimension = dimension
	-- client.vehicle.dimension = dimension

	-- local x,y,z,r = unpack( Config.interior.pos )
	-- client.vehicle:setPosition(x,y,z)
	-- client.vehicle:setRotation(0, 0, r)

	client.vehicle:setData('engine.disabled', true)

	client:setData('radar.hidden', true)
	client:setData('speed.hidden', true)

	local x,y,z,rx,ry,rz = unpack(exit)

	for _, occupant in pairs( getVehicleOccupants( client.vehicle ) ) do
		if occupant ~= client then
			removePedFromVehicle( occupant )
			setElementPosition(occupant, x,y,z)
		end
	end

	-- showChat(client, false)
end
addEvent('tuning.enter', true)
addEventHandler('tuning.enter', resourceRoot, enterTuning)

function exitTuning(_player)
end
addEvent('tuning.exit', true)
addEventHandler('tuning.exit', resourceRoot, exitTuning)

addEventHandler('onPlayerQuit', root, function()
	if source:getData('tuning.prevPos') then

		local prevPos = source:getData('tuning.prevPos')

		if prevPos then
			source:setPosition(unpack( prevPos.pos ))
			source:setRotation(unpack( prevPos.rot ))
			source.interior = 0
			source.dimension = 0
		end

	end
end, true, 'high+10')

-- addEventHandler('onResourceStop', resourceRoot, function()
-- 	for _, player in pairs( getElementsByType('player') ) do
-- 		if player:getData('tuning.prevPos') then
-- 			exitTuning(player)
-- 		end
-- 	end
-- end)

addEventHandler('onVehicleStartExit', root, function(player, seat)
	if player:getData('tuning.interior') then
		cancelEvent()
	end
end)