

function refreshPlayerSpawn(player)

	local x,y,z = getElementPosition(player.vehicle or player)
	setElementPosition(player.vehicle or player, x,y,z+2)

end