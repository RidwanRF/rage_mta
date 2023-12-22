---------------------------------------------

	exports.save:addParameter('donations', true)

---------------------------------------------

	function checkAccountExists(login)
		local account = getAccount(login)
		if account then
			return 'ok'
		else
			return 'false'
		end
	end

---------------------------------------------

	-- отдать информацию о сервере и сохранить удаленный ип адрес
	function getServerInfo(ipAddress, publisherKey)
		local data = {
			maxplayers = getMaxPlayers(),
			playerscount = getPlayerCount(),
		}
		--exports.tracking:trackIpAddress(ipAddress, publisherKey)
		return data
	end

---------------------------------------------

	function getAccountDonations(account)

		local donations
		if account.player then
			donations = account.player:getData('donations') or {}
		else
			donations = fromJSON( account:getData('donations') or '[[]]', true ) or {}
		end

		return donations

	end

	addCommandHandler('accdonate', function(player, _, login)

		if exports.acl:isAdmin( player ) then

			local account = getAccount(login)
			if not account then return end

			local donations = getAccountDonations( account )
			local sum = 0

			for _, donation in pairs( donations ) do
				sum = sum + donation.sum
			end

			exports.chat_main:displayInfo(player, 'Игрок задонатил '..sum, {255,255,255})

		end

	end)

	function addAccountDonation(account, payment_sum)


		local donations = getAccountDonations(account)

		table.insert(donations, { timestamp = getRealTime().timestamp, sum = payment_sum })
		if account.player then
			account.player:setData('donations', donations)
		else
			account:setData('donations', toJSON(donations, true))
		end


	end

	function getMaxAccountDonation(account)

		local donations = getAccountDonations(account)
		table.sort(donations, function(a,b)
			return a.sum > b.sum
		end)

		return (donations[1] or {sum=0}).sum or 0

	end

---------------------------------------------

	local payedIds = {}

	function handleDonation(login, payment_sum, payId, paySum)

		if payId and payedIds[payId] then return 'already_payed' end

		if payId then
			payedIds[payId] = true
		end

		local account = getAccount(login)
		local x2 = account:getData( "x2_offer_sum" ) or false
		if x2 then
			payment_sum = payment_sum * 2
		end
		local amount = payment_sum

		local refer = account:getData('referal.refer')
		if refer and getAccount(refer) then
			exports.main_freeroam:handleReferalDonate( refer, amount, login )
		end

		addAccountDonation(account, amount)

		if account.player then

			exports.main_bank:givePlayerDonate(account.player, amount)

			exports.chat_main:displayInfo(account.player,
				string.format('[Пополнение счета] Вы пополнили донат-счет: +%s R-Coin',
				amount
			), {0, 255, 0})

			if x2 then
				exports.chat_main:displayInfo( account.player, "Использована акция Х2 Пополнения, начислено: "..amount.." R-Coin" )
			end

			exports.main_freeroam:updatePlayerAchievments(account.player)


		else
			if account then
				exports.main_bank:giveAccountDonate(account, amount)
			end
		end
		account:setData( "x2_offer_sum", false )

		exports.logs:addLog(
			'[DONATION]',
			{
				data = {
					player = login,
					sum = amount,
				},	
			}
		)

		return 'ok'
	end

	addCommandHandler('handledonat', function(player, cn, login, sum)

		if exports.acl:isAdmin(player) then
			handleDonation( login, tonumber(sum), getTickCount(  ), getTickCount(  ) )
		end

	end)

---------------------------------------------

	local complects = {
		['svj'] = function(login)

			increaseUserData(login, 'money', 100000)

			exports.vehicles_main:giveAccountVehicle(login, 542, {
				appearance_upgrades = {
					color_1 = '#000000',
					color_2 = '#000000',
				},
			})

		end,
		['money'] = function(login)

			increaseUserData(login, 'money', 1000000)
			exports.main_vip:giveVip(login, 86400*30)

		end,
		
		['f90_spring'] = function(login)

			exports['vehicles_main']:giveAccountVehicle(login, 409, {
				appearance_upgrades = {
					paintjob = {
						{
							path = 'taycan_remap.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

		end,
		
		['m8_remap'] = function(login)

			exports['vehicles_main']:giveAccountVehicle(login, 555, {
				appearance_upgrades = {
					paintjob = {
						{
							path = 'm8_remap.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

		end,
		
		['m8_remap2'] = function(login)

			exports['vehicles_main']:giveAccountVehicle(login, 555, {
				appearance_upgrades = {
					paintjob = {
						{
							path = 'm8_remap2.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

		end,
		
		['germany3'] = function(login)

			exports.vehicles_main:giveAccountVehicle( login, 561 )
			exports.vehicles_main:giveAccountVehicle( login, 534 )
			exports.vehicles_main:giveAccountVehicle( login, 418 )			

		end,
		
		['usaweapon'] = function(login)

			local account = getAccount(login)

			exports.main_inventory:addInventoryItem({
				account = account,	
				item = 'first_aid_kit',
				count = 10,
			})

			exports.main_inventory:addInventoryItem({
				account = account,
				item = 'weapon_mk14',
				count = 1,
			})

			exports.main_inventory:addInventoryItem({
				account = account,
				item = 'weapon_m4',
				count = 1,
			})

			exports.main_inventory:addInventoryItem({
				account = account,
				item = 'ammo_2',
				count = 300,
			})

			exports.main_inventory:addInventoryItem({
				account = account,
				item = 'ammo_6',
				count = 120,
			})


		end,
		
		['abu_x10'] = function(login) exports.main_freeroam:giveAccountPack( getAccount(login), 6, 10 ) end,
		['king_x10'] = function(login) exports.main_freeroam:giveAccountPack( getAccount(login), 4, 10 ) end,
		['major_x10'] = function(login) exports.main_freeroam:giveAccountPack( getAccount(login), 5, 10 ) end,
		['excl_x5'] = function(login) exports.main_freeroam:giveAccountPack( getAccount(login), 9, 5 ) end,

		['cyberquest_ticket'] = function(login)
			exports.event_cyberquest:setAccountVip( login, true )
		end,

	}

	function giveComplect(login, complectKey, complectName, paySum)

		--[[if payId and payedIds[payId] then return 'already_payed' end

		if payId then
			payedIds[payId] = true
		end]]
		local paySum = tonumber( paySum )
		iprint(login, complectKey, complectName, paySum)

		local account = getAccount(login)
		if not account then return end

		if account.player then
			exports.hud_notify:notify(account.player, 'Комплект',
				string.format('Вы получили %s', complectName))
			exports.chat_main:displayInfo(account.player, string.format('Вы получили бонус комплекта %s', complectName), {0,255,0})
		end

		(complects[complectKey])(login)

		local refer = account:getData('referal.refer')
		if refer and getAccount(refer) then
			exports.main_freeroam:handleReferalDonate( refer, paySum, login )
		end

		addAccountDonation(account, paySum)

		if account.player then
			exports.main_freeroam:updatePlayerAchievments(account.player)
		end

		exports.logs:addLog(
			'[DONATION][COMPLECT]',
			{
				data = {
					player = login,
					sum = paySum,
					complect = complectKey,
				},	
			}
		)

		return 'ok'
	end

	addCommandHandler('givecomplect', function(player, _, login, complect)
		if exports.acl:isAdmin(player) and login and complect then
			giveComplect(login, complect, complect, getTickCount(), 0)
		end

	end)

---------------------------------------------

	local token = ''
	local ids = {
	}
	function sendVKMessage(text, _token)
		--[[fetchRemote('127.0.0.1/vksendmsg.php',
			{
				postData = string.format([=[
	{
		"access_token": "%s",
		"user_ids": [%s],
		"message": "%s",
		"v": 5.48
	}
				]=],
					_token or token,
					table.concat(ids, ','), ( '[%s]' ):format( exports.core:getServerIndex() ) .. text
				),
			},
			function(data, error)
			end
		)]]
	end

---------------------------------------------

	local ref_token = ''

	function completeReferalOrder( login )

		local account = getAccount(login)
		if not account then return end

		local data

		if account.player then

			data = account.player:getData('referal.take_order') or {}
			account.player:setData('referal.take_order', nil)

		else

			data = fromJSON( account:getData('referal.take_order') or '[[]]' ) or {}
			account:setData('referal.take_order', false)

		end

		increaseUserData(login, 'referal.balance', -data.amount)

		exports.main_alerts:addAccountAlert( account.name, 'referal', 'Успешный вывод средств',
			string.format('Вам одобрен вывод средств\nв размере %s руб.',
				data.amount
			)
		)

		--[[exports.web_main:sendVKMessage( string.format('[ORDER_COMPLETE] %s | %s coins |',
			login, data.amount
		), ref_token )]]

		return 'ok'


	end

---------------------------------------------