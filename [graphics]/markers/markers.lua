
loadstring( exports.core:include('common') )()
loadstring( exports.core:include('animations') )()

setAnimData('size', 0.05)

setTimer(function()
	setAnimData('size', 0.05)
	animate('size', 1)
end, 2000, 0)


addEventHandler('onClientRender', root, function()

	local cX, cY, cZ = getCameraMatrix()
    local mX, mY, mZ, data, scrX, scrY, needDraw, isOwner, textY

	if not localPlayer:getData('settings.markers') then

		for _, marker in pairs( getElementsByType('marker', root, true) ) do

			if isElement(marker) and getMarkerType(marker) == 'cylinder' then

	        	mX, mY, mZ = getElementPosition(marker)

	        	if getScreenFromWorldPosition(mX, mY, mZ) then

		        	local dist = getDistanceBetweenPoints3D(cX, cY, cZ, mX, mY, mZ)

		        	if dist < 30 then
		        		if marker.alpha > 0 then
			        		marker.alpha = 150
							fixMarkerZ(marker)
		        		end
		        	end

		        end
		        
			end


		end
		
		return
	end


	for _, marker in pairs( getElementsByType('marker', root, true) ) do
        if isElement(marker) and getMarkerType(marker) == 'cylinder' then

        	mX, mY, mZ = getElementPosition(marker)

        	if getScreenFromWorldPosition(mX, mY, mZ) then

	        	local dist = getDistanceBetweenPoints3D(cX, cY, cZ, mX, mY, mZ)

	        	if dist < 30 then

		        	if marker.alpha > 0 then

		        		marker.alpha = 30
		        		fixMarkerZ(marker)

			        	local mx, my, mz = getElementPosition(marker)

			        	local _, _, _, mz = processLineOfSight(
			        		mx,my,mz+0.5,
			        		mx,my,mz-100,
			        		true, false, false
		        		)

		        		if mz then

				        	mz = mz+0.03*marker.size

				        	local r,g,b = getMarkerColor(marker)

							local iconSize = marker.size + 0.2

							local direction = getTickCount() * 0.0002
							local ox = math.cos(direction) * iconSize / 2
							local oy =  math.sin(direction) * iconSize / 2
							roundIcon = roundIcon or dxCreateTexture('round.png')

							local alpha = 1
							dxDrawMaterialLine3D(
								mx + ox,
								my + oy,
								mz,
								mx - ox,
								my - oy,
								mz,
								roundIcon, 
								iconSize,
								tocolor(r,g,b, 255*alpha),
								mx,
								my,
								mz + 1
							)

							local anim = getAnimData('size')
							local iconSize = marker.size + 0.2 + 0.6*anim

							local ox = math.cos(direction) * iconSize / 2
							local oy =  math.sin(direction) * iconSize / 2

							dxDrawMaterialLine3D(
								mx + ox,
								my + oy,
								mz,
								mx - ox,
								my - oy,
								mz,
								roundIcon, 
								iconSize,
								tocolor(r,g,b, 255*(1-anim)),
								mx,
								my,
								mz + 1
							)

							local iconSize = marker.size + 0.2 + 0.3*anim

							local ox = math.cos(direction) * iconSize / 2
							local oy =  math.sin(direction) * iconSize / 2

							dxDrawMaterialLine3D(
								mx + ox,
								my + oy,
								mz,
								mx - ox,
								my - oy,
								mz,
								roundIcon, 
								iconSize,
								tocolor(r,g,b, 255*(1-anim)),
								mx,
								my,
								mz + 1
							)
							
		        		end


		        	end

	        	end
	        	
        	end


        end
	end


end)

local _cachedZ = {}

function fixMarkerZ(marker)
	if getMarkerType(marker) ~= 'cylinder' then return end
	local x,y,z = getElementPosition(marker)
	local gz = getGroundPosition(x,y,z)
	if math.abs(gz-z) < 1.5 then
		setElementPosition(marker, x,y,gz+0.02)
	end
	_cachedZ[marker] = true
end

addEventHandler('onClientElementStreamIn', root, function()
	if source.type == 'marker' and getMarkerType(source) == 'cylinder' and not _cachedZ[source] then
		if source.alpha > 0 then
			source.alpha = 30
		end
		fixMarkerZ(source)
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	for _, marker in pairs( getElementsByType('marker') ) do
		if isElementStreamedIn(marker) then
			fixMarkerZ(marker)
		end
	end
end)

addEventHandler('onClientElementDestroy', root, function()
	if _cachedZ[source] then
		_cachedZ[source] = nil
	end
end)