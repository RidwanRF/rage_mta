
function addPlayerXP(player, amount)
	return increaseElementData(player, 'xp', amount, false)
end


function setPlayerLevel(player, level)
	player:setData('xp', level*3600, false)
end