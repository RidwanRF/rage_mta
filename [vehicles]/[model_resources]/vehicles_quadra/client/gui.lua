

---------------------------------------------------------------

	local display_anim = {}

	setAnimData( display_anim, 0.1, 0 )

---------------------------------------------------------------

	function renderQuadra()

		local alpha = getAnimData( display_anim )

		local iw,ih = 90,90

		if not rx then
			rx,ry,rw,rh = exports.hud_radar:getRadarCoords()
		end

		local padding = 10

		local startX, startY = rx+rw+30, ry + rh/2 - ih/2

		local server_timestamp = getServerTimestamp().timestamp

		for _, index in pairs({'impulse', 'springboard'}) do

			local ability = Config.abilities[index]

			local q_ability = Quadra_abilities[ index ]

			local animData = getEasingValue( getAnimData( ability.anim ), 'InOutQuad' )
			local d_animData = getEasingValue( getAnimData( ability.d_anim ), 'InOutQuad' )

			dxDrawImage(
				startX, startY, iw,ih, 'assets/images/ability_bg.png',
				0, 0, 0, tocolor( 255,255,255,(100 + 155*d_animData)*alpha )
			)

			local d = 20*animData

			dxDrawText(ability.key,
				startX, startY - d,
				startX + iw, startY + ih,
				tocolor( 255,255,255,255*alpha ),
				0.5, 0.5, getFont('montserrat_bold', 50, 'light', true),
				'center', 'center'
			)

			local tw,th = 35,35
			local tx,ty = startX + 15, startY + ih - th - 5

			dxDrawImage(
				tx,ty,
				tw,th, 'assets/images/timer.png', 
				0, 0, 0, tocolor( 215,0,150,255*alpha*animData )
			)

			if q_ability and q_ability.reload then

				local delta = math.max(q_ability.reload - server_timestamp, 0)

				if delta > 0 then

					dxDrawText(('%02d'):format(delta),
						tx+tw-2,ty,
						tx+tw-2,ty+th,
						tocolor( 255,255,255,255*alpha*animData ),
						0.5, 0.5, getFont('montserrat_bold', 26, 'light', true),
						'left', 'center'
					)

				else

					q_ability.reload = nil

				end

				animate( ability.anim, ( delta > 0 ) and 1 or 0 )
				
			else

				animate( ability.anim, 0 )

			end

			animate( ability.d_anim, (q_ability and q_ability.start) and 1 or 0 )


			startX = startX + iw + padding

		end

	end

---------------------------------------------------------------

	function updateLocalQuadra()

		if isPlayerInQuadra( localPlayer ) then

			animate( display_anim, 1 )
			addEventHandler('onClientRender', root, renderQuadra)
			
		else
				
			animate( display_anim, 0, function()
				removeEventHandler('onClientRender', root, renderQuadra)
			end )

		end


	end

---------------------------------------------------------------

	addEventHandler('onClientPlayerVehicleEnter', localPlayer, function( vehicle, seat )

		if vehicle.model == 587 and seat == 0 then
			updateLocalQuadra()
		end

	end)

---------------------------------------------------------------

	addEventHandler('onClientPlayerVehicleExit', localPlayer, function( vehicle, seat )

		setTimer(updateLocalQuadra, 50, 1)

	end)

---------------------------------------------------------------

	addEventHandler('onClientElementDestroy', root, function()

		if source == localPlayer.vehicle then
			setTimer(updateLocalQuadra, 50, 1)
		end

	end)

---------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for index, ability in pairs( Config.abilities ) do

			ability.anim = {}
			ability.d_anim = {}

			setAnimData( ability.anim, 0.1, 0 )
			setAnimData( ability.d_anim, 0.1, 0 )

		end

		updateLocalQuadra()

	end)

---------------------------------------------------------------