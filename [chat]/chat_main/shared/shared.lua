
function displayInfo_client(text, color)
	local r,g,b

	if type(color) == 'table' then
		r,g,b = unpack(color)
	else
		r,g,b = hexToRGB(color or '#ffffff')
	end
	
	return outputChatBox(text, r,g,b, true)
end

function displayInfo_server(player, text, color)
	local r,g,b

	if type(color) == 'table' then
		r,g,b = unpack(color)
	else
		r,g,b = hexToRGB(color or '#ffffff')
	end

	return outputChatBox(text, player, r,g,b, true)
end

function displayInfo(...)
	if localPlayer then
		return displayInfo_client(...)
	else
		return displayInfo_server(...)
	end
end

function displayError(player, text, color)
	if localPlayer then
		return displayInfo_client(player, text or '#bb0000')
	else
		return displayInfo_server(player, text, color or '#bb0000')
	end
end
