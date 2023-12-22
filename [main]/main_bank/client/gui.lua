
openHandler = function()
end

closeHandler = function()
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	__basic = {

		{'element',
			0, 0, 0, 0, 
			color = {255,255,255,255},

			onRender = function(element)
				if localPlayer.vehicle then return closeWindow() end
			end,
		},

	},

	main = {

		{'image',

			sx/2 - 539/2, sy/2 - 537/2,
			539, 537,
			color = {27,30,56,255},
			'assets/images/bg.png',

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 555/2-1,
					y + h/2 - 555/2 + 5,
					557, 555, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onRender = {

				sections = function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					drawImageSection(
						x,y,w,h, element[6],
						{ x = (w-161)/w, y = (h-89)/h, }, tocolor(32,35,66,255*alpha), 1
					)

					dxDrawText('RAGEBank',
						x,y, x+161, y+89,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
						'center', 'center'
					)

				end,

				account = function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local lw,lh = 21,45
					local lx,ly = x + 161 + 20, y + 89/2 - lh/2

					dxDrawImage(
						lx,ly,lw,lh, 'assets/images/vline.png',
						0, 0, 0, tocolor(180, 70, 70, 255*alpha)
					)

					dxDrawText(splitWithPoints( localPlayer:getData('bank.rub') or 0, '.' ) .. ' $',
						lx+lw+4,ly,
						lx+lw+4,ly,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
						'left', 'top'
					)

					dxDrawText('Состояние счета',
						lx+lw+4,ly+23,
						lx+lw+4,ly+23,
						tocolor(170,170,170,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
						'left', 'top'
					)


				end,

			},

			elements = {

				{'button',

					0, 0, 33,33,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 89/2 - element[5]/2

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

				{'tabs',

					0, 89+45,
					161, 0,
					color = {255,255,255,255},

					id = 'tabs',
					variable = 'tabsElement',
					tab = 'main',

					onPostInit = function(element)

						local startY = 0

						for _, c_element in pairs( element.elements or {} ) do

							c_element[2] = 30
							c_element[3] = startY-40
							c_element[4] = element[4]

							startY = startY + c_element[5]
						end

					end,

					elements = {

						{'tab', section = { id = 'main', name = 'Главная', }, },
						{'tab', section = { id = 'withdraws', name = 'Штрафы', }, },
						{'tab', section = { id = 'deposits', name = 'Вклады', }, },
						{'tab', section = { id = 'history', name = 'История', }, },

					},

					onKey = {

						tab = function(element)

							local index = 0
							for _index, c_element in pairs( element.elements ) do

								if c_element[1] == 'tab' and c_element.section.id == element.tab then

									index = _index
									break

								end

							end

							element.tab = element.elements[ cycle( index + 1, 1, #element.elements ) ].section.id

						end,

					},

				},

				{'section',

					id = 'section-main',
					tab = 'take',

					elements = {

						{'button',

							[3] = 30,
							define_from = 'main-tab',
							section = 'take',
							[6]='Снятие наличных',

						},

						{'button',

							[3] = 90,
							define_from = 'main-tab',
							section = 'put',
							[6]='Пополнение счета',

						},

						{'button',

							[3] = 150,
							define_from = 'main-tab',
							section = 'send',
							[6]='Перевод игроку',

						},

						{'input',

							'center', 230,

							id = 'main-login',
							placeholder = 'Введите логин игрока',

							onRender = function(element)
								element.disabled = gui_get('section-main').tab ~= 'send'
							end,

							onPreRender = function(element)

								if gui_get('section-main').tab == 'send' then

									local input = gui_get('main-sum')
									local value = tonumber( input[6] ) or 0

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									local comission = math.floor( value * Config.sendComission / 100 )

									if comission > 0 then

										dxDrawText(('Комиссия на перевод: $%s'):format( splitWithPoints( comission, '.' ) ),
											x, y - 7, x + w, y - 7,
											tocolor( 150,150,150,255*alpha ),
											0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
											'center', 'bottom'
										)

									end

								end

							end,

						},

						{'input',

							'center', 290,

							id = 'main-sum',
							placeholder = 'Введите сумму',

							type = 'number',

						},

						{'button',

							[3] = 365,
							[6]='Продолжить',

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							onClick = function(element)

								local x,y,w,h = element:abs()

								animate(element.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 500, function()

									animate(element.animationAlpha, 1)

									local events = {
										take = 'bank.takeMoney',
										put = 'bank.putMoney',
										send = 'bank.sendMoney',
									}

									local sum = tonumber( gui_get('main-sum')[6] ) or 0
									local login = gui_get('main-login')[6]

									triggerServerEvent(events[ gui_get('section-main').tab ], resourceRoot, sum, login)

									gui_get('main-sum')[6] = ''
									gui_get('main-login')[6] = ''


								end )

							end,

						},

					},

				},

				{'section',

					id = 'section-withdraws',

					elements = {

						{'element',

							'center', 50,
							'100%', 0,
							color = {255,255,255,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText(string.format('%s $',
									splitWithPoints( localPlayer:getData('police.withdraws') or 0, '.' )
								),
									x,y,x+w,y,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
									'center', 'top'
								)

								dxDrawText('Общая сумма штрафов',
									x,y+30,x+w,y+30,
									tocolor(180,180,180,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top'
								)

							end,

						},

						{'input',

							'center', 120,
							id = 'withdraws-sum',
							placeholder = 'Введите сумму',

							type = 'number',
						},

						{'element',

							'center', 195,
							'100%', 0,

							color = {255,255,255,255},

							onPostInit = function(element)

								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)

								local last_c = element.elements[ #element.elements ]
								local totalH = last_c[3] + last_c[5]
								element[5] = totalH

							end,

							displayLoading = function(element, callback)

								local x,y,w,h = element:abs()

								animate(element.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 500, function()

									animate(element.animationAlpha, 1)
									callback()

								end )

							end,

							payWithdraws = function(element)

								local sum = tonumber( gui_get('withdraws-sum')[6] ) or 0

								triggerServerEvent('bank.payWithdraws', resourceRoot, sum)
								gui_get('withdraws-sum')[6] = ''

							end,

							elements = {

								{'button',

									[3] = 0,
									[6]='Оплатить',

									onClick = function(element)

										element.parent:displayLoading(function()
											element.parent:payWithdraws()
										end)

									end,

								},

								{'button',

									[3] = 60,
									[6]='Оплатить все',

									onClick = function(element)

										gui_get('withdraws-sum')[6] = localPlayer:getData('police.withdraws') or 0

										element.parent:displayLoading(function()
											element.parent:payWithdraws()
										end)

									end,

								},
							
							},

						},


					},

				},

				{'section',

					id = 'section-deposits',

					elements = {

						{'element',

							'center', 50,
							'100%', 0,
							color = {255,255,255,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawText('Сумма ваших вкладов',
									x,y,x+w,y,
									tocolor(180,180,180,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top'
								)

								dxDrawText(string.format('%s $',
									splitWithPoints( localPlayer:getData('bank.deposits') or 0, '.' )
								),
									x,y+20,x+w,y+20,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
									'center', 'top'
								)

								dxDrawText(string.format('+%s%% каждые 24 часа', Config.depositPercent.default),
									x,y+55,x+w,y+55,
									tocolor(180,180,180,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
									'center', 'top'
								)
								dxDrawText(string.format('+%s%% при наличии VIP', Config.depositPercent.vip),
									x,y+72,x+w,y+72,
									tocolor(180,180,180,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
									'center', 'top'
								)


							end,

						},

						{'input',
							'center', 170,
							id = 'deposits-sum',
							placeholder = 'Введите сумму',

							type = 'number',

						},

						{'element',

							'center', 245,
							'100%', 0,

							color = {255,255,255,255},

							onPostInit = function(element)

								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)

								local last_c = element.elements[ #element.elements ]
								local totalH = last_c[3] + last_c[5]
								element[5] = totalH

							end,

							displayLoading = function(element, callback)

								local x,y,w,h = element:abs()

								animate(element.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 500, function()

									animate(element.animationAlpha, 1)
									callback()

								end )

							end,

							elements = {

								{'button',

									[3] = 0,
									[6]='Пополнить',

									onClick = function(element)
										element.parent:displayLoading(function()

											local sum = tonumber( gui_get('deposits-sum')[6] ) or 0
											triggerServerEvent('bank.putDepositMoney', resourceRoot, sum)
											gui_get('deposits-sum')[6] = ''

										end)
									end,

								},

								{'button',

									[3] = 60,
									[6]='Снять',

									onClick = function(element)
										element.parent:displayLoading(function()

											local sum = tonumber( gui_get('deposits-sum')[6] ) or 0
											triggerServerEvent('bank.takeDepositMoney', resourceRoot, sum)
											gui_get('deposits-sum')[6] = ''

										end)
									end,

								},
							
							},

						},


					},

				},

				{'section',

					id = 'section-history',

					elements = {

						{'list',

							0, 0,
							'100%', '100%',

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {0, 0, 0,255},
							scrollWidth = 5,

							scrollXOffset = -25,
							scrollHeight = 0.7,

							listOffset = 0,

							listElements = {
								
							},

							font = getFont('montserrat_semibold', 26, 'bold'),
							scale = 0.5,

							listElementHeight = 73,

							color = {255,255,255,255},

							onRender = function(element)

								local list = { { begin = true } }

								for _, row in pairs( localPlayer:getData('bank.history') or {} ) do
									table.insert(list, row)
								end

								element.listElements = table.reverse(list)

							end,

							id = 'history-list',

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local height = lElement.height or element.listElementHeight

								local x,y,w,h = x,y+height/2-63/2, ew, 63

								if lElement.begin then

									for i = 1,2 do
										dxDrawText('Это начало вашей истории',
											x,y,x+w,y+h,
											tocolor(180, 180, 180, 200*alpha),
											0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
											'center', 'center'
										)
									end

								else

									local r,g,b = 25,27,55

									dxDrawRectangle(
										x,y,w,h, tocolor(r,g,b,255*alpha)
									)

									dxDrawText(lElement.name,
										x+20, y+h/2+1,
										x+20, y+h/2+1,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'left', 'bottom'
									)
									dxDrawText(lElement.date,
										x+20, y+h/2-1,
										x+20, y+h/2-1,
										tocolor(180,180,180,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'left', 'top'
									)

									local text = splitWithPoints( math.abs(lElement.sum), '.' ) .. ' $'

									local pre_color = lElement.sum > 0 and '#58cd46+#ffffff' or '#b64747-#ffffff'

									dxDrawText(pre_color .. text,
										x+w-35, y,
										x+w-35, y+h,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_bold', 28, 'light'),
										'right', 'center', false, false, false, true
									)

								end

							end,

						},


					},

				},

			},

		},

	},

}

----------------------------------------------------------------------

	GUIDefine('tab', {
		
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 45,
		color = {255,255,255,255},

		onInit = function(element)
			element.b_animId = 'section-'..element.section.id
			setAnimData(element.b_animId, 0.1)
		end,

		onClick = function(element)
			tabsElement.tab = element.section.id
		end,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local animData = getAnimData(element.b_animId)

			if not animData then
				setAnimData(element.b_animId, 0.1)
				animData = 0
			end

			animate(element.b_animId, tabsElement.tab == element.section.id and 1 or 0)

			local r,g,b = interpolateBetween( 170,170,170, 255,255,255, animData, 'InOutQuad' )

			local text = element.section.name
			local scale, font = 0.5, getFont('montserrat_semibold', 26, 'light')

			local textHeight = dxGetFontHeight( scale, font )

			dxDrawText(text,
				x,y,
				x,y+h,
				tocolor(r,g,b,255*alpha),
				scale, scale, font,
				'left', 'center'
			)

			dxDrawImage(
				x-10+2 - 20 * (1-animData), y+h/2+textHeight/2-10+4,
				56,21, 'assets/images/active_tab.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
			)




		end,

	})

	GUIDefine('section', {

		[2]='right', [3]='bottom',
		[4]=539-161, [5]=537-89,

		color = {255,255,255,255},

		onInit = function(element)
			element.x0 = element[2]
			element.animationAlpha = element.id
		end,

		onRender = function(element)

			local animData = getAnimData(element.animationAlpha)

			element[2] = element.x0 - 20 * (1-animData)

		end,

	})

	GUIDefine('input', {

		[4] = 273, [5] = 47,

		bg = 'assets/images/input.png',
		alignX = 'center',

		color = {37,42,74,255},
		activeColor = {47,52,84,255},
		placeholderColor = {75,78,101,255},
		[6] = '',

		font = getFont('montserrat_medium', 23, 'light'),
		scale = 0.5,

	})

----------------------------------------------------------------------

	GUIDefine('main-tab', {

		[2] = 'center',
		[4] = 216, [5] = 42,

		bg = 'assets/images/main_tab_empty.png',
		activeBg = 'assets/images/main_tab.png',

		font = getFont('montserrat_medium', 21, 'light'),
		scale = 0.5,

		onClick = function(element)
			gui_get('section-main').tab = element.section
		end,

		onRender = function(element)

			local active = gui_get('section-main').tab == element.section

			element.bg = active and 'assets/images/main_tab.png' or 'assets/images/main_tab_empty.png'

		end,

		onPreRender = function(element)

			local alpha = getElementDrawAlpha(element)

			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 247/2, y + h/2 - 75/2, 247, 75

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/main_tab_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/main_tab_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		color = {200, 70, 70, 255},

	})

	GUIDefine('button', {

		[2] = 'center',
		[4] = 199, [5] = 47,

		bg = 'assets/images/button_empty.png',
		activeBg = 'assets/images/button.png',

		font = getFont('montserrat_medium', 22, 'light'),
		scale = 0.5,

		onPreRender = function(element)

			local alpha = getElementDrawAlpha(element)

			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 231/2, y + h/2 - 80/2, 231, 80

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/main_tab_empty_shadow.png',
				0, 0, 0, tocolor(200, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/main_tab_shadow.png',
				0, 0, 0, tocolor(200, 70, 70, 255*alpha*element.animData)
			)

		end,

		color = {200, 70, 70, 255},

	})

----------------------------------------------------------------------

loadGuiModule()


end)

