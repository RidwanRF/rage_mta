

----------------------------------------------------------------

	local controls = {'jump', 'enter_exit', 'fire'}

	function setPlayerControlsState(player, state)
		for _, control in pairs( controls ) do
			toggleControl(player, control, state)
		end
	end

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if dn == 'loader.crate' and isElement(new) then

			setPlayerControlsState( source, false )
			setPedAnimation(source, "CARRY", "crry_prtial", 1, true, true, false)

		end

	end)

	addEventHandler('onElementDestroy', resourceRoot, function()

		local loader = source:getData('crate.loader')

		if isElement(loader) then

			setPlayerControlsState( loader, true )

			setPedAnimation(loader, "CARRY", "putdwn", 1, false, true, false, true)
		    setTimer(setPedAnimation, 1000, 1, loader, "ped", "IDLE_tired", -1, true, false, true, true)
		    setTimer(setPedAnimation, 2000, 1, loader)

		end

	end)

----------------------------------------------------------------