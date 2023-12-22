
	
----------------------------------------------------------------

	playersWork = {}

----------------------------------------------------------------

	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		playersWork[player] = {
		}

		createHelpMarker(player)

		player.model = Config.skin

		exports.hud_notify:notify(player, 'На карте указаны газоны', 'Направляйтесь к ним')

	end

----------------------------------------------------------------

	function destroyPlayerWork(player)

		local work = playersWork[player]
		if not work then return end

		player.model = player:getData('character.skin')

		clearTableElements(work)
		playersWork[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerWork(source)
		end

	end)

----------------------------------------------------------------