
paintJobTextures = {}

local function getColorTexture(r, g, b, a)
    local texture = dxCreateTexture(1, 1, "argb")
    local pixels = string.char(0, 0, 0, 0, 1, 0, 1, 0)
    dxSetPixelColor(pixels, 0, 0, r, g, b, a)
    texture:setPixels(pixels)
    return texture
end

whiteTex = getColorTexture(0, 0, 0, 0)

function setPaintJobTexture(vehicle, eTexture, temp_ETexture)

	local texture

	if eTexture ~= 'noChange' then
		if isElement(eTexture) or eTexture == 'noTexture' then
			if eTexture == 'noTexture' then
				texture = whiteTex
			else
				texture = eTexture
			end
			paintJobTextures[vehicle] = texture
			if coverShaders[vehicle] and isElement(coverShaders[vehicle][1]) then
				if eTexture == 'noTexture' then
					dxSetShaderValue(coverShaders[vehicle][1], 'paintJobTexture', whiteTex)
				else
					dxSetShaderValue(coverShaders[vehicle][1], 'paintJobTexture', texture)
				end
			end
		else
			paintJobTextures[vehicle] = nil
		end
	end


	if not temp_ETexture then
		texture = whiteTex
	else
		texture = temp_ETexture
	end

	if coverShaders[vehicle] and isElement(coverShaders[vehicle][1]) then
		if temp_ETexture == 'noTexture' then
			dxSetShaderValue(coverShaders[vehicle][1], 'temp_paintJobTexture', whiteTex)
		else
			dxSetShaderValue(coverShaders[vehicle][1], 'temp_paintJobTexture', texture)
		end
	end

end