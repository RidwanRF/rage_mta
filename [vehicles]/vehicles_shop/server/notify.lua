
function displayError(player, text)
	triggerClientEvent(player, 'carshop.error', player, text)
end

function displayNotify(player, text, color)
	triggerClientEvent(player, 'carshop.notify', player, text, color or {127, 222, 105})
end