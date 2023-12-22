
local texturesimg = {
	{"img/off.bmp", "vehiclelights128"},
	{"img/on.bmp", "vehiclelightson128"},
}

addEventHandler("onClientResourceStart", resourceRoot, function()
  -- upvalues: texturesimg
  for i = 1, #texturesimg do
    local shader = dxCreateShader("chaticon.fx")
    engineApplyShaderToWorldTexture(shader, texturesimg[i][2])
    dxSetShaderValue(shader, "gTexture", dxCreateTexture(texturesimg[i][1]))
  end
end
)




