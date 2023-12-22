
------------------------------------------------

	function renderDisplay()

		local floor = localPlayer:getData('used.floor') or 0
		if floor == 0 then return toggleDisplayRender(false) end
		dxDrawTextShadow(('%s этаж'):format( floor ),

			30, ( real_sy - px(30) ) * sx/real_sx,
			30, ( real_sy - px(30) ) * sx/real_sx,
			tocolor(255,255,255,255),
			0.5, getFont('montserrat_bold', 50, 'light'),
			'left', 'bottom', 1, tocolor( 0, 0, 0, 50 ), nil, dxDrawText

		)

	end

------------------------------------------------

	function toggleDisplayRender(flag)

		local func = flag and addEventHandler or removeEventHandler
		return func('onClientRender', root, renderDisplay)

	end

------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'used.floor' then
			toggleDisplayRender( not not new )
		end

	end)


------------------------------------------------