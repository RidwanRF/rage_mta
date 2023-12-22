


----------------------------------------------------------------------------------------

	auctions = {}

----------------------------------------------------------------------------------------

	function generateAuctionId()
		return getTickCount()
	end

----------------------------------------------------------------------------------------

	function createAuction( x,y,z, item_id, time, ctr_index )

		local auction_id = generateAuctionId()

		local auction = {}

		local item = table.copy( Config.auction_items[item_id] )
		item.min_bet = math.random( unpack(item.min_bet) )

		auction.data = {
			item = item,
			players = {},
			time = math.floor(time/1000),
			bet = item.min_bet,
			start_time = getRealTime().timestamp,
		}

		auction.ctr_index = ctr_index

		auction.marker = createMarker( x,y,z, 'cylinder', 1.5, 255, 0, 0, 150 )

		if auction.ctr_index == 1 then
			auction.blip = createBlipAttachedTo( auction.marker, 0 )
			auction.blip:setData('icon', 'auction')
		end


		auction.timer = setTimer(finishAuction, time, 1, auction.marker)

		auctions[ auction.marker ] = auction

		updateAuctionData( auction.marker )

	end

----------------------------------------------------------------------------------------

	function updateAuctionData( marker )

		local auction = auctions[marker]
		if not auction then return end

		auction.marker:setData('auction.data', auction.data)

	end

----------------------------------------------------------------------------------------

	function getAuctionMaxBet( marker )

		local auction = auctions[marker]
		if not auction then return end

		local players = {}

		for player, bet in pairs( auction.data.players or {} ) do
			table.insert(players, { player = player, bet = bet })
		end

		table.sort(players, function(a,b)
			return a.bet > b.bet
		end)

		if players[1] then
			return players[1].player, players[1].bet
		end

	end

----------------------------------------------------------------------------------------

	function setAuctionBet( marker, bet )

		local auction = auctions[marker]
		if not auction then return end

		for _marker, _auction in pairs( auctions ) do
			if _auction.data and _auction.data.players[client] and _marker ~= marker then
				return exports.hud_notify:notify( client, 'Ошибка', 'Вы в другом аукционе' )
			end
		end

		if bet <= auction.data.bet then
			return exports.hud_notify:notify( client, 'Ошибка', 'Сумма меньше текущей' )
		end

		if bet > exports.money:getPlayerMoney( client ) then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно денег' )
		end

		if (bet - auction.data.bet) < auction.data.item.min_bet_delta then
			return exports.hud_notify:notify( client, 'Ошибка',
				'Ставка доступна от $' .. splitWithPoints( auction.data.bet + auction.data.item.min_bet_delta, '.' )
			)
		end

		if (bet - auction.data.bet) > auction.data.item.max_bet_delta then
			return exports.hud_notify:notify( client, 'Ошибка',
				'Ставка доступна до $' .. splitWithPoints( auction.data.bet + auction.data.item.max_bet_delta, '.' )
			)
		end

		auction.data.players[client] = bet
		auction.data.bet = bet
		auction.data.bet_player = client

		exports.hud_notify:notify( client, 'Успешно', 'Ставка принята' )

		updateAuctionData( marker )

	end
	addEvent('auction.setBet', true)
	addEventHandler('auction.setBet', resourceRoot, setAuctionBet)

----------------------------------------------------------------------------------------

	function leaveAuction( marker, _player )

		local auction = auctions[marker]
		if not auction then return end

		local player = _player or client

		exports.hud_notify:notify( player, 'Аукцион', 'Вы покинули аукцион' )

		auction.data = auction.data or {}
		if auction.data.winner == player then
			return takeAuctionPrize( marker, player )
		end

		auction.data.players[player] = nil

		local n_player, bet = getAuctionMaxBet( marker )

		if isElement(n_player) and bet then
			auction.data.bet = bet
			auction.data.bet_player = n_player
		end

		updateAuctionData( marker )

	end
	addEvent('auction.leave', true)
	addEventHandler('auction.leave', resourceRoot, leaveAuction)

----------------------------------------------------------------------------------------

	function finishAuction( marker )

		local auction = auctions[marker]
		if not auction then return end

		auction.data.finished = true

		local winner, bet = getAuctionMaxBet( marker )
		triggerClientEvent(root, 'auction.blowCranMovie', resourceRoot, auction.ctr_index)

		if getTableLength( auction.data.players ) < 3 then

			for player in pairs( auction.data.players ) do
				exports.hud_notify:notify(player, 'Аукцион завершен', 'Мало участников')
			end

			return destroyAuction( marker )
			
		end

		if isElement(winner) then

			auction.data.winner = winner
			exports.money:takePlayerMoney(winner, auction.data.bet)

			auction.data.display_element = auction.data.item:create_display( Config.displayPosition[auction.ctr_index] )

			for _, player in pairs( getElementsByType('player') ) do

				if getDistanceBetween( marker, player ) < 100 then
					exports.chat_main:displayInfo( player, string.format('Аукцион завершен, победитель - ' .. winner.name), {100, 220, 0} )
				end

			end

			exports.logs:addLog(
				'[AUCTION][WIN]',
				{
					data = {
						bet = auction.data.bet,
						item = auction.data.items,
						winner = winner.account.name,
					},	
				}
			)

		else

			return destroyAuction( marker )

		end

		updateAuctionData( marker )

	end

----------------------------------------------------------------------------------------

	function takeAuctionPrize( marker, _player )

		local auction = auctions[marker]
		if not auction then return end

		local player = _player or client

		auction.data.item:give( player )
		exports.hud_notify:notify(player, 'Аукцион',
			'Вы получили ' .. auction.data.item.name
		)

		exports.logs:addLog(
			'[AUCTION][TAKE]',
			{
				data = {
					player = player.account.name,
					item = auction.data.item,
				},	
			}
		)

		destroyAuction( marker )

	end
	addEvent('auction.takePrize', true)
	addEventHandler('auction.takePrize', resourceRoot, takeAuctionPrize)

----------------------------------------------------------------------------------------

	function sellAuctionPrize( marker )

		local auction = auctions[marker]
		if not auction then return end

		local player = client

		exports.money:givePlayerMoney(player, auction.data.item.sell_cost)
		exports.hud_notify:notify(player, 'Аукцион',
			'Вы получили $' .. splitWithPoints(auction.data.item.sell_cost, '.')
		)

		exports.logs:addLog(
			'[AUCTION][SELL]',
			{
				data = {
					player = player.account.name,
					item = auction.data.item,
				},	
			}
		)

		destroyAuction( marker )

	end
	addEvent('auction.sellPrize', true)
	addEventHandler('auction.sellPrize', resourceRoot, sellAuctionPrize)

----------------------------------------------------------------------------------------

	function destroyAuction( marker )

		local auction = auctions[marker]
		if not auction then return end

		clearTableElements( auction )

	end

----------------------------------------------------------------------------------------

	function leaveAuction_handler()

		for marker, auction in pairs( auctions ) do

			if auction.data and auction.data.players[source] then
				leaveAuction(marker, source)
			end

		end

	end

	addEventHandler('onPlayerQuit', root, leaveAuction_handler)
	addEventHandler('onPlayerWasted', root, leaveAuction_handler)

----------------------------------------------------------------------------------------

	setTimer(function()

		for marker, auction in pairs( auctions ) do

			if auction.data then

				for player in pairs( auction.data.players or {} ) do

					if isElement(player) and getDistanceBetween( player, marker ) > 50 then
						leaveAuction( marker, player )
					end

				end

			end

		end

	end, 10000, 0)

----------------------------------------------------------------------------------------
