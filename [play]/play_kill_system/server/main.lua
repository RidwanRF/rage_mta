


addEventHandler('onPlayerWasted', root, function( _, killer, weapon )

	if isElement(killer) and ( killer.team ~= source.team or ( killer.team == source.team and not killer.team ) ) then

		if not killer.vehicle then

			if weapon == 4 then
				increaseElementData( killer, 'knife_kills', 1, false )
			else
				increaseElementData( killer, 'kills', 1, false )
				increaseElementData( killer, 'kills.'..weapon, 1, false )
			end

			exports.main_freeroam:updatePlayerAchievments( killer )
			exports.main_sounds:playSound( killer, 'kill' )

		end

	end

end)