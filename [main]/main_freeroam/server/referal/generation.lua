
function createReferalCode(account)
	local code = generateReferalCode()

	dbExec(db, string.format('INSERT INTO codes(owner, code, uses, users) VALUES ("%s", "%s", 0, \'%s\');',
		account.name, code, toJSON({})
	))

	updateOwnerData(code)

	return code

end

function generateReferalCode()
	local realTime = tostring(getRealTime().timestamp):sub(-5)
	local tick = tostring(getTickCount()):sub(-5)
	local num = tonumber( realTime..tick )
	return string.format("%.2X", num)
end
