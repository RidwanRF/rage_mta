

--------------------------------------------


	function toggleCase(player, flag)

		if flag then

			exports.main_inventory:removeInventoryItem({
				player = player,
				key = 'rich_case',
			})

			exports.main_inventory:addInventoryItem({

				player = player,
				item = 'case_1',
				data = { rich_case = true },
				count = 1,

			})

		else

			exports.main_inventory:removeInventoryItem({
				player = player,
				key = 'rich_case',
			})

		end

	end

--------------------------------------------

	update_case_queue = {}

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if dn == 'money' and source.type == 'player' then
			update_case_queue[source] = ( new or 0 ) >= Config.caseMoney
		end

	end)

--------------------------------------------

	setTimer(function()

		for player, flag in pairs( update_case_queue ) do
			toggleCase(player, flag)
		end

		update_case_queue = {}

	end, 5000, 0)

--------------------------------------------