

local log_file_name = ':databases/sfd_cheat_log.log'
local file = fileExists(log_file_name) and fileOpen(log_file_name) or fileCreate(log_file_name)

addEvent('sfd.triggerFlood', true)
addEventHandler('sfd.triggerFlood', resourceRoot, function(presses)

	local time = getRealTime()

	local log_string = (
		'[%02d.%02d.%s %02d:%02d:%02d] PLAYER %s IS SFD CHEATER, %s PRESSSES PER 3 SECONDS\n'
	):format(
		time.monthday, time.month, time.year+1900,
		time.hour, time.minute, time.second,
		client.account.name, presses
	)

	print(getTickCount(  ), log_string)
	fileWrite( file, log_string )
	fileFlush( file )

end)

addEventHandler('onResourceStop', resourceRoot, function()
	fileClose(file)
end)