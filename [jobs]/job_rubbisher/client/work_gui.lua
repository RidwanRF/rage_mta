

------------------------------------------------------------

	local tooltipsAnim = {}
	setAnimData(tooltipsAnim, 0.1, 0)

------------------------------------------------------------

	local tooltips = {

		{

			buttons = {
				'arrow_l',
				'arrow_r',
			},

			text = 'Башня крана',

		},

		{

			pre_button = {
				name = 'ctrl',
				handlers = { 'lctrl', 'rctrl' },
			},

			buttons = {
				'arrow_u',
				'arrow_d',
			},

			text = 'Основание',

		},

		{

			buttons = {
				'arrow_u',
				'arrow_d',
			},

			text = 'Кисть крана',

		},

		{

			buttons = {
				'pgup',
				'pgdn',
			},

			text = 'Контейнер',

		},

	}

------------------------------------------------------------

	function renderTooltip( data, x,y,w,h, alpha )

		dxDrawImage(
			x,y,w,h, 'assets/images/tooltip/bg.png',
			0, 0, 0, tocolor(21,21,33,220*alpha)
		)

		local startX = x+10

		local bsize = 50
		local bpadding = 0

		local pre_state = true

		if data.pre_button then

			local pre_state = false

			for _, button in pairs( data.pre_button.handlers or {} ) do
				if getKeyState( button ) then
					pre_state = true
					break
				end
			end

			local c = pre_state and 255 or 200

			dxDrawImage(
				startX, y+h/2-bsize/2,
				bsize, bsize, 'assets/images/tooltip/' .. data.pre_button.name .. '.png',
				0, 0, 0, tocolor(c,c,c,255*alpha)
			)

			dxDrawText('+',
				startX+bsize-1, y-2,
				startX+bsize-1, y-2+h,
				tocolor(180,70,70,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
				'left', 'center'
			)

			startX = startX + bsize + bpadding + 10

		end

		for _, button in pairs( data.buttons ) do

			local c = ( pre_state and getKeyState(button) ) and 255 or 200

			dxDrawImage(
				startX, y+h/2-bsize/2,
				bsize, bsize, 'assets/images/tooltip/' .. button .. '.png',
				0, 0, 0, tocolor(c,c,c,255*alpha)
			)

			startX = startX + bsize + bpadding

		end

		dxDrawText(' - ' .. data.text,
			startX, y,
			startX, y+h,
			tocolor(255,255,255,255*alpha),
			0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
			'left', 'center'
		)

	end

------------------------------------------------------------

	function renderTooltips()

		local animData, target = getAnimData( tooltipsAnim )
		if target == 0 and animData < 0.01 then
			return removeEventHandler('onClientRender', root, renderTooltips)
		end

		local radar = { exports.hud_radar:getRadarCoords() }

		local bw,bh = 304, 58
		local padding = 10

		local _startX = radar[1] + radar[3] + 20
		local startX = _startX

		local startY = radar[2] + radar[4]/2 - padding/2 - bh

		local index = 1

		for i_1 = 1,2 do

			for i_2 = 1,2 do

				renderTooltip( tooltips[index], startX,startY,bw,bh, animData )

				startX = startX + bw + padding

				index = index + 1

			end

			startX = _startX
			startY = startY + bh + padding

		end

		if checkObjectPick() then

			dxDrawImage(
				startX + bw*2 + padding + 5, radar[2] + radar[4]/2 - 127/2, 
				116,127, 'assets/images/tooltip/enter.png',
				0, 0, 0, tocolor(255,255,255,255*animData * (
					math.abs( math.sin( getTickCount() * 0.002 ) )
				))
			)

		end



	end

------------------------------------------------------------

	setTimer(function()

		if localPlayer:getData('work.current') == Config.resourceName then

			if currentManipulatorTarget and isElement( currentManipulatorTarget.help_marker )
				and isElementWithinMarker( localPlayer, currentManipulatorTarget.help_marker )
			then

				addEventHandler('onClientRender', root, renderTooltips)
				animate(tooltipsAnim, 1)

			else

				animate(tooltipsAnim, 0)

			end

		end

	end, 1000, 0)

------------------------------------------------------------
