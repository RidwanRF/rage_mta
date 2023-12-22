
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
						0, 0, 0, tocolor(255,255,255,80*alpha)
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, gradient
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, 'assets/images/bus.png',
						0, 0, 0, tocolor(40, 40, 40, 255*alpha)
					)

					dxDrawText('Автобусная компания',
						x + 35 + 38 + 15, y + 25,
						x + 35 + 38 + 15, y + 25 + 38,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

					dxDrawText('Едь по маршруту, за каждый чекпоинт ты будешь\nполучать деньги, забрать их можно в конце поездки',
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
								localPlayer:getData('job.session_stats.job_bus.raised_money') or 0, '.' )) },
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
			590, 380, 
			'assets/images/rbg.png',
			color = {25,24,38, 255},

			onInit = function(element)

				local w,h = 250, 54
				local padding = 13

				local d_element = element:addElement(
					{'element',

						'center', 140,
						w*2+padding, 0,
						color = {255,255,255,255},

					}
				)

				local startY = 0

				for i = 1,3 do

					for _, side in pairs( {'left', 'right'} ) do

						d_element:addElement(
							{'image',

								side, startY,
								w,h,
								'assets/images/ritem.png',
								color = {18,18,28,255},

								route_id = side == 'left' and i or i+3,

								onRender = function(element)

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									local aw,ah = 268, 73
									local ax,ay = x+w/2-aw/2, y+h/2-ah/2

									dxDrawImage(
										ax,ay,aw,ah, 'assets/images/ritem_a.png',
										0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
									)

									local tr,tg,tb = interpolateBetween(100, 100, 120, 180, 70, 70, element.animData, 'InOutQuad')

									local rx,ry,rw,rh = x + 20, y+h/2-53/2, 53,53

									dxDrawImage(
										rx,ry,rw,rh, 'assets/images/rround.png',
										0, 0, 0, tocolor(tr,tg,tb,255*alpha)
									)

									dxDrawText(element.route_id,
										rx,ry,rx+rw,ry+rh,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
										'center', 'center'
									)

									dxDrawText(Config.routes[element.route_id].name,
										rx + rw + 10, y,
										rx + rw + 10, y+h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
										'left', 'center'
									)

								end,

								onClick = function(element)

									currentWindowSection = 'main'

									local x,y,w,h = startButton:abs()

									animate('start-button', 0)
									displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

										animate('start-button', 1)

										triggerServerEvent('bus.start', resourceRoot,
											currentStationId, element.route_id
										)

										closeWindow()

									end )


								end,

							}
						)



					end

					startY = startY + h + padding

				end

			end,

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawImage(
						x + w/2 - 616/2,
						y + h/2 - 406/2 + 5,
						616, 406, 'assets/images/rbg_shadow.png',
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

					dxDrawText('Выберите маршрут',
						x, y + 35,
						x + w, y + 35,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'center', 'top'
					)

					dxDrawText('По этому маршруту вы будете двигаться\nна протяжении всей смены',
						x, y + 60,
						x + w, y + 60,
						tocolor(60,60,85,255*alpha),
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
