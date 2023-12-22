
addEventHandler('onPlayerLogin', root, function()
	source:setData('lastSeen', getRealTime().timestamp)
end)

addEventHandler('onPlayerQuit', root, function()
	source:setData('lastSeen', getRealTime().timestamp)
end)