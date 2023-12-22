
---------------------------------------------------------------------------

	function buyClothes(model)

		local config = Config.clothesAssoc[model]
		local cost = config.cost

		local wardrobe = client:getData('wardrobe') or {}

		if client:getData('character.skin') == model or wardrobe[model] then
			return exports.hud_notify:notify(client, 'Ошибка', 'У вас уже есть этот скин', 3000)
		end

		local money = config.donate
			and exports.main_bank:getPlayerDonate(client)
			or exports.money:getPlayerMoney(client)

		if cost > money then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег', 3000)
		end

		local current, all = client:getData('clothes.loaded') or 0, client:getData('clothes.all') or 0
		if (current + 1) > all then
			return exports.hud_notify:notify(client, 'Ошибка', 'В гардеробе нет места', 3000)
		end

		if config.donate then
			exports.main_bank:takePlayerDonate(client, cost)
		else
			exports.money:takePlayerMoney(client, cost)
		end

		addWardrobeClothes(client, model)

		increaseElementData(client, 'main_clothes.clothes_bought', 1)

		exports.hud_notify:notify(client, 'Новая одежда',
			string.format('Скин помещен в гардероб'), 3000)

		exports.logs:addLog(
			'[CLOTHES][BUY]',
			{
				data = {
					player = client.account.name,
					model = model,
					cost = cost,
					valute = valute,
				},	
			}
		)


	end

	addEvent('clothes.buy', true)
	addEventHandler('clothes.buy', resourceRoot, buyClothes)

---------------------------------------------------------------------------

	function setCaseTexture(tex_id)

		local saved = client:getData('custom_case.saved') or {}

		if saved[tex_id] or tex_id == 0 then

			client:setData('custom_case.id', tex_id)

			exports.hud_notify:notify(client, 'Успешно',
				string.format('Стиль кейса изменен'), 3000)

			exports.logs:addLog(
				'[CASE][TEXTURE]',
				{
					data = {
						player = client.account.name,
						tex_id = tex_id,
					},	
				}
			)

		else

			local config = Config.case_custom[tex_id]
			if not config then return end

			local money = client:getData( config.valute ) or 0
			if money < config.cost then
				return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
			end

			increaseElementData( client, config.valute, -config.cost )

			saved[tex_id] = getRealTime().timestamp

			client:setData('custom_case.saved', saved)
			client:setData('custom_case.id', tex_id)

			exports.hud_notify:notify(client, 'Успешно',
				string.format('Стиль кейса изменен'), 3000)

			exports.logs:addLog(
				'[CASE][BUY][TEXTURE]',
				{
					data = {
						player = client.account.name,
						tex_id = tex_id,
						cost = config.cost,
						valute = config.valute,
					},	
				}
			)

		end

	end
	addEvent('clothes.case.set', true)
	addEventHandler('clothes.case.set', resourceRoot, setCaseTexture)

---------------------------------------------------------------------------