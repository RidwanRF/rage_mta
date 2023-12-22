

----------------------------------------------------------------------

	local tuningIconOffset = {0, 0, 8}
	local tuningModel = 1665
	local tuningIconModel = 1548

----------------------------------------------------------------------

	tuningIcons = {}

	function createTuningIcon(object)

		if tuningIcons[object] then return end

		local x,y,z = getElementPosition(object)
		local ox,oy,oz = unpack(tuningIconOffset)

		local icon = createObject( tuningIconModel, x+ox,y+oy,z+oz )

		tuningIcons[object] = { icon = icon }

	end

	function destroyTuningIcon(object)
		clearTableElements(tuningIcons[object])
		tuningIcons[object] = nil
	end

	addEventHandler('onClientRender', root, function()

		for object, data in pairs( tuningIcons ) do

			if isElement(data.icon) then
				local _, _, rz = getElementRotation(data.icon)
				setElementRotation(data.icon, 0, 0, rz+0.5)
			end


		end

	end)

	addEventHandler('onClientElementStreamIn', root, function()
		if source.type == 'object' and source.model == tuningModel and source.dimension == 0 then

			createTuningIcon(source)


		end
	end)

	addEventHandler('onClientElementStreamOut', root, function()

		if tuningIcons[source] then
			destroyTuningIcon(source)
		end

	end)

	addEventHandler('onClientElementDestroy', root, function()

		if tuningIcons[source] then
			destroyTuningIcon(source)
		end

	end)

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, object in pairs( getElementsByType('object', root, true) ) do
			if object.model == tuningModel then
				createTuningIcon(object)
			end
		end

	end)

----------------------------------------------------------------------