
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f11'] = true,
	['f10'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['t'] = true,
	['y'] = true,
}

openHandler = function()
end
closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

hideBackground = true

windowModel = {

	main = {

		{'image',
			'center', 'center',
			641, 629,

			'assets/images/bg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 659/2,
					y + h/2 - 647/2 + 5,
					659, 647, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Подача объявления',
					x,y+35, x+w, y+35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 33, 'light'),
					'center', 'top'
				)

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

				{'button',

					'center', 629 - 57 - 40,
					185, 57,

					bg = 'assets/images/button_empty.png',
					activeBg = 'assets/images/button.png',

					'Опубликовать',

					scale = 0.5,
					font = getFont('montserrat_semibold', 25, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 217/2, y + h/2 - 91/2, 217, 91
						
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onInit = function(element)
						element.f_animId = {}
						setAnimData(element.f_animId, 0.1, 1)
						element.animationAlpha = element.f_animId
					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						animate(element.f_animId, 0)
						local size = 40

						displayLoading( {x+w/2-size/2, y+h/2-size/2, size, size}, {180,70,70,255}, 500, function()

							animate(element.f_animId, 1)

							local text = gui_get('ad_text')[6]
							if #text == 0 then return end

							triggerServerEvent('ads.createAd', resourceRoot,
								gui_get('ad_text')[6], gui_get('count_select').count_id, createAd_tabs.tab.id)
							-- closeWindow()

							gui_get('ad_text')[6] = ''
							gui_get('count_select').count_id = 1

							currentWindowSection = 'list'

						end )

					end,


				},

				{'tabs',

					[3] = 90,
					variable = 'createAd_tabs',
					d_scale = 0.85,

				},

				{'textarea',

					'center', 135,
					540, 194,
					bg = 'assets/images/ad_input.png',
					id = 'ad_text',

					padding = 25,

					color = {21,21,33,255},
					placeholderColor = {75,78,101,255},

					placeholder = 'Введите текст',
					'',

					possibleSymbols = '1234567890-qwertyuiopasdfghjklzxcvbnm,.;:йцукенгшщзхъфывапролджэячсмитьбю ',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText(string.format('%s #464c73/ 100',
							utf8.len(element[6])
						),
							x+w-20, y+h-20,
							x+w-20, y+h-20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'bold'),
							'right', 'bottom', false, false, false, true

						)

					end,

					maxSymbols = 100,

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,


				},

				{'element',

					'center', 380,
					'100%', 0,
					color = {255,255,255,255},
					id = 'count_select',
					count_id = 1,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите длительность объявления в часах',
							x, y-15,
							x+w, y-15,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'bottom'
						)

						dxDrawText('Подавать объявление можно не чаще, чем раз в три минуты,\nвсе объявления публикуются на доске объявлений',
							x, y +h + 80,
							x+w, y +h + 80,
							tocolor(180, 180, 180, 255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
							'center', 'top'
						)

					end,

					onInit = function(element)

						local ex,ey,ew,eh = element:abs()

						local w,h = 120, 60
						local padding = 0

						local sCount = #Config.adsCost/2

						local startX = ew/2 - sCount*w - padding*(sCount-0.5)
						local startY = 0

						local rw,rh = 30, 30

						for index, cost_select in pairs( Config.adsCost ) do

							element:addElement(
								{'image',

									startX+w/2-rw/2, startY,
									rw,rh,

									color = {21,21,33,255},
									'assets/images/round.png',

									index = index,
									data = cost_select,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local r,g,b = 21,21,33

										if element.parent.count_id == element.index then
											r,g,b = 180, 70, 70
										end

										dxDrawText(element.data.hours,
											x,y,x+w,y+h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'center'
										)

										element.color = {r,g,b, element.color[4]}

										drawSmartText(string.format('%s <img>assets/images/money.png</img>',
											splitWithPoints(element.data.cost or 0, '.')
										),
											x, x+w, y+h+20, 
											tocolor(255,255,255,255*alpha),
											tocolor(255,255,255,255*alpha),
											0.5, getFont('montserrat_semibold', 27, 'light'),
											'center', 20, 0
										)

									end,

									onClick = function(element)
										element.parent.count_id = element.index
									end,

								}
							)

							startX = startX + w + padding

						end

					end,

				},

			},

		},

	},

	list = {

		{'image',
			'center', 'center',
			766, 500,
			'assets/images/c/cbg.png',

			color = {25,24,38,255},

			onInit = function(element)

				openHandlers.receive = function()

					if currentWindowSection == 'list' then
						triggerServerEvent('ads.return', resourceRoot)
					end

				end

			end,

			addEvent('ads.receive', true),
			addEventHandler('ads.receive', resourceRoot, function(ads)

				adsList.currentAds = ads
				adTabs:update( adsList.currentAds )


			end),

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + 30, y + 30,
					56, 56, 'assets/images/c/c_icon_bg.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				dxDrawImage(
					x + 30, y + 30,
					56, 56, 'assets/images/c/c_icon.png',
					0, 0, 0, tocolor(140, 50, 50, 255*alpha)
				)

				dxDrawText('Доска объявлений',
					x, y + 30 + 56/2, x + w, y + 30 + 56/2,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'center'
				)

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

				{'image',
					'center', function(s,p) return p[5]-s[5]-( (p[4] - s[4])/2 ) end,
					701, 375,
					'assets/images/c/cbg1.png',
					color = {21,21,33,255},

					onRender = function(element)
					end,

					elements = {

						{'tabs',

							[3] = 20,
							variable = 'adTabs',

							update = function(element)
								local f_ads = {}

								for _, ad in pairs( adsList.currentAds ) do

									if ad.type == element.tab.id then

										table.insert( f_ads, ad )

									end

								end

								adsList:update(f_ads)
							end,

							onTabChange = function(element)
								element:update()
							end,

						},

						{'image',
							'center', 70,
							668, 47,
							color = {25,24,38,255},
							'assets/images/c/chead.png',

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText(('Найдено #cd4949%s#ffffff %s'):format(#adsList.elements,
									getWordCase( #adsList.elements, 'объявление', 'объявления', 'объявлений' )
								),
									x + 30, y,
									x + 30, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'center', false, false, false, true
								)

							end,

							elements = {

								{'button',

									function(s,p) return p[4] - s[4] - 10 end, 'center',
									170, 32,

									bg = 'assets/images/c/cbtn.png',

									'Новое объявление',

									scale = 0.5,
									font = getFont('montserrat_semibold', 21, 'light'),

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 212/2, y + h/2 - 74/2, 212, 74
										
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/c/cbtn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
										)

									end,

									onInit = function(element)
										element.f_animId = {}
										setAnimData(element.f_animId, 0.1, 1)
										element.animationAlpha = element.f_animId
									end,

									onClick = function(element)

										currentWindowSection = 'main'

									end,


								},

							},

						},

						{'element',

							'center', function(s,p) return p[5]-s[5]-( (p[4] - s[4])/2 ) end,
							668, 230,
							color = { 255, 255, 255, 255 },

							overflow = 'vertical',
							variable = 'adsList',

							scrollXOffset = 25,

							logins_to_players = {},

							getPlayerFromLogin = function(element, login)

								if isElement(element.logins_to_players[login]) then
									return element.logins_to_players[login]
								end

								local player = findElementByData('player', 'unique.login', login)

								if isElement(player) then
									element.logins_to_players[login] = player
								end

								return element.logins_to_players[login] or false

							end,

							update = function(element, ads)

								setAnimData(element.ov_animId, 0.1, 0)

								local localLogin = localPlayer:getData('unique.login')

								table.sort(ads, function(a,b)

									local w1 = a.player == localLogin and 1 or 0
									local w2 = b.player == localLogin and 1 or 0
									return w1 > w2

								end)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

								local w,h = 326, 172
								local padding = element[4] - w*2

								local startY = 0

								for index, ad in pairs( ads ) do

									local side = ( index % 2 ) == 0 and 'right' or 'left'

									element:addElement(
										{'image',

											side, startY,
											w,h,
											color = {25,24,38,255},

											'assets/images/c/citem_bg.png',

											ad = ad,

											onInit = function(element)

												element.text = splitStringWithCount(element.ad.ad_text, 27)

											end,

											onRender = function(element)

												local x,y,w,h = element:abs()
												local alpha = element:alpha()

												local r,g,b = 100,100,100

												local player = adsList:getPlayerFromLogin(element.ad.player)
												if isElement(player) then

													if player:getData('isAFK') then
														r,g,b = 255,220,0
													else
														r,g,b = 70,180,70
													end

												end

												dxDrawImage(
													x + 5, y + 5,
													51, 51, 'assets/images/c/c_status.png',
													0, 0, 0, tocolor(r,g,b, 255*alpha)
												)


												local text = element.ad.player
												if element.ad.player == localPlayer:getData('unique.login') then
													text = 'Ваше объявление'
												end

												dxDrawText(text,
													x + 50, y + 5 + 51/2,
													x + 50, y + 5 + 51/2,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
													'left', 'center'
												)

												dxDrawText(table.concat(element.text, '\n'),
													x + 30, y + 60,
													x + 30, y + 60,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
													'left', 'top'

												)

											end,

											elements = {

												{'button',

													function(s,p) return p[4] - s[4] end, -5,
													82, 70,

													bg = 'assets/images/c/msg_icon_bg.png',

													'',

													scale = 0.5,
													font = getFont('montserrat_semibold', 21, 'light'),

													color = {180, 70, 70, 255},
													activeColor = {200, 70, 70, 255},

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														dxDrawImage(
															x,y,w,h, 'assets/images/c/msg_icon.png',
															0, 0, 0, tocolor(255,255,255,255*alpha)
														)

													end,

													onClick = function(element)

														local player = adsList:getPlayerFromLogin(element.parent.ad.player)

														if player == localPlayer then
															return exports.hud_notify:notify('Ошибка', 'Нельзя написать себе')
														end

														if isElement(player) then

															closeWindow()

															setTimer(function(player)

																exports.main_messages:openWindow('main')
																exports.main_messages:openChat(player)

															end, 1000, 1, player)

														else
															exports.hud_notify:notify('Ошибка', 'Игрок не в сети')
														end

													end,


												},

												{'button',

													function(s,p) return p[4] - s[4] - 10 end,
													function(s,p) return p[5] - s[5] - 10 end,
													30, 30,

													bg = 'assets/images/close_icon.png',

													'',

													scale = 0.5,
													font = getFont('montserrat_semibold', 21, 'light'),

													color = {255, 255, 255, 255},
													activeColor = {200, 70, 70, 255},

													noDraw = function(element)
														return not exports.acl:isAdmin(localPlayer) and element.parent.ad.player ~= localPlayer:getData('unique.login')
													end,

													onClick = function(element)

														dialog('Удаление', 'Удалить это объявление?', function(result)

															if result then
																triggerServerEvent('ads.remove', resourceRoot, element.parent.ad.id)
															end

														end)

													end,


												},

											},


										}
									)

									if side == 'right' then
										startY = startY + h + padding
									end


								end

							end,

							elements = {},

						},

					},

				},

			},


		},

	},

}


--------------------------------------------------------------

	GUIDefine('tabs', {

		[2]='center', [3]=0,
		[4]=0, [5] = 37,

		color = {255,255,255,255},

		types = {
			car = { name = 'Авто', },
			business = { name = 'Бизнес', },
			house = { name = 'Дом', },
			number = { name = 'Номер', },
		},

		onInit = function(element)

			local d_scale = element.d_scale or 1

			local tw,th = 148*d_scale, 37*d_scale
			local padding = 10*d_scale

			local tabs = {
				{ id = 'car', name = 'Авто' },
				{ id = 'business', name = 'Бизнес' },
				{ id = 'house', name = 'Дом' },
				{ id = 'number', name = 'Номер' },
			}

			local sCount = #tabs/2

			local startX = element[4]/2 - sCount*tw - padding*(sCount-0.5)
			local startY = 0

			for _, tab in pairs( tabs ) do

				element:addElement(
					{'button',

						[2] = startX,
						[4] = tw, [5] = th,

						name = tab.name,
						id = tab.id,

						define_from = 'tab',
						d_scale = d_scale,

					}
				)

				startX = startX + tw + padding

			end

			element.tab = element.elements[1]

		end,

	})

	GUIDefine('tab', {

		[2]='center', [3]=0,
		[4]=148, [5] = 37,


		bg = 'assets/images/tab_empty.png',

		color = { 200,80,80,255 },
		[6]='',

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local d_scale = element.d_scale or 1

			local text = element.name or ''
			local scale, font = 0.5, getFont('montserrat_semibold', 23*d_scale, 'light')

			local textWidth = dxGetTextWidth( text, scale, font )
			local texture = getDrawingTexture( ('assets/images/types/%s.png'):format( element.id ) )

			local mw,mh = dxGetMaterialSize( texture )
			local iw,ih = mw*d_scale,mh*d_scale

			local i_padding = 8 * d_scale

			local startX = x+w/2 - ( textWidth + iw + i_padding )/2

			local iy = y+h/2-ih/2

			dxDrawText(text,
				startX, y,
				startX, y+h,
				tocolor(255,255,255,255*alpha),
				scale, scale, font,
				'left', 'center'
			)

			dxDrawImage(
				startX + textWidth + i_padding,iy,iw,ih, texture,
				0, 0, 0, tocolor( 255,255,255,255*alpha )
			)

			element.bg = element.parent.tab.id == element.id and 'assets/images/tab.png' or 'assets/images/tab_empty.png'

		end,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local d_scale = element.d_scale or 1

			local shadow = {
				['assets/images/tab_empty_shadow.png'] = (1-element.animData),
				['assets/images/tab_shadow.png'] = element.animData,
			}

			for path, anim in pairs( shadow ) do

				local texture = getDrawingTexture( path )

				local mw,mh = dxGetMaterialSize( texture )
				mw,mh = mw*d_scale,mh*d_scale

				local mx,my = x+w/2-mw/2, y+h/2-mh/2

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
				)

			end

		end,

		onClick = function(element)

			element.parent.tab = element
			element.parent:callHandler('onTabChange')

		end,


	})

--------------------------------------------------------------


loadGuiModule()


end)

