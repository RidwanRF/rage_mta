
function wheels_updateCoverShaderTextures()
	local texture = wheels_getCurrentCoverTexture()
	for _, shader in pairs( getElementsByType('shader', resourceRoot) ) do
		if shader:getData('wheel_coverShader') then
			dxSetShaderValue(shader, 'sReflectionTexture', texture )
		end
	end
end

function wheels_getCurrentCoverTexture()
	if not localPlayer:getData('settings.wheels_reflections') then
		return emptyTex
	end
	return coverTextures[1]
end

local lastInterior = localPlayer.interior
addEventHandler('onClientRender', root, function()

    local frame_start = getTickCount()

	if localPlayer.interior ~= lastInterior then
		wheels_updateCoverShaderTextures()
	end
	lastInterior = localPlayer.interior

end)

addEventHandler('onClientElementDataChange', localPlayer, function(dataName, _, value)
	if dataName == 'settings.wheels_reflections' then
		wheels_updateCoverShaderTextures()
	end
end)