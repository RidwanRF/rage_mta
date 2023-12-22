

----------------------------------------------------

	currentManipulatorTarget = {}

----------------------------------------------------

	function initializeRubbishMarker( marker_table, work_vehicle )

		currentManipulatorTarget.object = marker_table.object

		local x,y,z,rz = unpack( marker_table.coords )

		currentManipulatorTarget.s_object = createObject( 1148, x,y,z, 0, 0, rz )
		currentManipulatorTarget.object = createObject( 1149, x,y,z, 0, 0, rz )

		currentManipulatorTarget.marker = marker_table.marker
		currentManipulatorTarget.help_marker = marker_table.help_marker
		currentManipulatorTarget.vehicle = work_vehicle

	end
	addEvent('rubbisher.initializeRubbishMarker', true)
	addEventHandler('rubbisher.initializeRubbishMarker', resourceRoot, initializeRubbishMarker)

----------------------------------------------------

	addEventHandler('onClientElementDestroy', resourceRoot, function()

		if currentManipulatorTarget and currentManipulatorTarget.marker == source then
			clearTableElements( { currentManipulatorTarget.s_object, currentManipulatorTarget.object } )
		end

	end)

----------------------------------------------------

	function getCurrentManipulator()
		return manipulators[ currentManipulatorTarget.vehicle ]
	end

----------------------------------------------------

	function checkObjectPick()

		local manipulator = getCurrentManipulator()
		if not manipulator then return end

		if not isElement(currentManipulatorTarget.vehicle) then return end
		if not isElement(currentManipulatorTarget.object) then return end
		if localPlayer.vehicle ~= currentManipulatorTarget.vehicle then return end

		if isElementAttached( currentManipulatorTarget.object ) then

			local dx = getVehicleComponentRotation( currentManipulatorTarget.vehicle, 'rdoor_ok' )

			if dx < 80 then
				return false
			end

			local rx,ry,rz = getVehicleComponentPosition( currentManipulatorTarget.vehicle, 'rubbish_put_dummy', 'world' )
			local ox,oy,oz = getElementPosition( currentManipulatorTarget.object )

			return getDistanceBetweenPoints3D( rx,ry,rz, ox,oy,oz ) < 1.5

		else

			local mx,my,mz = getElementPosition( manipulator.objects.magnet )
			local ox,oy,oz = getElementPosition( currentManipulatorTarget.marker )

			return getDistanceBetweenPoints3D( mx,my,mz-0.1, ox,oy,oz+0.9 ) < 0.4

		end

	end

----------------------------------------------------

	function pickRubbishObject()

		local manipulator = getCurrentManipulator()
		if not manipulator then return end

		if isElementAttached( currentManipulatorTarget.object ) then
			return
		end

		local mx,my,mz = getElementPosition( manipulator.objects.magnet )
		local ox,oy,oz = getElementPosition( currentManipulatorTarget.marker )

		if checkObjectPick() then

			attachElements( currentManipulatorTarget.object, manipulator.objects.magnet, 0, 0, -1.7 )
			setElementCollisionsEnabled( currentManipulatorTarget.object, false )

			exports.hud_notify:notify('Манипулятор', 'Перетащите обьект к отсеку')

		end

	end

	function putRubbishObject()

		if isElement( currentManipulatorTarget.vehicle ) then

			local dx = getVehicleComponentRotation( currentManipulatorTarget.vehicle, 'rdoor_ok' )

			if dx < 80 then
				return exports.hud_notify:notify('Сперва откройте дверь', 'Для этого зажмите PageDown')
			end

			if checkObjectPick() then

				triggerServerEvent('rubbisher.completeMarker', resourceRoot, localPlayer)

				local manipulator = getCurrentManipulator()
				if not manipulator then return end

				animate( manipulator.animations.rot_b, 0 )

			end
			
		end

	end

----------------------------------------------------

	addEventHandler('onClientKey', root, function( button, state )

		if button:find('enter') and state and localPlayer:getData('work.current') == Config.resourceName and
			localPlayer.vehicle == currentManipulatorTarget.vehicle
		then

			if isElement(currentManipulatorTarget.vehicle) then

				local manipulator = getCurrentManipulator()
				if not manipulator then return end

				if isElementAttached(currentManipulatorTarget.object) then
					putRubbishObject()
				else
					pickRubbishObject()
				end

				cancelEvent()

			end

		end

	end)

----------------------------------------------------