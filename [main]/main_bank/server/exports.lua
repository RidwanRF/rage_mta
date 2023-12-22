

function bank_getAccountData(account, name)
	return account:getData('bank.'..name) or 0
end

function bank_giveAccountData(account, data, amount)
	increaseAccountData(account, 'bank.'..data, amount)
end


function getAccountDonate(account)
	return bank_getAccountData(account, 'donate')
end

function getAccountBankMoney(account)
	return bank_getAccountData(account, 'rub')
end

function giveAccountDonate(account, amount)
	return bank_giveAccountData(account, 'donate', amount)
end

function giveAccountBankMoney(account, amount)
	return bank_giveAccountData(account, 'rub', amount)
end

function takeAccountDonate(account, amount)
	return bank_giveAccountData(account, 'donate', -amount)
end

function takeAccountBankMoney(account, amount)
	return bank_giveAccountData(account, 'rub', -amount)
end