
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['i'] = true,
	['m'] = true,
}

openHandler = function()
	selectPlayerList:update()
end

closeHandler = function()
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'window',

			'center', 'center',
			525, 828,
			color = {255,255,255,255},

			close = function()

				triggerServerEvent('exchange.cancel', resourceRoot)
				closeWindow()

			end,

			bg = 'assets/images/bg.png',
			shadow = 'assets/images/bg_shadow.png',

			init = function(element)

				element:addHandler('onRender', function(element)

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local ix,iy, iw,ih = x+20, y + 20, 56,56

					dxDrawImage(
						ix,iy,
						iw,ih,
						'assets/images/icon_bg.png',
						0, 0, 0, tocolor(180, 70, 70, 255*alpha)
					)

					dxDrawImage(
						ix,iy,
						iw,ih,
						'assets/images/icon.png',
						0, 0, 0, tocolor(0, 0, 0, 100*alpha)
					)

					dxDrawText('Обмен имуществом',
						ix+iw+5,iy,
						ix+iw+5,iy+ih,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

					if localPlayer:getData('exchange.primaryPlayer') then

						drawSmartText(string.format('<img>assets/images/tax.png</img> #9f9f9fНалог на сделку: #ffffff $%s',
							splitWithPoints( math.floor(
								getCurrentExchangeTax( localPlayer, localPlayer:getData('exchange.player') )
							) , '.')
						),
							x, x+w, y+110, 
							tocolor(255,255,255,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_medium', 27, 'light'),
							'center', 30, 0
						)

					else

						local ex_player = localPlayer:getData('exchange.player')

						if isElement(ex_player) then
							dxDrawText(('Налог платит %s'):format( ex_player.name ),
								x, y+110,
								x+w, y+110,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
								'center', 'center'
							)
						end

					end


				end)

			end,

			addEvent('exchange.clearLists', true),
			addEventHandler('exchange.clearLists', resourceRoot, function()
				exchangeList_local.listElements = {}
				exchangeList_opposite.listElements = {}
			end),

			elements = {

				{'button',

					'center', function(s,p) return p[5] - s[5] - 40 end,
					[6] = 'Произвести обмен',

					onInit = function(element)

						closeHandlers.cancel_exchange = function()

							exchangeButton:stopTimer()

						end

					end,

					noDraw = function(element)
						if isTimer(element.timer) then return false end
						return not localPlayer:getData('exchange.primaryPlayer')
					end,

					time = 10000,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						if isTimer(element.timer) then

							local left = getTimerDetails(element.timer)
							local seconds = math.floor( ( element.time -(element.time - left ))/1000 )

							dxDrawText(('До обмена осталось #cd4949%s#ffffff сек.'):format( seconds ),
								x, y - 7, x + w, y - 7,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
								'center', 'bottom', false, false, false, true
							)

							element[6] = 'Отменить обмен'
							element[3] = element.parent[5] - element[5] - 20

						else

							element[6] = 'Произвести обмен'
							element[3] = element.parent[5] - element[5] - 40

						end


					end,
					variable = 'exchangeButton',

					startTimer = function(element)

						element.timer = setTimer(function()
							if localPlayer:getData('exchange.primaryPlayer') then
								triggerServerEvent('exchange.doExchange', resourceRoot)
							end
						end, element.time, 1)

					end,

					stopTimer = function(element)

						if isTimer(element.timer) then
							killTimer(element.timer)
						end

					end,

					addEventHandler('onClientElementDataChange', root, function(dn, old, new)

						if dn == 'exchange.timer' and (source == localPlayer or source == localPlayer:getData('exchange.player')) then

							if new then
								exchangeButton:startTimer()
							else
								exchangeButton:stopTimer()
							end

						end

					end),

					exchangeIsReady = function()

						local ex_player = localPlayer:getData('exchange.player')

						if isElement(ex_player) then

							local ready_1 = localPlayer:getData('exchange.ready1') and localPlayer:getData('exchange.ready2')
							local ready_2 = ex_player:getData('exchange.ready1') and ex_player:getData('exchange.ready2')
							return ready_1 and ready_2

						end

						return false

					end,

					onClick = function(element)

						if isTimer(element.timer) then

							element:stopTimer()
							triggerServerEvent('exchange.cancel', resourceRoot)
							closeWindow()

						else

							if element:exchangeIsReady() then

								localPlayer:setData('exchange.timer', true)

							else

								exports.hud_notify:notify('Ошибка', 'Участники не готовы')

							end


						end


					end,

				},

				{'image',
					'center', 185,
					426, 186,
					color = {21,21,33,255},
					'assets/images/list_bg.png',

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Ваше предложение',
							x + 10, y - 20,
							x + 10, y - 20,
							tocolor(255,255,255, 255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
							'left', 'center'
						)

					end,

					elements = {


						{'button',

							'center', function(s,p) return p[5] + 30 end,
							[6] = 'Добавить',

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local iw,ih = 20,20

								local r,g,b = interpolateBetween(95,230,160, 255,255,255, element.animData, 'InOutQuad')

								dxDrawImage(
									x + w - iw - 20, y+h/2 - ih/2,
									iw,ih, 'assets/images/add_icon.png',
									0, 0, 0, tocolor(r,g,b,255*alpha)
								)

							end,

							onClick = function(element)

								if isTimer( exchangeButton.timer ) then

									exports.hud_notify:notify('Ошибка', 'Производится обмен')

								else
									
									currentWindowSection = 'exchange_add_item'
									addItem_list:update(addItem_tabs.tab.id)

								end

							end,

						},

						{'ready-state',

							function(s,p) return p[4] - s[4] - 15 end,
							function(s,p) return -20 - s[5]/2  end,

							getPlayer = function() return localPlayer end,

						},

						{'ready-state',

							function(s,p) return p[4] - s[4] - 15 - 30 end,
							function(s,p) return -20 - s[5]/2  end,

							getPlayer = function() return localPlayer end,
							index = 2,

						},

						{'list',

							'center', 15,
							'100%', function(s,p) return p[5] - s[3]*2 end,

							scrollBg = scrollTexture,

							scrollColor = {180, 70, 70,255},
							scrollBgColor = {18,18,31,255},

							scrollWidth = 5,
							listOffset = 0,
							listElements = {},

							font = 'default',
							scale = 1,

							listElementHeight = 40,

							color = {255,255,255,255},

							variable = 'exchangeList_local',

							addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
								if dataName == 'exchange.items' and new then
									local list = {}

									for _, item in pairs(new) do
										if item.exchange then
											table.insert(list, item)
											item.clickHandlers = {
												{
													getCoords = function(element, x,y)

														local ex,ey,ew,eh = element:abs()

														local w,h = ew, 40
														local x,y = ew/2-w/2, y+element.listElementHeight/2-h/2

														return {
															x+w-h/2-25/2, y+h/2-25/2,
															25,25, 
														}

													end,

													handle = function(lElement)

														if isTimer( exchangeButton.timer ) then

															exports.hud_notify:notify('Ошибка', 'Производится обмен')

														else

															local items = localPlayer:getData('exchange.items') or {}

															for key, item in pairs(items) do
																if item.exchange_type == lElement.exchange_type then
																	if item.exchange_type == 'money' then
																		items[key] = nil
																	elseif item.id == lElement.id then
																		items[key].exchange = false
																	end
																end
															end

															localPlayer:setData('exchange.items', items)															

														end

													end,
												},
											}
										end
									end

									exchangeList_local.listElements = list
								end
							end),

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local w,h = ew, 40
								local x,y = ew/2-w/2, y+element.listElementHeight/2-h/2

								local r,g,b = interpolateBetween( 28,28,41, 180, 70, 70, animData, 'InOutQuad' )
								local tr,tg,tb = interpolateBetween( 255,255,255, 50, 50, 50, animData, 'InOutQuad' )

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b, 255*alpha)
								)

								local name = lElement.name
								if lElement.exchange_type ~= 'vehicle' then
									name = string.format('%s %s', convertTypeToString(lElement.exchange_type), lElement.name)
								end

								dxDrawText(name,
									x + 20, y,
									x + 20, y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
									'left', 'center'
								)

								dxDrawText('+',
									x+w-h/2, y,
									x+w-h/2, y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_bold', 30, 'light'),
									'center', 'center', false, false, false, false, false, 45
								)

							end,

						},

					},

				},

				{'image',
					'center', 520,
					426, 186,
					color = {21,21,33,255},
					'assets/images/list_bg.png',

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local e_player = localPlayer:getData('exchange.player')
						if not isElement(e_player) then return end

						dxDrawText(string.format('Предложение %s', clearColorCodes(e_player.name)),
							x + 10, y - 20,
							x + 10, y - 20,
							tocolor(255,255,255, 255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
							'left', 'center'
						)

					end,

					elements = {

						{'ready-state',

							function(s,p) return p[4] - s[4] - 15 end,
							function(s,p) return -20 - s[5]/2  end,

							getPlayer = function() return localPlayer:getData('exchange.player') end,

						},

						{'ready-state',

							function(s,p) return p[4] - s[4] - 15 - 30 end,
							function(s,p) return -20 - s[5]/2  end,

							getPlayer = function() return localPlayer:getData('exchange.player') end,
							index = 2,

						},

						{'list',

							'center', 15,
							'100%', function(s,p) return p[5] - s[3]*2 end,

							scrollBg = scrollTexture,

							scrollColor = {180, 70, 70,255},
							scrollBgColor = {18,18,31,255},

							scrollWidth = 5,
							listOffset = 0,
							listElements = {},

							font = 'default',
							scale = 1,

							listElementHeight = 40,

							color = {255,255,255,255},

							variable = 'exchangeList_opposite',

							addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
								local partner = localPlayer:getData('exchange.player')
								if dataName == 'exchange.items' and source == partner and new then
									local list = {}

									for _, item in pairs(new) do
										if item.exchange then
											table.insert(list, item)
										end
									end

									exchangeList_opposite.listElements = list

								end

								if (source == localPlayer or source == partner) and dataName == 'exchange.items' then
									localPlayer:setData('exchange.ready1', false)
									localPlayer:setData('exchange.ready2', false)
								end

							end),

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local w,h = ew, 40
								local x,y = ew/2-w/2, y+element.listElementHeight/2-h/2

								local r,g,b = interpolateBetween( 28,28,41, 180, 70, 70, animData, 'InOutQuad' )
								local tr,tg,tb = interpolateBetween( 255,255,255, 50, 50, 50, animData, 'InOutQuad' )

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b, 255*alpha)
								)

								local name = lElement.name
								if lElement.exchange_type ~= 'vehicle' then
									name = string.format('%s %s', convertTypeToString(lElement.exchange_type), lElement.name)
								end

								dxDrawText(name,
									x + 20, y,
									x + 20, y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
									'left', 'center'
								)

							end,

						},

					},

				},

			},

		},

	},

	select_player = {

		{'window',

			'center', 'center',
			330, 437,
			color = {255,255,255,255},

			close = function() closeWindow() end,
			name = 'Выбор игрока',

			bg = 'assets/images/sp_bg.png',
			shadow = 'assets/images/sp_bg_shadow.png',

			init = function(element)
			end,

			elements = {

				{'button',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					[6] = 'Предложить',

					onInit = function(element)
						element.animationAlpha = element.animationAlpha or {}
						setAnimData(element.animationAlpha, 0.1, 1)
					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						animate(element.animationAlpha, 0)
						displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

							animate(element.animationAlpha, 1)

							local player = selectPlayerList.lastSelectedItem

							if not player or (not isElement(player.player)) then
								return
							end

							triggerServerEvent('exchange.invite', resourceRoot, player.player)
							closeWindow()


						end )

					end,

				},

				{'input',

					'center', 80,
					placeholder = 'Поиск игрока',

					variable = 'searchInput',

					onInput = function(element)
						selectPlayerList:update(element[6])
					end,

				},

				{'image',
					'center', 135,
					241, 202,
					color = {21,21,33,255},
					'assets/images/sp_list.png',

					elements = {

						{'list',

							'center', 15,
							'100%', function(s,p) return p[5]-s[3]*2 end,

							scrollBg = scrollTexture,

							scrollColor = {180, 70, 70,255},
							scrollBgColor = {18,18,31,255},

							scrollWidth = 4,
							scrollHeight = 0.9,
							scrollXOffset = -25,

							listOffset = 0,

							listElements = {
								
							},

							font = 'default',
							scale = 0.5,

							listElementHeight = 45,

							color = {255,255,255,255},

							variable = 'selectPlayerList',

							update = function(element, filter)

								local list = {}

								for _, player in pairs( getElementsByType('player') ) do
									if isPlayerExchangeCompatible(player)
										and (not filter or player.name:find(filter))
									then
										table.insert(list, { player = player })
									end
								end

								element.listElements = list

							end,

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local w,h = ew, 40
								local x,y = ew/2-w/2, y+element.listElementHeight/2-h/2

								local r,g,b = interpolateBetween( 28,28,41, 180, 70, 70, animData, 'InOutQuad' )
								local tr,tg,tb = interpolateBetween( 255,255,255, 50, 50, 50, animData, 'InOutQuad' )

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b, 255*alpha)
								)

								dxDrawText(clearColorCodes(lElement.player.name),
									x, y,
									x + w, y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
									'center', 'center'
								)

							end,

						}

					},

				},

			},

		},

	},

	waiting = {

		{'window',

			'center', 'center',
			380, 233,
			color = {255,255,255,255},

			name = 'Ожидание',

			bg = 'assets/images/w_bg.png',
			shadow = 'assets/images/w_bg_shadow.png',

			init = function(element)

				element:addHandler('onRender', function(element)

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local rows = {
						'Ожидание подтверждения',
						'сделки другим игроком',
					}

					local startY = y + 75

					for _, row in pairs(rows) do
						dxDrawText(row,
							x, startY, x+w, startY,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 27, 'light'),
							'center', 'top'
						)
						startY = startY + 20
					end

				end)

			end,

			elements = {

				{'button',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					[6] = 'Отмена',

					onClick = function(element)
						triggerServerEvent('exchange.cancel', resourceRoot)
						closeWindow()
					end,

				},

			},

		},

	},


	invite = {

		{'window',

			'center', 'center',
			422, 223,
			color = {255,255,255,255},

			name = '',

			bg = 'assets/images/i_bg.png',
			shadow = 'assets/images/i_bg_shadow.png',

			init = function(element)

				element:addHandler('onRender', function(element)

					local player = localPlayer:getData('exchange.inviter')
					if not isElement(player) then return end

					element.name = string.format('%s предлагает обмен', clearColorCodes(player.name))

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local rows = {
						'Подробности обмена можно будет',
						'посмотреть в следующем окне',
					}

					local startY = y + 70

					for _, row in pairs(rows) do
						dxDrawText(row,
							x, startY, x+w, startY,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 27, 'light'),
							'center', 'top'
						)
						startY = startY + 20
					end


				end)

			end,

			elements = {

				{'element',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					350, 46,
					color = {255,255,255,255},

					elements = {

						{'button',

							'left', 0,
							167, 46,
							[6] = 'Принять',

							bg = 'assets/images/ibtn_empty.png',
							activeBg = 'assets/images/ibtn.png',

							shadow = 'assets/images/ibtn_empty_shadow.png',
							activeShadow = 'assets/images/ibtn_shadow.png',

							color = {80, 170, 100, 255},
							activeColor = {100, 230, 120, 255},

							onClick = function(element)
								triggerServerEvent('exchange.inviteResponse', resourceRoot, true)
							end,

						},


						{'button',

							'right', 0,
							167, 46,
							[6] = 'Отмена',

							bg = 'assets/images/ibtn_empty.png',
							activeBg = 'assets/images/ibtn.png',

							shadow = 'assets/images/ibtn_shadow.png',
							activeShadow = 'assets/images/ibtn_empty_shadow.png',

							onClick = function(element)
								triggerServerEvent('exchange.inviteResponse', resourceRoot, false)
								closeWindow()
							end,

						},

					},

				},


			},

		},

	},

	exchange_add_item = {

		{'window',

			'center', 'center',
			569, 418,
			color = {255,255,255,255},

			close = function() currentWindowSection = 'main' end,
			name = 'Предложение обмена',

			bg = 'assets/images/ex_bg.png',
			shadow = 'assets/images/ex_bg_shadow.png',

			variable = 'addItem_tabs',

			onKey = {

				tab = function(element)
					
					for index, tab in pairs(element.tabs) do

						if element.tab == tab.id then
							element.tab = element.tabs[ cycle( index+1, 1, #element.tabs ) ].id
							addItem_list:update(element.tab)
							break
						end

					end

				end,

			},

			tabs = {
				{ name = 'Деньги', id = 'money' },
				{ name = 'Автомобиль', id = 'vehicle' },
				{ name = 'Номер', id = 'number' },
			},

			init = function(element)

				element.tab = element.tabs[1].id

				local padding = 10
				local w,h = 147, 43

				local sCount = #element.tabs/2
				local startX = element[4]/2 - sCount*w - padding*(sCount-0.5)
				local startY = 80

				for _, tab in pairs( element.tabs ) do

					element:addElement(
						{'button',

							startX, startY,
							w,h,
							tab.name,

							define_from = false,

							bg = 'assets/images/ex_tab.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							color = {21,21,33,255},
							activeColor = {21,21,33,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								if element.parent.tab == element.tab.id then
									element.color = {180, 70, 70, element.color[4]}
								else
									element.color = {21, 21, 33, element.color[4]}
								end

								element.activeColor = table.copy(element.color)

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shw,shh = 165, 60
								local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

								local r,g,b = unpack(element.color)

								local anim = (element.parent.tab == element.tab.id) and 1 or element.animData

								dxDrawImage(
									shx,shy,shw,shh, element.shadow or 'assets/images/ex_tab_shadow.png',
									0, 0, 0, tocolor(r,g,b, 255*alpha*anim)
								)

							end,

							tab = tab,

							onClick = function(element)
								element.parent.tab = element.tab.id
								addItem_list:update(element.tab.id)
							end,

						}
					)

					startX = startX + w + padding

				end

				element:addElement(
					{'list',

						'center', 135,
						471, 160,

						scrollBg = scrollTexture,

						scrollColor = {180, 70, 70,255},
						scrollBgColor = {18,18,31,255},

						scrollWidth = 5,
						listOffset = 0,
						listElements = {},

						font = 'default',
						scale = 1,

						listElementHeight = 53,

						color = {255,255,255,255},

						variable = 'addItem_list',

						update = function(element, exchange_type)

							element.listElements = {}

							local ex_items = localPlayer:getData('exchange.items')

							for _, item in pairs( ex_items ) do

								if item.exchange_type == exchange_type then
									table.insert(element.listElements, item)
								end

							end

						end,

						additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

							local alpha = element:alpha()
							local ex,ey,ew,eh = element:abs()

							local w,h = ew, 48
							local x,y = ew/2-w/2, y+element.listElementHeight/2-h/2

							local r,g,b = interpolateBetween( 28,28,41, 180, 70, 70, animData, 'InOutQuad' )
							local tr,tg,tb = interpolateBetween( 255,255,255, 50, 50, 50, animData, 'InOutQuad' )

							dxDrawImage(
								x,y,w,h, 'assets/images/ex_list_item.png',
								0, 0, 0, tocolor(r,g,b, 255*alpha)
							)

							local name = lElement.name
							if lElement.exchange_type ~= 'vehicle' then
								name = string.format('%s %s', convertTypeToString(lElement.exchange_type), lElement.name)
							end

							dxDrawText(name,
								x + 30, y,
								x + 30, y+h,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
								'left', 'center'
							)

						end,

					}
				)


			end,

			elements = {

				{'button',

					'center', function(s,p) return p[5] - s[5] - 60 end,
					[6] = 'Предложить',

					onClick = function(element)

						local x,y,w,h = element:abs()

						if not element.parent.tab then return end
						local type = element.parent.tab

						if type == 'money' then

							local items = localPlayer:getData('exchange.items') or {}
							local sum = tonumber(ex_sumInput[6]) or 0
							if sum <= 0 then return end

							if not canPlayerPutMoney(sum) then
								return exports['hud_notify']:notify('Ошибка', 'Недостаточно денег')
							end

							local added = false
							for _, item in pairs(items) do
								if item.exchange and item.exchange_type == 'money' then
									added = true
									item.cost = item.cost + sum
									item.name = string.format('%s $',
										splitWithPoints(item.cost, '.')
									)
									break
								end
							end

							if not added then
								table.insert(items, {
									cost = sum,
									exchange_type = 'money',
									name = string.format('%s $',
										splitWithPoints(sum, '.')
									),
									hasUpgrades = false,
									exchange = true,
								})
							end

							ex_sumInput[6] = ''

							localPlayer:setData('exchange.items', items)

						else

							if not addItem_list.lastSelectedItem then return end

							local item = addItem_list.lastSelectedItem
							local items = localPlayer:getData('exchange.items') or {}

							local partner = localPlayer:getData('exchange.player')

							for _, _item in pairs(items) do
								if _item.exchange_type == item.exchange_type and _item.id == item.id then
									_item.exchange = true
								end
							end

							localPlayer:setData('exchange.items', items)

						end

						currentWindowSection = 'main'
						

					end,

				},

				{'input',

					'center', 'center',
					265, 50,
					placeholder = 'Введите сумму',
					type = 'number',

					variable = 'ex_sumInput',

					noDraw = function(element)
						return element.parent.tab ~= 'money'
					end,

				},


			},

		},		

	},

}

----------------------------------------------------------------------

	GUIDefine('window', {

		onInit = {

			function(element)

				element:addHandler('onRender', function(element)

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local sw,sh = w+18, h+18

					if element.shadow then
						dxDrawImage(
							x+w/2-sw/2,y+h/2-sh/2+5,
							sw,sh, element.shadow,
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)
					end

					dxDrawImage(
						x,y,w,h, element.bg,
						0, 0, 0, tocolor(25,24,38,255*alpha)
					)

					if element.name then

						dxDrawText(element.name,
							x,y+38,x+w,y+38,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'center'
						)

					end

				end)

				element:addHandler('onRender', function(element)

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local texture = getDrawingTexture(element.bg)

					local gradient = getTextureGradient(texture, {
						color = {
							{ 0, 0, 0, 0 },
							{ 180, 70, 70, 50 },
						},
						alpha = alpha,
						angle = -30,	
					})

					dxDrawImage(
						x,y,w,h, gradient
					)

				end)

				if element.close then

					element:addElement(
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

							onClick = element.close,

						}
					)

				end

				element:init()

			end,

		},

	})

----------------------------------------------------------------------

	GUIDefine('button', {

		[4] = 215, [5] = 46,

		bg = 'assets/images/btn_empty.png',
		activeBg = 'assets/images/btn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 21, 'light'),

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = w*1.083, h*1.391
			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			local r,g,b = unpack(element.color)

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/btn_empty_shadow.png',
				0, 0, 0, tocolor(r,g,b, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/btn_shadow.png',
				0, 0, 0, tocolor(r,g,b, 255*alpha*element.animData)
			)

		end,


	})

	GUIDefine('input', {

		[4] = 241, [5] = 44,
		[6] = '',

		bg = 'assets/images/input.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 23, 'light'),
		alignX = 'center',

		color = {21, 21, 33, 255},
		placeholderColor = {50, 50, 60, 255},


	})

	GUIDefine('ready-state', {

		[4] = 25, [5] = 25,

		bg = roundTexture,
		-- bg = createTextureSource('bordered_rectangle', 'assets/images/round.png', 35, 35, 35),

		getPlayer = function() return localPlayer end,

		onRender = function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			local player = element:getPlayer()
			if not isElement(player) then return end

			local animData = getAnimData(element.r_anim)

			local index = (element.index or 1)
			local dn = 'exchange.ready' .. index

			animate( element.r_anim, player:getData(dn) and 1 or 0 )

			local r,g,b = interpolateBetween( 32,35,66, 80,170,100, animData, 'InOutQuad' )
			local ir,ig,ib = interpolateBetween( 52,55,86, 255,255,255, animData, 'InOutQuad' )

			dxDrawImage(
				x,y,w,h, element.bg,
				0, 0, 0, tocolor(r,g,b, 255*alpha)
			)

			dxDrawImage(
				x,y,w,h, 'assets/images/ready.png',
				0, 0, 0, tocolor(ir,ig,ib, 255*alpha)
			)

			-- dxDrawText(player:getData(dn) and 'Готов к обмену' or 'Не готов к обмену',
			-- 	x - 7, y,
			-- 	x - 7, y+h,
			-- 	tocolor(255,255,255,255*alpha*element.animData),
			-- 	0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
			-- 	'right', 'center'
			-- )

		end,

		onInit = function(element)
			element.r_anim = element.r_anim or {}
			setAnimData(element.r_anim, 0.1)
		end,

		onClick = function(element)

			if isTimer( exchangeButton.timer ) then

				exports.hud_notify:notify('Ошибка', 'Производится обмен')

			else
				
				local player = element:getPlayer()
				if player ~= localPlayer then return end

				local index = (element.index or 1)
				local dn = 'exchange.ready' .. index

				player:setData(dn, not player:getData(dn))

			end


		end,


	})

----------------------------------------------------------------------

	localPlayer:setData('exchange.items', false)
	localPlayer:setData('exchange.inviter', false)
	localPlayer:setData('exchange.invited', false)
	localPlayer:setData('exchange.player', false)

----------------------------------------------------------------------

loadGuiModule()


end)

