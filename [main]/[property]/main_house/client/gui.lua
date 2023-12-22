
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
}


openHandler = function()

	if currentWindowSection ~= 'creation' then
		clearAllInputs()
	end

	if currentWindowSection == 'key_dialog' then
		showCursor(false)
	end

	-- showChat(false)
end
closeHandler = function()
	-- showChat(true)
end


addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	enter_free = {

		{'image',

			'center', 'center',
			444, 327,
			color = {32,35,66,255},
			'assets/images/bg1.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 462/2,
					y + h/2 - 345/2 + 5,
					462, 345, 'assets/images/bg1_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local tx,ty,tw,th = x+w/2-244/2, y+10, 244,82

				dxDrawImage(
					tx,ty,tw,th, 'assets/images/title_bg.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				dxDrawText(currentHouseData.flat and 'Квартира' or 'Свободный дом',
					tx,ty,tx+tw,ty+th,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'center'
				)

				local rows = {
					{ name = 'Владелец:', value = currentHouseData.owner == '' and 'Отсутствует' or currentHouseData.owner, },
					{ name = 'Цена:', value = splitWithPoints( currentHouseData.cost or 0, '.' ) .. (
						(currentHouseData.donate == 1) and ' R-Coin' or ' $'
					), },
					{ name = 'Парковочные места:', value = currentHouseData.lots or 0, },
				}

				local rw,rh = 353, 34

				local startY = y + 100
				local startX = x+w/2 - rw/2

				for _, row in pairs( rows ) do

					dxDrawImage(
						startX, startY, rw,rh,
						'assets/images/row_bg1.png', 0, 0, 0, tocolor(37,42,74,255*alpha)
					)

					dxDrawText(row.name,
						startX + 20, startY,
						startX + 20, startY+rh,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'left', 'center'
					)

					dxDrawText(row.value,
						startX + rw - 20, startY,
						startX + rw - 20, startY+rh,
						tocolor(180,70,70,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'right', 'center'
					)

					startY = startY + rh + 5

				end

			end,

			elements = {

				{'element',
					'center', 'bottom',
					355, 85,
					color = {255,255,255,255},

					elements = {

						{'button',
							'left', 'top',
							171, 57,
							'Закрыть',

							bg = 'assets/images/btn1_empty.png',
							activeBg = 'assets/images/btn1.png',

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = closeWindow,

						},

						{'button',
							'right', 'top',
							171, 57,
							'Купить',

							bg = 'assets/images/btn1_empty.png',
							activeBg = 'assets/images/btn1.png',

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local captcha = generateCaptcha()

								local cost = currentHouseData.cost
								local money = currentHouseData.donate == 1
									and (localPlayer:getData('bank.donate') or 0)
									or exports['money']:getPlayerMoney(localPlayer)

								if money < cost then
									return exports['hud_notify']:notify('Ошибка', 'Недостаточно денег', 3000)
								end


								dialog_input('Покупка', {
									'Введите символы в поле ввода',
								}, {
									{ type = 'text', name = '', params = { [6] = captcha, textColor = {180, 70, 70, 255}, noEdit = true, } },
									{ type = 'text', name = 'Введите символы', },
								}, function(data)

									if not data then return end

									if data[1] == data[2] then

										dialog_input('Придумайте ключ', {
											'Ключ будет использоваться',
											'для входа',
										}, {
											{type = 'text', name = 'Введите ключ'},
										}, function(data)

											if data then

												triggerServerEvent('house.buy', resourceRoot, currentHouseData.id, data[1])
												closeWindow()

											else

												currentWindowSection = 'enter_free'

											end


										end)

									else
										exports.hud_notify:notify('Ошибка', 'Вы не прошли проверку')
									end

								end)


							end,

						},

					},

				},

			},

		},

	},

	enter_bought = {

		{'image',

			'center', 'center',
			444, 327,
			color = {32,35,66,255},
			'assets/images/bg1.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 462/2,
					y + h/2 - 345/2 + 5,
					462, 345, 'assets/images/bg1_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local tx,ty,tw,th = x+w/2-244/2, y+10, 244,82

				dxDrawImage(
					tx,ty,tw,th, 'assets/images/title_bg.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				dxDrawText(currentHouseData.flat and 'Квартира' or 'Занятый дом',
					tx,ty,tx+tw,ty+th,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'center'
				)

				local rows = {
					{ name = 'Владелец:', value = currentHouseData.owner == '' and 'Отсутствует' or currentHouseData.owner, },
					{ name = 'Цена:', value = splitWithPoints( currentHouseData.cost or 0, '.' ) .. (
						(currentHouseData.donate == 1) and ' R-Coin' or ' $'
					), },
					{ name = 'Парковочные места:', value = currentHouseData.lots or 0, },
				}

				local rw,rh = 353, 34

				local startY = y + 100
				local startX = x+w/2 - rw/2

				for _, row in pairs( rows ) do

					dxDrawImage(
						startX, startY, rw,rh,
						'assets/images/row_bg1.png', 0, 0, 0, tocolor(37,42,74,255*alpha)
					)

					dxDrawText(row.name,
						startX + 20, startY,
						startX + 20, startY+rh,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'left', 'center'
					)

					dxDrawText(row.value,
						startX + rw - 20, startY,
						startX + rw - 20, startY+rh,
						tocolor(180,70,70,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'right', 'center'
					)

					startY = startY + rh + 5

				end

			end,

			elements = {

				{'element',
					'center', 'bottom',
					355, 85,
					color = {255,255,255,255},

					elements = {

						{'button',
							'left', 'top',
							171, 57,
							'Закрыть',

							bg = 'assets/images/btn1_empty.png',
							activeBg = 'assets/images/btn1.png',

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = closeWindow,

						},

						{'button',
							'right', 'top',
							171, 57,
							'Войти',

							bg = 'assets/images/btn1_empty.png',
							activeBg = 'assets/images/btn1.png',

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn1_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								dialog_input('Придумайте ключ', {
									'Ключ будет использоваться',
									'для входа',
								}, {
									{type = 'text', name = 'Введите ключ'},
								}, function(data)

									if data then

										if data[1] == currentHouseData.key then
											triggerServerEvent('house.enter', resourceRoot, currentHouseData.id)
											closeWindow()
										else
											exports.hud_notify:notify('Ошибка', 'Неверный ключ')
										end

									end


								end)


							end,

						},

					},

				},

			},

		},

	},

	main = {

		{'image',

			'center', 'center',
			634, 366,
			color = {32,35,66,255},
			'assets/images/mbg.png',

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Меню недвижимости',
					x + 55, y + 40,
					x + 55, y + 40,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'left', 'top'
				)

				dxDrawImage(
					x + 45, y + 60,
					58, 22,
					'assets/images/hline.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				local rows = {
					{ name = 'Владелец:', value = currentHouseData.owner == '' and 'Отсутствует' or currentHouseData.owner, },
					{ name = 'Цена:', value = splitWithPoints( currentHouseData.cost or 0, '.' ) .. (
						(currentHouseData.donate == 1) and ' R-Coin' or ' $'
					), },
					{ name = 'Парковочные места:', value = currentHouseData.lots or 0, },
					{ name = 'ID недвижимости:', value = currentHouseData.id or 0, },
				}

				local rw,rh = 353, 34

				local startY = y + 100
				local startX = x + 45

				for _, row in pairs( rows ) do

					dxDrawImage(
						startX, startY, rw,rh,
						'assets/images/mrow.png', 0, 0, 0, tocolor(37,42,74,255*alpha)
					)

					dxDrawText(row.name,
						startX + 20, startY,
						startX + 20, startY+rh,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'left', 'center'
					)

					dxDrawText(row.value,
						startX + rw - 20, startY,
						startX + rw - 20, startY+rh,
						tocolor(180,70,70,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'right', 'center'
					)

					startY = startY + rh + 7

				end


			end,

			elements = {

				{'button',
					70, 366-40-40,
					184, 40,
					'Выйти',

					bg = 'assets/images/mbtn_empty.png',
					activeBg = 'assets/images/mbtn.png',

					scale = 0.5,
					font = getFont('montserrat_semibold', 25, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onPreRender = function(element)

						local alpha = element:alpha()

						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 202/2, y + h/2 - 57/2, 202, 57

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/mbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = closeWindow,

				},

				{'element',
					634-184-30, 0,
					184, 0,
					color = {255,255,255,255},

					onInit = function(element)

						local actions = {
							{ name = 'Войти', action = function(element)

								triggerServerEvent('house.enter', resourceRoot, currentHouseData.id)
								closeWindow()

							end },
							{ name = 'Сменить ключ', action = function(element)

								dialog_input('Смена ключа', {
									'Ключ будет использоваться',
									'для входа в дом',
								}, {
									{type = 'text', name = 'Введите ключ'},
								}, function(data)

									if data then

										triggerServerEvent('house.changeKey', resourceRoot, currentHouseData.id, data[1])

									end


								end)


							end },
							{ name = 'Продать государству', action = function(element)

								dialog('Продажа', {
									'Вы действительно хотите продать',	
									string.format('за %s $?',
										splitWithPoints( (

											(currentHouseData.donate == 1) and (
												currentHouseData.cost * Config.sellMul * Config.donateConvertMul
											) or ( currentHouseData.cost * Config.sellMul )

										), '.' )
									),	
								}, function(result)

									if result then
										triggerServerEvent('house.sell', resourceRoot, currentHouseData.id)
										closeWindow()
									end

								end)


							end },
							{ name = 'Продать игроку', action = function(element)

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

										triggerServerEvent('house.sellPlayer', resourceRoot, currentHouseData.id, data[2], data[1])
										closeWindow()

									end


								end)

							end },
							{ name = 'Купить парк. места', action = function(element)

								if currentHouseData.flat then
									return exports.hud_notify:notify('Ошибка', 'Недоступно в квартире')
								end

								local index = ( currentHouseData.lots - currentHouseData.default_lots ) + 1

								local rub, donate = Config.lotsExtend.rub[index], Config.lotsExtend.donate[index]
								rub = rub or Config.lotsExtend.rub[ #Config.lotsExtend.rub ]
								donate = donate or Config.lotsExtend.donate[ #Config.lotsExtend.donate ]

								dialog_input('Расширение слотов', {
									'Выберите тип оплаты',
								}, {
									{type = 'select', name = 'Выберите оплату', params = {
										selectElements = {
											{ name = string.format('%s $', splitWithPoints(rub, '.')), data = 'rub' },
											{ name = string.format('%s R-Coin', donate), data = 'donate' },
										},
									}},
								}, function(data)

									if data then

										triggerServerEvent('house.extendParks', resourceRoot, currentHouseData.id, data[1])

									end


								end)


							end },
						}

						local bw,bh = 184, 40
						local padding = 10

						local sCount = #actions/2

						local startX = 0
						local totalH = ( bh*sCount + padding*(sCount-0.5) ) * 2

						element[5] = totalH
						element[3] = element.parent[5]/2 - totalH/2

						local startY = 0

						for _, action in pairs(actions) do

							element:addElement(
								{'button',
									startX, startY,
									bw,bh, 

									action.name,

									bg = 'assets/images/mbtn_empty.png',
									activeBg = 'assets/images/mbtn.png',

									scale = 0.5,
									font = getFont('montserrat_semibold', 20, 'light'),

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onPreRender = function(element)

										local alpha = element:alpha()

										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 202/2, y + h/2 - 57/2, 202, 57

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/mbtn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onClick = action.action,

								}
							)

							startY = startY + bh + padding

						end

					end,

				},

			},

		},

	},

	creation = {
		{'rectangle',
			sx/2 - 300, sy/2 - 300,
			600, 600,
			color = {25,25,25,255},
		},

		{'button', 
			sx/2 + 300 - 70, sy/2 - 300 + 20,
			50, 50,
			'',
			bg = closeTexture,
			color = {255,255,255,255},
			font = 'default',
			scale = 1,
			shadowRadius = 0,
			onClick = function(element)
				closeWindow()
			end,
		},

		{'input',
			sx/2 - 300 + 20, sy/2 - 300 + 20,
			250, 50,
			'',

			placeholder = 'Парковочные места',

			onInit = function(element)
				createLots = element
			end,

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
		},

		{'input',
			sx/2 - 300 + 20, sy/2 - 300 + 80,
			250, 50,
			'',

			placeholder = 'Стоимость',

			onInit = function(element)
				createCost = element
			end,

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
		},

		{'rectangle',
			sx/2 - 300 + 20, sy/2 - 300 + 140,
			50, 50,
			color = {0,0,0,255},


			onInit = function(element)
				createDonate = element
			end,

			onRender = function(element)
				local alpha = getElementDrawAlpha(element)

				local r,g,b = 0,0,0
				if element.selected then
					r,g,b = 255,255,255
				end

				element.color = {r,g,b, element.color[4]}

				dxDrawText('Донатный',
					element[2] + element[4] + 10,
					element[3],
					element[2] + element[4] + 10,
					element[3] + element[5],
					tocolor(255,255,255,255*alpha),
					13/14, 13/14, getFont('proximanova_bold', 14, 'bold'),
					'left', 'center'
				)

			end,

			onClick = function(element)
				element.selected = not element.selected
			end,

		},

		{'list',
			sx/2 - 300 + 280,
			sy/2 - 300 + 20,
			300, 300,
			scrollBg = 'assets/images/scroll.png',
			scrollColor = {14, 108, 196,255},
			scrollBgColor = {25, 25, 25,255},
			scrollWidth = 5,
			listOffset = 0,
			listElements = {

			},
			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
			listElementHeight = 30,

			color = {255,255,255,255},
			activeColor = {255,0,0,255},

			onInit = function(element)
				interiorsList = element

				local list = {}

				table.insert(list, {text = 'Выберите интерьер', interior = false})

				for interior, data in pairs(Config.interiors) do
					table.insert(list, {text = data.name, interior = interior})
				end

				interiorsList.listElements = list

			end,

		},

		{'button',
			sx/2 + 300 - 270, sy/2 + 300 - 70,
			250, 50,
			'Создать',

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			activeColor = {100, 100, 100, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,

			onClick = function(element)

				if not interiorsList.lastSelectedItem then return end

				local x,y,z = getElementPosition(localPlayer)

				local lots = tonumber(createLots[6]) or 0
				local cost = tonumber(createCost[6]) or 0
				local interior = interiorsList.lastSelectedItem.interior

				if lots <= 0 then return end
				if cost <= 0 then return end
				if not interior then return end

				triggerServerEvent('house.add', resourceRoot, x,y,z,
					lots, cost, createDonate.selected and 1 or 0, interior
				)

				closeWindow()
			end,
		},


	},

	creation_flat = {
		{'rectangle',
			sx/2 - 300, sy/2 - 300,
			600, 600,
			color = {25,25,25,255},
		},

		{'button', 
			sx/2 + 300 - 70, sy/2 - 300 + 20,
			50, 50,
			'',
			bg = closeTexture,
			color = {255,255,255,255},
			font = 'default',
			scale = 1,
			shadowRadius = 0,
			onClick = function(element)
				closeWindow()
			end,
		},

		{'input',
			sx/2 - 300 + 20, sy/2 - 300 + 20,
			250, 50,
			'',

			placeholder = 'Парковочные места',

			onInit = function(element)
				createFlatLots = element
			end,

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
		},

		{'input',
			sx/2 - 300 + 20, sy/2 - 300 + 80,
			250, 50,
			'',

			placeholder = 'Стоимость',

			onInit = function(element)
				createFlatCost = element
			end,

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
		},

		{'input',
			sx/2 - 300 + 20, sy/2 - 300 + 140,
			250, 50,
			'',

			placeholder = 'Кол-во квартир',

			onInit = function(element)
				createFlatsCount = element
			end,

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,
		},

		{'button',
			sx/2 + 300 - 270, sy/2 + 300 - 70,
			250, 50,
			'Создать',

			bg = whiteTexture,
			color = {0, 0, 0, 255},
			activeColor = {100, 100, 100, 255},
			textColor = {255,255,255,255},

			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 13/14,

			onClick = function(element)

				local x,y,z = getElementPosition(localPlayer)

				local lots = tonumber(createFlatLots[6]) or 0
				local cost = tonumber(createFlatCost[6]) or 0
				local flatsCount = tonumber(createFlatsCount[6]) or 0

				if lots <= 0 then return end
				if cost <= 0 then return end
				if flatsCount <= 0 then return end

				triggerServerEvent('flat.add', resourceRoot, x,y,z,
					lots, cost, flatsCount
				)

				closeWindow()
			end,
		},


	},

	flat = {

		{'element',
			'center', 'center',
			595, 581,
			color = {255,255,255,255},

			elements = {

				{'image',
					'center', 'top',
					595, 82,
					'assets/images/flats/hbg.png',
					color = {25,24,38,255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w/2 - 621/2,
							y + h/2 - 108/2 + 5,
							621, 108, 'assets/images/flats/hbg_shadow.png',
							0, 0, 0, tocolor(0,0,0,255*alpha)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local gradient = getTextureGradient( getDrawingTexture(element[6]) , {
							color = {
								{ 0, 0, 0, 0 },
								{ 180, 70, 70, 20 },
							},
							alpha = alpha,
							angle = -30+180,	
						})

						dxDrawImage(
							x,y,w,h, gradient
						)

						dxDrawImage(
							x + 30,
							y+h/2-56/2,
							56, 56, 'assets/images/flats/hicon_bg.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						dxDrawImage(
							x + 30,
							y+h/2-56/2,
							56, 56, 'assets/images/flats/hicon.png',
							0, 0, 0, tocolor(0,0,0,200*alpha)
						)

						dxDrawText('Многоэтажный дом',
							x,y,x+w,y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
							'center', 'center'
						)

					end,

					elements = {

						{'button',

							function(s,p) return p[4] - s[4] - 30 end, 'center', 26, 26,
							bg = 'assets/images/flats/close.png',
							activeBg = 'assets/images/flats/close_active.png',
							define_from = '',

							'',

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x,y,w,h, 'assets/images/flats/close_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

							onClick = closeWindow,

						},

					},

				},

				{'image',
					'center', 'bottom',
					595, 484,
					'assets/images/flats/fbg.png',
					color = {25,24,38,255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w/2 - 621/2,
							y + h/2 - 108/2 + 5,
							621, 108, 'assets/images/flats/fbg_shadow.png',
							0, 0, 0, tocolor(0,0,0,255*alpha)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local gradient = getTextureGradient( getDrawingTexture(element[6]) , {
							color = {
								{ 0, 0, 0, 0 },
								{ 180, 70, 70, 20 },
							},
							alpha = alpha,
							angle = -30+180,	
						})

						dxDrawImage(
							x,y,w,h, gradient
						)

					end,

					elements = {

						{'element',
							'center', 'center',
							496, '90%',
							color = {255,255,255,255},

							variable = 'flatsList',
							overflow = 'vertical',

							scrollXOffset = 15,

							clear = function(element)

								for _, element in pairs( element.elements or {} ) do
									element:destroy()
								end

								element.elemets = {}

							end,

							onInit = function(element)

								openHandlers.flats = function()

									if currentWindowSection == 'flat' then

										flatsList:update()

									end

								end

								closeHandlers.flats = function()

									if currentWindowSection == 'flat' then

										flatsList:clear()

									end

								end

							end,

							addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

								if dn == 'house.data' then

									if new and new.flat and new.id then

										for _, flat_element in pairs( flatsList.elements or {} ) do

											if flat_element.flat.data.flat == new.flat and flat_element.flat.data.id == new.id then
												flat_element.flat.data = new
											end

										end

									end


								end

							end),

							update = function(element)

								if not currentFlatData then return end

								setAnimData(element.ov_animId, 0.1, 0)
								element:clear()

								local flat_houses = {}

								local index = 1
								for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do

									if marker.dimension == currentFlatData.id then

										local h_data = marker:getData('house.data') or {}

										if h_data.flat == currentFlatData.id then
											table.insert(flat_houses, { marker = marker, data = h_data, index = index })
											index = index + 1
										end

									end

								end

								local localLogin = localPlayer:getData('unique.login')

								table.sort(flat_houses, function(a,b)

									local am1 = (
										a.data.owner == localLogin and 2 or (
											a.data.owner == '' and 1 or 0
										)
									)

									local am2 = (
										b.data.owner == localLogin and 2 or (
											b.data.owner == '' and 1 or 0
										)
									)

									if am1 == am2 then
										return a.index < b.index
									else
										return am1 > am2
									end


								end)

								local w,h = 243, 64
								local padding = element[4] - w*2
								local startY = 0

								for index, flat in pairs( flat_houses ) do

									local side = (index % 2) == 0 and 'right' or 'left'

									element:addElement(
										{'image',
											side, startY,
											w,h,
											color = {21,21,33,255},
											'assets/images/flats/fitem.png',

											flat = flat,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawText(('Квартира #ffffff #%s'):format(element.flat.index),
													x + 25, y + 11,
													x + 25, y + 11,
													tocolor(60,56,80,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
													'left', 'top', false, false, false, true
												)

												local str, r_color

												if element.flat.data.owner == '' then

													str = '$' .. splitWithPoints( element.flat.data.cost, '.' )
													r_color = {110,180,90}

												elseif element.flat.data.owner == localPlayer:getData('unique.login') then

													str = 'Вы владелец'
													r_color = {120,140,190}

												else

													str = element.flat.data.owner
													r_color = {180,70,70}

												end

												local r,g,b = unpack(r_color)


												dxDrawText(str,
													x + 25, y + h - 11,
													x + 25, y + h - 11,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
													'left', 'bottom'
												)

												local aw,ah = 290,112

												dxDrawImage(
													x + w/2 - aw/2, y+h/2 - ah/2,
													aw,ah, 'assets/images/flats/fitem_a.png',
													0, 0, 0, tocolor(r,g,b,255*alpha*element.animData)
												)

												local rw,rh = 58,58
												local rx,ry = x+w - rw - 10, y+h/2 - rh/2

												dxDrawImage(
													rx,ry,rw,rh, 'assets/images/flats/picon.png',
													0, 0, 0, tocolor(r,g,b,255)
												)

												dxDrawText(element.flat.data.lots,
													rx,ry,rx+rw,ry+rh,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
													'center', 'center'
												)

											end,

											onClick = function(element)

												currentHouseMarker = element.flat.marker
												currentHouseData = element.flat.data

												if element.flat.data.owner == '' then
													currentWindowSection = 'enter_free'
												elseif element.flat.data.owner == localPlayer:getData('unique.login') then
													currentWindowSection = 'main'
												else
													currentWindowSection = 'enter_bought'
												end

											end,



										}
									)

									if side == 'right' then
										startY = startY + h + padding
									end


								end

							end,

						},

					},

				},

			},

		},

	},

}

------------------------------------

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

------------------------------------

loadGuiModule()

end)
