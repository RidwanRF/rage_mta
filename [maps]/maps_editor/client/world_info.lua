history = {}

function worldInfo_onRender()

	if not windowOpened then return end

	currentWorldInfo = false

	if not getKeyState('ralt') then return end

	local x,y = 0.5, 0.5

	if isCursorShowing() then
		x,y = getCursorPosition()
	end

	local cx,cy,cz = getCameraMatrix()
	local wx,wy,wz = getWorldFromScreenPosition(x*real_sx,y*real_sy, 1000)

	local hit, hx,hy,hz,
	_,_,_,_,_,_,_,
	worldModelID,
	wmx,wmy,wmz,
	_,_,_,
	worldLODModelID = processLineOfSight(
		cx,cy,cz,
		wx,wy,wz,
		true, true, true, true, true, true, false, true, localPlayer,
		true
	)


	if hit and worldModelID then

		currentWorldInfo = {

			pos = { wmx, wmy, wmz },
			model = worldModelID,
			lod = worldLODModelID,

		}

		local dx,dy = x*sx, y*sy

		dxDrawText(string.format('MODEL: %s, LOD: %s\n%s', worldModelID, worldLODModelID or '---', Config.GTAModels_assoc[worldModelID] or ''),
			dx,dy - 10,
			dx,dy - 10,
			tocolor(255,255,255,255*windowAlpha),
			0.5, 0.5, getFont('proximanova_semibold', 30, 'light'),
			'center', 'bottom'
		)

	end


end
addEventHandler('onClientRender', root, worldInfo_onRender)