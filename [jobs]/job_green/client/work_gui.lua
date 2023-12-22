
--------------------------------------------------------

	local animations = {}

--------------------------------------------------------

	function renderWorkGui()

		for marker, position in pairs( animations ) do

			local x,y,z = unpack( position )
			local dx,dy = getScreenFromWorldPosition( x,y,z )

			if dx and dy then

				local anim = getAnimData(marker)
				local text = string.format('$%s', Config.money)

				dxDrawTextShadow('$',
					dx,dy - 200*anim,
					dx,dy - 200*anim,
					tocolor(255,255,255,255*(1-anim)),
					0.5, getFont('montserrat_semibold', 100, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*(1-anim)), false, dxDrawText
				)

			end

		end

	end

--------------------------------------------------------

	function displayMoneyAnimation( marker )

		animations[marker] = { getElementPosition(marker) }

		setAnimData(marker, 0.04)
		animate(marker, 1, function()
			animations[marker] = nil
		end)

	end

--------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'work.current' then

			local func = ( new == Config.resourceName ) and addEventHandler or removeEventHandler
			func('onClientRender', root, renderWorkGui)

		end

	end)

--------------------------------------------------------