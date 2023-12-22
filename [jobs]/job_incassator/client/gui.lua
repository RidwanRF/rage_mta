


openHandler = function()
end

closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {
	
		{'image',

			'center', 'center',
			820, 568,
			color = {25,24,38,255},
			'assets/images/bg.png',

			onInit = function(element)

				element.p_anim = {}
				setAnimData( element.p_anim, 0.1, 0 )

				setTimer(function()

					setAnimData( element.p_anim, 0.1, 0 )
					animate( element.p_anim, 1 )

				end, 2500, 0)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/bg1.png',
					0, 0, 0, tocolor(255, 255, 255, 255*alpha)
				)

				local iw,ih = 56,56
				local ix,iy = x + 57, y + 40

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/icon_bg.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				local texture = getDrawingTexture(element[6])
				local gradient = getTextureGradient(texture, {
					texture = texture,
					alpha = alpha,
					angle = -30+180-90,
					color = {
						{ 0, 0, 0, 0 },
						{ 180, 70, 70, 20 },
					},
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawImage(
					ix,iy,iw,ih, 'assets/images/icon.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)


				dxDrawText('Работа инкассатора',
					ix + iw + 10, iy,
					ix + iw + 10, iy + ih,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
					'left', 'center'
				)

				dxDrawImage(
					x + 61, y + 95,
					17, 434, 'assets/images/vline.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				dxDrawText('Процесс работы',
					x + 105, y + 130,
					x + 105, y + 130,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'top'
				)

				local text = {
					'Отправляйся на метки и собирай деньги',
					'После инкассации всех меток направляйся в офис',
					'Доставь деньги в офис и получи вознаграждение',
					'За работу ты получишь деньги и опыт прокачки',
				}

				local startY = y + 165
				local startX = x + 105

				for _, row in pairs( text ) do

					dxDrawText('• '..row,
						startX, startY,
						startX, startY,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
						'left', 'top'
					)

					startY = startY + 21

				end

				dxDrawText('Список уровней',
					x + 105, y + 270,
					x + 105, y + 270,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'top'
				)

				local level, nextLevel, xpProgress, data = getPlayerLevel( localPlayer )
				local xp = localPlayer:getData('incassator.xp') or 0

				dxDrawText('От уровня зависит ваш доход',
					x + 105, y + 296,
					x + 105, y + 296,
					tocolor(120,120,120,255*alpha),
					0.5, 0.5, getFont('montserrat_medium_italic', 24, 'light'),
					'left', 'top'
				)


				local startX = x + 105
				local startY = y + 335

				local padding = 30

				local ew,eh = 33, 33
				local count = 10

				local totalW = ew * count + padding * ( count-1 )

				dxDrawText(('Текущий бонус #cd4949+%s%% к зарплате'):format( data.add ),
					startX + totalW, y + 296,
					startX + totalW, y + 296,
					tocolor(120,120,120,255*alpha),
					0.5, 0.5, getFont('montserrat_medium_italic', 24, 'light'),
					'right', 'top', false, false, false, true
				)

				mta_dxDrawRectangle(
					px(startX), px(startY + eh/2),
					px( totalW ), 1, tocolor( 45,45,45,255*alpha )
				)

				mta_dxDrawRectangle(
					px(startX), px(startY + eh/2),
					px( totalW * ( level / count ) - ew/2 ), 1, tocolor( 180,70,70,255*alpha )
				)

				for i = 1, count do

					local l_data = Config.levels[i]

					if level >= i then

						local fw1, fh1 = 62,62
						local fx1, fy1 = startX+ew/2-fw1/2, startY + eh/2 - fh1/2


						dxDrawImage(
							fx1, fy1,
							fw1, fh1, 'assets/images/round_a.png',
							0, 0, 0, tocolor( 180,70,70,255*alpha )
						)

						if level == i then

							local fw2, fh2 = 72,72
							local fx2, fy2 = startX+ew/2-fw2/2, startY + eh/2 - fh2/2

							dxDrawImage(
								fx2, fy2,
								fw2, fh2, 'assets/images/round_a2.png',
								0, 0, 0, tocolor( 180,70,70,255*alpha )
							)

							local p_animData = getAnimData( element.p_anim )

							dxDrawImage(
								fx2 - 10*p_animData, fy2 - 10*p_animData,
								fw2 + 20*p_animData, fh2 + 20*p_animData, 'assets/images/round_a2.png',
								0, 0, 0, tocolor( 180,70,70,255*alpha*(1-p_animData) )
							)

						end


					else

						dxDrawImage(
							startX, startY,
							ew, eh, 'assets/images/round2.png',
							0, 0, 0, tocolor( 25,24,38,255*alpha )
						)

						dxDrawImage(
							startX, startY,
							ew, eh, 'assets/images/round.png',
							0, 0, 0, tocolor( 180,70,70,255*alpha )
						)

					end


					dxDrawText(i,
						startX, startY,
						startX + ew, startY + eh,
						tocolor( 255,255,255,255*alpha ),
						0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
						'center', 'center'
					)

					local r,g,b = 120,120,120

					if level == i then
						r,g,b = 180,70,70
					end

					dxDrawText(('+%s%%'):format( l_data.add ),
						startX, startY + eh + 10,
						startX + ew, startY + eh + 10,
						tocolor( r,g,b,255*alpha ),
						0.5, 0.5, getFont(level == i and 'montserrat_semibold' or 'montserrat_medium', 25, 'light'),
						'center', 'top'
					)

					startX = startX + ew + padding

				end

				dxDrawText('Информация',
					x + 105, y + 425,
					x + 105, y + 425,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'top'
				)

				local stats = exports.jobs_main:getPlayerStats( localPlayer )

				local to_next = (xpProgress[2] - xp)
				if to_next <= 0 then to_next = 0 end

				local rows = {
					{ name = 'Текущий уровень', value = level .. ' ур.', },
					{ name = 'Осталось до след. уровня', value = to_next .. ' EXP', },
					{ name = 'Заработано за все время', value = string.format('$%s', splitWithPoints( stats.raised_money or 0, '.' )) },
				}

				local startY = y + 455

				for _, row in pairs( rows ) do

					dxDrawText(row.name,
						x + 105, startY,
						x + 105, startY,
						tocolor(175,175,175,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
						'left', 'top'
					)

					dxDrawText(row.value,
						x + 405, startY,
						x + 405, startY,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
						'center', 'top'
					)

					startY = startY + 20

				end

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture('assets/images/bg_shadow.png')
				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2+5

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
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

				{'button',

					function(s,p) return p[4] - s[4] - 110 end,
					function(s,p) return p[5] - s[5] - 60 end,
					215, 46,

					bg = 'assets/images/btn_empty.png',
					activeBg = 'assets/images/btn.png',

					color = { 200,80,80,255 },
					'Начать смену',

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/btn_shadow.png'] = element.animData,
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

						triggerServerEvent('incassator.work.start', resourceRoot, currentJobMarker:getData('incassator.id'))
						closeWindow()

					end,

				},

			},

		},

	},

}


loadGuiModule()

end)
