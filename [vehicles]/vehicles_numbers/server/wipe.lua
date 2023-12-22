
function wipeAccount(login)
	dbExec(db, string.format('DELETE FROM numbers WHERE owner="%s";', login))
end
