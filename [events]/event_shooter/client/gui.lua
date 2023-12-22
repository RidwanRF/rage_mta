
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f6'] = true,
	['f7'] = true,
	['f11'] = true,
	['f10'] = true,
	['f9'] = true,
	['k'] = true,
	['i'] = true,
	['m'] = true,
}

openHandler = function()
end

closeHandler = function()

end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {
	
		{'image',

			'center', 'center',
			616, 718,
			'assets/images/main/bg.png',
			color = {25,24,38,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local text = 'Deathmatch War'
				local scale, font = 0.5, getFont('montserrat_semibold', 30, 'light')

				local textWidth = dxGetTextWidth( text, scale, font )
				local textHeight = dxGetFontHeight( scale, font )

				element.help_button[2] = 78 + textWidth + 10
				element.help_button[3] = 62 + textHeight/2 - element.help_button[4]/2 + 1

				dxDrawText(text,
					x + 78, y + 62,
					x + 78, y + 62,
					tocolor(255,255,255,255*alpha),
					scale, scale, font,
					'left', 'top'
				)

				dxDrawText('Список матчей',
					x + w - 78, y + 62,
					x + w - 78, y + 62,
					tocolor(54,51,76,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'right', 'top'
				)

			end,

			onInit = function(element)

				element.help_button = element:addElement(
					{'image',

						0, 0, 25,25,
						roundTexture,
						color = {180,70,70,255},

						onRender = function(element)

							local r,g,b = interpolateBetween( 60,60,80, 180,70,70, element.animData, 'InOutQuad' )
							element.color = { r,g,b, element.color[4] }

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawText('?',
								x,y,x+w,y+h,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'center', 'center'
							)

						end,

						onHover = function(element)

							element.update_source = true

						end,

						onPostRender = function(element)

							local x,y,w,h = element:abs()
							local ex,ey,ew,eh = element.parent:abs()
							local alpha = element:alpha()

							if element.animData < 0.05 then return end

							local rows = {
								'- Здесь игроки устраивают #cd4949перестрелки#ffffff',
								'- Каждый игрок делает одинаковый #cd4949взнос#ffffff',
								'- После матча победитель получит #cd4949награду#ffffff',
								'- Награда зависит от величины #cd4949взноса#ffffff игроков',
							}

							local count = #rows

							local padding = 5

							local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')

							local fontHeight = dxGetFontHeight( scale, font )
							local totalHeight = fontHeight * count + padding*( count-1 )
							local maxWidth = 0

							for _, row in pairs( rows ) do

								local width = dxGetTextWidth( row, scale, font, true )
								if width > maxWidth then maxWidth = width end

							end

							local margin_x, margin_y = 70, 40

							local rw,rh = maxWidth + margin_x, totalHeight + margin_y
							local rx,ry = ex + 78, y + h + 20*element.animData

							-- local aw,ah = 38,38

							-- dxDrawImage(
							-- 	rx - aw + 10, ry+rh/2-ah,
							-- 	aw,ah, 'assets/images/create_match/arrow.png',
							-- 	90, 0, 0, tocolor( 60,60,80,255*alpha*element.animData )
							-- )

							if element.update_source then
								element.source_bg = createTextureSource('bordered_rectangle', 'assets/images/source_bg.png', 20, rw,rh)
								element.update_source = false
							end

							dxDrawImage(
								rx,ry,rw,rh, element.source_bg,
								0, 0, 0, tocolor( 16,16,26,255*alpha*element.animData )
							)

							local startY = ry + margin_y/2

							for _, row in pairs( rows ) do

								dxDrawText(row,
									rx + margin_x/2, startY,
									rx + margin_x/2, startY,
									tocolor(255,255,255,255*alpha*element.animData),
									scale, scale, font,
									'left', 'top', false, false, false, true
								)

								startY = startY + fontHeight + padding

							end

						end,


					}
				)

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/main/bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2+5

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'element',

					'center', 130,
					457, 450,
					color = {255,255,255,255},

					scrollXOffset = -20,
					scrollBgColor = {21,21,33,255},

					overflow = 'vertical',

					variable = 'matchesList',

					clear = function(element)

						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						element.elements = {}

					end,

					onInit = function(element)

						openHandlers.update_matches = function( _, matches_queue )

							local list = {}

							for id, match in pairs( matches_queue ) do
								table.insert( list, match )
							end

							matchesList:update( matches_queue )

						end

					end,

					updateElementsY = function(element)

						local startY = 0

						local w,h = 457, 141
						local padding = 10

						for _, c_element in pairs( element.elements or {} ) do

							c_element[3] = startY
							startY = startY + h + padding

						end

					end,

					addMatch = function(element, match)

						local w,h = 457, 141
						local padding = 10

						local lastY = 0

						for _, c_element in pairs( element.elements or {} ) do

							local _y = c_element[3] + c_element[5]
							if _y > lastY then
								_y = lastY
							end

						end

						element:addElement(
							{'image',

								'center', lastY,
								w,h,
								color = { 16,16,26,255 },

								'assets/images/main/item_bg.png',

								match = match,

								update = function(element, data)
									if not data then return element:destroy() end
									element.match = data
								end,

								onDestroy = function(element)
									element.parent:updateElementsY()
								end,

								onRender = function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									if not element.match then return end

									local map_config = Config.maps[ element.match.map_id ]
									local match_type_config = Config.match_types[ element.match.type ]

									local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')

									local textWidth = dxGetTextWidth( map_config.name, scale, font )
									local fontHeight = dxGetFontHeight( scale, font )

									dxDrawText(map_config.name,
										x + 35, y + 20,
										x + 35, y + 20,
										tocolor( 255,255,255,255*alpha ),
										scale, scale, font,
										'left', 'top'
									)

									local iw,ih = 20,20

									dxDrawImage(
										x + 35 + textWidth + 10, y + 22 + fontHeight/2 - ih/2,
										iw,ih, 'assets/images/main/player.png',
										0, 0, 0, tocolor( 180,70,70,255*alpha )
									)

									dxDrawText(('%s#3c3c50 / %s'):format( getTableLength( match.players or {} ), match_type_config.players ),
										x + 35 + textWidth + 10 + iw + 5, y + 22 + fontHeight/2,
										x + 35 + textWidth + 10 + iw + 5, y + 22 + fontHeight/2,
										tocolor( 255,255,255,255*alpha ),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'left', 'center', false, false, false, true
									)

									dxDrawText(('Создатель %s'):format( element.match.creator ),
										x + w - 35, y + 22 + fontHeight/2,
										x + w - 35, y + 22 + fontHeight/2,
										tocolor( 60,60,80,255*alpha ),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'right', 'center', false, false, false, true
									)

									dxDrawText('Настройки',
										x + 35, y + 60,
										x + 35, y + 60,
										tocolor( 60,60,80,255*alpha ),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'left', 'top', false, false, false, true
									)

									dxDrawText(match_type_config.name,
										x + 35, y + 80,
										x + 35, y + 80,
										tocolor( 170,170,170,255*alpha ),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'left', 'top', false, false, false, true
									)

									dxDrawText(('Взнос $%s'):format( splitWithPoints( element.match.bet, '.' ) ),
										x + 35, y + 100,
										x + 35, y + 100,
										tocolor( 170,170,170,255*alpha ),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'left', 'top', false, false, false, true
									)

								end,

								elements = {

									{'button',

										function(s,p) return p[4] - s[4] - 25 end,
										function(s,p) return p[5] - s[5] - 25 end,
										161, 35,

										bg = 'assets/images/main/jbtn.png',

										color = { 200,80,80,255 },
										activeColor = { 230,90,90,255 },
										'Присоединиться',

										font = getFont('montserrat_bold', 19, 'light'),
										scale = 0.5,

										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local shadow = {
												['assets/images/main/jbtn_shadow.png'] = (element.animData),
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
											triggerServerEvent('event_shooter.joinMatchQueue', resourceRoot, element.parent.match.id)
										end,

									},

								},

							}
						)

					end,

					update = function(element, matches)

						element:clear()

						local startY = 0

						for _, match in pairs( matches ) do

							element:addMatch( match )

						end

					end,

					updateMatch = function(element, match_id, match_data)

						for _, c_element in pairs( element.elements or {} ) do

							if c_element.match.id == match_id then
								return c_element:update( match_data )
							end

						end

						if match_data then
							element:addMatch( match_data )
						end

					end,

					addEvent('event_shooter.forceMatchUpdate', true),
					addEventHandler('event_shooter.forceMatchUpdate', resourceRoot, function( match_id, match_data )

						if windowOpened then

							matchesList:updateMatch( match_id, match_data )
							matchQueueWindow.match = match_data

						end

					end),

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						if #( element.elements or {} ) == 0 then

							dxDrawText('Не найдено ни одного матча',
								x, y, x + w, y + h,
								tocolor(54,51,76,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
								'center', 'center'
							)

						end

						mta_dxDrawRectangle(
							px(x), px(y + h + 15),
							px(w), 1, tocolor(16,16,26,255*alpha)
						)

					end,

					elements = {},

				},

				{'button',

					function(s,p) return p[4] - s[4] - 80 end,
					function(s,p) return p[5] - s[5] - 50 end,
					185, 46,

					bg = 'assets/images/main/btn_empty.png',
					activeBg = 'assets/images/main/btn.png',

					color = { 200,80,80,255 },
					activeColor = { 230,90,90,255 },
					'Создать матч',

					font = getFont('montserrat_bold', 23, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/main/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/main/btn_shadow.png'] = (element.animData),
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
						currentWindowSection = 'create_match'
					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 80 - 185 - 10 end,
					function(s,p) return p[5] - s[5]/2 - 50 - 46/2 end,
					120, 40,

					bg = false,
					define_from = '',

					'Закрыть',

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},
					textColor = { 170,170,170,255 },

					onClick = function(element)
						closeWindow()
					end,

				},


			},


		},

	},

	match_queue = {

		{'image',

			'center', 'center',
			495, 582,
			'assets/images/match_queue/bg.png',
			color = {25,24,38,255},

			variable = 'matchQueueWindow',

			onInit = function(element)

				openHandlers.match_queue = function(_, match)

					if currentWindowSection == 'match_queue' then

						matchQueueWindow.match = match

					end

				end

				addEvent('event_shooter.receiveMatchQueue', true)
				addEventHandler('event_shooter.receiveMatchQueue', resourceRoot, function( match )

					matchQueueWindow.match = match

				end)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Ожидание игры',
					x, y + 55,
					x + w, y + 55,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				if not element.match then return end

				local match_type = Config.match_types[ element.match.type ]

				local rows = {
					{ name = 'Карта', value = Config.maps[ element.match.map_id ].name },
					{ name = 'Взнос', value = '$ '..splitWithPoints( element.match.bet, '.' ) },
					{ name = 'Игроки', value = ('%s / %s'):format( getTableLength( element.match.players ), match_type.players ) },
					{ name = 'Тип боя', value = match_type.name },
				}

				local startY = y + 110

				local rw,rh = 361, 49
				local rx = x+w/2-rw/2

				local padding = 15

				for _, row in pairs( rows ) do

					dxDrawImage(
						rx, startY,
						rw,rh, 'assets/images/match_queue/row.png',
						0, 0, 0, tocolor( 16,16,26,255*alpha )
					)

					dxDrawText(row.name,
						rx + 20, startY,
						rx + 20, startY + rh,
						tocolor(60,60,80,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
						'left', 'center'
					)

					dxDrawText(row.value,
						rx + rw - 20, startY,
						rx + rw - 20, startY + rh,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
						'right', 'center'
					)

					startY = startY + rh + padding

				end

				local tw,th = w, 80
				local tx,ty = x, y + 380

				dxDrawRectangle(
					tx,ty,tw,th, tocolor( 16,16,26,255*alpha )
				)

				dxDrawText(('Если за отведенное время не наберется нужное\nколичество игроков - матч будет отменен'),
					tx, ty, tx+tw,ty+th,
					tocolor( 60,60,80,255*alpha ),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'center'
				)



			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/match_queue/bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2+5

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 70 end,
					function(s,p) return p[5] - s[5] - 50 end,
					185, 46,

					bg = 'assets/images/match_queue/btn_empty.png',
					activeBg = 'assets/images/match_queue/btn.png',

					color = { 200,80,80,255 },
					activeColor = { 230,90,90,255 },
					'Покинуть матч',

					font = getFont('montserrat_bold', 22, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/match_queue/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/match_queue/btn_shadow.png'] = (element.animData),
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

					onRender = function(element)

						local x,y,w,h = element:abs()
						local ex,ey,ew,eh = element.parent:abs()
						local alpha = element:alpha()

						if not element.parent.match then return end

						local tw,th = 45,45
						local tx,ty = ex + 150, y+h/2-th/2

						dxDrawImage(
							tx,ty,tw,th, 'assets/images/match_queue/timer.png',
							0, 0, 0, tocolor( 180,70,70,255*alpha )
						)

						local server_timestamp = getServerTimestamp()
						local seconds = Config.match_queue_time - (server_timestamp.timestamp - element.parent.match.created)

						local time = {}

						time.m = math.floor( seconds/60 )
						time.s = seconds - time.m*60

						dxDrawText(( '%02d:%02d' ):format( time.m, time.s ),
							tx, ty,
							tx, ty+th,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('hb_medium', 24, 'light'),
							'right', 'center'
						)

					end,

					onClick = function(element)

						triggerServerEvent('event_shooter.leaveMatchQueue', resourceRoot, localPlayer)
						currentWindowSection = 'main'

					end,

				},

			},


		},

	},

	create_match = {

		{'image',

			'center', 'center',
			495, 564,
			'assets/images/create_match/bg.png',
			color = {25,24,38,255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()


				dxDrawText('Создание матча',
					x, y + 62,
					x + w, y + 62,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/create_match/bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2+5

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'select-box',
					'center', 150,
					values = Config.match_types,
					text = 'Выберите тип боя',

					variable = 'matchType_select',

				},

				{'select-box',
					'center', 260,
					values = Config.maps,
					text = 'Выберите поле боя',

					variable = 'matchMap_select',

				},

				{'input',

					'center', 370,
					[6] = tostring( Config.bet_range[1] ),

					values = {},
					text = 'Выберите сумму взноса',

					bg = 'assets/images/create_match/input.png',
					color = {16,16,26,255},

					override_bg = false,

					define_from = 'select-box',

					scale = 0.5,
					font = getFont('montserrat_semibold', 24, 'light'),
					alignX = 'center',
					type = 'number',

					variable = 'matchBet_select',

					move = function(element, step)

						local value = tonumber(element[6]) or 0
						element[6] = tostring( math.clamp( value + 1000*step, unpack( Config.bet_range ) ) )

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 80 end,
					function(s,p) return p[5] - s[5] - 50 end,
					185, 46,

					bg = 'assets/images/main/btn_empty.png',
					activeBg = 'assets/images/main/btn.png',

					color = { 200,80,80,255 },
					activeColor = { 230,90,90,255 },
					'Создать матч',

					font = getFont('montserrat_bold', 23, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/main/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/main/btn_shadow.png'] = (element.animData),
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

						local match_type = matchType_select.value
						local map_id = matchMap_select.value

						local bet = tonumber( matchBet_select[6] ) or 0

						if not isBetween( bet, unpack( Config.bet_range ) ) then
							return exports.hud_notify:notify('Введите сумму взноса', ('От $%s до $%s'):format(

								splitWithPoints( Config.bet_range[1], '.' ),
								splitWithPoints( Config.bet_range[2], '.' )

							))
						end

						triggerServerEvent('event_shooter.createMatchQueue', resourceRoot, match_type, map_id, bet)
						currentWindowSection = 'main'

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 80 - 185 - 10 end,
					function(s,p) return p[5] - s[5]/2 - 50 - 46/2 end,
					120, 40,

					bg = false,
					define_from = '',

					'Отмена',

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},
					textColor = { 170,170,170,255 },

					onClick = function(element)
						currentWindowSection = 'main'
					end,

				},


			},


		},

	},

}

---------------------------------------------------------------------

	GUIDefine('select-box', {

		[4] = 361, [5] = 49,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			if element.text then

				dxDrawText(element.text,
					x, y - 15, x+w, y - 15,
					tocolor( 60,60,80,255*alpha ),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'bottom'
				)

			end

			if element.override_bg ~= false then 

				dxDrawImage(
					x,y,w,h, 'assets/images/create_match/input.png',
					0, 0, 0, tocolor( 16,16,26,255*alpha )
				)

			end

			local value_data = element.values[ element.value ]

			if value_data then
				dxDrawText(value_data.name,
					x,y,x+w,y+h,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
					'center', 'center'
				)
			end


		end,

		onInit = function(element)

			element.value = 1

			element:addElement(
				{'button',

					10, 'center',

					define_from = 'next-button',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x - 5*element.animData,y,w,h, 'assets/images/create_match/arrow.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawImage(
							x + 5 * element.animData,y,w,h, 'assets/images/create_match/arrow.png',
							0, 0, 0, tocolor(255,255,255,100*alpha * element.animData)
						)

					end,

					_onClick = function(element)

						element.parent:move( -1 )

					end,

				}
			)

			element:addElement(
				{'button',

					function(s,p) return p[4] - s[4] - 10 end, 'center',

					define_from = 'next-button',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + 5*element.animData,y,w,h, 'assets/images/create_match/arrow.png',
							180, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawImage(
							x - 5 * element.animData,y,w,h, 'assets/images/create_match/arrow.png',
							180, 0, 0, tocolor(255,255,255,100*alpha * element.animData)
						)

					end,

					_onClick = function(element)

						element.parent:move( 1 )

					end,

				}
			)

		end,

		move = function(element, step)

			element.value = cycle( element.value + step, 1, #element.values )

		end,


	})

---------------------------------------------------------------------

	GUIDefine('next-button', {

		[4]=38,[5]=37,

		[6]='',
		bg = 'assets/images/create_match/nbtn.png',

		color = { 40,40,60,255 },
		activeColor = { 180,70,70,255 },

		scale = 0.5,
		font = 'default',

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shadow = {
				['assets/images/create_match/nbtn_shadow.png'] = (element.animData),
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

		gOnPreRender = function(element)

			local x,y,w,h = element:abs()

			if handleClick and isMouseInPosition( x,y,w,h ) then

				element:_onClick()
				handleClick = false

			end

		end,

	})

---------------------------------------------------------------------

loadGuiModule()


end)

