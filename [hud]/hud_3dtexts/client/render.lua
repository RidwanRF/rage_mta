
-------------------------------------------------------

	function getScaleFromDistance(distance, mindist, maxdist)
		local progress = distance - mindist
		local scale = progress/(maxdist - mindist)
		return math.clamp(1 - scale, 0, 1)
	end

-------------------------------------------------------

	local renderTemplates = {
		['3dtext'] = {
			zAdd = 1,
			render = function(element, x,y, data)

				local text = element:getData('3dtext') or ''

				local scale = getScaleFromDistance(data.dist, 5, element:getData('3dtext.maxDist') or 20)
				local f_scale = element:getData('3dtext.size') or 1

				dxDrawTextShadow(text,
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold', 30*f_scale, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)
			end,
		},

		['business.data'] = {
			zAdd = 0,
			render = function(element, x,y, data)

				local bData = element:getData('business.data') or {}
				local localLogin = localPlayer:getData('unique.login')

				local text = element:getData('business.3dtext') or ''
				local scale = getScaleFromDistance(data.dist, 5, 20)

				local size = 100
				y = y - size

				local image = 'assets/images/business_occ.png'
				setMarkerColor(element, 255, 50, 50, 50)

				if bData.owner == localLogin then
					image = 'assets/images/business_own.png'
					setMarkerColor(element, 50, 50, 255, 50)
				elseif bData.owner == '' then
					image = 'assets/images/business_free.png'
					setMarkerColor(element, 50, 255, 50, 50)
				end

				dxDrawImage(
					x - size/2, y - size/2,
					size, size, image,
					0, 0, 0, tocolor(255,255,255,255*scale)
				)

				y = y + size + 0
				dxDrawTextShadow(text,
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold_italic', 24, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

			end,
		},

		['auction.data'] = {
			zAdd = 1,
			render = function(element, x,y, data)

				local scale = getScaleFromDistance(data.dist, 5, element:getData('3dtext.maxDist') or 20)

				local timestamp = getServerTimestamp()
				local auctionData = element:getData('auction.data') or {}

				dxDrawTextShadow('[Аукцион]',
					x,y-30,x,y-30,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold', 60, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

				local serverTime = getServerTimestamp().timestamp
				local time = math.floor( auctionData.time - (serverTime - auctionData.start_time) )
				time = math.max( time, 0 )

				local min = math.floor( time/60 )
				local sec = time - min*60

				dxDrawTextShadow(('%02d:%02d'):format( min, sec ),
					x,y+10,x,y+10,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold', 60, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

				dxDrawTextShadow(('Ставка $%s'):format( splitWithPoints( auctionData.bet or 0, '.' ) ),
					x,y-55,x,y-55,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold', 30, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

			end,
		},

		['derrick.data'] = {
			zAdd = 0,
			render = function(element, x,y, data)

				local bData = element:getData('derrick.data') or {}
				local localLogin = localPlayer:getData('unique.login')

				local text = element:getData('derrick.3dtext') or ''
				local scale = getScaleFromDistance(data.dist, 5, 20)

				local size = 150
				y = y - size

				local image = 'assets/images/derrick_occ.png'
				setMarkerColor(element, 255, 50, 50, 50)

				if bData.owner == localLogin then
					image = 'assets/images/derrick_own.png'
					setMarkerColor(element, 50, 50, 255, 50)
				elseif bData.owner == '' then
					image = 'assets/images/derrick_free.png'
					setMarkerColor(element, 50, 255, 50, 50)
				end

				dxDrawImage(
					x - size/2, y - size/2,
					size, size, image,
					0, 0, 0, tocolor(255,255,255,255*scale)
				)

				y = y + size - 50
				dxDrawTextShadow('[НЕФТЕВЫШКА]',
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold_italic', 45, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

				y = y + 50
				dxDrawTextShadow(text,
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold_italic', 30, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)

			end,
		},

		['house.3dtext'] = {
			zAdd = 0,
			render = function(element, x,y, data)

				local hData = element:getData('house.data') or {}
				local localLogin = localPlayer:getData('unique.login')

				local text = element:getData('house.3dtext') or ''
				local scale = getScaleFromDistance(data.dist, 5, 20)

				local size = 100
				y = y - size

				local image = 'assets/images/house_occ.png'
				setMarkerColor(element, 255, 50, 50, 50)

				if hData.owner == localLogin then
					image = 'assets/images/house_own.png'
					setMarkerColor(element, 50, 50, 255, 50)
				elseif hData.owner == '' then
					image = 'assets/images/house_free.png'
					setMarkerColor(element, 50, 255, 50, 50)
				end

				dxDrawImage(
					x - size/2, y - size/2,
					size, size, image,
					0, 0, 0, tocolor(255,255,255,255*scale)
				)

				y = y + size + 0
				dxDrawTextShadow(text,
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold_italic', 24, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)
			end,
		},

		['flat.3dtext'] = {
			zAdd = 0,
			render = function(element, x,y, data)

				local hData = element:getData('flat.data') or {}

				local text = element:getData('flat.3dtext') or ''
				local scale = getScaleFromDistance(data.dist, 5, 20)

				local size = 100
				y = y - size

				local image = 'assets/images/flat.png'

				dxDrawImage(
					x - size/2, y - size/2,
					size, size, image,
					0, 0, 0, tocolor(255,255,255,255*scale)
				)

				y = y + size + 0
				dxDrawTextShadow(text,
					x,y,x,y,
					tocolor(255,255,255,255*scale),
					0.5, getFont('montserrat_semibold_italic', 24, 'light', true),
					'center', 'center', 1, tocolor(0, 0, 0, 50*scale), _, dxDrawText
				)
				
			end,
		},
	}

-------------------------------------------------------

	currentMarkers = {}

	setTimer(function()

		currentMarkers = {}

		local px,py,pz = getCameraMatrix()

		for _, marker in pairs( getElementsByType('marker', root, true) ) do

			local x,y,z = getElementPosition(marker)

			local dist = getDistanceBetweenPoints3D(px,py,pz, x,y,z)
			if dist < (marker:getData('3dtext.maxDist') or 25) then

				local type
				for name in pairs(renderTemplates) do
					if marker:getData(name) then
						type = name
					end
				end

				if type then
					currentMarkers[marker] = { type = type, dist = dist, }
				end

			end

		end

	end, 1000, 0)

-------------------------------------------------------

	function render3DText(marker, data)

		local mx,my,mz = getElementPosition(marker)

		local template = renderTemplates[data.type]

		local x,y = getScreenFromWorldPosition(mx,my,mz + (marker:getData('3dtext.zAdd') or template.zAdd or 0) )


		if x and y then

			local px,py,pz = getCameraMatrix()
			local mx,my,mz = getElementPosition(marker)

			local dist = getDistanceBetweenPoints3D(px,py,pz, mx,my,mz)
			data.dist = dist

			template.render(marker, x,y, data)
		end

	end

	addEventHandler('onClientRender', root, function()
		if isCursorShowing() then return end
		if localPlayer:getData('3dtext.hidden') then return end

		for marker, data in pairs( currentMarkers ) do

			if isElement(marker) then
				render3DText(marker, data)
			end

		end

	end)