
function getPlayerWithdraws(player)
	return player:getData('police.withdraws') or 0
end


function getPlayerStars(player)
	return player:getData('police.stars') or 0
end