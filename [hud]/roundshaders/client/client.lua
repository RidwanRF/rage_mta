
local shaders = {
	mask=dxCreateShader('assets/shaders/mask.fx'),
	line=dxCreateShader('assets/shaders/line.fx'),
	line_mirror=dxCreateShader('assets/shaders/line_mirror.fx'),
}

function getShader(name)
	return shaders[name]
end