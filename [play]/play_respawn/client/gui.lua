


openHandler = function()
end

closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			487, 212,

			'assets/images/bg.png',
			id = 'window',

			color = {32,35,66,255},

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + element[4]/2 - 505/2,
					y + element[5]/2 - 230/2 + 5,
					505, 230, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawText('Ваш персонаж #b64747мёртв',
					x + 60, y + 40,
					x + 60, y + 40,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'top', false, false, false, true
				)


				local timestamp = getServerTimestamp()
				local respawn = localPlayer:getData('respawn.next_timestamp')

				local time = 0

				if timestamp and respawn then
					time = math.max(0, respawn - timestamp.timestamp)
				end

				local m = math.floor(time/60)
				local s = time - m*60

				dxDrawText(string.format('До возрождения осталось %02d:%02d', m,s),
					x + 60, y + 67,
					x + 60, y + 67,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
					'left', 'top', false, false, false, true
				)

				dxDrawText(string.format('Стоимость мгновенного респавна - #b64747%s $', splitWithPoints(Config.respawnCost, '.')),
					x + 60, y + 95,
					x + 60, y + 95,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
					'left', 'top', false, false, false, true
				)

			end,

			elements = {

				{'element', 

					'center', 140,
					390, 45,
					color = {255,255,255,255},

					elements = {

						{'button',
							'right', 0,
							191, 45,
							'Мгновенный респавн',
							bg = 'assets/images/respawn_button_empty.png',
							activeBg = 'assets/images/respawn_button.png',

							color = {180, 70, 70, 255},

							scale = 0.5,
							font = getFont('montserrat_medium', 20, 'light'),

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 221/2, y + h/2 - 76/2, 221, 76

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/respawn_button_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/respawn_button_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local x,y,w,h = element:abs()

								animate('respawn-button', 0)
								displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 500, function()

									animate('respawn-button', 1)
									triggerServerEvent('play.respawn.buy', resourceRoot)

								end )

							end,

							setAnimData('respawn-button', 0.1, 1),

							animationAlpha = 'respawn-button',

						},

						{'image',
							10, 'center',
							150, 4,
							color = {37,42,74,255},
							'assets/images/line.png',

							onRender = function(element)
								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = element:abs()

								local time = 0
								local respawn = localPlayer:getData('respawn.next_timestamp')
								local timestamp = getServerTimestamp()

								if timestamp and respawn then
									time = math.max(0, respawn - timestamp.timestamp)
								end

								local percent = math.clamp(1 - time/Config.respawnTime, 0, 1)

								drawImageSection(
									x,y,w,h, element[6],
									{ x = percent, y = 1 }, tocolor(180, 70, 70, 255*alpha)
								)

							end,

						},

					},

				},

			},

		},

	},

}

loadGuiModule()

end)
