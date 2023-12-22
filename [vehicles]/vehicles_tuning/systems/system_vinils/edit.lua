
tempVinils = {}
selectedTempVinil = 1

setAnimData('vinils.color', 0.15, 0)

local editStep = 1

local posLimits = Config.vinilEditLimits.pos
posLimits[1] = posLimits[1]*2
posLimits[2] = posLimits[2]*2


------------------------------------------------

	function changeVinilPosition(axis, amount, key)

		local defaultDirection = 'durl'
		local model = localPlayer.vehicle.model

		local direction = Config.editDirectionsOverride[model] or defaultDirection
		local dirstable = string.split(direction, '')

		local axiskeys = {
			['x+'] = {1, 'd'},
			['x-'] = {2, 'u'},
			['y+'] = {3, 'r'},
			['y-'] = {4, 'l'},

			r = {'x', 1},
			l = {'x', -1},
			d = {'y', 1},
			u = {'y', -1},
		}

		local axiskey = string.format('%s%s', axis, amount > 0 and '+' or '-')
		local data = axiskeys[axiskey]
		local override = dirstable[data[1]]

		local c_axis, c_mul = unpack(axiskeys[override])

		if not currentTempVinil then return end
		currentTempVinil[c_axis] = math.clamp(
			currentTempVinil[c_axis] + math.abs(amount)*c_mul,
			unpack(posLimits)
		)

	end

------------------------------------------------

	function changeVinilSize(axis, amount, key)

		local defaultDirection = 'durl'
		local model = localPlayer.vehicle.model

		local direction = Config.editDirectionsOverride[model] or defaultDirection
		local dirstable = string.split(direction, '')

		local axiskeys = {
			['h+'] = {1, 'd'},
			['h-'] = {2, 'u'},
			['w+'] = {3, 'r'},
			['w-'] = {4, 'l'},

			r = {'w', 1, 'x'},
			l = {'w', -1, 'x'},
			d = {'h', 1, 'y'},
			u = {'h', -1, 'y'},
		}

		local axiskey = string.format('%s%s', axis, amount > 0 and '+' or '-')
		local data = axiskeys[axiskey]
		local override = dirstable[data[1]]

		local c_axis, c_mul, c_pos_axis = unpack(axiskeys[override])

		if not currentTempVinil then return end

		local old = currentTempVinil[c_axis]
		currentTempVinil[c_axis] = math.clamp(
			currentTempVinil[c_axis] + math.abs(amount)*c_mul,
			unpack(Config.vinilEditLimits.size)
		)

		local delta = currentTempVinil[c_axis] - old

		currentTempVinil[c_pos_axis] = currentTempVinil[c_pos_axis] - delta/2

	end

------------------------------------------------


local vinilKeys = {
	
	['arrow_r'] = function()
		changeVinilPosition('x', editStep)
	end,
	['arrow_l'] = function()
		changeVinilPosition('x', -editStep)
	end,

	['arrow_u'] = function()
		changeVinilPosition('y', editStep)
	end,
	['arrow_d'] = function()
		changeVinilPosition('y', -editStep)
	end,

	['w'] = function()
		changeVinilSize('h', editStep)
	end,
	['s'] = function()
		changeVinilSize('h', -editStep)
	end,

	['a'] = function()
		changeVinilSize('w', editStep)
	end,
	['d'] = function()
		changeVinilSize('w', -editStep)
	end,

	['z'] = function()
		local w = math.clamp(
			currentTempVinil.w - editStep,
			unpack(Config.vinilEditLimits.size))
		local h = math.clamp(
			currentTempVinil.h - editStep,
			unpack(Config.vinilEditLimits.size))

		local oldw,oldh = currentTempVinil.w, currentTempVinil.h

		currentTempVinil.w = w
		currentTempVinil.h = h

		local deltaw, deltah = currentTempVinil.w - oldw, currentTempVinil.h - oldh

		currentTempVinil.x = currentTempVinil.x - deltaw/2
		currentTempVinil.y = currentTempVinil.y - deltah/2

	end,
	['x'] = function()
		local w = math.clamp(
			currentTempVinil.w + editStep,
			unpack(Config.vinilEditLimits.size))
		local h = math.clamp(
			currentTempVinil.h + editStep,
			unpack(Config.vinilEditLimits.size))

		local oldw,oldh = currentTempVinil.w, currentTempVinil.h

		currentTempVinil.w = w
		currentTempVinil.h = h

		local deltaw, deltah = currentTempVinil.w - oldw, currentTempVinil.h - oldh

		currentTempVinil.x = currentTempVinil.x - deltaw/2
		currentTempVinil.y = currentTempVinil.y - deltah/2
	end,

	['q'] = function()
		currentTempVinil.r = currentTempVinil.r - editStep
	end,
	['e'] = function()
		currentTempVinil.r = currentTempVinil.r + editStep
	end,
}

local pressedButtons = {}
addEventHandler('onClientKey', root, function(button, state)

	if not windowOpened then return end
	if currentWindowSection ~= 'vinil_edit' then return end
	if getKeyState('lctrl') then return end

	pressedButtons[button] = state

	if not state then
		if button == 'c' then
			animate('vinils.color',
				1 - getAnimData('vinils.color')
			)
		elseif button == 'delete' then
			removeTempVinil(selectedTempVinil)
		end
	end

	cancelEvent()

end)

local lastRender = getTickCount()
addEventHandler('onClientRender', root, function()

	if not windowOpened then return end

	if (getTickCount() - lastRender) < Config.vinilEditSensitiveFrequency then
		return
	end

	local needMove = false

	editStep = pressedButtons['lshift'] and 3 or 1

	for buttonName, state in pairs( pressedButtons ) do

		if state then
			local action = vinilKeys[buttonName]
			if action then
				currentTempVinil = tempVinils[selectedTempVinil]
				action()
				needMove = true
			end
		end

	end

	if needMove then updateTempVinil() end

	lastRender = getTickCount()

end)

function addTempVinil(eData, id)

	local mul = Config.vinilBrightness

	local data = type(eData) == 'table' and eData or {
	    x = 257,
	    y = 1033,
		-- x = Config.vinilRTSize.x / 2 - 512/2,
		-- y = Config.vinilRTSize.y / 2 - 512/2,
		w = 512,
		h = 512,
		r = 90,
		path = eData,
		color = {255*mul,255*mul,255*mul},
	}

	if type(eData) == 'string' and Config.vinilsAssoc[eData].cover then
		data.x = 0
		data.y = 0
		data.r = 0
		data.w = Config.vinilRTSize.x
		data.h = Config.vinilRTSize.y
	end

	data.id = id

	table.insert(tempVinils, data)

	selectedTempVinil = #tempVinils

	updateTempVinil()

end

function removeTempVinil(id)

	local data = tempVinils[id]

	table.remove(tempVinils, id)

	if selectedTempVinil > #tempVinils then
		selectedTempVinil = #tempVinils
	end

	if selectedTempVinil == 0 then
		clearTempVinils()
		changeWindowSection('vinils')
		return
	end

	updateTempVinil()
end

function clearTempVinils()

	for _, vinil in pairs( tempVinils ) do
		if isElement(vinil.texture) then
			destroyElement(vinil.texture)
		end
	end

	if isElement(tempVinilRenderTarget) then
		destroyElement(tempVinilRenderTarget)
	end
	tempVinilRenderTarget = nil

	tempVinils = {}

	selectedTempVinil = 1

	-- updateTempVinil()
	setPaintJobTexture(localPlayer.vehicle, 'noChange', 'noTexture')
end

function updateTempVinil()

	if not windowOpened then return end
	if currentWindowSection ~= 'vinil_edit' then return end

	tempVinilRenderTarget = tempVinilRenderTarget or dxCreateRenderTarget(
		Config.vinilRTSize.x,
		Config.vinilRTSize.y, true
	)

	dxSetRenderTarget(tempVinilRenderTarget, true)

		-- mta_dxDrawRectangle(
		-- 	0, 0,
		-- 	Config.vinilRTSize.x,
		-- 	Config.vinilRTSize.y,
		-- 	tocolor(255,255,255,255)
		-- )

		for index, data in pairs( tempVinils ) do

			local r,g,b = unpack(data.color or {255,255,255})
			drawVinil(data, true)

		end

	dxSetRenderTarget()

	setPaintJobTexture(localPlayer.vehicle, 'noChange', tempVinilRenderTarget)
end

function updateTempVinilColor(r,g,b)
    local currentTempVinil = tempVinils[selectedTempVinil]
    currentTempVinil.color = {r,g,b}
    updateTempVinil()
end

addEventHandler('onClientRestore', root, function()

	if not windowOpened then return end
	if currentWindowSection ~= 'vinil_edit' then return end

	setTimer(updateTempVinil, 100, 1)

end)