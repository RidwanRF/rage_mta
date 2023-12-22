
previewConfig = {
	ped = { -2664.32, 1371.64, 55.81, -0, 0, 182.82 },
	matrix = { -2664.03, 1369.48, 56.35, -2646.71, 1467.47, 46.39, 0, 70 },
	player = { -2665.14, 1348.54, 55.81, },
}

function createPreview()

	currentPed = createPed(0, 0, 0, 3)

	local x,y,z, rx,ry,rz = unpack(previewConfig.ped)
	setElementPosition(currentPed, x,y,z)
	setElementRotation(currentPed, rx,ry,rz)

	currentPed.dimension = 1

	local px,py,pz = getElementPosition(localPlayer)
	lastPlayerPosition = {px,py,pz}

	local x,y,z = unpack(previewConfig.player)
	setElementPosition(localPlayer, x,y,z)

	localPlayer.dimension = 1

	setCameraMatrix(unpack(previewConfig.matrix))

end

function finishPreview()

	setCameraTarget(localPlayer, localPlayer)
	destroyElement(currentPed)

	local x,y,z = unpack(lastPlayerPosition or {0, 0, 3})
	setElementPosition(localPlayer, x,y,z)
	localPlayer.dimension = 0
end

function setPreviewModel(model)
	currentPed.model = model
end