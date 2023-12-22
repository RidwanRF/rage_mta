

---------------------------

	function getVehicleAbilities( vehicle )

		if localPlayer then
			return Quadra_abilities or {}
		else
			return abilities[vehicle] or {}
		end

	end

---------------------------

	function isPlayerInQuadra( player )
		return player.vehicle and player.vehicle.model == 587 and player.vehicleSeat == 0
	end

---------------------------