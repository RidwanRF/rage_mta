

addEventHandler('onResourceStart', resourceRoot, function()
	for _, data in pairs(Config.tollsMap) do
		local object = createObject(unpack(data))
		object.frozen = true
	end

	local objects = getElementsByType('object', resourceRoot)
	policeTolls = {}
	for _, object in pairs(objects) do
		if object.model == 2933 then

			local x,y,z = getElementPosition(object)

			setElementCollisionsEnabled(object, false)

			local wall = createObject(3571, x,y,z)
			wall.alpha = 0
			attachElements(wall, object, 0, 0, 0, 0, 0, 0)

			policeTolls[object] = {
				object = object,
				x=x, y=y, z=z
			}
		end
	end

	for _, toll in pairs(policeTolls) do
		toll.object:setData('police.toll', true)
	end
end)

function openToll(id)

	local currentToll = policeTolls[id]
	if not currentToll.opened then

		moveObject(currentToll.object,
			2000,
			currentToll.x, currentToll.y, currentToll.z + 5.7,
			0, 0, 0, "OutQuad")

		currentToll.opened = true
		setTimer(closeToll, 2700, 1, id)
	end

end

function closeToll(id)
	local currentToll = policeTolls[id]

	moveObject(currentToll.object,
		2000,
		currentToll.x, currentToll.y, currentToll.z,
		0, 0, 0, "OutBounce")

	setTimer(function(id)
		policeTolls[id].opened = false
	end, 2250, 1, id)
end