
local componentPositions = {}
local componentRotations = {}

function saveComponentPosition(v, name)
    local model = getElementModel(v)
    if componentPositions[model] and componentPositions[model][name] then
    	return componentPositions[model][name]
	end
    resetVehicleComponentPosition(v, name)
    componentPositions[model] = componentPositions[model] or {}
    componentPositions[model][name] = {getVehicleComponentPosition(v, name)}
    return componentPositions[model][name]
end

function saveComponentRotation(v, name)
    local model = getElementModel(v)
    if componentRotations[model] and componentRotations[model][name] then
    	return componentRotations[model][name]
	end
    resetVehicleComponentRotation(v, name)
    componentRotations[model] = componentRotations[model] or {}
    componentRotations[model][name] = {getVehicleComponentRotation(v, name)}
    return componentRotations[model][name]
end

defaultSpeed = 1500
function handleMovpart(v, step, model)
	local curTime
	curTime = (transformData[model] or defaultSpeed)*step

	local deltaposX, deltaposY, deltaposZ,
		deltarotX, deltarotY, deltarotZ, mStep

	local x,y,z, rx,ry,rz
	local nextParams, progress

	for partName, partDataList in pairs(animationsData[model]['components']) do
		for k, partData in pairs(partDataList) do

			if curTime > partData['time'] then
				nextParams = partDataList[k+1] or partData
				progress = (curTime - partData['time']) / (nextParams['time'] - partData['time'])

				local x,y,z = interpolateBetween(
					partData['params'][1], partData['params'][2], partData['params'][3],
					nextParams['params'][1], nextParams['params'][2], nextParams['params'][3],
					progress,
					partData['easing'] or 'Linear'
				)

				local rx,ry,rz = interpolateBetween(
					partData['params'][4], partData['params'][5], partData['params'][6],
					nextParams['params'][4], nextParams['params'][5], nextParams['params'][6],
					progress,
					partData['easing'] or 'Linear'
				)

				setVehicleComponentPosition(v, partName, x,y,z)
				setVehicleComponentRotation(v, partName, rx,ry,rz)
			end

		end
	end
end

transformData = {
	[436]=6500,
	[490]=4000,
}