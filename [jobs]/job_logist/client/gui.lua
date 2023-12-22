
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
						x,y,w,h, 'assets/images/bg1.png',
						0, 0, 0, tocolor(255,255,255,20*alpha)
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, gradient
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, 'assets/images/veh.png',
						0, 0, 0, tocolor(40, 40, 40, 255*alpha)
					)

					dxDrawText('Торговая база',
						x + 35 + 38 + 15, y + 25,
						x + 35 + 38 + 15, y + 25 + 38,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

					dxDrawText('Развози грузы по точкам\nи получай за это зарплату',
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

					'center', 170,
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

						currentWindowSection = 'select_route'

					end,

				},

				{'element',

					'center', 'bottom',
					300, 140,
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
							{ name = 'Суммарный стаж', value = string.format('%sч.', math.floor( (stats.total_xp or 0)/3600 )) },
							{ name = 'Совершено маршрутов', value = (stats.routes_passed or 0) },
							{ name = 'Заработано за сессию', value = string.format('$%s', splitWithPoints(
								localPlayer:getData('job.session_stats.job_.raised_money') or 0, '.' )) },
						}

						local startY = y + 30

						for _, row in pairs( rows ) do

							dxDrawText(row.name,
								x,startY,x,startY,
								tocolor(100, 100, 110, 255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
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

					end,

				},


			},

		},

	},

	select_route = {

		{'image',
			'center', 'center',
			478, 315, 
			'assets/images/rbg.png',
			color = {25,24,38, 255},

			onInit = function(element)

				local w,h = 358, 50
				local padding = 7

				local startY = 100

				for id, route in pairs( Config.routes ) do

					element:addElement(
						{'image',

							'center', startY,
							w,h,
							color = {20,20,30,255},
							'assets/images/ritem.png',

							route_id = id,
							route = route,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local iw,ih = 30,30

								dxDrawImage(
									x + 20, y+h/2-ih/2,
									iw, ih, element.route.icon,
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

								dxDrawText(element.route.name,
									x, y, x+w, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
									'center', 'center'
								)

								local aw,ah = 378, 70

								dxDrawImage(
									x + w/2 - aw/2, y+h/2-ah/2,
									aw, ah, 'assets/images/ritem_a.png',
									0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
								)


							end,

							onClick = function(element)

								currentWindowSection = 'main'

								local x,y,w,h = startButton:abs()

								animate('start-button', 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

									animate('start-button', 1)

									triggerServerEvent('logist.start', resourceRoot,
										currentStationId, element.route_id
									)

									closeWindow()

								end )

							end,


						}
					)

					startY = startY + h + padding

				end

			end,

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawImage(
						x + w/2 - 496/2,
						y + h/2 - 333/2 + 5,
						496, 333, 'assets/images/rbg_shadow.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local texture = getDrawingTexture(element[6])
					local gradient = getTextureGradient(texture, {
						texture = texture,
						alpha = alpha,
						angle = -45+180,
						color = {
							{ 0, 0, 0, 0 },
							{ 180, 70, 70, 50 },
						},
					})

					dxDrawImage(
						x,y,w,h, gradient
					)

					dxDrawText('Выберите товар',
						x, y + 50,
						x + w, y + 50,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
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

					onClick = function()
						currentWindowSection = 'main'
					end,

				},


			},

		},	
	},

}

-----------------------------------------------------------------

loadGuiModule()

end)
