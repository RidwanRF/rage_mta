
	addCommandHandler('vehicles_pay_debt', function(player, id)

		triggerServerEvent ( "vehicles_debt.payDebt", root, id )

	end)