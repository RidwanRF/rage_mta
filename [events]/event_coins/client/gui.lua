loadstring( exports.interfacer:extend( "Interfacer" ) )( )
Extend( "CPlayer" )

openHandler = function()

end

closeHandler = function()
end

clearGuiTextures = false

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			953, 623, 
			'assets/images/bg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 979/2,
					y + h/2 - 649/2 + 5,
					979, 649, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			elements = {

				{'element',
					0, 'center',
					function(s,p) return p[4]-390 end, '100%',
					color = {255,255,255,255},

					elements = {

						{'image',

							50, 30,
							302, 79,
							'assets/images/account_bg.png',
							color = {21,21,33,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local iw,ih = 20,20

								-- dxDrawImage(
								-- 	x+w-iw-10, y+h-iw-10,
								-- 	iw,ih, 'assets/images/coin.png',
								-- 	0, 0, 0, tocolor(255,255,255,255*alpha)
								-- )

								dxDrawText('Ваш счёт',
									x,y+10,x+w,y+10,
									tocolor(57,53,77,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
									'center', 'top'
								)

								dxDrawText(splitWithPoints( (localPlayer:getData('event_coins.coins') or 0) + coinsFarm.queue, ' ' ),
									x,y+30,x+w,y+30,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
									'center', 'top'
								)

							end,

						},

						{'image',

							function(s,p) return p[4] - s[4] - 50 end, 30,
							154, 79,
							'assets/images/rewards_lbg.png',
							color = {21,21,33,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local iw,ih = 40,40

								dxDrawImage(
									x,y,w,h, 'assets/images/rewards_lbg_g.png',
									0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
								)

								dxDrawImage(
									x + 17, y+h/2-ih/2,
									iw,ih, 'assets/images/rewards_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

								dxDrawText('Награды',
									x+25+iw,y,x+25+iw,y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
									'left', 'center'
								)

							end,

							onClick = function(element)
								currentWindowSection = 'prizes'
							end,

						},

						{'image',
							'center', 130,
							485, 64,
							'assets/images/auto_bg_a.png',
							color = {40, 32, 68, 255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local bw,bh = 467, 45

								dxDrawImage(
									x+w/2-bw/2, y+h/2-bh/2,
									bw,bh, 'assets/images/auto_bg.png',
									0, 0, 0, tocolor(21,21,33,255*alpha)
								)

								local auto = getPlayerFarmAmount( localPlayer, 'passive' )

								dxDrawText(string.format('Автоматически #ffffff + %s#39354d / сек',
									auto
								),
									x + 30, y,
									x + 30, y+h,
									tocolor(57,53,77,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
									'left', 'center', false, false, false, true
								)

							end,

						},

						{'element',
							'center', 220,
							515, 0,
							color = {255,255,255,255},

							lastClick = getTickCount(),

							onInit = function(element)

								local w,h = 249, 80

								local startY = 0
								local padding = 10

								for i = 1,3 do

									for _, side in pairs({ { side = 'left', add = 0 }, { side = 'right', add = 3 } }) do

										element:addElement(
											{'image',

												side.side, startY,
												w,h,
												'assets/images/upgrade_bg_a.png',

												color = {38,30,62,255},

												upgrade_id = i+side.add,
												upgrade = Config.upgrades[i+side.add],

												onRender = function(element)

													local r,g,b = interpolateBetween(38,30,62, 180,70,70, element.animData, 'InOutQuad')
													element.color = {r,g,b, element.color[4]}

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local bw,bh = 234, 66

													local r,g,b = interpolateBetween(21,21,33, 15,15,20, element.animData, 'InOutQuad')

													local upgrades = localPlayer:getData('event_coins.upgrades') or {}

													dxDrawImage(
														x + w/2- bw/2, y+h/2-bh/2,
														bw,bh, 'assets/images/upgrade_bg.png',
														0, 0, 0, tocolor(21,21,33,255*alpha)
													)

													local r,g,b = unpack( element.upgrade.color )

													dxDrawImage(
														x + 10, y+h/2- 57/2,
														57,57, ('assets/images/upgrades/%s.png'):format( element.upgrade_id ),
														0, 0, 0, tocolor(r,g,b,255*alpha)
													)

													local pf = element.upgrade.farm_type == 'active' and 'клик' or 'сек'

													dxDrawText(element.upgrade.name .. (' #39354d+%s / %s'):format( element.upgrade.add, pf ),
														x + 65, y + 22,
														x + 65, y + 22,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
														'left', 'top', false, false, false, true
													)

													dxDrawText(('Всего +%s#39354d / %s'):format( (upgrades[element.upgrade_id] or 0) * element.upgrade.add, pf ),
														x + 65, y + 38,
														x + 65, y + 38,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
														'left', 'top', false, false, false, true
													)

													local count = upgrades[element.upgrade_id] or 0
													if count > 0 then

														dxDrawText('x'..count,
															x+w-10,y+h-10,
															x+w-10,y+h-10,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
															'right', 'bottom'

														)

													end

													if isMouseInPosition( x,y,w,h ) then
														element.hint = true
													end

												end,

												onPostRender = function(element)

													if not element.hint then return end

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local cx,cy = getCursorPosition()
													cx,cy = cx*sx + 10, cy*real_sy*sx/real_sx + 10

													local w,h = 344, 42

													dxDrawImage(
														cx,cy, w,h,
														'assets/images/hint_bg.png',
														0, 0, 0, tocolor(40, 35, 65, 255*alpha)
													)

													dxDrawText( ('Стоимость - #cd4949$%s#ffffff ( Максимум x%s )'):format(
														splitWithPoints( element.upgrade.cost, '.' ),
														element.upgrade.limit
													),
														cx + 20, cy,
														cx + 20, cy+h,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
														'left', 'center', false, false, false, true
													)

													element.hint = false

												end,

												onClick = function(element)

													-- if ( getTickCount() - element.parent.lastClick ) < 500 then return end
													-- element.parent.lastClick = getTickCount()

													triggerServerEvent('event_coins.buyUpgrade', resourceRoot, element.upgrade_id)

												end,

											}
										)

									end

									startY = startY + h + padding



								end

							end,

						},

						{'button',
							'center', 'bottom',
							334, 113,

							[6] = '',
							bg = 'assets/images/mbtn2.png',

							color = {180,70,70,255},

							scale = 0.5,
							font = getFont('montserrat_semibold', 27, 'light'),

							effects = {},

							onPreRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawImage(
									x + w/2 - 379/2, y + h - 140,
									379, 140, 'assets/images/mbtn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, ( 50 + 205*element.animData )*alpha)
								)

								dxDrawImage(
									x,y,w,h, 'assets/images/mbtn1.png',
									0, 0, 0, tocolor(30,24,35,255*alpha)
								)

								dxDrawText('Кликай!',
									x, y+55, x+w, y + 55,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 35, 'light'),
									'center', 'top'
								)

							end,

							onPostRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								for effect in pairs( element.effects ) do

									local ex,ey = unpack( effect.start_pos )
									local anim = getAnimData(effect.anim)
									local size = effect.size + 20 * anim

									ex = ex + (10 + effect.target_offset) * anim
									ey = ey - 200 * anim

									dxDrawImage(
										ex-size/2,ey-size/2,
										size, size, 'assets/images/coin.png',
										effect.angle * anim, 0, 0, tocolor( 255,255,255,255*(1-anim) )
									)

								end

							end,

							addEffect = function(element)

								local effect = {}

								effect.anim = {}
								effect.size = math.random(20, 40)
								effect.angle = math.random(70,110)

								local cx,cy = getCursorPosition()
								cx,cy = cx*sx, cy*real_sy*sx/real_sx

								effect.start_pos = { cx,cy }
								effect.target_offset = math.random( -10, 10 )

								setAnimData(effect.anim, 0.05, 0)
								animate(effect.anim, 1, function()
									removeAnimData(effect.anim)
									element.effects[effect] = nil
								end)

								element.effects[effect] = true

							end,

							queue = 0,
							variable = 'coinsFarm',

							lastClick = getTickCount(),

							onClick = function(element)

								if ( getTickCount() - element.lastClick ) < 100 then return end
								element.lastClick = getTickCount()

								element.queue = element.queue + getPlayerFarmAmount( localPlayer, 'active' )

								element:addEffect()

							end,

							handleFarm = function(element)

								if windowOpened and not coinsFarm.frozen and currentWindowSection == 'main' then

									if not coinsFarm.lastMouseMove or ( getTickCount() - coinsFarm.lastMouseMove ) < 15*1000 then


										local add = element.queue + getPlayerFarmAmount( localPlayer, 'passive' )

										if add > 0 then

											triggerServerEvent('event_coins.farmCoins', resourceRoot, add,
												md5( ('%s_%s_%s'):format(Config.farm_key, add, localPlayer.name) )
											)

											coinsFarm.frozen = true

										end

									else

										coinsFarm.need_captcha = true

									end


								end

							end,

							callCaptchaDialog = function(element)

								if element.need_captcha then

									local captcha = generateCaptcha()

									dialog_input('Проверка', {
										'Докажите что вы не робот',
									}, {
										{ type = 'text', name = '', params = { [6] = captcha, textColor = {180, 70, 70, 255}, noEdit = true, } },
										{ type = 'text', name = 'Введите символы', },
									}, function(data)

										if not data then return end

										if data[1] == data[2] then
											element.need_captcha = false
										else
											element:callCaptchaDialog()
										end

									end)

								end

							end,

							onRender = function(element)
								element:callCaptchaDialog(element)
							end,

							_=setTimer(function()
								coinsFarm:handleFarm()
							end, 1000, 0),

							_=addEvent('event_coins.receiveClientCoins', true),
							_=addEventHandler('event_coins.receiveClientCoins', resourceRoot, function(amount)

								coinsFarm.queue = 0
								coinsFarm.frozen = false
								localPlayer:setData('event_coins.coins', amount, false)

							end),

							_=addEventHandler('onClientCursorMove', root, function(dn, old, new)

								coinsFarm.lastMouseMove = getTickCount()

							end),

						},

					},

				},

				{'element',
					'right', 'center',
					390, '100%',
					color = {255,255,255,255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element.parent:abs()

						drawImageSection(
							x,y,w,h, element.parent[6],
							{ x = 390/w, y = 1 }, tocolor(23,22,35,255*alpha), 1
						)

					end,

					elements = {

						{'element',

							'center', 'bottom',
							390, 107,
							color = {255,255,255,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element.parent.parent:abs()

								drawImageSection(
									x,y,w,h, element.parent.parent[6],
									{ x = 390/w, y = 107/h }, tocolor(18,18,30,255*alpha), 1
								)

								local x,y,w,h = element:abs()

								local rw,rh = 70,70

								local padding = 40

								local sCount = #Config.seasons/2

								local startX = x+w/2 - sCount*rw - (sCount-0.5)*padding

								local c_season = getCurrentSeason()

								for id, season in pairs( Config.seasons ) do

									local r,g,b = 30,20,50
									local tr,tg,tb = 80,80,80

									if id == c_season then
										r,g,b = 180,70,70
										tr,tg,tb = 255,255,255
									end

									dxDrawImage(
										startX, y+h/2-rh/2, rw,rh,
										'assets/images/round.png', 0, 0, 0, 
										tocolor(r,g,b,255*alpha)
									)

									dxDrawText(season.start_at,
										startX, y+h - 27,
										startX + rw, y+h - 10,
										tocolor(60,60,60,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'center', 'top'
									)

									dxDrawText('Сезон',
										startX, y+h/2 - 31,
										startX + rw, y+h/2 - 31,
										tocolor(60,60,60,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
										'center', 'bottom'
									)

									dxDrawText(id,
										startX, y,
										startX + rw, y+h,
										tocolor(tr,tg,tb,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
										'center', 'center'
									)

									if id ~= #Config.seasons then

										local smw,smh = 20,20

										dxDrawImage(
											startX + rw + padding/2 - smw/2, y+h/2-smh/2, smw,smh,
											'assets/images/round.png', 0, 0, 0, 
											tocolor(r,g,b,255*alpha)
										)

									end

									startX = startX + rw + padding

								end

							end,

						},

						{'element',

							'center', function(s,p) return p[5] - 107 - s[5] - 20 end,
							332, 40,

							variable = 'tabsElement',

							tabs = {
								{ id = 'send', name = 'Отправить', icon = 'assets/images/star.png', },
								{ id = 'top', name = 'Рейтинг', icon = 'assets/images/send.png', handle = function()
									coinTops:update()
								end },
							},

							onInit = function(element)

								openHandlers.top = function()

									if tabsElement.tab.id == 'top' then
										coinTops:update()
									end

								end


								local w,h = 156, 40
								local padding = 20

								local sCount = #element.tabs/2

								local startX = 0

								for _, tab in pairs( element.tabs ) do

									element:addElement(
										{'image',
											startX, 'center',
											w,h,

											tab = tab,

											color = {120, 30, 30,255},
											'assets/images/menubtn.png',

											onInit = function(element)
												element.s_anim = {}
												setAnimData(element.s_anim, 0.1, 0)
											end,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												animate(element.s_anim, element.tab == element.parent.tab and 1 or 0)
												local anim = getAnimData(element.s_anim)

												local r,g,b = interpolateBetween(30,30,60, 180,70,70, anim, 'InOutQuad')
												element.color = {r,g,b, element.color[4]}

												local iw,ih = 20,20

												dxDrawImage(
													x + 20, y+h/2-ih/2,
													iw,ih, element.tab.icon,
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)

												dxDrawText(element.tab.name,
													x + 10, y, x + 10+w, y+h,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
													'center', 'center'
												)

											end,

											onClick = function(element)
												element.parent.tab = element.tab

												if element.tab.handle then
													element.tab:handle()
												end

											end,

											onPreRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local anim = getAnimData(element.s_anim)
												local r,g,b = interpolateBetween(30,30,60, 180,70,70, anim, 'InOutQuad')

												dxDrawImage(
													x + w/2 - 173/2,
													y + h/2 - 58/2,
													173, 58, 'assets/images/menubtn_shadow.png',
													0, 0, 0, tocolor(r,g,b,255*alpha*element.animData)
												)

											end,

										}
									)

									startX = startX + w + padding

								end

								element.tab = element.tabs[1]

							end,

						},

						{'element',
							'center',  'center', '100%', '100%',
							color = {255,255,255,255},

							noDraw = function(element)
								return tabsElement.tab.id ~= 'send'
							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText('Перевод RCoin',
									x+30, y+30,
									x+30, y+30,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
									'left', 'top'
								)

							end,

							elements = {

								{'input',

									'center', 210,
									292, 46,

									type = 'number',

									placeholder = 'Сумма',
									variable = 'sendSumInput',

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()
										
										local iw,ih = 20,20

										dxDrawImage(
											x+w-iw-10, y+h/2-ih/2,
											iw,ih, 'assets/images/coin.png',
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

										dxDrawText('ID вашего счета',
											x, y - 60,
											x+w, y - 60,
											tocolor(56,53,74, 255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
											'center', 'bottom'
										)

										dxDrawText(localPlayer:getData('event_coins.account_id') or '---',
											x, y - 63,
											x+w, y - 63,
											tocolor(255,255,255, 255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
											'center', 'top'
										)

									end,

								},

								{'input',

									'center', 270,
									292, 46,

									type = 'number',

									placeholder = 'ID получателя',
									variable = 'sendIdInput',

								},

								{'button',
									'center', 340,
									215, 46,
									color = {180,70,70,255},

									[6] = 'Перевести',

									bg = 'assets/images/sbtn_empty.png',
									activeBg = 'assets/images/sbtn.png',

									scale = 0.5,
									font = getFont('montserrat_medium', 25, 'light'),

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 233/2, y + h/2 - 64/2, 233, 64

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/sbtn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/sbtn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,

									onClick = function(element)

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

											animate(element.animationAlpha, 1)

											local receiver = tonumber( sendIdInput[6] ) or 0
											local sum = tonumber( sendSumInput[6] or '' ) or 0

											if receiver <= 0 or sum <= 0 then
												return localPlayer:ShowError( "Заполните все поля" )
											end

											triggerServerEvent('event_coins.sendAccountCoins', resourceRoot, receiver, sum)


										end )

									end,



								},

							},

						},

						{'element',
							'center',  'center', '100%', '100%',
							color = {255,255,255,255},

							noDraw = function(element)
								return tabsElement.tab.id ~= 'top'
							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText('Рейтинг игроков',
									x+30, y+30,
									x+30, y+30,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
									'left', 'top'
								)

							end,

							elements = {

								{'image',
									'center', 80,
									322,308,
									color = {20,20,30,255},
									'assets/images/top_bg.png',

									overflow = 'vertical',

									variable = 'coinTops',

									scrollXOffset = 10,

									update = function(element)

										for _, c_element in pairs( element.elements or {} ) do

											c_element:destroy()

										end

										element.elements = {}

										local startY = 0

										local h = 35
										local padding = 5

										local data = getPlayersTop()

										for index, row in pairs( data.top ) do

											element:addElement(
												{'rectangle',

													0, startY,
													'100%', h,
													color = index <= 3 and {180,70,70,255} or {16,16,22,255},

													row = row,
													index = index,

													onRender = function(element)

														local alpha = element:alpha()
														local x,y,w,h = element:abs()

														dxDrawText(('%s. %s | %s RCoin | %s ч.'):format(
															element.index, element.row.account,
															splitWithPoints( element.row.value, '.' ),
															element.row.level
														),
															x+20, y,
															x+20, y+h,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
															'left', 'center'
														)

													end,

												}
											)

											startY = startY + h + padding

										end


									end,


									onPostRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local places = getPlayersTop().places

										local localLogin = localPlayer:getData('unique.login')
										local localData = places[ localLogin ]

										if not localData then return end

										local rw,rh = w, 35
										local rx,ry = x, y+h

										dxDrawRectangle(
											rx,ry,rw,rh,
											tocolor(41,26,65,255*alpha)
										)

										dxDrawText(('%s. %s | %s RCoin | %s ч.'):format(
											localData.place, localLogin,
											splitWithPoints( localData.value, '.' ),
											localPlayer:getData('level') or 0
										),
											rx+20, ry,
											rx+20, ry+rh,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
											'left', 'center'
										)

										dxDrawText('Рейтинг обновляется каждые 5 минут',
											rx,ry+rh+5,
											rx+rw, ry+rh+5,
											tocolor(100,100,120,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
											'center', 'top'
										)

									end,

								},

							},

						},

					},

				},

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

	prizes = {



		{'image',
			'center', 'center',
			701, 737, 
			'assets/images/rbg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 727/2,
					y + h/2 - 753/2 + 5,
					727, 753, 'assets/images/rbg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + 30, y + 30,
					70, 70, 'assets/images/ricon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText('Награды за мероприятие',
					x + 110,y+30,x+110,y+100,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
					'left', 'center'
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

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 35

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

				{'element',
					'center', 130,
					493, 570,
					color = {255,255,255,255},

					overflow = 'vertical',

					scrollXOffset = 10,

					variable = 'prizesList',

					onInit = function(element)
						element:update()
					end,

					update = function(element)

						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						element.elements = {}

						local h = 60
						local padding = -3
						local startY = 5

						for index, prize in pairs( Config.prizes ) do

							element:addElement(
								{'element',

									'center', startY,
									'100%', h,
									color = {255,255,255,255},

									prize = prize,
									index = index,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										dxDrawImage(
											x,y,w,h, 'assets/images/rsel.png',
											0, 0, 0, tocolor(80,60,130,255*alpha*element.animData)
										)

										local sw,sh = 100, 43
										local smx,smy = x + 10, y+h/2-sh/2

										local bw,bh = 369, 43
										local bx,by = x + w - 10 - bw, y+h/2-bh/2

										local r,g,b = 21,21,33

										if element.index <= 3 then
											r,g,b = 180,70,70
										end

										dxDrawImage(
											smx,smy,
											sw,sh, 'assets/images/ri1.png',
											0, 0, 0, tocolor(r,g,b,255*alpha)
										)

										dxDrawImage(
											bx,by,
											bw,bh, 'assets/images/ri2.png',
											0, 0, 0, tocolor(21,21,33,255*alpha)
										)

										dxDrawText(element.index .. ' место',
											smx,smy,smx+sw,smy+sh,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'center'
										)

										local r,g,b = 255,255,255

										if element.index <= 3 then
											r,g,b = 180,70,70
										end

										dxDrawText(element.prize.prize,
											bx,by,bx+bw,by+bh,
											tocolor(r,g,b,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'center'
										)

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

------------------------------------------

	GUIDefine('input', {

		color = {22,22,34,255},
		placeholderColor = {56,53,74,255},

		bg = 'assets/images/input.png',
		[6] = '',

		alignX = 'center',

		scale = 0.5,
		font = getFont('montserrat_medium', 23, 'light'),

		onPostInit = function(element)

			element:addHandler('onRender', function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local r,g,b = 41,32,68

				if element.focused then
					r,g,b = 180,70,70
				end

				dxDrawImage(
					x,y,w,h, 'assets/images/input_a.png',
					0, 0, 0, tocolor(r,g,b, 255*alpha)
				)

			end)

		end,

	})

------------------------------------------

	function generateCaptcha()

		local allowed = {{48, 57}, {65, 90}, {97, 122}},

		math.randomseed(getTickCount()) 
		local str = ""
		for i = 1, 6 do
			local charlist = allowed[math.random(1, 3)]
			str = str..string.char(math.random(charlist[1], charlist[2]))
		end 

		return str

	end

------------------------------------------

loadGuiModule()


end)

