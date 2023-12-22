

local usedNicknames = {}
for _, account in pairs( getAccounts() ) do

	local nickname = account:getData('character.nickname')
	if nickname then
		usedNicknames[nickname] = true
	end

end

function isNicknameFree(nickname)
	return not usedNicknames[nickname] and not getPlayerFromName(nickname)
end

addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'character.nickname' and new then
		setPlayerName(source, clearColorCodes(new))
	end
end)

addEventHandler('onPlayerChangeNick', root, function(oldName, newName)
	local nickname = source:getData('character.nickname')
	if nickname ~= newName then
		setPlayerName(source, oldName)
	else
		usedNicknames[oldName] = nil
		usedNicknames[newName] = nil
	end
end)

