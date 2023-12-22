
------------------------------------------------------------------------

	function givePlayerOxygen(player, oxygen)
		player:setData('diver.oxygen_max', oxygen)
		return player:setData('diver.oxygen', oxygen, false)
	end

------------------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if dn == 'diver.oxygen' and source.type == 'player' then
			triggerClientEvent(source, 'diver.catchOxygen', resourceRoot, new)
		end

	end)

------------------------------------------------------------------------

	function useOxygen(player)

		local oxygen = player:getData('diver.oxygen') or 0

		if oxygen > 0 then
			increaseElementData(player, 'diver.oxygen', -2, false)
		end

		if oxygen == 2 then
			exports.hud_notify:notify(player, 'Внимание', 'У вас закончился кислород')
		end

	end

------------------------------------------------------------------------

	setTimer(function()

		for player in pairs( playersWork ) do

			local _, _, z = getElementPosition(player)

			if isElementInWater(player) and z < -2 then
				useOxygen(player)
			end

		end

	end, 2000, 0)

------------------------------------------------------------------------
