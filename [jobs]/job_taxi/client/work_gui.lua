
setAnimData('taxi-gui', 0.1)
setAnimData('taxi-gui-loading', 0.1)
setAnimData('taxi-gui-progress', 0.1)

local taxiBg = createTextureSource('bordered_rectangle', 'assets/images/taxibgwork.png', 70, 400, 70)

setTimer(function()

	local animData, target = getAnimData('taxi-gui')

	if animData > 0.01 and target == 1 then
		
		setAnimData('taxi-gui-progress', 0.1)
		animate('taxi-gui-progress', 1)

	end

end, 1800, 0)

setTimer(function()

	local animData, target = getAnimData('taxi-gui')

	if animData > 0.01 and target == 1 then
		
		local _, target = getAnimData('taxi-gui-loading')
		animate( 'taxi-gui-loading', 1-target )

	end

end, 1000, 0)

function render()

	local animData, target = getAnimData('taxi-gui')

	if animData < 0.01 and target == 0 then
		removeEventHandler('onClientRender', root, render)
	end

	local data = localPlayer:getData('work.session') or {}

	if data then

		local w,h = 400, 70
		local x,y = sx/2 - w/2, real_sy*sx/real_sx - (h + 20)*animData

		dxDrawImage(
			x,y,w,h, taxiBg,
			0, 0, 0, tocolor(25,24,38,255*animData)
		)

		local progressAnim = getAnimData('taxi-gui-progress')
		local loadingAnim = getAnimData('taxi-gui-loading')

		drawImageSection(
			x,y,w,h, taxiBg,
			{ x = progressAnim, y = 1 }, tocolor( 60,60,85,255*animData*(1-progressAnim) )
		)

		dxDrawText('Поиск клиента',
			x,y,x+w,y+h,
			tocolor(255,255,255,255*animData),
			0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
			'center', 'center'
		)

		local rw,rh = 30,30
		local ry = y+h/2 - rh/2

		dxDrawImage(
			x + 30 + 20*loadingAnim, ry,
			rw,rh, 'assets/images/lround.png',
			0, 0, 0, tocolor(180,70,70,255*animData)
		)

		dxDrawImage(
			x + 30 + 20 - 20*loadingAnim, ry,
			rw,rh, 'assets/images/lround.png',
			0, 0, 0, tocolor(180,70,70,255*animData)
		)

	end

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'work.current' then

		if new == Config.resourceName then
			addEventHandler('onClientRender', root, render)
			animate('taxi-gui', 1)
		else
			animate('taxi-gui', 0)
		end

	end

end)

addEventHandler('work.onSessionUpdate', resourceRoot, function(session)

	if session then

		if session.order then
			animate('taxi-gui', 0)
		else
			addEventHandler('onClientRender', root, render)
			animate('taxi-gui', 1)
		end

	else

		animate('taxi-gui', 0)
		
	end

end)