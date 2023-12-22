

------------------------------------------------------------------------------

	function renderTreeFall()

		local animData = getEasingValue( timed_getAnimData( workMarker.tree_fall_anim ), 'OutBounce' )

		local rx,ry,rz = getElementRotation( workMarker.tree )
		setElementRotation( workMarker.tree, 0, animData * (90 + workMarker.tree_fall_angle), rz )

	end

------------------------------------------------------------------------------

	function handleTreeFall()

		addEventHandler('onClientRender', root, renderTreeFall)

		local tx,ty,tz = getElementPosition( workMarker.tree )
		setElementPosition( workMarker.tree, tx,ty,tz+0.1 )

		timed_animate( workMarker.tree_fall_anim, true, function()

			destroyElement( workMarker.marker )
			removeEventHandler('onClientRender', root, renderTreeFall)

			setElementCollisionsEnabled( workMarker.tree, false )

			local rx,ry,rz = getElementRotation( workMarker.tree )
			setElementRotation( workMarker.tree, 0, (90 + workMarker.tree_fall_angle), rz )

			createSliceMarker()
			clearObjectTexture(workMarker.tree, 'sprucbr')

			workMarker.stage = 'slice'


		end )

	end


------------------------------------------------------------------------------