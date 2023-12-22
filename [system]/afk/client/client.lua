
afkConfig = {
	afkTime = 5*60*1000,
}

local lastActive = getTickCount()

addEventHandler('onClientKey', root, function()
	lastActive = getTickCount()

	if localPlayer:getData('isAFK') then
		updateAFKStatus()
	end

end)

function isPlayerAFK()
	local isActive = (getTickCount() - lastActive) < afkConfig.afkTime
	local speed = getElementSpeed(localPlayer.vehicle or localPlayer, 'kmh')
	return (isActive or speed > 5)
end

function updateAFKStatus(state)
	
	local curState = false
	-- local curState = localPlayer:getData('isAFK') or false

	if localPlayer.dimension ~= 0 then
		state = false
	end

	if curState ~= state then
		localPlayer:setData('isAFK', state)
	end
end

setTimer(function()
	updateAFKStatus( not isPlayerAFK() )
end, 3000, 0)

addEventHandler('onClientResourceStart', resourceRoot, function()
	localPlayer:setData('isAFK', false)
end)

