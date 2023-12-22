
openHandlers = {
	
	function()

		triggerServerEvent('vehicles.sendPlayerVehicles', root)

		vehiclesList.listElements = {}
		vehiclesList.lastSelectedItem = false
		vehiclesList.selectedItem = false

	end,

}

closeHandlers = {

	function()

		vehiclesList.listElements = {}
		vehiclesList.lastSelectedItem = false
		vehiclesList.selectedItem = false

	end,

}

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			553, 540, 
			'assets/images/bg.png',
			color = {25,24,38, 255},

			onRender = {

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					dxDrawImage(
						x + w/2 - 593/2,
						y + h/2 - 580/2,
						593, 580, 'assets/images/bg_shadow.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local texture = getDrawingTexture('assets/images/icon_bg.png')
					local gradient = getTextureGradient(texture, {
						texture = texture,
						alpha = alpha,
						angle = -45,
						color = {
							{ 86, 56, 79, 255 },
							{ 180, 70, 70, 255 },
						},
					})

					dxDrawImage(
						x,y,w,h, 'assets/images/bg1.png',
						0, 0, 0, tocolor(255,255,255,30*alpha)
					)

					dxDrawImage(
						x + 35, y + 25, 38, 38, gradient
					)

					dxDrawImage(
						x + 35 + 38/2 - 40/2, y + 25 + 38/2 - 40/2, 40, 40, 'assets/images/taxi.png',
						0, 0, 0, tocolor(40, 40, 40, 255*alpha)
					)

					dxDrawText('Станция такси',
						x + 35 + 38 + 15, y + 25,
						x + 35 + 38 + 15, y + 25 + 38,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
						'left', 'center'
					)

				end,
			},

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

				{'element',

					'center', 400,
					390, 40,
					color = {255,255,255,255},

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Выберите транпорт для начала работы',
							x,y-20,x+w,y-20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'center', 'bottom'
						)

					end,

					elements = {

						{'button',

							'left', 'center',
							[6]='Арендованный',

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText(string.format('Стоимость - #cd4949$#ffffff%s#5a5a73\nТранспорт - #ffffff%s',
									splitWithPoints( Config.lease.cost, '.' ), exports.vehicles_main:getVehicleModName( Config.lease.model )
								),
									x,y+h+10,x+w,y+h+10,
									tocolor(90,90,115,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
									'center', 'top', false, false, false, true
								)

							end,

							onClick = function(element)

								dialog('Начало работы', {
									'Вы действительно хотите',
									string.format('арендовать автомобиль за #cd4949$%s#ffffff ?',
										splitWithPoints( Config.lease.cost, '.' )
									)
								}, function(result)

									if result then

										local x,y,w,h = element:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-30/2, y+h/2-30/2, 30, 30}, {180,70,70,255}, 800, function()

											animate(element.animationAlpha, 1)
											triggerServerEvent('taxi.start', resourceRoot, currentStationId)

											closeWindow()


										end )

									end

								end)

							end,

						},


						{'button',

							'right', 'center',
							[6]='Личный',

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText(string.format('Требуется игровой стаж\nболее #ffffff%s#5a5a73 часов',
									Config.ownVehiclesRequirement
								),
									x,y+h+10,x+w,y+h+10,
									tocolor(90,90,115,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
									'center', 'top', false, false, false, true
								)

								if exports.main_levels:getPlayerLevel(localPlayer) < Config.ownVehiclesRequirement then

									element.activeBg = nil
									element.disabled = true

									mta_dxDrawImage(
										px(x)-1,px(y)-1,px(w)+2,px(h)+2, 'assets/images/btn.png',
										0, 0, 0, tocolor(22,22,33,200*alpha)
									)

									dxDrawImage(
										x+w/2-40/2, y+h/2-40/2, 40,40,
										'assets/images/block.png',
										0, 0, 0, tocolor(255,255,255,255*alpha)
									)

								else

									element.disabled = false
									element.activeBg = 'assets/images/btn.png'

								end



							end,

							onClick = function(element)

								if exports.main_levels:getPlayerLevel(localPlayer) >= Config.ownVehiclesRequirement then
									currentWindowSection = 'select_vehicle'
								end

							end,

						},

					},

				},

				{'rectangle',

					'center', 120,
					'100%', 225,
					color = {0,0,0,100},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выбери автомобиль для работы, принимай\nзаказы и развози клиентов по карте',
							x,y+25,x+w,y+25,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
							'center', 'top'
						)


					end,

					elements = {
						{'element',

							'center', 'bottom',
							300, 140, 
							color = {255,255,255,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText('Статистика',
									x,y,x,y,
									tocolor(100, 100, 110, 255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
									'left', 'top'
								)

								local stats = exports.jobs_main:getPlayerStats( localPlayer )


								local rows = {
									{ name = 'Заработано за все время', value = string.format('$%s', splitWithPoints( stats.raised_money or 0, '.' )) },
									{ name = 'Суммарный стаж', value = string.format('%sч.', math.floor( (stats.total_xp or 0)/3600 )) },
									{ name = 'Выполнено заказов', value = (stats.orders_passed or 0) },
									{ name = 'Заработано за сессию', value = string.format('$%s', splitWithPoints(
										localPlayer:getData('job.session_stats.job_taxi.raised_money') or 0, '.' )) },
								}

								local startY = y + 30

								for _, row in pairs( rows ) do

									dxDrawText(row.name,
										x,startY,x,startY,
										tocolor(100, 100, 110, 255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'left', 'top'
									)

									dxDrawText(row.value,
										x + w,startY,x + w,startY,
										tocolor(255, 255, 255, 255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'right', 'top'
									)

									startY = startY + 22

								end

							end,

						},
					},

				},


			},

		},

	},


	select_vehicle = {

		{'image',
			'center', 'center',
			404, 428, 
			'assets/images/sbg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 422/2,
					y + h/2 - 446/2 + 5,
					422, 446, 'assets/images/sbg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Выберите автомобиль',
					x,y+25+13, x+w, y+25+13,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
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

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'list',

					'center', 70,
					'100%', 270,

					scrollBg = scrollTexture,

					scrollColor = {180, 70, 70,255},
					scrollBgColor = {18,18,28,255},

					scrollWidth = 4,
					scrollHeight = 0.7,
					scrollXOffset = -30,

					listOffset = 0,

					listElements = {
						
					},

					font = getFont('montserrat_semibold', 26, 'bold'),
					scale = 0.5,

					listElementHeight = 55,

					color = {255,255,255,255},

					onInit = function(element)
						vehiclesList = element
					end,

					addEvent('vehicles.getPlayerVehicles', true),
					addEventHandler('vehicles.getPlayerVehicles', root, function(vehicles)

						for _, vehicle in pairs( vehicles ) do
							vehicle.cost = exports.vehicles_main:getVehicleCost(vehicle.model)
							vehicle.name = exports.vehicles_main:getVehicleModName(vehicle.model)
							vehicle.plate = exports.vehicles_manager:convertNumberplateToText(vehicle.plate)
						end

						vehiclesList.listElements = vehicles

					end),

					additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

						local alpha = element:alpha()
						local ex,ey,ew,eh = element:abs()

						local w,h = 333, 48
						local x,y = 0+ew/2-w/2, y+element.listElementHeight/2-h/2

						local r,g,b = interpolateBetween( 18,18,28, 180, 70, 70, animData, 'InOutQuad' )

						dxDrawImage(
							x,y,w,h, 'assets/images/item_bg.png',
							0, 0, 0, tocolor(r,g,b, 255*alpha)
						)

						dxDrawText(lElement.name,
							x + 20, y,
							x + 20, y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'center'
						)

						dxDrawText(lElement.plate,
							x + w - 20, y,
							x + w - 20, y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'right', 'center'
						)

					end,

				},


				{'button',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					[6]='Начать работу',


					onClick = function(element)

						if not vehiclesList.lastSelectedItem then
							return exports.hud_notify:notify('Ошибка', 'Автомобиль не выбран')
						end

						local x,y,w,h = element:abs()

						animate(element.animationAlpha, 0)
						displayLoading( {x+w/2-30/2, y+h/2-30/2, 30, 30}, {180,70,70,255}, 800, function()

							animate(element.animationAlpha, 1)
							triggerServerEvent('taxi.start', resourceRoot, currentStationId, vehiclesList.lastSelectedItem.id)

							closeWindow()


						end )


					end,

				},

			},

		},

	},

}

-----------------------------------------------------------------

	GUIDefine('button', {

		[4]=183, [5]=40,

		bg = 'assets/images/btn_empty.png',
		activeBg = 'assets/images/btn.png',

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_medium', 22, 'light'),

		onPreRender = function(element)

			if element.disabled then return end

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 201/2, y + h/2 - 57/2, 201, 57

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/btn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		onInit = function(element)
			element.animationAlpha = {}
			setAnimData(element.animationAlpha, 0.1, 1)
		end,

	})

-----------------------------------------------------------------

loadGuiModule()

end)
