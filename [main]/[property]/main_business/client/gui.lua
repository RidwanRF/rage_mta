
openHandler = function()
	if currentWindowSection ~= 'creation' then
		clearAllInputs()
	end
end
closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			449, 480,
			color = {32,35,66,255},
			'assets/images/bg.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 467/2,
					y + h/2 - 498/2 + 5,
					467, 498, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local gradient = getTextureGradient(getDrawingTexture(element[6]), {
					angle = 30,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 35 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				local text = 'Информация о бизнесе'
				local scale, font = 0.5, getFont('montserrat_semibold', 27, 'light')

				local textWidth = dxGetTextWidth(text, scale, font)
				local fontHeight = dxGetFontHeight(scale, font)

				local add = 70

				dxDrawText(text,
					x,y+add,x+w,y+add,
					tocolor(255,255,255,255*alpha),
					scale, scale, font,
					'center', 'top'
				)

				local hw,hh = 55,23

				dxDrawImage(
					x+w/2-textWidth/2-10, y+add+fontHeight-5,
					hw,hh, 'assets/images/hline.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				local team_name = 'Отсутствует'

				if teamWindow.team then
					team_name = teamWindow.team.name
				end


				local rows = {

					{ name = 'ID Бизнеса', value = currentBusinessData.id or 0 },
					{ name = 'Владелец', value = currentBusinessData.owner or '' },
					{ name = 'Стоимость', value = string.format('%s $', splitWithPoints(currentBusinessData.cost or 0, '.')) },
					{ name = 'Выплата', value = string.format('%s $', splitWithPoints(currentBusinessData.payment_sum or 0, '.')) },
					{ name = 'Банк', value = string.format('%s $', splitWithPoints(currentBusinessData.balance or 0, '.')) },

				}
				iprint(currentBusinessData)
				if currentBusinessData.clan_area_type then

					local types = exports.teams_main:getConfigSetting('areasData')
					local amount = types[ currentBusinessData.clan_area_type or 1 ].income or 0

					table.insert( rows, { name = 'Банда', value = team_name })
					table.insert( rows, { name = 'Прибыль банды', value = string.format('%s $', splitWithPoints(amount or 0, '.')) })

				end

				local startY = y + 130

				for _, row in pairs(rows) do

					dxDrawText(row.name,
						x+60,startY,
						x+60,startY,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
						'left', 'center'
					)
					dxDrawText(row.value,
						x+w-60,startY,
						x+w-60,startY,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
						'right', 'center'
					)

					startY = startY + 30

				end

			end,


			elements = {

				{'button',

					0, 0, 30, 30,
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

					0, 0, 30, 30,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 20 - element[4] - 5
						element[3] = 25

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/settings.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function(element)
						openBusinessEdit()
					end,

					noDraw = function(element)
						return not exports.acl:isAdmin(localPlayer)
					end,

				},

				{'element',
					'center', 350,
					305, 95,
					color = {255,255,255,255},

					onInit = function(element)

						local x,y,w,h = element:abs()

						local bw,bh = 144, 41

						local buttons = {

							{
								name = 'Продать в гос.',
								action = function(element)

									dialog('Продажа бизнеса', {
										'Вы действительно хотите продать бизнес',	
										string.format('за %s $?',
											splitWithPoints( (

												(currentBusinessData.donate == 1) and (
													currentBusinessData.cost * Config.sellMul * Config.donateConvertMul
												) or ( currentBusinessData.cost * Config.sellMul )

											), '.' )
										),	
									}, function(result)

										if result then
											triggerServerEvent('business.sell', resourceRoot, currentBusinessData.id)
											closeWindow()
										end

									end)

								end,
								for_owner = true,
								coords = {'left', 'top'},
							},
							{
								name = 'Продать игроку',
								action = function(element)

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

											triggerServerEvent('business.sellPlayer', resourceRoot, currentBusinessData.id, data[2], data[1])
											closeWindow()

										end


									end)

								end,
								for_owner = true,
								coords = {'right', 'top'},
							},
							{
								name = 'Снять деньги',
								action = function(element)

									dialog_input('Вывод денег', 'Введите сумму вывода', {
										{ type = 'number', params = { placeholder = 'Сумма', } },
									}, function(data)

										if data then
											triggerServerEvent('business.takeMoney', resourceRoot, currentBusinessData.id, data[1])
										end

									end)


								end,
								for_owner = true,
								coords = {'left', 'bottom'},
							},
							{
								name = 'Выйти',
								action = function(element)
									closeWindow()
								end,
								coords = {'right', 'bottom'},
							},

						}

						for _, button in pairs(buttons) do

							element:addElement(
								{'button',

									button.coords[1], button.coords[2],
									bw,bh,

									bg = 'assets/images/button_empty.png',
									activeBg = 'assets/images/button.png',
									button.name,

									data = button,

									scale = 0.5,
									font = getFont('montserrat_bold', 19, 'light'),

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onInit = function(element)
										element.animationAlpha = {}
										setAnimData(element.animationAlpha, 0.1, 1)
									end,


									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 175/2, y + h/2 - 75/2, 175, 75


										if not element.data.for_owner or currentBusinessData.owner == localPlayer:getData('unique.login') then

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
											)

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/button_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
											)

											element.activeBg = 'assets/images/button.png'
											animate(element.animationAlpha, 1)

										else

											animate(element.animationAlpha, 0.5)
											element.activeBg = false

										end

									end,

									onClick = function(element)

										if element.data.for_owner then

											if currentBusinessData.owner == localPlayer:getData('unique.login') then
												element.data.action(element)
											end

										else
											element.data.action(element)
										end

									end,


								}
							)

						end


					end,

				},

			},

		},

		{'image',

			'center', sy/2 + 480/2 + 20,
			449, 80,
			'assets/images/teambg.png',
			-- createTextureSource('bordered_rectangle', 'assets/images/teambg.png', 22, 449, 80),
			color = {32,35,66,255},

			variable = 'teamWindow',

			noDraw = function(element)
				return (not localPlayer:getData('team.id')) or ( not currentBusinessData.clan_area_type )
			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/teambg_art.png',
					0, 0, 0, tocolor(255,255,255,100*alpha)
				)

				if element.team then

					local team_icon = element.team:getData('team.icon') or 1
					local r,g,b = 255,255,255
					-- local r,g,b = hexToRGB( team_data.color or '#ffffff' )

					drawSmartText(string.format('<img>:teams_main/assets/images/icons/%s.png</img> %s',
						team_icon, element.team.name
					),
						x+25, x+25, y+30,
						tocolor(r,g,b,255*alpha),
						tocolor(255,255,255,255*alpha),
						0.5, getFont('montserrat_bold', 45, 'light'),
						'left', 50, -15, 3
					)

					local scale, font = 0.5, getFont('montserrat_semibold', 22, 'light')

					local text = 'Деньги: #cd4949$' .. splitWithPoints( currentBusinessData.clan_bank or 0, '.' )

					local textWidth = dxGetTextWidth( text, scale, font, true )

					element.take_button[2] = 25 + textWidth + 4
					element.take_button[3] = 55 - element.take_button[5]/2

					dxDrawText(text,
						x + 25, y + 55,
						x + 25, y + 55,
						tocolor(255,255,255,255*alpha),
						scale, scale, font,
						'left', 'center', false, false, false, true
					)

				else

					dxDrawText('Свободная территория',
						x + 35, y,
						x + 35, y+h,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
						'left', 'center'
					)

				end


			end,

			onInit = function(element)

				openHandlers.team_actions = function()

					if currentWindowSection == 'main' then
						teamWindow:loadActions()

						if currentBusinessData.clan then
							teamWindow.team = exports.teams_main:findTeamById( currentBusinessData.clan )
						else
							teamWindow.team = false
						end

					end

				end

			end,

			loadActions = function(element)

				local localTeam = localPlayer:getData('team.id')
				local actions = {}

				if not currentBusinessData.clan then

					actions = {
						{

							name = 'Захватить',
							action = function(element)

								if not exports.teams_main:hasPlayerRight(localPlayer, 'area_capture') then
									return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
								end

								triggerServerEvent('team_area.capture', resourceRoot, currentBusinessData.id)
								closeWindow()

							end,

						},
					}

				elseif currentBusinessData.clan == localTeam then

					actions = {
						{

							name = 'Покинуть',
							action = function(element)

								if not exports.teams_main:hasPlayerRight(localPlayer, 'area_capture') then
									return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
								end

								dialog('Покинуть бизнес', {
									'После этого территория не',
									'будет вам принадлежать',
								}, function(result)

									if result then
										triggerServerEvent('team_area.leave', resourceRoot, currentBusinessData.id)
										closeWindow()
									end

								end)
							
							end,

						},
					}

				elseif currentBusinessData.clan_war and currentBusinessData.clan_war.opponent == localTeam then

					actions = {
						{

							name = 'Отменить бой',
							action = function(element)

								if exports.teams_main:hasPlayerRight(localPlayer, 'area_create_war') then
									
									dialog('Бой', {
										'Вы действительно хотите отменить',	
										'бой за эту территорию?',	
									}, function(result)

										if result then
											triggerServerEvent('team_area.leaveWar', resourceRoot, currentBusinessData.id)
											closeWindow()
										end

									end)

								else
									return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
								end

							end,

						},
					}

				else

					actions = {
						{

							name = 'Объявить бой',
							action = function(element)

								if exports.teams_main:hasPlayerRight(localPlayer, 'area_create_war') then
									currentWindowSection = 'create_war'
								else
									return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
								end

							end,

						},
					}

				end

				local bw,bh = 144,41

				local startX = element[4] - bw - 20

				element:clear()

				for _, action in pairs( actions ) do

					element:addElement(
						{'button',

							startX, 'center',
							bw,bh,

							bg = 'assets/images/button_empty.png',
							activeBg = 'assets/images/button.png',
							action.name,

							data = action,

							scale = 0.5,
							font = getFont('montserrat_bold', 20, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},


							onClick = action.action,

						}
					)

					startX = startX - bw - 15

				end


				element.take_button = element:addElement(

					{'button',
						0, 0,
						0, 0,
						'Снять',

						scale = 0.5,
						font = getFont('montserrat_semibold', 22, 'light'),

						onInit = function(element)
							element[4] = dxGetTextWidth( element[6], element.scale, element.font )
							element[5] = dxGetFontHeight( element.scale, element.font )
						end,

						color = {255,255,255,255},

						textColor = {255,255,255,255},
						activeTextColor = {180,70,70,255},

						noDraw = function(element)
							return (currentBusinessData.clan_bank or 0) <= 0 or (currentBusinessData.clan ~= localPlayer:getData('team.id'))
						end,

						onClick = function(element)

							if not exports.teams_main:hasPlayerRight(localPlayer, 'area_take_money') then
								return exports.hud_notify:notify('Ошибка', 'Недостаточно прав')
							end

							triggerServerEvent('team_area.takeMoney', resourceRoot, currentBusinessData.id)

						end,


					}

				)


			end,

			clear = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element:destroy()
				end

				element.elements = {}

			end,

			elements = {

			},

		},

	},

	create_war = {

		{'image',
			'center', 'center',
			541, 709,
			color = {25,24,38,255},
			'assets/images/cwar/wbg.png',

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/cwar/wicon_bg.png', 0, 0, 0, 
					tocolor(180,70,70,255*alpha)
				)

				dxDrawImage(
					x + 20, y + 20,
					56, 56, 
					'assets/images/cwar/wicon.png', 0, 0, 0, 
					tocolor(0,0,0,100*alpha)
				)

				dxDrawText('Назначение боя за территорию',
					x, y + 68, x + w, y + 68,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'center', 'top'
				)

				if isElement( teamWindow.team ) then

					local color = RGBToHex( getTeamColor( teamWindow.team ) )

					dxDrawText(('Территорию контролирует клан %s%s'):format(
						color, teamWindow.team.name
					),
						x, y + 90, x + w, y + 90,
						tocolor(76,73,94,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
						'center', 'top', false, false, false, true
					)

				end


			end,

			elements = {

				-- {'image',
				-- 	'center', 130,
				-- 	298, 146,
				-- 	color = {21,21,33,255},
				-- 	'assets/images/cwar/wbg2.png',

				-- 	onRender = function(element)

				-- 		local alpha = element:alpha()
				-- 		local x,y,w,h = element:abs()

				-- 		dxDrawText('Характеристики',
				-- 			x, y + 25, x + w, y + 25,
				-- 			tocolor(255,255,255,255*alpha),
				-- 			0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
				-- 			'center', 'top'
				-- 		)

				-- 		local ww,wh = 186, 17

				-- 		dxDrawImage(
				-- 			x+w/2-ww/2, y + 50,
				-- 			ww,wh,
				-- 			'assets/images/cwar/wline.png',
				-- 			0, 0, 0, tocolor(180,70,70,255*alpha)
				-- 		)

				-- 		local area_income = exports.teams_main:getConfigSetting('areaIncome')

				-- 		dxDrawText(('$%s'):format( splitWithPoints( area_income, '.' ) ),
				-- 			x, y + 65,
				-- 			x+w, y + 65,
				-- 			tocolor(180,70,70,255*alpha),
				-- 			0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
				-- 			'center', 'top'
				-- 		)

				-- 		dxDrawText('Доход территории',
				-- 			x, y + 105,
				-- 			x+w, y + 105,
				-- 			tocolor(255,255,255,255*alpha),
				-- 			0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
				-- 			'center', 'top'
				-- 		)

				-- 	end,

				-- },

				{'image',

					'center', 150,
					298, 146,
					color = {50,50,50,255},
					'assets/images/cwar/wbg2.png',

					mode = 1,

					variable = 'createWar_selectMode',

					mode_titles = {

						{
							name = 'Сцепка',
							title = {
								'Описание:',
								'Банды перестреливаются',
								'на открытых улицах города',
							},
						},
						{
							name = 'Захват',
							title = {
								'Описание:',
								'Задача атакующих - ',
								'захватить вражескую базу',
							},
						},
						{
							name = 'Стрелка',
							title = {
								'Описание:',
								'Банды встречаются на',
								'машинах в лесу',
								'Задача - убить ВСЕХ противников',
							},
						},

					},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите режим',
							x, y - 10, x+w, y - 10,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'bottom'
						)

						element[6] = ('assets/images/cwar/mode%s.png'):format( element.mode )

						dxDrawText(element.mode_titles[element.mode].name,
							x + 20, y + 20,
							x + 20, y + 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
							'left', 'top'
						)

						local s_y = y + 60

						for _,row in pairs( element.mode_titles[element.mode].title ) do
							dxDrawText(row,
								x + 20, s_y,
								x + 20, s_y,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
								'left', 'top'
							)
							s_y = s_y + 16
						end


					end,

					elements = {

						{'image',
							function(s,p) return p[4] + 10 end, 'center',
							25, 25,
							'assets/images/cwar/arrown.png',
							color = {255,255,255,255},

							rot = 180,

							onClick = function(element)
								element.parent.mode = cycle( element.parent.mode + 1, 1, 3 )
							end,

						},

						{'image',
							function(s,p) return - 10 - s[4] end, 'center',
							25, 25,
							'assets/images/cwar/arrown.png',
							color = {255,255,255,255},

							onClick = function(element)
								element.parent.mode = cycle( element.parent.mode - 1, 1, 3 )
							end,

						},

					},

				},

				{'button',

					0, 0, 35, 35,
					bg = 'assets/images/cwar/close.png',
					activeBg = 'assets/images/cwar/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 20 + 56/2 - element[5]/2

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/cwar/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'button',

					'center', function(s,p) return p[5] - s[5] - 50 end,
					196, 42,

					bg = 'assets/images/cwar/cwbtn_empty.png',
					activeBg = 'assets/images/cwar/cwbtn.png',
					'Назначить бой',

					scale = 0.5,
					font = getFont('montserrat_semibold', 21, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 214/2, y + h/2 - 60/2, 214, 60

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cwar/cwbtn_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/cwar/cwbtn_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						if not createWar_selectTime.selected_time then
							return exports.hud_notify:notify('Ошибка', 'Выберите время')
						end
						if not createWar_selectMode.mode then
							return exports.hud_notify:notify('Ошибка', 'Выберите режим')
						end
						triggerServerEvent('team_area.createWar', resourceRoot, currentBusinessData.id,
							createWar_selectMode.mode,
							createWar_selectTime.selected_time
						)

						closeWindow()

					end,


				},

				{'element',

					'center', 370,
					340, 204,
					color = {255,255,255,255},

					variable = 'createWar_selectTime',

					time_options = {
						{18, 00}, {18, 30}, {19, 00},
						{19, 30}, {20, 00}, {20, 30},
						{21, 00}, {21, 30}, {22, 00},
					},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите время боя',
							x, y - 20, x + w, y - 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'bottom'
						)

					end,

					onInit = function(element)

						local w,h = 95,36
						local padding = 20

						local sCount_x = 1.5
						local sCount_y = 2

						local _startX = element[4]/2 - w*sCount_x - padding*(sCount_x-0.5)
						local startX = _startX
						local startY = element[5]/2 - h*sCount_y - padding*(sCount_y-0.5)

						local index = 1

						for i_1 = 1,3 do
							for i_2 = 1,3 do

								local option = element.time_options[index]

								element:addElement(
									{'button',

										startX, startY,
										95, 35,

										bg = 'assets/images/cwar/wbtn_empty.png',
										activeBg = 'assets/images/cwar/wbtn.png',
										('%02d:%02d'):format( option[1], option[2] ),

										time = option,

										scale = 0.5,
										font = getFont('montserrat_semibold', 21, 'light'),

										color = {180, 70, 70, 255},
										activeColor = {200, 70, 70, 255},

										onRender = function(element)

											element.bg = element.parent.selected_time == element.time
												and element.activeBg or 'assets/images/cwar/wbtn_empty.png'

										end,

										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local shx,shy,shw,shh = x + w/2 - 121/2, y + h/2 - 64/2, 121,64

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/cwar/wbtn_empty_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
											)

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/cwar/wbtn_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
											)

										end,

										onClick = function(element)
											element.parent.selected_time = element.time
										end,


									}
								)

								startX = startX + w + padding
								index = index + 1

							end

							startY = startY + h + padding
							startX = _startX

						end

						openHandlers.reset_time = function()
							createWar_selectTime.selected_time = nil
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

			placeholder = 'Выплата',

			onInit = function(element)
				createPaymentSum = element
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

				local payment_sum = tonumber(createPaymentSum[6]) or 0
				local cost = tonumber(createCost[6]) or 0

				if payment_sum <= 0 then return end
				if cost <= 0 then return end

				triggerServerEvent('business.add', resourceRoot, x,y,z,
					payment_sum, cost, createDonate.selected and 1 or 0
				)

				closeWindow()
			end,
		},


	},

}

--------------------------------------------------------
	
	function openBusinessEdit()

		local params = {
			onRender = function(element)
				if element.focused then
					element.textColor = {255,255,255,element.color[4]}
				else
					element.textColor = {255,255,255,0}
					element.placeholderColor = {255,255,255,0}

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					dxDrawText(string.format('%s: %s',
						element.placeholder, element[6]
					),
						x,y,x+w,y+h,
						tocolor(255,255,255,255*alpha),
						element.scale, element.scale, element.font,
						'center', 'center'
					)
				end
			end,
		}

		dialog_input('Редактирование', 'Измените данные', {
			{ type = 'number', name = 'Выплата', params = { [6] = currentBusinessData.payment_sum, onRender = params.onRender } },
			{ type = 'number', name = 'Баланс', params = { [6] = currentBusinessData.balance, onRender = params.onRender } },
			{ type = 'number', name = 'Стоимость', params = { [6] = currentBusinessData.cost, onRender = params.onRender } },
			{ type = 'text', name = 'Владелец', params = { [6] = currentBusinessData.owner or '', onRender = params.onRender } },
		}, function(data)

			if data then

				triggerServerEvent('business.edit', resourceRoot, currentBusinessData.id, {
					payment_sum = data[1],
					balance = data[2],
					cost = data[3],
					owner = data[4],
				})

				if data[4] ~= currentBusinessData.owner then
					closeWindow()
				end

			end

		end)

	end

--------------------------------------------------------

loadGuiModule()


end)

