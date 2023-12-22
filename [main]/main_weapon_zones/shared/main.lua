
loadstring( exports.core:include('common'))()

Config = {}

Config.zones = {
}

local zones = {}

for _, zone in pairs( Config.zones ) do

	local shape = createColSphere(unpack(zone))
	zones[shape] = true

end

local ghetto = {
	1654.28, -2077.61,
	1658.8, -2156.56, 
	1972.09, -2156.58,
	2040.59, -2156.68,
	2062.58, -2158.26,
	2084.08, -2164.28,
	2103.01, -2173.68,
	2120.34, -2186.7, 
	2142.25, -2208.02,
	2184.77, -2165.45,
	2241.18, -2109.02,
	2283.72, -2066.42,
	2295.61, -2054.87,
	2301.91, -2050.1, 
	2310.85, -2045.08,
	2319.15, -2042.07,
	2328.95, -2039.93,
	2704.18, -2039.57,
	2812.91, -2039.6, 
	2813.07, -1900.75,
	2813.1, -1880.3,
	2815.44, -1821.47,
	2823.83, -1757.48,
	2830.12, -1718.3, 
	2843.51, -1667.49,
	2849.65, -1647.54,
	2871.62, -1579.97,
	2884.78, -1533.84,
	2894.26, -1486.24,
	2897.27, -1445.21,
	2895.55, -1403.47,
	2890.47, -1361.08,
	2883.23, -1318.46,
	2867.6, -1233.13, 
	2861.62, -1189.45,
	2858.62, -1146.86,
	2858.1, -1099.2,
	2858.2, -1072.6,
	2858.8, -1041.31, 
	2828.2, -1039.89, 
	2747, -1037.91,
	2692.5, -1037.89, 
	2512.67, -1037.94,
	2499.24, -1036.87,
	2485.34, -1031.51,
	2474.22, -1026.75,
	2450.61, -1023.72,
	2437.88, -1024.07,
	2424.65, -1025.89,
	2410.91, -1029.74,
	2401.19, -1034.98,
	2386.45, -1049.09,
	2378.29, -1055.9, 
	2367.54, -1061.11,
	2347.89, -1066.48,
	2330.15, -1069.37,
	2313.4, -1069.34, 
	2297.64, -1066.29,
	2281.48, -1059.32,
	2269.32, -1051.05,
	2248.76, -1031.15,
	2238.17, -1021.71,
	2225.71, -1014.01,
	2205.71, -1004.49,
	2197.88, -1001.44,
	2157.08, -993.65, 
	2131.33, -986.07, 
	2112.33, -980.48, 
	2090.78, -974.83, 
	2068.06, -969.25, 
	2046.27, -968.19, 
	2026.97, -972.25, 
	2010.53, -981.21, 
	1994.41, -998.17,
	1984.01, -1016.44,
	1975.69, -1040.61,
	1960.66, -1037.12,
	1950.09, -1035.12,
	1928.56, -1034.12,
	1897.42, -1030.45,
	1881.56, -1034.05,
	1868.7, -1042.72,
	1860.02, -1055.53,
	1856.9, -1070.97,
	1856.93, -1171,
	1838.51, -1170.6,
	1838.25, -1175.89,
	1839.44, -1501.14,
	1826.26, -1541.79,
	1815.15, -1602.87,
	1814.46, -1823.58,
	1793.48, -1824.35,
	1719.11, -1805.44,
	1696.05, -1804.85,
	1695.98, -1857.55,
	1687.71, -1870.17,
	1674.99, -1878.67,
	1678.08, -2073.58,
	1656.38, -2071.58,
}

local ghettoShape = createColPolygon( 1645.22, -2173.47,
	unpack( ghetto )
)
zones[ghettoShape] = true

function getGhettoZone()
	return ghetto
end

function isPlayerInGhetto( player )
	return isElementWithinColShape( player, ghettoShape )
end

function isPlayerInZone(player)

	if player:getData('team.match.data') and localPlayer.dimension > 0 then return false end
	if player:getData('event_shooter.match.data') and localPlayer.dimension > 0 then return false end

	if exports.jobs_main:getPlayerWork( player ) then
		return true
	end

	if exports.main_house:isPlayerNearFlat( player ) then
		return true
	end

	for _, marker in pairs( getElementsByType('marker', getResourceRoot('teams_main'), true) ) do

		if marker:getData('mansion.data') and getDistanceBetween( player, marker ) < 15 then
			return true
		end

	end

	for zone in pairs(zones) do
		if isElementWithinColShape(player, zone) then
			return false
		end
	end

	return true

end

if localPlayer then

	addEventHandler('onClientColShapeHit', resourceRoot, function(element)

		if element == localPlayer then
			exports.hud_main:removePlayerHUDIcon(localPlayer, 'weapon_zone')
		end

	end)

	addEventHandler('onClientColShapeLeave', resourceRoot, function(element)

		if element == localPlayer then
			exports.hud_main:addPlayerHUDIcon(localPlayer, 'weapon_zone')
		end
		
	end)

	addEventHandler('onClientKey', root, function(key, state)

		if key == 'f' and getKeyState('mouse2') and isPlayerInZone(localPlayer) then
			cancelEvent()
		end

	end)

	addEventHandler('onClientPlayerDamage', localPlayer, function( attacker, damage )

		if isPlayerInZone(localPlayer) and damage < 50 then
			cancelEvent(  )
		end

	end)

else

	addEventHandler('onColShapeHit', resourceRoot, function(element)

		if element.type == 'player' then
			removePedJetPack( element )
		end

	end)

end