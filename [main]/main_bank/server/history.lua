function appendPlayerHistory(player, name, sum)

	local history = player:getData('bank.history') or {}
	local realTime = getRealTime()

	local d,m,y = realTime.monthday, realTime.month+1, realTime.year+1900
	local hour = realTime.hour
	local minute = realTime.minute

	if #history > 5 then
		table.remove(history, 1)
	end

	table.insert(history, {
		name = name,
		sum = sum,
		date = string.format('%02d.%02d.%s %02d:%02d',
			d,m,y,hour,minute
		)	
	})

	player:setData('bank.history', history)
end

function appendAccountHistory(account, name, sum)

	local history = fromJSON(account:getData('bank.history') or '[[]]') or {}
	local realTime = getRealTime()

	local d,m,y = realTime.monthday, realTime.month+1, realTime.year+1900
	local hour = realTime.hour
	local minute = realTime.minute

	if #history > 5 then
		table.remove(history, 1)
	end

	table.insert(history, {
		name = name,
		sum = sum,
		date = string.format('%02d.%02d.%s %02d:%02d',
			d,m,y,hour,minute
		)	
	})

	account:setData('bank.history', toJSON(history))
end