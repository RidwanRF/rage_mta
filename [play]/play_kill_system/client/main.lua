

addEventHandler('onClientPlayerDamage', localPlayer, function( attacker )

	if isElement(attacker) and
		((localPlayer.dimension == 0 and attacker.type == 'player' and attacker.team == localPlayer.team and attacker.team)
		or
		(attacker.type == 'vehicle'))
	then

		cancelEvent()

	end

end)


addEventHandler('onClientPlayerDamage', localPlayer, function( attacker, dmg_causing, bodypart, loss )

	if isElement(attacker) and loss and bodypart == 9 then


		if not (
			localPlayer.dimension > 0
			and localPlayer:getData('team.match.data')
			and localPlayer:getData('team.match.immortal')
		) and not (

			localPlayer.dimension == 0 and (
			((attacker.type == 'player' and attacker.team == localPlayer.team and attacker.team)
			or
			(attacker.type == 'vehicle')))

		) and not (
			exports.jobs_main:getPlayerWork( localPlayer )
		) and not (
			exports.main_weapon_zones:isPlayerInZone( localPlayer )
		) then
			localPlayer.health = math.clamp( localPlayer.health - loss, 0, 100 ) 
		end

	end

end)

------------------------------------------------------------------------

	local health_table = {}

	addEventHandler('onClientPlayerDamage', root, function( attacker, dmg_type, _, loss )

		if attacker == localPlayer and dmg_type ~= 0 then

			health_table[ source ] = source.health

			setTimer(function(player)

				if health_table[player] and player.health <= health_table[player] then
					exports.main_sounds:playSound( 'hit' )
				end

			end, 50, 1, source)

		end

	end)


------------------------------------------------------------------------

	addEventHandler ( "onClientPlayerStealthKill", root,
		function ( player ) cancelEvent() end
	)

------------------------------------------------------------------------