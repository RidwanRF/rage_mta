

addEventHandler('onPlayerWasted', root, function(_, killer)

	if killer ~= source and isElement(killer) and killer.dimension == 0 and not killer.vehicle then

		addPlayerStars(killer, Config.stars.kill)

	end

end, true, 'high')

-- addEventHandler('onElementDataChange', root, function(dataName, old, new)
-- 	if dataName == 'police.stars' and new then
-- 		setPlayerWantedLevel(source, new)
-- 	end
-- end)

function addPlayerStars(player, count)
	local stars = player:getData('police.stars') or 0
	player:setData('police.stars',  math.clamp(stars + count, 0, 5) )
end

function setPlayerStars(player, count)
	player:setData('police.stars',  math.clamp(count, 0, 5) )
end

function givePrisonByStars(player, mul)
	local stars = player:getData('police.stars') or 0
	exports.police_prison:givePlayerPrison(player, stars * Config.starsPrisonTime * (mul or 1))
	player:setData('police.stars', 0)
end

-- addEventHandler('onServerHourCycle', root, function()

-- 	for _, player in pairs( getElementsByType('player') ) do

-- 		local stars = player:getData('police.stars') or 0
-- 		addPlayerStars(player, -2)

-- 	end

-- end)