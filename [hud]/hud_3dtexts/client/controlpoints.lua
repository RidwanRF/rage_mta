
	controlPointMarkers = {}

	function addMarker(marker)
		controlPointMarkers[marker] = true
	end

	addEventHandler('onClientResourceStart', resourceRoot, function()
		for _, marker in pairs( getElementsByType('marker') ) do

			if marker:getData('controlpoint.3dtext') then
				controlPointMarkers[marker] = true
				setAnimData(marker, 0.1)
				animate(marker, 1)
			end

		end
	end)

	addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
		if dataName == 'controlpoint.3dtext' then

			if new then

				controlPointMarkers[source] = true
				setAnimData(source, 0.1)
				animate(source, 1)

			else

				local _source = source
				animate(_source, 0, function()
					removeAnimData(_source)
					controlPointMarkers[_source] = nil
				end)

			end

		end
	end)

	addEventHandler('onClientElementDestroy', root, function()
		local _source = source
		animate(_source, 0, function()
			removeAnimData(_source)
			controlPointMarkers[_source] = nil
		end)
	end)

-------------------------------------------------------

	local sx,sy = guiGetScreenSize()

-------------------------------------------------------

	local markers_data_cache = {}

	function renderPoint(marker)

		local dist, text
		local mx,my,mz

		if isElement(marker) then

			mx,my,mz = getElementPosition(marker)

			text = marker:getData('controlpoint.3dtext') or ''

			markers_data_cache[marker] = {mx,my,mz, text}

		else
			mx,my,mz, text = unpack(markers_data_cache[marker] or {})
		end

		if not (mx and text) then return end
		
		local px,py,pz = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints3D(mx,my,mz, px,py,pz)

		local mdist = {20, 200}
		local scale = math.clamp( ( dist - mdist[1] ) / ( mdist[2] - mdist[1] ), 0.8, 0.8 )

		-- if localPlayer.vehicle then
		-- end

		local x,y = getScreenFromWorldPosition( mx,my,mz )
		local alpha = getAnimData(marker)
		scale = (scale * 1.5) + 0.5*(1-alpha)

		if x and y then
		
			local height = 100 * scale

			dxDrawRectangle(
				x - 1, y - height,
				2, height, tocolor(255,230,77,255*alpha)
			)

			local size = 69*scale
			dxDrawImage(
				x - size/2, y - height - size,
				size, size, 'assets/images/cp.png',
				0, 0, 0, tocolor(255,230,77,255*alpha)
			)

			dxDrawTextShadow(text,
				x,y - 20*scale - size,x,y - height - 20*scale - size,
				tocolor(255,230,77,255*alpha),
				0.5*scale, getFont('montserrat_bold', 30, 'light', true),
				'center', 'bottom', 1, tocolor(0, 0, 0, 20*alpha), _, mta_dxDrawText
			)

			dxDrawTextShadow(math.floor(dist) .. 'м',
				x,y - height - size,x,y - height - size,
				tocolor(255,255,255,255*alpha),
				0.5*scale, getFont('montserrat_bold', 30, 'light', true),
				'center', 'bottom', 1, tocolor(0, 0, 0, 20*alpha), _, mta_dxDrawText
			)

		end

	end

	addEventHandler('onClientRender', root, function()
		if isCursorShowing() then return end
		if localPlayer:getData('3dtext.hidden') then return end

		for marker, text in pairs( controlPointMarkers ) do

			if not isElement(marker) or
			(localPlayer.interior == marker.interior
			and localPlayer.dimension == marker.dimension) then
				renderPoint(marker, text)
			end

		end

	end)