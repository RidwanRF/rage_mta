
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

	exports.main_sounds:playSound('waterdrop')

	showChat( false )
end

closeHandler = function()
	showChat( true )
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	__basic = {

		{'image',
			'center', 'center',
			798, 594,
			'assets/images/bg.png',
			color = { 28,27,42,255 },

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local shw,shh = 878, 674
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2 

				dxDrawImage(
					shx,shy, shw,shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor( 215, 0, 150, 150*alpha )
				)

				local bw,bh = 263, 445
				local bx,by = x-263+10, y+h/2-bh/2

				dxDrawImage(
					bx,by,bw,bh, 'assets/images/bg1.png',
					0, 0, 0, tocolor( 255, 255, 255, 255*alpha )
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y, w,h, 'assets/images/bg2.png',
					0, 0, 0, tocolor( 255, 255, 255, 255*alpha )
				)

				local lw,lh = 191, 54
				local lx,ly = x + 50, y + 40

				dxDrawImage(
					lx,ly,lw,lh, 'assets/images/logo.png',
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				local tw,th = 282, 36
				local tx,ty = lx+lw+15, ly+lh/2-th/2+3

				dxDrawImage(
					tx,ty,tw,th, 'assets/images/title.png',
					0, 0, 0, tocolor( 21,21,33,255*alpha )
				)

				local energy_str = splitWithPoints( localPlayer:getData('cyberquest.energy') or 0, '.' )
				local to_next_energy_str = splitWithPoints( getToNextLevel( localPlayer ), '.' )

				local time = {}

				local seconds = Config.finish - getRealTime().timestamp

				time.d = math.floor( seconds / 86400 )
				time.h = math.floor( ( seconds - 86400*time.d ) / 3600 )
				time.m = math.floor( ( seconds - 86400*time.d - 3600*time.h ) / 60 )
				time.s = math.floor( ( seconds - 86400*time.d - 3600*time.h - 60*time.m ) )

				local time_str = ('%02d:%02d:%02d:%02d'):format( time.d, time.h, time.m, time.s )

				drawSmartText(string.format('%s <img>assets/images/timer.png</img>     %s / %s <img>assets/images/energy.png</img>',
					time_str, energy_str, to_next_energy_str
				),
					tx, tx+tw, ty+th/2, 
					tocolor(255,255,255,255*alpha),
					tocolor(215,0,150,255*alpha),
					0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 35, -5, 1
				)

			end,

			elements = {

				{'button',
					function(s,p) return p[4] - s[4] - 45 end, 45,
					47,47,
					'',
					bg = 'assets/images/close1.png',
					color = { 215, 0, 150, 255 },

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close2.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end,

					onClick = closeWindow,

				},

				{'element',

					70, 120,
					0, 0,
					color = {255,255,255,255},

					tabs = {
						{ id = 'main', name = 'Главная', },
						{ id = 'quests', name = 'Задания', },
						{ id = 'progress', name = 'Прогресс', },
					},

					onInit = function(element)

						local startX = 0

						local tw,th = 120, 50

						for _, tab in pairs( element.tabs ) do

							element:addElement(
								{'element',

									startX, 0,
									tw,th,
									color = {255,255,255,255},

									tab = tab,

									onInit = function(element)

										element.h_anim = {}
										setAnimData( element.h_anim, 0.1 )

									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local anim = getAnimData( element.h_anim )
										animate( element.h_anim, element.tab.id == currentWindowSection and 1 or 0 )

										local tw,th = 114,39
										local tx,ty = x+w/2-tw/2, y+h/2-th/2

										local r,g,b = interpolateBetween( 60,60,70, 215,0,150, anim, 'InOutQuad' )

										dxDrawImage(
											tx,ty,tw,th, 'assets/images/tab_shadow.png',
											0, 0, 0, tocolor( 215,0,150,255*anim )
										)

										dxDrawText(element.tab.name,
											x,y,x+w,y+h,
											tocolor( r,g,b,255*alpha ),
											0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
											'center', 'center'
										)

										mta_dxDrawRectangle(
											px(x),px(y+h),px(w), 1, tocolor(r,g,b,255*alpha)
										)

									end,

									onClick = function(element)
										currentWindowSection = element.tab.id
									end,

								}
							)

							startX = startX + tw

						end

					end,

				},

				{'element',
					60, 200,
					1000, 600, 
					color = {255,255,255,255},

					noDraw = function(element)	
						return currentWindowSection ~= 'main'
					end,

					variable = 'mainInfo',

					onInit = function(element)

						openHandlers.main_info = function()

							if currentWindowSection == 'main' then

								mainInfo.renderTarget = dxCreateRenderTarget(
									mainInfo[4], mainInfo[5], true
								)

								dxSetBlendMode( 'modulate_add' )
								dxSetRenderTarget( mainInfo.renderTarget )

									mainInfo:render()

								dxSetRenderTarget(  )
								dxSetBlendMode( 'blend' )

							end

						end

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, element.renderTarget,
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end,

					text = {

						{
							'Участвуй в специальных заданиях и собирай #d70096Энергию#ffffff,',
							'чтобы прокачать свой уровень.',
						},

						{
							'За прокачку ты получаешь призы (вкладка #d70096Прогресс#ffffff).',
							'Самый главный приз - #d70096Quadra V-TECH#ffffff.',
						},

						{
							'По карте разбросаны #d70096Сгустки#ffffff,',
							'собирай их и получишь очки #d70096Энергии#ffffff.',
						},

						{
							'В красной зоне Гетто появляются #d70096Аккумуляторы#ffffff,',
							'Сражайся за них и получай еще больше очков!',
						},

						{
							'Вводи бонус-код #d70096CASINO#ffffff,',
							'чтобы получить Quadra V-TECH на 14 дней!',
						},

					},

					render = function(element)

						local alpha = 1

						local startX, startY = 30,30

						local rw1,rh1 = 60,60
						local rw2,rh2 = 20,20

						mta_dxDrawImage(
							startX - rw2/2, startY - rh2/2,
							rw2,rh2, 'assets/images/round.png',
							0, 0, 0, tocolor( 215, 0, 150, 255*alpha )
						)

						mta_dxDrawText('Настало время Киберзаданий!',
							startX + 30, startY, 
							startX + 30, startY,
							tocolor( 255,255,255,255*alpha ),
							0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
							'left', 'center'
						)

						startY = startY + 60

						for index, row in pairs( element.text or {} ) do

							local rx1,ry1 = startX - rw1/2, startY - rh1/2

							mta_dxDrawImage(
								rx1,ry1,
								rw1,rh1, 'assets/images/round.png',
								0, 0, 0, tocolor( 215, 0, 150, 255*alpha )
							)

							mta_dxDrawText(index,
								rx1,ry1,rx1+rw1,ry1+rh1,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_bold', 25, 'light'),
								'center', 'center'
							)

							mta_dxDrawText(row[1],
								rx1+rw1+8,ry1+rh1/2,
								rx1+rw1+8,ry1+rh1/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
								'left', 'bottom', false, false, false, true
							)

							mta_dxDrawText(row[2],
								rx1+rw1+8,ry1+rh1/2,
								rx1+rw1+8,ry1+rh1/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
								'left', 'top', false, false, false, true
							)

							startY = startY + 60

						end

					end,

				},

				{'element',

					'center', 215,
					620, 310,
					color = {255,255,255,255},

					noDraw = function(element)	
						return currentWindowSection ~= 'quests'
					end,

					onRender = function(element)
						element.quests = localPlayer:getData('cyberquest.quests') or {}
						element.timestamp = getServerTimestamp()
					end,

					addEvent('cyberquest.receiveClientQuests', true),
					addEventHandler('cyberquest.receiveClientQuests', resourceRoot, function( quests )
						localPlayer:setData('cyberquest.quests', quests, false)
					end),

					onInit = function( element )

						element.p_anim = {}
						setAnimData(element.p_anim, 0.05)

						setTimer(function()

							setAnimData(element.p_anim, 0.05)
							animate(element.p_anim, 1)

						end, 2500, 0)

						local startX = 0
						local startY = 0

						local qw,qh = 300,154
						local padding = 20

						local index = 1

						for i1 = 1,2 do

							for i2 = 1,2 do

								element:addElement(
									{'image',

										startX, startY,
										qw,qh,

										'assets/images/quest_bg.png',
										color = {21,21,33,255},

										slot = index,

										onInit = function(element)
											element.y0 = element[3]
										end,

										onRender = function(element)

											element[3] = element.y0 - 5*element.animData

											local r,g,b = interpolateBetween( 21,21,33, 25,25,37, element.animData, 'InOutQuad' )
											element.color = { r,g,b, element.color[4] }

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local quest_data = element.parent.quests[ element.slot ]
											if not quest_data then return end

											local quest_config = Config.dailyQuests[ quest_data.questId ]

											if quest_data.renew_timestamp then

												local time = {}

												local seconds = quest_data.renew_timestamp - element.parent.timestamp.timestamp

												time.h = math.floor( ( seconds ) / 3600 )
												time.m = math.floor( ( seconds - 3600*time.h ) / 60 )
												time.s = math.floor( ( seconds - 3600*time.h - 60*time.m ) )

												local time_str = ('%02d:%02d:%02d'):format( time.h, time.m, time.s )

												drawSmartText(string.format('<img>assets/images/timer.png</img> %s',
													time_str
												),
													x-15, x+w, y+h/2,
													tocolor(255,255,255,255*alpha),
													tocolor(215,0,150,255*alpha),
													0.5, getFont('montserrat_semibold', 30, 'light'),
													'center', 45, 0, 1
												)

											else

												local rw,rh = 60,60
												local rx,ry = x-rw/2+15, y-rh/2+15

												dxDrawImage(
													rx,ry,rw,rh, 'assets/images/round.png',
													0, 0, 0, tocolor(215,0,150,255*alpha)
												)

												dxDrawText(element.slot,
													rx,ry,rx+rw,ry+rh,
													tocolor(255,255,255,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
													'center', 'center'
												)

												local lw,lh = 148,4
												local lx,ly = x+w/2-lw/2, y+h-lh-40

												dxDrawImage(
													lx,ly,lw,lh, 'assets/images/line.png',
													0, 0, 0, tocolor(28,27,42,255*alpha)
												)

												local points = math.floor(
													(quest_config.progressPoints - quest_data.progressPoints)
												)
												local progress = math.clamp(points / quest_config.progressPoints, 0, 1)

												drawImageSection(
													lx,ly,lw,lh, 'assets/images/line.png',
													{ y = 1, x = progress }, tocolor( 215,0,150,255*alpha )
												)

												local animData = getAnimData(element.parent.p_anim)

												drawImageSection(
													lx,ly,lw,lh, 'assets/images/line.png',
													{ y = 1, x = progress*animData }, tocolor( 255,100,210,255*alpha*(1-animData) )
												)

												dxDrawText(points,
													lx+5,ly+lh+4,
													lx+5,ly+lh+4,
													tocolor( 60,60,80,255*alpha ),
													0.5, 0.5, getFont('montserrat_bold_italic', 24, 'light'),
													'left', 'top'
												)

												dxDrawText(quest_config.progressPoints,
													lx+lw-5,ly+lh+4,
													lx+lw-5,ly+lh+4,
													tocolor( 60,60,80,255*alpha ),
													0.5, 0.5, getFont('montserrat_bold_italic', 24, 'light'),
													'right', 'top'
												)

												dxDrawText(quest_config.name,
													x,y+40,x+w,y+40,
													tocolor( 255,255,255,255*alpha ),
													0.5, 0.5, getFont('montserrat_bold_italic', 19, 'light'),
													'center', 'center'
												)

												local totalWidth = 0

												local scale, font = 0.5, getFont('montserrat_bold_italic', 20, 'light')
												local iw,ih = 18,18
												local i_padding = 7
												local padding = 10

												for index, item in pairs( quest_config.reward.items ) do

													item.textWidth = item.textWidth or dxGetTextWidth( item.text, scale, font )
													totalWidth = totalWidth + item.textWidth + iw + i_padding

												end

												totalWidth = totalWidth + ( #quest_config.reward.items - 1 )*padding

												local startX = x+w/2- totalWidth/2
												local startY = y+80

												for index, item in pairs( quest_config.reward.items ) do

													dxDrawImage(
														startX, startY - ih/2,
														iw,ih, item.icon,
														0, 0, 0, tocolor( 255,255,255,255*alpha )
													)

													dxDrawText(item.text,
														startX + i_padding + iw, startY, 
														startX + i_padding + iw, startY,
														tocolor(255,255,255,255*alpha),
														scale, scale, font,
														'left', 'center' 
													)

													startX = startX + item.textWidth + iw + i_padding + padding

												end

											end


										end,

									}
								)

								index = index + 1
								startX = startX + qw + padding

							end

							startX = 0
							startY = startY + qh + padding

						end

					end

				},

				{'element',
					'center', 190,
					'100%', 400,
					color = {255,255,255,255},

					noDraw = function(element)	
						return currentWindowSection ~= 'progress'
					end,

					elements = {

						{'image',
							'center', 0,
							651, 50,
							'assets/images/p_head.png',
							color = {21,21,33,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local scale, font = 0.5, getFont('montserrat_semibold', 23, 'light')
								local text = 'Уровень'

								local textWidth = dxGetTextWidth( text, scale, font )

								dxDrawText(text,
									x + 30, y,
									x + 30, y+h,
									tocolor(255,255,255,255*alpha),
									scale, scale, font,
									'left', 'center'
								)

								local lw,lh = 92,64
								local lx,ly = x + textWidth + 25, y+h/2-lh/2

								dxDrawImage(
									lx,ly,lw,lh, 'assets/images/p_level.png',
									0, 0, 0, tocolor( 215,0,150,255*alpha )
								)

								dxDrawText(('%s / %s'):format( localPlayer:getData('cyberquest.level') or 1, #Config.levels ),
									lx,ly-3,lx+lw,ly+lh,
									tocolor( 255,255,255,255*alpha ),
									0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
									'center', 'center'
								)

								local scale, font = 0.5, getFont('montserrat_bold_italic', 19, 'light')

								local energy = localPlayer:getData('cyberquest.energy') or 0
								local text = ('До следующего %sоч.'):format( getToNextLevel( localPlayer ) - energy )

								if getPlayerLevel( localPlayer ) >= #Config.levels then
									text = 'Макс. уровень'
								end

								local textWidth = dxGetTextWidth( text, scale, font )

								dxDrawText(text,
									lx + lw, y,
									lx + lw, y+h,
									tocolor( 110,110,115,255*alpha ),
									scale, scale, font,
									'left', 'center'
								)

								local text2 = 'Докупите очки'
								local textWidth2 = dxGetTextWidth( text2, scale, font )

								local dx = x + w - 300

								dxDrawText(text2,
									dx, y,
									dx, y+h,
									tocolor( 110,110,115,255*alpha ),
									scale, scale, font,
									'left', 'center'
								)

								drawSmartText(string.format('1 <img>assets/images/c_energy.png</img> =  %s <img>assets/images/donate.png</img>',
									Config.energyCost
								),
									dx + textWidth2 + 10,
									dx + textWidth2 + 10,
									y+h/2,
									tocolor(255,255,255,255*alpha),
									tocolor(255,255,255,255*alpha),
									0.5, getFont('montserrat_bold', 24, 'light'),
									'left', 20, 0, 1
								)

							end,

							elements = {

								{'button',
									function(s,p) return p[4] - s[4] - 13 end, 'center',
									32,32,
									'>>',
									bg = 'assets/images/p_buy.png',
									color = {215,0,150,255},
									activeColor = {255,70,200,255},

									scale = 0.5,
									font = getFont('montserrat_bold', 19, 'light'),

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shw,shh = 53, 51
										local shx,shy = x+w/2-shw/2, y+h/2-shh/2 

										dxDrawImage(
											shx,shy, shw,shh, 'assets/images/p_buy_shadow.png',
											0, 0, 0, tocolor( 215, 0, 150, 150*alpha*element.animData )
										)

									end,

									onClick = function(element)

										local amount = tonumber( buyLevel_amount[6] ) or 0

										if amount <= 0 then
											return exports.hud_notify:notify( 'Ошибка', 'Введите сумму' )
										end

										triggerServerEvent('cyberquest.buyEnergy', resourceRoot, amount)
										buyLevel_amount[6] = ''

									end,

								},

								{'input',
									function(s,p) return p[4] - s[4] - 52 end, 'center',
									50,32,
									'',
									bg = 'assets/images/p_input.png',
									color = {14,14,24,255},

									variable = 'buyLevel_amount',

									type = 'number',
									maxSymbols = 3,

									textPadding = 0,
									alignX = 'center',

									scale = 0.5,
									font = getFont('montserrat_bold', 18, 'light'),

								},

							},

						},

						{'level', 'center', 100, ticket = 'default',},
						{'level', 'center', 265, ticket = 'vip',},

					},


				},

			},

		},

	},

	main = {

	},

	quests = {},

	progress = {},

}

--------------------------------------------------------------------

	GUIDefine('level', {

		[4] = 651, [5] = 120,
		color = { 255,255,255,255 },

		overflow = 'horizontal',
		level = 0,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			element[3] = element.y0 - 5*element.animData

			local r,g,b = interpolateBetween( 21,21,33, 25,25,37, element.animData, 'InOutQuad' )
			element.color = { r,g,b, element.color[4] }

			dxDrawImage(
				x,y,w,h, 'assets/images/item_level.png',
				0, 0, 0, tocolor( r,g,b,255*alpha )
			)

			local text = element.ticket == 'default' and 'Стандартный пропуск' or '#d70096VIP#ffffff-пропуск'

			dxDrawText(text,
				x+20, y-10,
				x+20, y-10,
				tocolor(255,255,255,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold_italic', 25, 'light'),
				'left', 'bottom', false, false, false, true
			)

			if element.ticket == 'vip' then

				dxDrawText(localPlayer:getData('cyberquest.ticket') == 'vip' and 'Активирован' or 'Не активирован',
					x+w-20, y-10,
					x+w-20, y-10,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold_italic', 25, 'light'),
					'right', 'bottom'
				)

			end

			element.level = getPlayerLevel( localPlayer )

		end,

		scroll_step = 35,

		onInit = function(element)

			element.y0 = element[3]

			local startX = 50

			local w,h = 135, element[5]
			local padding = 20

			for index, level in pairs( Config.levels ) do

				element:addElement(
					{'element',

						startX, 'center',
						w,h,
						color = {255,255,255,255},

						level = level,
						index = index,

						onRender = function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							local ticket_type = localPlayer:getData('cyberquest.ticket') or 'default'

							local text
							local d_alpha

							if (element.parent.level >= element.index) then

								text = 'Пройдено'
								d_alpha = 1

								if element.parent.ticket == 'vip' and ticket_type == 'default' then
									text = 'Не пройдено'
									d_alpha = 0.5
								end

							else

								text = ( 'Уровень ' .. element.index )
								d_alpha = 0.5

							end


							local rewards = element.level.reward[ element.parent.ticket ].prize
							local add = (#rewards == 2 and 25 or 35)

							dxDrawText(text,
								x, y+add,
								x, y+add,
								tocolor( 80, 80, 90, 255*alpha ),
								0.5, 0.5, getFont('montserrat_semibold_italic', 24, 'light'),
								'left', 'top'
							)

							-- if (element.parent.level >= element.index) then

							-- 	local sw,sh = 114, 39
							-- 	local shx, shy = x+w/2-sw/2, y+h/2-sh/2

							-- 	dxDrawImage(
							-- 		shx,shy,sw,sh, 'assets/images/tab_shadow.png',
							-- 		0, 0, 0, tocolor( 215, 0, 150, 255*alpha )
							-- 	)

							-- end


							local startY = y + 60

							if #rewards == 2 then
								startY = y + 50
							end

							local rowH = 25

							for _, row in pairs( rewards ) do

								local iw,ih = 20,20
								local ix,iy = x+5, startY

								dxDrawImage(
									ix,iy,iw,ih, ('assets/images/icons/%s.png'):format( row.icon or row.key ),
									0, 0, 0, tocolor( 255,255,255,255*alpha*d_alpha )
								)

								row.text = row.text or splitWithPoints( row.amount, '.' )

								dxDrawText(row.text and row.text or splitWithPoints( row.amount, '.' ),
									ix+iw+10, iy,
									ix+iw+10, iy+ih,
									tocolor(255,255,255,255*alpha*d_alpha),
									0.5, 0.5, getFont('montserrat_bold', 22, 'light'),
									'left', 'center'
								)

								startY = startY + rowH

							end

						end,

					}
				)

				startX = startX + w + padding

			end

			element:addElement(
				{'element',
					startX, 'center',
					30, '100%',
					color = {255,255,255,255},
				}
			)

		end,

	})

--------------------------------------------------------------------

loadGuiModule()


end)

