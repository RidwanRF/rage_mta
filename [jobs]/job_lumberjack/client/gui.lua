
openHandlers = {
}

closeHandlers = {
}

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			548, 372, 
			'assets/images/bg.png',
			color = {25,24,38, 255},


			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawImage(
						x + w/2 - 588/2,
						y + h/2 - 412/2,
						588, 412, 'assets/images/bg_shadow.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

					dxDrawImage(
						x,y,w,h, 'assets/images/bg1.png',
						0, 0, 0, tocolor(255,255,255,50*alpha)
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local texture = getDrawingTexture('assets/images/icon_bg.png')
					local gradient = getTextureGradient(texture, {
						texture = texture,
						alpha = alpha,
						angle = -45,
						color = {
							{ 86, 56, 79, 255 },
							{ 180, 70, 70, 255 },
						},
					})

					dxDrawImage(
						x + 35, y + 25, 38, 38, gradient
					)

					local texture = getDrawingTexture(element[6])
					local gradient = getTextureGradient(texture, {
						texture = texture,
						alpha = alpha,
						angle = -30+180,
						color = {
							{ 0, 0, 0, 0 },
							{ 180, 70, 70, 20 },
						},
					})

					dxDrawImage(
						x,y,w,h, gradient
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, 'assets/images/lumberjack.png',
						0, 0, 0, tocolor(40, 40, 40, 255*alpha)
					)

					dxDrawText('Лесоруб',
						x + 35 + 38 + 15, y + 25,
						x + 35 + 38 + 15, y + 25 + 38,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

					dxDrawText('Добывай древесину и грузи ее в пикап.\nВези ее на лесопилку и получай деньги.',
						x, y + 100,
						x+w, y + 100,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
						'center', 'top'
					)


				end,
			},

			elements = {

				{'button',

					0, 0, 26, 26,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 20
						element[3] = 25

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'button',

					'center', 160,
					183, 39,
					'Начать работу',

					bg = 'assets/images/btn_empty.png',
					activeBg = 'assets/images/btn.png',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					scale = 0.5,
					font = getFont('montserrat_medium', 22, 'light'),

					variable = 'startButton',

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 201/2, y + h/2 - 57/2, 201, 57

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/btn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onInit = function(element)
						element.animationAlpha = 'start-button'
						setAnimData(element.animationAlpha, 0.1, 1)
					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						animate('start-button', 0)
						displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

							animate('start-button', 1)

							triggerServerEvent('lumberjack.start', resourceRoot,
								currentStationId
							)

							closeWindow()

						end )


					end,

				},

				{'element',

					70, 'bottom',
					280, 140,
					color = {255,255,255,255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Статистика',
							x,y,x,y,
							tocolor(100, 100, 110, 255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
							'left', 'top'
						)

						local stats = exports.jobs_main:getPlayerStats( localPlayer )


						local rows = {
							{ name = 'Заработано за все время', value = string.format('$%s', splitWithPoints( stats.raised_money or 0, '.' )) },
							{ name = 'Отработано за всё время', value = string.format('%sч.', math.floor( (stats.total_xp or 0)/3600 )) },
							{ name = 'Срублено деревьев суммарно', value = (stats.routes_passed or 0) },
							{ name = 'Заработано денег за сессию', value = string.format('$%s', splitWithPoints(
								localPlayer:getData('job.session_stats.job_lumberjack.raised_money') or 0, '.' )) },
						}

						local startY = y + 30

						for _, row in pairs( rows ) do

							dxDrawText(row.name,
								x,startY,x,startY,
								tocolor(100, 100, 110, 255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
								'left', 'top'
							)

							dxDrawText(row.value,
								x + w,startY,x + w,startY,
								tocolor(255, 255, 255, 255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
								'right', 'top'
							)

							startY = startY + 22

						end

						local iw,ih = 90,90
						local ix,iy = x + w + 60, y+h/2-ih/2 - 10

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/lj_icon.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end,

				},


			},

		},

	},

}

-----------------------------------------------------------------

loadGuiModule()

end)
