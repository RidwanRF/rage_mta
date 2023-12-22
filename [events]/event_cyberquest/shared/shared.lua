

------------------------------------

	function getPlayerLevel( player )
		return player:getData('cyberquest.level') or 0
	end

------------------------------------

	function getToNextLevel( player )

		local level = getPlayerLevel( player )

		local level_data = Config.levels[ level ]
		local next_level_data = Config.levels[ level + 1 ]

		if next_level_data then
			return next_level_data.energy
		else
			return level_data.energy
		end

	end

------------------------------------