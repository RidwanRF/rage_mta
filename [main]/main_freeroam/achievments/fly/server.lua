

function receiveFly(amount)
	increaseElementData(client, 'vehicle_fly', amount, false)
end
addEvent('main_freeroam.ach.receiveFly', true)
addEventHandler('main_freeroam.ach.receiveFly', resourceRoot, receiveFly)