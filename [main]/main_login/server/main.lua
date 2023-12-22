
addEvent('onAccountRegister', true)

function displayError(player, text)
	triggerClientEvent(player, 'authpanel.displayWarning', resourceRoot, text)
end

function registerAccount(login, _password, promo)

	if Config.disableLogins[login] then
		return displayError(client, string.format('Этот логин запрещен'))
	end

	local password = decode(_password)

	if password == login then
		return displayError(client, string.format('Логин и пароль совпадают'))
	end

	if tonumber(login) then
		return displayError(client, string.format('В логине должна быть буква'))
	end

	local account = getAccount(login, password)

	local promo_data = exports.main_freeroam:getCodeData(promo)
	if not promo_data and utf8.len(promo) > 0 then
		return displayError(client, string.format('Промокод не найден'))
	end

	local serialLogin = checkSerialUsage(client.serial)
	if serialLogin then
		return displayError(client,
			string.format('Вы уже зарегистрировали аккаунт\nс этого ПК. Логин - %s',
				serialLogin
		))
	end

	if not account then
		local newAccount = createAccount(login, password, client)
		if newAccount then

			enterAccount(login, _password, client)
			addSerial(login, client.serial)
			triggerEvent('onAccountRegister', client, newAccount)

			setTimer(function(promo, player)


				exports.main_freeroam:enterReferalCode(promo, player)

				if #promo > 0 then
					exports.chat_main:displayInfo(player,
						('Вы активировали промокод %s, подробнее о наградах >> F1 >> Реферальная система'):format(promo),
						{200, 255, 70}
					)
				end

			end, 1000, 1, promo, client)

		end
	else
		return displayError(client, 'Аккаунт уже существует')
	end

end
addEvent('authpanel.register', true)
addEventHandler('authpanel.register', resourceRoot, registerAccount)

function createAccount(login, password, player)
	local account = addAccount(login, password)
	if account then

		account:setData('unique.id', #getAccounts())
		account:setData('unique.serial', player.serial)
		account:setData('unique.register_date', getRealTime().timestamp)

		return account

	else
		return false
	end
end

debug = false
addCommandHandler('ml_toggle_debug', function(player)

	if exports.acl:isAdmin(player) then
		debug = not debug
	end

end)


function enterAccount_callback(login, _password, player)

	local a1 = getTickCount(  )

	if not isElement(player) then return end

	if tostring( login ) == "trademc" then
		exports.logs:addLog(
			'[LOGIN]',
			{
				data = {
					player = login,
					serial = player.serial,
					ip = player.ip,
					account = "trademc"
				},	
			}
		)
		player:kick( "#AC[4]" )
		return
	end

	local password = decode(_password)
	local account = getAccount(tostring( login ), tostring( password ) )

	if account then

		if getAccountPlayer(account) then
			return displayError(player, 'Аккаунт уже в игре')
		end

		local result = logIn(player, account, password)
		if result then
			triggerClientEvent(player, 'authpanel.close', player)
			player:setData('unique.login', login)
			player:setData('auth.timestamp', getRealTime().timestamp)

			setTimer(function(player)
				if isElement(player) then
					increaseElementData(player, 'session.auths', 1)
				end
			end, 5000, 1, player)

			exports.chat_main:displayInfo(player,
				'Вы успешно вошли на RAGE!', {200, 70, 70})

		else
			displayError(player, 'Неизвестная ошибка')
		end
	else
		displayError(player, 'Неверный логин или пароль')
	end

	if debug then
		local a2 = getTickCount(  )
		print(getTickCount(  ), 'LOGIN', login, a2-a1)
	end

end

login_queue = {}

setTimer(function()

	for player, data in pairs( login_queue ) do
		enterAccount_callback( unpack(data) )
		login_queue[player] = nil
		break
	end

end, 200, 0)

function enterAccount(login, _password, _player)

	local player = _player or client
	login_queue[player] = { login, _password, player }
	
end
addEvent('authpanel.authorize', true)
addEventHandler('authpanel.authorize', resourceRoot, enterAccount)

-- for _, player in pairs(getElementsByType('player')) do
-- 	logOut(player)
-- end

addEventHandler('onPlayerQuit', root, function()

	if source.account and source.account.name ~= 'guest' then

		local cTime = getRealTime().timestamp
		local session = cTime - (source:getData('auth.timestamp') or cTime)

		exports.logs:addLog(
			'[QUIT]',
			{
				data = {
					player = source.account.name,
					serial = source.serial,
					ip = source.ip,
					money = exports.money:getPlayerMoney(source),
					session = session,
					bank = exports.main_bank:getPlayerBankMoney(source),
				},	
			}
		)

	end

end)

addEventHandler('onPlayerLogin', root, function()

	if source.account and source.account.name ~= 'guest' then

		local cTime = getRealTime().timestamp

		exports.logs:addLog(
			'[LOGIN]',
			{
				data = {
					player = source.account.name,
					serial = source.serial,
					ip = source.ip,
					money = exports.money:getPlayerMoney(source),
					bank = exports.main_bank:getPlayerBankMoney(source),
				},	
			}
		)

	end

end, true, 'low-20')