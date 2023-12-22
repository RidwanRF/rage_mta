

---------------------------------------------

	local prev_position

---------------------------------------------

	function renderMatchColshape()

		local match_data = localPlayer:getData('event_shooter.match.data')
		if not match_data then return end

		if isElement(match_data.colshape) then
			
			if not isElementWithinColShape( localPlayer.vehicle or localPlayer, match_data.colshape ) then
				localPlayer.health = math.clamp( localPlayer.health - 0.6, 0, 100 )
			-- 	prev_position = { getElementPosition( localPlayer.vehicle or localPlayer ) }
			-- elseif prev_position then
			-- 	setElementPosition( localPlayer.vehicle or localPlayer, unpack(prev_position) )
			end

		end
		
	end

---------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn,old,new)

		if dn == 'event_shooter.match.data' then

			if new then
				addEventHandler('onClientRender', root, renderMatchColshape)
			else
				removeEventHandler('onClientRender', root, renderMatchColshape)
			end

		end

	end)

---------------------------------------------