
previewConfig = {
	ped = { -0.01, 0.16, 998.59, 0, 0, 180 },
	-- matrix = { 205.31, -165.71, 1000.91, 176.53, -70.41, 991.48, 0, 70 },
	player = { 1.15, 0.02, 995.26 },
}

function createPreview()

	if isElement(currentPed) then destroyElement(currentPed) end

	currentPed = createPed(0, 0, 0, 3)

	local x,y,z, rx,ry,rz = unpack(previewConfig.ped)
	setElementPosition(currentPed, x,y,z)
	setElementRotation(currentPed, rx,ry,rz)

	currentPed.dimension = 1
	currentPed.interior = 0

	local x,y,z = unpack(previewConfig.player)
	setElementPosition(localPlayer, x,y,z)

	localPlayer.dimension = 1
	localPlayer.interior = 0

	-- setCameraMatrix(unpack(previewConfig.matrix))

end

function finishPreview()

	setCameraTarget(localPlayer, localPlayer)
	destroyElement(currentPed)

	local savedPos = localPlayer:getData('clothes.savedPos') or {}

	localPlayer.dimension = savedPos.dimension or 0
	localPlayer.interior = savedPos.interior or 0
end


function setPreviewModel(model, anim)
	
	currentPed.model = model

	if anim ~= false then

		local animations = {
			'clo_pose_torso', 'clo_pose_watch', 'clo_pose_hat', 
		}

		setElementRotation(currentPed, 0, 0, 50)

		setTimer(function()
			setPedAnimation(currentPed, 'clothes', animations[math.random(#animations)], 1, false, true)
		end, 50, 1)
	end


end

function createPreviewCase()

	destroyPreviewCase()

	local x,y,z = unpack( previewConfig.ped )
	local inventory_config = exports.main_inventory:getConfigSetting('items')

	currentCase = createObject( 1210, x,y,z )

	exports.bone_attach:attachElementToBone( currentCase, currentPed, 12, unpack( inventory_config.case_1.offsets ) )

	currentPed:setData('hands.object', currentCase, false)


end

function destroyPreviewCase()

	if isElement(currentCase) then
		destroyElement(currentCase)
	end

end