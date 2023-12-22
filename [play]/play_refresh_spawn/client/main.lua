

---------------------------------------

	local time = 2000

---------------------------------------

	local animId = {}
	setAnimData(animId, 0.1, 0)

---------------------------------------

	function renderSpawnRefresh()

		animate( animId, isTimer(refreshSpawnTimer) and 1 or 0 )

		local anim, target = getAnimData(animId)

		if anim < 0.01 and target == 0 then
			return removeEventHandler('onClientRender', root, renderSpawnRefresh)
		end

		local w,h = 200, 6
		local x,y = sx/2 - w/2, (real_sy - px(100)) *sx/real_sx

		dxDrawRectangle(
			x,y,w,h, tocolor( 25,24,38,255*anim )
		)

		local left = isTimer(refreshSpawnTimer) and getTimerDetails( refreshSpawnTimer ) or time

		local progress = (time - left)/time

		dxDrawRectangle(
			x,y,w*progress,h, tocolor( 180,70,70,255*anim )
		)

		dxDrawTextShadow('Выполняем респавн...',
			x,y-5,x+w,y-5,
			tocolor(255,255,255,255*anim),
			0.5, getFont('montserrat_semibold', 25, 'light', true),
			'center', 'bottom', 1, tocolor(0, 0, 0, 50*anim), false, dxDrawText
		)


	end

---------------------------------------

	bindKey('delete', 'both', function( key, state )

		if state == 'down' then

			refreshSpawnTimer = setTimer(function()
				triggerServerEvent('play.refreshSpawn', resourceRoot)
			end, time, 1)

			addEventHandler('onClientRender', root, renderSpawnRefresh)

		else

			if isTimer(refreshSpawnTimer) then
				killTimer(refreshSpawnTimer)
			end

		end

	end)	

---------------------------------------