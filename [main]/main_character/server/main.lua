


addEventHandler('onPlayerLogin', root, function()
	if source:getData('character.state') ~= 'created' then

		fadeCamera(source, false, 0.5)

		setTimer(function(source)
			triggerClientEvent(source, 'character_create.open', source, 'main')
			fadeCamera(source, true, 0.5)
		end, 1000, 1, source)

	end
end, true, 'low-2')

function createCharacter(name, skin)

	if not exports.main_nickname:isNicknameFree(name) and name ~= clearColorCodes(client.name) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Никнейм уже используется')
	end

	client:setData('character.state', 'created')
	client:setData('character.skin', skin)
	client:setData('character.nickname', name)

	exports.play_main:doPlayerCome(client)

	triggerClientEvent(client, 'character.create.closeWindow', client)

	exports.logs:addLog(
		'[CHAR][CREATE]',
		{
			data = {
				player = client.account.name,
				name = name,
				skin = skin,
			},	
		}
	)

end
addEvent('character.create', true)
addEventHandler('character.create', resourceRoot, createCharacter)

addEventHandler('onPlayerChangeNick', root, function(old, new, byPlayer)
	if not byPlayer then return end
	if not source.account then return end

	local nickname = source.account:getData('character.nickname')
	if nickname then
		if nickname ~= new then
			cancelEvent()
			setPlayerName(source, clearColorCodes(old))
		end
	end
end)