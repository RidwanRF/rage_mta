
currentObjects = {}

function removePlayerCustomObject(player)

	if isElement(currentObjects[player]) then
		destroyElement(currentObjects[player])
	end

	currentObjects[player] = nil

end

function setPlayerCustomObject(player, config)

	removePlayerCustomObject(player)

	local object = createObject(config.model, 0, 0, 0)
	object.scale = config.objScale or 1

	player:setData('hands.object', object)

	currentObjects[player] = object

	exports.bone_attach:attachElementToBone(object, player, 12, unpack(config.offsets or {}))

end

addEventHandler('onPlayerQuit', root, function()
	removePlayerCustomObject(source)
end)

addEventHandler('onElementDestroy', root, function()
	removePlayerCustomObject(source)
end)