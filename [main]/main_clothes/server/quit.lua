
function handlePlayerQuit(player)

	local data = player:getData('clothes.savedPos') or {}

	player.dimension = 0
	player.interior = 0

	setElementPosition(player, unpack(data.pos))
	setElementRotation(player, 0, 0, data.r or 0)
	setCameraTarget(player, player)

	player:setData('clothes.savedPos', false)

end

addEventHandler('onPlayerQuit', root, function()
	if source:getData('clothes.savedPos') then

		handlePlayerQuit(source)
		
	end
end, true, 'high+2')

addEventHandler('onResourceStop', resourceRoot, function()
	for _, player in pairs( getElementsByType('player') ) do
		if player:getData('clothes.savedPos') then
			handlePlayerQuit(player)
		end
	end
end)