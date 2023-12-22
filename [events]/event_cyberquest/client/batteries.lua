

----------------------------------------------------------------

	local batteryCollect = {}
	local batteryCollect_anim = {}
	local batteryCollect_round_anim = {}

----------------------------------------------------------------

	setAnimData( batteryCollect_anim, 0.1 )
	setAnimData( batteryCollect_round_anim, 0.1 )

----------------------------------------------------------------

	addEvent('cyberquest.syncBatteryCollect', true)
	addEventHandler('cyberquest.syncBatteryCollect', resourceRoot, function( timestamp )


		if timestamp then

			batteryCollect = { timestamp = timestamp }

			setAnimData( batteryCollect_anim, 0.1 )
			animate( batteryCollect_anim, 1 )

			setAnimData( batteryCollect_round_anim, 0.1 )

			addEventHandler('onClientRender', root, renderBatteryCollect)

		else

			animate( batteryCollect_anim, 0, function()
				batteryCollect = {}
			end )

		end

	end)

----------------------------------------------------------------

	function renderBatteryCollect()

		local anim, target = getAnimData( batteryCollect_anim )

		if target == 0 and anim <= 0.01 then
			return removeEventHandler('onClientRender', root, renderBatteryCollect)
		end

		local alpha = getEasingValue( anim, 'InOutQuad' )

		if not batteryCollect.timestamp then return end

		local server_timestamp = getServerTimestamp().timestamp
		local started_timestamp = batteryCollect.timestamp

		local progress = (server_timestamp - started_timestamp) / math.floor( Config.markers.battery.collect_timeout / 1000 )
		animate( batteryCollect_round_anim, progress )

		local progress_anim = getAnimData( batteryCollect_round_anim )

		
		local w,h = 300,60
		local rw,rh = 44,44

		local round_texture = getDrawingTexture( 'assets/images/battery/round.png' )

		local x,y = sx/2 - w/2, ( real_sy - px(300) ) * sx/real_sx

		dxDrawImage(
			x,y,w,h, 'assets/images/battery/bg.png',
			0, 0, 0, tocolor( 25,24,38,255*alpha )
		)

		local rx,ry = x + 15, y+h/2-rh/2

		dxDrawImage(
			rx,ry,rw,rh, round_texture,
			0, 0, 0, tocolor( 60, 60, 80, 255*alpha )
		)

		local mask = getRoundMask( round_texture, {

			color = { 215,0,150, 255 },
			alpha = alpha,

			angle = { 0, 360 * progress_anim },

		} )

		dxDrawImage(
			rx,ry,rw,rh, mask
		)

		local tw,th = 52,52
		local tx,ty = rx+rw/2-th/2, ry+rh/2-th/2

		dxDrawImage(
			tx,ty,tw,th, 'assets/images/battery/timer.png',
			0, 0, 0, tocolor( 255,255,255,255*alpha )
		)

		dxDrawText('Идет сбор аккумулятора...',
			rx + rw + 10, ry,
			rx + rw + 10, ry+rh,
			tocolor( 255,255,255,255*alpha ),
			0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
			'left', 'center'
		)


	end

----------------------------------------------------------------