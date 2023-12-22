
local startX, startY = -3000, 3000
local endX, endY = 3000, -3000

local offsetX, offsetY = 0,0

local rSize = 3000

local neededX, neededY = rSize, rSize
local stepX, stepY =
	math.abs(startX - endX)/neededX, 
	math.abs(startY - endY)/neededY

local fileName = 'map.txt'

function startMapRender()

	local file
	if fileExists(fileName) then

		file = fileOpen(fileName)

		if file.size > 0 then
			fileSetPos(file, math.max(file.size - 500, 0))

			local content = fileRead(file, 500)
			local str = splitString(content, '\n')
			local data = splitString(str[#str-1], ' ')

			offsetX, offsetY = tonumber(data[1]), tonumber(data[2])
		end

	end

	renderFile = file or fileCreate(fileName)
	mapScreen = dxCreateScreenSource(1,1)

	imageX, imageY = offsetX, offsetY
	currentX, currentY = startX + offsetX*stepX, startY - offsetY*stepY

	setCameraMatrix(currentX, currentY, 600, currentX, currentY, 0)
	resetGraphics()
	

	setTimer(function()
		addEventHandler('onClientRender', root, doMapShot)
	end, 5000, 1)

end

function finishMapRender()
	fileClose(renderFile)
	removeEventHandler('onClientRender', root, doMapShot)
	-- createMapRender()
end

function doMapShot()

	setCameraMatrix(currentX, currentY, 600, currentX, currentY, 0)
	dxUpdateScreenSource(mapScreen)

	currentX = currentX + stepX
	imageX = imageX + 1

	if currentX >= endX then
		currentX = startX
		currentY = currentY - stepY

		imageX = 0
		imageY = imageY + 1

		if currentY <= endY then
			finishMapRender()
		end

	end

	local pixels = dxGetTexturePixels(mapScreen)
	local r,g,b = dxGetPixelColor(pixels, 0, 0)

	if isElement(renderFile) then
		fileWrite(renderFile, string.format('%s %s %s %s %s\n',
			imageX, imageY, r,g,b
		))
	end
	resetGraphics()

	print(getTickCount(  ), currentX, currentY)
end

function resetGraphics()
	setTime(4, 0)
	setFogDistance(2900)
	setFarClipDistance(3000)
	setCloudsEnabled(false)
	setWaterColor(200, 200, 255, 230)
	setWeather(0)
	setWaveHeight(0)
end


function createMapRender()

	local texture = dxCreateTexture(neededX, neededY)
	local pixels = dxGetTexturePixels(texture)

	local file = fileOpen(fileName)
	local content = fileRead(file, fileGetSize(file))
	fileClose(file)

	local lines = splitString(content, '\n')
	for _, line in pairs(lines) do
		local x,y, r,g,b = unpack( splitString(line, ' ') )

		if x and y then
			dxSetPixelColor(pixels,
				tonumber(x),
				tonumber(y),
				tonumber(r),
				tonumber(g),
				tonumber(b)
			)
		end


	end

	local result = dxConvertPixels(pixels, 'png')

	local file = fileCreate('map.png')
	fileWrite(file, result)
	fileClose(file)

end

addCommandHandler('startmaprender', function()
	startMapRender()
end)
addCommandHandler('stopmaprender', function()
	finishMapRender()
	setCameraTarget(localPlayer, localPlayer)
end)