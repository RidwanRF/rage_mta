
local fileName = 'autologin.data'

function cacheEnterSettings(login, password)

	local file = fileCreate(fileName)

	local data = toJSON({login, password})
	fileWrite(file, encode(data))

	fileClose(file)

end

function doAutologin()

	if not fileExists(fileName) then return end

	local file = fileOpen(fileName)
	local content = fileRead(file, file.size)
	fileClose(file)

	local data = decode(content)
	local authData = fromJSON(data or '[[]]') or {}

	local login, password = unpack(authData)

	triggerServerEvent('authpanel.authorize', resourceRoot, login, encode(password))

end

addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
	if dataName == 'settings.autologin' and new and not localPlayer:getData('unique.login') then

		doAutologin()

	end
end)


addEventHandler('onClientResourceStart', resourceRoot, function()
	if localPlayer:getData('settings.autologin') and not localPlayer:getData('unique.login') then
		doAutologin()
	end
end)
