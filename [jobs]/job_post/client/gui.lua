
openHandlers = {
}

closeHandlers = {
}

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			548, 356, 
			'assets/images/bg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 588/2,
					y + h/2 - 396/2 + 5,
					588, 396, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

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
					0, 0, 0, tocolor(255,255,255,80*alpha)
				)

				dxDrawImage(
					x + 35, y + 25, 38, 38, gradient
				)

				dxDrawImage(
					x + 35, y + 25, 38, 38, 'assets/images/post.png',
					0, 0, 0, tocolor(40, 40, 40, 255*alpha)
				)

				dxDrawText('Почтовый офис',
					x + 35 + 38 + 15, y + 25,
					x + 35 + 38 + 15, y + 25 + 38,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'left', 'center'
				)

				local text

				if exports.jobs_main:getPlayerSessionData(localPlayer, 'renew') then
					text = 'Ты развез всю почту, теперь можно\nзавершить работу или взять новые заказы'
				else
					text = 'Развози почту на мопеде по указанным точкам,\nпотом возвращайся обратно и получишь деньги'
				end

				dxDrawText(text,
					x, y + 100,
					x+w, y + 100,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
					'center', 'top'
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

					onClick = closeWindow,

				},

				{'element',
					'center', 170,
					380, 39 ,
					color = {255,255,255,255},

					onInit = function(element)
						element.animationAlpha = 'buttons'
						setAnimData(element.animationAlpha, 0.1, 1)
					end,

					elements = {

						{'button',

							'left', 'center',
							[6]='Начать работу',

							onRender = function(element)

								if exports.jobs_main:getPlayerSessionData(localPlayer, 'renew') then
									element[2] = 0
								else
									element[2] = element.parent[4]/2 - element[4]/2
								end

								if exports.jobs_main:getPlayerWork(localPlayer) == Config.resourceName then
									element[6] = 'Завершить работу'
								else
									element[6] = 'Начать работу'
								end

							end,

							onClick = function(element)

								local x,y,w,h = element.parent:abs()

								animate(element.parent.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

									animate(element.parent.animationAlpha, 1)

									if exports.jobs_main:getPlayerWork(localPlayer) == Config.resourceName then

										triggerServerEvent('post.finish', resourceRoot)

									else

										triggerServerEvent('post.start', resourceRoot,
											currentStationId
										)

									end

									closeWindow()

								end )

							end,

						},

						{'button',

							'right', 'center',
							[6]='Взять почту',

							id = 'take-post',

							onInit = function(element)

								openHandlers.take_post = function()

									gui_get('take-post').noDraw = not exports.jobs_main:getPlayerSessionData(localPlayer, 'renew')

								end

								element:addHandler('onRender', function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									dxDrawImage(
										x+w-50,y+h-50/2-5, 50, 50, 'assets/images/box.png',
										0, 0, 0, tocolor(255,255,255,255*alpha*element.animData)
									)

								end)

							end,

							onClick = function(element)

								local x,y,w,h = element.parent:abs()

								animate(element.parent.animationAlpha, 0)
								displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 800, function()

									animate(element.parent.animationAlpha, 1)

									triggerServerEvent('post.renew', resourceRoot)

									closeWindow()

								end )

							end,

						},

					},

				},

				{'element',

					'center', 'bottom',
					300, 120,
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
							{ name = 'Заработано за сессию', value = string.format('$%s', splitWithPoints(
								localPlayer:getData('job.session_stats.job_post.raised_money') or 0, '.' )) },
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

}

-----------------------------------------------------------------

	GUIDefine('button', {

		[4] = 183, [5] = 39,

		bg = 'assets/images/btn_empty.png',
		activeBg = 'assets/images/btn.png',

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_medium', 20, 'light'),

		onPreRender = function(element)

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

	})

-----------------------------------------------------------------

loadGuiModule()

end)
