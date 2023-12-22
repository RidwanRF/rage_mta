
function getPlayerWork(player)
	return player:getData('work.current')
end

function getPlayerStats(player)

	local data = player:getData('jobs.stats') or {}
	local job_name = sourceResource.name

	return data[job_name] or {}

end