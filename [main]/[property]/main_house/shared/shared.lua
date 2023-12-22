
function isPlayerNearFlat(player)

	for _, colshape in pairs( getElementsByType('colshape', resourceRoot) ) do

		if colshape:getData('flat.colshape') and colshape.dimension == player.dimension and colshape.interior == player.interior then
			if isElementWithinColShape( player, colshape ) then
				return true
			end
		end

	end

end