
local function handlePayday()

	for _, player in pairs( getElementsByType('player') ) do

		if exports['acl']:isModerator(player) then
			exports['money']:givePlayerMoney(player, Config.moderatorSalary)
			exports['hud_notify']:notify(player, string.format(
				'Вы получили %s$',
				splitWithPoints(Config.moderatorSalary, '.')
			),
				'За работу модератора'
			)
		end

		if exports['acl']:isPlayerInGroup(player, 'tester') then
			exports['money']:givePlayerMoney(player, Config.testerSalary)
			exports['hud_notify']:notify(player, string.format(
				'Вы получили %s$',
				splitWithPoints(Config.testerSalary, '.')
			),
				'За работу тестера'
			)
		end

	end

end

addEventHandler('onServerHourCycle', root, handlePayday)

addCommandHandler('admin_payday', function(player)

	if exports['acl']:isAdmin(player) then
		handlePayday()
	end

end)