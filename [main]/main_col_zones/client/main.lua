
Config = {}

Config.zones = {
	{ 1384.86, 691.7, 10.82, 50 },
	{ -2339.2, -158.88, 42.42, 100 },
	{ 548.22, -1290.5, 17.22, 100 },
	{ 1881.04, 2241.12, 18.85, 100 },
	{ -1351.85, -253.09, 14.14, 350 },
	{ -2609.17, 1417.54, 7.56, 50 },
	{ 1377.36, 758.42, 10.81, 50 },
	{ 18.69, -42.29, 12.71, 30 },
	{ 2637.39, 1201.12, 10.82, 50 },
	{ 208, -1434.71, 13.16, 20 },
	{ 2285.83, 1282.54, 10.82, 30 },
}

local zones = {}

for _, zone in pairs( Config.zones ) do

	local shape = createColSphere(unpack(zone))
	zones[shape] = true

end


function isPlayerInWhiteZone(player)

	if exports.main_house:isPlayerNearFlat( player ) then
		return true
	end

	if player.interior > 0 then return true end

	for zone in pairs(zones) do
		if isElementWithinColShape(player, zone) then
			return true
		end
	end

	return false

end

addEventHandler('onClientPlayerDamage', localPlayer, function()

	if isPlayerInWhiteZone(localPlayer) then
		cancelEvent()
	end

end)

addEventHandler('onClientColShapeHit', resourceRoot, function(element)

	if element == localPlayer.vehicle and localPlayer.vehicle:getData('id') then
		toggleCollision(false)
		-- exports.hud_main:addPlayerHUDIcon(localPlayer, 'col_zone')
	end

end)

addEventHandler('onClientColShapeLeave', resourceRoot, function(element)

	if element == localPlayer.vehicle and localPlayer.vehicle:getData('id') then
		toggleCollision(true)
		-- exports.hud_main:removePlayerHUDIcon(localPlayer, 'col_zone')
	end
	
end)
