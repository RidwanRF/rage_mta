
addEvent('onAccountWipe', true)

local resourcesToWipe = {'main_business', 'main_oil_derrick', 'vehicles_main', 'main_house', 'vehicles_numbers', 'teams_main'}
local dnExceptions = {'acl.groups'}

function wipeAccount(login)

	local account = getAccount(login)
	if not account then return end

	if account.player then
		kickPlayer(account.player, 'Обнуление')
	end

	for _, resource in pairs( resourcesToWipe ) do
		exports[resource]:wipeAccount(login)
	end

	local data = getAllAccountData(account)

	for _, key in pairs(dnExceptions) do
		data[key] = nil
	end

	for key, value in pairs( data ) do
		account:setData(key, 'false')
		account:setData(key, false)
	end

	triggerEvent('onAccountWipe', root, account)

end

addCommandHandler('custom_remaccount', function(player, _, ...)
	if exports['acl']:isAdmin(player) then

		local list = {...}
		
		exports.web_main:sendVKMessage(
			string.format('ADMIN-WIPE %s %s: %s',
				player.account.name, exports['core']:getServerIndex(),
				table.concat(list, ', ')
			)
		)

		for _, login in pairs(list) do
			wipeAccount(login)
		end

		if isElement(player) then
			exports['hud_notify']:notify(player, 'Успешно', 'Аккаунт обнулен')
		end


	end
end)