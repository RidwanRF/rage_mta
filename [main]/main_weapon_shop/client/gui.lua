
openHandler = function()
	showChat( false )
end

closeHandler = function()
	showChat( true )
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			80, ( real_sy*0.1 - px(88) + px(10) ) * sx/real_sx,
			148,88,
			color = {180,180,180,255},
			'assets/images/back.png',

			onRender = function(element)

				local r,g,b = interpolateBetween(180,180,180,255,255,255, element.animData, 'InOutQuad')
				element.color = {r,g,b, element.color[4]}

			end,

			onClick = function()
				closeWindow()
			end,

		},

		{'element',
			80, ( real_sy*0.1 ) * sx/real_sx, 332*2+10, ( real_sy*0.85 ) * sx/real_sx,
			color = {255,255,255,255},

			onRender = function(element)
				element.inventoryConfig = element.inventoryConfig or exports.main_inventory:getConfigSetting('items')
			end,

			anim_fix = true,

			variable = 'weaponShop',

			overflow = 'vertical',
			scrollXOffset = 30,
			scrollBgColor = {25,24,38,255},

			onInit = function(element)

				local padding = 10
				local h = 166

				local w1,w2 = 332, 161

				local sCount = #Config.shop_items/2
				local startY = 10

				for section, row in pairs( Config.shop_items ) do

					element:addElement(
						{'element',

							'center', startY,
							'100%', h,
							color = {255,255,255,255},

							row = row,
							section = section,

							onInit = function(element)

								local startX = 0

								for index, r_element in pairs( element.row ) do

									local width = r_element.type == 'item1' and w1 or w2

									element:addElement(
										{'image',
											startX, 'center',
											width, h,
											color = {25,24,38,255},
											('assets/images/%s.png'):format(r_element.type),

											data = r_element,
											lc = { section = element.section, index = index },

											-- onInit = function(element)
											-- 	element.y0 = element[3]
											-- end,

											-- onPreRender = function(element)

												-- element[3] = element.y0 - 5*element.animData

												-- local alpha = element:alpha()
												-- local x,y,w,h = element:abs()

												-- local shw,shh = w+24,h+24

												-- dxDrawImage(
												-- 	x+w/2-shw/2, y+h/2-shh/2+5,
												-- 	shw,shh, ('assets/images/%s_shadow.png'):format( element.data.type ),
												-- 	0, 0, 0, tocolor(0,0,0,255*alpha)
												-- )

											-- end,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												local item_config = weaponShop.inventoryConfig[ element.data.item ]

												if element.data.type == 'item1' then

													local ammo_config = weaponShop.inventoryConfig[ item_config.ammo_access ]

													local iw,ih = 200,200
													local ix,iy = x+w/2-iw/2, y+h/2-ih/2

													dxDrawImage(
														ix,iy,iw,ih, ':main_inventory/' .. item_config.icon,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

													dxDrawText(item_config.name,
														x + 30, y + 20 + 43/2,
														x + 30, y + 20 + 43/2,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'left', 'center'
													)

													local mw,mh = 20,20
													local mx,my = x+w-43/2-mw/2, y+h-20-43/2-mh/2
													-- local mx,my = x+w-20-43/2-mw/2, y+h-20-43/2-mh/2

													-- dxDrawImage(
													-- 	mx,my,mw,mh, 'assets/images/money.png',
													-- 	0, 0, 0, tocolor(255,255,255,255*alpha)
													-- )

													dxDrawText('$' .. splitWithPoints( element.data.cost, '.' ),
														mx - 3, my,
														mx - 3, my+mh,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'right', 'center'
													)

													if ammo_config then

														dxDrawText('Калибр ' .. ammo_config.name,
															x + 30, y + h - 20 - 43/2,
															x + 30, y + h - 20 - 43/2,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
															'left', 'center'
														)

													end


												elseif element.data.type == 'item2' then

													local iw,ih = 70,70
													local ix,iy = x+w/2-iw/2, y+h/2-ih/2

													dxDrawImage(
														ix,iy,iw,ih, ':main_inventory/' .. item_config.icon,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

													dxDrawText(item_config.name,
														x + 30, y + 20 + 43/2,
														x + 30, y + 20 + 43/2,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'left', 'center'
													)

													drawSmartText(string.format('$%s',
													-- drawSmartText(string.format('%s <img>assets/images/money.png</img>',
														splitWithPoints( element.data.cost, '.' )
													),
														x, x+w, y+h - 40, 
														tocolor(255,255,255,255*alpha),
														tocolor(255,255,255,255*alpha),
														0.5, getFont('montserrat_semibold', 26, 'light'),
														'center', 20, 0, 0
													)

													if (element.data.amount or 0) > 0 then

														dxDrawText(('за %s шт.'):format( element.data.amount ),
															x, y + h - 13, x + w, y + h - 13,
															tocolor(70,70,90,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
															'center', 'bottom'
														)

													end


												end

												-- local rw,rh = 43,43
												-- local rx,ry = x+w-20-rw,y+20

												-- dxDrawImage(
												-- 	rx,ry,rw,rh, 'assets/images/mark.png',
												-- 	0, 0, 0, tocolor(150,150,150,255*alpha*(1-element.animData))
												-- )

												-- dxDrawImage(
												-- 	rx,ry,rw,rh, 'assets/images/mark_a.png',
												-- 	0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
												-- )


											end,

											onClick = function(element)

												triggerServerEvent('weapon_shop.buyItem', resourceRoot,
													element.data.item, element.data.amount or 1, element.lc
												)

											end,

										}
									)

									startX = startX + width + padding

								end


							end,

						}
					)

					startY = startY + h + padding

				end

			end,

		},



	},

}

----------------------------------------------------------------------

loadGuiModule()


end)

