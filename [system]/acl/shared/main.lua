
function isPlayerInGroup(player, group)
	local groups = player:getData('acl.groups') or {}
	return groups[group]
end

function isAdmin(player)
	return isPlayerInGroup(player, 'admin')
end

function isModerator(player)
	return isPlayerInGroup(player, 'moderator') or isPlayerInGroup(player, 'admin')
end