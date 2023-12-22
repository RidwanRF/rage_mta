
--------------------------------------------------------------------------------

	function sendChatMessage(message)

		local rank = getPlayerRank(client)

		triggerClientEvent(client.team.players, 'clan.receiveMessage', resourceRoot, {

			player = client,
			text = message,
			rank = rank and rank.name or false,
			time = getRealTime().timestamp,

		})

	end
	addEvent('clan.sendMessage', true)
	addEventHandler('clan.sendMessage', resourceRoot, sendChatMessage)

--------------------------------------------------------------------------------