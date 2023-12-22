


function enterReferalCode(code, _player)

	local e_code = code

	local player = _player or client

	if player:getData('referal.code') then return end

	local data = getCodeData(code)

	if data then

		if data.max_uses and data.uses >= data.max_uses then
			return exports.hud_notify:notify(player, 'Ошибка', 'Код не найден')
		end

		player:setData('referal.entered_code', code)
		player:setData('referal.refer', data.owner)

		increaseAccountInvitedCount(data.owner, 1)

		local users = fromJSON( data.users or '[[]]' ) or {}
		table.insert(users, 1, player.account.name)

		dbExec(db, string.format('UPDATE codes SET uses=uses+1, users=\'%s\' WHERE code="%s";',
			toJSON(users), code
		))

		if Config.uniqueCodes[code] and Config.uniqueCodes[code].give then
			Config.uniqueCodes[code].give(player)
		end

		exports['hud_notify']:notify(player, 'Бонус', 'Вы активировали промокод')

		updateOwnerData(code)

		local code = createReferalCode(player.account)
		player:setData('referal.code', code)

		exports.hud_notify:notify(player, 'Успешно', 'Код активирован')

		exports.logs:addLog(
			'[REFERAL][ENTER]',
			{
				data = {
					player = player.account.name,
					code = e_code,
				},	
			}
		)

		return true
	else
		exports.hud_notify:notify(player, 'Ошибка', 'Код не найден')
	end

end
addEvent('freeroam.referal.code.enter', true)
addEventHandler('freeroam.referal.code.enter', resourceRoot, enterReferalCode)
