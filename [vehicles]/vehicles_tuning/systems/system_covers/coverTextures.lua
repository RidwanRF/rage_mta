
emptyTex = dxCreateTexture(1,1, 'argb')
coverTextures = {
	[1] = dxCreateTexture('assets/textures/env_1.dat'),
}


function updateCoverShaderTextures()
	local texture = getCurrentCoverTexture()
	for _, shader in pairs( getElementsByType('shader', resourceRoot) ) do
		if shader:getData('coverShader') then
			dxSetShaderValue(shader, 'sReflectionTexture', texture )
		end
	end
end

function getCurrentCoverTexture()
	if not localPlayer:getData('settings.reflections') then
		return emptyTex
	end
	return coverTextures[1]
end

local lastInterior = localPlayer.interior
addEventHandler('onClientRender', root, function()

    local frame_start = getTickCount()

	if localPlayer.interior ~= lastInterior then
		updateCoverShaderTextures()
	end
	lastInterior = localPlayer.interior

end)

addEventHandler('onClientElementDataChange', localPlayer, function(dataName, _, value)
	if dataName == 'settings.reflections' then
		updateCoverShaderTextures()
	end
end)