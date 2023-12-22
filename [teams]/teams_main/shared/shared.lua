

function getPlayerRank( player )

	if not player.team then return false end

	local team_data = player.team:getData('team.data') or {}
	local login = player:getData('unique.login')

	local rank

	if team_data.members[login] then
		rank = team_data.members[login].rank
	end

	if not rank and team_data.creator == login then
		return { name = 'Владелец', id = 'creator' }
	end

	return rank and team_data.ranks[rank] or false

end

function formatPlayerName( player )

	local rank = getPlayerRank( player )

	if rank then
		return ('%s (%s)'):format( player.name, rank.name )
	else
		return player.name
	end

end

function hasPlayerRight( player, right )

	local rank = getPlayerRank( player )

	if not rank then return false end

	if rank.id == 'creator' then
		return true
	else
		return rank.rights[right]
	end

end

function calculateClanSalary( team )

	local team_data = team:getData('team.data') or {}
	if not team_data then return end

	local salary = 0

	for _, player in pairs( team.players ) do

		if hasPlayerRight( player, 'salary' ) then

			local rank = getPlayerRank( player )

			if rank and rank.salary then
				salary = salary + rank.salary
			end

		end

	end

	return salary

end

function getClanAreas( team )

	local team_data = team:getData('team.data') or {}
	if not team_data then return end

	local areas = {}

	for _, business in pairs( getElementsByType('marker', getResourceRoot('main_business')) ) do

		local b_data = business:getData('business.data') or {}
		if b_data.clan == team_data.id then
			table.insert(areas, business)
		end

	end

	return areas

end

function findTeamById( team_id )

	for _, team in pairs( getElementsByType('team', resourceRoot) ) do

		if team:getData('team.id') == team_id then
			return team
		end

	end

end

function getClanRating( team )

	local data = team:getData('team.data')
	if not data then return 0 end

	local totalLevel = 0

	for member, data in pairs( data.members ) do
		totalLevel = totalLevel + (data.level or 0)
	end

	local calc_data = {
		hours = ( data.stats or {} ).hours or 0,
		areas = getTableLength( getClanAreas( team ) ),
		members = getTableLength(data.members),
		bank = data.bank,
	}

	local rating = math.floor(
		(
			( ( data.stats.success_wars or 0 ) - 
			( data.stats.fail_wars or 0 ) ) * 500
		)
		+ math.floor( math.clamp( calc_data.bank * 0.0001, 0, 2000 ) )
		+ calc_data.hours*15 + ( ( data.stats or {} ).areas_rating or 0 )
	)

	return rating, calc_data

end

function getTeamWars( team, war_type )

	local team_data = team:getData('team.data') or {}
	local wars = {}

	for _, marker in pairs( getElementsByType('marker', getResourceRoot('main_business')) ) do

		local b_data = marker:getData('business.data') or {}

		if b_data and b_data.clan and b_data.clan_war and (

			( b_data.clan == team_data.id and ( (war_type or 'defend') == 'defend' ) )
			or
			(b_data.clan_war.opponent == team_data.id and ( (war_type or 'attack') == 'attack' ) )

		) then
			b_data.marker = marker
			table.insert( wars, b_data )
		end

	end

	return wars

end

function getClanMansion( team )

	local team_data = team:getData('team.data') or {}
	if not team_data then return end

	for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do

		local m_data = marker:getData('mansion.data') or {}
		if m_data.owner == team_data.id then
			return marker
		end

	end

end