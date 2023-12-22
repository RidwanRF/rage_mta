
------------------------------------

	local mapModules = {}

------------------------------------

	function loadMapObject(data, mapModule, dimension)

		-- local object = createObject(data.model, data.x, data.y, 270, data.rx, data.ry, data.rz)
		local object = createObject(data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz)
		object.dimension = dimension or 0

		if type(data.scale) == 'number' then
			setObjectScale( object, data.scale )
		else
			setObjectScale( object, unpack(data.scale or {1,1,1} )  )
		end

		if data.col ~= nil then
			object:setCollisionsEnabled(data.col)
		end

		local lod

		if data.lod and data.lod ~= data.model then

			lod = createObject(data.lod, data.x, data.y, data.z, data.rx, data.ry, data.rz, true)
			lod.dimension = dimension or 0

			setLowLODElement(object, lod)

		end

		mapModule[object] = { object = object, lod = lod, }

	end


	function loadMap( fileName, dimension )

		if fileName:sub(-4) ~= '.map' then
			fileName = fileName .. '.map'
		end

		if not fileExists( fileName ) then
			return
		end

		local file = fileOpen( fileName )
		local content = fileRead( file, file.size )

		mapModules[fileName] = {}

		fileClose(file)

		local map_table = fromJSON( content )

		for _, object in pairs(map_table) do
			loadMapObject(object, mapModules[fileName], dimension)
		end

	end

	function unloadMap( fileName )

		if fileName:sub(-4) ~= '.map' then
			fileName = fileName .. '.map'
		end

		local mapModule = mapModules[fileName]
		if not mapModule then
			return
		end

		clearTableElements( mapModule )
		mapModules[fileName] = nil

	end

------------------------------------

	local modules_filePath = 'maps/modules.json'

	function getModulesFileData()

		if fileExists(modules_filePath) then

			local commitsFile = fileOpen(modules_filePath)

			if commitsFile then

				local content = fromJSON( commitsFile:read( commitsFile.size ) or '[[]]' )  or {}

				fileClose(commitsFile)

				return content

			end

			return {}

		end

		return {}

	end

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, map in pairs( Config.map_modules ) do
			for dimension = 0, 1 do
				loadMap( map.path, dimension )
			end
		end

		local data = getModulesFileData()

		for fileName in pairs( data ) do
			for dimension = 0, 1 do
				loadMap( fileName, dimension )
			end
		end


	end)

------------------------------------

	addCommandHandler('maps_load_module', function(player, _, path)
		if exports.acl:isAdmin(player) then
			loadMap( path )
		end
	end)

	addCommandHandler('maps_unload_module', function(player, _, path)
		if exports.acl:isAdmin(player) then
			unloadMap( path )
		end
	end)

------------------------------------
	
	function commitMapModule(module_name, json)

		local fileName = string.format('maps/%s_%s', client.account.name, module_name)

		if fileName:sub(-4) ~= '.map' then
			fileName = fileName .. '.map'
		end

		if fileExists( fileName ) then
			fileDelete( fileName )
		end

		local file = fileCreate(fileName)
		fileWrite(file, json)
		fileClose(file)

		if mapModules[fileName] then
			unloadMap(fileName)
		end

		loadMap(fileName)

		local data = getModulesFileData() or {}
		data[fileName] = true

		local commitsFile = fileExists(modules_filePath) and fileOpen(modules_filePath) or fileCreate(modules_filePath)
		fileWrite(commitsFile, toJSON(data))
		fileClose(commitsFile)

		outputDebugString(string.format('[MAP][MODULE] %s commited %s',
			client.account.name, module_name
		))

	end
	addEvent('map.commit_module', true)
	addEventHandler('map.commit_module', resourceRoot, commitMapModule)

------------------------------------

