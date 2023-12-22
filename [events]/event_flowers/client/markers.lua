

--------------------------------------------------------------------------------------------

	local _cached_z = {}

	addEventHandler('onClientRender', root, function()

		for _, object in pairs( getElementsByType('object', resourceRoot, true) ) do

			local animData = getAnimData( object )
			_cached_z[ object ] = _cached_z[ object ] or object.position.z

			if animData then

				setElementPosition(
					object,
					object.position.x,
					object.position.y,
					_cached_z[ object ] - 2*animData
				)
				
				object.scale = 1 - 0.5 * animData
				
			else

				local progress = math.abs( math.sin( getTickCount() * 0.0007 ) )
				local zAdd = massInterpolate( {-0.1}, {0.1}, progress, 'InOutQuad' )

				setElementPosition(
					object,
					object.position.x,
					object.position.y,
					_cached_z[ object ] + zAdd
				)

				setElementRotation(
					object,
					object.rotation.x,
					object.rotation.y,
					object.rotation.z + 0.5
				)

			end

		end

	end)

--------------------------------------------------------------------------------------------

	addEvent('flower.displayDestroyEffect', true)
	addEventHandler('flower.displayDestroyEffect', resourceRoot, function( object )

		setAnimData( object, 0.01, 0 )
		animate( object, 1 )

	end)

--------------------------------------------------------------------------------------------

	local function clearCachedZ()
		_cached_z[source] = nil
		removeAnimData(source)
	end

	addEventHandler('onClientElementDestroy', resourceRoot, clearCachedZ)
	addEventHandler('onClientElementStreamOut', resourceRoot, clearCachedZ)

--------------------------------------------------------------------------------------------