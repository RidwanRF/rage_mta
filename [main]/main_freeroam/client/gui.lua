
cancelButtons = {
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f10'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['0'] = true,
}

windowPriority = 'low-15'

openHandler = function()

	localPlayer:setData('hud.hidden', true, false)
	localPlayer:setData('speed.hidden', true, false)
	localPlayer:setData('radar.hidden', true, false)
	localPlayer:setData('drift.hidden', true, false)

	showChat(false)

	triggerServerEvent('business.sendPlayerBusiness', resourceRoot)

end

closeHandler = function()

	localPlayer:setData('hud.hidden', false, false)
	localPlayer:setData('speed.hidden', false, false)
	localPlayer:setData('radar.hidden', false, false)
	localPlayer:setData('drift.hidden', false, false)
	
	showChat(true)
end

disableVerticalAnim = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	__basic = {

		{'image',

			0, 0, sx, ( real_sy ) * sx/real_sx,
			'assets/images/bg.png',
			color = {255,255,255,255},

			onRender = function(element)
				if localPlayer.dimension ~= 0 then return closeWindow() end
			end,

			elements = {

				{'image',
					0, 0, '100%', 124,
					color = {255,255,255,255},
					'assets/images/bg_head.png',

					changeTab = function(element, tab)

						if currentWindowSection == tab then return end

						animate(currentWindowSection .. '-anim', 0, function()
							currentWindowSection = tab
							animate(currentWindowSection .. '-anim', 1)
						end)

					end,

					onKey = {

						tab = function(element)

							for index, tab in pairs(element.tabs) do

								if tab.id == currentWindowSection then
									element:changeTab( element.tabs[ cycle(index+1, 1, #element.tabs) ].id )
									break
								end

							end

						end,

					},

					variable = 'tabsElement',
					highlight = {},

					onInit = function(element)

						element.tabs = {
							{ name = 'Статистика', id = 'stats' },
							{ name = 'Награды', id = 'rewards' },
							{ name = 'Достижения', id = 'achievments' },
							{ name = 'Магазин', id = 'shop' },
							{ name = 'Кейсы', id = 'packs' },
							{ name = 'Реферальная система', id = 'referal' },
							{ name = 'Репорт', id = 'report' },
							{ name = 'Настройки', id = 'options' },
						}

						highlightMainTab = function( tab_id )

							if currentWindowSection ~= tab_id then

								tabsElement.highlight[tab_id] = true
								return true

							end

							return false

						end

						local startX = 275

						element.tabs_data = { x = startX }

						local totalWidth = 0

						local itemH = 55
						local startY = element[5]/2-itemH/2

						local scale, font = 0.5, getFont('montserrat_medium', 26, 'light')

						for _, tab in pairs( element.tabs ) do

							local itemW = dxGetTextWidth( tab.name, scale, font ) + 58

							element:addElement(
								{'element',

									startX, startY,
									itemW, itemH,
									color = {255,255,255,255},

									tab = tab,

									scale = scale,
									font = font,

									onInit = function(element)
										element.w_anim = {}
										setAnimData(element.w_anim, 0.1, 0)
									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local animData = getAnimData(element.w_anim)

										if currentWindowSection ~= element.tab.id and tabsElement.highlight[ element.tab.id ] then
											animData = math.abs( math.sin( getTickCount() * 0.0015 ) )
										end

										local tr,tg,tb = interpolateBetween(200, 200, 200, 255,255,255, animData, 'InOutQuad')

										animate(element.w_anim, element.tab.id == currentWindowSection and 1 or 0)

										local gradient = getTextureGradient(whiteTexture, {
											color = {
												{ 180, 70, 70, 255 },
												{ 112, 60, 77, 255 },
											},
											alpha = alpha*animData,
											angle = -30,	
										})

										dxDrawImage(
											x,y,w,h, gradient
										)

										dxDrawText(element.tab.name,
											x,y,x+w,y+h,
											tocolor(tr,tg,tb,255*alpha),
											element.scale, element.scale, element.font,
											'center', 'center'
										)

									end,

									onClick = function(element)
										element.parent:changeTab(element.tab.id)
										tabsElement.highlight[ element.tab.id ] = nil
									end,

								}
							)

							startX = startX + itemW
							totalWidth = totalWidth + itemW

						end

						element.tabs_data.w = totalWidth
						element.tabs_data.h = itemH
						element.tabs_data.border_w = totalWidth+70

						-- element.border = createTextureSource('bordered_empty_rectangle', 'assets/images/_border.png', 15, 2, element.tabs_data.border_w, itemH)

						element:addHandler('onRender', function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							dxDrawImage(
								x+element.tabs_data.x+element.tabs_data.w/2-element.tabs_data.border_w/2, y+h/2-element.tabs_data.h/2-1,
								element.tabs_data.border_w, element.tabs_data.h+2,
								'assets/images/_border.png', 0, 0, 0,
								-- element.border, 0, 0, 0,
								tocolor(180, 70, 70, 100*alpha)
							)

						end)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local ax,ay,aw,ah = x + 30, y+h/2-104/2, 104, 104

						dxDrawImage(
							ax,ay,aw,ah, 'assets/images/avatar.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('Никнейм',
							ax + aw - 5, ay+17,
							ax + aw - 5, ay+17,
							tocolor(66,66,84,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top'
						)
						dxDrawText(clearColorCodes(localPlayer.name),
							ax + aw - 5, ay+33,
							ax + aw - 5, ay+33,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
							'left', 'top'
						)

						dxDrawText('Логин',
							ax + aw - 5, ay+53,
							ax + aw - 5, ay+53,
							tocolor(66,66,84,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top'
						)
						dxDrawText(localPlayer:getData('unique.login'),
							ax + aw - 5, ay+69,
							ax + aw - 5, ay+69,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
							'left', 'top'
						)

						local stw,sth = 63,63
						local stx, sty = x+w-220,y+h/2-sth/2

						local vip_state = exports.main_vip:isVip(localPlayer)

						local y_add = vip_state and -5 or 0

						dxDrawImage(
							stx,sty,stw,sth, 'assets/images/star.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('VIP-Статус',
							stx + stw, sty+10+y_add,
							stx + stw, sty+10+y_add,
							tocolor(66,66,84,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top'
						)

						dxDrawText( vip_state and 'Активирован' or 'Отсутствует',
							stx + stw, sty+27+y_add,
							stx + stw, sty+27+y_add,
							vip_state and tocolor(255,255,255,255*alpha) or tocolor(150,150,150,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'left', 'top'
						)

						if vip_state then

							local realTime = getRealTime().timestamp
							local finishTime = localPlayer:getData('vip.finishTime')

							local delta = finishTime - realTime

							if delta > 0 then

								local days = math.floor( delta/86400 )
								local hours = math.floor( (delta - days*86400)/3600 )
								local minutes = math.floor( (delta - days*86400 - hours*3600)/60 )

								stats_infoElement.vip_amount = string.format('%sд %sч %sм',
									days, hours, minutes
								)

								dxDrawText(stats_infoElement.vip_amount,
									stx + stw, sty+46+y_add,
									stx + stw, sty+46+y_add,
									tocolor(0xff,0xdc,0x64,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
									'left', 'top', false, false, false, true
								)

							end


						end

						local dw,dh = 70,70
						local dx, dy = x+w-270,y+h/2-dh/2+1

						dxDrawImage(
							dx,dy,dw,dh, 'assets/images/hdonate.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('Донат-счёт',
							dx+5, dy+13,
							dx+5, dy+13,
							tocolor(66,66,84,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'right', 'top'
						)

						local donate = localPlayer:getData('bank.donate') or 0

						dxDrawText(splitWithPoints(donate, '.') .. ' RC',
							dx+5, dy+30,
							dx+5, dy+30,
							(donate > 0) and tocolor(255,255,255,255*alpha) or tocolor(150,150,150,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'right', 'top'
						)

					end,

				},

			},

		},

	},

	stats = {

		{'window-element',

			elements = {

				{'element',

					'center', 'center',
					900, 600,
					color = {255,255,255,255},

					variable = 'stats_infoElement',

					actions = {

						{
							name = 'Умереть',
							action = function(element)

								if localPlayer.dimension ~= 0 then return end

								dialog('Умереть', 'Вы действительно хотите умереть?', function(result)

									if result then

										localPlayer.health = 0
										closeWindow()

									end
									
								end)
							end,
						},
						{
							name = 'Передать деньги',
							action = function(element)

								if localPlayer.dimension ~= 0 then return end

								local playersList = {}

								for _, player in pairs( getElementsByType('player') ) do
									if getDistanceBetween(player, localPlayer) < 30 and player ~= localPlayer then
										table.insert(playersList, { data = player, name = player.name })
									end
								end

								if #playersList <= 0 then
									return exports.hud_notify:notify('Ошибка', 'Поблизости нет игроков')
								end

								dialog_input('Передать деньги', {
									string.format('У вас #cd4949$%s',
										splitWithPoints(localPlayer:getData('money') or 0, '.')
									),	
								}, {
									{ type = 'number', name = 'Введите сумму', },
									{ type = 'select', name = 'Выберите игрока', params = {
										selectElements = playersList,
									} },	
								}, function(data)

									if data and data[1] and data[2] then

										triggerServerEvent('freeroam.sendMoney', resourceRoot, data[2], data[1])

									end

								end)

							end,
						},
						{
							name = 'Подать объявление',
							action = function(element)

								if localPlayer.dimension ~= 0 then return end

								canOpenWindow = false
								setTimer(function()
									exports.main_ads:openWindow('main')

									setTimer(function()
										canOpenWindow = true
									end, 500, 1)

								end, 500, 1)

								closeWindow()

							end,
						},
						{
							name = 'Сменить никнейм',
							action = {

								{
								
									name = 'Ник',

									action = function(element)

										local cost = exports.main_vip:isVip(localPlayer) and (Config.changeNicknameCost/2) or Config.changeNicknameCost

										dialog_input('Смена никнейма', {
											'Заполните данные',	
											string.format('Стоимость операции - #cd4949%s R-Coin',
												cost
											),
										}, {
											{ type = 'text', name = 'Введите новый никнейм', },	
										},function(data)

											if data and data[1] then

												triggerServerEvent('freeroam.changeNickname', resourceRoot, data[1])

											end

										end)

									end,

								},

								{

									name = 'Цвет',

									action = function(element)

										local cost = Config.changeNicknameColorCost

										dialog_input('Смена цвета ника', {
											'Заполните данные',	
											string.format('Стоимость операции - #cd4949%s R-Coin',
												cost
											),
										}, {
											{ type = 'text', name = 'Цветовой код', params = {
												possibleSymbols = '1234567890abcdef#',
												variable = 'colorCodeInput',
												maxSymbols = 7,
											} },	
											{ type = 'text', name = '', params = { noEdit = true, onInit = function(element)

												local colors = {
													'#ffffff', '#dc5a5a',
													'#5a9ddc', '#f0a514',
													'#a3ec3b', '#df55d4',
													'#324fff', '#8416ea',
												}

												local w,h = 25,25
												local padding = 7

												local sCount = #colors/2
												local startX = element[4]/2 - w*sCount - padding*(sCount-0.5)

												for _, color in pairs( colors ) do

													local r,g,b = hexToRGB(color)

													element:addElement(
														{'image',
															startX, 'center',
															w,h,
															color = {r,g,b, 255},
															roundTexture,

															color_code = color,

															onRender = function(element)

																local x,y,w,h = element:abs()
																local alpha = element:alpha()

																if element.color_code == colorCodeInput[6] then

																	dxDrawImage(
																		x,y,w,h, 'assets/images/color_ok.png',
																		0, 0, 0, tocolor(0, 0, 0, 255*alpha)
																	)

																end

															end,

															onClick = function(element)
																colorCodeInput[6] = element.color_code
															end,

														}
													)

													startX = startX + w + padding

												end

											end, } },	
										},function(data)

											if data and data[1] then

												local color = data[1]

												if ( not color:find('#') ) or #color ~= 7 then
													return exports.hud_notify:notify('Ошибка', 'Неверный цветовой код')
												end

												triggerServerEvent('freeroam.changeNicknameColor', resourceRoot, data[1])

											end

										end)

									end,

								},

							},
						},

					},

					onInit = function(element)

						local startY = 0

						for _, action in pairs( element.actions ) do

							if type(action.action) == 'table' then

								local button = element:addElement(
									{'button',

										'right', startY,
										define_from = 'main-button',
										[6] = action.name,
										action = action,

										onInit = function(element)

											element.animationAlpha = {}
											setAnimData( element.animationAlpha, 0.1, 1 )

										end,

										noDraw = function(element)

											animate( element.animationAlpha, isMouseInPosition( element:abs() ) and 0 or 1 )

										end,


									}
								)

								button.buttons = {}

								local startX = element[4] - 133
								for _, c_action in pairs( action.action ) do

									element:addElement(
										{'button',

											startX, startY,
											define_from = 'main-button-sml',
											[6] = c_action.name,

											button = button,

											onInit = function(element)
												element.animationAlpha = {}
												setAnimData( element.animationAlpha, 0.1, 1 )
											end,

											noDraw = function(element)
												animate( element.animationAlpha, isMouseInPosition( element.button:abs() ) and 1 or 0 )
											end,

											onClick = c_action.action,


										}
									)

									startX = startX - 144

								end

							else
								element:addElement(
									{'button',
										'right', startY,
										define_from = 'main-button',
										[6] = action.name,

										onClick = action.action,

									}
								)
							end


							startY = startY + 75

						end

						startY = startY + 80

						element:addElement(
							{'input',

								'right', startY,
								define_from = 'main-input',
								placeholder = 'Введите бонус',

								variable = 'bonusCodeInput',

								onInit = function(element)

									element:addHandler('onRender', function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										dxDrawText('Знаете секретное слово?',
											x, y-10, x+w, y-10,
											tocolor(200,200,200,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
											'center', 'bottom'
										)

									end)

								end,

							}
						)

						startY = startY + 75

						element:addElement(
							{'button',

								'right', startY,
								define_from = 'main-button-e',
								[6] = 'Активировать',

								onInit = function(element)
									element.animationAlpha = {}
									setAnimData(element.animationAlpha, 0.1, 1)
								end,

								onClick = function(element)

									local x,y,w,h = element:abs()

									animate(element.animationAlpha, 0)
									displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1500, function()

										animate(element.animationAlpha, 1)

										if utf8.len(bonusCodeInput[6]) > 0 then
											triggerServerEvent('freeroam.useBonus', resourceRoot, bonusCodeInput[6])
										end


									end )

								end,

								onPreRender = function(element)

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									dxDrawRectangle(
										x - 500, y+h/2, 
										500, 1, tocolor(180, 70, 70, 30*alpha)
									)

									dxDrawRectangle(
										x - 650, y+h, 
										500, 1, tocolor(180, 70, 70, 30*alpha)
									)

								end,


							}
						)
						
					end,

					addEvent('bonus.receiveCurrentTime', true),
					addEventHandler('bonus.receiveCurrentTime', resourceRoot, function(time)
						localPlayer:setData('bonus.current_time', time, false)
					end),

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Информация',
							x,y,x,y,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 45, 'light'),
							'left', 'top'
						)

						local register_timestamp = localPlayer:getData('unique.register_date') or getRealTime().timestamp
						local register_date = getRealTime(register_timestamp)

						local rows = {
							{ name = 'Деньги в банке', value = string.format('$%s', splitWithPoints( localPlayer:getData('bank.rub') or 0, '.' )) },
							{ name = 'Деньги в бизнесах', value = string.format('$%s', splitWithPoints( stats_infoElement.business_balance or 0, '.' )) },
							{ name = 'RCOIN', value = string.format('%s', splitWithPoints( localPlayer:getData('bank.donate') or 0, '.' )) },
							{ name = 'VIP-статус', value = stats_infoElement.vip_amount or 'Отсутствует' },
							{ name = 'Парковочные места', value = string.format('%s/%s',
								localPlayer:getData('parks.loaded') or 0, localPlayer:getData('parks.all') or 0
							) },
							{ name = 'Рекорд дрифта', value = string.format('%s', splitWithPoints( localPlayer:getData('drift.best') or 0, '.' )) },
							{  },
							{ name = 'Игровой стаж', value = string.format('%sч.', exports.main_levels:getPlayerLevel(localPlayer)) },
							{ name = 'Билеты свободы', value = string.format('%sшт.', localPlayer:getData('prison.tickets') or 0) },
							{ name = 'Дата регистрации', value = string.format('%02d.%02d.%s', register_date.monthday, register_date.month+1, register_date.year+1900), },
							{  },
						}

						local bonus = localPlayer:getData('bonus.current')
						if bonus then

							table.insert(rows, { name = 'Вы активировали бонус-код', value = bonus })

							local time = math.max( 0, localPlayer:getData('bonus.current_time') or 0 )

							local hours = math.floor( (time)/3600 )
							local minutes = math.floor( (time - hours*3600)/60 )

							table.insert(rows, { name = 'Чтобы получить, отыграйте', value = string.format('%sч %sм', hours, minutes) })
							

						else
							table.insert(rows, { name = 'Бонус-код не активирован', value = '' })
						end

						local startY = y+80

						for _, row in pairs( rows ) do

							if row.name then
								dxDrawText(string.format('%s  #ffffff%s', row.name, row.value),
									x,startY,
									x,startY,
									tocolor(56,54,75,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
									'left', 'top', false, false, false, true
								)
							end

							startY = startY + 40

						end


					end,

					addEvent('business.receivePlayerBusiness', true),
					addEventHandler('business.receivePlayerBusiness', root, function(business)

						stats_infoElement.business_balance = 0

						for _, row in pairs( business ) do
							stats_infoElement.business_balance = stats_infoElement.business_balance + (row.balance or 0)
						end

					end),

				},

			},

		},

	},

	options = {

		{'window-element',

			elements = {

				{'element',

					'center', 'center',
					1000, 600,
					color = {255,255,255,255},

					tabs = {

						{

							name = 'Общие',
							id = 'common',

							elements = {
								{'slider',
									dn = 'settings.farclip',
									name = 'Дальность прорисовки',
									range = {500, 5000},
									value = 500,
								},
								{'checkbox',
									dn = 'settings.autologin',
									name = 'Автологин',
								},
								{'checkbox',
									dn = 'settings.water_safe',
									name = 'Телепорт из воды | для VIP',
								},
								{'checkbox',
									dn = 'settings.walking_style',
									name = 'Заменить походку',
								},
							},

						},

						{

							name = 'Графика',
							title = 'Если у вас слабый ПК - выключите эти настройки\nдля повышения производительности',
							id = 'graphics',

							elements = {

								{'checkbox',
									dn = 'settings.roads',
									name = 'HD Дороги',
									default = false,
								},
								-- {'checkbox',
								-- 	dn = 'settings.skybox',
								-- 	name = 'HD небо',
								-- 	default = true,
								-- },
								{'checkbox',
									dn = 'settings.detail',
									name = 'HD текстуры',
									default = false,
								},
								{'checkbox',
									dn = 'settings.water',
									name = 'HD вода',
									default = false,
								},
								{'checkbox',
									dn = 'settings.shading',
									name = 'HD тени',
									default = false,
								},
								{'checkbox',
									dn = 'settings.markers',
									name = 'HD Маркеры',
									default = false,
								},
								{'checkbox',
									dn = 'settings.fxaa',
									name = 'FXAA',
									default = false,
								},

				                {'checkbox',
				                	dn = 'settings.snow',
				                	name = 'Зимний мод',
									default = false,
								},
								--[[{'checkbox',
									dn = 'settings.winter',
									name = 'Зимний мод',
									default = false,
								},]]

								{'clickbox',
									dn = 'settings.plates_quality',
									name = 'Качество номеров',
									default = 2,
									values = {
										{ text = 'Низкое', value = 0.5, },
										{ text = 'Стандарт', value = 1, },
										{ text = 'HD', value = 2, },
										{ text = 'Ultra', value = 4, },
									},
								},

								-- {'clickbox',
								-- 	dn = 'settings.vinils_quality',
								-- 	name = 'Качество винилов',
								-- 	default = 2,
								-- 	values = {
								-- 		{ text = 'Низкое', value = 0.5, },
								-- 		{ text = 'Стандарт', value = 1, },
								-- 		{ text = 'HD', value = 2, },
								-- 		{ text = 'Ultra', value = 4, },
								-- 	},
								-- },

								{'checkbox',
									dn = 'settings.dof',
									name = 'Размытие',
									default = false,
								},

								{'slider',
									dn = 'settings.dof_level',
									name = 'Уровень размытия',
									range = {0, 30},
									value = 10,
								},

								{'slider',
									dn = 'settings.dof_saturation',
									name = 'Насыщенность картинки',
									range = {0, 100},
									value = 50,
								},

							},

						},

						{

							name = 'Отображение',
							id = 'view',

							elements = {
								{'checkbox',
									dn = 'settings.reflections',
									name = 'Отражения на авто',
									default = true,
								},
								{'checkbox',
									dn = 'settings.wheels_reflections',
									name = 'Отражения на дисках',
									default = true,
								},
								{'checkbox',
									dn = 'settings.vinils',
									name = 'Отображение винилов',
									default = true,
								},
								{'checkbox',
									dn = 'settings.billboards',
									name = 'Отображение биллбордов',
									default = true,
								},
								{'checkbox',
									dn = 'settings.kill_list',
									name = 'Отображение килл-листа',
									default = true,
								},
							},

						},

						{

							name = 'Звуки',
							id = 'sounds',

							elements = {
								{'checkbox',
									dn = 'settings.sync_radio',
									name = 'Чужая музыка',
									default = true,
								},
								{'checkbox',
									dn = 'settings.siren_sounds',
									name = 'Звуки СГУ',
									default = true,
								},
							},

						},

						{

							name = 'Смена пароля',
							id = 'password',

							onClick = function(element)

								dialog_input('Смена пароля', {
									'Заполните данные',	
								}, {
									{ type = 'text', name = 'Старый пароль', },	
									{ type = 'text', name = 'Новый пароль', },	
									{ type = 'text', name = 'Повторите пароль', },	
								},function(data)

									if data then

										if data[2] ~= data[3] then
											return exports.hud_notify:notify('Ошибка', 'Пароли не совпадают')
										end

										triggerServerEvent('freeroam.changePassword', resourceRoot, encode(data[1]), encode(data[2]))

									end

								end)

							end,

						},

					},

					variable = 'settingsElement',

					onInit = function(element)

						local possibleDataNames = {}

						addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
							if possibleDataNames[dataName] then

								setData(dataName, new)

							end
						end)

						toggleAllSettings = function( block_id, flag )

							for _, section in pairs( settingsElement.tabs ) do

								if section.id == block_id then
									for _, element in pairs( section.elements or {} ) do

										if element[1] == 'checkbox' then
											localPlayer:setData(element.dn, flag, false)
										end

									end
								end

							end

						end

						element.tab = element.tabs[1]

						local startY = 0

						local d_element = element:addElement(
							{'element',

								'right', 65,
								700, '100%',
								color = {255,255,255,255},

								onRender = function(element)

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									dxDrawText(element.parent.tab.name,
										x,y-15,x+w,y-15,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
										'center', 'bottom'
									)

									if element.parent.tab.title then

										dxDrawText(element.parent.tab.title,
											x,y+15,x+w,y+15,
											tocolor(150,150,170,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
											'center', 'top'
										)

									end

								end,

							}
						)

						for _, tab in pairs( element.tabs ) do

							local tab_element = element:addElement(
								{'settings-tab',

									'left', startY,

									tab = tab,

								}
							)

							local t_startY = 50

							local add = 0

							if tab.title then

								local rows = #splitString(tab.title, '\n')
								local fontHeight = dxGetFontHeight( 0.5, getFont('montserrat_medium', 25, 'light') )

								add = rows * fontHeight

							end

							t_startY = t_startY + add

							if tab.elements then

								for _, t_element in pairs( tab.elements ) do

									possibleDataNames[t_element.dn] = true

									if t_element[1] == 'slider' then

										d_element:addElement(

											{'element',
												'center', t_startY,
												506, 45,
												color = {255,255,255,255},

												elements = {

													{'slider',
														'center', 'bottom',
														506,9,

														bg = 'assets/images/settings_slider.png',

														data = t_element,
														tab = tab,

														onSlide = function(element, value)
															localPlayer:setData(element.data.dn, value, element.data.sync or false)
														end,

														range = t_element.range,
														value = getSavedData(t_element.dn) or t_element.value,

														onRender = function(element)

															local alpha = element:alpha()
															local x,y,w,h = element:abs()
															local ex,ey,ew,eh = element.parent:abs()

															dxDrawText(element.data.name,
																ex + 30, ey,
																ex + 30, ey,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
																'left', 'top'
															)

															local min,max = unpack(element.range)
															local progress = ( element.value-min ) / (max-min)

															local slw,slh = 20,20
															local slx,sly = x+w*progress-slw/2, y+h/2-slh/2

															mta_dxDrawImage(
																px(slx)-3,px(sly)-3,px(slw)+6,px(slh)+6, 'assets/images/settings_slider_a.png',
																0, 0, 0, tocolor(0, 0, 0, 255*alpha)
															)

															dxDrawImage(
																slx,sly,slw,slh, 'assets/images/settings_slider_a.png',
																0, 0, 0, tocolor(180, 70, 70, 255*alpha)
															)

														end,

														onInit = function(element)
															localPlayer:setData(element.data.dn, element.value, element.data.sync)
														end,

														padding = 2,
														color = {18,18,28,255},
														activeColor = {72,35,41,255},

														noDraw = function(element)
															return settingsElement.tab ~= element.tab
														end,

													}

												},

											}

										)

										t_startY = t_startY + 65

									elseif t_element[1] == 'checkbox' then

										d_element:addElement(

											{'element',
												'center', t_startY,
												490, 31,
												color = {255,255,255,255},

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													dxDrawText(element.data.name,
														x, y,
														x, y+h,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
														'left', 'center'
													)

												end,

												noDraw = function(element)
													return settingsElement.tab ~= element.tab
												end,

												data = t_element,
												tab = tab,

												elements = {

													{'checkbox',
														'right', 'center',
														76, 31,

														color = {18,18,28,255},
														fgColor = {46,43,64,255},
														activeColor = {180,70,70,255},

														bg = 'assets/images/cd_bg.png',
														fg = 'assets/images/cd_fg.png',
														size = 49,

														checked = getSavedData(t_element.dn) == nil and t_element.default or getSavedData(t_element.dn),

														data = t_element,
														tab = tab,

														onCheck = function(element)
															localPlayer:setData(element.data.dn, element.checked, element.data.sync)
														end,

														onInit = function(element)
															localPlayer:setData(element.data.dn, element.checked, element.data.sync)
														end,

														padding = 3,

													}

												},

											}

										)

										t_startY = t_startY + 45

									elseif t_element[1] == 'clickbox' then

										d_element:addElement(

											{'element',
												'center', t_startY,
												490, 31,
												color = {255,255,255,255},

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													dxDrawText(element.data.name,
														x, y,
														x, y+h,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
														'left', 'center'
													)

												end,

												noDraw = function(element)
													return settingsElement.tab ~= element.tab
												end,

												data = t_element,
												tab = tab,

												elements = {

													{'clickbox',
														'right', 'center',
														76, 31,

														color = {18,18,28,255},

														bg = 'assets/images/cd_bg.png',

														scale = 0.5,
														font = getFont('montserrat_bold', 19, 'light'),


														data = t_element,
														tab = tab,

														selected = getSavedData(t_element.dn) or t_element.default,

														values = t_element.values,

														onChange = function(element, value, index)
															localPlayer:setData(element.data.dn, index, element.data.sync)
														end,

														padding = 3,

													}

												},

											}

										)

										t_startY = t_startY + 45

									end

								end

							elseif tab.onClick then

								tab_element.onClick = tab.onClick

							end

							startY = startY + 92

						end



					end,


				},

			},

		},

	},

	referal = {

		{'window-element',

			variable = 'referalWindow',

			showLayer = function(element, layer)

				for _, c_element in pairs( element.elements or {} ) do

					if c_element[1] == 'layer' then

						if c_element.layer_id == layer then
							c_element:show()
						else
							c_element:hide()
						end

					end

				end

			end,

			elements = {

				{'layer',

					layer_id = 'main',

					elements = {

						{'element',
							'center', 'center',
							650, '95%',
							color = {255,255,255,255},

							onInit = function(element)
								element.s_anim = {}
								setAnimData(element.s_anim, 0.05, 0)
							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								animate(element.s_anim, localPlayer:getData('referal.code') and 1 or 0)
								local anim = getAnimData(element.s_anim)
								local ar,ag,ab = interpolateBetween(40,40,65, 180,70,70, anim, 'InOutQuad')
								local ar2,ag2,ab2 = interpolateBetween(40,40,65, 255,255,255, anim, 'InOutQuad')

								dxDrawText('Награды для приглашенных',
									x,y+40,x+w,y+40,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 35, 'light'),
									'center', 'top'
								)

								local lw,lh = 619, 9
								local lx,ly = x+w/2-lw/2, y + 170

								dxDrawImage(
									lx,ly,lw,lh, 'assets/images/ref/ref_progress.png',
									0, 0, 0, tocolor(18,18,28,255*alpha)
								)

								dxDrawImage(
									lx+lw/2-656/2,ly+lh/2-51/2,656,51, 'assets/images/ref/ref_progress_a.png',
									0, 0, 0, tocolor(ar,ag,ab,255*alpha)
								)

								local count = #Config.referal.invited

								local rw,rh = 23,23

								local padding = (lw - rw*count) / (count+1)
								local sCount = count/2

								local startX = lx + lw/2 - sCount*rw - padding*(sCount-0.5)


								for _, reward in pairs( Config.referal.invited ) do

									local rx = startX
									local ry = ly+lh/2 - rh/2

									dxDrawImage(
										rx,ry,
										rw,rh, 'assets/images/ref/ref_round.png',
										0, 0, 0, tocolor(ar,ag,ab, 255*alpha)
									)

									dxDrawText(string.format('%s#3b374f\n%s', reward.level, getWordCase(
										reward.level, 'Отыгранный\nчас', 'Отыгранных\nчаса', 'Отыгранных\nчасов'
									)),
										rx,ry-15,rx+rw,ry-15,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
										'center', 'bottom', false, false, false, true
									)

									mta_dxDrawRectangle(
										px( rx+rw/2 ), px( ry+rh+10 ),
										1, px(20), tocolor(ar,ag,ab, 255*alpha)
									)

									dxDrawText(reward.reward.name,
										rx, ry+rh+33,
										rx+rw, ry+rh+33,
										tocolor(ar2,ag2,ab2,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'center', 'top'
									)

									startX = startX + rw + padding

								end

								local referReward = Config.referal.inviter[1]
								dxDrawText(string.format('За каждого приглашенного, который отыграл #cd4949%s#ffffff %s - #cd4949%s#ffffff\n и #cd4949%s%%#ffffff от пополнений приглашенного',
									referReward.level, getWordCase(referReward.level, 'час', 'часа', 'часов'),
									referReward.reward.name,
									getLoginReferalPercent( localPlayer:getData('unique.login') )
								),
									lx, ly+lh+100,
									lx+lw, ly+lh+100,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
									'center', 'top', false, false, false, true
								)

								local iw,ih = 616,235
								local ix,iy = lx+lw/2-iw/2, ly+lh+165

								dxDrawImage(
									ix,iy,iw,ih, 'assets/images/ref/ref_info_bg.png',
									0, 0, 0, tocolor(18,18,28,255*alpha)
								)

								dxDrawText('Информация',
									ix+40, iy+20,
									ix+40, iy+20,
									tocolor(50,50,65,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
									'left', 'top'
								)

								dxDrawText('Награды для рефералов',
									ix+40, iy+37,
									ix+40, iy+37,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'top'
								)

								local text = {
									string.format('Приглашай друзей и получай #cd4949%s%%#ffffff от пополнений счета каждого',
										getLoginReferalPercent( localPlayer:getData('unique.login') )
									),
									'приглашенного, все средства конвертируются в #cd4949REFCOIN#ffffff, их вы ',
									'можете перевести в #cd4949RCOIN (донат-валюта) #ffffffили вывести',
									'в реальные деньги на электронный кошелек',
									'',
									string.format('Минимальная сумма вывода - #cd4949%s REFCOIN#ffffff', Config.minReferalTakeSum),
									string.format('1 #cd4949REFCOIN#ffffff = 1 #cd4949реальный рубль#ffffff / #cd4949RCOIN'),
								}

								dxDrawText(table.concat(text, '\n'),
									ix+40, iy+68,
									ix+40, iy+68,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
									'left', 'top', false, false, false, true
								)

								local stw,sth = 520, 88
								local stx,sty = lx+lw/2 - stw/2, iy + ih + 40

								local texture = getDrawingTexture('assets/images/ref/ref_stats_bg.png')
								local gradient = getTextureGradient(texture, {
									color = {
										{ 180,70,70,20 },
										{ 0, 0, 0, 0 },
									},
									alpha = alpha,
									angle = -30-90,
								})

								dxDrawImage(
									stx, sty, stw, sth,
									gradient
								)

								dxDrawImage(
									stx+stw/2-558/2, sty+sth/2-128/2, 558, 128,
									'assets/images/ref/ref_stats_bg_a.png',
									0, 0, 0, tocolor(180,70,70,255*alpha)
								)

								dxDrawText('У вас приглашенных',
									stx + 30, sty + 21,
									stx + 30, sty + 21,
									tocolor(50,50,65,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
									'left', 'top'
								)

								local invited = localPlayer:getData('referal.code.data') or {}

								dxDrawText(invited.uses or 0,
									stx + 30, sty + 45,
									stx + 30, sty + 45,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
									'left', 'top'
								)

								dxDrawText('Ваш баланс',
									stx + stw - 30, sty + 21,
									stx + stw - 30, sty + 21,
									tocolor(50,50,65,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
									'right', 'top'
								)

								dxDrawImage(
									stx + stw - 30 - 25, sty + 45, 25,25,
									'assets/images/ref/ref_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

								dxDrawText(splitWithPoints( localPlayer:getData('referal.balance') or 0, '.' ),
									stx + stw - 30 - 30, sty + 45,
									stx + stw - 30 - 30, sty + 70,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
									'right', 'center'
								)


								dxDrawText(localPlayer:getData('referal.code') and 'Вы уже ввели промокод, теперь вам доступен  #ffffffсобственный' or 'Чтобы получить свой промокод,  #ffffffвведите#464655  код другого игрока',
									stx, sty + sth + 20,
									stx + stw, sty + sth + 20,
									tocolor(70,70,85,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
									'center', 'top', false, false, false, true
								)

							end,

						},

						{'element',
							'center', 780,
							450, 65,
							color = {255,255,255,255},

							elements = {

								{'input',

									'left', 'center',
									215, 46,

									variable = 'refInput',

									active_size = {230,62},
									image = 'rinput',

									define_from = 'ref-input',

									placeholder = 'Введите код',

									possibleSymbols = '1234567890qwertyuiopasdfghjklzxcvbnm_-',

									onRender = function(element)

										local code = localPlayer:getData('referal.code')

										if code then

											element[6] = string.format('%s', code)
											element.noEdit = true
											element[2] = element.parent[4]/2 - element[4]/2

										else
											element[2] = 0
										end

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local t_y = y+h+5*element.animData
										element.y0 = element.y0 or element[3]

										element[3] = element.y0 - 10 * element.animData

										dxDrawText('Ваш реферальный код',
											x, t_y,
											x+w, t_y,
											tocolor(255,255,255,255*alpha*element.animData),
											0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
											'center', 'top'
										)

									end,

								},

								{'button',

									'right', 'center',
									215, 46,
									'Активировать',

									define_from = 'ref-button',

									noDraw = function(element)

										local code = localPlayer:getData('referal.code')
										return code

									end,

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onClick = function(element)

										if localPlayer:getData('referal.code') then return end

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

											animate(element.animationAlpha, 1)
											triggerServerEvent('freeroam.referal.code.enter', resourceRoot, refInput[6])


										end )

									end,

								},

							},

						},

						{'button',

							'center', 860,
							215, 46,
							'Вывести REFCOIN',

							define_from = 'ref-button',

							onClick = function(element)
								referalWindow:showLayer('take')
							end,

						},

					},

				},

				{'layer',

					hidden = true,
					layer_id = 'take',

					elements = {

						{'image',
							'center', 'center',
							625, 628,
							'assets/images/ref/ref_take_bg.png',
							color = {18,18,28,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local texture = getDrawingTexture(element[6])
								local gradient = getTextureGradient(texture, {
									color = {
										{ 180, 70, 70, 20 },
										{ 180, 70, 70, 10 },
									},
									alpha = alpha,
									angle = -30,
								})

								dxDrawImage(
									x,y,w,h, gradient
								)

								local aw,ah = 667,670
								local ax,ay = x+w/2-aw/2, y+h/2-ah/2

								dxDrawImage(
									ax,ay,aw,ah, 'assets/images/ref/ref_take_bg_a.png',
									0, 0, 0, tocolor(180,70,70,255*alpha)
								)

								local tw,th = 56,56
								local tx,ty = x+20,y+20

								dxDrawImage(
									tx,ty,tw,th, 'assets/images/ref/ref_take_title_bg.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha)
								)

								local iw,ih = 25,25

								dxDrawImage(
									tx+tw/2-iw/2, ty+th/2-ih/2,
									iw,ih, 'assets/images/ref/ref_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

								dxDrawText('Вывод REFcoin',
									tx+tw+5, ty,
									tx+tw+5, ty+th,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'center'
								)

							end,

							elements = {

								{'button',

									0, 0, 26, 26,
									bg = 'assets/images/ref/close.png',
									activeBg = 'assets/images/ref/close_active.png',
									define_from = '',

									'',

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onInit = function(element)

										element[2] = element.parent[4] - element[4] - 30
										element[3] = 30

									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										dxDrawImage(
											x,y,w,h, 'assets/images/ref/close_icon.png',
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

									end,

									onClick = function()
										referalWindow:showLayer('main')
									end,

								},

								{'input',

									'center', 100,
									340, 65,

									variable = 'refTakeInputVk',

									active_size = {380,105},
									image = 'ref_take_input',

									define_from = 'ref-input',

									placeholder = 'Ссылка на страницу VK',

								},

								{'element',
									'center', 240,
									150, 65,
									color = {255,255,255,255}, 

									variable = 'refTakePayType',

									tabs = {
										{ id = 'sber' },
										{ id = 'qiwi' },
										{ id = 'rcoin' },
									},

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										dxDrawText('Выберите сервис',
											x,y-20,
											x+w,y-20,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'bottom'
										)

									end,

									onInit = function(element)

										local bw,bh = 65,65
										local padding = 30

										local sCount = #element.tabs/2

										local startX = element[4]/2 - bw*sCount - padding*(sCount-0.5)

										for _, tab in pairs( element.tabs ) do

											element:addElement(
												{'image',

													startX, 0,
													bw,bh,
													color = {18,18,28,255},
													'assets/images/ref/ref_take_type_bg.png',

													tab = tab,

													onClick = function(element)

														element.parent.tab = element.tab

													end,

													onInit = function(element)
														element.h_anim = {}
														setAnimData(element.h_anim, 0.1)
														element.y0 = element[3]
													end,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														element[3] = element.y0 - 5*element.animData

														local iw,ih = 50,50

														dxDrawImage(
															x+w/2-iw/2, y+h/2-ih/2,
															iw,ih, string.format('assets/images/ref/%s.png', element.tab.id),
															0, 0, 0, tocolor(255,255,255,255*alpha)
														)

														local aw,ah = 107,107
														local ax,ay = x+w/2-aw/2, y+h/2-ah/2

														local animData = getAnimData(element.h_anim)
														animate(element.h_anim, element.parent.tab == element.tab and 1 or 0)

														dxDrawImage(
															ax,ay,aw,ah, 'assets/images/ref/ref_take_type_bg_a.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
														)

													end,

												}
											)

											startX = startX + bw + padding

										end

									end,

								},

								{'input',

									'center', 340,
									340, 65,

									variable = 'refTakeInputNumber',

									active_size = {380,105},
									image = 'ref_take_input',

									define_from = 'ref-input',

									placeholder = 'Введите номер кошелька',

									possibleSymbols = '1234567890qwertyuiopasdfghjklzxcvbnm_-',

									onPostRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										if refTakePayType.tab and refTakePayType.tab.id == 'rcoin' then
											element.noEdit = true

											dxDrawImage(
												x,y,w,h, element.bg,
												0, 0, 0, tocolor(18,18,28,255*alpha)
											)

											dxDrawText('Кошелек не требуется',
												x,y,x+w,y+h,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
												'center', 'center'
											)
										else

											element.noEdit = false

										end

									end,

								},

								{'button',

									'center', 430,
									215, 46,
									'Отправить запрос',

									define_from = 'ref-button',

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onClick = function(element)

										local x,y,w,h = element:abs()

										if not refTakePayType.tab then
											return exports.hud_notify:notify('Ошибка', 'Выберите сервис')
										end

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

											animate(element.animationAlpha, 1)

											triggerServerEvent('freeroam.takeReferalCoins', resourceRoot,
												refTakePayType.tab.id, refTakeInputNumber[6], refTakeInputVk[6]
											)


										end )

									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										dxDrawText('#cd4949ВНИМАНИЕ!#ffffff\n Проверьте правильность введенных данных,\n отменить действие будет невозможно!',
											x,y+h+20,x+w,y+h+20,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
											'center', 'top', false, false, false, true
										)

										dxDrawText('Средства начисляются в течение #cd494972#ffffff часов',
											x,y+h+95,x+w,y+h+95,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
											'center', 'top', false, false, false, true
										)

									end,

								},

							},

						},

					},

				},

			},

		},

	},

	report = {

		{'window-element',

			variable = 'reportWindow',

			mode = 'player',

			createGui = function(element)

				if element.gui_created then return end
				element.gui_created = true

				reportWindow.mode = exports.acl:isModerator(localPlayer) and 'moderator' or 'player'

				-- if exports.acl:isModerator(localPlayer) then



				-- else

				openHandlers.report = function()
					triggerServerEvent('freeroam.updateReport', resourceRoot, localPlayer)
				end

				element:addElement(
					{'element',

						'center', 'center',
						1300,800,
						color = {255,255,255,255},

						noDraw = function(element)
							return reportWindow.mode == 'moderator'
						end,

						onInit = function(element)

							for _, c_element in pairs( element.elements or {} ) do

								if c_element.section then

									c_element.noDraw = function(element)
										return element.section ~= reportWindow.tab.id
									end

								end

							end

						end,

						elements = {

							{'image',

								'center', 0,
								606, 143,
								'assets/images/report/menu.png',
								color = {180,70,70,255},

								tabs = {

									{ name = 'Мои заявки', id = 'my' },
									{ name = 'Новая заявка', id = 'new' },

								},

								onInit = function(element)

									local w,h = 218, 49
									local padding = 20

									local sCount = #element.tabs/2

									local startX = element[4]/2 - w*sCount - padding*(sCount-0.5)

									for _, tab in pairs( element.tabs ) do

										element:addElement(
											{'button',

												startX, 'center',
												[6] = '',
												define_from = 'report-button',

												tab = tab,

												activeBg = false,

												onInit = function(element)

													element.h_anim = {}
													setAnimData(element.h_anim, 0.1)

													-- element:addHandler('onPreRender', function(element)

													-- 	local alpha = element:alpha()
													-- 	local x,y,w,h = element:abs()

													-- 	dxDrawImage(
													-- 		x,y,w,h, element.activeBg,
													-- 		0, 0, 0, tocolor(18,18,28,255*alpha)
													-- 	)

													-- end)

												end,

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local shw,shh = unpack( element.shadowSize or {264,95} )

													local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

													local animData = getAnimData(element.h_anim)
													animate(element.h_anim, element.tab == reportWindow.tab and 1 or 0)

													local anim = math.max( element.animData, animData )

													dxDrawImage(
														shx,shy,shw,shh, element.shadow or 'assets/images/report/btn_empty_shadow.png',
														0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-anim))
													)

													dxDrawImage(
														shx,shy,shw,shh, element.activeShadow or 'assets/images/report/btn_shadow.png',
														0, 0, 0, tocolor(180, 70, 70, 255*alpha*(anim))
													)

													-- local texture = getDrawingTexture(element.activeBg)

													-- local gradient = getTextureGradient(texture, {
													-- 	color = {
													-- 		{ 180*anim,70*anim,70*anim, 20 + 20*anim },
													-- 		{ 0, 0, 0, 0 },
													-- 	},
													-- 	alpha = anim,
													-- 	angle = -30,
													-- })

													-- dxDrawImage(
													-- 	x,y,w,h, gradient
													-- )

													local r,g,b = interpolateBetween(100,100,100,255,255,255, anim, 'InOutQuad')

													dxDrawText(element.tab.name,
														x,y,x+w,y+h,
														tocolor(r,g,b,255*alpha),
														element.scale, element.scale, element.font,
														'center', 'center'
													)

												end,

												onClick = function(element)
													reportWindow.tab = element.tab
												end,


											}
										)

										startX = startX + w + padding

									end

									reportWindow.tab = element.tabs[1]

								end,

							},

							{'element',

								'center', 150,
								1132,531,
								color = {255,255,255,255},

								section = 'my',

								elements = {

									{'image',
										'left', 'center',
										556, 531,
										'assets/images/report/pbg.png',
										color = {18,18,28,255},

										elements = {

											{'element',

												0, 50,
												'100%', function(s,p) return p[5] - 170 end,
												color = {255,255,255,255},

												overflow = 'vertical',
												variable = 'reportList',

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													dxDrawText('Тип заявки',
														x + 40, y - 10,
														x + 40, y - 10,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'left', 'bottom'
													)

													dxDrawText('Статус',
														x + w - 40, y - 10,
														x + w - 40, y - 10,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'right', 'bottom'
													)

												end,

												update = function(element, data)

													element.row = nil

													for _, c_element in pairs( element.elements or {} ) do
														c_element:destroy()
													end

													element.elements = {}

													reportMessages:update({})

													local startY = 0
													local w,h = element[4], 50
													local padding = 10

													for _, row in pairs( data ) do

														element:addElement(
															{'rectangle',

																0, startY,
																w,h,
																color = {23,23,33,255},

																row = row,

																onInit = function(element)
																	element.r_anim = {}
																	setAnimData(element.r_anim, 0.2)
																end,

																onDestroy = function(element)
																	removeAnimData(element.r_anim)
																end,

																onRender = function(element)

																	local x,y,w,h = element:abs()
																	local alpha = element:alpha()

																	local animData = getAnimData(element.r_anim)

																	local r,g,b = interpolateBetween( 23,23,33, 30,30,40, animData, 'InOutQuad' )
																	element.color = {r,g,b, element.color[4]}

																	animate(element.r_anim, element.row == element.parent.row and 1 or 0)

																	local sTexts = {
																		unread = { name = 'На рассмотрении', color = {60,60,85} },
																		closed = { name = 'Вам ответил модератор', color = {180,70,70} },
																	}

																	local sData = sTexts[ element.row.state ]
																	if not sData then return end
																	local sr,sg,sb = unpack( sData.color )

																	local tTypes = {
																		complaint = 'Жалоба',
																		question = 'Вопрос',
																		other = 'Прочее',
																	}

																	dxDrawText(tTypes[element.row.type] or element.row.type,
																		x + 40,y,
																		x + 40,y+h,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																		'left', 'center'
																	)

																	dxDrawText(sData.name,
																		x + w - 40,y,
																		x + w - 40,y+h,
																		tocolor(sr,sg,sb,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																		'right', 'center'
																	)

																	mta_dxDrawImage(
																		px(x),px(y),px(w),1, 'assets/images/report/line.png',
																		0, 0, 0, tocolor( 180,70,70,255*alpha*animData )
																	)

																	mta_dxDrawImage(
																		px(x),px(y+h)-1,px(w),1, 'assets/images/report/line.png',
																		0, 0, 0, tocolor( 180,70,70,255*alpha*animData )
																	)

																end,

																onClick = function(element)
																	element.parent.row = element.row
																	reportMessages:update(element.row.messages, element.row)
																end,


															}
														)

														if reportList.select_row == row.id then

															element.row = row
															reportMessages:update(row.messages, row)

														end

														startY = startY + h + padding

													end

													reportList.select_row = nil

												end,

												addEvent('freeroam.receiveReport', true),
												addEventHandler('freeroam.receiveReport', resourceRoot, function( data )
													reportList:update(data)
												end),

											},

											{'button',

												60, function(s,p) return p[5] - s[5] - 40 end,
												[6] = 'Закрыть заявку',
												define_from = 'report-button',

												onInit = function(element)

													element.animationAlpha = {}
													setAnimData(element.animationAlpha, 0.1)

												end,

												noDraw = function(element)
													animate( element.animationAlpha, (reportList.row) and 1 or 0 )
												end,

												onRender = function(element)
													if reportList.row then
														element[6] = reportList.row.state == 'closed' and 'Закрыть заявку' or 'Отменить заявку'
													end
												end,

												onClick = function(element)

													if reportList.row then
														triggerServerEvent('freeroam.closeReport', resourceRoot, reportList.row.id)
													end

												end,


											},

										},

									},

									{'image',
										'right', 'center',
										556, 531,
										'assets/images/report/pbg.png',
										color = {18,18,28,255},

										onRender = function(element)

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local texture = getDrawingTexture(element[6])
											local gradient = getTextureGradient(texture, {
												color = {
													{ 180,70,70, 40 },
													{ 0, 0, 0, 0 },
												},
												alpha = alpha,
												angle = -30,
											})

											local hh = 80

											drawImageSection(
												x,y,w,h, element[6],
												{ x = 1, y = hh/h }, tocolor(25,25,35,255*alpha)
											)

											drawImageSection(
												x,y,w,h, gradient,
												{ x = 1, y = hh/h }, tocolor(255,255,255,255)
											)

											if reportList.row then

												if reportList.row.moderator then

													dxDrawText('Модератор',
														x + 40, y+20,
														x + 40, y+20,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
														'left', 'top'
													)

													dxDrawText(reportList.row.moderator,
														x + 40, y+37,
														x + 40, y+37,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
														'left', 'top'
													)

												else

													dxDrawText('Ожидание ответа',
														x + 30, y,
														x + 30, y+hh,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
														'left', 'center'
													)

												end

												local player = findElementByData('player', 'unique.login', reportList.row.moderator)

												dxDrawText(isElement(player) and 'В сети' or 'Не в сети',
													x + w - 40, y,
													x + w - 40, y+hh,
													tocolor(60,60,85,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
													'right', 'center'
												)

											end


										end,

										elements = {

											{'element',

												'center', 100,
												'100%', 350,
												color = {255,255,255,255},

												variable = 'reportMessages',
												overflow = 'vertical',

												update = function(element, messages, report)

													for _, c_element in pairs( element.elements or {} ) do
														c_element:destroy()
													end

													element.elements = {}

													local startY = 0
													local padding = 20

													for _, message in pairs( messages ) do

														local scale, font = 0.5, getFont('montserrat_semibold', 28, 'light')
														local f_height = dxGetFontHeight(scale, font)


														local text = splitStringWithCount( message.message, 40 )

														local time = getRealTime(message.timestamp)

														table.insert(text, 1, string.format('#3c3c55%02d:%02d (%s)#ffffff',
															time.hour, time.minute, (not message.moderator) and 'Вы' or 'Модератор'))

														local height = #text * f_height + padding

														element:addElement(
															{'element',

																0, startY,
																'100%', height,
																color = {255,255,255,255},

																text = text,

																scale = scale,
																font = font,

																isLocal = not message.moderator,

																onRender = function(element)

																	local x,y,w,h = element:abs()
																	local alpha = element:alpha()

																	if element.isLocal then

																		dxDrawText(table.concat(element.text, '\n'),
																			x + 30, y,
																			x + 30, y+h,
																			tocolor(255,255,255,255*alpha),
																			element.scale, element.scale, element.font,
																			'left', 'center', false, false, false, true
																		)

																	else

																		dxDrawText(table.concat(element.text, '\n'),
																			x + w - 30, y,
																			x + w - 30, y+h,
																			tocolor(255,255,255,255*alpha),
																			element.scale, element.scale, element.font,
																			'right', 'center', false, false, false, true
																		)

																	end

																end,

															}
														)

														startY = startY + height

													end

													if report and report.state == 'closed' then

														-- element:addElement(
														-- 	{'element',

														-- 		'center', startY,
														-- 		'100%', 60,
														-- 		color = {255,255,255,255},

														-- 		onRender = function(element)

														-- 			local alpha = element:alpha()
														-- 			local x,y,w,h = element:abs()

														-- 			dxDrawText('Заявка закрыта',
														-- 				x,y,x+w,y+h,
														-- 				tocolor(60,60,85,255*alpha),
														-- 				0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
														-- 				'center', 'center'
														-- 			)

														-- 		end,

														-- 	}
														-- )

														-- startY = startY + 60

														element:addElement(
															{'element',

																'center', startY+15,
																'100%', 130,
																color = {255,255,255,255},

																marks = {

																	{ icon = 's_good', name = 'Отлично', mark = 1 },
																	{ icon = 's_bad', name = 'Плохо', mark = -1 },

																},

																onInit = function(element)

																	local w,h = 69,69
																	local padding = 15

																	local sCount = #element.marks/2

																	local startX = element[4]/2 - sCount*w - padding*(sCount-0.5)

																	for _, mark in pairs( element.marks ) do
																		element:addElement(
																			{'image',

																				startX, 15,
																				w,h,
																				color = {15,15,25,255},
																				'assets/images/report/mark_bg.png',

																				mark = mark,

																				onRender = function(element)

																					local alpha = element:alpha()
																					local x,y,w,h = element:abs()

																					local anim = reportList.row.mark == element.mark.mark and 1 or 0.5

																					if reportList.row.mark == 0 then
																						anim = math.max( anim, element.animData )
																					end

																					dxDrawImage(
																						x+w/2-60/2, y+h/2-60/2,
																						60, 60,
																						string.format('assets/images/report/%s.png', element.mark.icon),
																						0, 0, 0, tocolor(255,255,255,255*alpha*anim)
																					)

																					local tr,tg,tb = 60,60,85
																					if reportList.row.mark == element.mark.mark then
																						tr,tg,tb = 255,255,255
																					end

																					dxDrawText(element.mark.name,
																						x, y+h+10,
																						x+w, y+h+10,
																						tocolor(tr,tg,tb,255*alpha),
																						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																						'center', 'top'
																					)

																				end,

																				onClick = function(element)
																					if reportList.row and reportList.row.mark == 0 then

																						triggerServerEvent('freeroam.markReport', resourceRoot, reportList.row.id, element.mark.mark)

																						reportList.select_row = reportList.row.id

																					end
																				end,

																			}
																		)

																		startX = startX + w + padding

																	end

																end,

																onRender = function(element)

																	local alpha = element:alpha()
																	local x,y,w,h = element:abs()

																	dxDrawText('Оцените работу модератора',
																		x,y,x+w,y,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																		'center', 'bottom'
																	)

																end,

															}
														)

													end


												end,

											},

										},

									},

								},

							},

							{'image',

								'center', 155,
								679, 560,
								'assets/images/report/add.png',
								color = {18,18,28,255},

								section = 'new',

								variable = 'reportCreateType',

								tabs = {
									{ name = 'Жалоба', type = 'complaint' },
									{ name = 'Вопрос', type = 'question' },
									{ name = 'Прочее', type = 'other' },
								},

								onInit = function(element)


									local w,h = 167, 46
									local padding = 10

									local sCount = #element.tabs/2

									local startX = element[4]/2 - sCount*w - padding*(sCount-0.5)

									for _, tab in pairs( element.tabs ) do

										element:addElement(
											{'button',

												startX, 120,
												w,h,
												define_from = 'report-nbutton',
												[6] = tab.name,

												tab = tab,

												onInit = function(element)
													element._bg = element.bg
												end,

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													element.bg = element.parent.tab == element.tab and element.activeBg or element._bg

												end,

												onClick = function(element)

													element.parent.tab = element.tab

												end,


											}
										)

										startX = startX + w + padding

									end

									element.tab = element.tabs[1]

								end,

								onRender = function(element)

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									dxDrawText('Создание заявки',
										x,y+45,x+w,y+45,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
										'center', 'top'
									)

									dxDrawText('Выберите тип заявки',
										x,y+75,x+w,y+75,
										tocolor(60,60,85,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'center', 'top'
									)

								end,

								elements = {

									{'button',

										'center', function(s,p) return p[5] - s[5] - 60 end,
										167, 46,
										define_from = 'report-nbutton',
										[6] = 'Отправить',

										onInit = function(element)
											element.animationAlpha = {}
											setAnimData(element.animationAlpha, 0.1, 1)
										end,

										onClick = function(element)

											local x,y,w,h = element:abs()

											local text = reportTextInput[6]

											if utf8.len(text) < 5 then
												return exports.hud_notify:notify('Ошибка', 'Введите 5 или более символов')
											end

											animate(element.animationAlpha, 0)
											displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

												animate(element.animationAlpha, 1)
												triggerServerEvent('freeroam.createReport', resourceRoot, reportCreateType.tab.type, text)
												reportTextInput[6] = ''

											end )

										end,


									},

									{'textarea',

										'center', 200,
										527, 220,
										bg = 'assets/images/report/text.png',
										variable = 'reportTextInput',

										padding = 25,

										color = {25,25,35,255},
										placeholderColor = {75,78,101,255},

										placeholder = 'Введите текст',
										'',

										possibleSymbols = '1234567890-qwertyuiopasdfghjklzxcvbnm,.;:йцукенгшщзхъфывапролджэячсмитьбю ?',

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											dxDrawText(string.format('%s #464c73/ 300',
												utf8.len(element[6])
											),
												x+w-20, y+h-20,
												x+w-20, y+h-20,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 25, 'bold'),
												'right', 'bottom', false, false, false, true

											)

										end,

										maxSymbols = 300,

										font = getFont('montserrat_semibold', 24, 'light'),
										scale = 0.5,


									},



								},

							},

						},

					}
				)

				element:addElement(
					{'element',

						'center', 'center',
						1429,531,
						color = {255,255,255,255},

						noDraw = function(element)
							return reportWindow.mode == 'player'
						end,

						onInit = function(element)

							for _, c_element in pairs( element.elements or {} ) do

								if c_element.section then

									c_element.noDraw = function(element)
										return element.section ~= reportWindow.tab.id
									end

								end

							end


						end,

						elements = {

							{'element',

								'right', 'center',
								1132,531,
								color = {255,255,255,255},

								elements = {

									{'image',
										'left', 'center',
										556, 531,
										'assets/images/report/pbg.png',
										color = {18,18,28,255},

										elements = {

											{'element',

												0, 50,
												'100%', function(s,p) return p[5] - 170 end,
												color = {255,255,255,255},

												overflow = 'vertical',
												variable = 'm_reportList',

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													dxDrawText('Тип заявки',
														x + 40, y - 10,
														x + 40, y - 10,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'left', 'bottom'
													)

													dxDrawText('Статус',
														x + w - 40, y - 10,
														x + w - 40, y - 10,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'right', 'bottom'
													)

												end,

												update = function(element, data)

													if data then
														element.data = data
													else
														data = element.data
													end

													local rc_id

													if element.row then
														rc_id = element.row.id
													else
														m_reportMessages:update({})
													end


													element.row = nil

													for _, c_element in pairs( element.elements or {} ) do
														c_element:destroy()
													end

													element.elements = {}

													local startY = 0
													local w,h = element[4], 50
													local padding = 10

													for _, row in pairs( data ) do

														if ((m_reportTabs.tab.id == 'delayed' and row.delayed == 1) or
															(m_reportTabs.tab.id == 'new' and row.delayed ~= 1)) and row.state ~= 'closed' then

															element:addElement(
																{'rectangle',

																	0, startY,
																	w,h,
																	color = {23,23,33,255},

																	row = row,

																	onInit = function(element)
																		element.r_anim = {}
																		setAnimData(element.r_anim, 0.2)
																	end,

																	onDestroy = function(element)
																		removeAnimData(element.r_anim)
																	end,

																	onRender = function(element)

																		local x,y,w,h = element:abs()
																		local alpha = element:alpha()

																		local animData = getAnimData(element.r_anim)

																		local r,g,b = interpolateBetween( 23,23,33, 30,30,40, animData, 'InOutQuad' )
																		element.color = {r,g,b, element.color[4]}

																		animate(element.r_anim, element.row == element.parent.row and 1 or 0)

																		local sTexts = {
																			unread = { name = 'На рассмотрении', color = {60,60,85} },
																			closed = { name = 'Заявка закрыта модератором', color = {180,70,70} },
																		}

																		local sData = sTexts[ element.row.state ]
																		if not sData then return end
																		local sr,sg,sb = unpack( sData.color )

																		local tTypes = {
																			complaint = 'Жалоба',
																			question = 'Вопрос',
																			other = 'Прочее',
																		}

																		dxDrawText(tTypes[element.row.type] or element.row.type,
																			x + 40,y,
																			x + 40,y+h,
																			tocolor(255,255,255,255*alpha),
																			0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																			'left', 'center'
																		)

																		dxDrawText(sData.name,
																			x + w - 40,y,
																			x + w - 40,y+h,
																			tocolor(sr,sg,sb,255*alpha),
																			0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																			'right', 'center'
																		)

																		mta_dxDrawImage(
																			px(x),px(y),px(w),1, 'assets/images/report/line.png',
																			0, 0, 0, tocolor( 180,70,70,255*alpha*animData )
																		)

																		mta_dxDrawImage(
																			px(x),px(y+h)-1,px(w),1, 'assets/images/report/line.png',
																			0, 0, 0, tocolor( 180,70,70,255*alpha*animData )
																		)

																	end,

																	onClick = function(element)
																		element.parent.row = element.row
																		m_reportMessages:update(element.row.messages)
																	end,


																}
															)

															if row.id == rc_id then
																element.row = row
															end

															startY = startY + h + padding

														end

													end

													if not element.row and rc_id then
														m_reportMessages:update({})
													end

												end,

												addEvent('freeroam.receiveReport', true),
												addEventHandler('freeroam.receiveReport', resourceRoot, function( data )
													m_reportList:update(data)
												end),

											},

											{'button',

												50,
												function(s,p) return p[5] - s[5] - 40 end,
												[6] = 'Отложить',
												define_from = 'report-button',

												onInit = function(element)

													element.animationAlpha = {}
													setAnimData(element.animationAlpha, 0.1)

												end,

												noDraw = function(element)
													animate( element.animationAlpha, (m_reportList.row and m_reportList.row.state ~= 'closed' and m_reportTabs.tab.id == 'new') and 1 or 0 )
												end,

												onClick = function(element)

													if m_reportList.row and m_reportList.row.state ~= 'closed' then
														triggerServerEvent('freeroam.delayReport', resourceRoot, m_reportList.row.id)
													end

												end,


											},

										},

									},

									{'image',
										'right', 'center',
										556, 531,
										'assets/images/report/pbg.png',
										color = {18,18,28,255},

										onRender = function(element)

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local texture = getDrawingTexture(element[6])
											local gradient = getTextureGradient(texture, {
												color = {
													{ 180,70,70, 40 },
													{ 0, 0, 0, 0 },
												},
												alpha = alpha,
												angle = -30,
											})

											local hh = 80

											drawImageSection(
												x,y,w,h, element[6],
												{ x = 1, y = hh/h }, tocolor(25,25,35,255*alpha)
											)

											drawImageSection(
												x,y,w,h, gradient,
												{ x = 1, y = hh/h }, tocolor(255,255,255,255)
											)

											if m_reportList.row and m_reportList.row.player then

												dxDrawText('Игрок',
													x + 40, y+20,
													x + 40, y+20,
													tocolor(60,60,85,255*alpha),
													0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
													'left', 'top'
												)

												dxDrawText(m_reportList.row.player,
													x + 40, y+37,
													x + 40, y+37,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
													'left', 'top'
												)

												local player = findElementByData('player', 'unique.login', m_reportList.row.player)

												dxDrawText(isElement(player) and 'В сети' or 'Не в сети',
													x + w - 40, y,
													x + w - 40, y+hh,
													tocolor(60,60,85,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
													'right', 'center'
												)

											end



										end,

										elements = {

											{'element',

												'center', 100,
												'100%', 280,
												color = {255,255,255,255},

												variable = 'm_reportMessages',
												overflow = 'vertical',

												update = function(element, messages)

													for _, c_element in pairs( element.elements or {} ) do
														c_element:destroy()
													end

													element.elements = {}

													local startY = 0
													local padding = 20

													for _, message in pairs( messages ) do

														local scale, font = 0.5, getFont('montserrat_semibold', 28, 'light')
														local f_height = dxGetFontHeight(scale, font)

														local text = splitStringWithCount( message.message, 40 )

														local time = getRealTime(message.timestamp)

														table.insert(text, 1, string.format('#3c3c55%02d:%02d (%s)#ffffff',
															time.hour, time.minute, message.moderator and 'Вы' or 'Игрок'))

														local height = #text * f_height + padding

														element:addElement(
															{'element',

																0, startY,
																'100%', height,
																color = {255,255,255,255},

																text = text,

																scale = scale,
																font = font,

																isLocal = message.moderator,

																onRender = function(element)

																	local x,y,w,h = element:abs()
																	local alpha = element:alpha()

																	if element.isLocal then

																		dxDrawText(table.concat(element.text, '\n'),
																			x + 30, y,
																			x + 30, y+h,
																			tocolor(255,255,255,255*alpha),
																			element.scale, element.scale, element.font,
																			'left', 'center', false, false, false, true
																		)

																	else

																		dxDrawText(table.concat(element.text, '\n'),
																			x + w - 30, y,
																			x + w - 30, y+h,
																			tocolor(255,255,255,255*alpha),
																			element.scale, element.scale, element.font,
																			'right', 'center', false, false, false, true
																		)

																	end

																end,

															}
														)

														startY = startY + height

													end


												end,

											},

											{'input',

												'center', function(s,p) return p[5] - s[5] - 30 end,
												485,51,

												color = {23,23,33,255},
												bg='assets/images/report/input.png',
												'',

												placeholderColor = {100,100,100,255},
												placeholder = 'Введите сообщение',

												variable = 'reportResponseInput',

												possibleSymbols = '1234567890-qwertyuiopasdfghjklzxcvbnm,.;:йцукенгшщзхъфывапролджэячсмитьбю ?',

												textPadding = 15,
												maxSymbols = 1000,

												scale = 0.5, 
												font = getFont('montserrat_medium', 22, 'light'),

												alignX = 'left',

												elements = {

													{'button',

														function(s,p) return p[4] - s[4] - 10 end, 'center',
														40, 40,
														'',
														bg = 'assets/images/report/round.png',

														define_from = false,

														color = {180,70,70,255},

														gOnPreRender = function(element)

															local x,y,w,h = element:abs()

															if isMouseInPosition(x,y,w,h) and handleClick then
																element:_onClick()
																handleClick = false
															end

														end,

														onRender = function(element)

															local x,y,w,h = element:abs()
															local alpha = element:alpha()

															dxDrawImage(
																x-10,y-10,w+20,h+20, 'assets/images/report/arrow.png',
																0, 0, 0, tocolor(255,255,255,255*alpha)
															)

														end,

														onInit = function(element)
															element.animationAlpha = {}
															setAnimData(element.animationAlpha, 0.1, 1)
														end,

														addEventHandler('onClientKey', root, function(button, state)

															if button:find('enter') and windowOpened and currentWindowSection == 'report' and state then
																reportSendMessage:_onClick()
															end

														end),

														variable = 'reportSendMessage',

														_onClick = function(element)

															if utf8.len(reportResponseInput[6]) < 5 then
																return exports.hud_notify:notify('Ошибка', 'Слишком короткий ответ')
															end

															if not m_reportList.row then
																return exports.hud_notify:notify('Ошибка', 'Выберите заявку')
															end

															local x,y,w,h = element:abs()

															animate(element.animationAlpha, 0)
															displayLoading( {x+w/2-30/2, y+h/2-30/2, 30, 30}, {180,70,70,255}, 500, function()

																animate(element.animationAlpha, 1)

																triggerServerEvent('freeroam.sendReportMessage', resourceRoot,
																	m_reportList.row.id,
																	reportResponseInput[6]
																)

																reportResponseInput[6] = ''

																setTimer(function()
																	reportResponseInput:blur()
																end, 100, 1)

															end )


														end,

													},

												},

											},

										},

									},

								},

							},

							{'element',

								'left', 'center',
								277, '100%',
								color = {255,255,255,255},

								variable = 'm_reportTabs',

								tabs = {
									{ name = 'Новые заявки', id = 'new' },
									{ name = 'Незакрытые заявки', id = 'delayed' },
								},

								onInit = function(element)

									local w,h = 277,63
									local padding = 10

									local startY = 0

									for _, tab in pairs( element.tabs ) do

										element:addElement(
											{'button',
												0, startY,
												w,h,

												define_from = 'report-button',
												[6] = tab.name,

												bg = 'assets/images/report/tbtn.png',

												shadow = false,
												activeShadow = 'assets/images/report/tbtn_shadow.png',
												activeBg = false,

												tab = tab,

												color = {15,15,25,255},
												activeColor = {25,25,35,255},

												shadowSize = {319,105},

												onInit = function(element)
													element.r_anim = {}
													setAnimData(element.r_anim, 0.1)
												end,

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													animate(element.r_anim, element.tab == element.parent.tab and 1 or 0)
													local anim = math.max( getAnimData(element.r_anim), element.animData )

													if anim > 0.01 then

														local texture = getDrawingTexture(element.bg)
														local gradient = getTextureGradient(texture, {
															color = {
																{ 180, 70, 70, 50 },
																{ 0, 0, 0, 0 },
															},
															alpha = alpha*anim,
															angle = -30,
														})

														dxDrawImage(
															x,y,w,h, gradient
														)

													end

												end,

												onClick = function(element)

													element.parent.tab = element.tab

													setAnimData(m_reportList.ov_animId, 0.1, 0)

													m_reportList:update()

												end,

											}
										)

										startY = startY + h + padding

									end

									element.tab = element.tabs[1]

									element:addElement(
										{'image',
											0, startY+10,
											277,174,
											'assets/images/report/stats.png',
											color = {18,18,28,255},

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawText('Статистика',
													x+30,y+35,
													x+30,y+35,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
													'left', 'top'
												)

												dxDrawText(string.format('Обработано заявок  #ffffff%s#3c3c55\nПоложительные отзывы  #ffffff%s#3c3c55\nОтрицательные отзывы  #ffffff%s#3c3c55',
													localPlayer:getData('report.stats.reports_completed') or 0,
													localPlayer:getData('report.stats.reports_good') or 0,
													localPlayer:getData('report.stats.reports_bad') or 0
												),
													x+30,y+70,
													x+30,y+70,
													tocolor(60,60,85,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
													'left', 'top', false, false, false, true
												)

											end,

										}
									)

								end,


							},

						},

					}
				)

				-- end

			end,

			_=addCommandHandler('fr_report_change', function()

				if exports.acl:isAdmin(localPlayer) then
					reportWindow.mode = reportWindow.mode == 'moderator' and 'player' or 'moderator'
				end

			end),

			_=addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

				if dn == 'unique.login' and new then
					reportWindow:createGui()
				end

			end),

			init = function(element)

				local login = localPlayer:getData('unique.login')

				if login then
					element:createGui()
				end

			end,

		},

	},

	rewards = {

		{'window-element',

			elements = {

				{'element',

					'center', 'center',
					1300, 700,
					color = {255,255,255,255},

					tabs = {
						{ name = 'Ежедневные бонусы', id = 'bonuses' },
						{ name = 'Ежедневные задания', id = 'quests' },
						{ name = 'Бонусы за игру', id = 'game_bonuses' },
					},

					variable = 'rewardsElement',

					onInit = function(element)

						element.tab = element.tabs[1]

						local startY = 0

						for _, tab in pairs( element.tabs ) do

							local tab_element = element:addElement(
								{'settings-tab',

									'left', startY,

									tab = tab,

								}
							)

							startY = startY + 92

						end

						openHandlers.rewards_reset = function()

							rewardsElement.tab = rewardsElement.tabs[1]

						end

					end,

					elements = {

						{'section',

							section = 'bonuses',

							onInit = function(element)

								local index = 1

								for _, x_align in pairs({'left', 'right'}) do

									local startY = 0
									local w,h = 469, 126

									for i = 1,5 do

										element:addElement(
											{'image',

												x_align, startY,
												w,h,
												color = {20, 20, 30, 255},
												'assets/images/bonus_bg.png',

												day = index,

												addEvent('dailyBonus.receiveCurrentTime', true),
												addEventHandler('dailyBonus.receiveCurrentTime', resourceRoot, function(time)
													localPlayer:setData('bonus.receive_time', time, false)
												end),

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local bonus_day = localPlayer:getData('bonus.day') or 1

													local config = Config.dailyBonuses[element.day]

													if config then

														local startX = x + 165 + 180/2 - #(config.rewards)*90/2

														for _, reward in pairs( config.rewards ) do

															local size = 50

															dxDrawImage(
																startX - size/2, y+h/2-size/2-10,
																size, size, reward.image,
																0, 0, 0, tocolor(255,255,255,255*alpha)
															)

															dxDrawText(reward.name,
																startX, y+h/2+size/2-5,
																startX, y+h/2+size/2-5,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
																'center', 'top'
															)

															startX = startX + 90

														end

													end

													if bonus_day == element.day then

														local aw,ah = 487,144
														local ax,ay = x+w/2-aw/2, y+h/2-ah/2

														dxDrawImage(
															ax,ay,aw,ah, 'assets/images/bonus_bg_a.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha)
														)

														local receive_time = localPlayer:getData('bonus.receive_time') or 0

														if receive_time > 0 then

															receive_time = math.floor(receive_time/1000)

															local m = math.floor( receive_time/60 )
															local s = receive_time - m*60

															dxDrawText('Отыграйте',
																x+w-100, y + 40,
																x+w-100, y + 40,
																tocolor(47,46,65, 255*alpha),
																0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
																'center', 'top'
															)

															dxDrawText(string.format('%02dм %02dс', m,s),
																x+w-100, y + 60,
																x+w-100, y + 60,
																tocolor(255,255,255, 255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
																'center', 'top'
															)

														end



													end

													dxDrawText('День  #ffffff' .. element.day,
														x + 25, y + 15,
														x + 25, y + 15,
														tocolor(47,46,65,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
														'left', 'top', false, false, false, true
													)

													-- dxDrawImage(
													-- 	x + 30, y+h/2-70/2+5,
													-- 	70, 70, 'assets/images/bonus_icon.png',
													-- 	0, 0, 0, bonus_day == element.day
													-- 	and tocolor(255,255,255,255*alpha) or tocolor(255,255,255,150*alpha)
													-- )


												end,

												onPostRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local bonus_day = localPlayer:getData('bonus.day') or 1

													if bonus_day ~= element.day then

														dxDrawImage(
															x,y,w,h, element[6],
															0, 0, 0, tocolor(20, 20, 30, 230*alpha)
														)

														if element.day < bonus_day then

															dxDrawText('Бонус получен',
																x,y,x+w,y+h,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																'center', 'center'
															)

														else

															local bw,bh = 120, 38
															local bx,by = x+w-bw-30, y+h/2-bh/2

															dxDrawImage(
																bx,by,bw,bh, 'assets/images/bonus_btn.png',
																0, 0, 0, tocolor(180, 70, 70, 255*alpha)
															)

															dxDrawText('День #ffffff' .. element.day,
																bx,by,bx+bw,by+bh,
																tocolor(50,50,70,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																'center', 'center', false, false, false, true
															)

														end

													end

												end,

												elements = {

													{'button',

														function(s,p) return p[4] - s[4] - 30 end, 'center',
														120, 38,

														'Забрать',

														bg = 'assets/images/bonus_btn.png',

														color = {120,180,100,255},
														activeColor = {120,220,100,255},

														scale = 0.5, 
														font = getFont('montserrat_semibold', 23, 'light'),

														onPreRender = function(element)


															local alpha = element:alpha()
															local x,y,w,h = element:abs()

															local shx,shy,shw,shh = x + w/2 - 163/2, y + h/2 - 82/2, 163, 82

															dxDrawImage(
																shx,shy,shw,shh, 'assets/images/bonus_btn_shadow.png',
																0, 0, 0, tocolor(120,180,100, 255*alpha*element.animData)
															)

															element[6] = localPlayer:getData('bonus.state') == 'received' and 'Получено' or 'Забрать'

														end,

														noDraw = function(element)

															local bonus_day = localPlayer:getData('bonus.day') or 1
															local receive_time = localPlayer:getData('bonus.receive_time') or 0

															return (element.parent.day ~= bonus_day) or receive_time > 0

														end,

														onInit = function(element)
															element.animationAlpha = {}
															setAnimData(element.animationAlpha, 0.1, 1)
														end,

														onClick = function(element)

															if localPlayer:getData('bonus.state') == 'received' then return end

															local x,y,w,h = element:abs()

															animate(element.animationAlpha, 0)
															displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {120,180,100,255}, 1000, function()

																animate(element.animationAlpha, 1)
																triggerServerEvent('freeroam.takeDailyBonus', resourceRoot)


															end )

														end,

													},

												},

											}
										)

										startY = startY + h + 15
										index = index + 1

									end

								end

							end,

						},

						{'section',

							section = 'quests',

							_=addEvent('freeroam.receiveClientQuests', true),
							_=addEventHandler('freeroam.receiveClientQuests', resourceRoot, function(quests)
								localPlayer:setData('quests', quests, false)
							end),

							onInit = function(element)

								element.p_anim = {}
								setAnimData(element.p_anim, 0.05)

								setTimer(function()

									setAnimData(element.p_anim, 0.05)
									animate(element.p_anim, 1)

								end, 2500, 0)

								local x,y,w,h = element:abs()

								local qw,qh = 297, 297
								local padding = 20

								local sCount_x, sCount_y = 1.5, 1

								local _startX = 0
								local startX = _startX

								local startY = 0

								local index = 1

								for i_1 = 1,2 do

									startX = _startX

									for i_2 = 1,3 do

										element:addElement(
											{'image',

												startX, startY,
												qw,qh,

												color = {20,20,30,255},

												'assets/images/quest_bg.png',

												slot = index,

												onInit = function(element)
													element.y0 = element[3]
												end,

												onRender = function(element)

													element[3] = element.y0 - 10*element.animData

													local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')

													element.color = {r,g,b, element.color[4]}

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local quests = localPlayer:getData('quests') or {}
													local quest_data = quests[element.slot]

													if not quest_data then return end


													if quest_data.renew_timestamp then

														local aw,ah = 315, 315
														local ax,ay = x+w/2-aw/2, y+h/2-ah/2

														dxDrawImage(
															ax,ay,aw,ah, 'assets/images/quest_bg_a.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha)
														)

														local scale, font = 0.5, getFont('montserrat_medium', 23, 'light')

														local text = 'Новое задание через:'

														local textWidth = dxGetTextWidth(text, scale, font)
														local imgSize, imgPadding = 20, 6

														local startX = x+w/2-(textWidth+imgSize+imgPadding)/2

														dxDrawImage(
															startX, y+110-imgSize/2,
															imgSize, imgSize,
															'assets/images/quest_timer.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha)
														)

														dxDrawText(text,
															startX + imgSize + imgPadding, y+110,
															startX + imgSize + imgPadding, y+110,
															tocolor(65,62,80,255*alpha),
															scale, scale, font,
															'left', 'center'
														)

														local timestamp = getServerTimestamp()

														local delta = quest_data.renew_timestamp - timestamp.timestamp

														if delta > 0 then

															local th = math.floor( delta/3600 )
															local tm = math.floor( (delta - th*3600)/60 )
															local ts = math.floor( delta - th*3600 - tm*60 )

															dxDrawText(string.format('%02d:%02d:%02d', th,tm,ts),
																x, y + 125,
																x+w, y + 125,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
																'center', 'top'
															)

														end

													else

														local quest_config = Config.dailyQuests[ quest_data.questId ]

														dxDrawText(quest_config.name,
															x,y+25,x+w,y+25,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
															'center', 'top'
														)

														local points = math.floor(
															(quest_config.progressPoints - quest_data.progressPoints)
														)
														local progress = math.clamp(points / quest_config.progressPoints, 0, 1)

														dxDrawRectangle(
															x,y+100,w,7,
															tocolor(17,16,27,255*alpha)
														)

														dxDrawRectangle(
															x,y+100,w*progress,7,
															tocolor(180,70,70,255*alpha)
														)

														local animData = getAnimData(element.parent.p_anim)

														dxDrawRectangle(
															x,y+100,w*progress*animData,7,
															tocolor(255,120,120,255*alpha*(1-animData))
														)

														dxDrawText(string.format('%s #312e44/ %s', points, quest_config.progressPoints),
															x+w-15, y+100 - 5, x+w-15, y+100-5,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
															'right', 'bottom', false, false, false, true

														)

														local rw,rh = w, 100
														local rx,ry = x, y+130

														dxDrawRectangle(
															rx,ry,rw,rh, tocolor(17,16,27,255*alpha)
														)

														dxDrawText('Награда',
															rx + 20, ry + 15,
															rx + 20, ry + 15,
															tocolor(45,42,60,255*alpha),
															0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
															'left', 'top'
														)

														local startX = rx + 20
														local startY = ry + 60

														local rImgSize = 30
														local rImgPadding = 10
														local rPadding = 20

														local scale, font = 0.5, getFont('montserrat_medium', 28, 'light')

														for _, reward in pairs( quest_config.reward.items ) do

															local textWidth = dxGetTextWidth(reward.text, scale, font)

															dxDrawImage(
																startX, startY - rImgSize/2,
																rImgSize, rImgSize,
																reward.icon,
																0, 0, 0, tocolor(255,255,255,255*alpha)
															)

															dxDrawText(reward.text,
																startX + rImgSize + rImgPadding, startY,
																startX + rImgSize + rImgPadding, startY,
																tocolor(255,255,255,255*alpha),
																scale, scale, font,
																'left', 'center'
															)

															startX = startX + rImgPadding + rImgSize + textWidth + rPadding

														end


														local timestamp = getServerTimestamp()

														local delta = quest_data.finish_at - timestamp.timestamp

														if delta > 0 then

															local th = math.floor( delta/3600 )
															local tm = math.floor( (delta - th*3600)/60 )
															local ts = math.floor( delta - th*3600 - tm*60 )

															dxDrawText('Закончится через',
																x+30, y+h-60,
																x+30, y+h-60,
																tocolor(65,62,80,255*alpha),
																0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
																'left', 'top'
															)
															dxDrawText(string.format('%02d:%02d:%02d', th,tm,ts),
																x+30, y+h-40,
																x+30, y+h-40,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
																'left', 'top'
															)

														end

													end




												end,



											}
										)

										startX = startX + qw + padding
										index = index + 1

									end

									startY = startY + qh + padding

								end


							end,

						},

						{'section',

							section = 'game_bonuses',

							onPostInit = function(element)

								element[3] = element[3] - 50

								element.s_anim = {}

								setAnimData( element.s_anim, 0.05, 0 )

								element:addElement(

									{'element',

										0, 0, 0, 0, color = {255,255,255,255},

										onRender = function(element)

											local anim, target = getAnimData( gameBonuses_prizeWindow.animationAlpha )
											local alpha = element:alpha()

											if element.parent.rt_draw then

												dxSetRenderTarget()

												local blur = getBlurTexture( element.parent.renderTarget, 4*anim, 1 )

												mta_dxDrawImage(
													0, 0, real_sx, real_sy, blur
												)

												mta_dxDrawRectangle(
													0, 0, real_sx, real_sy, tocolor( 100,100,100,20*alpha * anim ) 
												)
												
											end



										end,

									}

								)

								element:addElement(

									{'element',

										'center', 'center',
										616, 568,
										color = { 255,255,255,255 },

										variable = 'gameBonuses_prizeWindow',

										addEvent('freeroam.dispayGameBonusReceive', true),
										addEventHandler('freeroam.dispayGameBonusReceive', resourceRoot, function(prize)

											animate( gameBonuses_prizeWindow.animationAlpha, 1 )
											gameBonuses_prizeWindow.prize = prize

										end),

										onRender = function(element)

											if not element.prize then return end

											local alpha = element:alpha()

											local _, target = getAnimData( element.animationAlpha )

											local b_alpha = target > 0 and getEasingValue( alpha, 'OutBounce' ) or alpha

											local bw,bh

											if target > 0 then
												bw,bh = element.w0*b_alpha, element.h0*b_alpha
											else
												bw,bh = element.w0, element.h0
											end

											local rx,ry,rw,rh = element.parent:abs()

											element[2] = rw/2 - bw/2
											element[3] = ry + rh/2 - bh/2 - element.h0/2 + 120
											element[4] = bw
											element[5] = bh

											local x,y,w,h = element:abs()

											dxDrawImage(
												x,y,w,h, 'assets/images/game_bonuses/take_bg.png',
												0, 0, 0, tocolor( 0,0,0,200*alpha )
											)

											dxDrawText('Ваша награда',
												x, y + 30,
												x+w, y + 30,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
												'center', 'top'
											)

											local hw,hh = 77, 30
											local hx,hy = x+w/2-hw/2, y + 60

											dxDrawImage(
												hx,hy,hw,hh, 'assets/images/game_bonuses/hline.png',
												0, 0, 0, tocolor( 200,90,90,200*alpha )
											)

											local iw,ih

											if target > 0 then
												iw,ih = 250*b_alpha, 250*b_alpha
											else
												iw,ih = 250, 250
											end

											local ix,iy = x+w/2-iw/2, y + 130

											local shw,shh = 519, 518
											local shx,shy = ix+iw/2 - shw/2, iy+ih/2 - shh/2

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/game_bonuses/shadow.png',
												0, 0, 0, tocolor( 255,0,255,100*alpha )
											)

											dxDrawImage(
												ix,iy,iw,ih, element.prize.image,
												0, 0, 0, tocolor( 255,255,255,255*alpha )
											)

											dxDrawText(element.prize.name,
												x, y + h - 150,
												x + w, y + h - 150,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 33, 'light'),
												'center', 'bottom'
											)

										end,

										onInit = function(element)

											element.animationAlpha = {}
											setAnimData( element.animationAlpha, 0.1 )

											element.w0 = element[4]
											element.h0 = element[5]

										end,

										elements = {

											{'button',

												'center',
												function(s,p) return p[5] - s[5] - 40 end,
												239, 53,

												bg = 'assets/images/game_bonuses/tbtn_empty.png',
												activeBg = 'assets/images/game_bonuses/tbtn.png',

												color = { 200,80,80,255 },
												'Забрать',

												font = getFont('montserrat_semibold', 24, 'light'),
												scale = 0.5,

												onPreRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local shadow = {
														['assets/images/game_bonuses/tbtn_empty_shadow.png'] = (1-element.animData),
														['assets/images/game_bonuses/tbtn_shadow.png'] = element.animData,
													}

													for path, anim in pairs( shadow ) do

														local texture = getDrawingTexture( path )

														local mw,mh = dxGetMaterialSize( texture )
														local mx,my = x+w/2-mw/2, y+h/2-mh/2

														dxDrawImage(
															mx,my,mw,mh, texture,
															0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
														)

													end

												end,

												onClick = function(element)
													animate( element.parent.animationAlpha, 0 )
												end,

											},


										},

									}

								)

								element.p_anim = {}
								setAnimData( element.p_anim, 0.1, 0 )

								setTimer(function()

									if windowOpened then
										setAnimData( element.p_anim, 0.1, 1 )
										animate( element.p_anim, 0 )
									end

								end, 3000, 0)

							end,

							updateRenderTarget = function(element)

								if not isElement( element.renderTarget ) then
									element.renderTarget = dxCreateRenderTarget( real_sx, real_sy, true )
								end

							end,

							onPreRender = function(element)

								if ( getTickCount() - (element.rendered or 0) ) > 3000 then

									setAnimData( element.s_anim, 0.05 )
									animate( element.s_anim, 1 )

								end

								element.rendered = getTickCount()

							end,

							gOnPreRender = function(element)

								element:updateRenderTarget()

								local anim, target = getAnimData( gameBonuses_prizeWindow.animationAlpha )

								if target == 0 and anim < 0.01 then
									element.rt_draw = false
								else
									dxSetRenderTarget(element.renderTarget, true)
									element.rt_draw = true
								end


							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local animData = getAnimData( element.s_anim )

								local iw,ih = 45,45
								local ix,iy = x + 240, y + 680

								local texture = getDrawingTexture('assets/images/game_bonuses/info.png')

								dxDrawImage(
									ix,iy,iw,ih, texture,
									0, 0, 0, tocolor( 200,90,90,255*alpha )
								)

								local p_anim = getAnimData( element.p_anim )
								local p_alpha = ( 0.5 - math.abs( p_anim - 0.5 ) )*2

								local gradient = getTextureGradient(texture, {
									color = {
										{ 255,120,120, 150 },
										{ 0, 0, 0, 0 },
									},
									alpha = alpha * p_alpha,
									angle = 180 * p_anim,
								})

								dxDrawImage(
									ix,iy,iw,ih, gradient,
									0, 0, 0, tocolor( 200,90,90,255*alpha )
								)


								mta_dxDrawRectangle(
									px(ix + iw - 9), px(iy+ih/2+18),
									px(300), 1, tocolor( 200,90,90,100*alpha )
								)

								mta_dxDrawRectangle(
									px(ix + iw + 150), px(iy+ih/2),
									px(300), 1, tocolor( 200,90,90,100*alpha )
								)

								dxDrawText('Что такое RAGE BOX?',
									ix + iw + 15, iy + 12,
									ix + iw + 15, iy + 12,
									tocolor( 150,150,150,255*alpha ),
									0.5, 0.5, getFont('montserrat_bold', 25, 'light'),
									'left', 'bottom'
								)

								local text = {
									'Играй на сервере, чтобы получить мистическую коробку,',
									'из которой тебе выпадет абсолютно случайный приз!'
								}

								local startY = iy + 12

								for _, row in pairs( text ) do

									dxDrawText(row,
										ix + iw + 15, startY,
										ix + iw + 15, startY,
										tocolor(255,255,255,255*alpha*animData),
										0.5, 0.5, getFont('montserrat_medium_italic', 23, 'light'),
										'left', 'top'
									)

									startY = startY + 18

								end


							end,

							onInit = function(element)

								local w,h = 260, 260
								local padding = 10

								local sCount = #Config.game_bonuses / 2

								local startY = 230
								local startX = element[4]/2 - w*sCount - padding*(sCount-0.5)

								for _, box in pairs( Config.game_bonuses ) do

									element:addElement(
										{'element',

											startX, startY,
											w,h,

											box.image,
											color = {255,255,255,255},

											box = box,

											y0 = startY,

											onInit = function(element)

												setTimer(function()

													if windowOpened then

														for i = 1, math.random( 3,8 ) do
															element:createFlake()
														end

													end

												end, 500, 0)

												element:addHandler('onPreRender', function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													for _, flake in pairs( element.flakes or {} ) do

														local anim_data = getAnimData( flake.anim )
														local ox,oy = unpack( flake.offset )

														local fw,fh = flake.size, flake.size
														local fx,fy = x+w/2 + ox, y+h/2 + oy - (anim_data * flake.grow)

														local r,g,b = unpack( flake.color )

														dxDrawImage(
															fx,fy, fw,fh, roundTexture,
															0, 0, 0, tocolor( r,g,b, 255*alpha * ( 1 - anim_data ) )
														)

													end

												end)

											end,

											createFlake = function(element)

												element.flakes = element.flakes or {}

												local size = math.random( 1, 4 )
												local grow = math.random( 100, 150 )
												local offset = { math.random( -50, 50 ), math.random( -20, 20 ) }
												local color = element.box.color
												local anim = {}

												element.flakes[anim] = {
													size = size,
													grow = grow,
													anim = anim,
													color = color,
													offset = offset,
												}

												setAnimData( anim, 0.05 )
												animate( anim, 1, function()
													element:destroyFlake( anim )
												end )

											end,

											destroyFlake = function(element, id)
												element.flakes[id] = nil
												removeAnimData( id )
											end,

											onPreRender = function(element)

												local animData = getAnimData( element.parent.s_anim )
												animData = getEasingValue( animData, 'OutBounce' )

												element[3] = element.y0 - (1-animData)*100

											end,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local animData = getAnimData( element.parent.s_anim )
												local b_animData = getEasingValue( animData, 'OutBounce' )

												local iw,ih = w*b_animData, h*b_animData
												local ix,iy = x+w/2-iw/2, y+h/2-ih/2

												dxDrawImage(
													ix,iy,iw,ih, element[6],
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)

												local tw,th = 60,60
												local tx,ty = x + 80, y + 160

												local cr,cg,cb = unpack( element.box.color )

												local bw,bh = 156, 41
												local bx,by = tx + 20, ty + th - bh - 20

												local bonuses = localPlayer:getData('game_bonuses') or {}

												local config = Config.game_bonuses[ element.box.id ]
												local bonus = bonuses[ element.box.id ]

												if not bonus then return end

												local server_timestamp = getServerTimestamp()

												local texture = getDrawingTexture( 'assets/images/game_bonuses/timer_bg.png' )

												dxDrawImage(
													bx,by,bw,bh, texture,
													0, 0, 0, tocolor( 0, 0, 0, 150*alpha )
												)

												local p_anim = getAnimData( element.parent.p_anim )
												local p_anim2 = 1-getAnimData( element.parent.p_anim )
												local p_alpha = ( 0.5 - math.abs( p_anim - 0.5 ) )*2

												local gradient = getTextureGradient(texture, {
													color = {
														{ cr,cg,cb, 80 },
														{ 0, 0, 0, 0 },
													},
													alpha = alpha * p_alpha,
													angle = 180 * p_anim,
												})

												dxDrawImage(
													bx,by,bw,bh, gradient
												)

												dxDrawText(('%s %s'):format( element.box.play_hours, getWordCase(
													element.box.play_hours, 'час', 'часа', 'часов'
												) ),
													bx,by,bx+bw,by+bh,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('hb_medium', 26, 'light'),
													'center', 'center'
												)

												dxDrawImage(
													tx - 10*p_anim2,ty - 10*p_anim2,
													tw + 20*p_anim2,th + 20*p_anim2,
													'assets/images/game_bonuses/timer.png',
													0, 0, 0, tocolor( cr,cg,cb,150*alpha*p_alpha )
												)

												dxDrawImage(
													tx,ty,tw,th, 'assets/images/game_bonuses/timer.png',
													0, 0, 0, tocolor( cr,cg,cb,255*alpha )
												)

												dxDrawText(element.box.name,
													x, y + 230, x + w, y + 230,
													tocolor(255,255,255,255*alpha*animData),
													0.5, 0.5, getFont('hb_medium', 32, 'light'),
													'center', 'top'
												)

												local time = {}

												local seconds_dec = bonus.update_time and (server_timestamp.timestamp - bonus.update_time) or 0
												local seconds = bonus.time - seconds_dec

												element.draw_button = (seconds <= 0 and not bonus.received)

												if seconds > 0 then

													time.h = math.floor( seconds / 3600 )
													time.m =  math.floor( (seconds - (time.h * 3600)) / 60 )
													time.s =  math.floor( seconds - (time.h * 3600) - (time.m * 60) )

													dxDrawText(('%02d:%02d:%02d'):format( time.h, time.m, time.s ),
														x, y + 280, x + w, y + 280,
														tocolor(150, 150, 150,255*alpha*animData),
														0.5, 0.5, getFont('hb_medium', 26, 'light'),
														'center', 'top'
													)

												elseif bonus.received then

													dxDrawText('Бонус получен',
														x, y + 280, x + w, y + 280,
														tocolor(150, 150, 150,255*alpha*animData),
														0.5, 0.5, getFont('hb_medium', 26, 'light'),
														'center', 'top'
													)

												end


											end,

											elements = {

												{'button',

													'center',
													275,
													167, 37,

													bg = 'assets/images/game_bonuses/btn_empty.png',
													activeBg = 'assets/images/game_bonuses/btn.png',

													color = { 200,80,80,255 },
													'Забрать',

													font = getFont('montserrat_bold', 19, 'light'),
													scale = 0.5,

													onPreRender = function(element)

														local alpha = element:alpha()
														local x,y,w,h = element:abs()

														local shadow = {
															['assets/images/game_bonuses/btn_empty_shadow.png'] = (1-element.animData),
															['assets/images/game_bonuses/btn_shadow.png'] = element.animData,
														}

														for path, anim in pairs( shadow ) do

															local texture = getDrawingTexture( path )

															local mw,mh = dxGetMaterialSize( texture )
															local mx,my = x+w/2-mw/2, y+h/2-mh/2

															dxDrawImage(
																mx,my,mw,mh, texture,
																0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
															)

														end

													end,

													onClick = function(element)

														local anim, target = getAnimData( gameBonuses_prizeWindow.animationAlpha )

														if target == 0 then
															triggerServerEvent('freeroam.takeGameBonus',
																resourceRoot, element.parent.box.id
															)
														end

													end,

													noDraw = function(element)
														return not element.parent.draw_button
													end,

												},

											},

										}
									)

									startX = startX + padding + w

								end

							end,

							elements = {

								{'element',

									0, 0, 0, 0,
									color = {255,255,255,255},

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element.parent:abs()

										local animData = getAnimData( element.parent.s_anim )
										animData = getEasingValue( animData, 'OutBounce' )

										local iw,ih = 286*animData, 259*animData
										local ix,iy = x + w/2 - iw/2, y + 259/2 - ih/2

										dxDrawImage(
											ix,iy,iw,ih, 'assets/images/game_bonuses/ragebox.png',
											0, 0, 0, tocolor( 255,255,255,255*alpha )
										)


									end,


								},

							},

						},


					},


				},


			},

		},

	},

	packs = {

		{'window-element',

			variable = 'packsWindow',
			section = 'main',

			init = function(element)

				for _, c_element in pairs( element.elements ) do

					c_element.animationAlpha = {}
					setAnimData(c_element.animationAlpha, 0.1, 0)

					c_element.noDraw = function(element)
						animate(element.animationAlpha, element.section == element.parent.section and 1 or 0)
					end

				end

				closeHandlers.packs = function()
					packsWindow.section = 'main'
				end

				openHandlers.packs = function()
					packsWindow.section = localPlayer:getData('freeroam.pack.currentPrize') and 'prize' or 'main'
				end

			end,


			elements = {

				{'element',

					'center', 'center',
					1320, 850,
					color = {255,255,255,255},

					variable = 'packsElement',
					overflow = 'vertical',

					section = 'main',

					scrollBgColor = {20,20,30,255},

					scrollXOffset = 10,

					onInit = function(element)

						local rows = math.ceil( #Config.packs/3 )

						local startY = 0
						local w,h = 425, 399
						local padding = 15

						local index = 1

						for i = 1,rows do

							local startX = 0

							local r_element = element:addElement(
								{'element',

									0, startY,
									'100%', h+padding,
									color = {255,255,255,255},


								}
							)

							for p_i = 1,3 do

								local p_index = Config.packs_order[ index ]

								if Config.packs[p_index] then
									r_element:addElement(
										{'image',

											startX, 'center',
											w,h,
											color = {20,20,30,255},
											'assets/images/pack_bg.png',

											index = p_index,
											pack = Config.packs[p_index],

											onInit = function(element)
												element.y0 = element[3]
											end,

											onClick = function(element)
												packsWindow.section = 'open'
												packsWindow.pack = element.pack
												packsRoulette:preload(element.pack)
											end,

											onRender = function(element)

												element[3] = element.y0 - 10*element.animData

												local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')
												element.color = {r,g,b, element.color[4]}

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local pr,pg,pb = unpack(element.pack.color)

												local texture = getDrawingTexture(element[6])
												local gradient = getTextureGradient(texture, {
													color = {
														{ pr,pg,pb, 20 + 20*element.animData },
														{ 0, 0, 0, 0 },
													},
													alpha = alpha,
													angle = -30,
												})

												dxDrawImage(
													x,y,w,h, gradient
												)

												dxDrawText('Кейс',
													x,y+20,x+w,y+20,
													tocolor(56,54,78,255*alpha),
													0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
													'center', 'top'
												)

												dxDrawText(string.format('«%s»', utf8.upper(element.pack.name)),
													x,y+40,x+w,y+40,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
													'center', 'top'
												)

												local packs = localPlayer:getData('packs') or {}
												if (packs[element.pack.index] or 0) > 0 then

													dxDrawText('В наличии: ' .. packs[element.pack.index],
														x,y+70,x+w,y+70,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'center', 'top'
													)

												end

												local pw,ph = 250, 250

												dxDrawImage(
													x+w/2-pw/2, y+80,
													pw,ph, element.pack.icon,
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)

												drawSmartText(string.format('<img>assets/images/donate.png</img> %s',
													element.pack.cost
												),
													x, x+w, y+h-60, 
													tocolor(255,255,255,255*alpha),
													tocolor(255,255,255,255*alpha),
													0.5, getFont('montserrat_semibold', 28, 'light'),
													'center', 40, 5
												)

												local count = getPacksCount(element.pack)

												if count ~= -1 then

													local ppw,pph = 285, 12
													local ppx,ppy = x+w/2-ppw/2, y+110

													dxDrawImage(
														ppx,ppy, ppw,pph,
														'assets/images/pack_progress.png', 0, 0, 0, tocolor(24,23,36,255*alpha)
													)
													drawImageSection(
														ppx,ppy, ppw,pph,
														'assets/images/pack_progress.png',
														{ x = count.count/count.max, y = 1 }, tocolor(180, 70, 70,255*alpha)
													)

													dxDrawText('Осталось кейсов:',
														ppx + 20, ppy - 5,
														ppx + 20, ppy - 5,
														tocolor(56,54,78,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'left', 'bottom'
													)


													dxDrawText(string.format('%s%%',
														math.floor( count.count/count.max * 100 )
													),
														ppx + ppw - 20, ppy - 5,
														ppx + ppw - 20, ppy - 5,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'right', 'bottom'
													)

												end

											end,


										}
									)

									index = index + 1
									startX = startX + w + padding
								else
									break
								end

							end

							startY = startY + h + padding

						end

					end,


				},

				{'image',

					'center', 'center',
					805, 486,
					color = {18,18,28,255},
					'assets/images/pack_open_bg.png',

					section = 'open',

					elements = {

						{'element',

							0, 0, 400, '100%',
							color = {255,255,255,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()
								local ex,ey,ew,eh = element.parent:abs()

								drawImageSection(
									ex,ey,ew,eh, element.parent[6],
									{ x=w/ew, y = 1 }, tocolor(27,27,37, 255*alpha)
								)

								local texture = getDrawingTexture(element.parent[6])
								local gradient = getTextureGradient(texture, {
									color = {
										{ 180, 70, 70, 15 },
										{ 0, 0, 0, 0 },
									},
									alpha = alpha,
									angle = -30,
								})

								dxDrawImage(
									ex,ey,ew,eh, gradient
								)

								dxDrawText(packsWindow.pack.name,
									x,y+40,x+w,y+40,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
									'center', 'top'
								)

								local count = getPacksCount(packsWindow.pack)

								if count ~= -1 then

									local ppw,pph = 285, 12
									local ppx,ppy = x+w/2-ppw/2, y+120

									dxDrawImage(
										ppx,ppy, ppw,pph,
										'assets/images/pack_progress.png', 0, 0, 0, tocolor(24,23,36,255*alpha)
									)
									drawImageSection(
										ppx,ppy, ppw,pph,
										'assets/images/pack_progress.png',
										{ x = count.count/count.max, y = 1 }, tocolor(180, 70, 70,255*alpha)
									)

									dxDrawText('Осталось кейсов:',
										ppx + 20, ppy - 5,
										ppx + 20, ppy - 5,
										tocolor(56,54,78,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
										'left', 'bottom'
									)

									dxDrawText(string.format('%s%%',
										math.floor( count.count/count.max * 100 )
									),
										ppx + ppw - 20, ppy - 5,
										ppx + ppw - 20, ppy - 5,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
										'right', 'bottom'
									)


								end
								
								local pw,ph = 270, 270

								dxDrawImage(
									x+w/2-pw/2, y+100,
									pw,ph, packsWindow.pack.icon,
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

								drawSmartText(string.format('<img>assets/images/donate.png</img> %s',
									packsWindow.pack.cost
								),
									x, x+w, y+120+230, 
									tocolor(255,255,255,255*alpha),
									tocolor(255,255,255,255*alpha),
									0.5, getFont('montserrat_semibold', 28, 'light'),
									'center', 40, 5
								)

							end,

							elements = {

								{'button',
									'center', function(s,p) return p[5]-s[5]-40 end,
									[6] = 'Купить',

									define_from = 'packs-button',

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onRender = function(element)

										if not packsWindow.pack then return end

										local packs = localPlayer:getData('packs') or {}
										if (packs[packsWindow.pack.index] or 0) > 0 then
											element[6] = 'Открыть'
										else
											element[6] = 'Купить'
										end


									end,

									onClick = function(element)

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)

										packsWindow.packLoading = true

										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

											packsWindow.packLoading = false
											animate(element.animationAlpha, 1)

											if packsRoulette:isActive() then return end
											triggerServerEvent('freeroam.openPack', resourceRoot, packsWindow.pack)


										end )

									end,


								},

							},

						},

						{'element',

							'right', 0, function(s,p) return p[4]-400 end, '100%',
							color = {255,255,255,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local iw,ih = 100, 100

								local padding = 10

								local sCount_x = 1.5
								local sCount_y = 2

								local _startX = x+w/2 - sCount_x*iw - padding*(sCount_x-0.5)

								local startY = y+h/2 - sCount_y*ih - padding*(sCount_y-0.5)

								local index = 1

								for i_1 = 1, 4 do

									startX = _startX

									for i_2 = 1,3 do

										local pack_item = packsWindow.pack.items[index]

										if pack_item then

											dxDrawImage(
												startX, startY,
												iw,ih, 'assets/images/pack_open_item_bg.png',
												0, 0, 0, tocolor(27,27,37,255*alpha)
											)

											local scale = pack_item.img_scale or 1
											local piw, pih = 60*scale, 60*scale

											if pack_item.icon:find('vehicles_shop') then
												piw,pih = 60*scale, 36*scale
											end

											local pix,piy = startX+iw/2-piw/2, startY+ih/2-pih/2

											dxDrawImage(
												pix,piy-(scale == 1 and 8 or 0),
												piw,pih, pack_item.icon,
												0, 0, 0, tocolor(255,255,255,255*alpha)
											)

											dxDrawText(pack_item.tooltip or pack_item.name,
												pix, startY+ih - 8,
												pix+piw, startY+ih - 8,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_bold', 19, 'light'),
												'center', 'bottom'
											)

											-- if isMouseInPosition(startX, startY, iw,ih) then
											-- 	element.tooltip = pack_item
											-- end

											startX = startX + iw + padding

											index = index + 1

										end


									end

									startY = startY + ih + padding

								end

							end,

							onPostRender = function(element)

								if not element.tooltip then return end

								local alpha = element:alpha()

								local cx,cy = getCursorPosition()

								cx,cy = cx*sx + 5, (cy*real_sy) * sx/real_sx + 5

								local scale, font = 0.5, getFont('montserrat_medium', 25, 'light')
								local width = dxGetTextWidth(element.tooltip.name, scale, font)+20
								local height = dxGetFontHeight(scale, font)+10

								local gradient = getTextureGradient(whiteTexture, {
									color = {
										{ 0, 0, 0, 10 },
										{ 0, 0, 0, 230 },
									},
									angle = 70+90,
									alpha = alpha,	
								})

								dxDrawImage(
									cx,cy, width, height, gradient
								)

								dxDrawText(element.tooltip.name,
									cx,cy,cx+width,cy+height,
									tocolor(255,255,255,255*alpha),
									scale, scale, font,
									'center', 'center'
								)

								element.tooltip = nil

							end,

						},


						{'button',
							-50, -20,
							[6] = 'Назад',

							define_from = 'packs-button',

							onInit = function(element)
								element.bg = element.activeBg
							end,

							onClick = function(element)
								if not packsWindow.packLoading then
									packsWindow.section = 'main'
								end
							end,


						},

					},

				},

				{'element',

					'center', 'center',
					'100%', 500,
					color = {255,255,255,255},

					section = 'roulette',

					elements = {

						{'element',

							0, 'center', '100%', 220,
							color = {255,255,255,255},

							variable = 'packsRoulette',

							rouletteElements = {},
							rouletteElementsTemplate = {},

							onInit = function(element)

								element.offset_anim = {}
								setAnimData(element.offset_anim, 0.01, 0)

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shw,shh = w,250
								local shx,shy = x+w/2-shw/2, y+h/2-shh/2

								dxDrawRectangle(
									x,y,w,h, tocolor(18,18,28,255*alpha)
								)

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/packs_roulette_pointer.png',
									0, 0, 0, tocolor(180,70,70,255*alpha)
								)

							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText(
									isTimer(packsRoulette.timer) and 'Запускаем рулетку...' or 'Идет прокрутка...',
									x,y-40,x+w, y-40,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
									'center', 'bottom'
								)

								element.renderTarget = element.renderTarget or
									dxCreateRenderTarget(px(w), px(h), true)

								dxSetBlendMode('modulate_add')
								
								dxSetRenderTarget(element.renderTarget, true)

									local offset, target = getAnimData(element.offset_anim)

									if math.abs(target - offset) < 2 and element:isActive() then
										if packsWindow.section == 'roulette' then
											packsWindow.section = 'prize'
										end
									end

									for _, rElement in pairs( element.rouletteElements ) do

										local scale = rElement.item.img_scale or 1

										local size = (element[5] - 70)*scale
										local h_size = (element[5] - 70)*scale

										if rElement.item.icon:find('vehicles_shop') then
											h_size = size/(252/152)
										end

										local x,y = rElement.offset + offset + element[5]/2 - size/2, element[5]/2 - h_size/2

										dxDrawImage(
											x,y-(scale == 1 and 20 or 0),size,h_size,
											rElement.item.icon, 0, 0, 0, tocolor(255,255,255,255)
										)

										dxDrawText(rElement.item.tooltip or rElement.item.name,
											x, element[5] - 25,
											x+size, element[5] - 25,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_bold', 28, 'light'),
											'center', 'bottom'
										)

									end

								dxSetRenderTarget()

								dxSetBlendMode('blend')

								dxDrawImage(
									x,y,w,h,
									element.renderTarget, 0, 0, 0,
									tocolor(255,255,255,255*alpha)
								)

							end,

							preload = function(element, pack)

								element.rouletteElementsTemplate = table.copy( pack.items )
								element.rouletteElements = {}

								setAnimData(element.offset_anim, 0.02, 0)

								local startX = 0


								for i = 1,4 do
									for _, r_element in pairs( element.rouletteElementsTemplate ) do

										table.insert(element.rouletteElements, {
											item = r_element,
											offset = startX,
										})

										startX = startX + element[5]

									end
								end

							end,

							isActive = function(element)

								if packsWindow.section ~= 'roulette' then
									return false
								end

								local animData, target = getAnimData(element.offset_anim)
								return ( math.abs(animData - target) ) > 0.001

							end,

							roll = function(element, itemId)

								packsWindow.win_item = packsWindow.pack.items[itemId]

								local startX = element.rouletteElements[#element.rouletteElements].offset + element[5]

								for i = 1,4 do
									for _, r_element in pairs( element.rouletteElementsTemplate ) do

										table.insert(element.rouletteElements, {
											item = r_element,
											offset = startX,
										})

										startX = startX + element[5]

									end
								end

								local _, cOffset = getAnimData(element.offset_anim)

								for _, r_element in pairs( element.rouletteElements ) do

									if ( (r_element.offset + cOffset) - (element[4]/2) ) > element[5]*10 then

										if r_element.item.index == itemId then

											animate(element.offset_anim, -r_element.offset + element[4]/2 - ( element[5]/2 + math.random(
												-element[5]*0.1, element[5]*0.1
											) ), function()

												if packsWindow.section == 'roulette' then
													packsWindow.section = 'prize'
												end

											end )

											break

										end

									end

								end

							end,

							addEvent('freeroam.pack.openResult', true),
							addEventHandler('freeroam.pack.openResult', root, function( itemId )

								packsWindow.section = 'roulette'

								local x,y,w,h = packsRoulette:abs()

								displayLoading( {x+w/2-100/2, y-200, 100, 100}, {180,70,70,255}, 1000, function()

									


								end )


								packsRoulette.timer = setTimer(function()
									packsRoulette:roll( itemId )
								end, 1000, 1)

							end),

						},

					},


				},

				{'element',

					'center', 'center',
					800, 600,
					color = {255,255,255,255},

					section = 'prize',

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawRectangle(
							x + 200, y + 100,
							400, 400, tocolor(17,17,27,255*alpha)
						)
						dxDrawRectangle(
							x + 100, y + 200,
							400, 400, tocolor(180,70,70,10*alpha)
						)

						dxDrawText('Вы выиграли:',
							x,y+30,x+w,y+30,
							tocolor(56,53,78,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
							'center', 'top'
						)

						dxDrawText(packsWindow.win_item.name,
							x,y+60,x+w,y+60,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 50, 'light'),
							'center', 'top'
						)

						if packsWindow.win_item.sellCost then

							dxDrawText(string.format('Гос. стоимость - #ffffff$%s',
								splitWithPoints( packsWindow.win_item.sellCost, '.' )
							),
								x,y+120,x+w,y+120,
								tocolor(56,53,78,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
								'center', 'top', false, false, false, true
							)

						end

						local iw,ih = 300,300

						if packsWindow.win_item.icon:find('vehicles_shop') then
							ih = ih/(252/152)
						end

						local ix,iy = x+w/2-iw/2, y + 170 + 300/2 - ih/2

						dxDrawImage(
							ix,iy,iw,ih, packsWindow.win_item.icon,
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					elements = {

						{'element',

							'center', function(s,p) return p[5] - s[5] - 30 end,
							370, 49,
							color = {255,255,255,255},

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							elements = {

								{'button',

									'left', 'top',
									177,49,
									define_from = 'packs-button',

									'Забрать',

									shadowSize = {194,66},

									bg = 'assets/images/pbtn2_empty.png',
									activeBg = 'assets/images/pbtn2.png',
									shadow = 'assets/images/pbtn2_empty_shadow.png',
									activeShadow = 'assets/images/pbtn2_shadow.png',

									onRender = function(element)

										element[2] = packsWindow.win_item.sellCost and 0 or (element.parent[4]/2 - element[4]/2)

									end,

									onClick = function(element)

										local x,y,w,h = element.parent:abs()

										animate(element.parent.animationAlpha, 0)
										displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1500, function()

											animate(element.parent.animationAlpha, 1)

											triggerServerEvent('freeroam.takePackPrize', resourceRoot)
											packsWindow.section = 'main'


										end )

									end,

								},

								{'button',

									'right', 'top',
									177,49,
									define_from = 'packs-button',

									'Продать',

									shadowSize = {194,66},

									bg = 'assets/images/pbtn2_empty.png',
									activeBg = 'assets/images/pbtn2.png',
									shadow = 'assets/images/pbtn2_empty_shadow.png',
									activeShadow = 'assets/images/pbtn2_shadow.png',

									noDraw = function(element)
										return not packsWindow.win_item.sellCost
									end,

									onClick = function(element)

										local x,y,w,h = element.parent:abs()

										animate(element.parent.animationAlpha, 0)
										displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1500, function()

											animate(element.parent.animationAlpha, 1)

											triggerServerEvent('freeroam.sellPackPrize', resourceRoot)
											packsWindow.section = 'main'


										end )

									end,

								},

							},

						},

					},

				},

			},

		},

	},

	shop = {

		{'window-element',

			elements = {

				{'element',

					'center', 'center',
					1200, 700,
					color = {255,255,255,255},

					tabs = {
						{ name = 'Покупка валюты', id = 'convert' },
						{ name = 'VIP-аккаунт', id = 'vip' },
						{ name = 'Уникальные товары', id = 'items' },
					},

					variable = 'shopElement',

					onInit = function(element)

						element.tab = element.tabs[1]

						local startY = 0

						for _, tab in pairs( element.tabs ) do

							local tab_element = element:addElement(
								{'settings-tab',

									'left', startY,
									icon_size = 55,

									tab = tab,

								}
							)

							startY = startY + 92

						end



					end,

					elements = {

						{'section',

							[5] = '60%',
							section = 'convert',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText('Обмен валют',
									x, y + 40, x+w, y+40,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
									'center', 'bottom'
								)

								dxDrawRectangle(
									x+50, y + 100,
									650, 400, tocolor( 20, 20, 30, 100*alpha )
								)

							end,

							elements = {

								{'input',

									[2]=100, [3]=80,

									placeholder = 'Сумма R-Coin',
									c_icon = 'assets/images/donate.png',
									variable = 'shopConvertSum',

									type = 'number',

									define_from = 'convert-input',

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										mta_dxDrawRectangle(
											px(x+w-50),px(y+h),
											1, px(120),
											tocolor(180,70,70,255*alpha)
										)

									end,

								},

								{'input',

									[2]=280, [3]=200,

									placeholder = 'Скидочный промокод',
									variable = 'shopConvertPromo',

									define_from = 'convert-input',

									maxSymbols = 12,

									onScroll = function(element)

										local promocodes = localPlayer:getData('convert_promocodes') or {}
										local tbl_promocodes = {}

										for promo, data in pairs( promocodes ) do
											table.insert( tbl_promocodes, { promo = promo, data = data } )
										end

										table.sort(tbl_promocodes, function(a,b)
											return a.data.timestamp < b.data.timestamp
										end)

										element.index = element.index or 0
										element.index = cycle( element.index + 1, 1, #tbl_promocodes )
										local promo = tbl_promocodes[ element.index ]

										if promo then
											element[6] = promo.promo
										end


									end,

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										mta_dxDrawRectangle(
											px(x+w/2),px(y+h),
											1, px(120),
											tocolor(180,70,70,255*alpha)
										)

									end,

									init = function(element)

										element:addHandler('onRender', function(element)

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local promocodes = localPlayer:getData('convert_promocodes') or {}
											if getTableLength(promocodes) > 0 then

												dxDrawText('Покрутите колесиком',
													x+w, y-5,
													x+w, y-5,
													tocolor(100,100,120,255*alpha*element.animData),
													0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
													'right', 'bottom'
												)


											end

											if promocodes[element[6]] then
												dxDrawText(string.format('%s%%', promocodes[element[6]].bonus),
													x+30, y,
													x+30, y+h,
													tocolor(100,100,120,255*alpha),
													0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
													'left', 'center'
												)
											end

										end)

									end,

								},

								{'input',

									[2]=200, [3]=320,

									placeholder = '',

									define_from = 'convert-input',
									noEdit = true,

									c_icon = 'assets/images/bonuses/money.png',

									onPreRender = function(element)

										local donate_sum = tonumber( shopConvertSum[6] ) or 0

										local promo = getConvertPromo( localPlayer, shopConvertPromo[6] )
										local sum = Config.donateConvert * donate_sum

										if promo and promo.bonus then
											sum = sum + sum/100*promo.bonus
										end

										element[6] = splitWithPoints( sum, '.' )

									end,

								},

								{'button',

									[2] = 'center', [3] = 440,
									[6] = 'Конвертировать',
									define_from = 'convert-button',

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onClick = function(element)

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1000, function()

											animate(element.animationAlpha, 1)

											local amount = tonumber( shopConvertSum[6] ) or 0
											if amount <= 0 then return end

											local promo = shopConvertPromo[6] ~= '' and shopConvertPromo[6] or false

											shopConvertPromo[6] = ''
											shopConvertSum[6] = ''

											triggerServerEvent('freeroam.convertValute', resourceRoot, amount, promo)


										end )

									end,

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										dxDrawText('Пополнить счёт можно на сайте  #ffffffxragemta.trademc.org',
											x, y + h + 30, x + w, y + h + 30,
											tocolor(56,53,78,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
											'center', 'top', false, false, false, true
										)

									end,


								},

							},

						},

						{'section',

							[5] = '60%',
							section = 'vip',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawRectangle(
									x+50, y + 100,
									650, 400, tocolor( 20, 20, 30, 100*alpha )
								)

							end,

							elements = {

								{'image',
									'center', 0, 
									738, 302,
									color = {18,18,28,255},
									'assets/images/vip_bg.png',

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local aw,ah = 764, 328
										local ax,ay = x+w/2-aw/2, y+h/2-ah/2

										drawImageSection(
											x,y,w,h, element[6],
											{ x = 280/w, y = 1, }, tocolor(21,21,31,255*alpha)
										)

										dxDrawImage(
											x+280/2-180/2, y+h/2-180/2,
											180, 180, 'assets/images/vip_star.png',
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

										dxDrawImage(
											ax,ay,aw,ah, 'assets/images/vip_bg_a.png',
											0, 0, 0, tocolor(255,220,100,255*alpha)
										)

										dxDrawImage(
											x+w-100,y-50,160,160, 'assets/images/vip_star2.png',
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

									end,

									onInit = function(element)

										local iw,ih = 170,142

										local sCount = 2

										local padding = (element[4] - iw*sCount*2) / ( ( sCount-0.5 )*2 )

										local startX = element[4]/2-iw*sCount-padding*(sCount-0.5)

										for i = 1,4 do

											element:addElement(
												{'image',
													startX, element[5] + 30,
													iw,ih,

													color = {18,18,28,255},
													'assets/images/vip_item.png',

													data = Config.vipItems[i],
													id = i,

													onInit = function(element)

														element.y0 = element[3]

														element.animationAlpha = {}
														setAnimData(element.animationAlpha, 0.1, 1)


													end,

													onRender = function(element)

														element[3] = element.y0 - 10*element.animData

														local r,g,b = interpolateBetween(18,18,28, 30, 30, 40, element.animData, 'InOutQuad')

														element.color = {r,g,b, element.color[4]}

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local texture = getDrawingTexture(element[6])
														local gradient = getTextureGradient(texture, {
															color = {
																element.data.hit and { 255, 220, 100, 50 } or { 180, 70, 70, 50 },
																{ 0, 0, 0, 0 },
															},
															alpha = alpha,
															angle = -90,
														})

														dxDrawImage(
															x,y,w,h, gradient
														)


														dxDrawText(string.format('%s#36334b %s',
															element.data.days, getWordCase(element.data.days, 'день', 'дня', 'дней')
														),
															x,y+30,x+w,y+30,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
															'center', 'top', false, false, false, true
														)

														if element.data.hit then

															local hw,hh = 92,48
															local hx,hy = x+w/2-hw/2, y-hh/2

															dxDrawImage(
																hx,hy,hw,hh, 'assets/images/vip_hit.png',
																0, 0, 0, tocolor(180, 70, 70, 255*alpha)
															)

															dxDrawText('ХИТ!',
																hx,hy,hx+hw,hy+hh,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																'center', 'center'

															)

														end

														local bw,bh = 116,36
														local bx,by = x+w/2-bw/2, y+h-bh-20

														dxDrawImage(
															bx,by,bw,bh, 'assets/images/vip_button.png',
															0, 0, 0, element.data.hit and
															tocolor(255, 220, 100, 255*alpha)
															or tocolor(180, 70, 70, 255*alpha)
														)

														drawSmartText(string.format('%s <img>assets/images/donate.png</img>',
															element.data.cost
														),
															bx, bx+bw, by+bh/2,
															tocolor(255,255,255,255*alpha),
															tocolor(255,255,255,255*alpha),
															0.5, getFont('montserrat_semibold', 24, 'light'),
															'center', 25, 0
														)

														dxDrawText('Желаете купить?',
															x,y+h+10,x+w,y+h+10,
															tocolor(255,255,255,255*alpha*element.animData),
															0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
															'center', 'top'
														)

													end,

													onClick = function(element)

														local x,y,w,h = element:abs()

														animate(element.animationAlpha, 0)
														displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 500, function()

															animate(element.animationAlpha, 1)
															triggerServerEvent('freeroam.buyVip', resourceRoot, element.id)

														end )

													end,

												}
											)

											startX = startX + iw + padding

										end

									end,

									elements = {

										{'element',
											280, 0,
											function(s,p) return p[4]-280 end, '100%',
											color = {255,255,255,255},

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawText('Описание',
													x + 30, y + 40,
													x + 30, y + 40,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
													'left', 'top'
												)

												dxDrawText('#36334bПокупая услугу #ffdc64VIP#36334b, вы получаете\nследующие привилегии:',
													x + 30, y + 68,
													x + 30, y + 68,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
													'left', 'top', false, false, false, true
												)

											end,

											elements = {

												{'element',

													'center', 120,
													'90%', 150,
													color = {255,255,255,255},
													overflow = 'vertical',

													scrollWidth = 4,
													scrollColor = {255,220,100,255},


													rows = {
														{ text = '+50% доход на всех работах', },
														{ text = 'Бита в инвентаре', },
														{ text = 'Джетпак (в радиальной панели X)', },
														{ text = 'Телепорт из воды', },
														{ text = 'Смена ника на 50% дешевле', },
														{ text = 'Иконка возле ника', },
														{ text = 'X2 награда за ежедневные бонусы', },
													},

													onInit = function(element)

														local startY = 0
														local rowH = 32

														for _, row in pairs( element.rows ) do

															element:addElement(
																{'element',
																	0, startY,
																	'100%', rowH,
																	color = {255,255,255,255},

																	data = row,

																	onRender = function(element)

																		local x,y,w,h = element:abs()
																		local alpha = element:alpha()

																		local iw,ih = 30,30

																		dxDrawImage(
																			x + 20, y+h/2-ih/2,
																			iw,ih, 'assets/images/vip_point.png',
																			0, 0, 0, tocolor(255,220,100,255*alpha)
																		)

																		dxDrawText(element.data.text,
																			x + 55, y,
																			x + 55, y+h,
																			tocolor(113,108,150,255*alpha),
																			0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																			'left', 'center'
																		)

																	end,

																}
															)

															startY = startY + rowH

														end

													end,


												},
											},

										},

									},

								},

							},


						},

						{'section',

							[2] = 307 + 20,
							[4] = 1000, [5] = '60%',
							section = 'items',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawRectangle(
									x,124,w,real_sy*sx/real_sx, tocolor( 20, 20, 30, 100*alpha )
								)

								local hx,hy,hw,hh = x+w/2-896/2, y-100, 896, 103

								dxDrawImage(
									hx,hy,hw,hh, 'assets/images/items_head.png',
									0, 0, 0, 
									tocolor( 255,255,255, 255*alpha )
								)

								dxDrawText('Уникальные предложения, успей приобрести!',
									hx+120,hy,
									hx+120,hy+hh,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'center'
								)

							end,

							elements = {

								{'element',

									'center', 20,
									870, 800,
									color = {255,255,255,255},
									overflow = 'vertical',

									scrollXOffset = 30,

									onInit = function(element)

										local rows = math.ceil( #Config.donateShop/2 )

										local startY = 0
										local w,h = 423, 403
										local paddingx = 25
										local paddingy = 40

										local index = 1

										for i = 1,rows do

											local startX = 0

											local r_element = element:addElement(
												{'element',

													0, startY,
													'100%', h+paddingy,
													color = {255,255,255,255},


												}
											)

											for p_i = 1,2 do

												if Config.donateShop[index] then
													r_element:addElement(
														{'image',

															startX, 'center',
															w,h,
															color = {20,20,30,255},
															'assets/images/shop_item_bg.png',

															index = index,
															item = Config.donateShop[index],

															onInit = function(element)
																element.y0 = element[3]
															end,

															onRender = function(element)

																element[3] = element.y0 - 10*element.animData

																local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')
																element.color = {r,g,b, element.color[4]}

																local alpha = element:alpha()
																local x,y,w,h = element:abs()

																if element.animData > 0.01 then

																	local texture = getDrawingTexture(element[6])
																	local gradient = getTextureGradient(texture, {
																		color = {
																			{ 180, 70, 70, 30 },
																			{ 0, 0, 0, 0 },
																		},
																		alpha = alpha*element.animData,
																		angle = -30-90,
																	})

																	dxDrawImage(
																		x,y,w,h, gradient
																	)

																end

																if element.item.benefit then

																	dxDrawText(element.item.name,
																		x+40,y+40,x+40,y+40,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
																		'left', 'center'
																	)

																	local bw,bh = 159, 52
																	local bx,by = x+w-bw-30,y+40-bh/2

																	dxDrawImage(
																		bx,by,bw,bh, 'assets/images/si_timer.png',
																		0, 0, 0, tocolor(180, 70, 70,255*alpha)
																	)

																	dxDrawText(string.format('ВЫГОДА %s%%', element.item.benefit),
																		bx,by,bx+bw,by+bh,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_bold', 22, 'light'),
																		'center', 'center'
																	)

																else

																	dxDrawText(element.item.name,
																		x,y+50,x+w,y+50,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
																		'center', 'center'
																	)

																end

																local isize = 300
																local ix,iy = x+w/2-isize/2, y+30

																local isize_a = 150
																local ix_a,iy_a = x + 50, y + 40


																dxDrawImage(
																	ix,iy,isize,isize, element.item.image,
																	0, 0, 0, tocolor(255,255,255,255*alpha*
																		(element.item.content and (1-element.animData) or 1))
																)

																if element.animData > 0.01 and element.item.content then

																	dxDrawImage(
																		ix_a,iy_a,isize_a,isize_a, element.item.image,
																		0, 0, 0, tocolor(255,255,255,255*alpha*element.animData)
																	)

																	local rx,ry,rw,rh = ix_a, iy_a + isize_a-50 + 40, 300, 2

																	dxDrawRectangle(
																		rx,ry,rw,rh, tocolor(200,200,200,50*alpha*element.animData)
																	)

																	local rowH = 22

																	local startY = ry+rh + 20
																	local startX = rx + 15 * element.animData

																	dxDrawText(element.item.title_text or 'Содержимое набора',
																		startX, startY,
																		startX, startY,
																		tocolor(100,100,120,255*alpha*element.animData),
																		0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																		'left', 'center'
																	)

																	startY = startY + rowH

																	for index, row in pairs(element.item.content) do

																		local n = (element.item.numbering ~= false) and (index..'. ') or ''
																		dxDrawText(n..row,
																			startX, startY,
																			startX, startY,
																			tocolor(255,255,255,255*alpha*element.animData),
																			0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																			'left', 'center'
																		)

																		startY = startY + rowH

																	end

																end


																if element.item.expire then

																	local tw,th = 159, 52
																	local tx,ty = x+30,y+h-th/2

																	dxDrawImage(
																		tx,ty,tw,th, 'assets/images/si_timer.png',
																		0, 0, 0, tocolor(180, 70, 70, 255*alpha)
																	)

																	local time = element.item.expire - getRealTime().timestamp

																	if time > 0 then

																		local scale, font = 0.5, getFont('montserrat_semibold', 24, 'light')

																		local time_d = math.floor( time/86400 )
																		local time_h = math.floor( ( time - time_d*86400 )/3600 )

																		local text = string.format('%02dд. %02dч.', time_d, time_h)

																		drawSmartText(string.format('<img>assets/images/quest_timer.png</img> %s',
																			text
																		),
																			tx, tx+tw, ty+th/2, 
																			tocolor(255,255,255,255*alpha),
																			tocolor(120,50,50,255*alpha),
																			0.5, getFont('montserrat_medium', 26, 'light'),
																			'center', 20, 2
																		)

																	else

																		dxDrawText('Снят с продажи',
																			tx,ty,tx+tw,ty+th,
																			tocolor(255,255,255,255*alpha),
																			0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
																			'center', 'center'
																		)

																	end



																end

																local cw,ch = 25, 25
																local cx,cy = x + 50, y+h-70

																if element.item.oldCost then
																	cy = y+h-80
																end

																local icons = {
																	money = 'assets/images/bonuses/money.png',
																	['bank.donate'] = 'assets/images/donate.png',
																}

																local icon = icons[element.item.valute or 'bank.donate']
																local scale, font = 0.5, getFont('montserrat_semibold', 30, 'light')

																dxDrawImage(
																	cx,cy,cw,ch, icon,
																	0, 0, 0, tocolor(255,255,255,255*alpha)
																)

																dxDrawText(splitWithPoints(element.item.cost, '.'),
																	cx+cw+10, cy,
																	cx+cw+10, cy+ch,
																	tocolor(255,255,255,255*alpha),
																	scale, scale, font,
																	'left', 'center'
																)

																if element.item.oldCost then

																	cy = cy + 25
																	cx = cx + 10

																	local text = splitWithPoints(element.item.oldCost, '.')
																	local textWidth = dxGetTextWidth(text, scale, font)

																	local totalWidth = textWidth + cw + 10

																	dxDrawImage(
																		cx,cy,cw,ch, icon,
																		0, 0, 0, tocolor(255,255,255,255*alpha*0.7)
																	)

																	dxDrawText(text,
																		cx+cw+10, cy,
																		cx+cw+10, cy+ch,
																		tocolor(255,255,255,255*alpha*0.7),
																		scale, scale, font,
																		'left', 'center'
																	)

																	dxDrawRectangle(
																		cx - 5, cy+ch/2+2,
																		totalWidth + 10, 2,
																		tocolor(180, 70, 70, 255*alpha)
																	)

																end



															end,

															elements = {

																{'button',

																	function(s,p) return p[4]-s[4]-30 end,
																	function(s,p) return p[5]-s[5]-30 end,
																	[6] = 'Купить',

																	define_from = 'shop-button',

																	onInit = function(element)
																		element.animationAlpha = {}
																		setAnimData(element.animationAlpha, 0.1, 1)
																	end,

																	onClick = function(element)

																		local x,y,w,h = element:abs(true)

																		animate(element.animationAlpha, 0)
																		displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 500, function()

																			animate(element.animationAlpha, 1)

																			triggerServerEvent('freeroam.buyShopItem', resourceRoot, element.parent.index)


																		end )

																	end,

																},

															},


														}
													)

													index = index + 1
													startX = startX + w + paddingx
												else
													break
												end

											end

											startY = startY + h + paddingy

										end

									end,

								},

							},

						},

					},


				},


			},

		},

	},

	achievments = {

		{'window-element',

			elements = {

				{'element',

					'center', 'center',
					1700, 700,
					color = {255,255,255,255},

					tabs = {
						{ name = 'Достижения', id = 'achievments' },
						{ name = 'Титулы', id = 'status' },
						{ name = 'Зал славы', id = 'rating' },
					},

					variable = 'achievmentsElement',

					onInit = function(element)

						element.tab = element.tabs[1]

						local startY = 0

						for _, tab in pairs( element.tabs ) do

							local tab_element = element:addElement(
								{'settings-tab',

									'left', startY,

									tab = tab,

								}
							)

							startY = startY + 92

						end



					end,

					elements = {

						{'section',

							section = 'achievments',

							elements = {
								{'element',

									'center', -30,
									'100%', '100%',

									scrollXOffset = -80,
									scrollBgColor = { 20, 20, 30, 255 },

									color = {255,255,255,255},

									overflow = 'vertical',
									variable = 'achievmentsList',

									addEvent('freeroam.receiveClientAchievments', true),
									addEventHandler('freeroam.receiveClientAchievments', resourceRoot, function(achievments)
										localPlayer:setData('achievments', achievments, false)
									end),

									onPostRender = function(element)

										if not element.tooltip then return end

										local alpha = element:alpha()

										local cx,cy = getCursorPosition()

										cx,cy = cx*sx + 5, (cy*real_sy) * sx/real_sx + 5

										local scale, font = 0.5, getFont('montserrat_medium', 25, 'light')
										local width = dxGetTextWidth(element.tooltip.name, scale, font)+20
										local height = dxGetFontHeight(scale, font)+10

										dxDrawRectangle(
											cx,cy, width, height, tocolor(0, 0, 0, 220*alpha)
										)

										dxDrawText(element.tooltip.name,
											cx,cy,cx+width,cy+height,
											tocolor(255,255,255,255*alpha),
											scale, scale, font,
											'center', 'center'
										)

										element.tooltip = nil

									end,

									onInit = function(element)

										local achievments = {}

										for _, ach in pairs( Config.achievments ) do
											if ach.display ~= false then
												table.insert(achievments, ach)
											end
										end

										local rows = math.ceil( #achievments/3 )

										local startY = 0
										local w,h = 398, 300
										local padding = 25

										local index = 1

										for i = 1,rows do

											local startX = 0

											local r_element = element:addElement(
												{'element',

													0, startY,
													'100%', h+padding,
													color = {255,255,255,255},


												}
											)

											for p_i = 1,3 do

												if achievments[index] then
													r_element:addElement(
														{'image',

															startX, 'center',
															w,h,
															color = {20,20,30,255},
															'assets/images/ac_bg.png',

															index = index,
															achievment = achievments[index],

															onInit = function(element)
																element.y0 = element[3]
															end,

															onRender = function(element)

																element[3] = element.y0 - 10*element.animData

																local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')
																element.color = {r,g,b, element.color[4]}

																local alpha = element:alpha()
																local x,y,w,h = element:abs()

																local aw,ah = 398,181
																local ax,ay = x+w/2-aw/2, y

																dxDrawImage(
																	ax,ay,aw,ah, 'assets/images/ac_bg1.png',
																	0, 0, 0, tocolor(23,23,33,255*alpha)
																)

																local ar,ag,ab = interpolateBetween( 50,50,60,180,70,70,element.animData, 'InOutQuad' )

																dxDrawImage(
																	ax,ay,aw,ah, 'assets/images/ac_bg1_a.png',
																	0, 0, 0, tocolor(ar,ag,ab,255*alpha)
																)

																if element.animData > 0.01 then

																	local texture = getDrawingTexture('assets/images/ac_bg1.png')
																	local gradient = getTextureGradient(texture, {
																		color = {
																			{ 180, 70, 70, 30 },
																			{ 0, 0, 0, 0 },
																		},
																		alpha = alpha*element.animData,
																		angle = -30-90,
																	})

																	dxDrawImage(
																		ax,ay,aw,ah, gradient
																	)

																end

																dxDrawText(element.achievment.name,
																	ax + 30, ay + 20,
																	ax + 30, ay + 20,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
																	'left', 'top'
																)

																dxDrawText(element.achievment.title,
																	ax + 30, ay + 45,
																	ax + 30, ay + 45,
																	tocolor(60,60,85,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																	'left', 'top'
																)

																local achievments = localPlayer:getData('achievments') or {}

																local achievment_data = achievments[element.achievment.index]

																if (achievment_data or element.achievment) and element.achievment.progressPoints then

																	local prw,prh = 276,5

																	local prx,pry = ax+aw/2-prw/2, ay+ah-prh - 50

																	local points

																	if element.achievment.getProgress then

																		points = element.achievment:getProgress( localPlayer )

																	else

																		points = math.floor(
																			element.achievment.progressPoints - (achievment_data.progress or 0)
																		)

																	end

																	local progress = math.clamp(points / element.achievment.progressPoints, 0, 1)

																	dxDrawImage(
																		prx,pry,prw,prh, 'assets/images/ac_progress.png',
																		0, 0, 0, tocolor(18,18,28, 255*alpha)
																	)

																	drawImageSection(
																		prx,pry,prw,prh, 'assets/images/ac_progress.png',
																		{ x = progress, y = 1 }, tocolor(180,70,70, 255*alpha)
																	)

																	if progress < 1 then

																		if element.achievment.progressPoints > 1 then

																			dxDrawText(splitWithPoints( points, '.' ),
																				prx + 15, pry+prh+5,
																				prx + 15, pry+prh+5,
																				tocolor(255,255,255,255*alpha),
																				0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
																				'left', 'top'
																			)

																			dxDrawText(splitWithPoints( element.achievment.progressPoints, '.' ),
																				prx + prw - 15, pry+prh+5,
																				prx + prw - 15, pry+prh+5,
																				tocolor(60,60,85,255*alpha),
																				0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
																				'right', 'top'
																			)

																		end

																	else

																		dxDrawText('Выполнено',
																			prx,pry+prh+7,
																			prx+prw,pry+prh+7,
																			tocolor(255,255,255,255*alpha),
																			0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
																			'center', 'top'
																		)

																	end

																end

																local itemW = 100
																local itemH = h-ah

																local startX = x+w/2 - #element.achievment.reward*itemW/2
																local startY = y+ah

																for _, reward in pairs( element.achievment.reward ) do

																	local rx,ry,rw,rh = startX + itemW/2-60/2, startY + 15, 60, 60
																	-- local animY = getAnimData(achievmentsList.ov_animId)

																	-- local abx,aby = element:abs(true)
																	-- local arx,ary = abx+rx,aby+ry-animY

																	dxDrawImage(
																		rx,ry,rw,rh, reward.icon,
																		0, 0, 0, tocolor(255,255,255,255*alpha)
																	)

																	-- if isMouseInPosition( arx,ary,rw,rh ) then
																	-- 	achievmentsList.tooltip = { name = reward.tooltip }
																	-- end

																	dxDrawText(reward.text,
																		startX, startY + 80,
																		startX + itemW, startY + 80,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																		'center', 'top'
																	)

																	startX = startX + itemW

																end
																

															end,


														}
													)

													index = index + 1
													startX = startX + w + padding
												else
													break
												end

											end

											startY = startY + h + padding

										end

									end,

								},
							},

						},

						{'section',

							section = 'status',

							elements = {
								{'element',

									'center', -30,
									'100%', '100%',

									scrollXOffset = -80,
									scrollBgColor = { 20, 20, 30, 255 },

									color = {255,255,255,255},

									overflow = 'vertical',
									variable = 'statusList',

									onInit = function(element)

										element:loadElements()

									end,

									addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

										if dn == 'statuses' then
											statusList:loadElements()
										end

									end), 

									loadElements = function(element)

										for _, c_element in pairs(element.elements or {}) do
											c_element:destroy()
										end

										element.elements = {}

										local localStatus = localPlayer:getData('statuses') or {}
										local hStatusList = {}

										for _, status in pairs( table.copy(Config.status) ) do
											if status.default_visible ~= false or localStatus[status.id] then
												table.insert(hStatusList, status)
											end
										end

										table.sort(hStatusList, function(a,b)

											local st1 = localStatus[a.id] and 1 or 0
											local st2 = localStatus[b.id] and 1 or 0
											return st1 > st2

										end)

										local rows = math.ceil( #hStatusList/3 )

										local startY = 0
										local w,h = 398, 193
										local padding = 25

										local index = 1

										for i = 1,rows do

											local startX = 0

											local r_element = element:addElement(
												{'element',

													0, startY,
													'100%', h+padding,
													color = {255,255,255,255},


												}
											)

											for p_i = 1,3 do

												if hStatusList[index] then
													r_element:addElement(
														{'image',

															startX, 'center',
															w,h,
															color = {20,20,30,255},
															'assets/images/st_bg.png',

															index = hStatusList[index].index,
															status = hStatusList[index],

															onInit = function(element)

																element.animationAlpha = {}
																setAnimData(element.animationAlpha, 0.1, 1)
																element.y0 = element[3]

															end,

															onRender = function(element)

																element[3] = element.y0 - 10*element.animData

																local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')
																element.color = {r,g,b, element.color[4]}

																local alpha = element:alpha()
																local x,y,w,h = element:abs()

																local statuses = localPlayer:getData('statuses') or {}

																if not statuses[element.status.id] then
																	alpha = alpha*0.7
																end

																local tw,th = w, 130
																local tx,ty = x, y

																drawImageSection(
																	tx,ty,tw,th, element[6],
																	{ x = tw/w, y = 1 }, tocolor(18,18,28,255*alpha)
																)

																if element.status.id == localPlayer:getData('status.current') then

																	local aw,ah = 424,155
																	local ax,ay = tx+tw/2-aw/2, ty+th/2-ah/2

																	dxDrawImage(
																		ax,ay,
																		aw,ah, 'assets/images/st_bg_a.png',
																		0, 0, 0, tocolor(180, 70, 70, 255*alpha)
																	)

																end

																local tr,tg,tb = interpolateBetween( 60,60,85, 255,255,255, element.animData, 'InOutQuad' )

																dxDrawText(element.status.bonus,
																	x, ty+th, x+w, y+h,
																	tocolor(tr,tg,tb,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																	'center', 'center'
																)

																local ix,iy,iw,ih = tx + 30, ty+th/2-84/2, 84, 84

																dxDrawImage(
																	ix,iy,iw,ih, 'assets/images/st_icon.png',
																	0, 0, 0, tocolor(20,20,30,255*alpha)
																)

																dxDrawImage(
																	ix+10,iy+10,iw-20,ih-20, string.format('assets/images/status/%s.png', element.status.id),
																	0, 0, 0, tocolor(255,255,255,255*alpha)
																)

																if not statuses[element.status.id] then
																	dxDrawImage(
																		ix-25/2+10, iy-25/2+10,
																		25,25, 'assets/images/block.png',
																		0, 0, 0, tocolor(255,255,255,255*element:alpha())
																	)
																end

																dxDrawText(element.status.name,
																	ix+iw+15, iy+5,
																	ix+iw+15, iy+5,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
																	'left', 'top'
																)

																dxDrawText(element.status.title,
																	ix+iw+15, iy+30,
																	ix+iw+15, iy+30,
																	tocolor(60,60,85,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
																	'left', 'top'
																)

															end,

															onClick = function(element)


																local statuses = localPlayer:getData('statuses') or {}

																if not statuses[element.status.id] then
																	return
																end

																local x,y,w,h = element:abs(true)

																animate(element.animationAlpha, 0)
																displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 500, function()

																	animate(element.animationAlpha, 1)

																	if element.status.id == localPlayer:getData('status.current') then
																		triggerServerEvent('freeroam.clearCurrentStatus', resourceRoot)
																	else
																		triggerServerEvent('freeroam.setCurrentStatus', resourceRoot, element.status.id)
																	end

																end )

															end,



														}
													)

													index = index + 1
													startX = startX + w + padding
													
												else
													break
												end

											end

											startY = startY + h + padding

										end

									end,

								},
							},

						},

						{'section',

							section = 'rating',

							elements = {
								{'element',

									30, 0,
									'100%', '100%',

									scrollXOffset = -80,
									scrollBgColor = { 20, 20, 30, 255 },

									color = {255,255,255,255},

									overflow = 'vertical',
									variable = 'ratingList',

									onInit = function(element)

										element.ratings_update = true

										closeHandlers.ratings = function()

											setTimer(function()
												ratingList.ratings_update = true
											end, 1500, 1)

										end

										element.animationAlpha = {}
										setAnimData( element.animationAlpha, 0.1, 1 )

									end,

									onPreRender = function(element)

										if ratingList.ratings_update then
											triggerServerEvent('ratings.sendPlayerTop', resourceRoot)
											ratingList.ratings_update = false
										end

									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										dxDrawText('* Рейтинг обновляется каждый час',
											x + 20, y - 35,
											x + 20, y - 35,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
											'left', 'bottom'
										)

										dxDrawText('* При неактиве более 3 дней вы исчезаете из рейтингов',
											x + 20, y - 10,
											x + 20, y - 10,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
											'left', 'bottom'
										)

									end,

									openRatingInfo = function(element, rating_id, data)

										if data then

											element.rating_info_request = nil
											animate( ratingList.animationAlpha, 0 )
											animate( ratingInfo.animationAlpha, 1 )

											ratingInfo.rating_id = rating_id
											ratingInfo.data = data

										else

											if element.rating_info_request then return end
											element.rating_info_request = rating_id

											triggerServerEvent('ratings.sendPlayerTop', resourceRoot, rating_id)

										end

									end,

									addEvent('ratings.receiveTop', true),
									addEventHandler('ratings.receiveTop', resourceRoot, function( top_id, data )

										data = fromJSON(data)

										if top_id then

											if top_id == ratingList.rating_info_request then
												ratingList:openRatingInfo( top_id, data )
											end

										else
											ratingList:loadElements( data )
										end

									end),

									clear = function(element)

										for _, c_element in pairs(element.elements or {}) do
											c_element:destroy()
										end

										element.elements = {}

									end,

									loadElements = function(element, data)

										element:clear()

										local t_ratings = {}

										for id, section in pairs( data ) do
											section.id = id
											table.insert(t_ratings, section)
										end

										table.sort(t_ratings, function(a,b)
											return a.id > b.id
										end)

										local rows = math.ceil( #t_ratings/2 )

										local startY = 0
										local w,h = 585, 517
										local padding = 60

										local index = 1

										for i = 1,rows do

											local startX = 0

											local r_element = element:addElement(
												{'element',

													0, startY,
													'100%', h+padding,
													color = {255,255,255,255},


												}
											)

											for p_i = 1,2 do

												if t_ratings[index] then

													t_ratings[index].local_data = t_ratings[index].local_data or { place = 0, value = 0, login = '' }

													r_element:addElement(
														{'image',

															startX, 'center',
															w,h,
															color = {22,21,32,255},
															'assets/images/rating/rating_bg.png',

															index = t_ratings[index].id,
															rating = t_ratings[index],

															onInit = function(element)

																element.animationAlpha = {}
																setAnimData(element.animationAlpha, 0.1, 1)
																element.y0 = element[3]

															end,

															onRender = function(element)

																element[3] = element.y0 - 10*element.animData

																local r,g,b = interpolateBetween(20,20,30, 30, 30, 40, element.animData, 'InOutQuad')
																element.color = {r,g,b, element.color[4]}

																local alpha = element:alpha()
																local x,y,w,h = element:abs()

																local config = getRatingSection( element.rating.id )

																dxDrawText(config.name,
																	x + 60, y + 60,
																	x + 60, y + 60,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																	'left', 'top'
																)

																dxDrawText(config.title,
																	x + 60, y + 90,
																	x + 60, y + 90,
																	tocolor(80,80,80,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
																	'left', 'top'
																)

																local iw,ih = 78,78
																local ix,iy = x+w - iw - 60 + 10, y+40 + 10

																dxDrawImage(
																	ix,iy,
																	iw,ih, 'assets/images/rating/rating_icon.png',
																	0, 0, 0, tocolor(19,18,27,255*alpha)
																)

																local cw,ch = 80,80
																local cx,cy = ix - 20, iy - 20

																dxDrawImage(
																	cx,cy,
																	cw,ch, ('assets/images/rating/icons/%s.png'):format( config.id ),
																	0, 0, 0, tocolor(255,255,255,255*alpha)
																)

																local startY = y + 160
																local rw,rh = 493, 63
																local padding = 10
																local startX = x+w/2 - rw/2

																local colors = {
																	tocolor( 230,90,90,255*alpha ),
																	tocolor( 180,70,70,255*alpha ),
																	tocolor( 140,50,50,255*alpha ),
																}

																for index = 1, 3 do

																	local player_data = element.rating.players[index] or { login = '', value = 0, place = 0 }

																	dxDrawRectangle(
																		startX, startY, rw,rh,
																		tocolor(25,24,38,255*alpha)
																	)

																	dxDrawRectangle(
																		startX+rw-193, startY, 193,rh,
																		tocolor(21,20,32,255*alpha)
																	)

																	local lw,lh = 55,55
																	local lx,ly = startX + 5, startY+rh/2-lh/2

																	dxDrawRectangle(
																		lx,ly,lw,lh,
																		colors[index]
																	)

																	dxDrawImage(
																		lx,ly,lw,lh, ('assets/images/rating/%s.png'):format( index ),
																		0, 0, 0, tocolor(255,255,255,255*alpha)
																	)

																	dxDrawText(player_data.login,
																		startX + 85, startY,
																		startX + 85, startY+rh,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																		'left', 'center'
																	)

																	dxDrawText(config.toString( player_data.value ),
																		startX + rw - 193, startY,
																		startX + rw, startY+rh,
																		tocolor(255,255,255,255*alpha),
																		0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																		'center', 'center'
																	)

																	startY = startY + padding + rh

																end

																local player_data = element.rating.local_data or { place = 0, value = 0 }

																dxDrawRectangle(
																	startX, startY, rw,rh,
																	tocolor(25,24,38,255*alpha)
																)

																dxDrawRectangle(
																	startX+rw-193, startY, 193,rh,
																	tocolor(21,20,32,255*alpha)
																)

																dxDrawText(('Ваше место - #cd4949%s#ffffff'):format( player_data.place ),
																	startX, startY,
																	startX + 300, startY+rh,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
																	'center', 'center', false, false, false, true
																)

																dxDrawText(config.toString( player_data.value ),
																	startX + rw - 193, startY,
																	startX + rw, startY+rh,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
																	'center', 'center'
																)

																dxDrawText('Нажмите для подробной информации',
																	x, y + h - 30,
																	x + w, y + h - 30,
																	tocolor(80,80,80,255*alpha),
																	0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
																	'center', 'bottom'
																)

															end,

															onClick = function(element)

																ratingList:openRatingInfo( element.rating.id )

															end,

														}
													)

													index = index + 1
													startX = startX + w + padding
													
												else
													break
												end

											end

											startY = startY + h + padding

										end

									end,

								},

								{'image',

									50, 0,
									1007, 590,
									color = {25,24,38,255},
									'assets/images/rating/rating_info_bg.png',

									variable = 'ratingInfo',

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData( element.animationAlpha, 0.1, 0 )
									end,

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shw,shh = 1047, 630

										dxDrawImage(
											x+w/2-shw/2, y+h/2-shh/2,
											shw,shh, 'assets/images/rating/rating_info_bg_shadow.png',
											0, 0, 0, tocolor(0, 0, 0, 255*alpha)
										)

									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local config = getRatingSection( element.rating_id )

										dxDrawText(config.name,
											x + 60, y + 50,
											x + 60, y + 50,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
											'left', 'top'
										)

										dxDrawText(config.title,
											x + 60, y + 90,
											x + 60, y + 90,
											tocolor(80,80,80,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
											'left', 'top'
										)

										local rw,rh = 421, 55
										element:drawRating( {
											data = element.data.local_data or {},
											place = (element.data.local_data or {}).place or 0,
											pos = { x+450, y+50 },
											is_local = true,
										} )

									end,

									drawRating = function(element, data)

										local alpha = element:alpha()

										local rw,rh = 421, 55
										local rx,ry = unpack( data.pos )

										local r1,g1,b1 = 25,24,38
										local r2,g2,b2 = 21,20,32

										if data.is_local then
											r1,g1,b1 = 21,20,32
											r2,g2,b2 = 16,16,18
										end

										local config = getRatingSection( element.rating_id )

										dxDrawRectangle(
											rx,ry,rw,rh, tocolor(r1,g1,b1,255*alpha)
										)

										dxDrawRectangle(
											rx+rw-195,ry,195,rh, tocolor(r2,g2,b2,255*alpha)
										)

										if data.place <= 3 and data.place > 0 then

											local colors = {
												tocolor( 230,90,90,255*alpha ),
												tocolor( 180,70,70,255*alpha ),
												tocolor( 140,50,50,255*alpha ),
											}

											local lw,lh = 45,45
											local lx,ly = rx + 8, ry+rh/2-lh/2

											dxDrawRectangle(
												lx,ly,lw,lh,
												colors[data.place]
											)

											dxDrawImage(
												lx,ly,lw,lh, ('assets/images/rating/%s.png'):format( data.place ),
												0, 0, 0, tocolor(255,255,255,255*alpha)
											)

											dxDrawText(data.data.login or '',
												rx + 80, ry,
												rx + 80, ry+rh,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
												'left', 'center'
											)

										else

											dxDrawText(('%s. %s'):format( data.place, data.data.login or '' ),
												rx + 30, ry,
												rx + 30, ry+rh,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
												'left', 'center'
											)

										end

										dxDrawText(config.toString( data.data.value or 0 ),
											rx+rw-195, ry,
											rx+rw, ry+rh,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
											'center', 'center'
										)


									end,

									elements = {

										{'button',

											function(s,p) return p[4] - s[4] - 60 end,
											56,
											35,35,
											bg = 'assets/images/close.png',
											activeBg = 'assets/images/close_active.png',
											define_from = '',

											'',

											color = {180, 70, 70, 255},
											activeColor = {200, 70, 70, 255},

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawImage(
													x,y,w,h, 'assets/images/close_icon.png',
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)

											end,

											onClick = function()
												animate( ratingList.animationAlpha, 1 )
												animate( ratingInfo.animationAlpha, 0 )
											end,

										},

										{'rectangle',
											'center', 150,
											900, 400,
											color = {24,23,34,255},

											elements = {
												{'element',
													'center', 'center',
													'100%', '90%',
													color = {255,255,255,255},
													overflow = 'vertical',

													scrollBgColor = {21,21,33},
													scrollWidth = 3,
													scrollXOffset = 10,

													onInit = function(element)

														local startY = 0
														local rowHeight = 60

														for index = 1, 15 do

															element:addElement(
																{'element',

																	0, startY,
																	'100%', rowHeight,
																	color = {255,255,255,255},

																	index = index,

																	onRender = function(element)

																		local x,y,w,h = element:abs()

																		local p_1 = ratingInfo.data.players[ element.index ]
																		local p_2 = ratingInfo.data.players[ element.index + 15 ]

																		ratingInfo:drawRating( {
																			data = p_1 or {},
																			place = element.index,
																			pos = { x+20, y+5 },
																		} )

																		ratingInfo:drawRating( {
																			data = p_2 or {},
																			place = element.index + 15,
																			pos = { x+460, y+5 },
																		} )

																	end,

																}
															)

															startY = startY + rowHeight

														end

													end,

												},
											},

										},

									},

								},

							},

						},

					},


				},


			},

		},

	},

}

------------------------------------------------------------------------


	GUIDefine('window-element', {

		[2]=0, [3]=124,
		[4]=sx, [5]=( real_sy - px(124) ) * sx/real_sx,
		color = {255,255,255,255},

		onInit = function(element)

			element.animationAlpha = element.__data.section .. '-anim'
			setAnimData(element.animationAlpha, 0.1, 0)

			if element.init then
				element:init()
			end

		end,

		onRender = function(element)

			local anim = getAnimData(element.animationAlpha)
			element[2] = 100*(1-anim)

		end,

	})

	GUIDefine('main-button', {

		[4] = 277, [5] = 63,
		[6] = '',
		bg = 'assets/images/mbtn.png',
		color = {18,18,28,255},
		activeColor = {28,28,38,255},

		scale = 0.5, 
		font = getFont('montserrat_semibold', 25, 'light'),

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 319/2, y + h/2 - 105/2, 319, 105

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/mbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			if element.animData > 0.01 then

				local texture = getDrawingTexture(element.bg)
				local gradient = getTextureGradient(texture, {
					color = {
						{ 180, 70, 70, 50 },
						{ 0, 0, 0, 0 },
					},
					alpha = alpha*element.animData,
					angle = -30+180*(1-element.animData),
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

			end

		end,

	})

	GUIDefine('main-button-sml', {

		[4] = 133, [5] = 63,
		[6] = '',
		bg = 'assets/images/sbtn_sml.png',
		color = {18,18,28,255},
		activeColor = {28,28,38,255},

		scale = 0.5, 
		font = getFont('montserrat_semibold', 23, 'light'),

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 175/2, y + h/2 - 105/2, 175, 105

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/sbtn_sml_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			if element.animData > 0.01 then

				local texture = getDrawingTexture(element.bg)
				local gradient = getTextureGradient(texture, {
					color = {
						{ 180, 70, 70, 50 },
						{ 0, 0, 0, 0 },
					},
					alpha = alpha*element.animData,
					angle = -30+180*(1-element.animData),
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

			end

		end,

	})

	GUIDefine('main-button-e', {

		[4] = 277, [5] = 63,

		bg = 'assets/images/mbtn_empty.png',
		activeBg = 'assets/images/mbtn.png',

		color = {180,70,70,255},

		scale = 0.5, 
		font = getFont('montserrat_semibold', 25, 'light'),

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 319/2, y + h/2 - 105/2, 319, 105

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/mbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)


		end,

	})

	GUIDefine('main-input', {

		[4] = 277, [5] = 63,
		bg = 'assets/images/mbtn.png',
		[6] = '',

		alignX = 'center',

		color = {18,18,28,255},
		placeholderColor = {100,100,100,255},

		scale = 0.5, 
		font = getFont('montserrat_medium', 25, 'light'),

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			dxDrawImage(
				x,y,w,h, 'assets/images/mbtn1.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha)
			)

		end,

	})

------------------------------------------------------------------------

	GUIDefine('settings-tab', {

		[4] = 304, [5] = 77,
		[6] = '',
		color = {255,255,255,255},

		onInit = function(element)
			element.a_anim = {}
			setAnimData(element.a_anim, 0.1)
		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			dxDrawImage(
				x,y,w,h, 'assets/images/settings_tab.png',
				0, 0, 0, tocolor(18,18,28,255*alpha)
			)

			local aw,ah = 348, 121
			local ax,ay = x+w/2-aw/2, y+h/2-ah/2


			local animData = getAnimData(element.a_anim)
			animate(element.a_anim, element.parent.tab == element.tab and 1 or 0)

			local tr,tg,tb = interpolateBetween(200,200,200, 255,255,255, animData, 'InOutQuad')

			dxDrawImage(
				ax,ay,aw,ah, 'assets/images/settings_tab_a.png',
				0, 0, 0, tocolor(180,70,70,255*alpha*animData)
			)
				
			local path = string.format('assets/images/icons/%s.png',
				element.tab.id
			)

			if fileExists(path) then

				local icon_size = element.icon_size or 40

				dxDrawImage(
					x + 30, y+h/2-icon_size/2, icon_size, icon_size,
					path, 0, 0, 0, tocolor(tr,tg,tb,255*alpha)
				)

			end

			dxDrawText(element.tab.name,
				x + 90, y,
				x + 90, y+h,
				tocolor(tr,tg,tb,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
				'left', 'center'
			)


		end,

		onClick = function(element)
			element.parent.tab = element.tab
		end,

	})

------------------------------------------------------------------------

	GUIDefine('section', {
		[2]='right', [3]=0,
		[4]=function(s,p) return p[4] - 330 end, [5]='100%',
		color = {255,255,255,255},

		noDraw = function(element)
			return element.parent.tab.id ~= element.section
		end,

	})

------------------------------------------------------------------------

	GUIDefine('packs-button', {

		[4] = 143, [5] = 46,

		bg = 'assets/images/pbtn_empty.png',
		activeBg = 'assets/images/pbtn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 23, 'light'),

		color = {180,70,70,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = unpack( element.shadowSize or {161,64} )

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/pbtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/pbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
			)


		end,

	})

------------------------------------------------------------------------

	GUIDefine('convert-input', {

		[4]=333, [5]=67,

		bg = 'assets/images/convert_input.png',
		[6] = '',

		alignX = 'center',

		color = {18,18,28,255},
		placeholderColor = {100,100,100,255},

		scale = 0.5, 
		font = getFont('montserrat_medium', 25, 'light'),

		onInit = function(element)

			element.h_anim = {}
			setAnimData(element.h_anim, 0.2, 0)

			if element.c_icon then
				element.alignX = 'left'
				element.textPadding = 20
			else
				element.alignX = 'center'
			end

			if element.init then
				element:init()
			end

		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local aw,ah = 351, 85
			local ax,ay = x+w/2-aw/2, y+h/2-ah/2

			local animData = getAnimData(element.h_anim)
			animate(element.h_anim, element.focused and 1 or 0)

			dxDrawImage(
				ax,ay,aw,ah, 'assets/images/convert_input_a.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
			)

			if element.c_icon then

				local iw,ih = 30,30
				local ix,iy = x+w - h/2 - iw/2, y+h/2-ih/2

				dxDrawImage(
					ix,iy,iw,ih, element.c_icon,
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				local rh = h*0.5

				mta_dxDrawRectangle(
					px(ix - 8), px(y+h/2-rh/2),
					1,px(rh), tocolor(100, 100, 100, 50*alpha)
				)

			end

		end,
		

	})

	GUIDefine('convert-button', {

		[4]=333, [5]=67,

		bg = 'assets/images/convert_input.png',

		color = {18,18,28,255},
		placeholderColor = {100,100,100,255},

		scale = 0.5, 
		font = getFont('montserrat_medium', 25, 'light'),


		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local aw,ah = 351, 85
			local ax,ay = x+w/2-aw/2, y+h/2-ah/2

			dxDrawImage(
				ax,ay,aw,ah, 'assets/images/convert_button_a.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,
		

	})

------------------------------------------------------------------------

	GUIDefine('shop-button', {

		[4] = 133, [5] = 46,

		bg = 'assets/images/sibtn_empty.png',
		activeBg = 'assets/images/sibtn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 23, 'light'),

		color = {180,70,70,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = unpack( element.shadowSize or {151,64} )

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/sibtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/sibtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
			)


		end,

	})

------------------------------------------------------------------------

	GUIDefine('ref-input', {

		[4]=333, [5]=67,

		image = 'ref_take_input',
		[6] = '',

		alignX = 'center',

		color = {18,18,28,255},
		placeholderColor = {100,100,100,255},

		scale = 0.5, 
		font = getFont('montserrat_medium', 25, 'light'),

		onInit = function(element)

			element.h_anim = {}
			setAnimData(element.h_anim, 0.2, 0)

			element.bg = string.format('assets/images/ref/%s.png', element.image)

			if element.c_icon then
				element.alignX = 'left'
				element.textPadding = 20
			else
				element.alignX = 'center'
			end

			element:addHandler('onRender', function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local aw,ah = unpack(element.active_size)
				local ax,ay = x+w/2-aw/2, y+h/2-ah/2

				local animData = getAnimData(element.h_anim)
				animate(element.h_anim, element.focused and 1 or 0)

				dxDrawImage(
					ax,ay,aw,ah, string.format('assets/images/ref/%s_a.png', element.image),
					0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
				)

			end)

		end,
		

	})

	GUIDefine('ref-button', {

		[4] = 215, [5] = 46,

		bg = 'assets/images/ref/rbtn_empty.png',
		activeBg = 'assets/images/ref/rbtn.png',

		scale = 0.5,
		font = getFont('montserrat_medium', 23, 'light'),

		color = {180,70,70,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = unpack( element.shadowSize or {233,64} )

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/ref/rbtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/ref/rbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
			)


		end,

	})

------------------------------------------------------------------------

	GUIDefine('layer', {

		[2] = 'center', [3] = 'center', 
		[4] = '100%', [5] = '100%', 

		show = function(element)
			animate(element.animationAlpha, 1)
		end,

		hide = function(element)
			animate(element.animationAlpha, 0)
		end,

		onInit = function(element)
			element.animationAlpha = {}
			setAnimData(element.animationAlpha, 0.1, element.hidden and 0 or 1)
		end,

	})

------------------------------------------------------------------------

	GUIDefine('report-button', {

		[4] = 218, [5] = 49,

		bg = 'assets/images/report/btn_empty.png',
		activeBg = 'assets/images/report/btn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 23, 'light'),

		color = {180,70,70,255},
		textColor = {200,200,200,255},
		activeTextColor = {255,255,255,255},

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = unpack( element.shadowSize or {264,95} )

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			if element.shadow ~= false then
				dxDrawImage(
					shx,shy,shw,shh, element.shadow or 'assets/images/report/btn_empty_shadow.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
				)
			end

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/report/btn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
			)


		end,

	})

	GUIDefine('report-nbutton', {

		[4] = 167, [5] = 46,

		bg = 'assets/images/report/nbtn_empty.png',
		activeBg = 'assets/images/report/nbtn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 22, 'light'),

		color = {180,70,70,255},
		textColor = {255,255,255,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = unpack( element.shadowSize or {185,64} )

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/report/nbtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/report/nbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(element.animData))
			)


		end,

	})

------------------------------------------------------------------------


loadGuiModule()

end)

