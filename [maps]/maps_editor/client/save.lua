
------------------------------------------------------------

	function gui_saveMap( fileName )
		local content, kb = saveMap( fileName )
		debug:info(string.format('Сохранено (%s KB)', kb))
	end

	function getMapContent(json)

		local map_table, content = {}, ''

		for _, element in pairs( map ) do

			local x,y,z = getElementPosition(element.object)
			local rx,ry,rz = getElementRotation(element.object)
			local sx,sy,sz = getObjectScale(element.object)

			local _element = {
				model = element.object.model,
				x=x,y=y,z=z,
				rx=rx,ry=ry,rz=rz,
				scale = {sx,sy,sz},
				lod = element.lod and element.lod.model or nil,
				col = element.object:getCollisionsEnabled(),
				created = element.created,
			}

			table.insert(map_table, _element)

		end

		return (json ~= false) and toJSON(map_table, true) or map_table

	end

	function saveMap( fileName, dir )

		local content = getMapContent()

		local kb
		if fileName then

			if fileName:sub(-4) ~= '.map' then
				fileName = fileName .. '.map'
			end

			dir = dir or 'saves/'
			fileName = dir..fileName

			if fileExists( fileName ) then
				fileDelete( fileName )
			end


			local file = fileCreate( fileName )
			fileWrite(file, content)

			kb = math.ceil( fileGetSize( file ) / 1024 )

			fileClose(file)
			
		end

		return content, kb

	end

------------------------------------------------------------

	function gui_loadMap( fileName )
		local map_table = loadMap( fileName )
		if map_table then
			debug:info(string.format('Карта загружена (%s объектов)', getTableLength(map_table)))
			-- saveTempMap()
		end
	end

	function loadMap( fileName )

		local content = ''

		if fromJSON( fileName ) then
			content = fileName
		else
			if fileName:sub(-4) ~= '.map' then
				fileName = fileName .. '.map'
			end

			fileName = 'saves/'..fileName

			if not fileExists( fileName ) then
				return debug:error('Файл не найден')
			end

			local file = fileOpen( fileName )
			content = fileRead( file, file.size )

			fileClose(file)
		end

		local map_table = fromJSON( content )

		for _, object in pairs(map_table) do
			EditorObject(object)
		end

		return map_table


	end

------------------------------------------------------------

	function unloadMap()
		for _, object in pairs( map ) do
			object:destroy()
		end
	end

------------------------------------------------------------

	addCommandHandler('me_loadmap', function(_, fileName)

		if exports.core:isAdmin(localPlayer) then
			gui_loadMap(fileName)
		end

	end)

------------------------------------------------------------
