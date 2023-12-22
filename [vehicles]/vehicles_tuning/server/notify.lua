
function displayError(player, text)
	triggerClientEvent(player, 'tuning.error', player, text)
end

function displayNotify(player, text, color)
	triggerClientEvent(player, 'tuning.notify', player, text, color or {127, 222, 105})
end