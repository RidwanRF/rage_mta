
-----------------------------------------------------------------------------------------------

	-- addEventHandler('onPlayerLogin', root, function()
	-- 	source:setData('login.timestamp', getRealTime().timestamp, false)
	-- end)

	-- addEventHandler('onPlayerQuit', root, function()
	-- 	local enterTimestamp = source:getData('login.timestamp')
	-- 	if not enterTimestamp then return end

	-- 	local timestamp = getRealTime().timestamp

	-- 	local money = exports.money:getPlayerMoney(source)
	-- 	local bank = exports.main_bank:getPlayerBankMoney(source)
	-- 	local donate = exports.main_bank:getPlayerDonate(source)
	-- 	local version = exports.main_navigation:getConfigSetting('currentVersion') or '1.0'

	-- 	trackAction({
	-- 		[source.account.name] = {
	-- 			['gs'] = {
	-- 				{
	-- 					['timestamp'] = enterTimestamp,
	-- 					['length'] = timestamp - enterTimestamp,
	-- 					['level'] = exports.main_levels:getPlayerLevel(source),
	-- 					['inProgress'] = {},
	-- 				},
	-- 			},
	-- 			['pl'] = {
	-- 				{
	-- 					['data'] = {
	-- 						['bank.rub'] = bank,
	-- 						['donate'] = donate,
	-- 						['money'] = money,
	-- 						['refer'] = source.account:getData('referal.refer') or nil,
	-- 						['server'] = exports.core:getServerIndex() or 1,
	-- 						['version'] = version,

	-- 					},
	-- 					['timestamp'] = timestamp,
	-- 				},
	-- 			},
	-- 			['ui'] = {
	-- 				{
	-- 					['country'] = exports.admin:getPlayerCountry(source):upper(),
	-- 					['language'] = 'ru',
	-- 					['ip'] = source.ip,
	-- 					['isRooted'] = 0,
	-- 				},
	-- 			},
	-- 		},
	-- 	})

	-- end)

-----------------------------------------------------------------------------------------------
-- detection for tutorial


-----------------------------------------------------------------------------------------------

	-- addEvent('onAccountRegister', true)
	-- addEventHandler('onAccountRegister', root, function(account)
	-- 	local timestamp = getRealTime().timestamp
	-- 	trackAction({
	-- 		[account.name] = {
	-- 			['rg'] = {
	-- 				{
	-- 					['timestamp'] = timestamp,
	-- 				},
	-- 			},

	-- 			['rf'] = {
	-- 				{
	-- 					['timestamp'] = timestamp,
	-- 					['publisher'] = getTrackedIpAddress(source.ip) or 'undefined',
	-- 				},
	-- 			},

	-- 			['ui'] = {
	-- 				{
	-- 					['country'] = exports.admin:getPlayerCountry(source):upper(),
	-- 					['language'] = 'ru',
	-- 					['ip'] = source.ip,
	-- 					['isRooted'] = 0,
	-- 				},
	-- 			},

	-- 		},
	-- 	})
	-- end)

-----------------------------------------------------------------------------------------------

	-- addEvent('onPlayerPurchase', true)
	-- addEventHandler('onPlayerPurchase', root, function(data)
	-- 	if not source.account then return end

	-- 	local timestamp = getRealTime().timestamp
	-- 	trackAction({
	-- 		[source.account.name] = {
	-- 			['ip'] = {
	-- 				{
	-- 					['timestamp'] = timestamp,
	-- 					['purchaseType'] = data.type,
	-- 					['purchaseId'] = data.id,
	-- 					['purchaseAmount'] = data.amount,
	-- 					['purchasePrice'] = data.price,
	-- 					['purchasePriceCurrency'] = data.currency,
	-- 					['level'] = exports.main_levels:getPlayerLevel(source),
	-- 					['inProgress'] = {},
	-- 				},

	-- 			},

	-- 		},
	-- 	})
	-- end)

-----------------------------------------------------------------------------------------------

	-- addEvent('onPlayerDonat', true)
	-- addEventHandler('onPlayerDonat', root, function(data)
	-- 	local timestamp = getRealTime().timestamp

	-- 	trackAction({
	-- 		[data.account.name] = {
	-- 			['rp'] = {
	-- 				{
	-- 					['name'] = data.name,
	-- 					['entries'] = {
	-- 						{
	-- 							['orderId'] = data.payId,
	-- 							['price'] = data.price,
	-- 							['currencyCode'] = 'RUB',
	-- 							['timestamp'] = timestamp,
	-- 							['level'] = data.account:getData('level') or 0,
	-- 							['inProgress'] = {},
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	})
	-- end)

-----------------------------------------------------------------------------------------------

	-- addEventHandler('onElementDataChange', root, function(dataName, old, new)
	-- 	if tonumber(old) and dataName == 'level' and new > old then
			
	-- 		if not source.account then return end

	-- 		local timestamp = getRealTime().timestamp

	-- 		local bank = exports.main_bank:getPlayerBankMoney(source)
	-- 		local donate = exports.main_bank:getPlayerDonate(source)
	-- 		local money = exports.money:getPlayerMoney(source)

	-- 		trackAction({
	-- 			[source.account.name] = {
	-- 				{
	-- 					['lu'] = {
	-- 						['timestamp'] = timestamp,
	-- 						['level'] = new,
	-- 						['inProgress'] = {},
	-- 						['balance'] = {
	-- 							['bank.rub'] = bank,
	-- 							['donate'] = donate,
	-- 							['money'] = money,
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end
	-- end)

-----------------------------------------------------------------------------------------------

