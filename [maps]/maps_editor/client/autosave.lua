

setTimer(function()

	local realTime = getRealTime()

	saveMap( string.format('%s-%02d-%02d_%02d-%02d-%02d',
		realTime.year + 1900, realTime.month + 1, realTime.monthday,
		realTime.hour, realTime.minute, realTime.second
	), 'autosave/' )

	-- debug:info('Автосохранение')

end, 1*60*1000, 0)