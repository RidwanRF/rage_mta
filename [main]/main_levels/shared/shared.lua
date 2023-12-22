

function getPlayerLevel(player, _xp)
	local xp = _xp or (player:getData('xp') or 0)
	return math.floor(xp/3600)
end
