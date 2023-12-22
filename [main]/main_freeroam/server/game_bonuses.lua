

------------------------------------------------------------

	exports.save:addParameter( 'game_bonuses', true, true )

------------------------------------------------------------

	local update_time = 60

------------------------------------------------------------

	function updateGameBonuses( player )

		local bonuses = player:getData('game_bonuses')

		if getTableLength(bonuses) > 0 then

			local active_notify = false
			local update_bonuses = false

			for id, box in pairs( bonuses ) do

				if box.time > 0 then

					box.time = math.max( box.time - update_time, 0 )
					box.update_time = getRealTime().timestamp

					update_bonuses = true

				elseif not box.received then

					active_notify = true

				end

			end

			if active_notify then
				exports.hud_notify:notify( player, 'Заберите бонус >> F1!', 'Награды - Бонусы за игру' )
			end

			if update_bonuses then
				player:setData('game_bonuses', bonuses)
			end

		else

			local bonuses_template = {}

			for _, box in pairs( Config.game_bonuses ) do

				bonuses_template[ box.id ] = {

					time = box.play_hours * 3600,
					update_time = getRealTime().timestamp,

				}

			end

			player:setData('game_bonuses', bonuses_template)

		end

	end

------------------------------------------------------------
	

	local prize_types = {

		vehicle = function( player, data )
			exports.vehicles_main:giveAccountVehicle( player.account.name, data.model )
		end,

		chips = function( player, data )
			increaseElementData( player, 'casino.chips', data.amount or 0 )
		end,

		pack = function( player, data )
			exports.main_freeroam:givePlayerPack( player, data.pack, data.amount )
		end,

		money = function( player, data )
			exports.money:givePlayerMoney( player, data.amount )
		end,

		vip = function( player, data )
			exports.main_vip:giveVip( player.account.name, data.amount )
		end,

		prison_ticket = function( player, data )
			increaseElementData( player, 'prison.tickets', data.amount )
		end,

		casino_default_ticket = function( player, data )
			increaseElementData( player, 'casino.default_tickets', data.amount )
		end,

		casino_vip_ticket = function( player, data )
			increaseElementData( player, 'casino.vip_tickets', data.amount )
		end,

		discount = function( player, data )
			addConvertPromo(player, nil, data.percent)
		end,

		inventory = function( player, data )

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = data.item,
				count = data.amount,
			})

		end,

	}

	function giveGameBonus( player, data )

		local func = prize_types[ data.type ]
		if func then func( player, data ) end

	end

------------------------------------------------------------

	function takeGameBonus( id )

		local bonuses = client:getData('game_bonuses') or {}

		local bonus = bonuses[id]
		if not bonus then return end

		if bonus.received then
			return exports.hud_notify:notify( client, 'Ошибка', 'Бонус уже получен' )
		end

		if bonus.time > 0 then
			return
		end

		bonus.received = true

		local prizes = Config.game_bonuses_assoc[ id ].rewards
		local prize = prizes[ math.random( #prizes ) ]

		giveGameBonus( client, prize.data )

		triggerClientEvent( client, 'freeroam.dispayGameBonusReceive', resourceRoot, prize )

		client:setData( 'game_bonuses', bonuses )

		exports.hud_notify:notify( client, 'Успешно', 'Вы забрали бонус' )

		exports.logs:addLog(
			'[GAME_BONUS][TAKE]',
			{
				data = {

					player = client.account.name,
					bonus = id,
					prize = prize.data,

				},	
			}
		)

	end
	addEvent('freeroam.takeGameBonus', true)
	addEventHandler('freeroam.takeGameBonus', resourceRoot, takeGameBonus)

------------------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		updateGameBonuses( source )

	end, true, 'low-100')

------------------------------------------------------------

	addCommandHandler('fr_update_gb', function( player, _, login )

		if exports.acl:isAdmin( player ) then

			local account = getAccount( login )

			if account and account.player then
				updateGameBonuses( account.player )
			end

		end

	end)

	addCommandHandler('fr_complete_gb', function( player, _, login )

		if exports.acl:isAdmin( player ) then

			local account = getAccount( login )

			if account and account.player then

				local bonuses = account.player:getData('game_bonuses')

				if bonuses then

					for _, bonus in pairs( bonuses ) do
						bonus.time = 0
						bonus.received = nil
					end

					account.player:setData('game_bonuses', bonuses)
					updateGameBonuses( account.player )

				end

				exports.chat_main:displayInfo( account.player, 'fr_complete_gb succesfully', {255,255,255} )


			end

		end

	end)

------------------------------------------------------------
	
	addEventHandler('onServerDayCycle', root, function()

		for _, account in pairs( getAccounts() ) do
			account:setData('game_bonuses', '[[]]')
		end

	end)

------------------------------------------------------------

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do

			updateGameBonuses( player )

		end

	end, update_time * 1000, 0)

------------------------------------------------------------
