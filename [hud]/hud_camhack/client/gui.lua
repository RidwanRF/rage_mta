
cancelButtons = {
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f9'] = true,
	['i'] = true,
	['m'] = true,
	['j'] = true,
	['delete'] = true,
}

openHandler = function()

	showCursor(false)
	showChat(false)

	localPlayer:setData('hud.hidden', true, false)
	localPlayer:setData('players.hidden', true, false)
	localPlayer:setData('weapon.hidden', true, false)
	localPlayer:setData('speed.hidden', true, false)
	localPlayer:setData('radar.hidden', true, false)

	prevWorld = { time = { getTime() }, weather = getWeather() }

end

closeHandler = function()

	showChat(true)

	localPlayer:setData('hud.hidden', false, false)
	localPlayer:setData('players.hidden', false, false)
	localPlayer:setData('weapon.hidden', false, false)
	localPlayer:setData('speed.hidden', false, false)
	localPlayer:setData('radar.hidden', false, false)

	setWeather( prevWorld.weather )
	setTime( unpack(prevWorld.time) )

end

hideBackground = true
blurBackground = false

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {
	
	main = {

		{'element',
			0, 0, 0, 0, 
			color = {255,255,255,255},

			onKey = {

				i = function(element)
					camhackGUI:setVisible( not camhackGUI:isVisible() )
				end,

			},

			onRender = function(element)

				local alpha = element:alpha()

				if camhackGUI.mode == 'cinema' then

					local height = real_sy*0.1

					mta_dxDrawRectangle(
						0, 0, real_sx, height,
						tocolor( 0, 0, 0, 255*alpha )
					)

					mta_dxDrawRectangle(
						0, real_sy-height, real_sx, height,
						tocolor( 0, 0, 0, 255*alpha )
					)

				end

			end,

		},

		{'image',

			'center', ( real_sy - px(300) - 30 ) * sx/real_sx,
			600, 300,
			'',

			variable = 'camhackGUI',
			color = {25,24,38,255},

			setVisible = function(element, flag)
				animate(element.animationAlpha, flag and 1 or 0)
			end,

			isVisible = function(element)
				local _, target = getAnimData(element.animationAlpha)
				return target == 1
			end,

			setSmoothMove = function(element, value)

				local speed = value

				setAnimSpeed('cam-px', 1)
				setAnimSpeed('cam-py', 1)
				setAnimSpeed('cam-pz', 1)

				setAnimSpeed('cam-tx', speed)
				setAnimSpeed('cam-ty', speed)
				setAnimSpeed('cam-tz', speed)

			end,

			onKey = {

				c = function(element)
					showCursor( not isCursorShowing() )
				end,

			},

			onInit = function(element)

				element[6] = 'assets/images/bg.png'
				-- element[6] = createTextureSource( 'bordered_rectangle', 'assets/images/bg.png', 22, element[4], element[5] )

				element.animationAlpha = {}
				setAnimData(element.animationAlpha, 0.1, 1)

			end,

			elements = {

				{'element',

					'center', 'top',
					'100%', 60,
					color = {255,255,255,255},

					gOnPreRender = {

						function(element)

							local x,y,w,h = element:abs()

							if mta_getKeyState('mouse1') then

								local cx,cy = getCursorPosition()
								if not cx then return end
								cx,cy = sx*cx, real_sy*cy * sx/real_sx

								if isMouseInPosition(x,y,w,h) then

									if not element.moving then

										element.moving = {
											start = { x = x, y = y },
										}

										element.moving.offset = {x = cx - x, y = cy - y}

									end

								end

								if element.moving then
									element.parent[2] = math.clamp( cx - element.moving.offset.x, -element.parent[4] + 20, sx - 20 )
									element.parent[3] = math.clamp( cy - element.moving.offset.y, -40, sy - 20 )
								end

							else

								element.moving = false

							end

						end,
					
					},

					onRender = {

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element.parent:abs()

							drawImageSection(
								x,y,w,h, element.parent[6],
								{ x = 1, y = element[5]/h }, tocolor(18, 18, 30, 255*alpha)
							)

							dxDrawText('Свободная камера',
								x, y,
								x + w, y + element[5],
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
								'center', 'center'
							)


						end,

					},
					
				},

				{'element',

					'center', 70,
					function(s,p) return p[4] - 60 end,
					function(s,p) return p[5] - 90 end,

					variable = 'camhackGUIList',
					scrollXOffset = 10,

					overflow = 'vertical',

					content = {

						{ type = 'tooltip', keys = {
							{ key = 'c', name = 'C' },
						},
							name = 'Показать / Скрыть Курсор',
						},

						{ type = 'tooltip', keys = {
							{ key = 'i', name = 'I' },
						},
							name = 'Показать / Скрыть Интферфейс',
						},

						{ type = 'tooltip', keys = {
							{ key = 'f12', name = 'F12' },
						},
							name = 'Сделать скриншот',
						},

						{ type = 'tooltip', keys = {
							{ key = 'd', name = 'D' },
							{ key = 's', name = 'S' },
							{ key = 'a', name = 'A' },
							{ key = 'w', name = 'W' },
						},
							name = 'Передвижение',
						},

						{ type = 'tooltip', keys = {
							{ key = 'q', name = 'E' },
							{ key = 'e', name = 'Q' },
						},
							name = 'Наклон',
						},

						{ type = 'tooltip', keys = {
							{ key = 'z', name = 'Z' },
							{ key = 'x', name = 'X' },
						},
							name = 'Угол обзора',
						},

						{ type = 'tooltip', keys = {
							{ key = 'lshift', name = 'LSHIFT' },
							{ key = 'lalt', name = 'LALT' },
						},
							name = 'Скорость перемещения',
						},

						{ type = 'clickbox', name = 'Стабилизация камеры',

							values = {
								{ text = 'Нет', value = 0.5, },
								{ text = 'Быстрая', value = 0.2, },
								{ text = 'Медленная', value = 0.05, },
								{ text = '1/100', value = 0.01, },
							},

							onChange = function(element, value)
								camhackGUI:setSmoothMove( value.value )
							end,

						},


						{ type = 'clickbox', name = 'Погода',

							values = {
								{ text = 'Стандарт', value = 10, },
								{ text = 'Ясная #1', value = 1, },
								{ text = 'Ясная #2', value = 2, },
								{ text = 'Ясная #3', value = 2, },
								{ text = 'Пасмурно #1', value = 4, },
								{ text = 'Пасмурно #2', value = 7, },
								{ text = 'Пасмурно #3', value = 9, },
								{ text = 'Дождь #1', value = 8, },
								{ text = 'Дождь #2', value = 16, },
							},

							onChange = function(element, value)
								setWeather( value.value )
							end,

						},

						{ type = 'clickbox', name = 'Время суток',

							values = {
								{ text = '00:00', value = 0, },
								{ text = '03:00', value = 3, },
								{ text = '06:00', value = 6, },
								{ text = '09:00', value = 9, },
								{ text = '12:00', value = 12, },
								{ text = '15:00', value = 15, },
								{ text = '18:00', value = 18, },
								{ text = '21:00', value = 21, },
							},

							onChange = function(element, value)
								setTime( value.value, 0 )
							end,

						},

						{ type = 'clickbox', name = 'Режим',

							values = {
								{ text = 'Стандарт', value = 'default', },
								{ text = 'Кино', value = 'cinema', },
							},

							onChange = function(element, value)
								camhackGUI.mode = value.value
							end,

						},

					},

					onInit = function(element)

						local startY = 0

						local w,h = element[4], 45
						local padding = 3

						for _, row in pairs( element.content ) do

							element:addElement(
								{'rectangle',

									'center', startY,
									w,h,
									color = {21,21,33,255},

									data = row,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local r,g,b = interpolateBetween(100, 100, 130, 255,255,255, element.animData, 'InOutQuad')

										dxDrawText(element.data.name,
											x + 30,y,
											x + 30,y+h,
											tocolor(r,g,b,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
											'left', 'center'
										)

									end,

									onInit = function(element)

										if element.data.type == 'tooltip' then

											element:addHandler('onRender', function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local scale, font = 0.5, getFont('montserrat_bold', 25, 'light')

												local i_padding = 20

												local eh = h - 15
												local e_padding = (h - eh)/2

												local startX = x + w

												for _, key_data in pairs( element.data.keys ) do

													local textWidth = dxGetTextWidth( key_data.name, scale, font )

													if utf8.len(key_data.name) == 1 then
														textWidth = eh
													else
														textWidth = textWidth + i_padding
													end

													startX = startX - textWidth - e_padding

													local r,g,b = 50, 50, 70

													if mta_getKeyState( key_data.key ) then
														r,g,b = 180, 70, 70
													end

													dxDrawRectangle(
														startX, y + h/2 - eh/2,
														textWidth, eh,
														tocolor( r,g,b, 255*alpha )
													)

													dxDrawText(key_data.name,
														startX, y,
														startX + textWidth, y + h,
														tocolor(255,255,255,255*alpha),
														scale, scale, font,
														'center', 'center'

													)

												end

											end)

										elseif element.data.type == 'checkbox' then

											element:addElement(
												{'checkbox',
													function(s,p) return p[4] - s[4] - 10 end, 'center',
													76, 31,

													color = {15,15,25,255},
													fgColor = {46,43,64,255},
													activeColor = {180,70,70,255},

													bg = 'assets/images/cd_bg.png',
													fg = 'assets/images/cd_fg.png',
													size = 49,

													onCheck = function(element)
														element.parent.data.onChange( element )
													end,

													padding = 3,


												}
											)

										elseif element.data.type == 'clickbox' then

											element:addElement(
												{'clickbox',
													function(s,p) return p[4] - s[4] - 10 end, 'center',
													120, 35,

													color = {15,15,25,255},

													onInit = function(element)
														-- element.bg = createTextureSource('bordered_rectangle', 'assets/images/cbox.png',
														-- 	element[5], element[4], element[5]
														-- )
														element.bg = 'assets/images/cbox.png'
													end,

													selected = 1,
													initSelect = false,

													values = element.data.values,

													scale = 0.5,
													font = getFont('montserrat_bold', 19, 'light'),

													onChange = function(element, value)
														element.parent.data.onChange( element, value )
													end,

													padding = 3,


												}
											)

										end

									end,

								}
							)

							startY = startY + h + padding

						end

					end,


				},

			},

		},

	},

}

loadGuiModule()


end)

