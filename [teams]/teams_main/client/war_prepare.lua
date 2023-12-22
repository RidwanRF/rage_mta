

---------------------------------------------

	local warPrepare_anim = {}
	setAnimData(warPrepare_anim, 0.1, 0)

---------------------------------------------

	function renderWarPrepare()

		local animData, target = getAnimData( warPrepare_anim )
		if target == 0 and animData < 0.01 then
			return removeEventHandler('onClientRender', root, renderWarPrepare)
		end

		local w,h = 500,100
		local x,y = sx/2 - w/2, 40 -200*(1-animData)

		dxDrawImage(
			x,y,w,h, 'assets/images/wpbg.png',
			0, 0, 0, tocolor(21,21,33,255*animData)
		)

		dxDrawText('!',
			x + 30, y,
			x + 30, y+h,
			tocolor(180,70,70,255*animData),
			0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
			'left', 'center'
		)

		local server_timestamp = getServerTimestamp()

		local delta = (server_timestamp.timestamp - warPrepare_data.start)
		local time = warPrepare_data.time - delta

		local m = math.floor( time/60 )
		local s = time - m*60

		dxDrawText(('Бой за территорию начнется через #cd4949%02d:%02d#ffffff'):format( m,s ),
			x + 60, y + h/2,
			x + 60, y + h/2,
			tocolor(255,255,255,255*animData),
			0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
			'left', 'bottom', false, false, false, true
		)


		dxDrawText('Находитесь в обычном мире и покиньте автомобиль!',
			x + 60, y + h/2,
			x + 60, y + h/2,
			tocolor(255,255,255,255*animData),
			0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
			'left', 'top'
		)

	end

---------------------------------------------

	function displayWarPrepare( data, start )

		addEventHandler('onClientRender', root, renderWarPrepare, true, 'low-10000')
		animate(warPrepare_anim, 1)

		local server_timestamp = getServerTimestamp()
		local delta = (server_timestamp.timestamp - start)

		warPrepare_data = data
		warPrepare_data.start = start

		local time = warPrepare_data.time - delta

		setTimer(function()
			animate(warPrepare_anim, 0)
		end, time*1000, 1)

	end
	addEvent('teams.displayWarPrepare', true)
	addEventHandler('teams.displayWarPrepare', resourceRoot, displayWarPrepare)

---------------------------------------------

	addCommandHandler('tm_display_war_prepare', function()

		if exports.acl:isAdmin(localPlayer) then

			displayWarPrepare()

		end

	end)

---------------------------------------------