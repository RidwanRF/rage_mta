
function getPlayerDonate(player)
	return player:getData('bank.donate') or 0
end

function givePlayerDonate(player, amount)
	local donate = getPlayerDonate(player)
	return player:setData('bank.donate', donate + amount)
end

function takePlayerDonate(player, amount)
	return givePlayerDonate(player, -amount)
end

function getPlayerBankMoney(player)
	return player:getData('bank.rub') or 0
end

function givePlayerBankMoney(player, amount)
	local bank = getPlayerBankMoney(player)
	return player:setData('bank.rub',bank + amount)
end

function takePlayerBankMoney(player, amount)
	return givePlayerBankMoney(player, -amount)
end

function getPlayerByCardNumber(cardNumber)
	for _, player in pairs( getElementsByType('player') ) do
		if player:getData('bank.card') == cardNumber then
			return player
		end
	end
	return false
end

function getPlayerWithdraws(player, types)
	
	if type(types) == 'string' then
		return getPlayerWithdraws(player, {[types]=true})
	end

	local withdraws = player:getData('bank.withdraws') or {}
	local sum = 0

	for _, withdraw in pairs(withdraws) do
		if not types or types[withdraw.id] then
			sum = sum + withdraw.sum
		end
	end

	return sum
end

function getTax(playerOrAccount, types)

	local account
	if getElementType(playerOrAccount) == 'player' then
		account = playerOrAccount.account
	else
		account = playerOrAccount
	end

	local withdraws = player:getData('bank.withdraws') or {}
	local sum = 0

	for _, withdraw in pairs(withdraws) do
		if not types or types[withdraw.type] then
			sum = sum + withdraw.sum
		end
	end

	return sum
end