
---------------------------------------------
	
	local offsets = {}

---------------------------------------------

	local dataFile_name = 'cached_azo.json'

	local function loadDataFromFile()

		if fileExists(dataFile_name) then
			local file = fileOpen(dataFile_name)
			local content = file:read(file.size)

			local data = fromJSON(content or '[[]]') or {}
			for model, value in pairs(data) do
				offsets[tonumber(model)] = value
			end

			fileClose(file)

		end

	end

	local function writeDataToFile()

		if fileExists(dataFile_name) then
			fileDelete(dataFile_name)
		end

		local file = fileCreate(dataFile_name)
		fileWrite(file, toJSON(offsets))

		fileClose(file)

	end

	setTimer(writeDataToFile, 2000, 0)

---------------------------------------------

	function setModelAxisOffset( objectOrModel, offset )

		local model = tonumber(isElement(objectOrModel) and objectOrModel.model or objectOrModel)
		if type(model) ~= 'number' then return end

		offsets[model] = offset

	end

	function getModelAxisOffset( objectOrModel )

		local model = tonumber(isElement(objectOrModel) and objectOrModel.model or objectOrModel)
		if type(model) ~= 'number' then return end

		return offsets[model] or 0

	end

---------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, loadDataFromFile)

---------------------------------------------