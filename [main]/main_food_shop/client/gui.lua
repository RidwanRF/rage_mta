
--------------------------------------------------------------------
	
addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {
	
	main = {

		{'image',

			'center', 'center',
			821, 511,
			'assets/images/bg.png',
			color = {32,35,66,255},

			id = 'window',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 839/2,
					y + h/2 - 529/2 + 5,
					839, 529, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)


				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Закусочная',
					x,y+35,x+w,y+35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 31, 'light'),
					'center', 'top'
				)

			end,

			onInit = function(element)

				element.inventory_config = exports.main_inventory:getConfigSetting('items')

				local ex,ey,ew,eh = element:abs()

				local index = 1

				local w,h = 141, 162
				local padding = 40

				local sCount_x = 2
				local sCount_y = 1

				local _startX = ew/2 - sCount_x*w - padding*(sCount_x-0.5)
				local startX = _startX
				local startY = eh/2 - sCount_y*h - padding*(sCount_y-0.5) + 10

				for i_1 = 1, 2 do
					for i_2 = 1,4 do

						element:addElement(
							{'image',

								startX, startY,
								w,h,
								'assets/images/item_bg.png',
								color = {37,42,74,255},

								index = index,
								item = Config.items[index],

								onRender = function(element)

									local x,y,w,h = element:abs()
									local alpha = element:alpha()

									local config = element.parent.inventory_config[element.item.item]

									dxDrawText(string.format('#cd4949+#ffffff %s #cd4949HP',
										config.heal or 0
									),
										x,y+10,x+w,y+10,
										tocolor(255,255,255,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
										'center', 'top', false, false, false, true
									)

									local iw,ih = 120, 120

									dxDrawImage(
										x+w/2-iw/2,y+h/2-ih/2+10,
										iw,ih, ':main_inventory/' .. config.icon,
										0, 0, 0, tocolor(255,255,255,255*alpha)
									)

								end,

								elements = {

									{'button',

										'center', h-36/2,
										110, 36,

										bg = 'assets/images/button.png',
										string.format('%s$', Config.items[index].cost),

										scale = 0.5,
										font = getFont('montserrat_semibold', 20, 'light'),

										color = {180, 70, 70, 255},
										activeColor = {200, 70, 70, 255},


										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local shx,shy,shw,shh = x + w/2 - 128/2, y + h/2 - 53/2, 128, 53
											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/button_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
											)

										end,

										onInit = function(element)
											element.f_animId = {}
											setAnimData(element.f_animId, 0.1, 1)
											element.animationAlpha = element.f_animId
										end,

										onClick = function(element)

											local x,y,w,h = element:abs()

											animate(element.f_animId, 0)
											local size = 30

											displayLoading( {x+w/2-size/2, y+h/2-size/2, size, size}, {180,70,70,255}, 500, function()

												animate(element.f_animId, 1)
												triggerServerEvent('food_shop.buyItem', resourceRoot, element.parent.index)

											end )

										end,


									},

								},


							}
						)

						if index == 4 then
							startX = _startX
							startY = startY + h+padding
						else
							startX = startX + w + padding
						end

						index = index + 1

					end
				end

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

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 35

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


			},

		},

	},

}

loadGuiModule()

end)

