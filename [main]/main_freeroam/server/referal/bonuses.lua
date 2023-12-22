
------------------------------------------------------------

	local rewardFunctions = {

		money = function(login, amount)
			increaseUserData(login, 'money', amount)
		end,

		vip = function(login, amount)
			exports.main_vip:giveVip(login, amount*86400)
		end,

		car = function(login, amount)

			for i = 1, amount do
				exports.vehicles_main:giveAccountVehicle(login, 550)
			end

		end,

	}

	function giveReferalBonus(login, reward)
		( rewardFunctions[reward.type] )( login, reward.amount )
	end

------------------------------------------------------------

	function handleReferalDonate( refer, amount, donater )

		local refer_acc = getAccount(refer)
		if not refer_acc then return end

		local donater_acc = getAccount(donater)
		if not donater_acc then return end

		local percent = getLoginReferalPercent( refer )
		local add = math.floor(amount*percent/100)

		increaseUserData(refer, 'referal.balance', add)

		exports.logs:addLog(
			'[REFERAL][DONATION]',
			{
				data = {

					player = refer,
					donater = donater,
					code = donater_acc:getData('referal.entered_code'),

					referal_add = add,
					amount = amount,

				},	
			}
		)

	end

------------------------------------------------------------