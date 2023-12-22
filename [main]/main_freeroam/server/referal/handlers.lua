
addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'level' then

		local code = source:getData('referal.entered_code')
		if code and new ~= source.account:getData('level') then

			local codeData = getCodeData(code)

			if codeData then

				local rewards = {
					{ section = 'invited', login = source.account.name },
					{ section = 'inviter', login = codeData.owner },
				}

				for _, data in pairs( rewards ) do
					for _, row in pairs( Config.referal[ data.section ] ) do
						if row.level == new then
							
							giveReferalBonus( data.login, row.reward )

							local account = getAccount(data.login)

							if account then

								if account.player then
									exports['hud_notify']:notify(account.player, 'Новый бонус', 'F1 -> Реферальная система')
								end

								exports.main_alerts:addAccountAlert( account.name, 'referal', 'Новый реферальный бонус',
									string.format('Реф. награда %s',
										row.reward.name
									)
								)
								
							end


						end
					end
				end

			end

		end

	end
end, true, 'high+2')