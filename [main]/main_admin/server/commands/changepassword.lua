
addCommandHandler('changepass', function(player, _, login, password)

	if exports.acl:isAdmin(player) then

		setAccountPassword( getAccount(login), password )
		exports.chat_main:displayInfo( player, 'changepassword succesfully', {255,255,255} )

	end

end)