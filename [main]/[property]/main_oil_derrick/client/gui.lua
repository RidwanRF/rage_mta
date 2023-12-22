
openHandler = function()
end

closeHandler = function()
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	__basic = {

		{'element',
			'center', 'center',
			835, 517,
			color = {255,255,255,255},
			bg='assets/images/bg.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local shw,shh = w+18,h+18
				local shx, shy = x+w/2-shw/2, y+h/2-shh/2+5

				dxDrawImage(
					x,y,w,h, element.bg,
					0, 0, 0, tocolor(53,58,90, 200*alpha)
				)

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 150*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/bg1.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				drawImageSection(
					x,y,w,h, element.bg,
					{ x = 255/w, y = 1 }, tocolor(46,50,83,100*alpha), 1
				)

			end,

			elements = {

				{'element',
					'right', 'top',
					255, '100%',
					color = {255,255,255,255},

					onKey = {

						tab = function(element)

							for index, tab in pairs(element.tabs) do

								if tab.id == currentWindowSection then
									currentWindowSection = element.tabs[ cycle(index-1, 1, #element.tabs) ].id
									break
								end

							end

						end,

					},

					tabs = {
						{ id = 'main', name = 'Главная', },
						{ id = 'upgrades', name = 'Улучшения', },
						{ id = 'sell', name = 'Продать', },
					},

					onInit = function(element)

						local ex,ey,ew,eh = element:abs()
						local startY = 170
						local padding = 5

						local w,h = element[4], 40

						element.active_anim = {}
						setAnimData(element.active_anim, 0.1, ey+startY)

						for _, tab in pairs( element.tabs ) do

							element:addElement(
								{'element',

									'center', startY,
									w,h,

									tab = tab,

									onClick = function(element)
										currentWindowSection = element.tab.id
									end,

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										dxDrawRectangle(
											x,y,w,h, tocolor(62,65,96, 255*alpha)
										)

									end,

									onPostRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										if element.tab.id == currentWindowSection then

											local animData = getAnimData(element.parent.active_anim)

											dxDrawRectangle(
												x, animData,
												element[4], 40,
												tocolor(180, 70,70,255*alpha)
											)

										end

										dxDrawText(element.tab.name,
											x,y,x+w,y+h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
											'center', 'center'
										)

										if element.tab.id == currentWindowSection then
											animate(element.parent.active_anim, y)
										end


									end,

								}
							)

							startY = startY + h + padding

						end

					end,

					elements = {

						{'info-block',

							'center', 30,

							icon = 'assets/images/icons/balance.png',

							getData = function(element)
								return 'Общий баланс', string.format('$%s', splitWithPoints(currentBusinessData.balance or 0, '.'))
							end,

						},

						{'button',

							'center', 95,
							[6] = 'Вывести прибыль',

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							onClick = function(element)

								local x,y,w,h = element:abs()
								animate(element.animationAlpha, 0)

								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

									animate(element.animationAlpha, 1)
									triggerServerEvent('derrick.takeMoney', resourceRoot,
										currentBusinessData.id,
										currentBusinessData.balance or 0
									)

								end )

							end,

						},

						{'button',

							'center', function(s,p) return p[5] - s[5] - 30 end,
							[6] = 'Выйти',

							onClick = closeWindow,

						},

						{'button',

							'center', function(s,p) return p[5] - s[5]*2 - 30 - 10 end,
							[6] = 'Заказать починку',

							onClick = function()

								if currentBusinessData.fix_amount > 0 then
									return exports.hud_notify:notify('Ошибка', 'Починка уже заказана')
								else
									currentWindowSection = 'order_fix'
								end

							end,

						},

						{'button',

							'center', function(s,p) return p[5] - s[5]*3 - 30 - 20 end,
							[6] = 'Редактирование',

							noDraw = function(element)
								return not exports.acl:isAdmin(localPlayer)
							end,

							onClick = function()
								openBusinessEdit()
							end,

						},

					},

				},

			},

		},

	},

	main = {

		{'element',

			'center', 'center',
			835, 517,

			color = {255,255,255,255},

			elements = {

				{'element',
					0, 'center',
					function(s,p) return p[4]-255 end, '100%',
					color = {255,255,255,255},

					elements = {

						{'image',

							'center', 65,
							300,20,

							'assets/images/state.png',
							color = {29,32,62,255},

							onInit = function(element)

								element.t_anim = {}
								setAnimData(element.t_anim, 0.05)

								setTimer(function()

									if windowOpened then
										setAnimData(element.t_anim, 0.05)
										animate(element.t_anim, 1)
									end

								end, 2000, 0)

							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local prx,pry,prw,prh = element.parent:abs()

								local alpha = element:alpha()

								local scale, font = 0.5, getFont('montserrat_semibold', 23, 'light')
								local text = 'Состояние станции'

								local padding = 20
								local textWidth = dxGetTextWidth(text, scale, font)

								local totalWidth = textWidth + padding + element[4]

								local startX = prx + prw/2 - totalWidth/2

								dxDrawText(text,
									startX, y,
									startX, y+h,
									tocolor(255,255,255,255*alpha),
									scale, scale, font,
									'left', 'center'
								)

								element[2] = element.parent[4]/2 - totalWidth/2 + padding + textWidth

								local level = currentBusinessData.upgrades_level
								local level_data = Config.derrick.levels[level]

								local progress = math.clamp( currentBusinessData.health/level_data.health, 0, 1 )

								mta_drawImageSection(
									px(x)+2,px(y)+2,px(w)-4,px(h)-4, element[6],
									{ y = 1, x = progress }, tocolor(180, 70, 70, 255*alpha)
								)

								if currentBusinessData.fix_amount > 0 then

									local t_anim = getAnimData(element.t_anim)

									mta_drawImageSection(
										px(x)+2,px(y)+2,px(w)-4,px(h)-4, element[6],
										{ y = 1, x = progress*t_anim }, tocolor(200, 90, 90, 255*alpha*(1-t_anim))
									)

								end

								dxDrawText(string.format('%s / %s', currentBusinessData.health or 0, level_data.health),
									x,y,x+w,y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
									'center', 'center'
								)

								if currentBusinessData.fix_amount and currentBusinessData.fix_amount > 0 then

									local prx,pry,prw,prh = element.parent:abs()

									dxDrawText(string.format('До починки #cd4949%s#c8c8c8 мин.',
										currentBusinessData.fix_amount
									),
										startX,y+h+3,
										startX,y+h+3,
										tocolor(200,200,200,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
										'left', 'top', false, false, false, true
									)

								end


							end,

						},

						{'element',

							'center', 155,
							465, 115,

							color = {255,255,255,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText('Финансы',
									x,y-20,x+w,y-20,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'bottom'
								)

								local level_data = Config.derrick.levels[currentBusinessData.upgrades_level]
								local mul = level_data.payment_mul

								local course = resourceRoot:getData('oil.course') or {}
								local payment = (course.current or Config.derrick.course.default) * mul

								element.income = currentBusinessData.override_income or math.floor(payment)

							end,

							elements = {

								{'info-block',

									'left', 'top',
									[4] = 225,

									icon = '1L',
									drop_icon = true,

									getData = function(element)
										return 'Прибыль в час', string.format('$%s', splitWithPoints(element.parent.income, '.'))
									end,

								},

								{'info-block',

									'right', 'top',
									[4] = 225,

									icon = 'assets/images/icons/24.png',
									drop_icon = true,

									getData = function(element)
										return 'Прибыль в сутки', string.format('$%s', splitWithPoints(element.parent.income*24, '.'))
									end,

								},

								{'info-block',

									'left', 'bottom',
									[4] = 225,

									icon = 'assets/images/icons/week.png',
									drop_icon = true,

									getData = function(element)
										return 'Прибыль в неделю', string.format('$%s', splitWithPoints(element.parent.income*24*7, '.'))
									end,

								},

								{'info-block',

									'right', 'bottom',
									[4] = 225,

									icon = 'assets/images/icons/week.png',
									drop_icon = true,

									getData = function(element)
										return 'Прибыль в месяц', string.format('$%s', splitWithPoints(element.parent.income*24*30, '.'))
									end,

								},

							},

						},

						{'element',

							'center', 325,
							465, 165,

							onInit = function(element)

								element.bg = 'assets/images/history_bg.png'
								-- element.bg = createTextureSource('bordered_rectangle', 'assets/images/history_bg.png',
								-- 	22, element[4], element[5]
								-- )

								element.round = 'assets/images/round1.png'
								-- element.round = createTextureSource('bordered_rectangle', 'assets/images/round1.png',
								-- 	50, 50, 50
								-- )

								element.round_empty = 'assets/images/round2.png'
								-- element.round_empty = createTextureSource('bordered_empty_rectangle', 'assets/images/round2.png',
								-- 	50, 15, 50, 50
								-- )

								element.info_bg = 'assets/images/hinfo.png'
								-- element.info_bg = createTextureSource('bordered_rectangle', 'assets/images/hinfo.png',
								-- 	14, 120, 50
								-- )

							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local course = resourceRoot:getData('oil.course') or {}

								dxDrawRectangle(
									x,y+h/2,w,1,
									tocolor(200,200,200,255*alpha)
								)

								dxDrawText(string.format('$%s', splitWithPoints(Config.derrick.course.default, '.')),
									x + 10, y+h/2-5,
									x + 10, y+h/2-5,
									tocolor(200,200,200,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
									'left', 'bottom'

								)

								dxDrawImage(
									x,y,w,h, element.bg,
									0, 0, 0, tocolor(34,38,68,200*alpha)
								)

								dxDrawText('Курс нефти за сутки',
									x,y-15,x+w,y-15,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'bottom'
								)

								local gw = w*0.8
								local gh = h*0.8

								local middle, min, max = 0

								for index, data in pairs( course.history or {} ) do

									if not min or data.cost < min then
										min = data.cost
									end

									if not max or data.cost > max then
										max = data.cost
									end

									middle = middle + data.cost

								end

								middle = math.floor(middle/24)

								for index, data in pairs( course.history or {} ) do

									local p_x = x+w/2-gw/2 + (index-1)/23*gw

									local default = Config.derrick.course.default
									-- local default = Config.derrick.course.default
									local range = Config.derrick.course.change_range

									local delta = data.cost - default

									local offset = 0

									if delta > 0 then
										offset = delta/(default/100*range[2])
									else
										offset = -delta/(default/100*range[1])
									end

									local p_y = y+h/2 - offset*gh/2

									local pw,ph = 10, 10

									data.coords = {p_x,p_y}

									local hp_x = p_x - pw/2
									local hp_y = p_y - ph/2

									dxDrawImage(
										hp_x, hp_y, pw,ph, element.round,
										0, 0, 0, tocolor(180, 70, 70, 255*alpha)
									)

									if isMouseInPosition(hp_x, hp_y, pw,ph) then

										dxDrawImage(
											hp_x - 3, hp_y - 3, pw + 6,ph + 6, element.round_empty,
											0, 0, 0, tocolor(180, 70, 70, 255*alpha)
										)

										local lx1,ly1, lx2,ly2

										if delta > 0 then
											lx1,ly1 = p_x + 20, p_y + 100
											lx2,ly2 = lx1 + 40, ly1 + 10
										else
											lx1,ly1 = p_x + 20, p_y - 100
											lx2,ly2 = lx1 + 40, ly1 - 10
										end

										dxDrawLine(p_x, p_y, lx1,ly1, tocolor(180, 70, 70, 255*alpha), 2)
										dxDrawLine(lx1,ly1, lx2,ly2, tocolor(180, 70, 70, 255*alpha), 2)

										local iw,ih = 120, 50
										local ix,iy = lx2, ly2 - ih/2

										dxDrawImage(
											ix,iy,
											iw,ih, element.info_bg,
											0, 0, 0, tocolor(23,26,57,255*alpha)
										)

										local timestamp = getRealTime(data.timestamp)

										local str = string.format('%02d.%02d %02d:%02d',
											timestamp.monthday,
											timestamp.month+1,
											timestamp.hour,
											timestamp.minute
										)

										if index == #course.history then
											str = 'Сейчас'
										end

										dxDrawText(str,
											ix+20, iy+6,
											ix+20, iy+6,
											tocolor(200,200,200,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
											'left', 'top'
										)

										dxDrawText(string.format('$%s', splitWithPoints(data.cost, '.')),
											ix+20, iy+ih-7,
											ix+20, iy+ih-7,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
											'left', 'bottom'
										)

									end

								end

								for index, data in pairs( course.history or {}  ) do

									local next_data = course.history[index+1]
									if next_data then

										local startx, starty = unpack(data.coords)
										local endx, endy = unpack(next_data.coords)

										--dxDrawLine(startx, starty, endx, endy, tocolor(180, 70, 70, 255*alpha), 2)
										
									end


								end

							end,

						},

					},

				},

			},

		},

	},

	upgrades = {

		{'element',

			'center', 'center',
			835, 517,

			color = {255,255,255,255},

			elements = {

	            {'element',
	                20, 'center',
	                function(s,p) return p[4]-255 end, '100%',
	                color = {255,255,255,255},

	                onRender = function(element)

	                	local x,y,w,h = element:abs()
	                	local alpha = element:alpha()

	                	local rx,ry,rw,rh = x+30, y + element.r[1], 15, ( element.r[2] - element.r[1] )

	                	local progress = currentBusinessData.upgrades_level/#Config.derrick.levels

	                	dxDrawRectangle(
	                		rx,ry,rw,rh,
	                		tocolor(43,46,77,255*alpha)
                		)

	            	end,

	                onInit = function(element)

	                	local ex,ey,ew,eh = element:abs()

	                	local padding = 40
	                	local w,h = 431, 56

	                	local levels = table.reverse(Config.derrick.levels)
	                	local sCount = #levels/2

	                	local startY = eh/2 - sCount*h - padding*(sCount-0.5)

	                	element.r = { startY + h/2 }

	                	for index, level in pairs( levels ) do

	                		local level_index = #levels - (index-1)

	                		element:addElement(
	                			{'image',

	                				'center', startY,
	                				w,h, 
	                				color = {42,46,76,255},
	                				'assets/images/upgrade_bg.png',

	                				data = level,
	                				level = level_index,

	                				onRender = function(element)

	                					local alpha = element:alpha()
	                					local x,y,w,h = element:abs()

	                					dxDrawText('Уровень',
	                						x + 20, y+h/2+1,
	                						x + 20, y+h/2+1,
	                						tocolor(200,200,200,255*alpha),
	                						0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
	                						'left', 'bottom'
                						)
	                					dxDrawText(element.data.name,
	                						x + 20, y+h/2-2,
	                						x + 20, y+h/2-2,
	                						tocolor(255,255,255,255*alpha),
	                						0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
	                						'left', 'top'
                						)

                						local columns = {

                							{ i_text = '1L', text = string.format('+%s%%', ( element.data.payment_mul-1 )*100) },
                							{ i_text = 'HP', text = element.data.health },

                						}

                						local scale, font = 0.5, getFont('montserrat_semibold', 24, 'light')
                						local padding = 10
                						local ipadding = -2

                						local isize = 45

                						local startX = x + 120
                						local startY = y+h/2

                						for _, column in pairs( columns ) do

                							local textWidth = dxGetTextWidth( column.text, scale, font )

                							dxDrawText(column.text,
                								startX, startY,
                								startX, startY,
                								tocolor(255,255,255,255*alpha),
                								scale, scale, font,
                								'left', 'center'
            								)

            								dxDrawImage(
            									startX + textWidth + ipadding, startY-isize/2,
            									isize, isize, 'assets/images/ug_round.png',
            									0, 0, 0, tocolor(180, 70, 70, 255*alpha)
        									)

                							dxDrawText(column.i_text,
                								startX + textWidth + ipadding, startY,
            									startX + textWidth + ipadding+isize, startY,
            									tocolor(255,255,255,255*alpha),
            									0.5, 0.5, getFont('montserrat_medium', 18, 'light'),
            									'center', 'center'
            								)

                							startX = startX + textWidth + isize + padding + ipadding

                						end


                						local prx,pry,prw,prh = element.parent:abs()

                						local r,g,b = 39,42,72

                						if (currentBusinessData.upgrades_level+1) >= element.level then
                							r,g,b = 180, 70,70
                						end

                						if (currentBusinessData.upgrades_level) >= element.level
                							and #Config.derrick.levels ~= element.level
            							then
                						
						                	dxDrawRectangle(
						                		prx+30,y+h/2-96,15,96,
						                		tocolor(180,70,70,255*alpha)
					                		)

                						end

                						dxDrawImage(
                							prx+30+15/2-50/2, y+h/2-50/2,
                							50, 50, 'assets/images/ug_round.png',
                							0, 0, 0, tocolor(r,g,b,255*alpha)
            							)

	                				end,

	                				onPostRender = function(element)

	                					local alpha = element:alpha()
	                					local x,y,w,h = element:abs()

	                					if element.level > (currentBusinessData.upgrades_level+1) then

	                						dxDrawImage(
	                							x,y,w,h, element[6],
	                							0, 0, 0, tocolor(42,46,76, 240*alpha)
                							)

                							dxDrawText('Разблокируйте предыдущие уровни',
                								x,y,x+w,y+h,
                								tocolor(200,200,200,255*alpha),
                								0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
                								'center', 'center'
            								)

		                					dxDrawImage(
		                						x+w-40-15, y+h/2-40/2,
		                						40, 40, 'assets/images/block.png',
		                						0, 0, 0, tocolor(180, 70, 70, 255*alpha)
	                						)

	                					end


	                				end,

	                				elements = {

			                			{'button',
			                				function( s,p ) return p[4]-s[4]-20 end, 'center',

			                				114, 34,
			                				shadow_size = {146,68},

			                				[6] = string.format('$%s', splitWithPoints(level.cost, '.')),

											bg = 'assets/images/ug_btn_empty.png',
											activeBg = 'assets/images/ug_btn.png',

											shadow = 'assets/images/ug_btn_empty_shadow.png',
											activeShadow = 'assets/images/ug_btn_shadow.png',

			                				onRender = function(element)

			                					if currentBusinessData.upgrades_level >= element.parent.level then
		                							element[6] = 'Куплено'
		                						else
		                							element[6] = string.format('$%s', splitWithPoints(element.parent.data.cost, '.'))
			                					end

			                				end,

											onInit = function(element)
												element.animationAlpha = {}
												setAnimData(element.animationAlpha, 0.1, 1)
											end,

			                				onClick = function(element)

			                					if (element.parent.level-1) ~= currentBusinessData.upgrades_level then
			                						return
			                					end

			                					local x,y,w,h = element:abs()
												animate(element.animationAlpha, 0)

												displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

													animate(element.animationAlpha, 1)
													triggerServerEvent('derrick.buyUpgrade', resourceRoot, currentBusinessData.id, element.parent.level)

												end )

			                				end,

			                			},

	                				},


	                			}
                			)

	                		if index == #levels then
	                			element.r[2] = startY + h/2
	                		end

	                		startY = startY + h + padding


	                	end

	            	end,

	                elements = {



	                },

	            },

			},


		},

	},

	sell = {

		{'element',

			'center', 'center',
			835, 517,

			color = {255,255,255,255},

			elements = {

	            {'element',
	                0, 'center',
	                function(s,p) return p[4]-255 end, '100%',
	                color = {255,255,255,255},

	                elements = {

	                	{'element',
	                		'center', 'center',
	                		240, 100,
	                		color = {255,255,255,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText('Выберите кому продать:',
									x,y-20,x+w,y-20,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'bottom'
								)

							end,


	                		elements = {

	                			{'button',
	                				'center', 'top',
	                				'100%', 45,
	                				[6] = 'Государству',

	                				icon = 'assets/images/sell_gos_icon.png',

	                				onClick = function()

										dialog('Продажа вышки', {
											'Вы действительно хотите продать',	
											string.format('нефтевышку за %s $?',
												splitWithPoints(currentBusinessData.cost*Config.sellMul, '.')
											),	
										}, function(result)

											if result then
												triggerServerEvent('derrick.sell', resourceRoot, currentBusinessData.id)
												closeWindow()
											end

										end)

	                				end,

	                			},
	                			{'button',
	                				'center', 'bottom',
	                				'100%', 45,
	                				[6] = 'Игроку',

	                				icon = 'assets/images/sell_player_icon.png',

	                				onClick = function()

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

												triggerServerEvent('derrick.sellPlayer', resourceRoot, currentBusinessData.id, data[2], data[1])
												closeWindow()

											end


										end)

	                				end,

	                			},

	                		},

	                	},

	                },

	            },

			},


		},

	},

	order_fix = {

		{'image',
			'center', 'center',
			408, 255, 
			'assets/images/fix_bg.png',
			color = {32,35,66, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 434/2,
					y + h/2 - 281/2 + 5,
					434, 281, 'assets/images/fix_bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture(element[6])

				local gradient = getTextureGradient(texture, {
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

				dxDrawText('Заказать починку',
					x,y+25+13, x+w, y+25+13,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'center'
				)

				dxDrawText(string.format('Цена: 1 HP = #cd4949$%s',
					splitWithPoints( Config.derrick.fix_cost, '.' )
				),
					x,y+25+13+20, x+w, y+25+13+20,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'center', false, false, false, true
				)

				dxDrawText(string.format('( 1 HP восстанавливается %s мин. )',
					math.floor(Config.fixTimeout/60000)
				),
					x,y+25+13+45, x+w, y+25+13+45,
					tocolor(150,150,150,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
					'center', 'center', false, false, false, true
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

				{'input',

					'center', function(s,p) return p[5] - s[5] - 85 end,
					placeholder = 'Кол-во HP',

					type = 'number',
					maxSymbols = 10,

					variable = 'fixAmount_input',

					onInput = function(element)

						local value = tonumber(element[6]) or 0

						local level = currentBusinessData.upgrades_level
						local level_data = Config.derrick.levels[level]

						local n_value = math.clamp( value, 0, ( level_data.health - currentBusinessData.health ) )

						if n_value ~= value then
							element[6] = tostring(n_value)
						end

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local stw,sth = 300, 20
						local stx, sty = x+w/2-stw/2, y-sth-15

						dxDrawImage(
							stx,sty,stw,sth, 'assets/images/state.png',
							0, 0, 0, tocolor(39,42,72,255*alpha)
						)

						local level = currentBusinessData.upgrades_level
						local level_data = Config.derrick.levels[level]

						local amount = tonumber( fixAmount_input[6] ) or 0

						local progress = math.clamp( currentBusinessData.health/level_data.health, 0, 1 )
						local i_progress = math.clamp( ( currentBusinessData.health + amount )/level_data.health, 0, 1 )

						mta_drawImageSection(
							px(stx)+2,px(sty)+2,px(stw)-4,px(sth)-4, 'assets/images/state.png',
							{ y = 1, x = progress }, tocolor(180, 70, 70,255*alpha)
						)

						mta_drawImageSection(
							px(stx)+2,px(sty)+2,px(stw)-4,px(sth)-4, 'assets/images/state.png',
							{ y = 1, x = i_progress }, tocolor(180, 70, 70,120*alpha)
						)

						dxDrawText(string.format('%s / %s', currentBusinessData.health or 0, level_data.health),
							stx,sty,stx+stw,sty+sth,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
							'center', 'center'
						)

					end,

				},

    			{'button',
    				'center', function(s,p) return p[5] - s[5] - 30 end,
    				[6] = 'Заказать',

					onInit = function(element)
						element.animationAlpha = {}
						setAnimData(element.animationAlpha, 0.1, 1)
					end,

					onClick = function(element)

						local x,y,w,h = element:abs()
						animate(element.animationAlpha, 0)

						displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1000, function()

							animate(element.animationAlpha, 1)

							local amount = tonumber( fixAmount_input[6] ) or 0

							if amount <= 0 then return end

							triggerServerEvent('derrick.orderFix', resourceRoot, currentBusinessData.id, amount)

							currentWindowSection = 'main'

						end )

					end,

    			},

			},

		},

	},

}

--------------------------------------------------------

	__basic_Ignore.gui_dialog = true
	__basic_Ignore.gui_input_dialog = true
	__basic_Ignore.order_fix = true

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
			{ type = 'number', name = 'Баланс', params = { [6] = currentBusinessData.balance, onRender = params.onRender } },
			{ type = 'text', name = 'Владелец', params = { [6] = currentBusinessData.owner or '', onRender = params.onRender } },
			{ type = 'number', name = 'Уровень', params = { [6] = currentBusinessData.upgrades_level or 1, onRender = params.onRender } },
			{ type = 'number', name = 'Починка', params = { [6] = currentBusinessData.fix_amount or 0, onRender = params.onRender } },
			{ type = 'number', name = 'HP', params = { [6] = currentBusinessData.health or 0, onRender = params.onRender } },
		}, function(data)

			if data then

				triggerServerEvent('derrick.edit', resourceRoot, currentBusinessData.id, {
					balance = data[1],
					owner = data[2],
					upgrades_level = data[3],
					fix_amount = data[4],
					health = data[5],
				})

				if data[2] ~= currentBusinessData.owner then
					closeWindow()
				end

			end

		end)

	end

--------------------------------------------------------

	GUIDefine('button', {

		[4] = 200, [5] = 38,

		bg = 'assets/images/btn_empty.png',
		activeBg = 'assets/images/btn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 20, 'light'),

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shw,shh = w*212/180-2,h*67/33-2

			if element.shadow_size then
				shw, shh = unpack(element.shadow_size)
			end

			local shx,shy = x + w/2 - shw/2, y + h/2 - shh/2

			local r,g,b = unpack(element.color)

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/btn_empty_shadow.png',
				0, 0, 0, tocolor(r,g,b, 255*alpha*(1-element.animData))
			)

			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/btn_shadow.png',
				0, 0, 0, tocolor(r,g,b, 255*alpha*element.animData)
			)

		end,

		onRender = function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			if element.icon then

				local isize = 30

				dxDrawImage(
					x + 20, y+h/2-isize/2,
					isize, isize, element.icon,
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

			end


		end,

	})

	GUIDefine('input', {

		[4] = 200, [5] = 38,
		[6] = '',

		bg = 'assets/images/btn.png',

		scale = 0.5,
		font = getFont('montserrat_semibold', 20, 'light'),

		alignX = 'center',

		color = {39, 42, 72, 255},
		placeholderColor = {200, 200, 200, 255},

	})

	GUIDefine('info-block', {

		[4] = 205, [5] = 50,

		getData = function(element)
			return 'Название', 'Значение'
		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local name, data = element:getData()

			dxDrawText(name,
				x + 20, y + 7,
				x + 20, y + 7,
				tocolor(200,200,200,255*alpha),
				0.5, 0.5, getFont('montserrat_medium', 19, 'light'),
				'left', 'top'
			)
			dxDrawText(data,
				x + 20, y + h - 7,
				x + 20, y + h - 7,
				tocolor(255,255,255,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
				'left', 'bottom'
			)


			if element.icon then

				local iw,ih = 50,50
				local ix,iy = x+w-h/2-ih/2, y+h/2-ih/2

				if element.drop_icon then

					ix = ix - 27

					local dw,dh = 20,20
					local dx,dy = ix+iw-5, y+h/2-dh/2

					dxDrawImage(
						dx,dy,dw,dh, 'assets/images/oil_drop.png',
						0, 0, 0, tocolor(180, 70, 70, 255*alpha)
					)

				end

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/info_block_round.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				if fileExists(element.icon) then

					dxDrawImage(
						ix,iy,iw,ih, element.icon,
						0, 0, 0, tocolor(255, 255, 255, 255*alpha)
					)					

				else

					dxDrawText(element.icon,
						ix,iy,ix+iw,iy+ih,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
						'center', 'center'
					)

				end

			end

		end,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			dxDrawImage(
				x,y,w,h, 'assets/images/info_block.png',
				0, 0, 0, tocolor(34,38,68, 255*alpha)
			)

		end,


	})

--------------------------------------------------------

loadGuiModule()


end)

