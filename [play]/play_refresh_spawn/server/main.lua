

function refreshSpawn()

	if (client:getData('prison.time') or 0) > 0 then
		return exports.hud_notify:notify(client, 'Ошибка', 'Вы в тюрьме')
	end

	if client:getData('respawn.suppressed') then
		return exports.hud_notify:notify(client, 'Ошибка', 'Действие недоступно')
	end

	if exports.jobs_main:getPlayerWork( client ) then
		exports.jobs_main:refreshPlayerSpawn(client)
	else
		local x,y,z = unpack( Config.spawn )
		spawnPlayer(client, x,y,z, 0, client.model, 0, 0)
	end

	exports.hud_notify:notify(client, 'Успешно', 'Вы телепортированы')

end
addEvent('play.refreshSpawn', true)
addEventHandler('play.refreshSpawn', resourceRoot, refreshSpawn)