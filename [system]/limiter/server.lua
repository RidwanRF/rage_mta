
--------------------------------------------------------------------------------

	-- exports.save:addParameter('cheater', nil, true)

	-- addEventHandler('onElementDataChange', root, function(dn, old, new)

	-- 	if dn == 'money' and (new or 0) < 0 and not exports.acl:isAdmin(source) then
	-- 		source:setData('cheater', 1)
	-- 	end

	-- end)

--------------------------------------------------------------------------------

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do
			if player.ping >= 500 and player.dimension > 0 then
				kickPlayer(player, 'Высокий пинг')
			end
		end

	end, 5000, 0)

--------------------------------------------------------------------------------