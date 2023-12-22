local BETS = { }
local OFFLINE_BETS = { }

function StartBetTimer ( conf )
	if BETS [ client.account.name ] then
		client:ShowError ( 'У вас уже идет ставка' )
		return
	end

	if not client:HasMoney ( conf.bet ) then
		client:ShowError ( 'Недостаточно средств' )
		return
	end

	local time = conf.time * 60000

	local bet_data = {
		player = client;
		accName = client.account.name;
		time = conf.time;
		bet = conf.bet;
		crypt = conf.crypt;
		type = conf.type or 1;
	}

--	Timer(UpdateCourse, time, 1, 'Btc')
	bet_data.timer = Timer ( CheckBetTimer, time, 1, client, bet_data )
	BETS [ client.account.name ] = bet_data
	--client:setData ( 'bet_data', bet_data, false );

	client:ShowInfo ( 'Ставка принята!' )
end
addEvent ( 'StartBetTimer', true )
addEventHandler ( 'StartBetTimer', resourceRoot, StartBetTimer )

function OnQuit ( )
	if BETS [ source.account.name ] then
		local bet = BETS [ source.account.name ].bet
		source:GiveMoney ( bet )
		if isTimer ( BETS [ source ].timer ) then killTimer ( BETS [ source ].timer ) end
		BETS [ source ] = { }
	end
end
addEventHandler ( 'onPlayerQuit', root, OnQuit )

function CheckBetTimer ( player, bet )
	if isElement ( player ) then
		local bet = bet or BETS [ player ]
		if bet.player ~= player then return end
		if not bet then return end
		if LAST_CHANGED_CRYPT ~= bet.crypt then
			player:ShowError ( 'Ваша ставка не зашла' )
			BETS [ player.account.name ] = nil
			return
		end
		local data = GetCryptData ( bet.crypt )
		if not data then return end
		local change_time = data.change_time or 0
		local timestamp = getRealTime().timestamp
		local change_course = data.change_course or 0
		if change_time + 10 >= timestamp then
			local type = bet.type or 1
			if type == 1 then
			--	iprint(data.change_course)
				if change_course > 0 then -- если курс вверх
					player:ShowInfo ( ( 'Твоя ставшка зашла!\nТы выиграл %s$' ):format ( bet.bet * 2 ) )
					player:GiveMoney ( bet.bet * 2 )
				else -- если нет
					player:ShowInfo ( 'Твоя ставка не зашла\nТы проиграл: '..bet.bet..'$' )
				end
			elseif type == 2 then
				if change_course < 0 then -- если курс вниз
					player:ShowInfo ( ( 'Твоя ставшка зашла!\nТы выиграл %s$' ):format ( bet.bet * 2 ) )
				else
					player:ShowInfo ( 'Твоя ставка не зашла\nТы проиграл: '..bet.bet..'$' )
				end
			else -- или
				player:ShowInfo ( 'Твоя ставка не зашла\nТы проиграл: '..bet.bet..'$' )
			end
		else -- если время не совпадает
			player:ShowInfo ( 'Твоя ставка не зашла\nТы проиграл: '..bet.bet..'$' )
		end
		BETS [ player.account.name ] = nil
	end
end

addEventHandler ( 'onResourceStop', resourceRoot, function ( )
	for i, v in pairs ( BETS ) do
		if isElement ( v.player ) then
			v.player:GiveMoney ( v.bet )
			BETS [ v.player.account.name ] = nil
			v.player:ShowInfo ( '[Crypt] Ресурс был остановлен\nсервером, ваша ставка возвращена.' )
		end
	end
end )