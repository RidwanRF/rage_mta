
addCommandHandler('inc_user_data', function(player, _, login, dn, value)
	if exports.acl:isAdmin(player) then
		increaseUserData( login, dn, tonumber(value) )
	end
end)


addCommandHandler('set_user_data', function(player, _, login, dn, value)
	if exports.acl:isAdmin(player) then
		setUserData( login, dn, tonumber(value) or value )
	end
end)


addCommandHandler('get_user_data', function(player, _, login, dn)
	if exports.acl:isAdmin(player) then

		local account = getAccount(login)
		exports.chat_main:displayInfo( player, inspect(account:getData(dn)), {255,255,255} )

	end
end)