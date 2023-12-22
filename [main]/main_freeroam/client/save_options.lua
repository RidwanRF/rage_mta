local curData = {}

local fileName = 'data.json'

function getSavedData(name)
	return curData[name]
end

local prevDataStr
function saveData()

	local file

	if fileExists(fileName) then
		file = fileOpen(fileName)
	else
		file = fileCreate(fileName)
	end

	local dataStr = toJSON(curData)
	if dataStr ~= prevDataStr then
		prevDataStr = dataStr
		fileWrite(file, dataStr)
	end
	fileClose(file)
end

function loadData()

	local file

	if fileExists(fileName) then
		file = fileOpen(fileName)
	else
		file = fileCreate(fileName)
	end

	local content = fileRead(file, fileGetSize(file))
	curData = fromJSON(content) or {}

	fileClose(file)
end
loadData()

function setData(name, value)
	curData[name] = value
end

setTimer(saveData, 2000, 0)
