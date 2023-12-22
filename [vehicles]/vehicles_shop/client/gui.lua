
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['delete'] = true,
} 


openHandler = function()
	gui_get('cars-list'):loadModels()
	startCamera()
	showChat(false)

	timedata = { getTime() }
	setTime( 12, 0 )

end
closeHandler = function()
	stopCamera()
	showChat(true)

	if timedata then
		setTime( unpack(timedata) )
	end

end

function getParkingData()
	return localPlayer:getData('parks.loaded') or 0, localPlayer:getData('parks.all') or 0
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			0, 0, sx, real_sy * sx/real_sx,
			'assets/images/bg_shadow.png',
			color = {0, 0, 0, 255},
			anim_fix = true,
			hover = false,
		},

		{'element',
			0, 0, sx, 100,
			color = {255,255,255,255},

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local texture = getTextureGradient(whiteTexture, {
					alpha = alpha,
					angle = 180,
					color = {
						{ 43,49,82, 255 },
						{ 180,70,70, 240 },
					},
				})

				dxDrawImage(
					x,y,w*3,h, texture
				)

				dxDrawImage(
					x,y,198,h, 'assets/images/tl.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawImage(
					x+75,y,100,100, 'assets/images/logo.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText('Автосалон',
					x+175+30, y,
					x+175+30, y+100,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'center'
				)

				local _x = x+w/2 + 150

				local cur, all = getParkingData()

				drawSmartText(string.format('Слотов %s #ba4b4c/ %s#ffffff        <img>assets/images/money.png</img> %s #ba4b4c$#ffffff        <img>assets/images/donate.png</img> %s #ba4b4cRC#ffffff',
					cur, all, splitWithPoints( localPlayer:getData('money') or 0, '.' ),
					splitWithPoints( localPlayer:getData('bank.donate') or 0, '.' )
				),
					_x, _x, y+50, 
					tocolor(255,255,255,255*alpha),
					tocolor(255,255,255,255*alpha),
					0.5, getFont('montserrat_semibold', 28, 'light'),
					'left', 35, 0
				)

				element[3] = -100*(1-windowAlpha)


			end,

			elements = {

				{'button',

					sx - 60, 'center', 35, 35,
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
						exitShop()
						closeWindow()
					end,

				},

			},

		},

		{'image',
			'center', ( real_sy - px(59) - 20 ) * sx/real_sx,
			670,59,
			color = {32,35,66,255},
			'assets/images/hints_bg.png',

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local hints = {
					{ button = 'BACKSPACE', hint = ' - Закрыть', icon = 'hint1' },
					{ button = 'ENTER', hint = ' - Купить', icon = 'hint2' },
					{ button = 'Z', hint = ' - Тест-драйв', icon = 'hint3' },
				}

				local totalW = 0
				local padding = 5

				local t_scale, t_font = 0.5, getFont('montserrat_semibold', 24, 'light')
				local b_scale, b_font = 0.5, getFont('montserrat_semibold', 21, 'light')

				for _, hint in pairs(hints) do

					local texture = getDrawingTexture(string.format('assets/images/%s.png', hint.icon))

					local textWidth = dxGetTextWidth(hint.hint, t_scale, t_font)
					local mw,mh = dxGetMaterialSize(texture)

					hint.width = { total = textWidth + mw, texture = mw, text = textWidth }
					hint.texture = texture

					totalW = totalW + hint.width.total

				end

				totalW = totalW + padding*(#hints-1)

				local startX = x+w/2 - totalW/2

				for _, hint in pairs(hints) do

					dxDrawImage(
						startX, y+h/2-50/2,
						hint.width.texture, 50,
						hint.texture, 0, 0, 0,
						tocolor(180,70,70,255*alpha)
					)

					dxDrawText(hint.button,
						startX, y+h/2,
						startX+hint.width.texture, y+h/2,
						tocolor(255,255,255,255*alpha),
						b_scale, b_scale, b_font, 'center', 'center'
					)

					dxDrawText(hint.hint,
						startX+hint.width.texture-5, y+h/2,
						startX+hint.width.texture-5, y+h/2,
						tocolor(255,255,255,255*alpha),
						t_scale, t_scale, t_font, 'left', 'center'
					)

					startX = startX + hint.width.total + padding

				end

			end,

			onKey = {

				backspace = function()
					exitShop()
					closeWindow()
				end,

				enter = function()
					animate('buying', 1)
					gui_get('pay-type'):update()
				end,

				num_enter = function()
					animate('buying', 1)
					gui_get('pay-type'):update()
				end,

				z = function()

					local cars_list = gui_get('cars-list')
					local cost = Config.calcTestDriveCost(cars_list.selected_item.vehicle.data.discount_cost)

					dialog('Тест-драйв', {
						string.format('Тест-драйв %s %s',
							cars_list.selected_item.vehicle.data.mark,
							cars_list.selected_item.vehicle.data.name
						),
						string.format('Стоимость - %s $', splitWithPoints(cost, '.')),
						string.format('Продолжить?'),
					}, function(result)

						if result then
							triggerServerEvent('vehicles.shop.testDrive',
								resourceRoot, cars_list.selected_item.vehicle.model, currentShopId)
						end


					end)

				end,

			},

		},

		{'image',

			'center', 'center',
			537,273,
			color = {32,35,66, 255},
			'assets/images/buy.png',

			onInit = function(element)
				element.y0 = element[3]
			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				element[3] = element.y0 - (1-alpha)*50

				dxDrawImage(
					x + w/2 - 563/2,
					y + h/2 - 299/2 + 5,
					563, 299, 'assets/images/buy_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Покупка',
					x, y+35,
					x+w, y+35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
					'center', 'top'
				)

				dxDrawText('Выберите тип оплаты',
					x, y+70,
					x+w, y+70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'top'
				)

			end,

			animationAlpha = 'buying',
			setAnimData('buying', 0.2),

			elements = {

				{'button',

					0, 0, 35, 35,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 35

					end,

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

					onClick = function(element)
						animate(element.parent.animationAlpha, 0)
					end,

				},

				{'button',

					'center', 273 - 42 - 35,
					163, 42,

					bg = 'assets/images/button_empty.png',
					activeBg = 'assets/images/button.png',
					'Продолжить',

					scale = 0.5,
					font = getFont('montserrat_semibold', 21, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},


					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 198/2, y + h/2 - 79/2, 198, 79

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local selectedPayType = gui_get('pay-type'):getSelectedType()

						if not selectedPayType then
							return exports.hud_notify:notify('Ошибка', 'Выберите тип оплаты')
						end

						local cars_list = gui_get('cars-list')

						if cars_list and cars_list.selected_item then

							local r,g,b = getVehicleColor(currentVehicle, true)
							triggerServerEvent('vehicle.shop.buy', resourceRoot,
								cars_list.selected_item.vehicle.model,
								RGBToHex(r,g,b), selectedPayType, element.index == 3)

						end


					end,


				},

				{'select',

					'center', 120,
					317, 50,
					bg = 'assets/images/gui_dialog/bg.png',
					-- bg = createTextureSource('bordered_rectangle', 'assets/images/gui_dialog/bg.png', 50, 317, 50),
					color = {53, 60, 98, 255},
					textColor = {255,255,255,255},

					id = 'pay-type',

					selectElements = {
						{ pay_type = 'money', name = 'Наличные' },
						{ pay_type = 'bank', name = 'Банковский счёт' },
						{ pay_type = 'donate', name = 'R-Coin' },
					},
					animSpeed = 0.1,

					placeholderColor = {200, 200, 200, 255},

					placeholder = 'Выберите оплату',
					alignX = 'center',

					listElementHeight = 50,

					lbg = 'assets/images/gui_dialog/lbg.png',
					-- lbg = createTextureSource('bordered_rectangle', ':core/assets/images/gui_dialog/lbg.png', 40, 280, 40),

					update = function(element)

						local cars_list = gui_get('cars-list')

						if cars_list and cars_list.selected_item then
							element.selectList.listElements[3].name = string.format('%s R-Coin',
								cars_list.selected_item.vehicle.data.donate_cost or 0
							)
						end

					end,

					additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

						local alpha = element:alpha()
						alpha = math.clamp(alpha, 0, 1)

						local x,y,w,h = x,y, element[4], element.listElementHeight

						local bw,bh = 280, 40

						local bx,by = x+w/2-bw/2, y+h/2-bh/2

						local r,g,b = interpolateBetween(24,30,66, 180,70,70, animData, 'InOutQuad')

						dxDrawImage(
							bx,by,bw,bh, element.parent.lbg,
							0, 0, 0, tocolor(r,g,b,255*alpha)
						)


						for i = 1,2 do
							dxDrawText(lElement.name,
								x,y,x+w,y+h,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
								'center', 'center'
							)
						end

					end,

					getSelectedText = function(element)
						return element.selectList.lastSelectedItem and element.selectList.lastSelectedItem.name
					end,

					getSelectedType = function(element)
						return element.selectList.lastSelectedItem and element.selectList.lastSelectedItem.pay_type
					end,

					onPostInit = function(element)

						-- element.list_bg = createTextureSource('bordered_rectangle',
						-- 	'assets/images/gui_dialog/lst_bg.png', 30,
						-- 	element[4], element.selectList[5]
						-- )
						element.list_bg = 'assets/images/gui_dialog/lst_bg.png'

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local bw,bh = 25, 25
						local bx,by = x+w-bw-10, y+h/2-bh/2

						local animData = getAnimData(element.select_animData)
						animData = getEasingValue(animData, 'InOutQuad')

						dxDrawImage(
							bx,by,bw,bh, ':core/assets/images/gui_dialog/select_btn.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)
						dxDrawImage(
							bx+bw/2-20/2,by+bh/2-20/2,20,20, ':core/assets/images/gui_dialog/select_arrow.png',
							180*animData, 0, 0, tocolor(255, 255, 255, 255*alpha)
						)


					end,

					scale = 0.5,
					font = getFont('montserrat_semibold', 25, 'light'),

				},

			},



		},

		{'image',

			30, 150,
			453,348,
			'assets/images/info_bg.png',
			color = {32,35,66,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getTextureGradient(getDrawingTexture(element[6]), {
					alpha = alpha,
					angle = -50,
					color = {
						{ 0,0,0, 0 },
						{ 180,70,70, 50 },
					},
				})

				dxDrawImage(
					x,y,w,h, texture
				)

				local cars_list = gui_get('cars-list')

				if cars_list and cars_list.selected_item then

					local name = string.format('%s %s',
						cars_list.selected_item.vehicle.data.mark,
						cars_list.selected_item.vehicle.data.name
					)

					if exports.vehicles_tuning:hasVehicleTuning(cars_list.selected_item.vehicle.model) then

						local scale, font = 0.5, getFont('montserrat_semibold', 28, 'light')
						local textWidth = dxGetTextWidth(name, scale, font)

						if textWidth > w*0.4 then
							name = cars_list.selected_item.vehicle.data.name
						end

						dxDrawText(name,
							x + 50,y+30,
							x + 50,y+30,
							tocolor(255,255,255,255*alpha),
							scale, scale, font,
							'left', 'top'
						)

						dxDrawText('Имеется тюнинг',
							x + w - 50,y+30,
							x + w - 50,y+30,
							tocolor(255,255,255,255*alpha),
							scale, scale, font,
							'right', 'top'
						)

					else
						dxDrawText(name,
							x,y+30,
							x+w,y+30,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
							'center', 'top'
						)
					end


					local properties = {'max_velocity', 'fuel', 'fuel_consumption'}

					local startY = y + 80

					for _, property in pairs( properties ) do

						local property_data = cars_list.vehiclesProperties[ property ]

						local lw,lh = 382,21
						local lx,ly = x+w/2-lw/2, startY + 30

						dxDrawText(property_data.name,
							lx + 30, startY,
							lx + 30, startY,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'top'
						)

						local value = cars_list.selected_item.vehicle.data.properties[property]

						dxDrawText(string.format('%s %s',
							value, getWordCase( value, unpack(property_data.postfix) )
						),
							lx + lw - 30, startY,
							lx + lw - 30, startY,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'right', 'top'
						)

						dxDrawImage(
							lx,ly,lw,lh, 'assets/images/property_line.png',
							0, 0, 0, tocolor(43,49,82,255*alpha)
						)

						drawImageSection(
							lx,ly,lw,lh, 'assets/images/property_line.png',
							{ y = 1, x = value/property_data.max }, tocolor(180, 70, 70, 255*alpha)
						)

						startY = startY + 60

					end

					local discount = getModelDiscount(cars_list.selected_item.vehicle.model) or 0

					local cost_int = cars_list.selected_item.vehicle.data.cost
					cars_list.selected_item.vehicle.data.discount_cost = cost_int - cost_int*(discount/100)
					local cost = splitWithPoints(cars_list.selected_item.vehicle.data.discount_cost, '.')

					local scale, font = 0.5, getFont('montserrat_semibold', 35, 'light')
					local textWidth = dxGetTextWidth( cost, scale, font )
					local fontHeight = dxGetFontHeight( scale, font )

					local imgSize = 30
					local imgPadding = 5
					local dw,dh = 40,26

					local totalWidth = (textWidth+imgSize+imgPadding)

					if discount > 0 then
						totalWidth = totalWidth + dw + 5
					end

					local startX = x+w/2-totalWidth/2
					local startY = y+h - 50

					local dx,dy = startX+imgSize+imgPadding+textWidth+5, startY-dh/2

					dxDrawImage(
						startX, startY - imgSize/2,
						imgSize, imgSize, 'assets/images/money.png',
						0, 0, 0, tocolor(255,255,255,255*alpha)
					)

					if discount > 0 then

						local old_cost = splitWithPoints(cost_int, '.')
						local scale, font = 0.5, getFont('montserrat_semibold', 30, 'light')

						local textWidth = dxGetTextWidth(old_cost, scale, font)
						local _y = startY - fontHeight/2+10

						local fontHeight = dxGetFontHeight(scale, font)

						dxDrawText(old_cost,
							startX+imgSize+imgPadding + textWidth/2 - 20, _y,
							startX+imgSize+imgPadding + textWidth/2 - 20, _y,
							tocolor(255,255,255,100*alpha),
							scale, scale, font,
							'left', 'bottom'
						)

						dxDrawRectangle(
							startX+imgSize+imgPadding + textWidth/2 - 20 - 3, _y-fontHeight/2,
							textWidth + 6, 1, tocolor(180, 70, 70, 255*alpha)
						)

					end
					
					dxDrawText(cost,
						startX+imgSize+imgPadding, startY, 
						startX+imgSize+imgPadding, startY,
						tocolor(255,255,255,255*alpha),
						scale, scale, font,
						'left', 'center'
					)

					if discount > 0 then

						dxDrawImage(
							dx,dy,dw,dh, 'assets/images/discount.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

						dxDrawText(string.format('-%s%%', discount),
							dx,dy,dx+dw,dy+dh,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'center', 'center'
						)

					end

				end

			end,

			elements = {

				{'image',

					'center', 0,
					'100%', 65,
					color = {32,35,66,255},

					id = 'car-color',

					onScroll = function(element, side)

						local cars_list = gui_get('cars-list')

						local delta = side == 'down' and 1 or -1

						for index, c_element in pairs(element.elements or {}) do

							if c_element.v_color == cars_list.v_color then	
								return element.elements[ cycle( index + delta, 1, #element.elements ) ]:onClick()
							end

						end

					end,

					onInit = function(element)

						openHandlers.color = function()

							local cars_list = gui_get('cars-list')
							local car_color = gui_get('car-color')

							cars_list.v_color = car_color.elements[1].v_color

						end

						element[3] = element.parent[5] + 10

						local cw,ch = 40, 40
						local padding = 7

						element[6] = 'assets/images/colors.png'
						-- element[6] = createTextureSource('bordered_rectangle', 'assets/images/colors.png', 25, element[4], element[5])

						local sCount = #Config.colors/2

						local startX = element[4]/2 - cw*sCount - padding*(sCount-0.5)
						local startY = element[5]/2 - ch/2

						for index, color in pairs( Config.colors ) do

							local r,g,b = unpack(color)

							element:addElement(
								{'rectangle',
									startX, startY,
									cw,ch, 
									color = {r,g,b, 255},

									v_color = color,

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local cars_list = gui_get('cars-list')

										local r,g,b = 255,255,255

										if cars_list and element.v_color == cars_list.v_color then
											dxDrawRectangle(
												x-2,y-2,w+4,h+4, tocolor(r,g,b,alpha*255*math.abs( math.sin( getTickCount()*0.0015 ) ))
											)
										end

									end,

									onClick = function(element)

										local cars_list = gui_get('cars-list')
										cars_list.v_color = element.v_color

										local r,g,b = unpack(cars_list.v_color)

										setVehicleColor(currentVehicle, r,g,b,r,g,b)

									end,

									index = index,


								}
							)

							startX = startX + cw + padding

						end

					end,

				},

			},

		},

		{'element',
			'center', ( real_sy - px(150) - 120 ) * sx/real_sx,
			'95%', 180,
			color = {255,255,255,255},

			elements = {

				{'button',
				
					-40, 'center',
					30, 30,
					'',
					color = {255,255,255,255},
					activeColor = {180,70,70,255},
					bg = 'assets/images/arrown.png',

					onClick = function(element)
						carsLisElement:callHandler('onScroll', 'up')
					end,

				},

				{'button',

					function(s,p) return p[4] + 10 end, 'center',
					30, 30, 
					'',
					color = {255,255,255,255},
					activeColor = {180,70,70,255},
					bg = 'assets/images/arrown.png',

					rot = 180,

					onClick = function(element)
						carsLisElement:callHandler('onScroll', 'down')
					end,

				},

				{'element',
					
					'center', 'center',
					'100%', '100%',
					color = {255,255,255,255},

					id = 'cars-list',
					variable = 'carsLisElement',

					onKey = {
						arrow_l = function(element)
							element:callHandler('onScroll', 'up')
						end,
						arrow_r = function(element)
							element:callHandler('onScroll', 'down')
						end,
					},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local cw,ch = 108, 43
						local cx,cy = x+w-cw-30,y-ch-20

						dxDrawImage(
							cx,cy,cw,ch, 'assets/images/cars_count.png',
							0, 0, 0, tocolor(47,53,89,255*alpha)
						)

						dxDrawText(string.format('%s #6c739a/ %s',
							element.selected_item and element.selected_item.index or 0,
							#(element.elements or {})
						),
							cx,cy,cx+cw,cy+ch,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'center', 'center', false, false, false, true
						)

					end,

					loadModels = function(element)

						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						local vehiclesList, vehiclesProperties = exports.vehicles_main:getVehiclesList()
						element.vehiclesProperties = vehiclesProperties

						local list = {}

						for model, vehicle_data in pairs(vehiclesList) do
							if not vehicle_data.noSell and vehicle_data.shop == currentShopId then
								table.insert(list, { model = model, data = vehicle_data })
							end
						end

						table.sort(list, function(a,b)
							return a.data.cost < b.data.cost
						end)

						local w,h = 252,152
						local padding = 10

						local startX = 0

						for index, vehicle in pairs(list) do

							local c_element = element:addElement(
								{'element',

									startX, 'center',
									w,h,
									color = {32,35,66,255},

									index = index,

									vehicle = vehicle,

									onInit = function(element)
										element.y0 = element[3]
									end,

									onRender = {

										function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											element[3] = element.y0 - 5*element.animData

											local r,g,b = interpolateBetween(32,35,66, 49,55,89, element.animData, 'InOutQuad')

											dxDrawImage(
												x + w/2 - 270/2,
												y + h/2 - 170/2 + 5,
												270, 170, 'assets/images/item_bg_shadow.png',
												0, 0, 0, tocolor(0,0,0,255*alpha)
											)

											dxDrawImage(
												x,y,w,h, 'assets/images/item_bg.png',
												0, 0, 0, tocolor(r,g,b,255*alpha)
											)


										end,

										function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local path = string.format('assets/images/vehicles/%s.png', element.vehicle.model)

											local tw,th = w*0.9,h*0.9

											if fileExists( path ) then
												dxDrawImage(
													x+w/2-tw/2,y+h/2-th/2 - 5,tw,th, path,
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)
											end

											element.s_animId = element.s_animId or {}

											local s_animData, s_target = getAnimData(element.s_animId)

											if not s_animData then
												setAnimData(element.s_animId, 0.2, 0)
												s_animData = 0
											end

											animate(element.s_animId, (element.parent.selected_item == element) and 1 or 0 )

											dxDrawImage(
												x,y,w,h, 'assets/images/item_bg_active.png',
												0, 0, 0, tocolor(180,70,70,255*alpha*s_animData)
											)

											local name = string.format('%s %s',
												element.vehicle.data.mark,
												element.vehicle.data.name
											)

											local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
											local textWidth = dxGetTextWidth(name, scale, font)

											if s_target == 1 and textWidth > w*0.4 then
												name = element.vehicle.data.name
											end

											local textWidth = dxGetTextWidth(name, scale, font)


											local cx = x+w/2- textWidth/2
											local lx = x + 30

											local tx = cx - (cx-lx)*s_animData

											dxDrawText(name,
												tx,y+h-15,
												tx,y+h-15,
												tocolor(255,255,255,255*alpha),
												scale, scale, font,
												'left', 'bottom'
											)

											local _,_,_, anim = unpack( divideAnim( s_animData, 4 ) )

											dxDrawText('Выбрано',
												x+w-30,y+h-15,
												x+w-30,y+h-15,
												tocolor(160,160,160,255*alpha*anim),
												scale, scale, font,
												'right', 'bottom'
											)

										end,

									},

									onClick = function(element)

										element.parent.selected_item = element

										animate('buying', 0)
										setPreviewModel(element.vehicle.model, element.parent.v_color)

									end,

								}
							)

							startX = startX + w + padding

							if index == 1 then
								c_element:callHandler('onClick')
							end

						end

					end,

					onInit = function(element)

						element.cl_animId = element.cl_animId or {}
						setAnimData(element.cl_animId, 0.1)

					end,

					overflow = 'horizontal',
					scroll_step = 300,

					elements = {



					},

				},

			},

		},


	},


}

--------------------------------------------------------

loadGuiModule()
hideBackground = true
blurBackground = false


end)


