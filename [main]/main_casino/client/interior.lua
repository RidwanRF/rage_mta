

----------------------------

	addEventHandler('onClientRender', root, function()

		if localPlayer.interior == Config.casinoInterior.interior and 
			localPlayer.dimension == Config.casinoInterior.dimension
		then

			toggleControl( 'fire', false )

		end

	end)

----------------------------

