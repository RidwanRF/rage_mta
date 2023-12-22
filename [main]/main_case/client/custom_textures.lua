
------------------------------------------

	shaders = {}

	addEventHandler('onClientResourceStart', resourceRoot, function()

		local index = 1

		while true do

			local filepath = ('assets/textures/%s.png'):format(index)

			if fileExists(filepath) then

				local shader = dxCreateShader('assets/shaders/texreplace.fx', 0, 0, true)
				local texture = dxCreateTexture(filepath)

				shaders[index] = shader

				dxSetShaderValue(shader, 'gTexture', texture)

				index = index + 1

			else
				break
			end


		end

	end)

------------------------------------------

	function updateCaseTexture(case)

		local ped = exports.bone_attach:getElementBoneAttachmentDetails( case )

		if isElement(ped) then

			local case_id = ped:getData('custom_case.id')

			for _, shader in pairs( shaders ) do
				engineRemoveShaderFromWorldTexture(shader, 'IdMap', case)
			end

			if case_id and isElement(shaders[case_id]) then

				engineApplyShaderToWorldTexture(shaders[case_id], 'IdMap', case)

			end

		end

	end

------------------------------------------

	local inventory_root = getResourceRoot('main_inventory')

	addEventHandler('onClientElementStreamIn', inventory_root, function()
		if source.model == 1210 then
			updateCaseTexture(source)
		end
	end)

	addEventHandler('onClientElementDataChange', root, function(dn, old, new)
		if dn == 'custom_case.id' then

			local object = source:getData('hands.object')

			if isElement(object) and object.model == 1210 then
				updateCaseTexture(object)
			end

		end
	end)

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, object in pairs( getElementsByType('object', inventory_root, true) ) do

			if object.model == 1210 then
				updateCaseTexture(object)
			end

		end

	end)

------------------------------------------