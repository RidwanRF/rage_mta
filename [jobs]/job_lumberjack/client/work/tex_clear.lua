

----------------------------------------------------------------

	local shader = dxCreateShader('assets/shaders/clear.fx')

----------------------------------------------------------------

	function clearObjectTexture( object, texture )
		engineApplyShaderToWorldTexture( shader, texture, object )
	end

----------------------------------------------------------------