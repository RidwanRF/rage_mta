

------------------------------------------------
	
	local ghettoPlay = {}

------------------------------------------------

	function resetPlayerGhettoScore( _player )

		local player = _player or source
		if not isElement(player) then return end

		ghettoPlay[player] = nil

	end

	addEventHandler('onPlayerWasted', root, resetPlayerGhettoScore)
	addEventHandler('onPlayerQuit', root, resetPlayerGhettoScore)

------------------------------------------------
	
	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do


			if exports.main_weapon_zones:isPlayerInGhetto( player ) and not player:getData('isAFK') then

				ghettoPlay[player] = ( ghettoPlay[player] or 0 ) + 1

				if ghettoPlay[player] >= 60 then

					increaseElementData( player, 'ghetto.played', 1, false )
					resetPlayerGhettoScore( player )

				end

			end

		end

	end, 60000, 0)

------------------------------------------------