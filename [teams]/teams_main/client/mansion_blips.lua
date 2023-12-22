

------------------------------------------------------------

	local mansionBlips = {}

	function removeMansionBlip( marker )

		if isElement( mansionBlips[marker] ) then

			destroyElement( mansionBlips[marker] )
			mansionBlips[marker] = nil

		end

	end

	function updateMansionBlip( marker )

		removeMansionBlip( marker )

		local blip = createBlipAttachedTo( marker, 0 )

		local m_data = marker:getData('mansion.data') or {}

		local blip_icon = 'used'

		if not m_data.owner then
			blip_icon = 'free'
		elseif m_data.owner == localPlayer:getData('team.id') then
			blip_icon = 'own'
		end

		blip:setData('icon', 'mansion_'..blip_icon)

	end

------------------------------------------------------------

	function updateMansionBlips()

		for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do

			if marker:getData('mansion.data') then

				updateMansionBlip( marker )

			end

		end

	end

------------------------------------------------------------

	addEventHandler('onClientElementDataChange', resourceRoot, function( dn, old, new )

		if dn == 'mansion.data' then
			updateMansionBlip( source )
		end

	end)

------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, updateMansionBlips)

------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
		if dataName == 'unique.login' then
			updateMansionBlips()
		end
	end)

------------------------------------------------------------