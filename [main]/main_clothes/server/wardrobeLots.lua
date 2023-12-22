
function calculatePlayerWardrobeLots(player)
	if not player.account then return 0, 1 end

	local lotsCurrent, lotsAll = 0, Config.defaultLotsCount

	local lotsCurrent = getTableLength( player:getData('wardrobe') or {} )

	lotsAll = lotsAll + (player:getData('clothes.extended') or 0)

	player:setData('clothes.loaded', lotsCurrent)
	player:setData('clothes.all', lotsAll)

	return lotsCurrent, lotsAll
end

function updatePlayerWardrobeLots(player)

	if not player.account then return end

	local lotsCurrent, lotsAll = calculatePlayerWardrobeLots(player)
	player:setData('clothes.loaded', lotsCurrent)
	player:setData('clothes.all', lotsAll)

end

addEventHandler('onPlayerLogin', root, function()
	updatePlayerWardrobeLots(source)
end, true, 'low')

addEventHandler('onResourceStart', resourceRoot, function()
	for _, player in pairs( getElementsByType('player') ) do
		updatePlayerWardrobeLots(player)
	end
end)