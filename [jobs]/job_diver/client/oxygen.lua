

addEvent('diver.catchOxygen', true)
addEventHandler('diver.catchOxygen', resourceRoot, function(amount)
	localPlayer:setData('diver.oxygen', amount, false)
end)