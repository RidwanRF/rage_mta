
----------------------------------------------------------------

	db = dbConnect('sqlite', ':databases/vehicles.db')

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec( db, 'ALTER TABLE vehicles ADD COLUMN debt INTEGER;' )
		-- dbExec( db, 'UPDATE vehicles SET debt=0;' )

	end)

----------------------------------------------------------------

	function payDebt(id)

		if not id then return end

		local data = dbPoll( dbQuery(db, string.format('SELECT * FROM vehicles WHERE id=%d', id)), -1 )
		
		if data and data[1] and data[1].owner ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец')
		end

		local debt = math.floor( ( data[1].debt or 0 ) * ( 100 - Config.discount ) / 100 )

		if debt <= 0 then
			return exports.hud_notify:notify(client, 'Ошибка', 'Долг отсутствует')
		end

		if exports.money:getPlayerMoney(client) < debt then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		exports.money:takePlayerMoney(client, debt)
		dbExec(db, ('UPDATE vehicles SET debt=0 WHERE id=%s;'):format( id ))

		exports.hud_notify:notify(client, 'Успешно', 'Долг оплачен')

		exports.vehicles_main:returnPlayerVehicles( client )

		exports.logs:addLog(
			'[DEBT][PAY]',
			{
				data = {
					player = client.account.name,
					model = data[1].model,
					vehicle = id,
					debt = debt,
				},	
			}
		)

	end
	addEvent('vehicles_debt.payDebt', true)
	addEventHandler('vehicles_debt.payDebt', resourceRoot, payDebt)

----------------------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		local vehicles = dbPoll( dbQuery(
			db, ('SELECT * FROM vehicles WHERE owner="%s";'):format( source.account.name )
		), -1 )

		local total_debt = 0

		for _, vehicle in pairs( vehicles ) do
			total_debt = total_debt + (vehicle.debt or 0)
		end

		if total_debt > 0 then
	
			setTimer(function( player )

				if isElement(player) then

					exports.chat_main:displayInfo( player, 'У вас есть неоплаченный автодолг', { 255,0,0 } )
					exports.chat_main:displayInfo( player, ('нажмите «%s» для подробностей'):format( Config.key ), { 255,0,0 } )

				end

			end, 3000, 1, source)

		end

	end)

----------------------------------------------------------------