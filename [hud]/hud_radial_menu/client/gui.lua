

disableVerticalAnim = true

setAnimData('rot-anim', 0.15)

openHandlers = {
	
	function()

		keepCurrentControl()

		animate('rot-anim', 1)

		showChat(false)
		setCursorAlpha(0)

	end,

}

closeHandlers = {

	function()

		stopControlKeeping()

		animate('rot-anim', 0)
		showChat(true)
		setCursorAlpha(255)

	end,
	
}

clearGuiTextures = false
hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',

			'center', ( real_sy / 2 - px ( 544 ) / 2 ) * sx / real_sx,
			544, 544, 

			'assets/images/radial_bg.png',
			id = 'radial-main',

			color = { 20, 20, 20, 200 },

			controls = {

				{

					display_condition = function ( )
						return localPlayer.vehicle and localPlayer.vehicleSeat == 0
					end,

					action = 'engine',

					id = 'engine',

					text = 'Двигатель',

					hint = function ( )
						return getVehicleEngineState( localPlayer.vehicle ) and 'Выключить' or 'Включить'
					end,


				},

				{

					display_condition = function ( )
						return not localPlayer.vehicle and exports.main_inventory:hasInventoryItem ( { player = localPlayer, item = 'first_aid_kit' } )
					end,

					action = 'first_aid_kit',

					id = 'first_aid_kit',

					text = 'Аптечка',

					hint = function ( )
						return 'Использовать'
					end,


				},

				{

					text = 'СГУ',
					action = 'sirens',
					id = 'sirens',

					display_condition = function ( )
						return localPlayer.vehicle and ( localPlayer.vehicle:getData ( 'sirens' ) or 0 ) > 0
							and localPlayer.vehicleSeat == 0
					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'sirens.state' ) and 'Выключить' or 'Включить'
					end,

				},

				{

					text = 'ФСО',
					action = 'fso',
					id = 'fso',

					display_condition = function ( )
						return localPlayer.vehicle and ( localPlayer.vehicle:getData ( 'fso' ) or 0 ) > 0
							and localPlayer.vehicleSeat == 0
					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'fso.state' ) and 'Выключить' or 'Включить'
					end,

				},

				{

					text = 'Ручник',
					action = 'handbrake',
					id = 'handbrake',

					display_condition = function ( )
						return localPlayer.vehicle and localPlayer.vehicleSeat == 0
					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'vehicle.handbrake' ) and 'Снять' or 'Поставить'
					end,

				},

				{

					text = 'Оптика',
					action = 'lights',
					id = 'lights',

					display_condition = function ( )

						local banned = {
							Helicopter = true,
							Boat = true,
						}

						return localPlayer.vehicle and localPlayer.vehicleSeat == 0 and
							not banned [ getVehicleType ( localPlayer.vehicle ) ]

					end,

					hint = function ( )

						local state = localPlayer.vehicle:getData ( 'vehicleLightsState' )
						local text = ''

						if state == 'off' then
							text = 'Габариты'
						elseif state == 'hwd' then
							text = 'Фары'
						else
							text = 'Выключить'
						end

						return text
					end,

				},

				{

					text = 'Шторка',
					action = 'curtain',
					id = 'curtain',

					display_condition = function ( )
						return localPlayer.vehicle and ( localPlayer.vehicle:getData ( 'plate_curtain' ) or 0 ) > 0
							and localPlayer.vehicleSeat == 0
					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'sirens.enabled' ) and 'Выключить' or 'Включить'
					end,

				},

				{

					text = 'Стробоскопы',
					action = 'strobo',
					id = 'strobo',

					display_condition = function ( )
						return localPlayer.vehicle and ( localPlayer.vehicle:getData ( 'strobo' ) or 0 ) > 0
							and localPlayer.vehicleSeat == 0
					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'vehicleLightsState' ) == 'strobo' and 'Выключить' or 'Включить'
					end,

				},

				{

					text = 'Джетпак',
					action = 'jetpack',
					id = 'jetpack',

					display_condition = function ( )
						return not localPlayer.vehicle and exports.main_vip:isVip ( localPlayer ) and localPlayer.dimension == 0 and localPlayer.interior == 0
							and exports.main_weapon_zones:isPlayerInZone ( localPlayer )
					end,

					hint = function ( )
						return doesPedHaveJetPack ( localPlayer ) and 'Забрать' or 'Выдать'
					end,

				},

				{

					text = 'Двери',

					action = 'block',
					id = 'block',

					display_condition = function ( self )
						self.vehicle = getNearestPlayerVehicle ( localPlayer, 15 ) or localPlayer.vehicle
						return ( isElement ( self.vehicle ) and localPlayer.vehicle ~= self.vehicle ) or
							( localPlayer.vehicleSeat == 0 and localPlayer:getData ( 'unique.login' ) == localPlayer.vehicle:getData ( 'owner' ) )
					end,

					hint = function ( self )
						return isElement ( self.vehicle ) and isVehicleLocked ( self.vehicle ) and 'Открыть' or 'Закрыть'
					end,

				},

				{

					text = 'Управление',

					action = function ( )
						exports.main_control_help:openWindow ( 'main' )
					end,
					id = 'control_help',

					display_condition = function ( )
						return true
					end,

					hint = function ( )
						return 'Подсказки'
					end,

				},

				{

					text = function ( )

						local flag, name = exports.vehicles_transforms:isVehicleTransformable ( localPlayer.vehicle )
						if flag then
							return name
						end

						return ''

					end,

					hint = function ( )
						return localPlayer.vehicle:getData ( 'transformActive' ) and 'Выключить' or 'Включить'
					end,

					display_condition = function ( )
						return exports.vehicles_transforms:isVehicleTransformable ( localPlayer.vehicle ) and localPlayer.vehicleSeat == 0
					end,

					id = 'transform',

					action = function ( )
						if ( localPlayer.vehicleSeat == 0 ) then
							localPlayer.vehicle:setData ( 'transformActive', not localPlayer.vehicle:getData ( 'transformActive' ) )
						end
					end,

				},

				{

					text = 'Аварийки',

					hint = function ( )

						local state = (
							exports.vehicles_turn_lights:getVehicleLightData ( localPlayer.vehicle, 'turn_left' )
							or
							exports.vehicles_turn_lights:getVehicleLightData ( localPlayer.vehicle, 'turn_right' )
						)

						return state and 'Выключить' or 'Включить'

					end,

					display_condition = function ( )

						local banned = {
							Helicopter = true,
							Boat = true,
						}

						return localPlayer.vehicle and localPlayer.vehicleSeat == 0 and
							not banned [ getVehicleType ( localPlayer.vehicle ) ]
					end,

					id = 'turns',

					action = function ( )

						local vehicle = localPlayer.vehicle
						if not vehicle then return end

						local state = (
							exports.vehicles_turn_lights:getVehicleLightData ( vehicle, 'turn_left' )
							or
							exports.vehicles_turn_lights:getVehicleLightData ( vehicle, 'turn_right' )
						)

						exports.vehicles_turn_lights:setLocalLightsData ( 'turn_left', not state )
						exports.vehicles_turn_lights:setLocalLightsData ( 'turn_right', not state )

					end,

				},

			},

			clearControls = function ( )

				local remove = { }
				for index, element in pairs ( windowModel.main ) do
					if element.radialElement then
						table.insert ( remove, index )
					end
				end

				for _, index in pairs ( remove ) do
					windowModel.main [ index ] = nil
				end

			end,

			onInit = function ( element )

				openHandlers.update_controls = function ( )

					local radialMenu = gui_get ( 'radial-main' )

					radialMenu:clearControls ( )

					radialMenu.currentControls = { }

					for index, control in pairs ( radialMenu.controls ) do

						if control:display_condition ( ) then
							radialMenu.currentControls [ index ] = control
						end

					end

					elementsCount = getTableLength ( radialMenu.currentControls )
					angle = 360 / elementsCount

					local r = 0
					local i = 1

					for index, control in pairs ( radialMenu.currentControls ) do


						local element =
						{'image',
							0,0,0,0,

							mtaDraw = true,
							radialElement = true,

							rot = r,

							'',
							color = {0,0,0,150},

							onRender = function ( element )


								local anim = getEasingValue ( getAnimData ( 'rot-anim' ), 'InOutQuad' )
								local rotation = element.rot

								local x,y = getPointFromDistanceRotation(
									real_sx/2, real_sy/2, px ( 180 - 10*anim ), rotation - 180 )

								local alpha = element:alpha ( )
								local r,g,b = 255,255,255

								if currentSelectedItem == element.index then
									r,g,b = 200,70,70
								end

								local x,y,w,h = x - px(45), y - px(45) - 20, px(90), px(90)

								mta_dxDrawImage(x,y,w,h,
									string.format('assets/images/sections/%s.png', element.control.id),
									0, 0, 0, tocolor(r,g,b, 255*alpha)
								)

								local text = element.control.text
								if type ( text ) == 'function' then
									text = text ( )
								end

								mta_dxDrawText ( text,
									x,y+h-10,x+w,y+h-10,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top'
								)

								element.s_animId = element.s_animId or { }

								local animData = getAnimData ( element.s_animId )
								if not animData then
									animData = 0
									setAnimData ( element.s_animId, 0.1 )
								end

								animate ( element.s_animId, element.selected and 1 or 0 )

								local hint = element.control.hint
								if type ( hint ) == 'function' then
									hint = element.control:hint ( )
								end

								mta_dxDrawText ( hint,
									x,y+h+10,x+w,y+h-10,
									tocolor(100,100,100,255*alpha*animData),
									0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
									'center', 'top'
								)

								local x,y = getPointFromDistanceRotation(
									real_sx/2, real_sy/2, px(110 - 10*anim), rotation - 180)


								local x,y,w,h = x - px(10), y - px(10), px(20), px(20)

								mta_dxDrawImage(
									x,y,w,h, 'assets/images/selection.png',
									0, 0, 0, tocolor(200, 70, 70, 255*alpha*animData)
								)




							end,

							i = i,
							index = index,
							control = control,

						}

						table.insert ( windowModel.main, element )


						i = i + 1
						r = r - angle

					end

					for index, element in pairs( windowModel.main ) do

						if not element.__data then
							initializeElement( currentWindowSection, index, element )
						end

					end

					

				end

				closeHandlers.update_controls = function()

					for _, element in pairs( windowModel.main ) do

						if element.radialElement and element.selected then

							if type(element.control.action) == 'function' then
								element.control.action()
							else
								triggerServerEvent('radmenu.handleAction', resourceRoot, element.control.action)
							end

						end

					end

				end

			end,

			onRender = {

				function(element)

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					local texture = getDrawingTexture('assets/images/border.png')
					local mw,mh = dxGetMaterialSize(texture)

					local gradient = getTextureGradient(texture, {
						angle = getTickCount() * 0.15,
						alpha = alpha,
						color = {
							{ 140, 40, 40, 255 },
							{ 255, 100, 100, 255 },
						},
					})

					dxDrawImage(
						x+w/2-mw/2, y+h/2-mh/2,
						mw,mh, gradient
					)



				end,

				update_selection = 	function()

					local positions = {}

					table.insert(positions, {real_sx/2, real_sy/2, false})

					for index, element in pairs(windowModel.main) do

						if element.radialElement then

							element.selected = false

							local x,y = getPointFromDistanceRotation(
								real_sx/2, real_sy/2, px(115), element.rot - 180)
							table.insert(positions, {x, y, element})

						end

					end

					local nearestIndex

					local cx,cy = getCursorPosition()
					if not cx then return end
					cx,cy = cx*real_sx, cy*real_sy

					for _, pos in pairs( positions ) do
						local dist = getDistanceBetweenPoints2D(cx,cy, pos[1], pos[2])
						if not nearestIndex or dist < nearestIndex[1] then
							nearestIndex = {dist, pos[3]}
						end
					end

					local element = (nearestIndex or {})[2] or {}
					element.selected = true

				end,

			}

		},
		
	},

}


---------------------------------------------------------------------





loadGuiModule()

end)
