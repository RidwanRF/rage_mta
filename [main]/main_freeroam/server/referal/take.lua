
--------------------------------------------------------------------

	local token = ''

--------------------------------------------------------------------

	function takeReferalCoins( pay_type, number, vk_link )

		local amount = client:getData('referal.balance') or 0
		local order = client:getData('referal.take_order')

		if amount <= 0 then return end

		if order then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы уже отправили запрос')
		end

		if amount < Config.minReferalTakeSum and pay_type ~= 'rcoin' then
			return exports.hud_notify:notify(client, 'Ошибка', 'Минимальный вывод - ' .. Config.minReferalTakeSum)
		end

		if pay_type == 'rcoin' then

			increaseElementData(client, 'referal.balance', -amount)
			increaseElementData(client, 'bank.donate', amount)

			exports.hud_notify:notify(client, 'Успешно', 'Запрос выполнен')

			exports.web_main:sendVKMessage( string.format('[ORDER] %s | %s | convert %s rcoin',
				client.account.name, amount, pay_type, number, vk_link
			), token )

		else

			client:setData('referal.take_order', {
				amount = amount,
				pay_type = pay_type,
				number = number,
				vk_link = vk_link,
			})

			exports.hud_notify:notify(client, 'Успешно', 'Запрос отправлен')

			exports.web_main:sendVKMessage( string.format('[ORDER] %s | %s coins | %s | %s | %s',
				client.account.name, amount, pay_type, number, vk_link
			), token )

		end

		exports.logs:addLog(
			'[REFERAL][TAKE]',
			{
				data = {
					player = client.account.name,
					pay_type = pay_type,
					amount = amount,
					vk_link = vk_link,
					number = number,
				},	
			}
		)

	end
	addEvent('freeroam.takeReferalCoins', true)
	addEventHandler('freeroam.takeReferalCoins', resourceRoot, takeReferalCoins)

--------------------------------------------------------------------
	
	function completeTakeOrder(player, cn, login)

		if exports.acl:isAdmin(player) then

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

			if cn == 'fr_complete_rt_order' then

				increaseUserData(login, 'referal.balance', -data.amount)

				exports.main_alerts:addAccountAlert( account.name, 'referal', 'Успешный вывод средств',
					string.format('Вам одобрен вывод средств\nв размере %s руб.',
						data.amount
					)
				)

			elseif cn == 'fr_fail_rt_order' then

				exports.main_alerts:addAccountAlert( account.name, 'referal', 'Вывод средств отклонен',
					string.format('Вывод средств в размере %s руб.\nне одобрен',
						data.amount
					)
				)

			end

			exports.chat_main:displayInfo( player, ('%s %s succesfully'):format( cn, login ), {255,255,255} )

			exports.web_main:sendVKMessage( string.format('[ORDER_COMPLETE] admin %s | %s | %s coins |',
				client.account.name, login, data.amount
			), token )

		end

	end

	addCommandHandler('fr_complete_rt_order', completeTakeOrder)
	addCommandHandler('fr_fail_rt_order', completeTakeOrder)

--------------------------------------------------------------------