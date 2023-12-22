

presses = 0

addEventHandler('onClientKey', root, function(button, state)

	if button == 'space' and state then
		presses = presses + 1
	end

end)

setTimer(function()

	if exports.jobs_main:getPlayerWork(localPlayer) == 'job_diver' then

		if presses > 40 then
			triggerServerEvent('sfd.triggerFlood', resourceRoot, presses)
		end
		
	end

	presses = 0

end, 3000, 0)