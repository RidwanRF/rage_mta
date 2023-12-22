

cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f6'] = true,
	['f7'] = true,
	['f10'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
}


openHandler = function()

	if currentWindowSection == 'destroy' or currentWindowSection == 'main' then
		triggerServerEvent('vehicles.catchVehicleInfo', root, localPlayer.vehicle:getData('id'))
	end

	hideBackground = currentWindowSection == 'buy_vehicle'

	showChat( false )

end

closeHandler = function()
	
	showChat( true )

end

addEventHandler('onClientResourceStart', resourceRoot, function()


windowModel = {

	main = {

		{'image',

			'center', 'center',
			762, 675,
			color = {25,24,38,255},
			'assets/images/sell_bg.png',

			variable = 'sellWindow',

			addEvent('vehicles.catchVehicleInfo', true),
			addEventHandler('vehicles.catchVehicleInfo', root, function( data )
				sellWindow.current_tuning = fromJSON(data.appearance_upgrades or '[[]]') or {}
			end),

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/sell_bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				if not localPlayer.vehicle and windowOpened then
					return closeWindow()
				end

				if not localPlayer.vehicle then return end

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/destroy_bg1.png',
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				local text = {
					('• Автомобиль выставляется на срок #cd4949%s#b4b4b4 дней'):format( Config.rentDays ),
					'• При продаже транспорта вы вносите залог #cd4949$' .. splitWithPoints( Config.rentCost, '.' ),
					'#b4b4b4• Залог вернется вам, если вы продадите ваш автомобиль',
					'• Залог #cd4949НЕ#b4b4b4 возвращается, если автомобиль не будет продан',
					'• При продаже деньги начислятся автоматически',
					('• Комиссия на продажу автомобиля на авторынке - #cd4949%s%%#b4b4b4'):format( Config.sellComission ),
				}

				dxDrawText(table.concat( text, ';\n' ),
					x + 170, y+h-130,
					x + 170, y+h-130,
					tocolor(180,180,180,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
					'left', 'bottom', false, false, false, true
				)

				local iw,ih = 72, 47
				local ix,iy = x + 50, y + 50

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/dline.png',
					0, 0, 0, tocolor( 200,90,90,255*alpha )
				)

				dxDrawText('Продажа автомобиля',
					ix+iw, iy,
					ix+iw, iy+ih,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'left', 'center'
				)

				local vehicle_name = exports.vehicles_main:getVehicleModName( localPlayer.vehicle )

				dxDrawText(vehicle_name,
					ix+20, iy+ih-10,
					ix+20, iy+ih-10,
					tocolor(250,190,130,255*alpha),
					0.5, 0.5, getFont('hb_medium', 34, 'light'),
					'left', 'top'
				)

				local d_cost = exports.vehicles_main:getVehicleCost( localPlayer.vehicle )
				local t_cost = exports.vehicles_tuning:getTuningCost( localPlayer.vehicle.model, destroyWindow.current_tuning or {} )
				t_cost = math.floor( t_cost * Config.destroy_cost_percent/100 )

				local vehicle_cost = exports.vehicles_main:getVehicleCost( localPlayer.vehicle ) or 0
				local max = ( vehicle_cost * 3 )

				local s_cost = math.min( max, math.floor( d_cost * Config.destroy_cost_percent/100 ) + t_cost )

				local blocks = {
					{
						head = 'Гос. стоимость',
						text = splitWithPoints( d_cost, '.' ),
						color = { 255,255,255 },
					},
					{
						head = 'Рекомендуемая цена',
						text = splitWithPoints( s_cost, '.' ),
						color = { 0, 250, 155 },
					},
					{
						head = 'Оценка тюнинга',
						text = splitWithPoints( t_cost, '.' ),
						color = { 255,255,255 },
					},
				}

				local bw,bh = 188,84
				local padding = 40

				local sCount = #blocks/2

				local startX = x+w/2-sCount*bw - (sCount-0.5)*padding
				local startY = y + 170

				for _, block in pairs( blocks ) do

					dxDrawImage(
						startX, startY,
						bw,bh, 'assets/images/ditem.png',
						0, 0, 0, tocolor( 21,21,33,255*alpha )
					)

					dxDrawText(block.head,
						startX, startY + 15,
						startX+bw, startY + 15,
						tocolor(140,140,140,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
						'center', 'top'
					)

					local r,g,b = unpack( block.color )

					dxDrawText(block.text,
						startX, startY + bh - 15,
						startX+bw, startY + bh - 15,
						tocolor(r,g,b,255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 34, 'light'),
						'center', 'bottom'
					)

					startX = startX + bw + padding

				end

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 42 end, 42,
					33, 33,
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

					onClick = closeWindow,

				},

				{'input',

					'center',
					300,
					448, 59,

					bg = 'assets/images/sell_input.png',

					color = { 22,21,34,255 },
					'',

					type = 'number',

					font = getFont('montserrat_semibold', 22, 'light'),
					scale = 0.5,

					alignX = 'center',

					variable = 'sellInput',

					onInput = function(element)

						local value = tonumber( element[6] or '' ) or 0
						local vehicle_cost = exports.vehicles_main:getVehicleCost( localPlayer.vehicle ) or 0

						local max = ( vehicle_cost * 3 )
						element[6] = tostring( math.clamp( value, 0, max ) )

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Желаемая стоимость',
							x + 10, y + h + 10,
							x + 10, y + h + 10,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'left', 'top'
						)

						dxDrawText('Не более 300% от гос. стоимости',
							x + w - 10, y + h + 10,
							x + w - 10, y + h + 10,
							tocolor(160,160,160,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'right', 'top'
						)

					end,

				},

				{'button',

					'center',
					function(s,p) return p[5] - s[5] - 40 end,
					215, 46,

					bg = 'assets/images/dbtn_empty.png',
					activeBg = 'assets/images/dbtn.png',

					color = { 200,80,80,255 },
					'Выставить на продажу',

					font = getFont('montserrat_bold', 19, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/dbtn_empty_shadow.png'] = (1-element.animData),
							['assets/images/dbtn_shadow.png'] = element.animData,
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

						if not localPlayer.vehicle then return end

						local vehicle_id = localPlayer.vehicle:getData('id')
						if not vehicle_id then return end

						local cost = tonumber( sellInput[6] ) or 0

						if cost <= 0 then
							return exports.hud_notify:notify('Ошибка', 'Введите стоимость')
						end

						triggerServerEvent('used.sellVehicle', resourceRoot, vehicle_id, cost)
					end,

				},


			},

		},

	},

	destroy = {

		{'image',

			'center', 'center',
			762, 487,
			color = {25,24,38,255},
			'assets/images/destroy_bg.png',

			variable = 'destroyWindow',

			addEvent('vehicles.catchVehicleInfo', true),
			addEventHandler('vehicles.catchVehicleInfo', root, function( data )
				destroyWindow.current_tuning = fromJSON(data.appearance_upgrades or '[[]]') or {}
			end),

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/destroy_bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				if not localPlayer.vehicle and windowOpened then
					return closeWindow()
				end

				if not localPlayer.vehicle then return end

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/destroy_bg1.png',
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				local text = {
					'Вы можете отправить любой свой автомобиль на разборку.',
					'Денежные средства придут на ваш счет мгновенно.',
					'Стоимость разборки ниже рыночной стоимости.',
					'Если вы считаете свой автомобиль уникальным,',
					'вы можете продать его на авторынке.',
				}

				dxDrawText(table.concat( text, '\n' ),
					x, y+h-130,
					x+w, y+h-130,
					tocolor(180,180,180,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'bottom'
				)

				local iw,ih = 72, 47
				local ix,iy = x + 50, y + 50

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/dline.png',
					0, 0, 0, tocolor( 200,90,90,255*alpha )
				)

				dxDrawText('Разбор автомобиля',
					ix+iw, iy,
					ix+iw, iy+ih,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'left', 'center'
				)

				local vehicle_name = exports.vehicles_main:getVehicleModName( localPlayer.vehicle )

				dxDrawText(vehicle_name,
					ix+20, iy+ih-10,
					ix+20, iy+ih-10,
					tocolor(250,190,130,255*alpha),
					0.5, 0.5, getFont('hb_medium', 34, 'light'),
					'left', 'top'
				)

				local d_cost = exports.vehicles_main:getVehicleCost( localPlayer.vehicle )
				local t_cost = exports.vehicles_tuning:getTuningCost( localPlayer.vehicle.model, destroyWindow.current_tuning or {} )
				t_cost = math.floor( t_cost * Config.destroy_cost_percent/100 )
				local s_cost = math.floor( d_cost * Config.destroy_cost_percent/100 ) + t_cost

				local blocks = {
					{
						head = 'Гос. стоимость',
						text = splitWithPoints( d_cost, '.' ),
						color = { 255,255,255 },
					},
					{
						head = 'Вы получите',
						text = splitWithPoints( s_cost, '.' ),
						color = { 0, 250, 155 },
					},
					{
						head = 'Оценка тюнинга',
						text = splitWithPoints( t_cost, '.' ),
						color = { 255,255,255 },
					},
				}

				local bw,bh = 188,84
				local padding = 40

				local sCount = #blocks/2

				local startX = x+w/2-sCount*bw - (sCount-0.5)*padding
				local startY = y + 140

				for _, block in pairs( blocks ) do

					dxDrawImage(
						startX, startY,
						bw,bh, 'assets/images/ditem.png',
						0, 0, 0, tocolor( 21,21,33,255*alpha )
					)

					dxDrawText(block.head,
						startX, startY + 15,
						startX+bw, startY + 15,
						tocolor(140,140,140,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
						'center', 'top'
					)

					local r,g,b = unpack( block.color )

					dxDrawText(block.text,
						startX, startY + bh - 15,
						startX+bw, startY + bh - 15,
						tocolor(r,g,b,255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 34, 'light'),
						'center', 'bottom'
					)

					startX = startX + bw + padding

				end

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 42 end, 42,
					33, 33,
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

					onClick = closeWindow,

				},

				{'button',

					'center',
					function(s,p) return p[5] - s[5] - 40 end,
					215, 46,

					bg = 'assets/images/dbtn_empty.png',
					activeBg = 'assets/images/dbtn.png',

					color = { 200,80,80,255 },
					'Отправить на разборку',

					font = getFont('montserrat_bold', 19, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/dbtn_empty_shadow.png'] = (1-element.animData),
							['assets/images/dbtn_shadow.png'] = element.animData,
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
						triggerServerEvent('used.orderVehicleBreak', resourceRoot)
					end,

				},


			},

		},

	},

	enter = {
	
		{'image',

			'center', 'center',
			510, 376,
			color = {25,24,38,255},
			'assets/images/enter_bg.png',

			variable = 'enterWindow',
			
			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/enter_bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2+5

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = {

				title = function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawText('Выберите этаж авторынка',
						x + 53, y + 35,
						x + 53, y + 35,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('hb_medium', 25, 'light'),
						'left', 'top'
					)

				end,

				buttons = function(element)

					local s_alpha = 0.3

					local cx,cy = getCursorPosition()
					if not cx then return end
					cx,cy = cx*sx, cy*real_sy * sx/real_sx

					local tx,ty = cx,cy

					for index, button in pairs( element.buttons ) do


						local bx,by,bw,bh = button:abs()
						local btx,bty = bx+bw/2, by+bh/2

						local dist = getDistanceBetweenPoints2D( tx,ty, btx,bty )

						s_alpha = 0.3 + 0.7*(1-math.clamp(dist/200, 0, 1))

						if button == element.selected_button then
							s_alpha = 1
						end

						animate( button.animationAlpha, s_alpha )

					end


				end,

			},

			onInit = function(element)

				local x,y,w,h = element:abs()

				element.buttons = {}

				local bw,bh = 47,43
				local padding_x, padding_y = 15, 15

				local sCount = 3.5

				local _startX = w/2 - bw * sCount - padding_x*(sCount-0.5)
				local startX = _startX
				local startY = 90

				local index = 0

				for i1 = 1,3 do

					for i2 = 1,7 do

						local b_element = element:addElement(
							{'button',

								startX, startY,
								bw, bh,

								bg = 'assets/images/etab_empty.png',
								activeBg = 'assets/images/etab.png',

								color = { 200,80,80,255 },
								activeColor = { 230,90,90,255 },
								index > 0 and index or '',

								font = getFont('hb_medium', 24, 'light'),
								scale = 0.5,

								index = index,

								onInit = function(element)
									element.animationAlpha = {}
									setAnimData( element.animationAlpha, 0.1, 0.6 )
								end,

								onRender = index == 0 and (function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									dxDrawImage(
										x,y,w,h, 'assets/images/exit.png',
										0, 0, 0, tocolor(255,255,255,255*alpha)
									)

								end) or 0,

								onPreRender = function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									local anim = element.parent.selected_button == element and 1 or element.animData

									local shadow = {
										['assets/images/etab_shadow.png'] = anim,
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

									if element.parent.selected_button == element then
										element.bg ='assets/images/etab.png'
									else
										element.bg ='assets/images/etab_empty.png'
									end

								end,

								onClick = function(element)
									element.parent.selected_button = element
								end,

							}
						)

						table.insert( element.buttons, b_element )

						index = index + 1

						startX = startX + padding_x + bw

					end

					startX = _startX
					startY = startY + padding_y + bh

				end


			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 45 end,
					function(s,p) return p[5] - s[5] - 50 end,
					177, 51,

					bg = 'assets/images/ebtn.png',

					color = { 200,80,80,255 },
					activeColor = { 230,90,90,255 },
					'Войти',

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/ebtn_shadow.png'] = (element.animData),
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

						if element.parent.selected_button then

							triggerServerEvent('used.goToFloor', resourceRoot, element.parent.selected_button.index)
							closeWindow()

						end

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 45 - 177 - 10 end,
					function(s,p) return p[5] - s[5]/2 - 50 - 51/2 end,
					120, 40,

					bg = false,
					define_from = '',

					'Отмена',

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},
					textColor = { 170,170,170,255 },

					onClick = closeWindow,

				},


			},

		},

	},

	buy_vehicle = {

		{'element',

			0, 'center',
			700, '100%',
			color = {255,255,255,255},

			onRender = function(element)

				local data = currentVehicleMarketData

				if not data then
					return closeWindow()
				end

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local gradient = getTextureGradient( whiteTexture , {
					color = {
						{ 0, 0, 0, 0 },
						{ 180, 70, 70, 50 },
					},
					alpha = alpha,
					angle = -30,
				})

				dxDrawRectangle(
					x,y,w,h, tocolor(25,24,38, 150*alpha)
				)

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawText(data.vehicle_name,
					x + 100, y + 100,
					x + 100, y + 100,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('hb_medium', 35, 'light'),
					'left', 'top'
				)

				local ix,iy, iw,ih = x + 100, y + 145, 25, 25

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/money.png',
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				dxDrawText(splitWithPoints( data.cost or 0, '.' ),
					ix + iw + 7, iy, 
					ix + iw + 7, iy+ih,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
					'left', 'center'
				)

			end,

			elements = {

				{'rectangle',
					100, 350,
					1, 320,
					color = { 120, 120, 120, 255 },

					onRender = function(element)

						local data = currentVehicleMarketData

						if not data then
							return
						end

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local cover_types = {
							default = 'Стандартный',
							mat = 'Мат',
							perlamutr = 'Перламутр',
							chrome = 'Хром',
						}

						local wheels = (data.vehicle:getData('wheels') or 0)
						local plate = (data.vehicle:getData('plate') or '')

						local values = {

							{
								head = 'Стробоскопы',
								value = (data.vehicle:getData('strobo') or 0) > 0 and 'Установлено' or false,
							},

							{
								head = 'Рамка шторка',
								value = (data.vehicle:getData('plate_curtain') or 0) > 0 and 'Установлено' or false,
							},

							{
								head = 'СГУ',
								value = (data.vehicle:getData('sirens') or 0) > 0 and 'Установлено' or false,
							},

							{
								head = 'Номерная рамка',
								value = (data.vehicle:getData('license_frame') or 0) > 0 and 'Установлено' or false,
							},

							{
								head = 'ФСО Вспышки',
								value = (data.vehicle:getData('fso') or 0) > 0 and 'Установлено' or false,
							},

							{
								head = 'Материал покраски',
								value = cover_types[ data.vehicle:getData('coverType') or 'default' ],
							},

							{
								head = 'Диски',
								value = wheels > 0 and ('Диски #%s'):format( wheels ) or false,
							},

							{
								head = 'Номер',
								value = utf8.len(plate) > 0 and exports.vehicles_manager:convertNumberplateToText( plate ) or false,
							},


						}

						local index = 1

						local _startX = x + 40
						local startX = _startX
						local startY = y - 20

						local padding_x, padding_y = 230, 75

						local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
						local textHeight = dxGetFontHeight( scale, font )

						for i1 = 1, 4 do

							for i2 = 1, 2 do

								local text = values[index]

								dxDrawText(text.head,
									startX, startY,
									startX, startY,
									tocolor(140, 140, 140, 255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
									'left', 'top'
								)

								local value = text.value or 'Не установлено'

								dxDrawText(value,
									startX, startY + 25,
									startX, startY + 25,
									tocolor(150, 150, 150, 255*alpha),
									scale, scale, font,
									'left', 'top'
								)

								if not text.value then

									local textWidth = dxGetTextWidth( value, scale, font )

									local iw,ih = 20, 20
									local ix,iy = startX + textWidth/2 - iw/2, startY + 25 + textHeight/2 - ih/2

									dxDrawImage(
										ix,iy,iw,ih, 'assets/images/not_installed.png',
										0, 0, 0, tocolor(255,255,255,255*alpha)
									)

								end

								startX = startX + padding_x
								index = index + 1

							end

							startX = _startX
							startY = startY + padding_y

						end

						startY = startY - 10

						dxDrawText('Оценочная стоимость тюнинга',
							_startX, startY + 20, 
							_startX, startY + 20,
							tocolor(140, 140, 140, 255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'left', 'top'
						)

						local iw,ih = 24,24
						local ix,iy = _startX, startY + 45

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/money.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						local t_cost = exports.vehicles_tuning:getTuningCost( data.vehicle.model, data.tuning or {} )

						dxDrawText( splitWithPoints( t_cost, '.' ),
							ix + iw + 5, iy,
							ix + iw + 5, iy+ih,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'left', 'center'
						)


					end,

				},

				{'element',
					'center', function(s,p) return p[5] - s[5] - 200 end,
					'100%', 51,
					color = {255,255,255,255},

					elements = {
					
						{'button',

							150,
							'center',
							238, 51,

							bg = 'assets/images/bbtn.png',

							color = { 200,80,80,255 },
							'Приобрести автомобиль',

							font = getFont('montserrat_bold', 19, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/bbtn_shadow.png'] = element.animData,
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

								local data = currentVehicleMarketData

								if not data then
									return
								end

								element[6] = data.owner == localPlayer:getData('unique.login') and 'Снять с продажи' or 'Приобрести автомобиль'

							end,

							onClick = function(element)

								local data = currentVehicleMarketData

								if not data then
									return
								end

								if data.owner == localPlayer:getData('unique.login') then
									triggerServerEvent('used.takeVehicle', resourceRoot, data.slot)
								else
									triggerServerEvent('used.buyVehicle', resourceRoot, data.slot)
								end

								closeWindow()

							end,

						},

						{'button',

							400, 'center',
							120, 40,

							bg = false,
							define_from = '',

							'Отмена',

							font = getFont('montserrat_semibold', 24, 'light'),
							scale = 0.5,

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},
							textColor = { 170,170,170,255 },

							onClick = closeWindow,

						},

					},

				},

			},

		},

	},

}

loadGuiModule()



end)
