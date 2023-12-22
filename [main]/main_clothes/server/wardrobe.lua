
function wearItem(model)

	model = tonumber(model)

	local wardrobe = client:getData('wardrobe') or {}
	local currentModel = client:getData('character.skin') or {}

	if not wardrobe[model] then
		return exports.hud_notify:notify(client, 'Ошибка', 'В гардеробе нет скина', 3000)
	end

	local time = wardrobe[model]
	wardrobe[model] = nil
	wardrobe[tonumber(currentModel)] = time

	client:setData('character.skin', model)
	client:setData('wardrobe', wardrobe)
	updatePlayerWardrobeLots(client)

	exports.hud_notify:notify(client, 'Успешно', 'Вы сменили одежду', 3000)

	exports.logs:addLog(
		'[CLOTHES][WEAR]',
		{
			data = {
				player = client.account.name,
				model = model,
				prev = currentModel,
			},	
		}
	)

end
addEvent('clothes.wardrobe.wear', true)
addEventHandler('clothes.wardrobe.wear', resourceRoot, wearItem)


function removeItem(model)

	model = tonumber(model)

	local wardrobe = client:getData('wardrobe') or {}
	local currentModel = client:getData('character.skin') or {}

	if getTableLength(wardrobe) <= 0 then
		return exports.hud_notify:notify(client, 'Ошибка', 'Остался последний скин', 3000)
	end

	local time = wardrobe[model]
	wardrobe[model] = nil


	if model == currentModel then
		for model in pairs(wardrobe) do
			client:setData('character.skin', model)
			wardrobe[model] = nil
		end
	end

	client:setData('wardrobe', wardrobe)
	updatePlayerWardrobeLots(client)

	exports.hud_notify:notify(client, 'Гардероб', 'Вы удалили скин', 3000)

	exports.logs:addLog(
		'[CLOTHES][REMOVE]',
		{
			data = {
				player = client.account.name,
				model = model,
			},	
		}
	)

end
addEvent('clothes.wardrobe.remove', true)
addEventHandler('clothes.wardrobe.remove', resourceRoot, removeItem)


function extendWardrobe()
	
	local money = exports.main_bank:getPlayerDonate(client)

	if money < Config.extendWardrobeCost then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег', 3000)
	end

	exports.main_bank:takePlayerDonate(client, Config.extendWardrobeCost)

	increaseElementData(client, 'clothes.extended', 1)
	updatePlayerWardrobeLots(client)

	exports.hud_notify:notify(client, 'Успешно', 'Гардероб расширен', 3000)

	exports.logs:addLog(
		'[CLOTHES][REMOVE]',
		{
			data = {
				player = client.account.name,
				cost = Config.extendWardrobeCost,
			},	
		}
	)
end
addEvent('clothes.wardrobe.extend', true)
addEventHandler('clothes.wardrobe.extend', resourceRoot, extendWardrobe)