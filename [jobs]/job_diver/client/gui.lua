
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
						x + 35, y + 25, 38, 38, 'assets/images/diver.png',
						0, 0, 0, tocolor(40, 40, 40, 255*alpha)
					)

					dxDrawText('Водолаз',
						x + 35 + 38 + 15, y + 25,
						x + 35 + 38 + 15, y + 25 + 38,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

					dxDrawText('Бери акваланг и исследуй побережье.\nКак забьешь рюкзак - возвращайся\nна сушу и выкладывай находки.',
						x, y + 90,
						x + w, y + 90,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
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

						animate('start-button', 0)
						displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

							animate('start-button', 1)

							triggerServerEvent('diver.start', resourceRoot,
								currentStationId
							)

							closeWindow()

						end )


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
							{ name = 'Найдено предметов', value = (stats.items_found or 0) },
							{ name = 'Заработано за сессию', value = string.format('$%s', splitWithPoints(
								localPlayer:getData('job.session_stats.job_diver.raised_money') or 0, '.' )) },
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

	shop = {


		{'image',

			'center', 'center',
			618, 609, 
			'assets/images/sbg.png',
			color = {25,24,38, 255},

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawImage(
						x + w/2 - 646/2,
						y + h/2 - 637/2,
						646, 637, 'assets/images/sbg_shadow.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawText('Магазин оборудования',
						x,y + 30,x+w,y + 30,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
						'center', 'top'
					)


				end,
			},

			onInit = function(element)


				local w,h = 260,228
				local padding = 15

				local sw,sh = w*2 + padding, h*2 + padding

				local s_element = element:addElement(
					{'element',

						'center', element[5] - sh - 55,
						sw,sh,
						color = {255,255,255,255},

					}
				)

				local sides = {
					{'left', 'top'},
					{'right', 'top'},
					{'left', 'bottom'},
					{'right', 'bottom'},
				}

				for i = 1,4 do

					s_element:addElement(
						{'image',

							sides[i][1], sides[i][2], 
							w,h,

							'assets/images/sitem.png',
							color = {21,21,33,255},

							index = i,
							item = Config.shop[i],

							onInit = function(element)
								element.y0 = element[3]
							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								element[3] = element.y0 - 5*element.animData

								dxDrawText(element.item.name,
									x,y + 20, x+w, y+20,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top'
								)

								dxDrawText(element.item.title,
									x,y + 40, x+w, y+40,
									tocolor(100,100,120,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
									'center', 'top'
								)

								local iw,ih = 100,100

								dxDrawImage(
									x + w/2 - iw/2, y + 65,
									iw,ih, string.format('assets/images/shop/%s.png', element.index),
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)


							end,

							elements = {


								{'button',

									25, function(s,p) return p[5] - s[5] - 20 end,
									109, 36,
									'Купить',

									bg = 'assets/images/sbtn_empty.png',
									activeBg = 'assets/images/sbtn.png',

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									scale = 0.5,
									font = getFont('montserrat_medium', 20, 'light'),

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 127/2, y + h/2 - 54/2, 127, 54

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/sbtn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/sbtn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										dxDrawText('#cd4949$#ffffff' .. element.parent.item.cost,
											x+w+20, y,
											x+w+20, y+h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
											'left', 'center', false, false, false, true
										)
										

									end,

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onClick = function(element)

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

											animate(element.animationAlpha, 1)

											triggerServerEvent('diver.buyShopItem', resourceRoot,
												element.parent.index
											)

										end )


									end,

								},

							},

						}
					)

				end

			end,

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

			},

		},


	},

}

-----------------------------------------------------------------

loadGuiModule()

end)
