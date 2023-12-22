
playerIds = {}

addEventHandler('onPlayerJoin', root, function()
	local id = 1
	while playerIds[id] do
		id = id + 1
	end
	source:setData('dynamic.id', id)
	playerIds[id] = true
end)

addEventHandler('onPlayerQuit', root, function()
	local id = source:getData('dynamic.id')
	if id then
		playerIds[id] = nil
	end
end)