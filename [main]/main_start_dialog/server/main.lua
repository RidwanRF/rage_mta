
----------------------------------------------------------------

	exports.save:addParameter('start_dialog', nil, true)
	exports.save:addParameter('start_bonus', nil, true)

----------------------------------------------------------------

	addEvent('npc_start.completeStart', true)
	addEventHandler('npc_start.completeStart', resourceRoot, function()

		client:setData('start_dialog', 1)

	end)

----------------------------------------------------------------

	addEvent('npc_start.takeBonus', true)
	addEventHandler('npc_start.takeBonus', resourceRoot, function()

		if client:getData('start_bonus') ~= 1 then

			Config.startBonus.give(client)
			client:setData('start_bonus', 1)

		end

	end)

----------------------------------------------------------------

	addEvent('npc_start.trackGraphicsChoice', true)
	addEventHandler('npc_start.trackGraphicsChoice', resourceRoot, function( choice )

		exports.logs:addLog(
			'[START][GRAPHICS_CHOICE]',
			{
				data = {
					player = client.account.name,
					choice = choice,
				},	
			}
		)

	end)

----------------------------------------------------------------