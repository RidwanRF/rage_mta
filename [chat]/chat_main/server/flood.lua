
local lastMessages = {}

function handlePlayerFlood(player)
	if exports.acl:isModerator(player) then return end

	local tick = getTickCount()

	if lastMessages[player] then

		if (tick - lastMessages[player].timestamp) > Config.floodDetect.time then
			lastMessages[player] = { timestamp = getTickCount(), count = 1 }
		end

		lastMessages[player].count = lastMessages[player].count + 1
		lastMessages[player].timestamp = getTickCount()
	else
		lastMessages[player] = { timestamp = getTickCount(), count = 1 }
	end

	if lastMessages[player].count >= Config.floodDetect.messages then
		addPlayerMute(player, Config.floodDetect.mute)
		return true
	end

end