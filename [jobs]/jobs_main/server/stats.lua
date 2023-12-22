
exports.save:addParameter('jobs.stats', true, true, true)

function addPlayerStats( player, stats_name, amount, _job_name )

	local data = player:getData('jobs.stats') or {}
	local job_name = _job_name or sourceResource.name

	data[job_name] = data[job_name] or {}
	data[job_name][stats_name] = ( data[job_name][stats_name] or 0 ) + amount

	local d1 = string.format('job.temp_stats.%s.%s', job_name, stats_name)
	local d2 = string.format('job.session_stats.%s.%s', job_name, stats_name)

	increaseElementData(player, d1, amount, false)
	increaseElementData(player, d2, amount, false)

	player:setData('jobs.stats', data, false)

	triggerClientEvent(player, 'work.syncStats', resourceRoot, {
		['jobs.stats'] = data,
		[d1] = player:getData(d1) or 0,
		[d2] = player:getData(d2) or 0,
	})

end

function clearPlayerTempStats( player )

	for key, value in pairs( getAllElementData(player) ) do

		if key:find('job.temp_stats') then
			removeElementData(player, key)
		end

	end

end