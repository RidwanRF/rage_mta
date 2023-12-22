

-------------------------------------------------------

	manipulators = {}

-------------------------------------------------------

	Manipulator_class = {

		init = function( self, data )

			if not isElement( data.vehicle ) then return false end

			self.vehicle = data.vehicle
			self.objects = {}

			local x,y,z = getElementPosition( self.vehicle )

			self.objects.base = createObject( 1151, x,y,z )
			self.objects.bone_1 = createObject( 1152, x,y,z )
			self.objects.bone_2 = createObject( 1153, x,y,z )
			self.objects.magnet = createObject( 1154, x,y,z )

			attachElements( self.objects.base, self.vehicle )
			attachElements( self.objects.bone_1, self.objects.base )
			attachElements( self.objects.bone_2, self.objects.bone_1 )
			attachElements( self.objects.magnet, self.objects.bone_2 )

			for key, object in pairs( self.objects ) do
				setElementCollisionsEnabled( object, false )
			end

			self.animations = {}

			self.animations.rot_h = {}
			self.animations.rot_v_1 = {}
			self.animations.rot_v_2 = {}
			self.animations.rot_b = {}
			self.anim_speed = 0.15

			for _, anim in pairs( self.animations ) do
				setAnimData( anim, self.anim_speed, 0 )
			end

			manipulators[ self.vehicle ] = self

		end,

		destroy = function(self)

			for _, anim in pairs( self.animations ) do
				removeAnimData(anim)
			end

			manipulators[ self.vehicle ] = nil
			clearTableElements( self )

		end,

		render = function( self )

			local rot = getPedCameraRotation( localPlayer )

			if isElement( self.objects.base ) then

				local h_anim = getAnimData( self.animations.rot_h )
				local v_anim_1 = getAnimData( self.animations.rot_v_1 )
				local v_anim_2 = getAnimData( self.animations.rot_v_2 )

				local b_anim = getAnimData( self.animations.rot_b )

				local bone_1_rot = v_anim_1
				local bone_2_rot = v_anim_2
				local magnet_rot = -bone_1_rot-bone_2_rot

				setElementAttachedOffsets( self.objects.base, 0, -3, 2, 0, 0, h_anim )
				setElementAttachedOffsets( self.objects.bone_1, 0, 0, 0.85/2, bone_1_rot, 0, 0 )
				setElementAttachedOffsets( self.objects.bone_2, 0, -5.28868/2, 0, bone_2_rot, 0, 0 )
				setElementAttachedOffsets( self.objects.magnet, 0, (-9.982/2)+5.28868/2, 0, magnet_rot, 0, 0 )

				setVehicleComponentRotation( self.vehicle, 'rdoor_ok', b_anim, 0, 0 )

				local pos = { 0.00048267253441736, -4.6428294181824 + 1.5 * b_anim/90, 0.43209969997406 }

				setVehicleComponentPosition( self.vehicle, 'rdoor_ok', unpack(pos) )
			end

		end,

		pressed_keys = {},

		handleKey = function( self, key, state )

			if key:find('mouse_wheel') then
				local func = self.process_keys[key]
				func(self)
			else
				self.pressed_keys[key] = state
			end

		end,

		rot_v_1 = 0, rot_v_2 = 0,

		updateKeyRanges = function( self )

			local rot_v_1 = math.clamp( self.rot_v_1, -67, 10 )
			local rot_v_2 = math.clamp( self.rot_v_2, 0, 65 - rot_v_1 )

			animate( self.animations.rot_v_1, rot_v_1 )
			animate( self.animations.rot_v_2, rot_v_2 )

			self.rot_v_1 = rot_v_1
			self.rot_v_2 = rot_v_2

		end,

		getControlPressed = function(self)
			return getKeyState( 'lctrl' ) or getKeyState( 'rctrl' )
		end,

		process_keys = {

			pgdn = function(self)
				local _, target = getAnimData( self.animations.rot_b )
				animate( self.animations.rot_b, math.clamp( target + 1, 0, 90 ) )
			end,

			pgup = function(self)
				local _, target = getAnimData( self.animations.rot_b )
				animate( self.animations.rot_b, math.clamp( target - 1, 0, 90 ) )
			end,

			arrow_l = function(self)
				local _, target = getAnimData( self.animations.rot_h )
				animate( self.animations.rot_h, math.clamp( target - 1, -100, 100 ) )
			end,

			arrow_r = function(self)
				local _, target = getAnimData( self.animations.rot_h )
				animate( self.animations.rot_h, math.clamp( target + 1, -100, 100 ) )
			end,

			arrow_d = function(self)

				if self:getControlPressed() then
					self.rot_v_1 = (self.rot_v_1 or 0) + 1
					self:updateKeyRanges()
				else
					self.rot_v_2 = (self.rot_v_2 or 0) + 1
					self:updateKeyRanges()
				end

			end,

			arrow_u = function(self)

				if self:getControlPressed() then
					self.rot_v_1 = (self.rot_v_1 or 0) - 1
					self:updateKeyRanges()
				else
					self.rot_v_2 = (self.rot_v_2 or 0) - 1
					self:updateKeyRanges()
				end

			end,

		},

		renderKeys = function( self )

			for key, pressed in pairs( self.pressed_keys ) do

				if pressed then

					local func = self.process_keys[key]
					if func then
						func( self )
					end

				end

			end

		end,

		sync = function(self, data)

			for name, anim in pairs( self.animations or {} ) do
				if tonumber(data[name]) and data[name] == data[name] then
					animate( anim, data[name] )
				end
			end

		end,

	}

	initClasses()

-------------------------------------------------------

	addEventHandler('onClientRender', root, function()

		for vehicle, manipulator in pairs( manipulators ) do
			if isElementStreamedIn(vehicle) then
				manipulator:render()
			end
		end

		if localPlayer.vehicle and manipulators[localPlayer.vehicle] then
			manipulators[localPlayer.vehicle]:renderKeys()
		end

	end)

-------------------------------------------------------

	addEventHandler('onClientKey', root, function( button, state )

		if Manipulator_class.process_keys[button] then

			if localPlayer.vehicle and localPlayer.vehicle.model == Config.vehicle then

				local manipulator = manipulators[localPlayer.vehicle]

				if manipulator then
					manipulator:handleKey( button, state )
				end

				cancelEvent()

			end

		end

	end)

-------------------------------------------------------
	
	setTimer(function()

		local needed_vehicles = {}

		for _, vehicle in pairs( getElementsByType('vehicle', resourceRoot, true) ) do

			if isElementOnScreen(vehicle) and getDistanceBetween( localPlayer, vehicle ) < 70 and localPlayer.vehicle ~= vehicle then
				needed_vehicles[vehicle] = true
			end

		end

		if localPlayer.vehicle and localPlayer.vehicle.model == Config.vehicle then


			local manipulator = manipulators[localPlayer.vehicle]

			if manipulator then

				local anims = {}

				for name, anim in pairs( manipulator.animations or {} ) do
					anims[ name ] = getAnimData( anim )
				end

				triggerServerEvent('rubbisher.syncManipulator', resourceRoot, anims, needed_vehicles)

			end

		elseif getTableLength( needed_vehicles ) > 0 then

			triggerServerEvent('rubbisher.syncManipulator', resourceRoot, nil, needed_vehicles)

		end

	end, 500, 0)

	addEvent('rubbisher.syncManipulator', true)
	addEventHandler('rubbisher.syncManipulator', resourceRoot, function( vehicles )

		for vehicle, anims in pairs( vehicles ) do

			if isElementOnScreen( vehicle ) and vehicle ~= localPlayer.vehicle then

				local manipulator = manipulators[vehicle]

				if manipulator then
					manipulator:sync( anims )
				end

			end

		end

	end)

-------------------------------------------------------
