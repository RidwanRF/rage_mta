function getPlayerHouses(player)
	local houses = dbPoll(dbQuery(db, string.format('SELECT * FROM houses WHERE owner="%s";',
		player.account.name
	)), -1)

	return houses
end