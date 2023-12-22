
local timers = {}

function resetChatTimer(player)
	if isTimer(timers[player]) then killTimer(timers[player]) end

	timers[player] = setTimer(function(player)
		if isElement(player) then
			player:setData('chat.lastMessage', nil)
		end
	end, 5000, 1, player)
end

addEventHandler('onPlayerChat', root, function(message, type)

	if type == 0 and not exports.chat_main:isPlayerMuted(source) then
		resetChatTimer(source)
		source:setData('chat.lastMessage', message)
	end

end)