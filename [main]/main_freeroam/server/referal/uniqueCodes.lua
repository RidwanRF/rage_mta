
function loadUniqueCodes()
	for code, data in pairs( Config.uniqueCodes ) do

		if data.owner then
			dbExec(db, string.format('UPDATE codes SET code="%s" WHERE owner="%s";',
				code, data.owner
			))
		end

		data.owner = data.owner or ''
		updateOwnerData( data.owner )

		local codeData = getCodeData(code)

		if codeData then

			dbExec(db, string.format('UPDATE codes SET owner="%s", max_uses=? WHERE code="%s";',
				data.owner, code
			),
				data.maxUses
			)

		else

			dbExec(db, string.format('INSERT INTO codes(owner, code, uses, max_uses, users) VALUES ("%s", "%s", 0, ?, \'%s\');',
				data.owner, code, toJSON({})
			), data.maxUses)

		end
	end
end