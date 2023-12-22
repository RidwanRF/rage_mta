

addEventHandler('onClientPlayerDamage', localPlayer, function()

	if (
		localPlayer.dimension > 0
		and localPlayer:getData('event_shooter.match.data')
		and localPlayer:getData('event_shooter.match.immortal')
	) then

		cancelEvent()

	end

end)