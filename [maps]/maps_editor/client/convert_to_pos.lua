

addCommandHandler('me_convert_to_pos', function(_, model)

	local map = getMapContent(false)

	table.sort(map, function(a,b)
		return (a.created or 0) < (b.created or 0)
	end)

	local result = '{\n'

	for _, object in pairs( map ) do

		if not tonumber(model) or object.model == tonumber(model) then
			result = result .. string.format('	{ %s, %s, %s, %s, },\n',
				math.round(object.x, 2),
				math.round(object.y, 2),
				math.round(object.z, 2),
				math.round(object.rz, 2)
			)
		end

	end

	result = result .. '\n}'

	setClipboard(result)

	debug:info(string.format('Сконвертировано в буфер обмена'))

end)

addCommandHandler('me_convert_to_map', function()

	local map = getMapContent(false)

	table.sort(map, function(a,b)
		return (a.created or 0) < (b.created or 0)
	end)

	local result = '{\n'

	for _, object in pairs( map ) do

		result = result .. string.format('	{ model = %s, x = %s, y = %s, z = %s, rx = %s, ry = %s, rz = %s },\n',
			object.model,
			math.round(object.x, 2),
			math.round(object.y, 2),
			math.round(object.z, 2),
			math.round(object.rx, 2),
			math.round(object.ry, 2),
			math.round(object.rz, 2)
		)

	end

	result = result .. '\n}'

	setClipboard(result)

	debug:info(string.format('Сконвертировано в буфер обмена'))

end)