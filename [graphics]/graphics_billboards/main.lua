
loadstring( exports.core:include('common'))()

local replace = {

	['Victim_bboard'] = 'bb3',
	['didersachs01'] = 'bb3',
	['heat_04'] = 'bb3',
	['homies_1'] = 'bb3',
	['semi3dirty'] = 'bb3',
	['base5_1'] = 'bb3',
	['bobo_3'] = 'bb3',
	['heat_01'] = 'bb3',
	['eris_5'] = 'bb3',
	['ads003 copy'] = 'bb3',
	['dirtringtex1_256'] = 'bb3',
	['cokopops_2'] = 'bb3',

}

local shaders = {}
local textures = {}

function enableShader()

	for tex_name, bb_id in pairs( replace ) do

		local shader = dxCreateShader('fx/tex_replace.fx', 0, 0, true)

		if not textures[bb_id] then
			textures[bb_id] = dxCreateTexture(('images/%s.png'):format(bb_id), 'argb', true, 'clamp')
		end

		dxSetShaderValue(shader, 'gTexture', textures[bb_id])
		engineApplyShaderToWorldTexture(shader, tex_name)

		table.insert(shaders, shader)

	end
	
end

function disableShader()

	clearTableElements(shaders)
	shaders = {}

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.billboards' then

		if new then
			enableShader()
		else
			disableShader()
		end

	end

end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('settings.billboards') then
		enableShader()
	else
		disableShader()
	end

end)