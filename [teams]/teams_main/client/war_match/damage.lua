

addEventHandler('onClientPlayerDamage', localPlayer, function()

	if (
		localPlayer.dimension > 0
		and localPlayer:getData('team.match.data')
		and localPlayer:getData('team.match.immortal')
	) then

		cancelEvent()

	end

end)