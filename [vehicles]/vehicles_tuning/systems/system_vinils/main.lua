-- vinilCreateTimer = setTimer(function()

-- 	local _vc = Config.vinilCompressionSize
-- 	local created = 0
-- 	for _, vinil in pairs(Config.vinils) do
-- 		local path = 'assets/vinils/'..vinil.path

-- 		local file_sml
-- 		if fileExists(path..'_sml') then
-- 			file_sml = fileOpen(path..'_sml')
-- 		end

-- 		if fileExists(path)
-- 			and (
-- 				not fileExists(path..'_sml')
-- 				or (file_sml and fileGetSize(file_sml) <= 0)
-- 			)
-- 		then

-- 			local rTarget = dxCreateRenderTarget(_vc, _vc, true)

-- 			local texture = dxCreateTexture(path)
-- 			dxSetRenderTarget(rTarget)
-- 				mta_dxDrawImage1(0, 0, _vc, _vc, texture)
-- 			dxSetRenderTarget()
-- 			destroyElement(texture)

-- 			local pixels = dxConvertPixels( dxGetTexturePixels(rTarget), 'png')

-- 			if file_sml then
-- 				fileClose(file_sml)
-- 				fileDelete(path..'_sml')
-- 				file_sml = nil
-- 			end

-- 			local file = fileCreate(path..'_sml')
-- 			fileWrite(file, pixels)
-- 			fileClose(file)

-- 			destroyElement(rTarget)
-- 			created = created + 1
-- 		end

-- 		if file_sml then
-- 			fileClose(file_sml)
-- 			file_sml = nil
-- 		end

-- 	end

-- 	if created == 0 then killTimer(vinilCreateTimer) end

-- end, 20000, 0)

tempVinilTextures = {}

setTimer(function()
	if not windowOpened then
		for path, texture in pairs( tempVinilTextures ) do
			if isElement(texture) then
				destroyElement(texture)
				tempVinilTextures[path] = nil
			end
		end
	end
end, 1000, 0)

local mirror_shader = dxCreateShader('assets/shader/mirror.fx')

function drawVinil(vinil, isTemp, selection)

	local r,g,b = unpack(vinil.color or {255,255,255})
	local mul = Config.vinilBrightness

	local path = string.format('assets/vinils/%s', vinil.path)
	local s = currentVinilsQuality

    if selection then

    	local r,g,b = unpack(selection.color)


		mta_dxDrawImage(
			vinil.x*s - 10*s, vinil.y - 10*s,
			vinil.w*s + 20*s, vinil.h + 20*s,
			'assets/images/vinils/selvinil.png',
			vinil.r, 0, 0,
			tocolor(r,g,b,255)
		)

    end

	if vinil.mirrorx or vinil.mirrory then

	    local shader = mirror_shader
	    vinil.texture = isElement(vinil.texture) and vinil.texture or dxCreateTexture(path, 'argb', true, 'clamp')

	    dxSetShaderValue(shader, 'mirrorX', vinil.mirrorx and 1 or 0)
	    dxSetShaderValue(shader, 'mirrorY', vinil.mirrory and 1 or 0)
	    dxSetShaderValue(shader, 'gTexture', vinil.texture)
	    dxSetShaderValue(shader, 'r', r/255*mul)
	    dxSetShaderValue(shader, 'g', g/255*mul)
	    dxSetShaderValue(shader, 'b', b/255*mul)
	    dxSetShaderValue(shader, 'alpha', vinil.alpha or 1)

	    dxSetBlendMode('blend')
	    mta_dxDrawImage(
			vinil.x*s, vinil.y*s,
			vinil.w*s, vinil.h*s,
			shader, vinil.r, 0, 0,
			tocolor( 255,255,255 )
		)
	    dxSetBlendMode('modulate_add')

	    if not isTemp and isElement(vinil.texture) then
	    	destroyElement(vinil.texture)
	    end

	else

		tempVinilTextures[path] = tempVinilTextures[path] or dxCreateTexture(path, 'argb', true, 'clamp')
		mta_dxDrawImage(
			vinil.x*s, vinil.y*s,
			vinil.w*s, vinil.h*s,
			tempVinilTextures[path],
			vinil.r, 0, 0, 
			tocolor( r*mul,g*mul,b*mul, 255*(vinil.alpha or 1) )
		)

	end
end

local vinil_draw_timers = {}

function createVehicleVinils(vehicle)

	if vinil_draw_timers[vehicle] then return end

	if (
		not isElement(vehicle)
		or (not isElementStreamedIn(vehicle))
	)
	then
		return
	end

	if not localPlayer:getData('settings.vinils') then
		return setPaintJobTexture(vehicle, 'noTexture')
	end

	local vinils = vehicle:getData('paintjob') or {}

	if type(vinils) ~= 'table' then return end

	if #vinils == 0 then return setPaintJobTexture(vehicle, 'noTexture') end

	local renderTarget = dxCreateRenderTarget(
		Config.vinilRTSize*currentVinilsQuality,
		Config.vinilRTSize*currentVinilsQuality, true
	)

	-- dxSetBlendMode('modulate_add')

	-- dxSetRenderTarget(renderTarget, true)

	-- 	for index, vinil in pairs(vinils) do
	-- 		drawVinil(vinil)
	-- 	end

	-- dxSetRenderTarget()
	
	-- dxSetBlendMode('blend')

	-- setPaintJobTexture(vehicle, renderTarget)

	-- destroyElement(renderTarget)

	local part_size = math.ceil( #vinils/20 )
	local iterations = math.ceil( #vinils/part_size )

	vinil_draw_timers[vehicle] = {

		renderTarget = renderTarget,
		vehicle = vehicle,
		vinils = vinils,
		index = 1,

		iterations = iterations,
		part_size = part_size,

		timer = setTimer(function(vehicle)

			local data = vinil_draw_timers[vehicle]
			if not data then return end
			if not isElement(vehicle) then return killTimer(data.timer) end

			local n_index = data.index + data.part_size

			dxSetBlendMode('modulate_add')
			dxSetRenderTarget(data.renderTarget)

				for index = data.index, n_index do
					local vinil = data.vinils[index]
					if vinil then drawVinil(vinil) end
				end

			dxSetRenderTarget()
			dxSetBlendMode('blend')

			setPaintJobTexture(vehicle, data.renderTarget)

			data.index = n_index

			if data.index >= #vinils then

				destroyElement(data.renderTarget)
				killTimer(data.timer)

				vinil_draw_timers[vehicle] = nil

			end

		end, 50, 0, vehicle),

	}


end

addEventHandler("onClientVehicleScreenStreamIn", root, function ()
	if getElementType(source) == "vehicle" then
		createVehicleVinils(source)
	end
end)

-- addEventHandler("onClientResourceStart", resourceRoot, function ()
-- 	for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
-- 		createVehicleVinils(vehicle)
-- 	end
-- end)

addEventHandler("onClientElementDataChange", root, function(dataName, old, new)
	if dataName == 'paintjob' and source.type == 'vehicle' then
		if isElementOnScreen(source) and getDistanceBetween(source, localPlayer) < 50 then
			createVehicleVinils(source)
		end
	end
end)

addEventHandler("onClientRestore", root, function()
	for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
		if isElementOnScreen(vehicle) and getDistanceBetween(vehicle, localPlayer) < 50 then
			createVehicleVinils(vehicle)
		end
	end
end)

addEventHandler("onClientElementDataChange", localPlayer, function(dataName, old, new)
	if dataName == 'settings.vinils' then
		for _, vehicle in pairs( getElementsByType('vehicle') ) do
			createVehicleVinils(vehicle)
		end
	end
end)

------------------------------------------------------------------------------------------

	function updateVinilsQuality()

		-- local quality = localPlayer:getData('settings.vinils_quality') or 2
		-- local quality_list = { 0.5, 1, 2, 4 }

		-- currentVinilsQuality = quality_list[quality] or 1

		currentVinilsQuality = 1

		-- if vinilsDrawElement then

		-- 	if isElement(vinilsDrawElement.renderTarget) then
		-- 		destroyElement(vinilsDrawElement.renderTarget)
		-- 	end

		-- 	vinilsDrawElement:createRenderTarget()

		-- end

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
			createVehicleVinils(vehicle)
		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'settings.vinils_quality' then
			updateVinilsQuality()
		end
		
	end)


	addEventHandler("onClientResourceStart", resourceRoot, function ()
		updateVinilsQuality()
	end, true, 'high+100')


------------------------------------------------------------------------------------------