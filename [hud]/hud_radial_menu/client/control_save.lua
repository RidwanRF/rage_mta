
function keepCurrentControl()
	currentState = localPlayer.vehicle
		and getPedControlState(localPlayer, 'accelerate')
		or getPedControlState(localPlayer, 'forwards')

	sprintState = getPedControlState(localPlayer, 'sprint')

end

function stopControlKeeping()
	setControlState(localPlayer, localPlayer.vehicle and 'accelerate' or 'forwards', currentState)
	setControlState(localPlayer, 'sprint', sprintState)
end

bindKey('accelerate', 'up', function()
	currentState = false
	setControlState(localPlayer, 'accelerate', false)
end)

bindKey('forwards', 'up', function()
	currentState = false
	setControlState(localPlayer, 'forwards', false)
end)

bindKey('sprint', 'up', function()
	sprintState = false
	setControlState(localPlayer, 'sprint', false)
end)