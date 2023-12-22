
local rights = {
	
	admin = function(player)
		return exports.acl:isAdmin(player)
	end,

	moderator = function(player)
		return exports.acl:isAdmin(player) or exports.acl:isModerator(player)
	end,
}

function hasPlayerRight(player, right)
	return (rights[right])(player)
end