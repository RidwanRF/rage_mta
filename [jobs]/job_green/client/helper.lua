
----------------------------------------------------

	bindKey(Config.helpKey, 'both', function( _, state )

		-- if exports.jobs_main:getPlayerWork(localPlayer) == Config.resourceName then

			toggleHelper( state == 'down' )

		-- else

		-- 	toggleHelper( false )

		-- end

	end)

----------------------------------------------------

	function renderHelper()

		for _, object in pairs( getElementsByType('object', resourceRoot, true) ) do

			if isElementOnScreen(object) then

				object.alpha = 155 + 100 * math.abs( math.sin( getTickCount() * 0.003 ) )
				local _, _, rz = getElementRotation(object)

				setElementRotation(object, 0, 0, rz + 1)

			end

		end

	end

----------------------------------------------------

	function toggleHelper( flag )

		local func = flag and addEventHandler or removeEventHandler
		func( 'onClientRender', root, renderHelper )

		if not flag then

			for _, object in pairs( getElementsByType('object', resourceRoot) ) do
				object.alpha = 255
				setElementRotation(object, 0, 0, 0)
			end

		end

	end	

----------------------------------------------------