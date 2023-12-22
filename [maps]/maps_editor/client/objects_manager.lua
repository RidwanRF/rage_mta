
-------------------------------------------------------

	replacedModels = {}

-------------------------------------------------------

	function getReplacedModelData(model)
		return replacedModels[model]
	end

	function replaceModel( model, name, _save )

		replacedModels[model] = { name = name, model = model }
		exports.engine:replaceModel(string.format(':maps_editor/models/%s', name), model)

		if _save ~= false then
			cacheReplacedData()
		end

	end

	function destroyReplacedModel( model, _save )

		exports.engine:engineRestoreModel(model)
		replacedModels[model] = nil

		if _save ~= false then
			cacheReplacedData()
		end

	end

-------------------------------------------------------

	local cacheFileName = 'cached_models.json'

	function cacheReplacedData()

		if fileExists(cacheFileName) then
			fileDelete(cacheFileName)
		end

		local file = fileCreate(cacheFileName)

		fileWrite(file, toJSON(replacedModels))

		fileClose(file)


	end

	function getCachedReplaceData()

		if not fileExists(cacheFileName) then
			return {}
		end

		local file = fileOpen(cacheFileName)
		local content = fileRead( file, file.size )

		fileClose(file)

		return fromJSON(content or '[[]') or {}

	end

-------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		local data = getCachedReplaceData()

		for _, replaceData in pairs( data or {} ) do
			replaceModel( replaceData.model, replaceData.name, false )
		end

	end)

-------------------------------------------------------