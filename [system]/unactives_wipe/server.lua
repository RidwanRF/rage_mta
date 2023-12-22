local unactiveTime = 86400*40

function checkUnactive()

	local realTime = getRealTime().timestamp

	for _, account in pairs( getAccounts() ) do

		local lastSeen = tonumber( account:getData('lastSeen') )

		if lastSeen then
			if (realTime - lastSeen) >= unactiveTime then

				exports['main_house']:wipeAccount( account.name )
				exports['main_business']:wipeAccount( account.name )
				exports['main_oil_derrick']:wipeAccount( account.name )

				if account.player then
					exports.hud_notify:notify(account.player, 'Неактив', 'Имущество обнулено')
				end

			end
		end

	end

end
addEventHandler('onResourceStart', resourceRoot, checkUnactive)

