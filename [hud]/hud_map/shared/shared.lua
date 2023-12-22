
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

function getPlayerTax(player)
end

function getPlayerWithdraws(player)
end