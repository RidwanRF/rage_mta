
function updateVipFinishTime(account, value)
	if not account.player then return end
	account.player:setData( 'vip.finishTime', value or (account:getData('vip.finishTime') or 0) )
end

addEventHandler('onAccountDataChange', root, function(account, name, value)
	if name == 'vip.finishTime' then
		updateVipFinishTime(account, value)
	end
end)

addEventHandler('onPlayerLogin', root, function()
	updateVipFinishTime(source.account)
end)