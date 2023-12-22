

openHandler = function()
	showCursor(false)
end
closeHandler = function()
end

hideBackground = true
blurBackground = false

local scale = 0.7

addEventHandler('onClientResourceStart', resourceRoot, function()



windowModel = {

	main = {

		{'element',
			0, 0, 0, 0,
			color = {255,255,255,255},

			onRender = function(element)

				if localPlayer:getData('speed.hidden') then
					return closeWindow()
				end

				if not localPlayer.vehicle then
					return closeWindow()
				end

				if isCursorShowing() then

					if isTimer(cursor_timer) then
						killTimer(cursor_timer)
					end

					cursor_timer = setTimer(function()

						if not isCursorShowing() then

							if isTimer(cursor_timer) then
								killTimer(cursor_timer)
							end

							if localPlayer.vehicle then
								openWindow('main')
							end

						end

					end, 100, 0)

					return closeWindow()

				end

				lastPlayerVehicle = isElement(lastPlayerVehicle) and lastPlayerVehicle or localPlayer.vehicle
				if localPlayer.vehicle and lastPlayerVehicle ~= localPlayer.vehicle then
					lastPlayerVehicle = localPlayer.vehicle
				end

			end,

		},

		{'image',

			sx - 301 - 60, ( real_sy - px(261) - px(50) )*sx/real_sx,
			301, 261,

			'assets/images/speed.png',
			color = {210,233,243,255},

			turn_anim = function(element)

				setAnimData('turn', 0.1, 0)
				setAnimData('turn-alpha', 0.1, 1)

				animate('turn', 1, function()
					animate('turn-alpha', 0, function()
						setTimer(function()
							element:turn_anim()
						end, 500, 1)
					end)
				end)

			end,

			onInit = function(element)
				element:turn_anim()
			end,

			onRender = {

				function(element)

					if not isElement(lastPlayerVehicle) then return end

					local alpha = getElementDrawAlpha(element)
					local x,y,w,h = element:abs()

					local lx,ly,lw,lh = x+w/2 + 4, y+h/2 + 60, 47,27
					local turnAlpha = getAnimData('turn-alpha')

					dxDrawImage(
						lx,ly,lw,lh, 'assets/images/arrow_right.png',
						0, 0, 0, tocolor(90,90,90,255*alpha)
					)

					local rx,ry,rw,rh = x+w/2 - 47 - 4, y+h/2 + 60, 47,27

					dxDrawImage(
						rx,ry,rw,rh, 'assets/images/arrow_left.png',
						0, 0, 0, tocolor(90,90,90,255*alpha)
					)

					if lastPlayerVehicle:getData('turn_right') then
						drawImageSection(
							lx,ly,lw,lh, 'assets/images/arrow_right.png',
							{ x = getAnimData('turn'), y = 1 }, tocolor(210,233,243,255*alpha*turnAlpha)
						)
					end

					if lastPlayerVehicle:getData('turn_left') then
						drawImageSection(
							rx,ry,rw,rh, 'assets/images/arrow_left.png',
							{ x = getAnimData('turn'), y = 1 }, tocolor(210,233,243,255*alpha*turnAlpha), 1
						)
					end

					local cx,cy,cw,ch = x+w/2-40/2, y+h/2-40/2+15+10, 40, 40

					local rx,ry,rw,rh = cx-155+45,cy+ch/2-35/2-2, 155,35

					local speed = math.floor(getElementSpeed(lastPlayerVehicle, 'kmh'))

					local maxSpeed = 550
					local progress = math.clamp(speed/maxSpeed, 0, 1)

					local angle = {-44,360-87}
					local c_angle = angle[1] + ( angle[2] )*progress

					dxDrawImage(
						cx,cy,cw,ch, 'assets/images/speed_center.png',
						0, 0, 0, tocolor(0,0,0,160*alpha)
					)

					dxDrawImage(
						rx,ry,rw,rh, 'assets/images/speed_sarrow.png',
						c_angle, px(53), 0, tocolor(210,233,243,255*alpha)
					)

					local c2x,c2y,c2w,c2h = cx+cw/2-27/2, cy+ch/2-27/2, 27,27

					dxDrawImage(
						c2x,c2y,c2w,c2h, 'assets/images/speed_center2.png',
						0, 0, 0, tocolor(255,255,255,255*alpha)
					)

					local scale, font = 0.5, getFont('montserrat_semibold', 45, 'light')

					local speedStr = '#ecf9ff' .. tostring(speed)
					while #speedStr < 10 do
						speedStr = '0' .. speedStr 
					end

					local offset = -15

					dxDrawText(speedStr,
						x+offset, y+h+5,
						x+w+offset, y+h+5,
						tocolor(161,165,167,255*alpha),
						scale, scale, font,
						'center', 'bottom',
						false, false, false, true
					)

					local textWidth = dxGetTextWidth( speedStr, scale, font, true )

					dxDrawText('km/h',
						x + w/2 + textWidth/2 + 5+offset, y+h,
						x + w/2 + textWidth/2 + 5+offset, y+h,
						tocolor(236,249,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 19, 'light'),
						'left', 'bottom'

					)

					local odometer = math.floor(lastPlayerVehicle:getData('odometer') or 0)

					local odometerStr = '#ecf9ff' .. tostring(odometer)
					while #odometerStr < 13 do
						odometerStr = '0' .. odometerStr 
					end

					dxDrawText(odometerStr,
						x, y+h+5-3,
						x+w, y+h+5-3,
						tocolor(161,165,167,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
						'center', 'top',
						false, false, false, true
					)

					local iw,ih = 12,12
					local ix,iy = x-40, y+h-12

					local percents = math.floor( lastPlayerVehicle.health / 1000 * 100 )

					local r,g,b = 210,233,243
					if percents < 20 then
						r,g,b = 230, 90, 90
					end

					dxDrawImage(
						ix,iy,iw,ih, 'assets/images/veh_health.png',
						0, 0, 0, tocolor( r,g,b,255*alpha )
					)

					dxDrawText(('%s%%'):format( percents ),
						ix + iw + 6, iy,
						ix + iw + 6, iy+ih,
						tocolor( r,g,b,255*alpha ),
						0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
						'left', 'center'
					)


				end,

				icons = function(element)

					if not isElement(lastPlayerVehicle) then return end

					local alpha = getElementDrawAlpha(element)
					local x,y,w,h = element:abs()

					local icons = {

						{ icon = 'lights', state = (lastPlayerVehicle:getData('vehicleLightsState') or 'off') ~= 'off' },
						{ icon = 'lock', state = lastPlayerVehicle:getData('doors.locked') },
						{ icon = 'engine', state = getVehicleEngineState(lastPlayerVehicle) },
						{ icon = 'cruise', state = exports.vehicles_cruise:getCruiseSpeedEnabled() },

					}

					local angle = 210
					local dist = 150
					local cx,cy = x+w/2-15,y+h/2-25
					local size = 80

					for _, icon_data in pairs( icons ) do

						local animData = getAnimData(icon_data.icon)

						if not animData then
							setAnimData(icon_data.icon, 0.1)
							animData = 0
						end

						animate(icon_data.icon, icon_data.state and 1 or 0)

						local ix,iy = getPointFromDistanceRotation( cx,cy, dist, -angle )
						local r,g,b = interpolateBetween(100,100,100, 210,233,243, animData, 'InOutQuad')

						dxDrawImage(
							ix,iy, size, size,
							string.format('assets/images/icon_%s.png', icon_data.icon), 
							0, 0, 0, tocolor(r,g,b,255*alpha)
						)

						angle = angle + 20

					end

				end,

			},

			elements = {

				{'image',
					-105, 'bottom',
					90, 155,
					'assets/images/fuel_line.png',
					color = {210,233,243,255},

					cached_models_fuel = {},

					onRender = function(element)

						if not isElement(lastPlayerVehicle) then return end

						local alpha = getElementDrawAlpha(element)
						local x,y,w,h = element:abs()

						local cx,cy,cw,ch = x+w/2-30/2+41, y+h/2-30/2+11, 30, 30

						local rx,ry,rw,rh = cx-98+35,cy+ch/2-35/2, 98,33

						local _fuel = lastPlayerVehicle:getData('fuel') or 0
						local fuel = math.floor(_fuel)

						if _fuel < 1 and _fuel > 0 then
							fuel = 0
						end

						if not element.cached_models_fuel[lastPlayerVehicle.model] then
							element.cached_models_fuel[lastPlayerVehicle.model] = exports.vehicles_main:getVehicleProperty(lastPlayerVehicle, 'fuel')
						end

						local maxFuel = element.cached_models_fuel[lastPlayerVehicle.model]

						local progress = math.clamp(fuel/maxFuel, 0, 1)

						local angle = {-47,82}
						local c_angle = angle[1] + ( angle[2] - angle[1] )*progress

						dxDrawImage(
							cx,cy,cw,ch, 'assets/images/speed_center.png',
							0, 0, 0, tocolor(0,0,0,160*alpha)
						)

						dxDrawImage(
							rx,ry,rw,rh, 'assets/images/fuel_arrow.png',
							c_angle, px(30), 0, tocolor(210,233,243,255*alpha)
						)

						local c2x,c2y,c2w,c2h = cx+cw/2-20/2, cy+ch/2-20/2, 20,20

						dxDrawImage(
							c2x,c2y,c2w,c2h, 'assets/images/speed_center2.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						local text = tostring( math.clamp( fuel, 0, maxFuel ) )
						local scale, font = 0.5, getFont('montserrat_semibold', 26, 'light')

						local fx,fy = x + w/2 + 20, y+h/2 + 60

						dxDrawText(text,
							fx,fy,fx,fy,
							tocolor(210,233,243,255*alpha),
							scale, scale, font,
							'left', 'bottom'
						)

						local textWidth = dxGetTextWidth( text, scale, font )

						dxDrawText(string.format('/ %s', maxFuel),
							fx + textWidth + 2, fy-2,
							fx + textWidth + 2, fy-2,
							tocolor(210,233,243,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 20, 'light'),
							'left', 'bottom'
						)


					end,

				},

			},

		},

	},
}


loadGuiModule()

end)
