
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
end

closeHandler = function()

	animate(window.anim, 0)
	animate(window.x_anim, window.x0)

	setTimer(function()
		setCameraTarget(localPlayer, localPlayer)
	end, 1000, 1)

end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			449, 615,
			color = {25,24,38,255},
			'assets/images/bg.png',

			onInit = function(element)

				element.x_anim = {}
				element.anim = {}

				element.x0 = element[2]

				setAnimData(element.anim, 0.01, 0)
				setAnimData(element.x_anim, 0.1, element.x0)

			end,

			addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

				if dn == 'auction.data' and source == currentAuctionMarker then

					if new and new.winner == localPlayer then

						openWindow('main')

						animate(window.x_anim, (sx-window[4]-40))
						animate(window.anim, 1)

						window.camera_matrix = table.copy( Config.matrix )

						local x,y = getPointFromDistanceRotation(
							window.camera_matrix[1],
							window.camera_matrix[2],
							10, 45
						)

						window.camera_matrix[1] = x
						window.camera_matrix[2] = y
						window.camera_matrix[3] = window.camera_matrix[3] + 3

						currentAuctionData = new

					end


				end

			end),

			onRender = function(element)

				local x_anim, target = getAnimData(element.x_anim)
				local anim, target = getAnimData(element.anim)

				element[2] = x_anim

				blurBackground = target == 0

				if element.camera_matrix then

					local x,y,z, tx,ty,tz, roll, fov = massInterpolate(
						element.camera_matrix, Config.matrix, anim, 'InOutQuad'
					)

					setCameraMatrix(x,y,z, tx,ty,tz, roll, fov)
				end

			end,

			variable = 'window',

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

						if currentAuctionData.winner == localPlayer then
							triggerServerEvent('auction.leave', resourceRoot, currentAuctionMarker)
						else
							exports.hud_notify:notify('Не убегайте далеко', 'Чтобы не покинуть аукцион')
						end

 						closeWindow()

					end,

				},

				{'image',

					30, 30,
					56,56,
					color = {180,70,70,255},
					'assets/images/title_bg.png',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/title_icon.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

						dxDrawText('Аукцион',
							x + w + 10, y,
							x + w + 10, y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
							'left', 'center'
						)

					end,

				},

				{'image',

					'center', 100,
					374, 168,
					color = {21,21,33,255},
					'assets/images/ctr_bg.png',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local iw,ih = 100,100

						local bw,bh = 184, 32
						local bx,by = x + 150, y + 100

						local bsw, bsh = 224, 74

						dxDrawImage(
							bx,by,bw,bh, 'assets/images/timer_bg.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						dxDrawImage(
							bx+bw/2-bsw/2,by+bh/2-bsh/2,bsw,bsh,
							'assets/images/timer_bg_shadow.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						local tw,th = 20,20

						dxDrawImage(
							bx + 10, by + bh/2 - th/2,
							tw,th, 'assets/images/timer.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						local text, image, content

						if currentAuctionData.winner then

							text = 'Аукцион завершен'
							image = currentAuctionData.item.icon
							content = currentAuctionData.item.name

						else

							local serverTime = getServerTimestamp().timestamp
							local time = math.floor( currentAuctionData.time - (serverTime - currentAuctionData.start_time) )
							time = math.max( time, 0 )

							local min = math.floor( time/60 )
							local sec = time - min*60

							text = ('Осталось %02dм %02dс'):format( min, sec )
							image = 'assets/images/unknown_ctr.png'
							content = 'Неизвестно'

						end

						dxDrawText(text,
							bx + 10 + tw + 14 + 61, by-2,
							bx + 10 + tw + 14 + 61, by+bh,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
							'center', 'center'
						)

						local texture = getDrawingTexture( image )
						local mw,mh = dxGetMaterialSize(texture)

						if mw > mh then
							ih = mh*100/mw
						elseif mw > mh then
							iw = mw*100/mh
						end

						dxDrawImage(
							x + 30, y+h/2-ih/2,
							iw,ih, texture,
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText('Контейнер',
							x + 150, y + 30,
							x + 150, y + 30,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
							'left', 'top'
						)

						dxDrawText('Содержимое: #ffffff '..content,
							x + 150, y + 60,
							x + 150, y + 60,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
							'left', 'top', false, false, false, true
						)

					end,

				},

				{'image',

					'center', 278,
					374, 98,
					color = {21,21,33,255},
					'assets/images/bet_bg.png',

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local lw,lh = 335, 39

						dxDrawText('Лидер ставки',
							x,y+15,x+w,y+15,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
							'center', 'top'
						)

						local lx,ly = x+w/2-lw/2, y+h-lh-15

						dxDrawImage(
							lx,ly,
							lw,lh, 'assets/images/bet_leader.png',
							0, 0, 0, tocolor(25,24,38,255*alpha)
						)

						if isElement(currentAuctionData.bet_player) then

							dxDrawText(currentAuctionData.bet_player.name,
								lx+25, ly,
								lx+25, ly+lh,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'left', 'center'
							)

							dxDrawText('$' .. splitWithPoints( currentAuctionData.bet, '.' ),
								lx+lw-25, ly,
								lx+lw-25, ly+lh,
								tocolor(180,70,70,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'right', 'center'
							)

						else

							dxDrawText('Не определен',
								lx,ly,lx+lw,ly+lh,
								tocolor(76,73,94,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'center', 'center'
							)

						end

					end,

				},

				{'image',

					'center', 278+98+10,
					374, 201,
					color = {21,21,33,255},
					'assets/images/make_bert_bg.png',

					noDraw = function(element)

						if currentAuctionData.winner == localPlayer then
							return true
						elseif currentAuctionData.finished and currentAuctionData.winner ~= localPlayer then
							closeWindow()
							return false
						else
							return false
						end

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Сделайте свою ставку',
							x + 30, y + 20,
							x + 30, y + 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
							'left', 'top'
						)

						dxDrawText('Стартовая цена: #ffffff $' .. splitWithPoints( currentAuctionData.item.min_bet, '.' ),
							x + 30, y + 55,
							x + 30, y + 55,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

						dxDrawText(string.format('Текущая ставка: #ffffff $' .. splitWithPoints( currentAuctionData.bet, '.' )),
							x + 30, y + 72,
							x + 30, y + 72,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

						dxDrawText(('Можно поставить от #cd4949 $%s до $%s'):format(
							splitWithPoints( currentAuctionData.bet + currentAuctionData.item.min_bet_delta, '.' ),
							splitWithPoints( currentAuctionData.bet + currentAuctionData.item.max_bet_delta, '.' )
						),

							x + 30, y + 95,
							x + 30, y + 95,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

					end,

					elements = {

						{'element',

							'center', function(s,p) return p[5] - s[5] - 20 end,
							320, 41,
							color = {255,255,255,255},

							onInit = function(element)

								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)

							end,

							elements = {

								{'input',
									'left', 'center',
									155, 41,
									'',

									bg = 'assets/images/button.png',

									color = {25,24,38,255},
									placeholderColor = {76,73,94,255},

									placeholder = 'Сумма',
									alignX = 'center',

									type = 'number',

									font = getFont('montserrat_semibold', 22, 'light'),
									scale = 0.5,

									variable = 'betInput',


								},

								{'button',
									'right', 'center',
									155, 41,
									'Сделать ставку',

									onClick = function(element)

										local x,y,w,h = element.parent:abs()
										local lw,lh = 40,40

										local sum = tonumber(betInput[6]) or 0

										if sum <= 0 then
											return exports.hud_notify:notify('Ошибка', 'Введите сумму')
										end

										animate(element.parent.animationAlpha, 0)

										displayLoading({x+w/2-lw/2, y+h/2-lh/2, lw,lh}, {180,70,70,255}, 1000, function()

											triggerServerEvent('auction.setBet', resourceRoot, currentAuctionMarker, sum)

											betInput[6] = ''
											animate(element.parent.animationAlpha, 1)

										end)

									end,

								},

							},


						},

					},

				},

				{'image',

					'center', 278+98+10,
					374, 201,
					color = {21,21,33,255},
					'assets/images/make_bert_bg.png',

					noDraw = function(element)

						if currentAuctionData.winner == localPlayer then
							return false
						elseif currentAuctionData.finished and currentAuctionData.winner ~= localPlayer then
							closeWindow()
							return false
						else
							return true
						end

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Вы победили в аукционе!',
							x + 30, y + 20,
							x + 30, y + 20,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
							'left', 'top'
						)

						dxDrawText('Ваша ставка: #ffffff $' .. splitWithPoints( currentAuctionData.bet, '.' ),
							x + 30, y + 55,
							x + 30, y + 55,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

						dxDrawText('Приз: #ffffff ' .. currentAuctionData.item.name,
							x + 30, y + 72,
							x + 30, y + 72,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

						dxDrawText('Заберите приз или продайте за #cd4949 $' .. splitWithPoints(currentAuctionData.item.sell_cost, '.'),
							x + 30, y + 95,
							x + 30, y + 95,
							tocolor(76,73,94,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
							'left', 'top', false, false, false, true
						)

					end,

					elements = {

						{'element',

							'center', function(s,p) return p[5] - s[5] - 20 end,
							320, 41,
							color = {255,255,255,255},


							onInit = function(element)

								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)

							end,

							elements = {

								{'button',
									'left', 'center',
									155, 41,
									'Продать',
									color = {140,50,50,255},

									onClick = function(element)

										local x,y,w,h = element.parent:abs()
										local lw,lh = 40,40

										animate(element.parent.animationAlpha, 0)

										displayLoading({x+w/2-lw/2, y+h/2-lh/2, lw,lh}, {180,70,70,255}, 1000, function()

											triggerServerEvent('auction.sellPrize', resourceRoot, currentAuctionMarker)
											closeWindow()

											animate(element.parent.animationAlpha, 1)

										end)

									end,

								},

								{'button',
									'right', 'center',
									155, 41,
									'Забрать',

									onClick = function(element)

										local x,y,w,h = element.parent:abs()
										local lw,lh = 40,40

										animate(element.parent.animationAlpha, 0)

										displayLoading({x+w/2-lw/2, y+h/2-lh/2, lw,lh}, {180,70,70,255}, 1000, function()

											triggerServerEvent('auction.takePrize', resourceRoot, currentAuctionMarker)
											closeWindow()

											animate(element.parent.animationAlpha, 1)

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

}

------------------------------------------------------------------------

	GUIDefine('button', {

		font = getFont('montserrat_semibold', 22, 'light'),
		scale = 0.5,

		bg = 'assets/images/button.png',

		color = {180,70,70,255},

		onPreRender = function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			local shx,shy,shw,shh = x + w/2 - 193/2, y + h/2 - 83/2, 193,83
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/button_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

	})

------------------------------------------------------------------------

loadGuiModule()


end)

