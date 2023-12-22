
function createInterior(dimension)
	local x,y,z,r = unpack(Config.interior.object)
	interiorObject = createObject(1665, x,y,z, 0, 0, r)
	-- interiorObject = createObject(3571, x,y,z, 0, 0, r)
	interiorObject.interior = Config.interior.interior
	interiorObject.dimension = dimension

end

function handleCreateInterior(dataName, old, new)

	if dataName == 'dynamic.id' then

		createInterior(new)
		removeEventHandler('onClientElementDataChange', localPlayer, handleCreateInterior)
	end


end

addEventHandler('onClientElementDataChange', localPlayer, handleCreateInterior)

addEventHandler('onClientResourceStart', resourceRoot, function()
	local dynamicId = localPlayer:getData('dynamic.id')
	if dynamicId then
		handleCreateInterior('dynamic.id', _, dynamicId)
	end
end)