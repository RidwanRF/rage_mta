
------------------------------------------------------------------------------------------------------

	exports.save:addParameter('bonus.current', nil, true)
	exports.save:addParameter('bonus.current_time', nil, true)
	exports.save:addParameter('bonus.used', true, true)
	exports.save:addParameter('bonus.uses', nil, true)

------------------------------------------------------------------------------------------------------

	function CheckBonus( )
		for _, player in pairs( getElementsByType('player') ) do
			if player:getData('bonus.current_time') then

				local time = player:getData('bonus.current_time') or 0
				player:setData('bonus.current_time', time - 60, false)
				triggerClientEvent(player, 'bonus.receiveCurrentTime', resourceRoot, player:getData('bonus.current_time'))

				if time < 1 then
					giveBonus(player)
				end
			end
		end
	end

	Timer( CheckBonus, 60000, 0 )
	addCommandHandler( "updatebonuses", function( self ) 
		if exports.acl:isAdmin( self ) then
			CheckBonus( )
		end
	end)

	addCommandHandler( "removebonuses", function( self, _, login ) 
		if exports.acl:isAdmin( self ) then
			local acc = getAccount( tostring( login ) )
			if acc then
				local player = getAccountPlayer( acc )
				if player then
					player:setData( "bonus.current_time", false )
					player:setData( "bonus.current", false )
					player:setData( "bonus.used", false )
				end
			end
		end
	end)

	function giveBonus(player)

		local bonus = player:getData('bonus.current')
		if not bonus then return end

		if not Config.bonuses[bonus] then
			return print(getTickCount(  ), ('BONUS ERROR %s %s'):format( player.account.name, bonus ))
		end

		Config.bonuses[bonus].give(player)

		player:setData('bonus.current', false)
		player:setData('bonus.current_time', false)

		exports.hud_notify:notify(player, 'Бонус', string.format('Вы получили «%s»', Config.bonuses[bonus].name))

		exports.logs:addLog(
			'[BONUS][GIVE]',
			{
				data = {
					player = player.account.name,
					bonus = bonus,
				},	
			}
		)

	end

	function useBonus(bonus)

		bonus = tostring(bonus)

		if client:getData('bonus.current') then
			return exports['hud_notify']:notify(client, 'Ошибка бонуса', 'Не получен предыдущий')
		end

		local config = Config.bonuses[bonus]

		if not config or config.disabled then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Бонус не найден')
		end

		if config.check and not config:check(client) then
			return
		end

		local usedBonuses = client:getData('bonus.used') or {}
		if usedBonuses[bonus] or ( tonumber(bonus) and usedBonuses[tonumber(bonus)] ) then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Бонус уже использован')
		end

		if config.attach then
			for _, a_bonus in pairs(config.attach) do
				return exports['hud_notify']:notify(client, 'Ошибка', 'Бонус уже использован')
			end
		end

		usedBonuses[bonus] = true
		client:setData('bonus.used', usedBonuses)
		increaseElementData(client, 'bonus.uses', 1)

		updatePlayerAchievments( client )

		local currentTime = Config.bonuses[bonus].time
		local hours = math.ceil(currentTime/3600)

		client:setData('bonus.current', bonus)
		client:setData('bonus.current_time', currentTime)

		exports['hud_notify']:notify(client, string.format('Отыграйте %s %s',
			hours, getWordCase(hours, 'час', 'часа', 'часов')
		), 'Чтобы получить бонус')

		exports.logs:addLog(
			'[BONUS][ENTER]',
			{
				data = {
					player = client.account.name,
					bonus = bonus,
				},	
			}
		)

	end
	addEvent('freeroam.useBonus', true)
	addEventHandler('freeroam.useBonus', resourceRoot, useBonus)



------------------------------------------------------------------------------------------------------

	addCommandHandler('bonus_usage', function(player, _, bonus_name)

		if exports.acl:isAdmin(player) then
			local count = 0

			for _, account in pairs( getAccounts() ) do

				local used = account:getData('bonus.used')
				if used then

					local used_tbl = fromJSON( used or '[[]]' ) or {}
					if used_tbl[bonus_name] then
						count = count + 1
					end

				end

			end

			outputChatBox(string.format('Бонус-код %s использован %s раз',
				bonus_name, count
			), player)
		end

	end)

------------------------------------------------------------------------------------------------------