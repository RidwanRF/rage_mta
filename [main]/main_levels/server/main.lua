
function updatePlayerLevel(player, xp)

	if not player.account then return end

	local oldLevel = player.account:getData('level') or 1
	local newLevel = getPlayerLevel(player, xp)

	if newLevel ~= oldLevel then
		
		player:setData('level', newLevel)

		if newLevel > oldLevel then

			exports.hud_notify:notify(player,
				'Стаж', string.format('+1 час стажа', newLevel), 3000)

			increaseElementData(player, 'temp.level', 1, false)

			for i = 1, newLevel do

				if (i%10) == 0 then
					increaseElementData(player, 'levels.reached.'..i, 1, false)
				end

			end

		end

	end

end

addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'xp' and new then
		updatePlayerLevel(source, new)
	end
end)

setTimer(function()

	for _, player in pairs( getElementsByType('player') ) do
		if not exports.afk:isAFK(player) then
			addPlayerXP(player, 5*60)
		end
	end

end, 5*60000, 0)