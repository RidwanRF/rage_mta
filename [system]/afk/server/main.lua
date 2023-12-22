

afk_queue = {}

setTimer(function()

	for player, data in pairs( afk_queue ) do

		if not player.vehicle then

			-- setElementFrozen( player, data.flag )
			setElementAlpha( player, data.flag and 128 or 255 )
			setElementCollisionsEnabled( player, not data.flag )
			
		end

	end

	afk_queue = {}

end, 1000, 0)

addEventHandler('onElementDataChange', root, function(dn, old, new)

	if dn == 'isAFK' and source.type == 'player' then

		afk_queue[source] = { flag = new }

	end

end)