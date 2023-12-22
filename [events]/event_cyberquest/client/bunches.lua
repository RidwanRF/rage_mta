

-----------------------------------------------------------------

	bunchEffects = {}

-----------------------------------------------------------------


	function createBunchEffect( marker )

		if bunchEffects[marker] then return end

		local shader = dxCreateShader('assets/shaders/bunch.fx', 0, 0, true)
		local r,g,b = getMarkerColor( marker )

		dxSetShaderValue( shader, 'gColor', { r/255,g/255,b/255, 1 } )
		engineApplyShaderToWorldTexture( shader, 'blood', marker.parent )

		bunchEffects[marker] = { markers = {}, default_z = marker.position.z, shader = shader }

	end

-----------------------------------------------------------------

	function destroyBunchEffect( _marker )

		local marker = _marker or source

		if not bunchEffects[marker] then return end

		clearTableElements( bunchEffects[marker] or {} )
		bunchEffects[marker] = nil

	end

-----------------------------------------------------------------

	function pulseBunchEffect( marker )

		local effect = bunchEffects[marker]
		if not effect then return end

		local x,y,z = getElementPosition( marker )
		if not getScreenFromWorldPosition( x,y,z ) then return end

		local ox,oy =
			math.random( -60, 60 )/100,
			math.random( -60, 60 )/100

		local r,g,b = getMarkerColor( marker )

		local p_marker = createMarker( x + ox, y + oy, z-0.2, 'corona', 0.3, r,g,b, 255 )
		local p_data = { marker = p_marker, anim = {}, height = math.random(7,10)/10 }

		setAnimData( p_data.anim, 0.03 )

		effect.markers[p_marker] = p_data

		animate( p_data.anim, 1, function()

			if p_data.anim then
				removeAnimData( p_data.anim )
			end

			clearTableElements( p_data )
			
			if effect.markers then
				effect.markers[p_marker] = nil
			end

		end )

	end

-----------------------------------------------------------------

	function pulseEffect()

		for marker in pairs( bunchEffects ) do
			pulseBunchEffect( marker )
		end

		setTimer(pulseEffect, math.random( 300, 1000 ), 1)

	end

	pulseEffect()

-----------------------------------------------------------------

	addEventHandler('onClientRender', root, function()

		local tick_anim = math.abs( math.sin( getTickCount() * 0.0015 ) )

		for marker, data in pairs( bunchEffects ) do

			for p_marker, p_data in pairs( data.markers or {} ) do

				local anim = getAnimData( p_data.anim )

				local mx,my,mz = getElementPosition( marker )
				local px,py,pz = getElementPosition( p_marker )

				local r,g,b = getMarkerColor( p_marker )

				local a_anim_1, a_anim_2 = unpack( divideAnim( anim, 2 ) )

				local alpha = 255 * a_anim_1 * (1-a_anim_2)

				setElementPosition( p_marker, px, py, mz + anim * p_data.height - 0.2 )
				setMarkerColor( p_marker, r,g,b, alpha )
				
			end

			local x,y,z = getElementPosition( marker.parent )
			setElementPosition( marker.parent, x, y, data.default_z + ( getEasingValue( tick_anim, 'InOutQuad' )*0.03 ) )

			marker.parent.scale = 0.9 + ( getEasingValue( tick_anim, 'OutBounce' ) )*0.2


		end

	end)

-----------------------------------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()

		if source.type == 'marker' and source:getData('cyberquest.bunch') then

			createBindHandler( source, 'f', 'Собрать сгусток', function( marker )
				removeBindHandler( marker )
				triggerServerEvent( 'cyberquest.collectBunch', resourceRoot, marker )
			end )

			createBunchEffect( source )

		end

	end)

	addEventHandler('onClientElementStreamOut', resourceRoot, destroyBunchEffect)
	addEventHandler('onClientElementDestroy', resourceRoot, destroyBunchEffect)

-----------------------------------------------------------------

	addEventHandler('onClientVehicleCollision', root, function( hitElement )

		if localPlayer.vehicle == source and isElement( hitElement ) and source.model == 587 then

			if hitElement.model == 1169 then

				local abilities = exports.vehicles_quadra:getVehicleAbilities()
				if not abilities.impulse then return end

				local marker = getElementChild( hitElement, 0 )

				if isElement( marker ) then
					triggerServerEvent('cyberquest.breakBunch', resourceRoot, marker)
				end

			end


		end
		
	end)

	addEvent('cyberquest.createBunchExplosion', true)
	addEventHandler('cyberquest.createBunchExplosion', resourceRoot, function( x,y,z )
		createExplosion( x,y,z, 10, true, -1, false )

	end)

-----------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, marker in pairs( getElementsByType('marker', resourceRoot, true) ) do

			if marker:getData('cyberquest.bunch') then
				createBunchEffect( marker )
			end

		end

	end)

-----------------------------------------------------------------
