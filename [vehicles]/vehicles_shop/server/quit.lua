
function handlePlayerQuit(player)

	local data = player:getData('autoshop.savedPos') or {}
	setElementPosition(player, unpack(data.pos))
	setElementRotation(player, 0, 0, data.r or 0)

	player:setData('autoshop.savedPos', false)

	player.interior = 0
	player.dimension = 0

	setCameraTarget(player, player)

	player:setData('speed.hidden', false)
	player:setData('hud.hidden', false)
	player:setData('radar.hidden', false)
	player:setData('notify.hidden', false)

	finishPreview(player)
		
end

addEventHandler('onPlayerQuit', root, function()
	if source:getData('autoshop.savedPos') then
		handlePlayerQuit(source)
	end
end, true, 'high+2')

addEventHandler('onResourceStop', resourceRoot, function()
	for _, player in pairs( getElementsByType('player') ) do
		if player:getData('autoshop.savedPos') then
			handlePlayerQuit(player)
		end
	end
end)