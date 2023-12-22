
windowAnimSpeed = 0.05

openHandler = function()

	showCursor(false)

	local x,y,w,h = withdrawScreenElement:abs()
	w,h = w*2,h*2

	local vx,vy,vz = getElementPosition( localPlayer.vehicle )

	local wx,wy,wz = getVehicleComponentPosition( localPlayer.vehicle, 'wheel_lb_dummy' )
	local ex,ey,ez = getVehicleComponentPosition( localPlayer.vehicle, 'exhaust' )

	local wsx, wsy = getScreenFromWorldPosition( vx,vy+wy+1,vz+wz )

	withdrawElement.data.c_speed = math.floor( getElementSpeed( localPlayer.vehicle, 'kmh' ) )

	withdrawScreenElement.renderTarget = isElement(withdrawScreenElement.renderTarget)
		and withdrawScreenElement.renderTarget or dxCreateRenderTarget( w,h,true )

	dxSetRenderTarget( withdrawScreenElement.renderTarget )

		local screen_source = getScreenSource()
		local mw,mh = dxGetMaterialSize(screen_source)

		local wscale = w/mw
		local nw,nh = mw*wscale,mh*wscale

		dxDrawImage(
			w/2-nw/2, 0, nw,nh, getGrayTexture( screen_source, { alpha = 1 } )
			-- -wsx+w/2, -wsy+h/2, mw,mh, screen_source,
			-- 0, 0, 0, tocolor(200, 200, 200, 255)
		)

	dxSetRenderTarget()

end

closeHandler = function()
end

hideBackground = true
blurBackground = false

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			sx - 317 - 20, 'center',
			317, 284,
			color = {25,24,38,255},
			'assets/images/bg.png',

			variable = 'withdrawElement',

			onInit = function(element)
				element.y0 = element[3]

				element.i_anim = {}
				setAnimData(element.i_anim, 0.03)

				setTimer(function()

					if windowOpened then
						setAnimData(element.i_anim, 0.03)
						animate(element.i_anim, 1)
					end

				end, 1500, 0)

			end,

			data = {},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				element[2] = sx - (element[4]+20)*(alpha)
				element[3] = element.y0 + 30*alpha

				local shw, shh = 345, 312

				dxDrawImage(
					x+w/2-shw/2, y+h/2-shh/2+5,
					shw,shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local gradient = getTextureGradient(getDrawingTexture(element[6]), {

					color = {
						{0, 0, 0, 0},
						{180, 70, 70, 50},
					},

					angle = -120,
					alpha = alpha,

				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawText('Оплатить можно в отделении\nполиции или в банке',
					x,y+h-15,x+w,y+h-15,
					tocolor(80, 77, 99, 255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
					'center', 'bottom'
				)

				dxDrawText(string.format('$%s',
					splitWithPoints( element.data.withdraw or 0, '.' )
				),
					x,y+h-60,x+w,y+h-60,
					tocolor(180, 70, 70, 255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 40, 'light'),
					'center', 'bottom'
				)

				if element.data.type == 'speed_break' then

					local rows = {
						{ name = 'Превышение скорости', value = string.format('%s км/ч', element.data.c_speed or 0) },
						{ name = 'Допустимая скорость', value = string.format('%s км/ч', element.data.max_speed or 0) },
					}

					local startY = y+163

					for _, row in pairs( rows ) do

						dxDrawText(row.name,
							x+25, startY,
							x+25, startY,
							tocolor(80, 77, 99, 255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
							'left', 'center'
						)

						dxDrawText(row.value,
							x+w-25, startY,
							x+w-25, startY,
							tocolor(255,255,255, 255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
							'right', 'center'
						)

						startY = startY + 17

					end

				else

					dxDrawText('Езда без номера',
						x, y + h - 95, x+w, y+h-95,
						tocolor(80, 77, 99,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
						'center', 'bottom'
					)

				end

				local rw,rh = 68,68
				local rx,ry = x-rw/2+10, y+h-rh/2-10

				local anim = getAnimData(element.i_anim)

				for i = 1,2 do

					local step = 20*i*anim

					dxDrawImage(
						rx-step,ry-step,rw+step*2,rh+step*2, 'assets/images/round_e.png',
						0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-anim))					
					)
				end


				dxDrawImage(
					rx,ry,rw,rh, 'assets/images/round.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				dxDrawText('!',
					rx,ry,rx+rw,ry+rh,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
					'center', 'center'
				)


			end,

			elements = {

				{'element',

					variable = 'withdrawScreenElement',

					'center', 15,
					285, 130,
					color = {255,255,255,255},
					bg = 'assets/images/screen_bg.png',

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local d_texture = getDrawingTexture(element.bg)
						local texture = cutTextureByMask(element.renderTarget, {
							mask = d_texture,
							alpha = alpha
						})

						dxDrawImage(
							x,y,w,h, texture
						)

						dxDrawImage(
							x+w/2-315/2, y+h/2-160/2,
							315, 160, 'assets/images/screen_bg1.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

					end,

				},

			},

		},

	},

}


----------------------------------------------------------------------

loadGuiModule()


end)

