

addEventHandler('onClientMarkerHit', resourceRoot, function( player, mDim )

	if not player.vehicle and localPlayer == player and mDim and player.interior == source.interior then

		local m_data = source:getData('mansion.data')

		if m_data and not m_data.owner then

			currentMansionData = m_data
			openWindow('buy_mansion')

		elseif m_data and m_data.owner == localPlayer:getData('team.id') then

			currentMansionData = m_data
			openWindow('mansion_menu')


		end


	end

end)