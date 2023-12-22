function isAdmin(player)
	return exports.acl:isAdmin(player)
	-- return player:getData('isAdmin')
end