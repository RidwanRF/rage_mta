
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['i'] = true,
	['0'] = true,
}

openHandler = function()

	localPlayer:setData( 'hud.hidden', true, false )
	localPlayer:setData( 'speed.hidden', true, false )
	localPlayer:setData( 'radar.hidden', true, false )
	localPlayer:setData( 'drift.hidden', true, false )

	showChat(false)

end

closeHandler = function( )

	localPlayer:setData( 'hud.hidden', false, false )
	localPlayer:setData( 'speed.hidden', false, false )
	localPlayer:setData( 'radar.hidden', false, false )
	localPlayer:setData( 'drift.hidden', false, false )
	
	showChat( true )

end

__basic_Ignore = {
	creation = true,
	invite_window = true,
	buy_mansion = true,
	mansion_menu = true,
}

addEventHandler( 'onClientResourceStart', resourceRoot, function( )

windowModel = {
	
	creation = {

		{'image',
			'center', 'center',
			882,802,
			'assets/images/creation/bg.png',
			color = {25,24,38,255},

			onPreRender = function( element )

				local alpha = element:alpha( )
				local x,y,w,h = element:abs( )

				dxDrawImage(
					x + w/2 - 908/2,
					y + h/2 - 828/2 + 5,
					908, 828, 'assets/images/creation/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local iw,ih = 59,59
				local ix,iy = x + 40, y + 40

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/creation/icon_bg.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/creation/icon.png',
					0, 0, 0, tocolor(0,0,0,100*alpha)
				)

				dxDrawText('Создание клана',
					ix + iw + 10, iy + 10, 
					ix + iw + 10, iy + 10,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'top'
				)

				dxDrawImage(
					ix + iw + 10, iy + 33,
					135, 25,
					'assets/images/creation/tline.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

			end,

			elements = {

				{'button',

					function(s,p)
						return p[4] - s[4] - 50
					end,

					function(s,p)
						return 40 + 59/2 - s[4]/2
					end,

					28, 28,
					bg = 'assets/images/creation/close.png',
					activeBg = 'assets/images/creation/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/creation/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'element',
					'center', 180,
					732, 214,
					color = {255,255,255,255},

					variable = 'createClanIcon',

					onInit = {

						function(element)

							element.s_anim = { x = {}, y = {} }
							setAnimData(element.s_anim.x, 0.2)
							setAnimData(element.s_anim.y, 0.2)
							
						end,

						function(element)

							local startY = 0
							local startX = 0

							local w,h = 66,66
							local padding = 8

							local slot = 1

							for i1 = 1, 3 do

								startX = 0

								for i2 = 1, 10 do

									element:addElement(
										{'image',
											startX, startY,
											w,h,
											color = {21,21,33,255},

											slot = slot,

											'assets/images/creation/item_bg.png',

											onRender = function(element)

												local filepath = ('assets/images/icons/%s.png'):format(element.slot)

												if fileExists( filepath ) then

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													dxDrawImage(
														x,y,w,h, filepath,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

												end

											end,

											onClick = function(element)
												element.parent.selected = element
											end,

										}
									)

									slot = slot + 1
									startX = startX + w + padding

								end

								startY = startY + h + padding

							end

							element.elements[1]:onClick()

						end,

					},

					onPostRender = function(element)

						if element.selected then

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							animate(element.s_anim.x, element.selected[2])
							animate(element.s_anim.y, element.selected[3])

							local ax = getAnimData( element.s_anim.x )
							local ay = getAnimData( element.s_anim.y )

							dxDrawImage(
								x + ax + 66/2 - 70/2,
								y + ay + 66/2 - 70/2,
								70, 70, 'assets/images/creation/item_bg_a.png',
								0, 0, 0, tocolor(180,70,70,255*alpha)
							)

						end

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите титул клана',
							x, y - 25, x + w, y - 25,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'bottom'
						)

						

					end,

				},

				{'input',
					130, 510,
					328, 60,
					bg = 'assets/images/creation/input.png',
					'',

					color = {21,21,33,255},
					alignX = 'center',

					placeholderColor = { 70, 70, 70, 255 },
					placeholder = 'Поле ввода',

					font = getFont('montserrat_semibold', 26, 'light'),
					scale = 0.5,

					maxSymbols = 10,
					possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm1234567890',

					variable = 'createClanName',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Введите название клана\n#4f4f56(От 2-х до 10-ти символов)',
							x, y - 10, x + w, y - 10,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
							'center', 'bottom', false, false, false, true
						)

						local content = #element[6] >= 2 and element[6] or 'CLAN'

						if  createClanIcon.selected then

							local r,g,b = unpack( createClanPalette.rgb or {255,255,255} )

							drawSmartText(string.format('<img>assets/images/icons/%s.png</img> %s',
								createClanIcon.selected.slot, content
							),
								x, x+w, y+h + 30, 
								tocolor(r,g,b,255*alpha),
								tocolor(255,255,255,255*alpha),
								0.5, getFont('montserrat_bold', 52, 'light'),
								'center', 63, -15, 3
							)

							dxDrawText('Пример названия',
								x, y + h + 55,
								x+w, y + h + 55,
								tocolor(83,82,89,255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
								'center', 'top'
							)
							
						end


					end,

				},

				{'element',
					
					520, 450,
					200, 200,

					color = {255, 255, 255, 255},

					hsv = {0, 0, 1},

					variable = 'createClanPalette',

					onInit = {

						function(element)
							element.palette_mask = 'assets/images/creation/pmask.png'

							element.animationAlpha = {}
							setAnimData(element.animationAlpha, 0.1, 1)

						end,

					},

					bg = 'assets/images/creation/palette.png',

					onRender = {

						function(element)
							
							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawImage(
								x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
									alpha = alpha,
									mask = getDrawingTexture( element.palette_mask )
								} )
							)

						end,

						function(element)

							local x,y = unpack(element.hsv)
							y = 1 - y


							local alpha = element:alpha()
							local ex,ey,ew,eh = element:abs()

							dxDrawImage(
								ex + x*ew - 8,
								ey + y*eh - 8,
								16, 16, 'assets/images/creation/palette_target.png',
								0, 0, 0, tocolor(180, 70, 70, 255*alpha)
							)

						end,

						function(element)

							animate(element.animationAlpha, 0.5 + 0.5*math.max( element.animData, element.alphaSlider.animData ))

						end,

					},

					getColor = function(element)
						local r,g,b = hsvToRgb(unpack(element.hsv))
						return r,g,b
					end,

					onColorChange = function(element, r,g,b)
						element.rgb = {r,g,b}
					end,

					onDragDrop = function(element, _, _, x,y)

						local ex,ey = element:abs(true)

						x = x*real_sx - px(ex)
						y = y*real_sy - px(ey)
						x = x * sx/real_sx
						y = y * sx/real_sx

						local h,s = 
				            math.clamp(x / element[4],  0, 1),
				            1 - math.clamp(y / element[5],  0, 1)

			            element.hsv = {h,s, element.hsv[3]}

			            element:onColorChange( hsvToRgb( unpack(element.hsv) ) )

					end,

					elements = {

						{'element',
							function(s,p) return p[4] + 15 end, 'center',
							27, 200,

							bg='assets/images/creation/alpha.png',
							color = {255, 255, 255, 255},

							onRender = {

								function(element)
									
									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									dxDrawImage(
										x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
											alpha = alpha,
											mask = getDrawingTexture( element.palette_alpha )
										} )
									)

								end,

								function(element)

									local alpha = element:alpha()
									local ex,ey,ew,eh = element:abs()

									local y = 1-createClanPalette.hsv[3]

									local rw, rh = ew+5, 3
									local rx,ry = ex+ew/2 - rw/2, (ey+8)+(eh-16)*y-rh/2

									mta_dxDrawRectangle(
										px(rx) - 1, px(ry) - 1,
										px(rw)+2, px(rh)+2,
										tocolor(0, 0, 0, 150*alpha)
									)

									dxDrawRectangle(
										rx,ry,
										rw,rh,
										tocolor(180, 70, 70, 255*alpha)
									)

									local r,g,b = hsvToRgb( 
										createClanPalette.hsv[1],
										createClanPalette.hsv[2],
										1
									)
									element.color = {r,g,b, element.color[4]}

								end,

							},

							onDragDrop = function(element, _, _, x,y)

								local ex,ey = element:abs(true)

								y = y*real_sy - px(ey)

								local v = 1-math.clamp(y / element[5],  0, 1)
								createClanPalette.hsv[3] = v

								createClanPalette:onColorChange( hsvToRgb( unpack(createClanPalette.hsv) ) )
							end,

							onInit = {

								function(element)
									element.palette_alpha = 'assets/images/creation/palpha.png'
									element.parent.alphaSlider = element
								end,

							},

						},

					},

				},


				{'image',
					'center', function(s,p) return p[5] - s[5] - 50 end,
					275,44,
					color = {180,70,70,255},
					'assets/images/creation/cblock.png',

					onInit = function(element)
						element.animationAlpha = {}
						setAnimData(element.animationAlpha, 0.1, 1)
					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local sww,swh = 295, 68

						dxDrawImage(
							x + w/2 - sww/2, y + h/2 - swh/2,
							sww,swh,
							'assets/images/creation/cblock_shadow.png',
							0, 0, 0, tocolor(230,80,80,255*alpha)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						drawSmartText(string.format('%s <img>assets/images/donate.png</img>',
							splitWithPoints( Config.creationCost, '.')
						),
							x, x+(w-138+15), y+h/2, 
							tocolor(255,255,255,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 25, 0
						)

					end,



					elements = {

						{'button',
							'right', 'center',
							138, 44,
							color = {230,80,80,255},

							bg = 'assets/images/creation/cbtn.png',
							'Создать',

							font = getFont('montserrat_semibold', 25, 'light'),
							scale = 0.5,

							onClick = function(element)

								if #createClanName[6] < 2 then
									return exports.hud_notify:notify('Ошибка', 'Слишком короткое название')
								end

								local x,y,w,h = element.parent:abs()

								animate(element.parent.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

									animate(element.parent.animationAlpha, 1)

									triggerServerEvent('clan.create', resourceRoot,
										createClanName[6],
										createClanIcon.selected.slot,
										RGBToHex( unpack( createClanPalette.rgb or {255,255,255} ) )
									)

									closeWindow()

								end )

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local sww,swh = 160,66

								dxDrawImage(
									x + w/2 - sww/2, y + h/2 - swh/2,
									sww,swh,
									'assets/images/creation/cbtn_shadow.png',
									0, 0, 0, tocolor(230,80,80,255*alpha*element.animData)
								)

							end,

						},

					},

				},

			},

		},

	},

	buy_mansion = {

		{'image',
			'center', 'center',
			656, 400,
			color = {25,24,38,255},
			'assets/images/mansion/mbg.png',

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local gradient = getTextureGradient(getDrawingTexture(element[6]), {
					angle = 80,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 20 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/mansion/micon_bg.png', 0, 0, 0, 
					tocolor(180,70,70,255*alpha)
				)

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/mansion/micon.png', 0, 0, 0, 
					tocolor(0,0,0,150*alpha)
				)

				dxDrawText('Приобретение особняка',
					x, y + 68, x + w, y + 68,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'center', 'top'
				)

				dxDrawText('Что дает особняк клану?',
					x, y + 100, x + w, y + 130,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'bottom'
				)

				dxDrawText(table.concat({
					'#cd4949•#ffffff Возможность захватывать территории',
					'#cd4949•#ffffff Общак с оружием и патронами',
				}, '\n'),
					x + w/2 - 150, y + 160, x + w, y + 160,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'left', 'top', false, false, false, true
				)

				dxDrawImage(
					x + w/2-186/2, y + 135,
					186, 17, 
					'assets/images/mansion/mline.png', 0, 0, 0, 
					tocolor(180,70,70,255*alpha)
				)

			end,

			elements = {

				{'button',

					0, 0, 35, 35,
					bg = 'assets/images/mansion/close.png',
					activeBg = 'assets/images/mansion/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 20 + 56/2 - element[5]/2

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/mansion/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'button',

					'center', function(s,p) return p[5] - s[5] - 50 end,
					215, 46,

					bg = 'assets/images/mansion/mbtn_empty.png',
					activeBg = 'assets/images/mansion/mbtn.png',
					'Приобрести',

					scale = 0.5,
					font = getFont('montserrat_semibold', 21, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 233/2, y + h/2 - 64/2, 233, 64

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/mansion/mbtn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/mansion/mbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						if not currentMansionData then return end

						local cost = currentMansionData.cost

						drawSmartText(string.format('<img>assets/images/money.png</img> %s',
							splitWithPoints( cost, '.' )
						),
							x, x+w, y - 40, 
							tocolor(255,255,255,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_semibold', 30, 'light'),
							'center', 32, 5, 0
						)


					end,

					onClick = function(element)

						triggerServerEvent('teams.buyMansion', resourceRoot, currentMansionData.id)
						closeWindow()

					end,


				},


			},

		},

	},

	mansion_menu = {

		{'image',
			'center', 'center',
			656, 400,
			color = {25,24,38,255},
			'assets/images/mansion/mbg.png',

			onInit = function()

				closeHandlers.mansion_data = function()
					currentMansionData = nil
				end

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local gradient = getTextureGradient(getDrawingTexture(element[6]), {
					angle = 80,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 20 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/mansion/micon_bg.png', 0, 0, 0, 
					tocolor(180,70,70,255*alpha)
				)

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/mansion/micon.png', 0, 0, 0, 
					tocolor(0,0,0,150*alpha)
				)

				dxDrawText('Меню особняка',
					x, y + 68, x + w, y + 68,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'center', 'top'
				)

				dxDrawImage(
					x + w/2-186/2, y + 100,
					186, 17, 
					'assets/images/mansion/mline.png', 0, 0, 0, 
					tocolor(180,70,70,255*alpha)
				)

				dxDrawText('Что дает особняк клану?',
					x, y + 100, x + w, y + 150,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'bottom'
				)

				dxDrawText(table.concat({
					'#cd4949•#ffffff Возможность захватывать территории',
					'#cd4949•#ffffff Общак с оружием и патронами',
				}, '\n'),
					x + w/2 - 150, y + 180, x + w, y + 180,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'left', 'top', false, false, false, true
				)

			end,

			elements = {

				{'button',

					0, 0, 35, 35,
					bg = 'assets/images/mansion/close.png',
					activeBg = 'assets/images/mansion/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 20 + 56/2 - element[5]/2

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/mansion/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'element',
					'center', function(s,p) return p[5] - s[5] - 45 end,
					396, 92,
					color = {255,255,255,255},

					elements = {

						{'button',

							'left', 'top',
							[6]='Войти',

							define_from = 'mm_button',

							onClick = function(element)

								triggerServerEvent('mansion.enter', resourceRoot, currentMansionData.id)
								closeWindow()

							end,

						},

						{'button',

							'right', 'top',
							[6]='Продать гос-ву',

							define_from = 'mm_button',

							onClick = function(element)

								dialog('Продажа', {
									'Вы действительно хотите продать',	
									('особняк за #cd4949$%s?'):format( splitWithPoints(currentMansionData.cost * Config.mansionSell, '.') ),
								}, function(result)

									if result then
										triggerServerEvent('teams.sellMansion', resourceRoot, currentMansionData.id)
										closeWindow()
									end

								end)

							end,

						},

						{'button',

							'left', 'bottom',
							[6]='Продать игроку',

							define_from = 'mm_button',

							_=addEvent('mansion.sellOffer', true),
							_=addEventHandler('mansion.sellOffer', resourceRoot, function( mansion_data, seller, cost )

								currentMansionData = mansion_data

								dialog('Продажа особняка', {
									('%s предлагает вам купить'):format( seller.name ),
									('особняк за #cd4949$%s'):format( splitWithPoints( cost, '.' ) ),
								}, function(result)

									triggerServerEvent('teams.sellMansionResponse', resourceRoot,
										mansion_data.id, seller, result, cost
									)

								end)

							end),

							onClick = function(element)

								local nearest_players = {}

								for _, player in pairs( getElementsByType('player', root, true) ) do

									if getDistanceBetween(player, localPlayer) < 15 and player ~= localPlayer then
										table.insert(nearest_players, { name = player.name, data = player })
									end

								end

								dialog_input('Продажа', {
									'Заполните данные',
								}, {
									{ type = 'number', name = 'Выберите стоимость', },
									{type = 'select', name = 'Выберите игрока', params = {
										selectElements = nearest_players,
									}},
								}, function(data)

									if data then

										if not isElement(data[2]) then
											return exports.hud_notify:notify('Ошибка', 'Игрок не найден')
										end

										triggerServerEvent('teams.sellMansionInvite', resourceRoot, currentMansionData.id, data[2], data[1])
										closeWindow()

									end


								end)

							end,

						},

						{'button',

							'right', 'bottom',
							[6]='Закрыть',

							define_from = 'mm_button',

							onClick = function(element)
								closeWindow()
							end,

						},

					},

				},


			},

		},

	},

	invite_window = {

		{'image',

			'center', 'center',
			416, 200,
			':core/assets/images/gui_dialog/bg.png',

			color = {24, 30, 66, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture(element[6])
				local gradient = getTextureGradient(texture, {
					angle = 150,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 50 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawText('Приглашение в клан',
					x, y + 35,
					x+w, y + 35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				if current_invite then
					dxDrawText(table.concat({
						('Игрок %s приглашает вас'):format( current_invite.inviter_name ),
						('вступить в клан %s'):format( current_invite.team_name ),
					}, '\n'),
						x, y + 70,
						x+w, y + 70,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
						'center', 'top', false, false, false, true
					)
				end

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local sw,sh = 434, 201

				dxDrawImage(
					x+w/2-sw/2, y+h/2-sh/2+5+(element.y_add or 0)/2, sw,sh,
					':core/assets/images/gui_dialog/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'element',
					'center', 'bottom',
					316, 70,
					color = {255,255,255,255},

					onRender = function(element)
						element[3] = element.parent[5] - element[5]
					end,

					elements = {

						{'button',

							'left', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Продолжить',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								triggerServerEvent('teams.inviteResult', resourceRoot, true)
								current_invite = nil
								closeWindow()								

							end,

						},

						{'button',

							'right', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Отмена',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								triggerServerEvent('teams.inviteResult', resourceRoot, false)
								current_invite = nil
								closeWindow()

							end,

						},

					},

				},

			},

		},

	},

	__basic = {

		{'image',
			0, 0, sx, ( real_sy ) * sx/real_sx,
			'assets/images/mbg.png',
			color = {255,255,255,255},
			anim_fix = true,

			noDraw = function(element)
				return currentMansionData ~= nil
			end,

		},

		{'element',

			'center', 100,
			sx, 50,
			color = {255,255,255,255},

			noDraw = function(element)
				return currentMansionData ~= nil
			end,

			tabs = {
				{ name = 'Главная', id = 'main', },
				{ name = 'Ранги', id = 'ranks', },
				{ name = 'Участники', id = 'members', },
				{ name = 'Владения клана', id = 'areas', },
				{ name = 'График битв', id = 'wars', },
				{ name = 'Рейтинг кланов', id = 'top', },
				{ name = 'Уведомления', id = 'notify', },
				{ name = 'Клановый чат', id = 'chat', },
			},

			variable = 'tabs',

			onKey = {

				tab = function(element)

					for index, tab in pairs( element.tabs ) do

						if tab.id == currentWindowSection then
							element.elements[ cycle( index + 1, 1, #element.tabs ) ]:onClick()
							return
						end

					end


				end,

			},

			onInit = function(element)

				local totalWidth = 0
				local scale, font = 0.5, getFont('montserrat_semibold', 28, 'light')
				local i_padding = 50

				for _, tab in pairs( element.tabs ) do
					totalWidth = totalWidth + dxGetTextWidth( tab.name, scale, font ) + i_padding
				end

				local startX = element[4]/2 - totalWidth/2

				for _, tab in pairs( element.tabs ) do

					local textWidth = dxGetTextWidth( tab.name, scale, font ) + i_padding

					element:addElement(
						{'element',
							startX, 'center',
							textWidth, '100%',
							color = {255,255,255,255},

							tab = tab,

							onInit = function(element)
								element.h_anim = {}
								setAnimData(element.h_anim, 0.1, 0)
							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								animate(element.h_anim, currentWindowSection == element.tab.id and 1 or 0)
								local animData = getAnimData(element.h_anim)

								local r,g,b = interpolateBetween( 25,24,38, 180,70,70, animData, 'InOutQuad' )
								local tr,tg,tb = interpolateBetween( 150,150,160, 255,255,255, animData, 'InOutQuad' )

								mta_dxDrawRectangle(
									px(x), px(y + h),
									px(w), 1, tocolor(r,g,b, 255*alpha)
								)

								dxDrawText(element.tab.name,
									x,y,x+w,y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
									'center', 'center'
								)

							end,

							onClick = function(element)
								currentWindowSection = element.tab.id
							end,

						}
					)

					startX = startX + textWidth

				end

			end,

			gOnPreRender = function(element)
				currentTeamData = localPlayer.team and ( localPlayer.team:getData('team.data') or {} ) or {}
				serverTimestamp = getServerTimestamp()
			end,

		},

	},

	main = {

		{'element',
			'center', 'center',
			1075, 600,
			color = {255,255,255,255},

			elements = {

				{'element',
					'left', 'center',
					450, '100%',

					variable = 'clanInfo_blocks',

					drawInfoBlock = function(element, data)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local rw,rh = unpack( data.size )

						dxDrawRectangle(
							x, y + data.start_y,
							rw,rh,
							tocolor(28,27,42,255*alpha)
						)

						local xOffset = 40

						dxDrawText(data.name,
							x + xOffset, y + data.start_y + 30,
							x + xOffset, y + data.start_y + 30,
							tocolor(75,75,87,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'top'
						)

						dxDrawImage(
							x + xOffset - 7, y + data.start_y + 55,
							50, 50, data.icon,
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText(splitWithPoints( data.value, '.' ),
							x + xOffset + 45, y + data.start_y + 55 - 4,
							x + xOffset + 45, y + data.start_y + 55 + 50,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 45, 'light'),
							'left', 'center'
						)

						dxDrawImage(
							x + rw - 96 - 20, y + data.start_y + rh - 31 - 20,
							96, 31, 'assets/images/miline.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

					end,

					onInit = function(element)

						openHandlers.calc_rating = function()

							if currentWindowSection == 'main' then

								clanInfo_blocks.rating = getClanRating( localPlayer.team )

							end

						end

						openHandlers.calc_inventory = function()

							if currentWindowSection == 'main' then

								local ammo, weapon = 0,0
								local inventoryConfig = exports.main_inventory:getConfigSetting('items')

								local team_data = localPlayer.team:getData('team.data') or {}

								for _, item in pairs( (team_data.inventory or {}).inventory or {} ) do

									local item_config = inventoryConfig[ item.item ]

									if item_config.type == 'ammo' then
										ammo = ammo + item.count
									end

									if item_config.type == 'weapon' then
										weapon = weapon + 1
									end

								end

								clanInfo_blocks.inventory = {
									ammo = ammo,
									weapon = weapon,
								}

							end

						end

					end,

					onRender = function(element)

						local info_blocks = {

							{
								name = 'Рейтинг клана',
								icon = 'assets/images/mi_rating.png',
								value = element.rating,
							},

							{
								name = 'Территории',
								icon = 'assets/images/mi_area.png',
								value = #clanAreas_list.areas,
							},

							{
								name = 'Оружия в общаке',
								icon = 'assets/images/mi_weapon.png',
								value = element.inventory.weapon,
							},

							{
								name = 'Патронов в общаке',
								icon = 'assets/images/mi_ammo.png',
								value = element.inventory.ammo,
							},

						}

						local w,h = 450, 141
						local padding = (element[5] - h*#info_blocks) / (#info_blocks-1)

						local sCount = #info_blocks/2
						local startY = element[5]/2 - h*sCount - padding*(sCount-0.5)

						for _, info_block in pairs( info_blocks ) do

							info_block.start_y = startY
							info_block.size = { w,h }

							element:drawInfoBlock( info_block )

							startY = startY + h + padding

						end

					end,

				},

				{'rectangle',
					470, 'top',
					295, 295,
					color = {28,27,42,255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w - 58 - 10,
							y + 10,
							58,58, 'assets/images/mi_round.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)
						dxDrawImage(
							x + w - 58 - 10,
							y + 10,
							58,58, 'assets/images/mi_user.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('Участников',
							x + 30, y + 20 + 58/2,
							x + 30, y + 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'center'
						)

						local rw,rh = 161,161
						local rx,ry = x + w /2 - rw/2, y + h - rh - 50

						dxDrawImage(
							rx,ry,rw,rh, 'assets/images/mi_eround.png',
							0, 0, 0, tocolor(23,23,35,255*alpha)
						)

						local members, max = getTableLength( currentTeamData.members ), currentTeamData.max_members
						local progress = members/max

						dxDrawImage(
							rx,ry,rw,rh, getRoundMask(
								getDrawingTexture('assets/images/mi_eround.png'),
								{
									color = {180,70,70,255},
									alpha = alpha,
									angle = { 0, 360*progress },
								}
							)
						)

						dxDrawImage(
							rx+rw/2 - 154/2, ry+rh/2-rh/2,
							rw,rh, 'assets/images/mi_ushadow.png',
							0, 0, 0, tocolor(180,70,70,100*alpha)
						)

						dxDrawText(members,
							rx,ry-5,rx+rw,ry+rh-5,
							tocolor(180,70,70,255*alpha),
							0.5, 0.5, getFont('montserrat_bold', 70, 'light'),
							'center', 'center'
						)

						dxDrawText('/ ' .. max,
							rx,ry + 33-5,rx+rw,ry+rh + 33-5,
							tocolor(80,80,80,200*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'center'
						)

					end,

				},

				{'rectangle',
					470, 'bottom',
					295, 295,
					color = {28,27,42,255},

					variable = 'mainInfo_areas',

					onInit = function(element)

						openHandlers.areas = function()

							if currentWindowSection == 'main' then

								local team_id = localPlayer:getData('team.id')
								if not team_id then return end

								mainInfo_areas.areas = {
									count = 0,
									income = 0,
								}

								for _, business in pairs( getElementsByType('marker', getResourceRoot('main_business')) ) do

									local b_data = business:getData('business.data') or {}

									if b_data.clan == team_id then

										local types = Config.areasData
										local amount = types[ b_data.clan_area_type or 1 ].income

										mainInfo_areas.areas.count = mainInfo_areas.areas.count + 1
										mainInfo_areas.areas.income = mainInfo_areas.areas.income + amount

									end

								end

								mainInfo_areas.salary = calculateClanSalary( localPlayer.team )*24

							end


						end

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w - 58 - 10,
							y + 10,
							58,58, 'assets/images/mi_round.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)
						dxDrawImage(
							x + w - 58 - 10,
							y + 10,
							58,58, 'assets/images/mi_money.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('Казна клана',
							x + 30, y + 20 + 58/2,
							x + 30, y + 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'center'
						)


						local money = splitWithPoints( currentTeamData.bank or 0, '.' )

						dxDrawText('Состояние казны',
							x, y+70,
							x + w, y+70,
							tocolor(220,220,220,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'center', 'top'
						)

						drawSmartText(string.format('%s <img>assets/images/money.png</img>',
							money
						),
							x, x+w, y + 104, 
							tocolor(255,255,255,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_bold', 58, 'light'),
							'center', 25, -5, 3
						)

						dxDrawImage(
							x + w / 2 - 199/2,
							y + 130,
							199, 31,
							'assets/images/mi_arealine.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						dxDrawText('$' .. splitWithPoints( mainInfo_areas.areas.income or 0, '.' ),
							x, y + 175,
							x + w, y + 175,
							tocolor(180,70,70,255*alpha),
							0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
							'center', 'center'
						)

						dxDrawText('Доход в сутки',
							x, y+195,
							x + w, y+195,
							tocolor(220,220,220,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'center', 'top'
						)

						-- dxDrawText('$' .. splitWithPoints( element.salary or 0, '.' ),
						-- 	x + w - w/2 - 15, y + 185,
						-- 	x + w, y + 185,
						-- 	tocolor(180,70,70,255*alpha),
						-- 	0.5, 0.5, getFont('montserrat_bold', 30, 'light'),
						-- 	'center', 'center'
						-- )

						-- dxDrawText('Расход в сутки',
						-- 	x + w - w/2 - 15, y+195,
						-- 	x + w, y+195,
						-- 	tocolor(220,220,220,255*alpha),
						-- 	0.5, 0.5, getFont('montserrat_semibold', 19, 'light'),
						-- 	'center', 'top'
						-- )

						-- if ( mainInfo_areas.areas.income or 0 ) > ( element.salary or 0 ) then

						-- 	dxDrawImage(
						-- 		x+w/2-20/2, y + 192 - 20/2,
						-- 		20, 20, 'assets/images/cmp_icon.png',
						-- 		180, 0, 0, tocolor(50,230,60,255*alpha)
						-- 	)

						-- elseif ( mainInfo_areas.areas.income or 0 ) < ( element.salary or 0 ) then

						-- 	dxDrawImage(
						-- 		x+w/2-20/2, y + 192 - 20/2,
						-- 		20, 20, 'assets/images/cmp_icon.png',
						-- 		0, 0, 0, tocolor(180,70,70,255*alpha)
						-- 	)

						-- else

						-- 	dxDrawText('=',
						-- 		x+w/2, y + 192,
						-- 		x+w/2, y + 192,
						-- 		tocolor(150,150,150,255*alpha),
						-- 		0.5, 0.5, getFont('montserrat_bold', 45, 'light'),
						-- 		'center', 'center'
						-- 	)

						-- end

					end,

					elements = {

						{'button',

							function(s,p) return p[4]/2 - s[4] - 8 end,
							function(s,p) return p[5] - s[5] - 25 end,
							110, 35,

							bg = 'assets/images/cm_btn_empty.png',
							activeBg = 'assets/images/cm_btn.png',

							'Вывести',

							scale = 0.5,
							font = getFont('montserrat_bold', 20, 'light'),

							color = {230,90,90,255},

							onClick = function(element)

								if not hasPlayerRight( localPlayer, 'take_balance' ) then
									return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
								end

								dialog_input('Вывод денег', 'Введите сумму вывода', {
									{ type = 'number', params = { placeholder = 'Сумма', } },
								}, function(data)

									if data then
										triggerServerEvent('clan.takeMoney', resourceRoot, data[1])
									end

								end)

							end,

						},

						{'button',

							function(s,p) return p[4]/2 + 8 end,
							function(s,p) return p[5] - s[5] - 25 end,
							110, 35,

							bg = 'assets/images/cm_btn_empty.png',
							activeBg = 'assets/images/cm_btn.png',
							-- bg = whiteTexture,

							'Положить',

							scale = 0.5,
							font = getFont('montserrat_bold', 20, 'light'),

							color = {230,90,90,255},

							onClick = function(element)

								dialog_input('Пополнить казну', 'Введите сумму пополнения', {
									{ type = 'number', params = { placeholder = 'Сумма', } },
								}, function(data)

									if data then
										triggerServerEvent('clan.putMoney', resourceRoot, data[1])
									end

								end)

							end,

						},

					},

				},

				{'element',
					'right', 'top',
					289, '100%',
					color = {0,0,0,255},

					actions = {

						{
							name = 'Устав клана',
							action = function(element)
								currentWindowSection = 'clan_rules'
							end,
						},
						{
							name = 'Правила кланов',
							action = function(element)
								currentWindowSection = 'clan_server_rules'
							end,
						},
						{
							name = function()
								return localPlayer:getData('unique.login') == currentTeamData.creator and 'Распустить клан' or 'Покинуть клан'
							end,

							action = function(element)

								local isCreator = localPlayer:getData('unique.login') == currentTeamData.creator

								dialog('Выход', {
									'Вы действительно хотите',
									isCreator and 'распустить клан?' or 'покинуть клан?',
								}, function(result)

									if result then
										
										setTimer(function()
											if isCreator then
												triggerServerEvent('clan.delete', resourceRoot)
											else
												triggerServerEvent('clan.leave', resourceRoot)
											end
										end, 1000, 1)

										closeWindow()

									end

								end)

							end,

							margin = 20,

						},

						{
							name = 'Расширить слоты',
							creator = true,

							action = function(element)

								dialog('Подтверждение', {
									('Стоимость операции - #cd4949%s R-Coin#ffffff'):format(
										Config.extendSlots.cost
									),
									('В клане прибавится #cd4949%s#ffffff %s'):format(
										Config.extendSlots.amount,
										getWordCase( Config.extendSlots.amount, 'слот', 'слота', 'слотов' )
									),
									'Продолжить?',
								}, function(result)

									if result then
										triggerServerEvent('clan.extendSlots', resourceRoot)
									end

								end)

							end,
						},

						{
							name = 'Изменить название клана',
							creator = true,

							action = function(element)
								currentWindowSection = 'change_name'
							end,
						},

						{
							name = 'Изменить титул',
							creator = true,

							action = function(element)
								changeIcon_block.elements[ currentTeamData.icon ]:onClick()
								currentWindowSection = 'change_icon'
							end,
						},

						{
							name = 'Изменить цвет клана',
							creator = true,

							action = function(element)
								currentWindowSection = 'change_color'
							end,
						},

					},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local hex = currentTeamData.color
						local r,g,b = hexToRGB(hex)

						dxDrawText('Клан',
							x + 10, y + 10,
							x + 10, y + 10,
							tocolor(r,g,b,255*alpha),
							0.5, 0.5, getFont('montserrat_bold', 30, 'light'),
							'left', 'top'
						)

						dxDrawText(currentTeamData.name,
							x + 10, y + 30,
							x + 10, y + 30,
							tocolor(r,g,b,255*alpha),
							0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
							'left', 'top'
						)

					end,

					onPostRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local isCreator = localPlayer:getData('unique.login') == currentTeamData.creator

						local lw,lh = 50, 50
						local lx,ly = x+w/2-50/2, y+h-200

						if not isCreator then

							dxDrawImage(
								lx,ly,lw,lh, 'assets/images/padlock.png',
								0, 0, 0, tocolor(180,70,70,255*alpha)
							)

							dxDrawText('Для владельца клана',
								lx, ly+lh, lx+lw, ly+lh,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
								'center', 'top'
							)

						end

					end,


					onInit = function(element)

						local startY = 100
						local w,h = element[4], 59
						local padding = 8

						for index, action in pairs( element.actions ) do

							element:addElement(
								{'button',

									'center', startY,
									w,h,

									bg = 'assets/images/mi_btn_empty.png',
									activeBg = whiteTexture,

									action.name,
									index = index,

									scale = 0.5,
									font = getFont('montserrat_semibold', 25, 'light'),

									color = {180,70,70,255},

									action = action,

									onPreRender = function(element)

										if element.activeBg then
											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local shw,shh = 397, 164

											dxDrawImage(
												x + w /2 - shw/2, y + h/2 - shh/2,
												shw, shh, 'assets/images/mi_btn_shadow.png',
												0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
											)
										end


									end,

									onInit = function(element)

										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)

									end,

									onRender = function(element)

										if element.action.creator then
											local isCreator = localPlayer:getData('unique.login') == currentTeamData.creator

											animate(element.animationAlpha, isCreator and 1 or 0.4)
											element.activeBg = isCreator and whiteTexture or nil

										else
											animate(element.animationAlpha, 1)
											element.activeBg = whiteTexture
										end

									end,

									onClick = function(element)

										if element.action.creator then

											local isCreator = localPlayer:getData('unique.login') == currentTeamData.creator

											if isCreator then
												element.action.action( element )
											end

										else
											element.action.action( element )
										end


									end,

								}
							)

							startY = startY + h + padding + ( action.margin or 0 )

						end

					end,

				},

			},

		},

	},

	edit_player_rank = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 260,
			700, 800,

			overflow = 'vertical',
			scrollXOffset = 100,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				dxDrawText('Изменить ранг',
					x, y - 40, x + w, y - 40,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
					'center', 'bottom'
				)

				if element.edit_data then
					dxDrawText('Игрок #aaaaaa' .. element.edit_data.login,
						x, y - 10, x + w, y - 10,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
						'center', 'bottom', false, false, false, true
					)
				end

			end,

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}
				setAnimData(element.ov_animId, 0.1, 0)

			end,

			update = function(element)

				element:clear()

				local startY = 30

				local w,h = element[4], 70

				for index, rank in pairs( currentTeamData.ranks ) do

					element:addElement(
						{'element',

							'center', startY,
							w,h,
							color = {255,255,255,255},

							rank = rank,
							index = index,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText(element.rank.name,
									x, y,
									x, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
									'left', 'center'
								)

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								mta_dxDrawRectangle(
									px(x), px(y + h/2), px(w-161), 1,
									tocolor(180,70,70,150*alpha) 
								)

							end,

							elements = {

								{'button',
									function(s,p) return p[4] - s[4] end, 'center',
									161, 47,
									'Установить',
									bg = 'assets/images/cr_btn_empty.png',
									activeBg = 'assets/images/cr_btn.png',

									color = {180,70,70,255},
									font = getFont('montserrat_semibold', 22, 'light'),
									scale = 0.5,

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 199/2, y + h/2 - 89/2, 199, 89

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/cr_btn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/cr_btn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onClick = function(element)

										if clanEditRank_element.edit_data then

											triggerServerEvent('clan.editPlayerRank', resourceRoot,
												clanEditRank_element.edit_data.login,
												element.parent.index
											)

										end

										currentWindowSection = 'members'

									end,

								},

							},


						}
					)

					startY = startY + h

				end

			end,

			variable = 'clanEditRank_element',

		},

		{'button',

			function(s,p)
				return p[4] - s[4] - 50
			end,

			function(s,p)
				return 50
			end,

			40, 40,
			bg = 'assets/images/creation/close.png',
			activeBg = 'assets/images/creation/close_active.png',
			define_from = '',

			'',

			color = {180, 70, 70, 255},
			activeColor = {200, 70, 70, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/creation/close_icon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

			end,

			onClick = function()
				currentWindowSection = 'members'
			end,

		},

	},

	change_name = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 400,
			600, 390,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Смена названия',
					x, y, x + w, y,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				dxDrawImage(
					x + w/2 - 197/2, y + 20,
					197, 31, 'assets/images/cn_line.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				dxDrawText(('Стоимость операции - #cd4949%s R-Coin'):format( Config.changeNameCost ),
					x, y + 60, x + w, y + 60,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
					'center', 'top', false, false, false, true
				)

				dxDrawText('Название не должно иметь оскорбительное',
					x, y + 87, x + w, y + 87,
					tocolor(120,120,140,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'center', 'top'
				)

				dxDrawText('содержание и нецензурную лексику',
					x, y + 105, x + w, y + 105,
					tocolor(120,120,140,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'center', 'top'
				)

			end,

			elements = {

				{'button',

					function(s,p)
						return p[4]
					end,

					function(s,p)
						return -30
					end,

					28, 28,
					bg = 'assets/images/creation/close.png',
					activeBg = 'assets/images/creation/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/creation/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'input',
					'center', 160,
					450, 72,
					bg = 'assets/images/cn_input.png',
					'',

					color = {23,23,36,255},
					alignX = 'center',

					placeholderColor = { 70, 70, 70, 255 },
					placeholder = 'Новое название',

					font = getFont('montserrat_semibold', 28, 'light'),
					scale = 0.5,

					maxSymbols = 10,
					possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm1234567890',

					variable = 'changeClanName_input',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('#4f4f56(От 2-х до 10-ти символов)',
							x, y + h + 10, x + w, y + h + 10,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'top', false, false, false, true
						)

					end,

				},

				{'button',
					'center', function(s,p) return p[5] - s[5] - 30 end,
					225, 55,
					'Продолжить',
					bg = 'assets/images/cn_btn_empty.png',
					activeBg = 'assets/images/cn_btn.png',

					color = {180,70,70,255},
					font = getFont('montserrat_semibold', 27, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 273/2, y + h/2 - 105/2, 273, 105

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cb_btn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cn_btn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						if #changeClanName_input[6] > 2 then

							triggerServerEvent('clan.changeName', resourceRoot, changeClanName_input[6])
							changeClanName_input[6] = ''

							currentWindowSection = 'main'


						else
							exports.hud_notify:notify('Ошибка', 'Слишком короткое имя')
						end

					end,

				},

			},

		},

	},

	change_color = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 400,
			800, 390,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Смена цвета',
					x, y, x + w, y,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				dxDrawImage(
					x + w/2 - 197/2, y + 20,
					197, 31, 'assets/images/cn_line.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

			end,

			elements = {

				{'button',

					function(s,p)
						return p[4] - 160
					end,

					function(s,p)
						return -30
					end,

					28, 28,
					bg = 'assets/images/creation/close.png',
					activeBg = 'assets/images/creation/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/creation/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'element',
					
					120, 85,
					200, 200,

					color = {255, 255, 255, 255},

					hsv = {0, 0, 1},

					variable = 'changeColor_palette',

					onInit = {

						function(element)
							element.palette_mask = 'assets/images/creation/pmask.png'

							element.animationAlpha = {}
							setAnimData(element.animationAlpha, 0.1, 1)

						end,

					},

					bg = 'assets/images/creation/palette.png',

					onRender = {

						function(element)
							
							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawImage(
								x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
									alpha = alpha,
									mask = getDrawingTexture( element.palette_mask )
								} )
							)

						end,

						function(element)

							local x,y = unpack(element.hsv)
							y = 1 - y


							local alpha = element:alpha()
							local ex,ey,ew,eh = element:abs()

							dxDrawImage(
								ex + x*ew - 8,
								ey + y*eh - 8,
								16, 16, 'assets/images/creation/palette_target.png',
								0, 0, 0, tocolor(180, 70, 70, 255*alpha)
							)

						end,

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							local r,g,b = unpack( changeColor_palette.rgb or {255,255,255} )

							drawSmartText(string.format('<img>assets/images/icons/%s.png</img> %s',
								currentTeamData.icon, currentTeamData.name
							),
								x+w+65, x+w+65, y + 50, 
								tocolor(r,g,b,255*alpha),
								tocolor(255,255,255,255*alpha),
								0.5, getFont('montserrat_bold', 52, 'light'),
								'left', 63, -15, 3
							)

							dxDrawText(('Стоимость - #cd4949%s R-Coin'):format( Config.changeColorCost ),
								x + w + 70, y + 80,
								x + w + 70, y + 80,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
								'left', 'top', false, false, false, true
							)

						end,

					},

					getColor = function(element)
						local r,g,b = hsvToRgb(unpack(element.hsv))
						return r,g,b
					end,

					onColorChange = function(element, r,g,b)
						element.rgb = {r,g,b}
					end,

					onDragDrop = function(element, _, _, x,y)

						local ex,ey = element:abs(true)

						x = x*real_sx - px(ex)
						y = y*real_sy - px(ey)
						x = x * sx/real_sx
						y = y * sx/real_sx

						local h,s = 
				            math.clamp(x / element[4],  0, 1),
				            1 - math.clamp(y / element[5],  0, 1)

			            element.hsv = {h,s, element.hsv[3]}

			            element:onColorChange( hsvToRgb( unpack(element.hsv) ) )

					end,

					elements = {

						{'element',
							function(s,p) return p[4] + 15 end, 'center',
							27, 200,

							bg='assets/images/creation/alpha.png',
							color = {255, 255, 255, 255},

							onRender = {

								function(element)
									
									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									dxDrawImage(
										x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
											alpha = alpha,
											mask = getDrawingTexture( element.palette_alpha )
										} )
									)

								end,

								function(element)

									local alpha = element:alpha()
									local ex,ey,ew,eh = element:abs()

									local y = 1-changeColor_palette.hsv[3]

									local rw, rh = ew+5, 3
									local rx,ry = ex+ew/2 - rw/2, (ey+8)+(eh-16)*y-rh/2

									mta_dxDrawRectangle(
										px(rx) - 1, px(ry) - 1,
										px(rw)+2, px(rh)+2,
										tocolor(0, 0, 0, 150*alpha)
									)

									dxDrawRectangle(
										rx,ry,
										rw,rh,
										tocolor(180, 70, 70, 255*alpha)
									)

									local r,g,b = hsvToRgb( 
										changeColor_palette.hsv[1],
										changeColor_palette.hsv[2],
										1
									)
									element.color = {r,g,b, element.color[4]}

								end,

							},

							onDragDrop = function(element, _, _, x,y)

								local ex,ey = element:abs(true)

								y = y*real_sy - px(ey)

								local v = 1-math.clamp(y / element[5],  0, 1)
								changeColor_palette.hsv[3] = v

								changeColor_palette:onColorChange( hsvToRgb( unpack(changeColor_palette.hsv) ) )
							end,

							onInit = {

								function(element)
									element.palette_alpha = 'assets/images/creation/palpha.png'
									element.parent.alphaSlider = element
								end,

							},

						},

					},

				},

				{'button',
					385, 215,
					225, 55,
					'Продолжить',
					bg = 'assets/images/cn_btn_empty.png',
					activeBg = 'assets/images/cn_btn.png',

					color = {180,70,70,255},
					font = getFont('montserrat_semibold', 27, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 273/2, y + h/2 - 105/2, 273, 105

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cb_btn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cn_btn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						triggerServerEvent('clan.changeColor', resourceRoot, RGBToHex( unpack( changeColor_palette.rgb or {255,255,255} ) ))
						currentWindowSection = 'main'

					end,

				},

			},

		},

	},


	change_icon = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 400,
			600, 480,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Смена титула',
					x, y, x + w, y,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				dxDrawImage(
					x + w/2 - 197/2, y + 20,
					197, 31, 'assets/images/cn_line.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

			end,

			elements = {

				{'button',

					function(s,p)
						return p[4] + 50
					end,

					function(s,p)
						return -30
					end,

					28, 28,
					bg = 'assets/images/creation/close.png',
					activeBg = 'assets/images/creation/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/creation/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'element',
					'center', 65,
					732, 214,
					color = {255,255,255,255},

					variable = 'changeIcon_block',

					onInit = {

						function(element)

							element.s_anim = { x = {}, y = {} }
							setAnimData(element.s_anim.x, 0.2)
							setAnimData(element.s_anim.y, 0.2)
							
						end,

						function(element)

							local startY = 0
							local startX = 0

							local w,h = 66,66
							local padding = 8

							local slot = 1

							for i1 = 1, 3 do

								startX = 0

								for i2 = 1, 10 do

									element:addElement(
										{'image',
											startX, startY,
											w,h,
											color = {21,21,33,255},

											slot = slot,

											'assets/images/creation/item_bg.png',

											onRender = function(element)

												local filepath = ('assets/images/icons/%s.png'):format(element.slot)

												if fileExists( filepath ) then

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													dxDrawImage(
														x,y,w,h, filepath,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

												end

											end,

											onClick = function(element)
												element.parent.selected = element
											end,

										}
									)

									slot = slot + 1
									startX = startX + w + padding

								end

								startY = startY + h + padding

							end

						end,

					},

					onPostRender = function(element)

						if element.selected then

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							animate(element.s_anim.x, element.selected[2])
							animate(element.s_anim.y, element.selected[3])

							local ax = getAnimData( element.s_anim.x )
							local ay = getAnimData( element.s_anim.y )

							dxDrawImage(
								x + ax + 66/2 - 70/2,
								y + ay + 66/2 - 70/2,
								70, 70, 'assets/images/creation/item_bg_a.png',
								0, 0, 0, tocolor(180,70,70,255*alpha)
							)

						end

					end,

				},

				{'button',
					'center', function(s,p) return p[5] - s[5] - 30 end,
					225, 55,
					'Продолжить',
					bg = 'assets/images/cn_btn_empty.png',
					activeBg = 'assets/images/cn_btn.png',

					color = {180,70,70,255},
					font = getFont('montserrat_semibold', 27, 'light'),
					scale = 0.5,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local r,g,b = unpack( changeColor_palette.rgb or {255,255,255} )

						drawSmartText(string.format('<img>assets/images/icons/%s.png</img> %s',
							changeIcon_block.selected.slot, currentTeamData.name
						),
							x, x+w, y - 70, 
							tocolor(r,g,b,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_bold', 52, 'light'),
							'center', 63, -15, 3
						)

						dxDrawText(('Стоимость - #cd4949%s R-Coin'):format( Config.changeIconCost ),
							x, y - 20,
							x + w, y - 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'bottom', false, false, false, true
						)

					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 273/2, y + h/2 - 105/2, 273, 105

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cb_btn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cn_btn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						if changeIcon_block.selected.slot then

							triggerServerEvent('clan.changeIcon', resourceRoot, changeIcon_block.selected.slot)
							currentWindowSection = 'main'

						end

					end,

				},

			},

		},

	},

	clan_rules = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 230,
			982, 800,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				dxDrawText('Устав клана',
					x, y - 30, x + w, y - 30,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
					'center', 'bottom'
				)

			end,

			overflow = 'vertical',
			scrollXOffset = 100,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			variable = 'clanRules_list',

			addEventHandler('onClientKey', root, function(button, state)
				if (button == 'enter' or button == 'num_enter') and state and selectedInput and currentWindowSection == 'clan_rules' then

					for _, c_element in pairs( clanRules_list.elements or {} ) do
						if selectedInput == c_element.input then
							c_element.button:onClick()
						end
					end

				end
			end),

			onInit = function(element)

				local startY = 0

				local nw,nh = 982, 69
				local padding = 10

				for i = 1, 10 do

					element:addElement(
						{'rectangle',
							'center', startY,
							nw,nh,
							color = {23,23,36,255},

							index = i,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText(element.index .. '.',
									x, y,
									x+84, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
									'center', 'center'
								)

							end,

							elements = {

								{'input',

									'center', 'center',
									function(s,p) return p[4] - 84*2 end, '100%',

									color = {18,18,27,255},
									bg = whiteTexture,
									'',

									placeholder = 'Пустой пункт',
									placeholderColor = { 46,43,64,255 },

									noEdit = true,

									scale = 0.5,
									font = getFont('montserrat_semibold', 27, 'light'),
									alignX = 'center',

									maxSymbols = 60,
									possibleSymbols = '1234567890-=+qwertyuiopasdfghjkl;zxcvbnm,.йцукенгшщзхъёфывапролджэячсмитьбю ',

									onRender = function(element)
										element.noEdit = not element.parent.editing
									end,

									onInit = function(element)
										element.parent.input = element
									end,

								},

								{'image',
									function(s,p) return p[4] - 84/2 - s[4]/2 end, 'center',
									45, 45, 'assets/images/r_edit.png',
									color = {180,70,70,255},

									onRender = function(element)

										local r,g,b

										if element.parent.editing then

											r,g,b = interpolateBetween( 15,180,105, 30,220,135, element.animData, 'InOutQuad' )
											element[6] = 'assets/images/r_ok.png'

										else

											r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
											element[6] = 'assets/images/r_edit.png'

										end

										element.color = { r,g,b, element.color[4] }

									end,

									onInit = function(element)
										element.parent.button = element
									end,

									noDraw = function(element)
										return currentTeamData.creator ~= localPlayer:getData('unique.login')
									end,

									onClick = function(element)

										if element.parent.editing then

											local text = element.parent.input[6]

											if utf8.len(text) < 5 then
												return exports.hud_notify:notify('Ошибка', 'Введите минимум 5 символов')
											end

											if text ~= element.parent.editing_prev then
												triggerServerEvent('clan.addRule', resourceRoot, element.parent.index, text ~= '' and text or false)
												element.parent.input:blur()
											end

											element.parent.editing = false
											
										else

											element.parent.editing = true
											setTimer(function()
												element.parent.input:focus()
											end, 100, 1)
											element.parent.editing_prev = element.parent.input[6]

										end

									end,


								},

							},

						}
					)

					startY = startY + nh + padding

				end

				openHandlers.clan_rules = function()

					if currentWindowSection == 'main' then

						local team_data = localPlayer.team:getData('team.data') or {}

						for _, element in pairs( clanRules_list.elements ) do
							element.input[6] = ''
						end

						for index, rule in pairs( team_data.rules or {} ) do
							clanRules_list.elements[index].input[6] = rule
						end

					end


				end

			end,


		},

		{'button',

			function(s,p)
				return p[4] - s[4] - 50
			end,

			function(s,p)
				return 50
			end,

			40, 40,
			bg = 'assets/images/creation/close.png',
			activeBg = 'assets/images/creation/close_active.png',
			define_from = '',

			'',

			color = {180, 70, 70, 255},
			activeColor = {200, 70, 70, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/creation/close_icon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

			end,

			onClick = function()
				currentWindowSection = 'main'
			end,

		},

	},

	clan_server_rules = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'element',

			'center', 'center',
			800, 600,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				dxDrawText('Правила кланов',
					x, y - 30, x + w, y - 30,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
					'center', 'bottom'
				)

			end,

			overflow = 'vertical',
			scrollXOffset = 100,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			onInit = function(element)

				local startY = 0

				local nw,nh = 752, 49
				local padding = 20

				local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')

				for _, block in pairs( Config.clan_rules ) do

					local totalH = nh + 20 + padding + (#block.content * dxGetFontHeight(scale, font))

					element:addElement(
						{'element',
							'center', startY,
							nw, totalH,
							color = {255,255,255,255},

							block = block,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawRectangle(
									x, y, w, nh,
									tocolor(21,21,33,255*alpha)
								)

								dxDrawText(
									element.block.name,
									x, y, w, y+nh,
									tocolor(180,70,70,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
									'center', 'center'
								)

								dxDrawText(table.concat( element.block.content, '\n' ),
									x + 20, y + nh + 20,
									x + 20, y + nh + 20,
									tocolor( 255,255,255,255 ),
									scale, scale, font,
									'left', 'top'
								)

							end,

						}
					)

					startY = startY + totalH + padding

				end

			end,


		},

		{'button',

			function(s,p)
				return p[4] - s[4] - 50
			end,

			function(s,p)
				return 50
			end,

			40, 40,
			bg = 'assets/images/creation/close.png',
			activeBg = 'assets/images/creation/close_active.png',
			define_from = '',

			'',

			color = {180, 70, 70, 255},
			activeColor = {200, 70, 70, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/creation/close_icon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

			end,

			onClick = function()
				currentWindowSection = 'main'
			end,

		},

	},

	ranks = {

		{'element',
			'center', 250,
			1107, 0,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Ранги клана',
					x, y - 40, x + w, y - 40,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'center', 'bottom'
				)

				dxDrawText('Название',
					x + 140, y - 15,
					x + 140, y - 15,
					tocolor(90,90,90,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'left', 'bottom'
				)

				dxDrawText('Зарплата',
					x + w - 140, y - 15,
					x + w - 140, y - 15,
					tocolor(90,90,90,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'right', 'bottom'
				)

			end,

			variable = 'ranksList',

			onInit = {

				function(element)

					local startY = 0
					local w,h = 1107, 59

					local padding = 15

					for i = 1, 10 do

						element:addElement(
							{'image',
								'center', startY,
								w,h,
								color = {35,35,50,255},
								'assets/images/r_bg1.png',

								index = i,

								onRender = function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									dxDrawText(element.index .. '.',
										x, y,
										x + 118, y + h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
										'center', 'center'
									)

								end,


								elements = {

									{'image',
										'center', 'center',
										870, 59,
										color = {30,30,45,255},
										'assets/images/r_bg2.png',

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local rank = currentTeamData.ranks[ element.parent.index ]
											if rank then

												local aw,ah = 904, 93
												dxDrawImage(
													x + w/2 - aw/2,y + h/2 - ah/2,aw,ah,
													'assets/images/r_bg2_a.png',
													0, 0, 0, tocolor(180,70,70,( 150 + 100*element.animData )*alpha)
												)

												dxDrawText(rank.name,
													x + 30,y,x+30,y+h,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
													'left', 'center'
												)

												dxDrawText(('$%s'):format( splitWithPoints( rank.salary, '.' ) ),
													x + w - 30,y,x+w - 30,y+h,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
													'right', 'center'
												)

											else

												local r,g,b = interpolateBetween( 150,150,150, 255,255,255, element.animData, 'InOutQuad' )

												dxDrawImage(
													x,y,w,h, 'assets/images/r_bg2_b.png',
													0, 0, 0, tocolor(r,g,b,255*alpha)
												)

												dxDrawText('Добавить ранг',
													x,y,x+w,y+h,
													tocolor(r,g,b,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
													'center', 'center'
												)

											end

										end,

										onClick = function(element)

											if localPlayer:getData('unique.login') ~= currentTeamData.creator then
												return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
											end

											if not currentTeamData.ranks[ element.parent.index ] then

												currentWindowSection = 'add_rank'
												addRank_settings.mode = 'new_rank'

												local default_rights = {
													salary = true,
												}

												for option, checkbox in pairs( addRank_settings.options ) do
													checkbox.checked = default_rights[option] or false
												end

												addRank_settings.edit_index = element.parent.index

											end

										end,


									},

									{'image',
										function(s,p) return p[4] - 118/2 - s[4]/2 - 25 end, 'center',
										45, 45, 'assets/images/r_edit.png',
										color = {180,70,70,255},

										onRender = function(element)
											local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										end,

										noDraw = function(element)
											return not currentTeamData.ranks[ element.parent.index ] or not hasPlayerRight(localPlayer, 'rank_edit')
										end,

										onClick = function(element)

											if localPlayer:getData('unique.login') ~= currentTeamData.creator then
												return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
											end

											local rank = currentTeamData.ranks[ element.parent.index ]

											if rank then

												currentWindowSection = 'add_rank'
												addRank_settings.mode = 'edit_rank'

												for option, checkbox in pairs( addRank_settings.options ) do
													checkbox.checked = rank.rights[option] or false
												end

												addRank_nameInput[6] = rank.name
												addRank_salaryInput[6] = rank.salary

												addRank_settings.edit_index = element.parent.index

											end


										end,


									},

									{'image',
										function(s,p) return p[4] - 118/2 - s[4]/2 + 20 end, 'center',
										45, 45, 'assets/images/r_delete.png',
										color = {180,70,70,255},

										onRender = function(element)
											local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										end,

										noDraw = function(element)
											return not currentTeamData.ranks[ element.parent.index ] or (
												currentTeamData.creator ~= localPlayer:getData('unique.login')
											)
										end,

										onClick = function(element)

											if localPlayer:getData('unique.login') ~= currentTeamData.creator then
												return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
											end

											local rank = currentTeamData.ranks[ element.parent.index ]

											if rank then

												dialog('Подтверждение', {
													'Вы действительно хотите',
													('удалить ранг #cd4949%s#ffffff?'):format(rank.name),
												}, function(result)
													if result then
														triggerServerEvent('clan.addRank', resourceRoot, element.parent.index)
													end
												end)

											end


										end,


									},

								},


							}
						)

						startY = startY + h + padding

					end

				end,

				function(element)

					openHandlers.ranks = function()

						if currentWindowSection == 'ranks' then

							local team_data = localPlayer.team:getData('team.data') or {}
							ranksList.ranks = team_data.ranks

						end

					end

				end,

			},
			

		},

	},

	add_rank = {

		{'rectangle', 0, 0, sx, (real_sy) * sx/real_sx, color = {0,0,0,180}, },

		{'button',

			function(s,p)
				return p[4] - s[4] - 50
			end,

			function(s,p)
				return 50
			end,

			40, 40,
			bg = 'assets/images/creation/close.png',
			activeBg = 'assets/images/creation/close_active.png',
			define_from = '',

			'',

			color = {180, 70, 70, 255},
			activeColor = {200, 70, 70, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/creation/close_icon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

			end,

			onClick = function()
				currentWindowSection = 'ranks'
				addRank_nameInput[6] = ''
				addRank_salaryInput[6] = ''
			end,

		},

		{'element',

			'center', 190,
			720, 800,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Настройка ранга',
					x, y, x + w, y,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

			end,

			options = {},
			variable = 'addRank_settings',

			onInit = function(element)

				local startY = 200

				local w,h = 500, 35

				for _, option in pairs( Config.rank_rights ) do

					element:addElement(
						{'element',

							'center', startY,
							w,h,
							color = {255,255,255,255},

							option = option,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText(element.option.name,
									x, y,
									x, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
									'left', 'center'
								)

							end,

							elements = {

								{'checkbox',
									'right', 'center',
									49, 25,

									color = {15,15,25,255},
									fgColor = {46,43,64,255},
									activeColor = {180,70,70,255},

									bg = 'assets/images/cb_bg.png',
									fg = 'assets/images/cb_fg.png',
									size = 35,

									padding = 1,

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										mta_dxDrawImage(
											px(x)-1, px(y)-1,
											px(w)+2, px(h)+2,
											element.bg, 0, 0, 0, 
											tocolor(150,150,150,( 50 + 100*element.animData )*alpha)
										)

									end,

									onInit = function(element)
										element.parent.parent.options[ element.parent.option.right ] = element
									end,

								}

							},

						}
					)

					startY = startY + h

				end

			end,

			elements = {

				{'input',
					'center', 50,
					350, 51,
					bg = 'assets/images/r_input.png',
					'',

					color = {21,21,32,255},
					alignX = 'center',

					placeholderColor = { 70, 70, 70, 255 },
					placeholder = 'Название ранга',

					font = getFont('montserrat_semibold', 26, 'light'),
					scale = 0.5,

					maxSymbols = 20,
					possibleSymbols = '1234567890-=+qwertyuiopasdfghjkl;zxcvbnm,.йцукенгшщзхъёфывапролджэячсмитьбю ',

					variable = 'addRank_nameInput',

				},

				{'input',
					'center', 115,
					350, 51,
					bg = 'assets/images/r_input.png',
					'',

					color = {21,21,32,255},
					alignX = 'center',

					placeholderColor = { 70, 70, 70, 255 },
					placeholder = 'Зарплата в час',

					font = getFont('montserrat_semibold', 26, 'light'),
					scale = 0.5,

					type = 'number',

					onBlur = function(element)

						element[6] = tostring(math.clamp( tonumber( element[6] ) or 0, 1000, 100000 ))

					end,

					variable = 'addRank_salaryInput',

				},

				{'button',
					'center', function(s,p) return p[5] - s[5] - 30 end,
					225, 55,
					'Готово',
					bg = 'assets/images/cn_btn_empty.png',
					activeBg = 'assets/images/cn_btn.png',

					color = {180,70,70,255},
					font = getFont('montserrat_semibold', 27, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 273/2, y + h/2 - 105/2, 273, 105

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cb_btn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cn_btn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local salary = tonumber( addRank_salaryInput[6] ) or 0
						

						if #addRank_nameInput[6] <= 2 then
							return exports.hud_notify:notify('Ошибка', 'Слишком короткое название')
						end

						local rank = {

							name = addRank_nameInput[6],
							salary = salary,

							rights = {},

						}

						for option, checkbox in pairs( addRank_settings.options ) do
							rank.rights[ option ] = checkbox.checked
						end

						if salary <= 0 and (rank.rights.salary) then
							return exports.hud_notify:notify('Ошибка', 'Введите зарплату')
						end

						triggerServerEvent('clan.addRank', resourceRoot, addRank_settings.edit_index, rank)

						currentWindowSection = 'ranks'

						addRank_nameInput[6] = ''
						addRank_salaryInput[6] = ''

					end,

				},

			},

		},

	},

	members = {

		{'button',
			sx/2 + 1106/2 - 161, -500,
			161, 47,
			'Пригласить',
			bg = 'assets/images/cr_btn_empty.png',
			activeBg = 'assets/images/cr_btn.png',

			color = {180,70,70,255},
			font = getFont('montserrat_semibold', 22, 'light'),
			scale = 0.5,

			variable = 'clanMembers_button',

			onRender = function(element)

				local lastY = 0
				local last_element = clanMembers_list.elements[ #clanMembers_list.elements ]

				if last_element then
					lastY = last_element[3] + last_element[5]
				end

				element[3] = clanMembers_list[3] + math.min( lastY, clanMembers_list[5] ) + 15

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local shx,shy,shw,shh = x + w/2 - 199/2, y + h/2 - 89/2, 199, 89

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/cr_btn_empty_shadow.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
				)
				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/cr_btn_shadow.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
				)

			end,

			onClick = function(element)

				if not hasPlayerRight(localPlayer, 'invite') then
					return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
				end

				if getTableLength(currentTeamData.members) >= currentTeamData.max_members then
					return exports.hud_notify:notify('Ошибка', 'В клане недостаточно места')
				end


				local playersList = {}

				for _, player in pairs( getElementsByType('player') ) do
					if getDistanceBetween(player, localPlayer) < 30 and player ~= localPlayer then
						table.insert(playersList, { data = player, name = player.name })
					end
				end

				if #playersList <= 0 then
					return exports.hud_notify:notify('Ошибка', 'Поблизости нет игроков')
				end

				dialog_input('Приглашение игрока', 'Заполните данные', {
					{ type = 'select', name = 'Выберите игрока', params = {
						selectElements = playersList,
					} },
				}, function(data)

					if data then

						local player = data[1]

						if not isElement(player) then
							return exports.hud_notify:notify('Ошибка', 'Игрок не найден')
						end

						triggerServerEvent('teams.sendPlayerInvite', resourceRoot, player)

					end

				end)


			end,

		},

		{'element',

			'center', 250,
			1106, 600,
			color = {255,255,255,255},

			overflow = 'vertical',
			scrollXOffset = 50,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			variable = 'clanMembers_list',

			columns = {

				{

					name = 'Ник#888888 (Логин)',
					width = 270,

					get_text = function(member)
						return member.data.nickname or '---', member.member
					end,

				},

				{

					name = 'Ранг',
					width = 200,

					get_text = function(member)

						if currentTeamData.creator == member.member then
							return '#cd4949Владелец'
						end

						return member.data.rank and currentTeamData.ranks[ member.data.rank ].name or '#888888Отсутствует'

					end,

				},

				{

					name = 'Стаж в клане',
					width = 180,

					get_text = function(member)

						local time = (serverTimestamp.timestamp - member.data.invited)

						local h = math.floor(time/3600)

						return ('%sч.'):format( h )

					end,

				},

				{

					name = 'Статус',
					width = 260,

					get_text = function(member, element)

						local player = getPlayerFromLogin( member.member )

						if isElement(player) then
							element.parent.online = element.parent.online + 1
							return '#36c15aOnline'
						else

							if member.data.enter_time then
								local time_distance = serverTimestamp.timestamp - member.data.enter_time
								local time_str

								if time_distance > 86400 then
									time_str = ('%s дн. назад'):format( math.floor( time_distance/86400 ) )
								else
									time_str = 'сегодня'
								end

								return ('#aaaaaaБыл %s'):format(
									time_str
								)
							end

						end

						return ''

					end,

				},

			},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local startX = x + 90

				for _, column in pairs( element.columns ) do

					dxDrawText(column.name,
						startX, y - 14,
						startX + column.width, y - 14,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
						'center', 'bottom', false, false, false, true
					)

					startX = startX + column.width

				end

				element.online = 0

			end,

			onPostRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText(('Участники: #ababab%s#888888   В сети: #ababab%s#ababab'):format( getTableLength(currentTeamData.members), element.online ),
					x, ( real_sy - px(50) ) * sx/real_sx,
					x+w, ( real_sy - px(50) ) * sx/real_sx,
					tocolor(136,136,136,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
					'center', 'bottom', false, false, false, true
				)

			end,

			addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

				if source == localPlayer.team and dn == 'team.data' then
					clanMembers_list:update()
				end

			end),

			onInit = function(element)

				openHandlers.members = function()

					if currentWindowSection == 'main' then
						clanMembers_list:update()
					end

				end

			end,

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}
				setAnimData(element.ov_animId, 0.1, 0)

			end,

			update = function(element)

				element:clear()

				local startY = 0

				local mw,mh = 1106, 59
				local padding = 7

				local members = {}

				local team_data = localPlayer.team:getData('team.data') or {}

				for member, data in pairs( team_data.members or {} ) do
					table.insert( members, { member = member, data = data } )
				end

				table.sort(members, function(a,b)
					return ( a.member == team_data.creator and -1 or ( a.data.rank or 0 ) ) < 
						( b.member == team_data.creator and -1 or ( b.data.rank or 0 ) )
				end)

				for index, member in pairs( members ) do

					element:addElement(
						{'image',

							'center', startY,
							mw,mh,
							color = {35,35,51,255},
							'assets/images/m_bg.png',

							index = index,
							member = member,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local rx = x + 30

								dxDrawRectangle(
									rx,y,h,h, tocolor(30,31,46,255*alpha)
								)

								dxDrawText(element.index .. '.',
									rx, y,
									rx+h, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
									'center', 'center'
								)

								local startX = x + 90

								for _, column in pairs( element.parent.columns ) do

									local text1, text2 = column.get_text(element.member, element)

									if text2 then

										dxDrawText(text1,
											startX, y + 7,
											startX + column.width, y + 7,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
											'center', 'top', false, false, false, true
										)
										dxDrawText(text2,
											startX, y + 30,
											startX + column.width, y + 30,
											tocolor(170,170,170,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'top', false, false, false, true
										)

									else

										dxDrawText(text1,
											startX, y,
											startX + column.width, y + h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
											'center', 'center', false, false, false, true
										)

									end


									startX = startX + column.width

								end


							end,

							elements = {

								{'image',
									function(s,p) return p[4] - 84/2 - s[4]/2 - 45 end, 'center',
									45, 45, 'assets/images/r_edit.png',
									color = {180,70,70,255},

									onRender = function(element)

										local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
										element.color = { r,g,b, element.color[4] }

									end,

									noDraw = function(element)

										if currentTeamData.creator == element.parent.member.member then
											return true
										end

										return not hasPlayerRight(localPlayer, 'edit_rank')
										-- return currentTeamData.creator ~= localPlayer:getData('unique.login')

									end,

									onClick = function(element)

										clanEditRank_element.edit_data = { login = element.parent.member.member }
										clanEditRank_element:update()

										currentWindowSection = 'edit_player_rank'	

									end,


								},

								{'image',
									function(s,p) return p[4] - 84/2 - s[4]/2 end, 'center',
									45, 45, 'assets/images/r_delete.png',
									color = {180,70,70,255},

									onRender = function(element)

										local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
										element.color = { r,g,b, element.color[4] }

									end,

									noDraw = function(element)

										if currentTeamData.creator == element.parent.member.member then
											return true
										end

										return currentTeamData.creator == element.parent.member.member or not hasPlayerRight(localPlayer, 'kick')

									end,

									onClick = function(element)

										if not hasPlayerRight( localPlayer, 'kick' ) then
											return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
										end

										dialog('Удаление', {
											'Вы действительно хотите',	
											('выгнать игрока #cd4949%s#ffffff?'):format( element.parent.member.member ),
										}, function(result)

											if result then
												triggerServerEvent('clan.kickMember', resourceRoot, element.parent.member.member)
											end

										end)

									end,


								},

							},


						}
					)

					startY = startY + mh + padding

				end

			end,

			elements = {

			},

		},

	},

	areas = {

		{'element',

			'center', 250,
			1129, 600,
			color = {255,255,255,255},

			overflow = 'vertical',
			scrollXOffset = 50,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			variable = 'clanAreas_list',

			columns = {

				{

					name = 'ID',
					width = 160,

					get_text = function(area)
						return area.data.id
					end,

				},

				{

					name = 'Местонахождение',
					width = 280,

					get_text = function(area)

						local x,y,z = getElementPosition(area.marker)
						local zone = getZoneName( x,y,z, true )
						return zone

					end,

				},

				{

					name = 'Прибыль в сутки',
					width = 290,

					get_text = function(area)

						local types = Config.areasData
						local amount = types[ area.data.clan_area_type or 1 ].income

						return '$' .. splitWithPoints( amount, '.' )
					end,

				},

				{

					name = 'Баланс',
					width = 230,

					get_text = function(area)
						return '$' .. splitWithPoints( area.data.clan_bank or 0, '.' )
					end,

				},

			},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local startX = x + 90

				if #(element.elements or {}) > 0 then

					for _, column in pairs( element.columns ) do

						dxDrawText(column.name,
							startX, y - 14,
							startX + column.width, y - 14,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
							'center', 'bottom', false, false, false, true
						)

						startX = startX + column.width

					end

				else

					dxDrawText('Территорий пока нет...',
						x,y,x+w,y+h,
						tocolor(150,150,150,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 36, 'light'),
						'center', 'center'
					)

				end


			end,

			onInit = function(element)

				openHandlers.upd_areas = function()

					if currentWindowSection == 'main' then
						clanAreas_list:update()
					end

				end

			end,

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}
				setAnimData(element.ov_animId, 0.1, 0)

			end,

			update = function(element)

				element:clear()

				local startY = 0

				local mw,mh = 1123, 59
				local padding = 7

				local areas = {}

				for _, area in pairs( getClanAreas( localPlayer.team ) ) do
					table.insert( areas, { marker = area, data = area:getData('business.data') or {} } )
				end

				element.areas = areas

				local team_data = localPlayer.team:getData('team.data') or {}

				for index, area in pairs( areas ) do

					element:addElement(
						{'image',

							'center', startY,
							mw,mh,
							color = {35,35,51,255},
							'assets/images/a_bg.png',

							index = index,
							area = area,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local rx = x + 30

								dxDrawRectangle(
									rx,y,h,h, tocolor(30,31,46,255*alpha)
								)

								dxDrawText(element.index .. '.',
									rx, y,
									rx+h, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
									'center', 'center'
								)

								local startX = x + 90

								for _, column in pairs( element.parent.columns ) do

									local text1 = column.get_text(element.area)

									dxDrawText(text1,
										startX, y,
										startX + column.width, y + h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
										'center', 'center', false, false, false, true
									)


									startX = startX + column.width

								end

								local aw,ah = 1141, 77
								local ax,ay = x+w/2 - aw/2, y+h/2-ah/2

								dxDrawImage(
									ax,ay,aw,ah, 'assets/images/a_bg_a.png',
									0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
								)

							end,

							hasPoint = function(element)
								return exports.main_navigation:getGPSPoint(element.area.marker)
							end,

							togglePoint = function(element)


								if element:hasPoint() then

									exports.main_navigation:removeGPSPoint( element.area.marker )

								else

									local x,y,z = getElementPosition( element.area.marker )
									local point = exports.main_navigation:createGPSPoint(
										element.area.marker,
										{ x,y,z },
										'Клан. точка', false
									)

								end


							end,

							elements = {

								{'image',
									function(s,p) return p[4] - 84/2 - s[4]/2 end, 'center',
									45, 45, 'assets/images/a_point.png',
									color = {180,70,70,255},

									onRender = function(element)

										if element.parent:hasPoint() then
											local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										else
											local r,g,b = interpolateBetween( 80,80,100, 120, 120,150, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										end


									end,

									onClick = function(element)
										element.parent:togglePoint()
									end,


								},

							},


						}
					)

					startY = startY + mh + padding

				end

			end,

			elements = {

			},

		},

	},

	wars = {

		{'element',

			'center', 250,
			1450, 700,
			color = {255,255,255,255},

			overflow = 'vertical',
			variable = 'warsList',

			columns = {

				{
					name = 'ID',
					width = 110,
					key = 'id',
				},

				{
					name = 'Место',
					width = 160,
					key = 'placement',
				},

				{
					name = 'Прибыль',
					width = 160,
					key = 'area_income',
				},

				{
					name = 'Время',
					width = 180,
					key = 'war_time_str',
				},

				{
					name = 'Противник',
					width = 190,
					key = 'opponent_name',
				},

				{
					name = 'Режим',
					width = 160,
					key = 'mode_name',
				},

				{
					name = 'Тип',
					width = 160,
					key = 'war_type',
				},

			},


			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if #element.elements == 0 then

					dxDrawText('Бои еще не назначены...',
						x,y,x+w,y+h,
						tocolor(150,150,150,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 36, 'light'),
						'center', 'center'
					)

				else

					local startX = x

					for _, column in pairs( element.columns ) do

						dxDrawText(column.name,
							startX, y - 10,
							startX + column.width, y - 10,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'bottom', false, false, false, true
						)

						startX = startX + column.width

					end

				end

			end,

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}
				setAnimData(element.ov_animId, 0.1, 0)

			end,

			update = function(element)

				element:clear()

				local wars = getTeamWars( localPlayer.team )

				local mode_names = {
					'Свое оружие',
					'Захват',
					'Стрелка',
				}

				for _, war in pairs( wars ) do

					local types = Config.areasData
					local amount = types[ war.clan_area_type or 1 ].income

					war.area_income = ('$%s'):format( splitWithPoints(amount, '.') )

					local server_timestamp = getServerTimestamp()
					local delta = (server_timestamp.timestamp - getRealTime().timestamp)

					local time = getRealTime( war.clan_war.timestamp + delta )

					war.war_time_str = war.clan_war.time_str or ('%02d.%02d %02d:%02d'):format(
						time.monthday, time.month+1, time.hour, time.minute
					)

					local l_team_data = localPlayer.team:getData('team.data') or {}

					local op_team = findTeamById( war.clan == l_team_data.id and war.clan_war.opponent or war.clan )

					war.opponent_name = ('%s%s'):format(
						RGBToHex( getTeamColor(op_team) ), op_team.name
					)

					war.mode_name = mode_names[ war.clan_war.mode ]
					war.war_type = war.clan == l_team_data.id and 'Защита' or 'Атака'

					local x,y,z = war.pos.x, war.pos.y, war.pos.z
					war.placement = getZoneName( x,y,z, true )

				end

				local w,h = 1444, 75
				local padding = -4
				local startY = 0

				for index, war in pairs( wars or {} ) do

					element:addElement(
						{'element',

							'center', startY,
							w,h,
							color = {255,255,255,255},

							war = war,
							index = index,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local ww,wh = 1428, 59
								local wx,wy = x+w/2-ww/2, y+h/2-wh/2

								dxDrawImage(
									wx,wy,ww,wh, 'assets/images/wbg.png',
									0, 0, 0, tocolor(33,33,50,255*alpha)
								)

							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local startX = x

								for _, column in pairs( element.parent.columns ) do

									dxDrawText(element.war[column.key],
										startX, y,
										startX + column.width, y + h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
										'center', 'center', false, false, false, true
									)

									startX = startX + column.width

								end

								if element.war.clan_war.starting then

									dxDrawText('Бой уже начался',
										x+w-50, y,
										x+w-50, y+h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'right', 'center'
									)

								end

								dxDrawImage(
									x,y,w,h, 'assets/images/wbg_a.png',
									0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
								)


							end,

							hasPoint = function(element)
								return exports.main_navigation:getGPSPoint(element.war.marker)
							end,

							togglePoint = function(element)


								if element:hasPoint() then

									exports.main_navigation:removeGPSPoint( element.war.marker )

								else

									local x,y,z = getElementPosition( element.war.marker )
									local point = exports.main_navigation:createGPSPoint(
										element.war.marker,
										{ x,y,z },
										'Клановая битва', false
									)

								end


							end,

							elements = {

								{'image',
									function(s,p) return p[4] - 270 - s[4]/2 end, 'center',
									45, 45, 'assets/images/wmember.png',
									color = {80,80,100,255},

									noDraw = function(element)
										return element.parent.war.clan_war.starting
									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local members = 0

										if element.parent.war and element.parent.war.clan_war then

											local war = element.parent.war.clan_war

											local team
											if currentTeamData.id == element.parent.war.clan then
												team = war.defenders or {}
											elseif currentTeamData.id == war.opponent then
												team = war.attackers or {}
											end

											members = getTableLength(team)

											element.team = team
											element.area_id = element.parent.war.id

										end

										local r,g,b = 80,80,100
										element[2] = element.parent[4] - 250 - element[4]/2

										if members > 0 then
											r,g,b = 255,255,255
											element[2] = element.parent[4] - 270 - element[4]/2
										end

										element.color = {r,g,b, element.color[4]}
										element.members = members or 0

										dxDrawText(members,
											x, y,
											x, y+h,
											tocolor(r,g,b,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
											'right', 'center'
										)


									end,

									elements = {

										{'image',

											function(s,p) return p[4] - 10 end, 'center',
											30, 30, 'assets/images/r_edit.png',
											color = {180,70,70,255},

											noDraw = function(element)
												return (element.parent.members or 0) <= 0
											end,


											onRender = function(element)

												local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
												element.color = { r,g,b, element.color[4] }

											end,

											onClick = function(element)

												local players = {}

												for login in pairs( element.parent.team or {} ) do
													table.insert(players, { name = login, data = login })
												end

												if #players <= 0 then
													return exports.hud_notify:notify('Ошибка', 'Нет участников')
												end

												if not hasPlayerRight(localPlayer, 'area_war_kick') then
													return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
												end

												dialog_input('Убрать игрока из боя',

													{
														'Выберите в списке игрока,',
														'которого хотите исключить',
														'( по игровому логину )',
													}, 
													
													{
														{ type = 'select', name = 'Выберите игрока', params = { selectElements = players, } },
													},

													function(data)

														if data and data[1] then
															triggerServerEvent('teams.kickWarMember', resourceRoot, element.parent.area_id, data[1])
														end

													end

												)

											end,

										},

									},

								},

								{'image',
									function(s,p) return p[4] - 200 - s[4]/2 end, 'center',
									45, 45, 'assets/images/a_point.png',
									color = {180,70,70,255},

									onRender = function(element)

										if element.parent:hasPoint() then
											local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										else
											local r,g,b = interpolateBetween( 80,80,100, 120, 120,150, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }
										end


									end,

									noDraw = function(element)
										return element.parent.war.clan_war.starting
									end,

									onClick = function(element)
										element.parent:togglePoint()
									end,


								},

								{'button',

									function(s,p) return p[4] - s[4] - p[5]/2 end, 'center',
									129, 38,
									'Участвовать',

									bg = 'assets/images/cr_btn_empty.png',
									_activeBg = 'assets/images/cr_btn.png',

									color = {180,70,70,255},
									font = getFont('montserrat_bold', 19, 'light'),
									scale = 0.5,

									noDraw = function(element)
										return element.parent.war.clan_war.starting
									end,

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 159/2, y + h/2 - 71/2, 159, 71

										if hasPlayerRight(localPlayer, 'area_war') then

											animate(element.animationAlpha, 1)
											element.activeBg = element._activeBg

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/cr_btn_empty_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
											)
											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/cr_btn_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
											)

										else

											animate(element.animationAlpha, 0.5)
											element.activeBg = element.bg

										end

									end,

									onRender = function(element)

										element[6] = 'Участвовать'

										if element.parent.war and element.parent.war.clan_war then

											local war = element.parent.war.clan_war

											local localLogin = localPlayer:getData('unique.login')

											if ( war.attackers and war.attackers[localLogin] ) or
											( war.defenders and war.defenders[localLogin] ) then
												element[6] = 'Покинуть'
											end

										end

									end,

									onClick = function(element)

										if not hasPlayerRight(localPlayer, 'area_war') then
											return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
										end

										triggerServerEvent('teams.toggleAreaWar', resourceRoot, element.parent.war.id)

									end,

								},

							},

						}
					)

					startY = startY + h + padding

				end


			end,

			addEvent('teams.gui.forceUpdateWar', true),
			addEventHandler('teams.gui.forceUpdateWar', resourceRoot, function( id, war_data )
				if windowOpened then

					for _, c_element in pairs( warsList.elements or {} ) do

						if c_element.war.id == id then
							c_element.war.clan_war = war_data
							break
						end

					end

				end
			end),

			onInit = function(element)

				openHandlers.wars = function()

					if currentWindowSection == 'main' then

						warsList:update()

					end

				end

			end,

			elements = {},

		},


	},

	top = {

		{'element',
			'center', 220,
			986 + 300, 769,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Рейтинг\nКланов',
					x,y+80,
					x,y+80,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 60, 'light'),
					'left', 'top'
				)

				dxDrawText('Ваше место в рейтинге',
					x,y+260,
					x,y+260,
					tocolor(150,150,150,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'left', 'top'
				)

				local place = 0

				for index, data in pairs( clanRating_list.ratings ) do

					if data.name == localPlayer.team.name then
						place = index
						break
					end

				end

				drawSmartText(string.format('%s <img>assets/images/ch_btn.png</img>',
					place
				),
					x, x, y+300, 
					tocolor(255,255,255,255*alpha),
					tocolor(230,90,90,255*alpha),
					0.5, getFont('montserrat_bold', 52, 'light'),
					'left', 14, 0, 0
				)

			end,

			elements = {

				{'image',

					'right', 'center',
					986,769,
					'assets/images/t_bg.png',
					color = {31,32,47,255},

					columns = {

						{
							name = 'Клан',
							width = 120,
							key = 'name',
						},

						{
							name = 'Рейтинг',
							width = 160,
							key = 'rating',
						},

						{
							name = 'Территории',
							width = 150,
							key = 'areas',
						},

						{
							name = 'Стаж',
							width = 130,
							key = 'hours',
						},

						{
							name = 'Участники',
							width = 140,
							key = 'members',
						},

						{
							name = 'Казна',
							width = 160,
							key = 'bank',
						},

					},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						drawImageSection(
							x,y,w,h, element[6],
							{ x = 1, y = 70/h }, tocolor(35,35,50,255*alpha)
						)
						drawImageSection(
							x,y,w,h, element[6],
							{ x = 70/w, y = 1 }, tocolor(35,35,50,255*alpha)
						)
						drawImageSection(
							x,y,w,h, element[6],
							{ x = 70/w, y = 70/h }, tocolor(42,42,60,255*alpha)
						)

						dxDrawText('№',
							x, y, x + 70, y + 70,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'center'
						)

						local startX = x + 90

						for _, column in pairs( element.columns ) do

							dxDrawText(column.name,
								startX, y,
								startX + column.width, y + 70,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
								'center', 'center', false, false, false, true
							)

							startX = startX + column.width

						end

					end,

					elements = {

						{'element',

							'center', 80,
							'100%', function(s,p) return p[5] - s[3] - 20 end,
							color = {255,255,255,255},

							variable = 'clanRating_list',

							overflow = 'vertical',
							scrollXOffset = 50,
							scrollColor = { 180,70,70, },
							scrollBgColor = { 21,21,33 },
							scrollWidth = 2,

							ratings = {},

							clear = function(element)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}
								setAnimData(element.ov_animId, 0.1, 0)

							end,

							update = function(element)

								element:clear()

								local startY = 0

								local w,h = element[4], 60
								local padding = 15

								for index, row in pairs( element.ratings ) do

									element:addElement(
										{'element',

											'center', startY,
											w,h,
											color = {255,255,255,255},

											index = index,
											row = row,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local startX = x + 90

												local isLocal = element.row.name == localPlayer.team.name

												if isLocal then

													dxDrawRectangle(
														x, y,
														w, h,
														tocolor(83,44,55, 255*alpha)
													)

												else

													dxDrawRectangle(
														x + 70, y,
														w - 70, h,
														tocolor(36,36,53, 255*alpha)
													)
													

												end

												dxDrawText(element.index .. '.',
													x, y, x + 70, y + h,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
													'center', 'center'
												)

												for _, column in pairs( element.parent.parent.columns ) do

													dxDrawText(element.row[column.key],
														startX, y,
														startX + column.width, y + h,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
														'center', 'center', false, false, false, true
													)

													startX = startX + column.width

												end


											end,

										}
									)

									startY = startY + h + padding

								end

							end,

							onInit = function(element)

								openHandlers.rating = function()

									if currentWindowSection == 'main' then
										triggerServerEvent('teams.returnClansTop', resourceRoot)
									end

									addEvent('teams.receiveClansTop', true)
									addEventHandler('teams.receiveClansTop', resourceRoot, function(top)

										clanRating_list.ratings = top
										clanRating_list:update()

									end)

								end

							end,

							elements = {},

						},

					},

				},

			},

		},

	},

	notify = {

		{'element',

			'center', 250,
			1129, 700,
			color = {255,255,255,255},

			overflow = 'vertical',
			scrollXOffset = 50,
			scrollColor = { 180,70,70, },
			scrollBgColor = { 21,21,33 },
			scrollWidth = 2,

			variable = 'clanNotify_list',

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if #element.elements == 0 then

					dxDrawText('Уведомлений пока нет',
						x,y,x+w,y+h,
						tocolor(150,150,150,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 36, 'light'),
						'center', 'center'
					)

				else

					dxDrawText('Уведомления клана',
						x, y - 30, x + w, y - 30,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
						'center', 'bottom'
					)

				end

			end,

			onInit = function(element)

				openHandlers.notify = function()

					if currentWindowSection == 'main' then
						clanNotify_list:update()
					end

				end

			end,

			addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

				if dn == 'team.data' and source == localPlayer.team then

					clanNotify_list:update()

				end

			end),

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}
				setAnimData(element.ov_animId, 0.1, 0)

			end,

			update = function(element)

				element:clear()

				local startY = 0

				local team_data = localPlayer.team:getData('team.data') or {}
				local history = team_data.history

				local rw,rh = 1129, 63
				local padding = 15

				for _, row in pairs( history or {} ) do

					element:addElement(
						{'image',

							'center', startY,
							rw,rh,
							color = {33,34,49,255},
							'assets/images/n_bg.png',

							row = row,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText(element.row.text,
									x + 30, y,
									x + 30, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'center', false, false, false, true
								)

								local time = getRealTime(element.row.time)

								dxDrawText(('%02d.%02d %02d:%02d'):format( time.monthday, time.month+1, time.hour, time.minute ),
									x + w - 30, y,
									x + w - 30, y+h,
									tocolor(150,150,150,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'right', 'center'
								)


							end,

						}
					)

					startY = startY + rh + 15

				end

			end,

			elements = {},

		},

	},

	chat = {

		{'rectangle',
			'center', 250,
			1003, 759,
			color = {34,34,49,255},

			elements = {

				{'element',

					'center', 20,
					842, 630,
					color = {255,255,255,255},

					overflow = 'vertical',
					scrollXOffset = 50,
					scrollColor = { 180,70,70, },
					scrollBgColor = { 21,21,33 },
					scrollWidth = 2,

					variable = 'clanChat_list',

					addEvent('clan.receiveMessage', true),
					addEventHandler('clan.receiveMessage', resourceRoot, function(message)
						clanChat_list:addMessage( message )
					end),

					elements = {},

					clearFirstElement = function(element)

						for _, f_element in pairs( element.elements ) do
							f_element:destroy()
							break
						end

						local startY = 20
						local padding = 15
						local index = 1

						for _index, c_element in pairs( element.elements ) do

							c_element[3] = startY
							element.elements[_index] = nil
							element.elements[index] = c_element
							startY = startY + c_element[5] + padding
							index = index + 1

						end

					end,

					addMessage = function(element, message)

						if #element.elements > 20 then
							element:clearFirstElement()
						end

						message.player_name = message.player.name

						local textSplitted = splitStringWithCount(message.text, 27)
						message.text = table.concat(textSplitted, '-\n')

						local scale, font = 0.5, getFont('montserrat_semibold', 24, 'light')
						local fontHeight = dxGetFontHeight(scale, font)

						local ipadding = { top = 50, bottom = 50 }

						local mw, mh = 350, ipadding.top + ipadding.bottom + fontHeight * #textSplitted
						local bg = createTextureSource(
							'bordered_rectangle', string.format('assets/images/msg_%s_%s', mw,mh),
							30, mw,mh
						)

						local side = message.player == localPlayer and element[4] - mw - 10 or 10

						local last_element = element.elements[#element.elements]
						local padding = 15
						local y

						if last_element then
							y = last_element[3] + last_element[5] + padding
						else
							y = 20
						end

						element:addElement(
							{'element',

								side, y,
								mw,mh+5,
								color = {255,255,255,255},

								elements = {

									{'image',

										0, 0, mw,mh,
										color = {28,29,43,255},
										bg,

										message = message,

										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local r,g,b = 70,70,80

											if element.message.player_name == localPlayer.name then
												r,g,b = 75,120,190
											end

											mta_dxDrawImage(
												px(x)-1, px(y)-1,
												px(w)+2, px(h)+2,
												element[6], 0, 0, 0, tocolor(r,g,b,255*alpha)
											)

										end,

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local time = getRealTime( element.message.time )
											local time_str = ('%02d:%02d'):format(
												time.hour, time.minute
											)

											dxDrawText(time_str,
												x + 30, y+h-ipadding.bottom + 5,
												x + 30, y+h,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'top'
											)

											dxDrawText(element.message.text,
												x + 30, y + ipadding.top,
												x + 30, y + h - ipadding.bottom,
												tocolor(255,180,180,255*alpha),
												scale, scale, font,
												'left', 'center'
											)

											dxDrawText(element.message.player_name,
												x + 30, y,
												x + 30, y + ipadding.top - 5,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'bottom', false, false, false, true
											)

											if element.message.rank then

												dxDrawText(element.message.rank,
													x + w - 30, y,
													x + w - 30, y + ipadding.top - 5,
													tocolor(150,150,150,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
													'right', 'bottom', false, false, false, true
												)

											end

										end,

									},
								
								},

							}
						)

						element:update_endY()

						if element.ov_endY > element[5] then
							setAnimData(element.ov_animId, 0.1, -element.ov_endY+element[5])
						end

					end,

				},

				{'image',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					842, 59,
					color = {28,29,43,255},
					'assets/images/ch_input.png',

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						mta_dxDrawImage(
							px(x)-1, px(y)-1,
							px(w)+2, px(h)+2,
							element[6], 0, 0, 0, tocolor(70,70,80,255*alpha)
						)

					end,

					elements = {

						{'input',

							20, 'center',
							function(s,p) return p[4] - s[2] - 50 end, '100%',
							color = {255,255,255,255},
							bg = false,
							'',

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),
							alignX = 'left',

							variable = 'clanChat_input',
							possibleSymbols = '1234567890-=+qwertyuiopasdfghjkl;zxcvbnm,.йцукенгшщзхъёфывапролджэячсмитьбю ',

							maxSymbols = 200,

						},

						{'image',
							function(s,p) return p[4] - s[4] - 10 end, 'center',
							46, 46, 'assets/images/ch_btn.png',
							color = {180,70,70,255},

							onRender = function(element)

								local r,g,b = interpolateBetween( 180,70,70, 230, 90,90, element.animData, 'InOutQuad' )
								element.color = { r,g,b, element.color[4] }

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x,y,w,h, 'assets/images/ch_btn_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

							variable = 'clanChat_button',

							addEventHandler('onClientKey', root, function(button, state)
								if (button == 'enter' or button == 'num_enter') and state and selectedInput == clanChat_input then
									clanChat_button:onClick()
								end
							end),

							onClick = function(element)

								if element.last_message and ( getTickCount(  ) - element.last_message ) < 5000 then
									return exports.hud_notify:notify('Ошибка', 'Не более 1 сообщения в 5 сек.')
								end

								element.last_message = getTickCount(  )

								local message = clanChat_input[6]

								if utf8.len(message) < 1 then
									return
								end

								triggerServerEvent('clan.sendMessage', resourceRoot, message)

								clanChat_input[6] = ''

							end,


						},

					},

				},

			},

		},

	},

}

------------------------------------------------------

	GUIDefine('mm_button', {

		[4] = 193,
		[5] = 41,

		bg = 'assets/images/mansion/mbtn_empty.png',
		activeBg = 'assets/images/mansion/mbtn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 21, 'light'),

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 210/2, y + h/2 - 58/2, 210, 58

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/mansion/mbtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/mansion/mbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

	})

------------------------------------------------------

loadGuiModule()


end)

