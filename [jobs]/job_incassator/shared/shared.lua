function getPlayerLevel(player, _xp)
	local xp = _xp or player:getData('incassator.xp') or 0
	local level = 1
	local nextLevel = 1
	local _data

	local xpProgress = {0, 0}

	for _, data in pairs(Config.levels) do
		if data.xp <= xp then
			level = data.level
			nextLevel = math.min( #Config.levels, data.level+1 )

			xpProgress = { xp - data.xp, Config.levels[nextLevel].xp }
			_data = data
		end
	end

	return level, nextLevel, xpProgress, _data
end
