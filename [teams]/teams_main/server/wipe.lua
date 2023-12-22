

function wipeAccount( login )

	for id, team in pairs( teams ) do

		if team.data and team.data.members and team.data.members[login] then

			if login == team.data.creator then
				deleteClan( team.team )
			else
				removeClanMember( id, login )
			end

		end

	end

end