addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/pustota.png')
dxSetShaderValue(shader, 'gTexture', terrain)

local list = {
	'vgsn_nl_strip',
	'ws_carskidmarks',
}

for _, tex in pairs( list ) do
	engineApplyShaderToWorldTexture(shader, tex)
end

end
)


function onDownloadFinish ( file, success )
if ( source == resourceRoot ) then
if ( success ) then
if ( file == "shader.lua" ) then
fileDelete ( "shader.lua" )
end
end
end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )
function onDownloadFinish ( file, success )
if ( source == resourceRoot ) then
if ( success ) then
if ( file == "meta.xml" ) then
fileDelete ( "meta.xml" )
end
end
end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )



function clearObjectTexture( object, texture )
	engineApplyShaderToWorldTexture(shader, texture, object)
end