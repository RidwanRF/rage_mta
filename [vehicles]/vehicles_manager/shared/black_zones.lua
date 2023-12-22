

local colshapes = {
	createColSphere( -1918.17, -1510.56, 28.8, 50 ),
	createColSphere( -2071.59, -147.85, 35.32, 50 ),
	-- createColSphere( -2660.97, -279.44, 7.54, 50 ),

	createColSphere( 1255.5, -2026.23, 59.55, 40 ),
	createColSphere( 2754.06, -2535.56, 15.66, 70 ),
	-- createColSphere( 2623.21, 1207.94, 11.02, 15 ),
	createColSphere( 2515.08, 2781.45, 10.82, 30 ),
	createColSphere( 217.2, -1425.15, 13.19, 6 ),
	createColSphere( 1781.43, -1298.08, 13.38, 15 ),
	createColSphere( 1795.16, -1298.25, 13.38, 15 ),
	createColSphere( -1989.17, -2373.68, 30.62, 15 ),
	createColSphere( 2020.85, 1007.9, 10.82, 15 ),
}

if localPlayer then

	function isPlayerManagerCompatible()

		if exports.main_house:isPlayerNearFlat( localPlayer ) then
			return false
		end

		for _, shape in pairs( colshapes ) do
			if isElementWithinColShape(localPlayer, shape) then
				return false
			end
		end

		return localPlayer.dimension == 0 and localPlayer.interior == 0
	end

else

	addEventHandler('onColShapeHit', resourceRoot, function(element)

		if element.type == 'vehicle' and element:getData('id') then

			if element.occupant then
				exports.hud_notify:notify(element.occupant, 'Автомобиль убран', 'Вы попали в пешеходную зону')
			end

			exports.vehicles_main:clearVehicle( nil, nil, element )

		end

	end)

end
