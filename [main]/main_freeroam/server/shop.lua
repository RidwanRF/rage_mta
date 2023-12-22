

--------------------------------------------------------------------------------

	exports.save:addParameter('convert_promocodes', true, true)

	function generatePromo()
		local realTime = tostring(getRealTime().timestamp):sub(-3)
		local tick = tostring(getTickCount()):sub(-3)
		local num = tonumber( realTime..tick )
		return string.format("%.2X", num)
	end

	function generateUniquePromo( _for )

		local promo = generatePromo()
		while _for[promo] do
			promo = generatePromo()
		end

		return promo

	end

	function addConvertPromo( element, promo, bonus )

		local timestamp = getRealTime().timestamp

		if element.type == 'player' then

			local promocodes = element:getData('convert_promocodes') or {}
			if not promo then promo = generateUniquePromo(promocodes) end

			promocodes[promo] = { bonus = bonus, timestamp = timestamp }

			element:setData('convert_promocodes', promocodes)

		else

			if element.player then return addConvertPromo( element.player, promo, bonus ) end
			
			local promocodes = fromJSON( element:getData('convert_promocodes') or '[[]]' ) or {}
			if not promo then promo = generateUniquePromo(promocodes) end

			promocodes[promo] = { bonus = bonus, timestamp = timestamp }

			element:setData('convert_promocodes', toJSON(promocodes))	

		end

	end

	function removeConvertPromo( element, promo )

		if element.type == 'player' then

			local promocodes = element:getData('convert_promocodes') or {}
			promocodes[promo] = nil

			element:setData('convert_promocodes', promocodes)

		else

			if element.player then return removeConvertPromo( element.player, promo ) end
			
			local promocodes = fromJSON( element:getData('convert_promocodes') or '[[]]' ) or {}
			promocodes[promo] = nil

			element:setData('convert_promocodes', toJSON(promocodes))	

		end

	end

	addCommandHandler('fr_add_convert_promo', function( player, _, login, promo, bonus )

		if exports.acl:isAdmin( player ) then

			local account = getAccount(login)

			if account then
				addConvertPromo( account, promo ~= 'nil' and promo or nil, tonumber(bonus) )
			end
			
		end

	end)

--------------------------------------------------------------------------------

	function convertValute(count, promo)

		if count <= 0 then return end

		local donate = client:getData('bank.donate') or 0

		if donate < count then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно R-Coin')
		end

		local quotation = Config.donateConvert
		local valute = count*quotation

		if promo then

			local promo_data = getConvertPromo(client, promo)

			if promo_data then

				valute = valute + valute/100*promo_data.bonus
				removeConvertPromo(client, promo)

			else
				return exports['hud_notify']:notify(client, 'Ошибка', 'Промокод не найден')
			end


		end

		increaseElementData(client, 'bank.donate', -count)
		exports['money']:givePlayerMoney(client, valute)

		exports['hud_notify']:notify(client, 'Успешно', 'Средства сконвертированы')

		exports.logs:addLog(
			'[FREEROAM][DONATECONVERT]',
			{
				data = {
					player = client.account.name,
					count = count,
					valute = valute,
				},	
			}
		)

	end
	addEvent('freeroam.convertValute', true)
	addEventHandler('freeroam.convertValute', resourceRoot, convertValute)

--------------------------------------------------------------------------------

	function buyVip(item_id)

		local config = Config.vipItems[item_id]
		if not config then return end

		local cost = config.cost

		local donate = client:getData('bank.donate') or 0

		if donate < cost then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно R-Coin')
		end

		increaseElementData(client, 'bank.donate', -cost)
		exports.main_vip:giveVip(client.account.name, config.days*86400)

		increaseElementData(client, 'vip_status.bought', 1)
		
		exports['hud_notify']:notify(client, 'Успешно',
			string.format('VIP продлен на %s %s',
				config.days, getWordCase(config.days, 'день', 'дня', 'дней')
		))

		exports.logs:addLog(
			'[FREEROAM][BUY_VIP]',
			{
				data = {
					player = client.account.name,
					cost = config.cost,
					days = config.days,
				},	
			}
		)

	end
	addEvent('freeroam.buyVip', true)
	addEventHandler('freeroam.buyVip', resourceRoot, buyVip)

--------------------------------------------------------------------------------

	function buyShopItem(itemId)

		local config = Config.donateShop[itemId]
		if not config then return end

		local valute = config.valute or 'bank.donate'

		local money = client:getData(valute) or 0

		if money < config.cost then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно R-Coin')
		end

		if config.expire and config.expire <= getRealTime().timestamp then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Набор уже недоступен')
		end

		local result = config.give(client)
		if not result then return end

		increaseElementData(client, valute, -config.cost)

		exports['hud_notify']:notify(client, 'Успешно', 'Набор приобретен')

		exports.logs:addLog(
			'[FREEROAM][BUYSHOPITEM]',
			{
				data = {
					player = client.account.name,
					cost = config.cost,
					item = itemId,
					item_id = config.item_id,
					item_name = config.name,
				},	
			}
		)		

	end
	addEvent('freeroam.buyShopItem', true)
	addEventHandler('freeroam.buyShopItem', resourceRoot, buyShopItem)

--------------------------------------------------------------------------------