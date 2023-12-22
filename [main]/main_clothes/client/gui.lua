

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
	['p'] = true,
	['delete'] = true,
}

blurBackground = false
hideBackground = true

openHandler = function()

	showChat(false)
	setPreviewModel(localPlayer.model, false)

	startCamera()

end
closeHandler = function()

	showChat(true)
	destroyPreviewCase()

end


addEventHandler('onClientResourceStart', resourceRoot, function()


windowModel = {
	
	__basic = {

		{'image',
			mtaDraw = true,
			0, 0, real_sx, real_sy,
			color = {0, 0, 0, 255},
			'assets/images/bg_shadow.png',
			anim_fix = true,
			hover = false,

		},

	},

	main = {

		{'element',
			30, 'center',
			400, 645,
			color = {255,255,255,255},

			elements = {

				{'image',

					0, 'top',
					400, 536,

					[6]='assets/images/mbg.png',
					bg_shadow='assets/images/mbg_shadow.png',

					define_from = 'window',

					variable = 'skinsElement',

					onInit = function(element)

						element:addHandler('onRender', function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							dxDrawImage(
								x+20,y+10,100,100, 'assets/images/clothes.png',
								0, 0, 0, tocolor(255,255,255,255*alpha)
							)

							local px,py = unpack( Config.shops[ currentShopId or 1 ] )
							local town = getTown( px,py, true )

							dxDrawText('Магазин одежды',
								x + 20 + 100, y+10+100/2,
								x + 20 + 100, y+10+100/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'left', 'bottom'
							)

							dxDrawText(town,
								x + 20 + 100, y+10+100/2,
								x + 20 + 100, y+10+100/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
								'left', 'top'
							)

						end)

						element.tabs = {
							{ name = 'Магазин', id = 'shop' },
							{ name = 'Гардероб', id = 'wardrobe' },
						}

						local tabw,tabh = 120, 30
						local sCount = #element.tabs/2

						element.tab = element.tabs[1]

						local startY = 110
						local startX = element[4]/2-sCount*tabw

						for _, tab in pairs( element.tabs ) do

							element:addElement(
								{'element',

									startX, startY,
									tabw,tabh,
									color = {255,255,255,255},

									tab = tab,

									onInit = function(element)
										element.t_anim = {}
										setAnimData(element.t_anim, 0.2)
									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local animData = getAnimData(element.t_anim)
										animate(element.t_anim, element.tab == element.parent.tab and 1 or 0)

										local yAdd = -5*animData
										local tr,tg,tb = interpolateBetween( 200,200,200,255,255,255, animData, 'InOutQuad' )

										dxDrawText(element.tab.name,
											x,y+yAdd,
											x+w,y+h+yAdd,
											tocolor(tr,tg,tb,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
											'center', 'center'
										)

										dxDrawImage(
											x+w/2-63/2, y+13*animData,
											63,30, 'assets/images/tabs_line.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
										)

									end,

									onClick = function(element)
										element.parent.tab = element.tab
										clothesList:update()

									end,

								}
							)

							startX = startX + tabw

						end

					end,

					elements = {

						{'image',
							function(s,p) return p[4]-s[4]-60 + 100/2 - s[4]/2 end, function(s,p) return 10 + 100/2 - s[4]/2 end,
							50, 50,
							'assets/images/case.png',
							color = {255,255,255,255},

							onInit = function(element)
								element.y0 = element[3]
							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local r,g,b = interpolateBetween(255,255,255, 180, 70, 70, element.animData, 'InOutQuad')
								element.color = {r,g,b, element.color[4]}

								element[3] = element.y0 - 5*element.animData

							end,

							onClick = function(element)

								camera = {
									FOV = 30,
									centerOffset = 0.49998784065247,
									distance = 3.7,
									roll = 0,
									rotationHorizontal = -181.74986600876,
									rotationVertical = 0,
									targetPosition = Vector3(-0.010, 0.376, 999.093),
									yOffset = -0.7,
								}

								currentWindowSection = 'case_custom'
								createPreviewCase()

								currentPed:setData( 'custom_case.id', localPlayer:getData('custom_case.id') or 0 )


							end,

						},


						{'element',

							0, 160,
							'100%', 350,
							color = {255,255,255,255},

							overflow = 'vertical',
							variable = 'clothesList',

							scrollBgColor = {15,15,25,255},

							update = function(element)

								if element.ov_animId then
									setAnimData(element.ov_animId, 0.1, 0)
								end

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

								local section = element.parent.tab.id

								if section == 'shop' then

									local startY = 0

									local _clothes = table.copy(Config.clothes)

									table.sort(_clothes, function(a,b)

										local donate_a = a.donate and 1 or 0
										local donate_b = b.donate and 1 or 0

										if donate_a ~= donate_b then
											return donate_a > donate_b
										else
											return a.cost > b.cost
										end


									end)

									for _, clothes in pairs( _clothes ) do

										if not clothes.noSell then

											local itemH = 60
											if clothes.rarity then
												itemH = 70
											end

											element:addElement(
												{'element',

													0, startY,
													element[4], itemH,
													color = {255,255,255,255},

													clothes = clothes,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local rw,rh = element[4], 52

														local rx,ry = 0, y+h-rh

														dxDrawRectangle(
															rx,ry,rw,rh, tocolor(20,20,30,255*alpha)
														)

														dxDrawText(element.clothes.name,
															rx + 35, ry,
															rx + 35, ry+rh,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
															'left', 'center'
														)


														dxDrawText(string.format('%s  #3c3c55%s',
															splitWithPoints(element.clothes.cost, '.'),
															element.clothes.donate and 'R-Coin' or '$'
														),
															rx + rw - 40, ry,
															rx + rw - 40, ry+rh,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
															'right', 'center', false, false, false, true
														)

														if element.parent.clothes == element.clothes then

															dxDrawImage(
																rx+10,ry+rh/2-45/2,
																21,45, 'assets/images/skinsel.png',
																0, 0, 0, tocolor(180, 70, 70, 255*alpha)
															)

														end

														if element.clothes.rarity then

															local rarity_config = Config.rarity[element.clothes.rarity]

															local br,bg,bb = unpack(rarity_config.color)
															local tr,tg,tb = unpack(rarity_config.text_color)

															local dw,dh = 138,36
															local dx,dy = rx + 30, ry-dh/2

															dxDrawImage(
																dx,dy,dw,dh, 'assets/images/rarity_bg.png',
																0, 0, 0, tocolor(br,bg,bb,255*alpha)
															)

															dxDrawText(rarity_config.name,
																dx,dy,dx+dw,dy+dh,
																tocolor(tr,tg,tb,255*alpha),
																0.5,0.5, getFont('montserrat_semibold', 20, 'light'),
																'center', 'center'
															)

														end

													end,

													onClick = function(element)

														element.parent.clothes = element.clothes
														setPreviewModel(element.clothes.model)

													end,



												}
											)

											startY = startY + itemH

										end

									end

								elseif section == 'wardrobe' then

									local startY = 0
									local itemH = 60

									local wardrobe = localPlayer:getData('wardrobe') or {}
									local wardrobe_slots = localPlayer:getData('clothes.extended') or 0

									local free_slots = ( Config.defaultLotsCount + wardrobe_slots ) - getTableLength(wardrobe)

									local wardrobe_tbl = {}

									for model, time in pairs( wardrobe ) do
										table.insert(wardrobe_tbl, {
											model = model,
											time = time,
											name = Config.clothesAssoc[model] and Config.clothesAssoc[model].name or ('Модель '..model),
										})
									end

									table.insert(wardrobe_tbl, {
										model = localPlayer.model,
										time = 0,
										name = Config.clothesAssoc[localPlayer.model] and Config.clothesAssoc[localPlayer.model].name or
											('Модель '..localPlayer.model),
									})

									table.sort(wardrobe_tbl, function(a,b)
										return a.time < b.time
									end)

									for _, clothes in pairs( wardrobe_tbl ) do

										element:addElement(
											{'element',

												0, startY,
												element[4], itemH,
												color = {255,255,255,255},

												clothes = clothes,

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local rw,rh = element[4], 52

													local rx,ry = 0, y+h/2-rh/2

													dxDrawRectangle(
														rx,ry,rw,rh, tocolor(20,20,30,255*alpha)
													)

													local isWeared = ''
													if localPlayer.model == element.clothes.model then
														isWeared = '#3c3c55 Надето'
													end

													dxDrawText(string.format('%s%s', element.clothes.name, isWeared),
														rx + 35, ry,
														rx + 35, ry+rh,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'left', 'center', false, false, false, true
													)

													if element.parent.clothes == element.clothes then

														dxDrawImage(
															rx+10,ry+rh/2-45/2,
															21,45, 'assets/images/skinsel.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha)
														)

													end

												end,

												onClick = function(element)

													element.parent.clothes = element.clothes
													setPreviewModel(element.clothes.model)

												end,


												elements = {

													{'button',
														function(s,p) return p[4] - s[4] - p[5]/2 end, 'center',
														30, 30,

														define_from = false,
														[6] = '',

														gOnPreRender = function(element)

															local x,y,w,h = element:abs(true)
															if isMouseInPosition(x,y,w,h) and handleClick then
																element:onClick()
																handleClick = false
															end

														end,

														onRender = function(element)

															local x,y,w,h = element:abs()
															local alpha = element:alpha()

															dxDrawText('+',
																x,y,x+w,y+h,
																tocolor(120,120,170,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
																'center', 'center', false, false, false, true, false, 45
															)


														end,

														onInit = function(element)
															element.animationAlpha = {}
															setAnimData(element.animationAlpha, 0.1, 1)
														end,

														onClick = function(element)

															dialog('Гардероб', {
																'Вы действительно хотите удалить',
																string.format('скин за #cd4949«%s»#ffffff?',
																	element.parent.clothes.name
																),
															}, function(result)

																if result then

																	local x,y,w,h = element:abs(true)

																	animate(element.animationAlpha, 0)
																	displayLoading( {x+w/2-25/2, y+h/2-25/2, 25, 25}, {180,70,70,255}, 1000, function()

																		animate(element.animationAlpha, 1)

																		triggerServerEvent('clothes.wardrobe.remove', resourceRoot, element.parent.clothes.model)


																	end )


																end

															end)

														end,

													},

												},


											}
										)

										startY = startY + itemH

									end

									if free_slots > 0 then

										element:addElement(
											{'element',

												0, startY,
												element[4], itemH,
												color = {255,255,255,255},

												free_slots = free_slots,

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local rw,rh = element[4], 52

													local rx,ry = 0, y+h/2-rh/2

													dxDrawRectangle(
														rx,ry,rw,rh, tocolor(20,20,30,255*alpha)
													)

													dxDrawText('Свободных мест в гардеробе: ' .. element.free_slots,
														rx + 35, ry,
														rx + 35, ry+rh,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'left', 'center'
													)

												end,

											}
										)

										startY = startY + itemH

									end

									element:addElement(
										{'element',

											0, startY,
											element[4], itemH,
											color = {255,255,255,255},

											onRender = function(element)

												local x,y,w,h = element:abs()
												local alpha = element:alpha()

												local rw,rh = element[4], 52

												local rx,ry = 0, y+h/2-rh/2

												dxDrawRectangle(
													rx,ry,rw,rh, tocolor(20,20,30,255*alpha)
												)

												dxDrawText('Расширить гардероб',
													rx + 35, ry,
													rx + 35, ry+rh,
													tocolor(60,60,85,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
													'left', 'center'
												)

											end,

											elements = {

												{'button',
													function(s,p) return p[4] - s[4] - p[5]/2 end, 'center',
													define_from = 'extend-button',
													[6] = '',

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														drawSmartText(string.format('<img>assets/images/donate.png</img> %s',
															Config.extendWardrobeCost
														),
															x, x+w, y+h/2, 
															tocolor(255,255,255,255*alpha),
															tocolor(255,255,255,255*alpha),
															0.5, getFont('montserrat_semibold', 23, 'light'),
															'center', 20, 5
														)

													end,

													onInit = function(element)
														element.animationAlpha = {}
														setAnimData(element.animationAlpha, 0.1, 1)
													end,

													onClick = function(element)

														dialog('Гардероб', {
															'Вы действительно хотите расширить',
															string.format('гардероб за %s #cd4949R-Coin#ffffff?',
																Config.extendWardrobeCost
															),
														}, function(result)

															if result then

																local x,y,w,h = element:abs(true)

																animate(element.animationAlpha, 0)
																displayLoading( {x+w/2-25/2, y+h/2-25/2, 25, 25}, {180,70,70,255}, 1000, function()

																	animate(element.animationAlpha, 1)

																	triggerServerEvent('clothes.wardrobe.extend', resourceRoot)


																end )


															end

														end)

													end,

												},

											},



										}
									)

									setPreviewModel(localPlayer.model, false)

								end

							end,

							addEventHandler('onClientElementDataChange', localPlayer, function(dn)

								if skinsElement.tab.id == 'wardrobe' and (
									dn == 'wardrobe'
									or dn == 'clothes.extended'
								) then
									clothesList:update()
								end

							end),

							onInit = function(element)
								element:update()
							end,


						},


					},

				},

				{'image',

					0, 'bottom',
					400, 93,

					[6]='assets/images/pbg.png',
					bg_shadow='assets/images/pbg_shadow.png',

					define_from = 'window',

					elements = {

						{'element',

							'center', 'center',
							345,46,
							color = {255,255,255,255},

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							elements = {

								{'button',

									'left', 'center',
									[6] = 'Приобрести',

									onRender = function(element)

										if skinsElement.tab.id == 'shop' then
											element[6] = 'Приобрести'
										else

											if clothesList.clothes and clothesList.clothes.model == localPlayer.model then
												element[6] = 'Надето'
											else
												element[6] = 'Надеть'
											end

										end

									end,

									onClick = function(element)

										if not clothesList.clothes then
											return exports.hud_notify:notify('Ошибка', 'Выберите одежду')
										end

										if skinsElement.tab.id == 'shop' then

											dialog('Покупка', {
												'Вы действительно хотите купить',
												string.format('скин #cd4949«%s»#ffffff за %s #cd4949%s#ffffff?',
													clothesList.clothes.name,
													splitWithPoints(clothesList.clothes.cost, '.'),
													clothesList.clothes.donate and 'R-Coin' or '$'
												),
											}, function(result)

												if result then


													local x,y,w,h = element.parent:abs()

													animate(element.parent.animationAlpha, 0)
													displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1000, function()

														animate(element.parent.animationAlpha, 1)

														triggerServerEvent('clothes.buy', resourceRoot, clothesList.clothes.model)


													end )


												end

											end)

										else

											if clothesList.clothes and clothesList.clothes.model == localPlayer.model then
												return
											end

											local x,y,w,h = element.parent:abs()

											animate(element.parent.animationAlpha, 0)
											displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1000, function()

												animate(element.parent.animationAlpha, 1)

												triggerServerEvent('clothes.wardrobe.wear', resourceRoot, clothesList.clothes.model)


											end )

										end


									end,

								},

								{'button',

									'right', 'center',
									[6] = 'Выход',

									onClick = function()
										closeWindow()
										exitShop()
									end,

								},

							},

						},

					},


				},

			},

		},
	
	},

	case_custom = {

		{'element',
			30, 'center',
			400, 645,
			color = {255,255,255,255},

			elements = {

				{'image',

					0, 'top',
					400, 536,

					[6]='assets/images/mbg.png',
					bg_shadow='assets/images/mbg_shadow.png',

					define_from = 'window',

					variable = 'casesElement',

					onInit = function(element)

						element:addHandler('onRender', function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							dxDrawImage(
								x+40,y+30,60,60, 'assets/images/case.png',
								0, 0, 0, tocolor(255,255,255,255*alpha)
							)

							local px,py = unpack( Config.shops[ currentShopId or 1 ] )
							local town = getTown( px,py, true )

							dxDrawText('Кейс выдается в инвентарь,',
								x + 20 + 100, y+10+100/2,
								x + 20 + 100, y+10+100/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'left', 'bottom'
							)

							dxDrawText('Если наличных более $1млн',
								x + 20 + 100, y+10+100/2,
								x + 20 + 100, y+10+100/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
								'left', 'top'
							)

						end)

					end,

					elements = {

						{'element',

							0, 100,
							'100%', 430,
							color = {255,255,255,255},

							overflow = 'vertical',
							variable = 'casesList',

							scrollBgColor = {15,15,25,255},

							update = function(element)

								if element.ov_animId then
									setAnimData(element.ov_animId, 0.1, 0)
								end

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

								local startY = 0

								local _cases = table.copy(Config.case_custom)

								table.sort(_cases, function(a,b)

									local donate_a = a.donate and 1 or 0
									local donate_b = b.donate and 1 or 0

									if donate_a ~= donate_b then
										return donate_a > donate_b
									else
										return a.cost > b.cost
									end


								end)

								table.insert(_cases, 1, {

									name = 'Стандартный кейс',
									cost = 0,
									valute = 'money',
									index = 0,

								})

								element.cases = _cases

								local c_case = localPlayer:getData('custom_case.id')

								for _, case in pairs( _cases ) do

									if not case.noSell then

										if c_case == case.index then
											element.case = case
										end

										local itemH = 60

										element:addElement(
											{'element',

												0, startY,
												element[4], itemH,
												color = {255,255,255,255},

												case = case,

												onRender = function(element)

													local x,y,w,h = element:abs()
													local alpha = element:alpha()

													local rw,rh = element[4], 52

													local rx,ry = 0, y+h-rh

													dxDrawRectangle(
														rx,ry,rw,rh, tocolor(20,20,30,255*alpha)
													)

													dxDrawText(element.case.name,
														rx + 35, ry,
														rx + 35, ry+rh,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'left', 'center'
													)


													dxDrawText(string.format('%s  #3c3c55%s',
														splitWithPoints(element.case.cost, '.'),
														element.case.valute == 'bank.donate' and 'R-Coin' or '$'
													),
														rx + rw - 40, ry,
														rx + rw - 40, ry+rh,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'right', 'center', false, false, false, true
													)

													if element.parent.case == element.case then

														dxDrawImage(
															rx+10,ry+rh/2-45/2,
															21,45, 'assets/images/skinsel.png',
															0, 0, 0, tocolor(180, 70, 70, 255*alpha)
														)

													end

												end,

												onClick = function(element)

													element.parent.case = element.case
													currentPed:setData('custom_case.id', element.case.index)

												end,



											}
										)

										startY = startY + itemH

									end

								end

							end,

							addEventHandler('onClientElementDataChange', localPlayer, function(dn)

								if (
									dn:find('custom_case')
								) then
									casesList:update()
								end

							end),

							onInit = function(element)
								element:update()
							end,


						},


					},

				},

				{'image',

					0, 'bottom',
					400, 93,

					[6]='assets/images/pbg.png',
					bg_shadow='assets/images/pbg_shadow.png',

					define_from = 'window',

					elements = {

						{'element',

							'center', 'center',
							345,46,
							color = {255,255,255,255},

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							elements = {

								{'button',

									'left', 'center',
									[6] = 'Приобрести',

									onRender = function(element)

										local saved = localPlayer:getData('custom_case.saved') or {}

										if casesList.case and localPlayer:getData('custom_case.id') == casesList.case.index then
											element[6] = 'Установлено'
										elseif casesList.case and (saved[casesList.case.index] or casesList.case.index == 0) then
											element[6] = 'Установить'
										else
											element[6] = 'Купить'
										end

									end,

									onClick = function(element)


										if not casesList.case then
											return exports.hud_notify:notify('Ошибка', 'Выберите стиль кейса')
										end

										if casesList.case and casesList.case.index == localPlayer:getData('custom_case.id') then
											return
										end

										local x,y,w,h = element.parent:abs()

										animate(element.parent.animationAlpha, 0)
										displayLoading( {x+w/2-50/2, y+h/2-50/2, 50, 50}, {180,70,70,255}, 1000, function()

											animate(element.parent.animationAlpha, 1)

											triggerServerEvent('clothes.case.set', resourceRoot, casesList.case.index)


										end )


									end,

								},

								{'button',

									'right', 'center',
									[6] = 'Назад',

									onClick = function()

										currentWindowSection = 'main'
										destroyPreviewCase()

										camera = {
										    FOV = 30,
										    centerOffset = 0.49998784065247,
										    distance = 3.7,
										    roll = 0,
										    rotationHorizontal = -72.791554927826,
										    rotationVertical = 1.4814352989197,
										    targetPosition = Vector3(0,0,0),
										    yOffset = 0,
										}

									end,

								},

							},


						},

					},


				},

			},

		},

	},

}


------------------------------------------------------------------------------

	GUIDefine('window', {
	
		color = {25,24,38,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local gradient = getTextureGradient( getDrawingTexture(element[6]) , {
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

		end,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = w+26,h+26
			local shx,shy = x+w/2-shw/2,y+h/2-shh/2+5

			dxDrawImage(
				shx,shy,shw,shh, element.bg_shadow,
				0, 0, 0, tocolor(0, 0, 0,255*alpha)
			)

		end,

	})

------------------------------------------------------------------------------

	GUIDefine('button', {

		[4]=167, [5]=46,
		bg = 'assets/images/pbtn_empty.png',
		activeBg = 'assets/images/pbtn.png',

		color = {180, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_semibold', 22, 'light'),

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 184/2, y + h/2 - 64/2, 184, 64

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/pbtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/pbtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

	})

	GUIDefine('extend-button', {

		[4]=78, [5]=30,
		bg = 'assets/images/ebtn_empty.png',
		activeBg = 'assets/images/ebtn.png',

		color = {180, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_semibold', 22, 'light'),

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 98/2, y + h/2 - 50/2, 98, 50

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/ebtn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/ebtn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

	})

------------------------------------------------------------------------------


loadGuiModule()

end)

