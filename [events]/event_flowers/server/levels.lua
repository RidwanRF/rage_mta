

---------------------------------------------------

	function handleFlowerCollect( player, flower_type )

		local level_progress = player:getData('flowers.level_progress') or {}

		local nextLevel = (player:getData('flowers.level') or 0) + 1
		local nextLevel_config = Config.levels[ nextLevel ]

		if not nextLevel_config then

			exports.hud_notify:notify(player, 'Весенний движ', 'Вы прошли все уровни')
			return false

		end

		if ( level_progress[ flower_type ] or 0 ) >= nextLevel_config.requirements[ flower_type ] then

			exports.hud_notify:notify(player, 'Вы собрали такие цветы', 'Ищите другие')
			return false

		end

		level_progress[ flower_type ] = ( level_progress[ flower_type ] or 0 ) + 1

		local completed = true

		for _, flower_type in pairs( Config.flowerTypes ) do

			if ( level_progress[ flower_type.type ] or 0 ) < nextLevel_config.requirements[ flower_type.type ] then

				completed = false
				break

			end

		end

		player:setData('flowers.level_progress', level_progress)

		if completed then
			completePlayerLevel( player )
		end

		return true

	end

---------------------------------------------------

	function completePlayerLevel( player )

		local level = player:getData('flowers.level') or 0
		level = level + 1

		local config = Config.levels[level]

		for _, reward in pairs( config.rewards ) do
			reward.give( player )
		end

		exports.hud_notify:notify( player, 'Весенний движ', ('Вы разблокировали уровень %s'):format(level) )

		player:setData('flowers.level', level)
		player:setData('flowers.level_progress', {})

	end

---------------------------------------------------