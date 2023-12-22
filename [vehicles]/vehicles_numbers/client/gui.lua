
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

	showChat(false)
	localPlayer:setData('hud.hidden', true)
	localPlayer:setData('speed.hidden', true)
	localPlayer:setData('radar.hidden', true)
	localPlayer:setData('3dtext.hidden', true)

	triggerServerEvent('vehicles.sendPlayerVehicles', root)
	triggerServerEvent('vehicles.sendPlayerNumbers', root)

	startCamera({
		FOV = 70,
		centerOffset = 1,
		distance = 6,
		roll = 0,
		rotationHorizontal = -70 + localPlayer.vehicle.rotation.z,
		rotationVertical = 0,
		targetPosition = localPlayer.vehicle.position
	})

	localPlayer.vehicle:setData('engine.disabled', true)

end

closeHandler = function()

	showChat(true)
	localPlayer:setData('hud.hidden', false)
	localPlayer:setData('speed.hidden', false)
	localPlayer:setData('radar.hidden', false)
	localPlayer:setData('3dtext.hidden', false)

	stopCamera() 

	if localPlayer.vehicle then
		localPlayer.vehicle:setData('engine.disabled', false)
	end

	numberInput[6] = ''

	numberExampleElement:resetVehicleNumber()

end

-- windowPriority = 'low-10'
hideBackground = true
blurBackground = false

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

		{'element',
			0, 50, 
			'100%', 50,
			color = {255,255,255,255},

			tabs = {
				{ name = 'Новый номер', id = 'main' },
				{ name = 'Хранилище', id = 'repository' },
				{ name = 'Перенос номеров', id = 'reset' },
			},

			onInit = function(element)

				local x,y,w,h = element:abs()			

				local startX = x + 400
				local bh = 40

				local scale, font = 0.5, getFont('montserrat_semibold', 27, 'light')

				for _, tab in pairs( element.tabs ) do

					local textWidth = dxGetTextWidth(tab.name, scale, font)
					local bw = textWidth + 55

					element:addElement(
						{'button',

							startX, y+h/2-bh/2,
							bw,bh,
							color = {255,255,255,255},
							textColor = {150,150,150,255},

							scale = scale,
							font = font,

							tab.name,

							tab = tab.id,

							onClick = function(element)
								currentWindowSection = element.tab
							end,

							onInit = function(element)
							end,

							onRender = function(element)

								if currentWindowSection == element.tab then
									element.textColor = {255,255,255, element.textColor[4]}
								else
									element.textColor = {150,150,150, element.textColor[4]}
								end


							end,


						}
					)

					startX = startX + bw

				end

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local size = 64

				dxDrawImage(
					x + 50, y+h/2-size/2, size, size,
					'assets/images/icon_bg.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				dxDrawImage(
					x + 50, y+h/2-size/2, size, size,
					'assets/images/numbers_icon.png',
					0, 0, 0, tocolor(0, 0, 0, 120*alpha)	
				)

				dxDrawText('Номерной салон',
					x+50+size+15, y,
					x+50+size+15, y+h,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 33, 'light'),
					'left', 'center'
				)

			end,

			elements = {

				{'button',

					0, 'center', 40, 40,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 40

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

	main = {


		{'list',

			80,
			sy/2 - 850/2 + 40,
			262, 850,

			scrollBg = scrollTexture,

			scrollColor = {180, 70, 70,255},
			scrollBgColor = {29, 27, 35, 255},

			scrollWidth = 5,

			icons = {

				a = { icon = 'assets/images/numbers/ru.png' },
				k = { icon = 'assets/images/numbers/ru.png' },
				j = { icon = 'assets/images/numbers/ru.png' },

				o = { icon = 'assets/images/numbers/vip.png', color = {230,90,90} },
				h = { icon = 'assets/images/numbers/vip.png', color = {250,210,80}, symbols_limit = 15 },
				n = { icon = 'assets/images/numbers/vip.png', color = {100,100,200}, symbols_limit = 15 },
				m = { icon = 'assets/images/numbers/vip.png', color = {255,255,0}, symbols_limit = 15 },
				-- p = { icon = 'assets/images/numbers/vip.png', color = {200,70,70} },
				q = { icon = 'assets/images/numbers/vip.png', color = {70,200,70} },

				f = { icon = 'assets/images/numbers/ua.png' },
				g = { icon = 'assets/images/numbers/by.png' },
				e = { icon = 'assets/images/numbers/kz.png' },

			},

			listOffset = 0,
			listElements = {
				{name = 'Россия', type = 'a',},
				{name = 'Россия | без флага', type = 'k'},
				{name = 'Федеральные', type = 'j'},
				{name = 'Дипломатические', type = 'o'},

				{name = 'VIP', type = 'h', draw_type = 'vip'},
				{name = 'VIP', type = 'n', draw_type = 'vip'},
				{name = 'Золотые', type = 'm', draw_type = 'vip'},
				-- {name = 'Рос. именные', type = 'p', draw_type = 'vip', symbols_limit = 7},
				{name = 'Фед. именные', type = 'q', draw_type = 'vip', symbols_limit = 7},

				{name = 'Украина', type = 'f'},
				{name = 'Беларусь', type = 'g'},
				{name = 'Казахстан', type = 'e'},
			},

			font = getFont('montserrat_semibold_italic', 24, 'light'),
			scale = 0.5,

			listElementHeight = 70,


			color = {255,255,255,255},

			onInit = function(element)
				selectNumberBuy = element
			end,

			onKey = {

				arrow_u = function(element)
					element:move(-1)
				end,
				arrow_d = function(element)
					element:move(1)
				end,

				mouse1 = function(element)
					local x,y,w,h = element:abs()

					if not isMouseInPosition(x,y,w,h) and not hasHoveredElement and not selectedInput then
						element.lastSelectedItem = false
						element.selectedItem = false
					end

				end,

			},

			additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

				local alpha = element:alpha()

				local w,h = 262, 59
				local x,y = 0, y+element.listElementHeight/2-h/2


				dxDrawImage(
					x,y,w,h,
					'assets/images/mnum.png', 0, 0, 0,
					tocolor(25,24,38, ( 200 + 55*animData )*alpha)
				)
				dxDrawImage(
					x,y,w,h,
					'assets/images/selnum.png', 0, 0, 0,
					tocolor(180, 70, 70, 255*alpha*animData)
				)

				if lElement.draw_type == 'vip' then

					local r,g,b = unpack(element.icons[lElement.type].color or {255,255,255})

					local texture = getDrawingTexture('assets/images/mnum.png')

					local gradient = getTextureGradient(texture, {
						alpha = alpha*animData,
						angle = 60,
						color = {
							{ 0, 0, 0, 0 },
							{ r,g,b, 50 },
						},	
					})

					dxDrawImage(
						x,y,w,h,
						gradient
					)

					dxDrawImage(
						x + 30, y+h/2-30/2,
						30, 30, element.icons[lElement.type].icon,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)

					for i = 1,2 do
						dxDrawText(lElement.name,
							x, y,
							x+w, y+h,
							tocolor(r,g,b,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
							'center', 'center'
						)
					end

				else

					local texture = getDrawingTexture('assets/images/mnum.png')

					local gradient = getTextureGradient(texture, {
						alpha = alpha*animData,
						angle = 60*animData,
						color = {
							{ 0, 0, 0, 0 },
							{ 180, 70, 70, 50 },
						},	
					})

					dxDrawImage(
						x,y,w,h,
						gradient
					)

					dxDrawImage(
						x+w-55, y+h/2-30/2,
						30, 30, element.icons[lElement.type].icon,
						0, 0, 0, tocolor(255,255,255,255*alpha)
					)

					for i = 1,2 do
						dxDrawText(lElement.name,
							x+30, y,
							x+30, y+h,
							tocolor(255,255,255,255*alpha),
							element.scale, element.scale, element.font,
							'left', 'center'
						)
					end

				end


			end,

			onListElementClick = function()
				setTimer(function()
					numberExampleElement:updateVehicleNumber()
				end, 100, 1)
			end,

		},

		{'image',

			sx-342-70, ( real_sy - px(346) - px(70) )*sx/real_sx,
			342, 346,
			color = {25,24,38,255},
			'assets/images/mbg1.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 368/2,
					y + h/2 - 372/2 + 5,
					368, 372, 'assets/images/mbg1_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			elements = {

				{'input',
					'center', 30,
					233, 49,
					'',
					placeholder = 'Введите номер',
					bg = 'assets/images/input.png',

					onInit = function(element)
						numberInput = element

						element.h_animId = {}
						setAnimData(element.h_animId, 0.1, 0)
						element.y0 = element[3]

					end,

					color = {21, 21, 33, 255},
					placeholderColor = {65, 61, 87, 255},

					alignX = 'center',

					scale = 0.5,
					font = getFont('montserrat_medium', 25, 'light'),

					maxSymbols = 10,
					possibleSymbols = '1234567890qwertyuiopasdfghjklzxcvbnm',

					onInput = function(element)

						numberExampleElement:updateVehicleNumber()

					end,

					onRender = function(element)

						animate(element.h_animId,
							element == selectedInput and 1 or 0
						)

						local anim = getAnimData(element.h_animId)

						element[3] = element.y0 - 15*anim

						if selectNumberBuy.lastSelectedItem then

							local hint = Config.numberHints[ selectNumberBuy.lastSelectedItem.type ]

							if hint then

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText(hint,
									x,y+h+3,x+w,y+h+3,
									tocolor(100,100,120,255*alpha*anim),
									0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
									'center', 'top'
								)
								
							end

							if selectNumberBuy.lastSelectedItem.symbols_limit then
								element.maxSymbols = selectNumberBuy.lastSelectedItem.symbols_limit
							else
								element.maxSymbols = 10
							end

						else

							element.maxSymbols = 10

						end


					end,

				},

				{'button',
					'center', 95,
					196, 42,
					'Проверить',
					bg = 'assets/images/rpbtn_empty.png',
					activeBg = 'assets/images/rpbtn.png',

					color = {180, 70, 70, 255},

					scale = 0.5,
					font = getFont('montserrat_medium', 25, 'light'),

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 211/2, y + h/2 - 58/2, 211, 58

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/rpbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						animate('check-button', 0)
						displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1500, function()

							animate('check-button', 1)

							local nType = getCurrentNumberType()
							if not nType then return end

							local currentNumber = string.format('%s-%s',
								nType,
								numberInput[6]
							)

							if isPlateCorrect(currentNumber) then
								triggerServerEvent('numbers.check', resourceRoot, currentNumber)
							end


						end )

					end,

					setAnimData('check-button', 0.1, 1),
					animationAlpha = 'check-button',

				},

				{'image',

					'center', 'bottom',
					'100%', 187,
					color = {25,24,38,255},
					'assets/images/mbg2.png',

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w/2 - 370/2,
							y + h/2 - 215/2,
							370, 215, 'assets/images/mbg2_shadow.png',
							0, 0, 0, tocolor(0,0,0,255*alpha)
						)

					end,

					onRender = {

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							local texture = getDrawingTexture(element[6])

							local gradient = getTextureGradient(texture, {
								alpha = alpha,
								angle = -45+180,
								color = {
									{ 0, 0, 0, 0 },
									{ 180, 70, 70, 50 },
								},	
							})

							dxDrawImage(
								x,y,w,h,
								gradient
							)

						end,

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							local nType = getCurrentNumberType()


							if nType then

								local currentNumber = string.format('%s-%s',
									nType,
									numberInput[6]
								)

								if isPlateCorrect(currentNumber) then

									dxDrawText('Стоимость номера',
										x,y+30,x+w,y+30,
										tocolor(65,61,87,255*alpha),
										0.5, 0.5, getFont('montserrat_bold', 24, 'light'),
										'center', 'top'
									)

									local donate, dollars = getPlateCost(currentNumber, localPlayer)
									local cost, valute = dollars or donate, dollars and '#413d57$' or '<img>assets/images/donate.png</img>'

									drawSmartText(string.format('%s#ffffff%s',
										valute, splitWithPoints(cost, '.')
									),
										x, x+w, y+70, 
										tocolor(255,255,255,255*alpha),
										tocolor(255,255,255,255*alpha),
										0.5, getFont('montserrat_bold', 50, 'light'),
										'center', 35, 3, 3
									)

								else

									local text1, text2

									if numberInput[6] == '' then
										text1 = 'Пример номера'
										text2 = utf8.upper(numberExamples[nType])
									else
										text1 = 'Ошибка ввода'
										text2 = 'Неверный формат'
									end

									dxDrawText(text1,
										x,y+30,x+w,y+30,
										tocolor(65,61,87,255*alpha),
										0.5, 0.5, getFont('montserrat_bold', 24, 'light'),
										'center', 'top'
									)

									dxDrawText(text2,
										x,y+70,x+w,y+70,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_bold', 35, 'light'),
										'center', 'center'
									)

								end

							else

								dxDrawText('Выберите номер',
									x,y+70,x+w,y+70,
									tocolor(65,61,87,255*alpha),
									0.5, 0.5, getFont('montserrat_bold', 35, 'light'),
									'center', 'center'
								)

							end


						end,

					},

					elements = {

						{'button',
							'center', 187-47-25,
							216, 47,
							'Приобрести',
							bg = 'assets/images/rpbtn_empty.png',
							activeBg = 'assets/images/rpbtn.png',

							color = {180, 70, 70, 255},

							scale = 0.5,
							font = getFont('montserrat_medium', 25, 'light'),

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 234/2, y + h/2 - 65/2, 234, 65

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/rpbtn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local x,y,w,h = element:abs()


								local nType = getCurrentNumberType()
								if not nType then return end

								local number_input = numberInput[6]

								local currentNumber = string.format('%s-%s',
									nType, number_input
								)

								local donate, dollars = getPlateCost(currentNumber, localPlayer)
								local cost, valute = dollars or donate, dollars and '$' or 'R-Coin'

								dialog('Покупка', {
									string.format('Вы действительно хотите купить номер'),	
									string.format('%s за %s %s?',
										utf8.upper(number_input), splitWithPoints(cost, '.'), valute
									),	
								}, function(result)

									if result then

										animate('buy-button', 0)

										displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1500, function()

											animate('buy-button', 1)
											triggerServerEvent('numbers.buy', resourceRoot, currentNumber)
											numberExampleElement:resetVehicleNumber()
											numberInput[6] = ''

										end )

									end

								end)


							end,

							setAnimData('buy-button', 0.1, 1),
							animationAlpha = 'buy-button',

						},

					},

				},

			},

		},

		{'image',

			'center', (real_sy - px(123) - px(70))*sx/real_sx,
			354,123,

			'assets/images/num_example.png',
			color = {255,255,255,255},

			onInit = function(element)

				numberExampleElement = element

				element.animationAlpha = {}
				setAnimData(element.animationAlpha, 0.1)
			end,

			noDraw = function(element)

				local nType = getCurrentNumberType()
				animate(element.animationAlpha, nType and 1 or 0)

				return false

			end,

			updateVehicleNumber = function(element)

				local nType = getCurrentNumberType()
				if not nType then return end

				local currentNumber = string.format('%s-%s',
					nType,
					numberInput[6]
				)

				exports.vehicles_plates:applyPlateToVehicle(localPlayer.vehicle, currentNumber)

			end,

			resetVehicleNumber = function(element)

				if localPlayer.vehicle then
					exports.vehicles_plates:applyPlateToVehicle(localPlayer.vehicle)
				end

			end,

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()


					local nType = getCurrentNumberType()
					if not nType then return end

					local currentNumber = string.format('%s-%s',
						nType,
						numberInput[6]
					)

					local plate
					if isPlateCorrect(currentNumber) then
						plate = convertNumberplateToText(currentNumber)
					else
						plate = numberInput[6]
					end

					local scale, font

					if nType =='o' then
						scale, font = 0.5, getFont('montserrat_bold', 32, 'light')
					else
						scale, font = 0.5, getFont('montserrat_bold', 42, 'light')
					end

					dxDrawText(utf8.upper(plate),
						x+137,y,x+137,y+h,
						tocolor(255,255,255,255*alpha),
						scale, scale, font,
						'center', 'center'
					)

					local iw,ih = 40, 40
					local ix,iy = x+287-iw/2, y+62-ih/2

					local icon_data = selectNumberBuy.icons[nType]
					local icon = icon_data.icon

					local r,g,b = unpack( icon_data.color or {255,255,255} )

					dxDrawImage(
						ix,iy,iw,ih, icon,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)

				end,

				function(element)


					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local y_add = -30 + element.animData*15

					dxDrawText('Номер, который вы покупаете',
						x, y+h+y_add, x+w, y+h+y_add,
						tocolor(255,255,255,255*alpha*element.animData),
						0.5, 0.5, getFont('montserrat_semibold_italic', 24, 'light'),
						'center', 'top'
					)

				end,

			},

		},


	},

	repository = {

		{'list',

			80,
			sy/2 - 600/2,
			289, 600,

			scrollBg = scrollTexture,

			scrollColor = {180, 70, 70, 255},
			scrollBgColor = {29, 27, 35, 255},

			scrollWidth = 5,
			scrollXOffset = 10,

			listOffset = 0,
			listElements = {},

			font = getFont('montserrat_semibold_italic', 24, 'light'),
			scale = 0.5,

			listElementHeight = 75,

			color = {255,255,255,255},

			onInit = function(element)
				numbersRepositoryList = element
			end,

			onListElementClick = function(element, lElement)
				element.selectedId = lElement.id
				exports.vehicles_plates:applyPlateToVehicle(localPlayer.vehicle, lElement.number)
			end,

			scrollHeight = 0.8,

			slots = { total = 0, used = 0, },

			addEvent('numbers.returnRepository', true),
			addEventHandler('numbers.returnRepository', root, function(repository)

				local repositorySize = Config.defaultRepositorySize + ( localPlayer:getData('numbers.repository_expand') or 0 )
				numbersRepositoryList.slots = { total = repositorySize, used = #repository }

				for i = 1, repositorySize - #repository do
					table.insert(repository, { free = true })
				end

				numbersRepositoryList.listElements = repository

				for index, listElement in pairs(numbersRepositoryList.listElements) do
					if listElement.id == numbersRepositoryList.selectedId then
						numbersRepositoryList.selectedItem = index
						numbersRepositoryList.lastSelectedItem = listElement
						numbersRepositoryList:onListElementClick(listElement)
					end
				end

			end),

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText(string.format('#ffffff%s #433e59/ %s',
					element.slots.used, element.slots.total
				),
					x+15,y-20,x+15,y-20,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
					'left', 'bottom', false, false, false, true
				)

				element.server_time = getServerTimestamp().timestamp

			end,


			additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

				local alpha = element:alpha()

				local w,h = 289, 67
				local x,y = 0, y+element.listElementHeight/2-h/2

				dxDrawImage(
					x,y,w,h, 'assets/images/rpnum.png',
					0, 0, 0, tocolor(25,24,38,255*alpha)
				)

				if lElement.free then

					dxDrawText('Свободный слот',
						x,y,x+w,y+h,
						tocolor(50,50,60,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
						'center', 'center'
					)

				else

					local r,g,b = interpolateBetween(
						20,20,30,180,70,70,animData,'InOutQuad'
					)

					dxDrawImage(
						x+1,y+1,w-2,h-2, 'assets/images/rpnum_sep.png',
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)

					local plate = convertNumberplateToText(lElement.number)
					local plate_type = string.sub(lElement.number, 1, 1)

					local font

					if plate_type == 'o' then
						font = getFont('montserrat_bold', 22, 'light')
					else
						font = getFont('montserrat_bold', 27, 'light')
					end

					dxDrawText(utf8.upper(plate),
						x,y,x+230,y+h,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, font,
						'center', 'center'
					)

					local iw,ih = 30, 30
					local ix,iy = x+242-iw/2, y+34-ih/2

					local icon_data = selectNumberBuy.icons[plate_type]
					local icon = icon_data.icon

					local r,g,b = unpack( icon_data.color or {255,255,255} )

					dxDrawImage(
						ix,iy,iw,ih, icon,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)

					if element.server_time then

						local days = math.floor( (lElement.expire - element.server_time)/86400 )
						local tr,tg,tb = 70,180,70
						if days < 3 then
							tr,tg,tb = 180,70,70
						end

						dxDrawText(days,
							x + 35, y+h/2+4,
							x + 35, y+h/2+4,
							tocolor(tr,tg,tb,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
							'center', 'bottom'
						)
						dxDrawText('дн.',
							x + 35, y+h/2-4,
							x + 35, y+h/2-4,
							tocolor(tr,tg,tb,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
							'center', 'top'
						)

					end


				end



			end,

			elements = {

				{'button',
					'center', 0,
					289, 67,
					'Расширить хранилище',

					bg = 'assets/images/rp_tab.png',

					color = {25, 24, 38, 255},

					onInit = function(element)
						element[3] = element.parent[5] + 10
					end,

					scale = 0.5,
					font = getFont('montserrat_semibold', 25, 'light'),

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local texture = getDrawingTexture(element.bg)

						local gradient = getTextureGradient(texture, {
							alpha = alpha*element.animData,
							angle = 60,
							color = {
								{ 0, 0, 0, 0 },
								{ 180, 70, 70, 50 },
							},	
						})

						dxDrawImage(
							x,y,w,h,
							gradient
						)

						dxDrawImage(
							x,y,w,h, 'assets/images/rptab1.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 315/2, y + h/2 - 104/2, 315, 104

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/rp_tab_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 100*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						dialog('Расширение', {
							'Вы действительно хотите расширить',
							string.format('хранилище за %s R-Coin?', Config.expandCost)
						}, function(result)

							if result then

								animate('expand-button', 0)
								displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1500, function()

									animate('expand-button', 1)
									triggerServerEvent('numbers.expandRepository', resourceRoot)

								end )

							end

						end)

					end,

					setAnimData('expand-button', 0.1, 1),
					animationAlpha = 'expand-button',

				},

			},

		},

		{'element',
			sx-289-50, 300,
			289, 0,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Управление номером',
					x+w-10,y-15,x+w-10,y-15,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'right', 'bottom'
				)

			end,

			onInit = function(element)

				local actions = {

					{ name = 'Удалить номер', action = function(element)

						if not numbersRepositoryList.lastSelectedItem then
							return exports.hud_notify:notify('Ошибка', 'Не выбран номер')
						end

						dialog('Удаление', {
							string.format('Вы действительно хотите удалить'),
							string.format('номер %s?',
								convertNumberplateToText(numbersRepositoryList.lastSelectedItem.number)
							),
						}, function(result)

							if result then
								triggerServerEvent('numbers.delete', resourceRoot, numbersRepositoryList.lastSelectedItem.number)
							end

						end)

					end },

					{ name = 'Установить на Т/С', action = function(element)

						if not numbersRepositoryList.lastSelectedItem then
							return exports.hud_notify:notify('Ошибка', 'Не выбран номер')
						end

						local id = localPlayer.vehicle:getData('id')
						if not id then return end

						dialog('Установка', {
							string.format('Вы действительно хотите установить'),
							string.format('номер %s?',
								convertNumberplateToText(numbersRepositoryList.lastSelectedItem.number)
							),
						}, function(result)

							if result then
								triggerServerEvent('numbers.set', resourceRoot, numbersRepositoryList.lastSelectedItem.number, id)
							end

						end)


					end },

					{ name = 'Снять в хранилище', action = function(element)

						animate('repository-take-window', 1)

					end },

					{ name = 'Убрать флаг', action = function(element)

						if not numbersRepositoryList.lastSelectedItem then
							return exports.hud_notify:notify('Ошибка', 'Не выбран номер')
						end

						dialog('Убрать флаг', {
							string.format('Вы действительно хотите убрать'),
							string.format('флаг на номере %s за $%s?',
								convertNumberplateToText(numbersRepositoryList.lastSelectedItem.number),
								splitWithPoints( Config.clearFlagCost, '.' )
							),
						}, function(result)

							if result then
								triggerServerEvent('numbers.clearPlateFlag', resourceRoot,
									numbersRepositoryList.lastSelectedItem.number,
									numbersRepositoryList.lastSelectedItem.id
								)
							end

						end)

					end, noDraw = function(element)

						return not ( numbersRepositoryList.lastSelectedItem and getNumberType(numbersRepositoryList.lastSelectedItem.number) == 'a' )

					end },

				}

				local startY = 0
				local padding = 12

				for _, action in pairs( actions ) do

					element:addElement(
						{'button',
							'center', startY,
							289, 67,
							action.name,

							bg = 'assets/images/rp_tab.png',

							color = {25, 24, 38, 255},
							activeColor = {32, 35, 66, 255},

							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local texture = getDrawingTexture(element.bg)

								local gradient = getTextureGradient(texture, {
									alpha = alpha*element.animData,
									angle = 60+60*element.animData,
									color = {
										{ 0, 0, 0, 0 },
										{ 180, 70, 70, 100 },
									},	
								})

								dxDrawImage(
									x,y,w,h,
									gradient
								)

								dxDrawImage(
									x,y,w,h, 'assets/images/rptab1.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha)
								)

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 315/2, y + h/2 - 104/2, 315, 104

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/rp_tab_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 200*alpha*element.animData)
								)

							end,

							onClick = action.action,
							noDraw = action.noDraw,

						}
					)

					startY = startY + 67 + padding

				end

			end,

		},

		{'image',
			'center', 'center',
			494, 475,
			color = {25,24,38,255},
			'assets/images/rpbg.png',

			animationAlpha = 'repository-take-window',
			setAnimData('repository-take-window', 0.1, 0),

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local texture = getDrawingTexture(element[6])

					local gradient = getTextureGradient(texture, {
						alpha = alpha,
						angle = 60-90,
						color = {
							{ 0, 0, 0, 0 },
							{ 180,70,70, 20 },
						},	
					})

					dxDrawImage(
						x,y,w,h,
						gradient
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local cost,text,ty

					if clearNumberList.lastSelectedItem and clearNumberList.lastSelectedItem.cost <= Config.minResetCost then
						cost = Config.clearCost2
						text = string.format('Стоимость операции - #cd4949$%s#4a4566\n(Автомобиль дешевле #cd4949$%s#4a4566)',
							splitWithPoints(Config.clearCost2, '.'),
							splitWithPoints(Config.minResetCost, '.')
						)
						ty = y+h-15
					else
						cost = Config.clearCost
						text = string.format('Стоимость операции - #cd4949$%s',
							splitWithPoints(Config.clearCost, '.')
						)
						ty = y+h-25
					end

					dxDrawText(text,
						x,ty,x+w,ty,
						tocolor(74,69,102,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
						'center', 'bottom', false, false, false, true
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawText(string.format('Снять в хранилище'),
						x, y+43, x+w, y+43,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
						'center', 'center'
					)

				end,

			},

			elements = {

				{'image',
					'center', 75,
					426, 271,
					color = {22,22,34,255},
					'assets/images/rpbg1.png',

					onPostRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/rpbg11.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

					end,

					elements = {

						{'list',
							'center', 30,
							'100%', 271-60,
							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {29, 27, 35, 255},
							scrollWidth = 5,
							listOffset = 0,
							listElements = {},

							font = getFont('montserrat_semibold', 25, 'light'),
							scale = 0.5,

							listElementHeight = 50,

							scrollXOffset = 10,

							color = {255,255,255,255},

							onInit = function(element)
								clearNumberList = element
							end,

							addEvent('vehicles.getPlayerVehicles', true),
							addEventHandler('vehicles.getPlayerVehicles', root, function(vehicles)

								clearNumberList.listElements = {}

								for index, vehicle in pairs( vehicles ) do
									if not (vehicle.flag or vehicle.expiry_date)
									and getVehicleType(vehicle.model) == 'Automobile' then

										table.insert(clearNumberList.listElements, {
											name = exports['vehicles_main']:getVehicleModName(vehicle.model),
											model = vehicle.model,
											plate = vehicle.plate and convertNumberplateToText(vehicle.plate) or '',
											id = vehicle.id,
											cost = exports.vehicles_main:getVehicleCost(vehicle.model),
										})

									end
								end

							end),

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

								local alpha = element:alpha()

								local r,g,b = interpolateBetween(
									26,24,36,180,70,70,animData,'InOutQuad'
								)
								local tr,tg,tb = interpolateBetween(
									255,255,255,80,30,30,animData,'InOutQuad'
								)

								local w,h = element[4], 45
								local x,y = 0, y+element.listElementHeight/2-h/2

								dxDrawRectangle(
									x,y,w,h,
									tocolor(r,g,b, 255*alpha)
								)

								dxDrawText(lElement.name,
									x+25, y,
									x+25, y+h,
									tocolor(tr,tg,tb,255*alpha),
									element.scale,element.scale, element.font,
									'left', 'center'
								)

								dxDrawText(lElement.plate,
									x+w-25, y,
									x+w-25, y+h,
									tocolor(tr,tg,tb,255*alpha),
									element.scale,element.scale, element.font,
									'right', 'center'
								)

							end,

						},

					},

				},

				{'button',

					0, 30, 26, 26,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30

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
						animate('repository-take-window', 0)
					end,

				},

				{'button',
					'center', 0,
					216, 47,
					'Снять номер',
					bg = 'assets/images/rpbtn_empty.png',
					activeBg = 'assets/images/rpbtn.png',

					color = {180, 70, 70, 255},

					onInit = function(element)
						element[3] = element.parent[5] - element[5] - 60
					end,

					scale = 0.5,
					font = getFont('montserrat_semibold', 27, 'light'),

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 234/2, y + h/2 - 65/2, 234, 65

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/rpbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						local selected = clearNumberList.lastSelectedItem

						if not selected then
							return exports.hud_notify:notify('Ошибка', 'Не выбран автомобиль')
						end

						local id = selected.id

						dialog('Снять номер', {
							'Вы действительно хотите снять',
							string.format('номер %s с %s',
								selected.plate, selected.name
							),
							string.format('за %s$?',
								splitWithPoints(Config.clearCost, '.')
							),
						}, function(result)

							if result then

								animate('clear-button', 0)
								displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1500, function()

									animate('clear-button', 1)

									triggerServerEvent('numbers.clear', resourceRoot, id)
									animate('repository-take-window', 0)

								end )

							end

						end)

					end,

					setAnimData('clear-button', 0.1, 1),
					animationAlpha = 'clear-button',

				},


			},

		},

	},

	reset = {

		{'element',
			'center', 'center',
			484*2 + 300, 308,
			color = {255,255,255,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local aw,ah = 112,112
				local ax,ay = x+w/2-aw/2, y+h/2-ah/2

				dxDrawImage(
					ax,ay,aw,ah, 'assets/images/arrow_bg.png',
					0, 0, 0, tocolor(205, 75,75, 255*alpha)
				)

				dxDrawImage(
					ax+aw/2-30/2,ay+ah/2-30/2,30,30, 'assets/images/arrow.png',
					0, 0, 0, tocolor(255, 255,255, 255*alpha)
				)

				dxDrawText('Перенос номеров',
					x, y + h + 70,
					x, y + h + 70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold_italic', 40, 'light'),
					'left', 'top'
				)

				dxDrawText('Информация',
					x, y + h + 120,
					x, y + h + 120,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold_italic', 30, 'light'),
					'left', 'top'
				)

				dxDrawText(string.format('Стоимость переноса номера - #cd4949$%s', splitWithPoints(Config.resetCost, '.')),
					x, y + h + 150,
					x, y + h + 150,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium_italic', 25, 'light'),
					'left', 'top', false, false, false, true
				)

				dxDrawText(string.format('Если один из автомобилей дешевле #cd4949$%s#ffffff,\nто перенос обойдется в #cd4949$%s', 
					splitWithPoints(Config.minResetCost, '.'), splitWithPoints(Config.resetCost2, '.')
				),
					x, y + h + 180,
					x, y + h + 180,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium_italic', 25, 'light'),
					'left', 'top', false, false, false, true
				)

			end,

			onInit = function(element)

				for index, id in pairs( {'resetList_from', 'resetList_to'} ) do

					element:addElement(
						{'element',
							index == 1 and 'left' or 'right', 0,
							484, 308,

							id = id,

							color = {255,255,255,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x,y,w,h, 'assets/images/rbg.png',
									0, 0, 0, tocolor(22,21,34, 220*alpha)
								)

							end,

							onPostRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x,y,w,h, 'assets/images/rbg1.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha)
								)

							end,

							elements = {

								{'list',
									'center', 30,
									'100%', 308-60,
									scrollBg = scrollTexture,
									scrollColor = {180, 70, 70,255},
									scrollBgColor = {29, 27, 35, 255},
									scrollWidth = 5,
									listOffset = 0,
									listElements = {},

									font = getFont('montserrat_semibold', 25, 'light'),
									scale = 0.5,

									listElementHeight = 50,

									scrollXOffset = -10,

									color = {255,255,255,255},

									onInit = function(element)
										_G[element.parent.id] = element
									end,

									additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

										local alpha = element:alpha()

										local r,g,b = interpolateBetween(
											26,24,36,180,70,70,animData,'InOutQuad'
										)
										local tr,tg,tb = interpolateBetween(
											255,255,255,80,30,30,animData,'InOutQuad'
										)

										local w,h = element[4], 45
										local x,y = 0, y+element.listElementHeight/2-h/2

										dxDrawRectangle(
											x,y,w,h,
											tocolor(r,g,b, 255*alpha)
										)

										dxDrawText(lElement.name,
											x+25, y,
											x+25, y+h,
											tocolor(tr,tg,tb,255*alpha),
											element.scale,element.scale, element.font,
											'left', 'center'
										)

										dxDrawText(lElement.plate,
											x+w-25, y,
											x+w-25, y+h,
											tocolor(tr,tg,tb,255*alpha),
											element.scale,element.scale, element.font,
											'right', 'center'
										)

									end,

								},

							},

						}
					)

				end

			end,

			addEvent('vehicles.getPlayerVehicles', true),
			addEventHandler('vehicles.getPlayerVehicles', root, function(vehicles)

				resetList_from.listElements = {}
				resetList_to.listElements = {}

				for index, vehicle in pairs( vehicles ) do
					if not (vehicle.flag or vehicle.expiry_date)
					and getVehicleType(vehicle.model) == 'Automobile' then

							for _, tbl in pairs( { resetList_to, resetList_from } ) do
								table.insert(tbl.listElements, {
									name = exports['vehicles_main']:getVehicleModName(vehicle.model),
									model = vehicle.model,
									plate = vehicle.plate and convertNumberplateToText(vehicle.plate) or '',
									id = vehicle.id,
									cost = exports.vehicles_main:getVehicleCost(vehicle.model),
								})
							end

					end
				end

			end),

			elements = {

				{'button',
					0, 0,
					298, 66,
					'Перенести номер',
					bg = 'assets/images/rbtn_empty.png',
					activeBg = 'assets/images/rbtn.png',

					color = {180, 70, 70, 255},

					onInit = function(element)
						element[2] = element.parent[4] - element[4]/2 - 484/2
						element[3] = element.parent[5] + 100
					end,

					scale = 0.5,
					font = getFont('montserrat_semibold', 27, 'light'),

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 336/2, y + h/2 - 106/2, 336, 106

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/rbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local x,y,w,h = element:abs()

						local from, to = resetList_from.lastSelectedItem, resetList_to.lastSelectedItem
						if not (from and to) then return end

						local cost = ( from.cost <= Config.minResetCost or to.cost <= Config.minResetCost ) and Config.resetCost2 or Config.resetCost

						dialog('Перестановка', {
							'Вы действительно хотите поставить',
							string.format('номер с %s на %s',
								from.name, to.name
							),
							string.format('за %s$?',
								splitWithPoints(cost, '.')
							),
						}, function(result)

							if result then

								animate('reset-button', 0)
								displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1500, function()

									animate('reset-button', 1)

									local from, to = resetList_from.lastSelectedItem, resetList_to.lastSelectedItem

									if from and to then
										triggerServerEvent('numbers.reset', resourceRoot, from.id, to.id)
									end

								end )

							end

						end)

					end,

					setAnimData('reset-button', 0.1, 1),
					animationAlpha = 'reset-button',

				},

			},

		},

	},
	
}

----------------------------------------------------------------------

	function getCurrentNumberType()
		if not selectNumberBuy.lastSelectedItem then return end
		return selectNumberBuy.lastSelectedItem.type
	end

----------------------------------------------------------------------

loadGuiModule()


end)

