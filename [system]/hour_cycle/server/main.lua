addEvent('onServerHourCycle', true)

addEventHandler('onServerHourCycle', root, function()
	outputDebugString(string.format('[HOUR_CYCLE]'))
end)

local hoursHandled = {}

setTimer(function()

	local h = getTime()
	if not hoursHandled[h] then
		hoursHandled[h] = true
		triggerEvent('onServerHourCycle', root)
	end

end, 10000, 0)

addCommandHandler('hour_cycle', function(player)
	if exports.acl:isAdmin(player) then
		triggerEvent('onServerHourCycle', root)
	end
end)