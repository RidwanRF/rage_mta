local tpCoolDown = {}

function doInteriorTeleport(intId)

	local interior = Config.interiors[intId]

	fadeCamera(client, false, 0.5)

	setTimer(function(player, position)

		if not offset then offset = { coords = {0,0,0,0} } end
		
		if tpCoolDown[player] then
			if getTickCount() - tpCoolDown[player] < 2000 then return end
		end

		if not isElement(player) then return end

		fadeCamera(player, true, 0.5)

		local x,y,z,r = unpack(position.coords)
		local dx,dy,dz,dr = unpack(position.offset or {0,0,0,0})

		setElementPosition(player, x + dx, y + dy, z + dz + 1)
		setElementRotation(player, 0, 0, r)

		player.interior = position.int or 0
		player.dimension = position.dim or 0

		tpCoolDown[player] = getTickCount()

	end, 600, 1, client, interior.teleport)

end
addEvent('interior.doTeleport', true)
addEventHandler('interior.doTeleport', resourceRoot, doInteriorTeleport)