

function businessIncome()

	setTimer(function()

		handleAreasIncome()

		local allBusiness = dbPoll(dbQuery(db, 'SELECT * FROM business;'), -1)

		for _, business in pairs(allBusiness) do

			if business.owner ~= '' then

				local newBalance = (tonumber(business.balance) or 0) + (tonumber(business.payment_sum) or 0)

				exports.logs:addLog(
					'[BUSINESS][INCOME]',
					{
						data = {
							id = business.id,
							new_balance = newBalanc,
							income = business.payment_sum,
						},	
					}
				)

				dbExec(db, string.format('UPDATE business SET balance=%s WHERE id=%s;',
					newBalance, business.id
				))

			end

		end
		
		restartResource( getThisResource() )

	end, 10000, 1)

end

addEventHandler('onServerDayCycle', root, businessIncome)


addCommandHandler('business_income', function(player)
	if exports.acl:isAdmin(player) then
		businessIncome()
	end
end)