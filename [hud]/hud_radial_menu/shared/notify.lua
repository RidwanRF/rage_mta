
function displayInfo(player, text)
	if localPlayer then
		return outputChatBox(''..player, 212, 90, 205, true)
	else
		return outputChatBox(''..text, player, 212, 90, 205, true)
	end
end

function displayWarning(player, text)
	if localPlayer then
		return outputChatBox(''..player, 255, 0, 0, true)
	else
		return outputChatBox(''..text, player, 255, 0, 0, true)
	end
end