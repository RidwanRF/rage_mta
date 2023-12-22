
coverShaders = {}

local textureNames = {
	['remap'] = true,
	['remap_body'] = true,
	['body'] = true,
}

local coverTypes = {
	chrome = true,
	mat = true,
	perlamutr = true,
	chameleon = true,
	default = true,
	tex_replace = true,
}


function setVehicleSpecularColor(vehicle, r,g,b)
	vehicle:setData('color_cover', RGBToHex(r,g,b), false)
end

function setSpecularColor(vehicle)
	local specularColor = vehicle:getData('color_cover') or '#ffffff'
	local r,g,b = getColorFromString( specularColor )

	if (coverShaders[vehicle] and coverShaders[vehicle][1]) then
		dxSetShaderValue(coverShaders[vehicle][1], 'specularColor', {r,g,b,1})
	end
end

function createCoverShader(type, specularColor, priority)

	-- local s_type = type
	local s_type = type == 'mat' and 'default' or type

	local shader = dxCreateShader(
		-- string.format('assets/shader/%s.fx', type), priority or 1000, 0, false, 'vehicle')
		ShaderSources[s_type] or string.format('assets/shader/%s.fx', s_type), priority or 1000, 0, false, 'vehicle')

	if type == 'default' then

		dxSetShaderValue(shader, 'light', 2.0 )

	elseif type == 'mat' then

		dxSetShaderValue(shader, 'm_fixed', 0.0 )
		dxSetShaderValue(shader, 'light', 2.6 )
		
	end

	dxSetShaderValue(shader, 'specularColor', specularColor or {1,1,1,1} )
	dxSetShaderValue(shader, 'sReflectionTexture',  getCurrentCoverTexture() )

	shader:setData('coverShader', true)

	return shader
end

function clearAllVehicleCovers(vehicle)
	if coverShaders[vehicle] then
		if isElement(coverShaders[vehicle][1]) then
			destroyElement(coverShaders[vehicle][1])
		end
		coverShaders[vehicle] = nil
	end
end

function setVehicleCover(vehicle, eCoverType)
	
	if not isElementStreamedIn(vehicle) then return end

	local coverType = eCoverType or (vehicle:getData('coverType') or 'default')

	if coverShaders[vehicle] then
		if coverType == coverShaders[vehicle][2] then
			return false
		end
	end

	if coverTypes[coverType] then
		clearAllVehicleCovers(vehicle)
		coverShaders[vehicle] = { createCoverShader( coverType ), coverType }
		createVehicleVinils(vehicle)

		for texture in pairs(textureNames) do
			engineApplyShaderToWorldTexture(coverShaders[vehicle][1], texture, vehicle)
		end
	end

	setSpecularColor(vehicle)
	setPaintJobTexture(vehicle, paintJobTextures[vehicle] or 'noTexture')

end

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)

	if getElementType(source) ~= 'vehicle' then return end
	if not isElementStreamedIn(source) then return end
	if not isElementOnScreen(source) then return end

	if dataName == 'coverType' then
		setVehicleCover(source)
	elseif dataName == 'color_cover' then
		setSpecularColor(source)
	end

end, true, 'high')

addEventHandler('onClientVehicleScreenStreamIn', root, function()
	if source.type == 'vehicle' then
		setVehicleCover(source)
	end
end)

addEventHandler('onClientElementStreamOut', root, function()
	if source.type == 'vehicle' then
		clearAllVehicleCovers(source)
	end
end)

addEventHandler('onClientElementDestroy', root, function()
	clearAllVehicleCovers(source)
end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	for k,v in pairs( getElementsByType('vehicle') ) do
		if isElementStreamedIn(v) then setVehicleCover(v) end
	end

end)

----------------------------------------------------------------------------

	local otherTextures = {
		details_chrome = { shader = 'default_other', color = { 0.2, 0.2, 0.2, 1 }, power = 5, spec = 1 },
		chrome_disk = { shader = 'default_other', color = { 0.2, 0.2, 0.2, 1 }, power = 5, spec = 1 },
		details_black = { shader = 'default_other', color = { 0, 0, 0, 1 }, power = 1, spec = 0 },
		mirror_refl_0 = { shader = 'default_realtime', color = { 0, 0, 0, 1 }, realtime = true },
		carbon = { shader = 'carbon' },
	}

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for texture, data in pairs( otherTextures ) do

			data.shader_element = createCoverShader( data.shader )

			if data.color then
				dxSetShaderValue(data.shader_element, 'paintColor', data.color)
			end

			dxSetShaderValue(data.shader_element, 'reflPower', data.power or 1)
			dxSetShaderValue(data.shader_element, 'specularPower', data.spec or 1)

			engineApplyShaderToWorldTexture(data.shader_element, texture)

		end


	end)

	addEventHandler('onClientRender', root, function()

		local screenSource = exports.core:getGraphicsElement('screen_source')

		for _, tex_data in pairs( otherTextures ) do

			if tex_data.realtime then

				dxSetShaderValue( tex_data.shader_element, 'sReflectionTexture', screenSource )

			end

		end

	end)

----------------------------------------------------------------------------