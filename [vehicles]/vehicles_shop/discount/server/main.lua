

local fileName = ':databases/vehicles_discounts.json'

function loadFile()

	if fileExists(fileName) then
		local file = fileOpen(fileName)
		local content = fileRead(file, file.size)
		fileClose(file)
		return fromJSON(content or '') or {}
	end

	return {}

end

function writeFile(content)

	if fileExists(fileName) then
		fileDelete(fileName)
	end

	local file = fileCreate(fileName)
	fileWrite( file, toJSON(content) )
	fileClose(file)

end

function addDiscount(model, discount, hours)
	local data = loadFile()

	data[tostring(model)] = { 
		discount = tonumber(discount) or 0,
		finish = getRealTime().timestamp + (tonumber(hours) or 0) * 3600,
		timeToFinish = math.round( (tonumber(hours) or 0) ),
	}

	resourceRoot:setData('vehicles.discount', data)
	writeFile(data)
end

addCommandHandler('adddiscount', function(player, _, model, discount, hours)
	if exports['acl']:isAdmin(player) then
		addDiscount(model, discount, hours)
	end
end)

setTimer(function()

	local discountModels = loadFile()

	local timestamp = getRealTime().timestamp

	for model, data in pairs( discountModels ) do
		if data.finish < timestamp then
			discountModels[model] = nil
		else
			discountModels[model].timeToFinish = 
				math.round( (discountModels[model].finish - timestamp) / 3600 )
		end
	end

	resourceRoot:setData('vehicles.discount', discountModels)
	writeFile(discountModels)

end, 15000, 0)

addEventHandler('onResourceStart', resourceRoot, function()

	resourceRoot:setData('vehicles.discount', loadFile() or {})

end)