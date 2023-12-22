
function increaseAccountInvitedCount(login, count)

	local account = getAccount(login)
	if not account then return end

	if account.player then
		increaseElementData(account.player, 'referal.players.invited_change', count)
	else
		increaseAccountData(account, 'referal.players.invited_change', count)
	end

end


addEventHandler('onElementDataChange', root, function(dn, old, new)
	if dn == 'referal.players.invited_change' and (new or 0) > 0 then

		setTimer(function(source, new)

			increaseElementData(source, 'referal.players.invited', new)
			source:setData('referal.players.invited_change', 0)
			source.account:setData('referal.players.invited_change', 0)

		end, 1000, 1, source, new)
		
	end
end)

