

------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		if not source:getData('cyberquest.level') then

			source:setData('cyberquest.level', 0)
			source:setData('cyberquest.energy', 0)
			source:setData('cyberquest.ticket', 'default')

			-- triggerClientEvent( source, 'cyberquest.displayPreview', resourceRoot )

		end

	end, true, 'low-1000')

------------------------------------
	
	function updatePlayerLevel( player )

		local energy = player:getData('cyberquest.energy') or 0
		local level = getPlayerLevel( player )
		local new_level = math.clamp( level + 1, 0, #Config.levels )

		local to_next = getToNextLevel( player )

		if energy >= to_next and new_level > level then

			player:setData('cyberquest.level', new_level)

			if new_level == #Config.levels then
				player:setData('cyberquest.energy', getToNextLevel( player ))
			else
				player:setData('cyberquest.energy', math.max( energy - to_next, 0 ))
			end

			givePlayerLevelReward( player, new_level )

			exports.hud_notify:notify( player, 'CyberQuest', 'Вы получили уровень ' .. new_level )

		end

	end

------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if dn == 'cyberquest.energy' and new then
			updatePlayerLevel( source )
		end

	end)

------------------------------------


	local prize_types = {

		vehicle = function( player, data )
			exports.vehicles_main:giveAccountVehicle( player.account.name, data.model )
		end,

		status = function( player, data )
			exports.main_freeroam:giveStatus( player.account.name, data.status )
		end,

		chips = function( player, data )
			increaseElementData( player, 'casino.chips', data.amount or 0 )
		end,

		skin = function( player, data )

			local wardrobe = player:getData('wardrobe') or {}

			if wardrobe[ data.model ] or (player:getData('character.skin') == data.model) then

				if data.cost then

					exports.money:givePlayerMoney( player, data.cost )

					exports.chat_main:displayInfo( player, ('Скин из награды уже есть у вас, вместо этого вы получили $%s'):format(
						splitWithPoints( data.cost, '.' )
					), { 50, 255, 50 } )

				end

			else

				exports.main_clothes:addWardrobeClothes( player, data.model )

			end

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

		vip_ticket = function( player, data )

			if player:getData('cyberquest.ticket') ~= 'vip' then

				player:setData('cyberquest.level', 0)
				player:setData('cyberquest.energy', 0)

			end

			player.account:setData('cyberquest.completed', 1)
			setAccountVip( player.account.name, true )

		end,

		inventory = function( player, data )

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = data.item,
				count = data.amount,
			})

		end,

	}

	function giveCyberQuestPrize( player, data )

		local func = prize_types[ data.key ]
		if func then func( player, data ) end

	end

	
	function givePlayerLevelReward( player, level )

		if not player.account then return end

		local level_data = Config.levels[level]
		if not level_data then return end

		local prizes = {
			level_data.reward.default.prize
		}	

		if player:getData('cyberquest.ticket') == 'vip' then

			 if ( player.account:getData('cyberquest.completed') == 1 ) then
			 	prizes = {}	
			 end

			table.insert( prizes, level_data.reward.vip.prize )

		end

		for _, section in pairs( prizes ) do

			for _, reward in pairs( section ) do

				giveCyberQuestPrize( player, reward )

			end

		end

		exports.logs:addLog(
			'[CYBERQUEST][LEVEL][REWARD]',
			{
				data = {
					player = player.account.name,
					rewards = prizes,
					level = level,
				},	
			}
		)

	end

------------------------------------