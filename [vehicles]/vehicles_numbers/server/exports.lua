
function addFreeNumber(login, type, count)

	local account = getAccount(login)
	local free = fromJSON( account:getData('numbers.free') or '[[]]' ) or {}

	free[type] = (free[type] or 0) + (count or 1)

	if account.player then
		account.player:setData('numbers.free', free)
	else
		account:setData('numbers.free', toJSON(free))
	end

end