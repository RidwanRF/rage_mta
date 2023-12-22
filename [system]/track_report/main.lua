
---------------------------------------------------------------------------

	loadstring( exports.core:include('common') )()

---------------------------------------------------------------------------

	local logs = dbConnect('sqlite', ':databases/logs.db')
	local jobs_tracking = dbConnect('sqlite', ':databases/jobs_tracking.db')
	local vehicles_db = dbConnect('sqlite', ':databases/vehicles.db')

---------------------------------------------------------------------------

	local cached_accounts = {}
	function hasAccountGroups( login )

		if cached_accounts[login] ~= nil then
			return cached_accounts[login]
		end

		cached_accounts[login] = not not exports.acl:hasAccountGroups( getAccount( login ) )
		return cached_accounts[login]

	end

---------------------------------------------------------------------------

	function getTagData(tag, period)

		local data = dbPoll( dbQuery( logs,
			('SELECT * FROM logs WHERE timestamp>%s AND timestamp<%s AND tag="%s";'):format( period.start, period.finish, tag )
		), -1 )

		return data

	end

	function getJobData(period)

		local data = dbPoll( dbQuery( jobs_tracking,
			('SELECT * FROM jobs_tracking WHERE timestamp>%s AND timestamp<%s AND session>300;'):format( period.start, period.finish )
		), -1 )

		return data

	end

---------------------------------------------------------------------------

	local actual_process_list = {}
	local timeout = 100

	function createProcess( func, data )
		table.insert( actual_process_list, { func = func, data = data } )
	end

	function processQueue()

		local process = actual_process_list[1]

		if process then

			if process.data and process.data.name then
				print(getTickCount(  ), ('processing %s'):format(process.data.name))
			end

			process.func( process.data )
			table.remove( actual_process_list, 1 )

		end

		setTimer(processQueue, timeout, 1)

	end

	function isProcessQueueFree()
		return #actual_process_list <= 0
	end

	setTimer(processQueue, timeout, 1)

---------------------------------------------------------------------------

	function createReport(period, out_file, callback)

		if not isProcessQueueFree() then return end

		local tick_start = getTickCount(  )

		local report = {}

		local time = getRealTime()
		local time_from = getRealTime( period.start )
		local time_to = getRealTime( period.finish )

		report.info = {

			report_created = ('%02d.%02d.%s %02d:%02d:%02d'):format(
				time.monthday, time.month + 1, time.year+1900,
				time.hour, time.minute, time.second
			),

			time_from = ('%02d.%02d.%s %02d:%02d:%02d'):format(
				time_from.monthday, time_from.month + 1, time_from.year+1900,
				time_from.hour, time_from.minute, time_from.second
			),

			time_to = ('%02d.%02d.%s %02d:%02d:%02d'):format(
				time_to.monthday, time_to.month + 1, time_to.year+1900,
				time_to.hour, time_to.minute, time_to.second
			),

		}

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local convert_data = getTagData('[FREEROAM][DONATECONVERT]', period)

				local sum = 0
				local k_top = {}

				for _, row in pairs( convert_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						sum = sum + data.count

						k_top[ data.player ] = k_top[ data.player ] or { amount = 0, converts = 0 }
						k_top[ data.player ].amount = k_top[ data.player ].amount + data.count
						k_top[ data.player ].converts = k_top[ data.player ].converts + 1

					end

				end

				local top = {}

				for player, p_data in pairs( k_top ) do
					table.insert(top, { player = player, amount = p_data.amount, converts = p_data.converts })
				end

				table.sort(top, function( a,b )
					return a.amount > b.amount
				end)

				top = table.slice( top, 0, 10 )

				local average = math.floor( sum / #convert_data )

				report[data.name] = {

					total = sum,
					average = average,

					total_players = getTableLength(k_top),

					top = top,

				}

			end, { report = report, name = 'donate_convert' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local packs_data = getTagData('[FREEROAM][PACK]', period)

				local sum = 0
				local total_uses = 0
				local k_packs = {}

				for _, row in pairs( packs_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						sum = sum + data.cost

						k_packs[ data.pack ] = k_packs[ data.pack ] or { total = 0, uses = 0 }
						k_packs[ data.pack ].total = k_packs[ data.pack ].total + data.cost

						if data.cost > 0 then
							total_uses = total_uses + 1
							k_packs[ data.pack ].uses = k_packs[ data.pack ].uses + 1
						end

					end

				end

				local bestsellers = {}

				for pack_id, p_data in pairs( k_packs ) do
					table.insert(bestsellers, { pack_id = pack_id, total = p_data.total, uses = p_data.uses })
				end

				table.sort(bestsellers, function( a,b )
					return a.total > b.total
				end)

				report[data.name] = {

					total = sum,
					uses = total_uses,

					bestsellers = bestsellers,

				}
				
			end, { report = report, name = 'packs' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local cars_data = getTagData('[CARSHOP][BUY]', period)

				local sum = 0
				local total_bought = 0
				local k_cars = {}

				for _, row in pairs( cars_data ) do

					local data = loadstring(('return %s'):format(row.data))()

					if data then

						data = data.data

						if not hasAccountGroups( data.player ) then

							sum = sum + data.cost

							local car_name = exports.vehicles_main:getVehicleModName(data.model)

							k_cars[ car_name ] = k_cars[ car_name ] or { total = 0, bought = 0 }
							k_cars[ car_name ].total = k_cars[ car_name ].total + data.cost

							if data.cost > 0 then
								total_bought = total_bought + 1
								k_cars[ car_name ].bought = k_cars[ car_name ].bought + 1
							end

						end
						
					end


				end

				local bestsellers = {}

				for car_name, p_data in pairs( k_cars ) do
					table.insert(bestsellers, { car_name = car_name, total = p_data.total, bought = p_data.bought })
				end

				table.sort(bestsellers, function( a,b )
					return a.total > b.total
				end)

				local k_database_total = {}
				local vehicles_result = dbPoll( dbQuery( vehicles_db, 'SELECT * FROM vehicles;' ), -1 )

				for _, row in pairs( vehicles_result ) do

					if row.owner ~= '--used--' and not hasAccountGroups( row.owner ) then

						local vehicle_name = exports.vehicles_main:getVehicleModName( row.model )
						k_database_total[vehicle_name] = (k_database_total[vehicle_name] or 0) + 1

					end

				end

				local database_total = {}

				for name, count in pairs( k_database_total ) do
					table.insert(database_total, { name = name, count = count })
				end

				table.sort(database_total, function( a,b )
					return a.count > b.count
				end)

				report[data.name] = {

					total = sum,
					bought = total_bought,

					bestsellers = bestsellers,

					database_total = database_total,

				}

			end, { report = report, name = 'cars' })


		---------------------------------

			createProcess(function( data )

				local report = data.report
				
				local bonuses_data = getTagData('[BONUS][ENTER]', period)

				local total_uses = 0
				local k_bonuses = {}

				for _, row in pairs( bonuses_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						k_bonuses[ data.bonus ] = k_bonuses[ data.bonus ] or { uses = 0 }

						total_uses = total_uses + 1
						k_bonuses[ data.bonus ].uses = k_bonuses[ data.bonus ].uses + 1

					end

				end

				local bonuses_used = {}

				for bonus, p_data in pairs( k_bonuses ) do
					table.insert(bonuses_used, { bonus = bonus, uses = p_data.uses, })
				end

				table.sort(bonuses_used, function( a,b )
					return a.uses > b.uses
				end)

				report[data.name] = {

					uses = total_uses,
					bonuses_used = bonuses_used,

				}

			end, { report = report, name = 'bonuses' })

		---------------------------------

			createProcess(function( data )

				local report = data.report
					
				local referal_data = getTagData('[REFERAL][ENTER]', period)

				local total_uses = 0
				local k_referal = {}

				for _, row in pairs( referal_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					local code_data = exports.main_freeroam:getCodeData( data.code )
					local code_owner = code_data and code_data.owner or data.code

					if not hasAccountGroups( data.player ) then

						k_referal[ data.code ] = k_referal[ data.code ] or { uses = 0, owner = code_owner }
						k_referal[ data.code ].uses = k_referal[ data.code ].uses + 1

						total_uses = total_uses + 1

					end

				end

				local referals_top = {}

				for owner, c_data in pairs( k_referal ) do
					if c_data.uses > 1 then
						table.insert(referals_top, { code = c_data.code, owner = c_data.code ~= owner and owner or nil, uses = c_data.uses, })
					end
				end

				table.sort(referals_top, function( a,b )
					return a.uses > b.uses
				end)

				report[data.name] = {
					total_uses = total_uses,
					referals_top = referals_top,
				}

			end, { report = report, name = 'referals' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local refdonate_data = getTagData('[REFERAL][DONATION]', period)

				local k_refdonate = {}

				for _, row in pairs( refdonate_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					k_refdonate[ data.player ] = k_refdonate[ data.player ] or { sum = 0 }
					k_refdonate[ data.player ].sum  = k_refdonate[ data.player ].sum + data.amount

				end

				local refdonate_top = {}

				for owner, c_data in pairs( k_refdonate ) do
					table.insert(refdonate_top, { owner = owner, amount = c_data.sum, })
				end

				table.sort(refdonate_top, function( a,b )
					return a.amount > b.amount
				end)

				report[data.name] = {
					top = refdonate_top,
				}

			end, { report = report, name = 'refdonate' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local total_sum = 0

				report[data.name] = {}

				for key, donate_data in pairs( {
					donation = getTagData('[DONATION]', period),
					complect = getTagData('[DONATION][COMPLECT]', period),
				} ) do

					local section_sum = 0

					for _, row in pairs( donate_data ) do

						local data = loadstring(('return %s'):format(row.data))().data

						if not hasAccountGroups( data.player ) then
							section_sum = section_sum + data.sum
							total_sum = total_sum + data.sum
						end

					end

					report[data.name][ key ] = section_sum

				end

				report[data.name].total = total_sum

			end, { report = report, name = 'donations' })

		---------------------------------

			createProcess(function( data )

				local report = data.report
				
				local quit_data = getTagData('[QUIT]', period)

				local visitors = {}
				local total_session = 0

				for _, row in pairs( quit_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						visitors[ data.player ] = visitors[ data.player ] or { session = 0 }
						visitors[ data.player ].session = visitors[ data.player ].session + data.session

						total_session = total_session + data.session

					end

				end

				local played_more_config = {20, 30, 60, 120}
				local played_more = {}

				for login, data in pairs( visitors ) do

					for _, min in pairs( played_more_config ) do

						if data.session >= min*60 then
							played_more[min] = (played_more[min] or 0) + 1
						end

					end

				end

				local registrations = 0
				local miss_registrations = 0

				for _, account in pairs( getAccounts() ) do

					local reg_date = account:getData('unique.register_date')
					if reg_date and isBetween(reg_date, period.start, period.finish ) then

						registrations = registrations + 1

						local seconds_played = account:getData('xp') or 0
						if math.floor( seconds_played/60 ) < 30 then
							miss_registrations = miss_registrations + 1
						end

					end

				end

				local tutorial_finished = #getTagData('[TUTORIAL][COMPLETE]', period)
				local tutorial_canceled = #getTagData('[TUTORIAL][CANCEL]', period)

				report[data.name] = {

					unique = getTableLength( visitors ),
					total = #quit_data,

					average_session_minutes = math.floor( ( total_session/#quit_data )/60 ),

					played_more = played_more,

					total_accounts = #getAccounts(),

					registrations = registrations,
					miss_registrations = miss_registrations,
					
					tutorial_finished = tutorial_finished,
					tutorial_canceled = tutorial_canceled,

				}


			end, { report = report, name = 'visits' })

		---------------------------------

			createProcess(function( data )

				local report = data.report
				
				local unactivesConfig = { 1, 3, 5, 7, 10, 20 }
				local unactives = {}

				local promo_activity = {}

				local realTime = getRealTime().timestamp

				for _, account in pairs( getAccounts() ) do

					local lastSeen = account:getData('lastSeen')

					if lastSeen then

						local unactive_days = math.floor( ( realTime - lastSeen )/86400 )

						for _, amount in pairs( table.reverse(unactivesConfig) ) do

							if unactive_days >= amount then
								unactives[amount] = ( unactives[amount] or 0 ) + 1
								break
							end

						end

						local promo = account:getData('referal.entered_code') or 'NO_PROMO'
						if promo then

							promo_activity[promo] = ( promo_activity[promo] or { active = 0, unactive = 0, dead = 0, total = 0 } )
							promo_activity[promo].total = promo_activity[promo].total + 1

							if unactive_days >= 14 then
								promo_activity[promo].dead = promo_activity[promo].dead + 1
							elseif unactive_days >= 5 then
								promo_activity[promo].unactive = promo_activity[promo].unactive + 1
							else
								promo_activity[promo].active = promo_activity[promo].active + 1
							end

						end

					end

				end

				local promo_activity_top = {}

				for promo, data in pairs( promo_activity ) do
					table.insert(promo_activity_top, { promo = promo, data = data, })
				end

				table.sort(promo_activity_top, function( a,b )
					return a.data.total > b.data.total
				end)

				promo_activity_top = table.slice( promo_activity_top, 1, 15 )

				report[data.name] = {

					unactive = unactives,
					promo_activity = promo_activity_top,

				}


			end, { report = report, name = 'activity' })

		---------------------------------


			createProcess(function( data )

				local report = data.report

				local vip_data = getTagData('[FREEROAM][BUY_VIP]', period)

				local sum = 0
				local k_vip = {}

				for _, row in pairs( vip_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						sum = sum + data.cost

						k_vip[ data.days ] = k_vip[ data.days ] or { total = 0 }
						k_vip[ data.days ].total = k_vip[ data.days ].total + data.cost


					end

				end

				local bestsellers = {}

				for days, v_data in pairs( k_vip ) do
					table.insert(bestsellers, { days = days, total = v_data.total })
				end

				table.sort(bestsellers, function( a,b )
					return a.total > b.total
				end)

				report[data.name] = {

					total = sum,
					bestsellers = bestsellers,

				}

			end, { report = report, name = 'vip' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local shop_data = getTagData('[FREEROAM][BUYSHOPITEM]', period)

				local sum = 0
				local k_shop = {}

				for _, row in pairs( shop_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if data.item_name and not hasAccountGroups( data.player ) then

						sum = sum + data.cost

						k_shop[ data.item_name ] = k_shop[ data.item_name ] or { total = 0 }
						k_shop[ data.item_name ].total = k_shop[ data.item_name ].total + data.cost


					end

				end

				local bestsellers = {}

				for name, s_data in pairs( k_shop ) do
					table.insert(bestsellers, { name = name, total = s_data.total })
				end

				table.sort(bestsellers, function( a,b )
					return a.total > b.total
				end)

				report[data.name] = {

					total = sum,
					bestsellers = bestsellers,

				}
				
			end, { report = report, name = 'donate_shop' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local sum_config = {
					['bank.rub'] = true,
					['money'] = true,
					['casino.chips'] = { mul = 90 },
					['bank.deposits'] = true,
				}

				local sum = {}
				local total = 0

				local accounts = {}

				for _, account in pairs( getAccounts() ) do

					if not hasAccountGroups( account.name ) then

						local account_data = {

							name = account.name,
							level = account:getData('level') or 0,

							total = 0,
						}

						for key, data in pairs( sum_config ) do

							local amount = (account:getData(key) or 0)

							if type(data) == 'table' then
								amount = amount * data.mul
							end

							total = total + amount
							sum[key] = (sum[key] or 0) + amount

							account_data[key] = (account_data[key] or 0) + amount
							account_data.total = (account_data.total or 0) + amount

						end

						table.insert( accounts, account_data )

					end


				end

				table.sort(accounts, function(a,b)
					return a.total > b.total
				end)

				local average = math.floor( total / #accounts )

				accounts = table.slice( accounts, 0, 100 )


				report[data.name] = {

					total = total,
					sum = sum,
					average = average,

					accounts = accounts,

				}

			end, { report = report, name = 'money' })

		---------------------------------

			createProcess(function( data )

				local report = data.report

				local sum_config = {
					['bank.donate'] = true,
				}

				local sum = {}
				local total = 0

				local accounts = {}

				for _, account in pairs( getAccounts() ) do

					if not hasAccountGroups( account.name ) then

						local account_data = {

							name = account.name,
							level = account:getData('level') or 0,

							total = 0,
						}

						for key in pairs( sum_config ) do

							local amount = (account:getData(key) or 0)

							total = total + amount
							sum[key] = (sum[key] or 0) + amount

							account_data[key] = (account_data[key] or 0) + amount
							account_data.total = (account_data.total or 0) + amount

						end

						table.insert( accounts, account_data )

					end


				end

				table.sort(accounts, function(a,b)
					return a.total > b.total
				end)

				local average = math.floor( total / #accounts )

				accounts = table.slice( accounts, 0, 100 )



				local donation_groups = {}

				local donation_groups_template = table.reverse({
					1000, 5000, 10000
				})

				for _, account in pairs( getAccounts() ) do

					if not hasAccountGroups( account.name ) then

						local donations = exports.web_main:getAccountDonations(account) or {}

						local sum = 0

						for _, donation in pairs( donations ) do
							sum = sum + (donation.sum or 0)
						end

						for _, value in pairs( donation_groups_template ) do

							if sum >= value then

								donation_groups[value] = donation_groups[value] or {}
								table.insert( donation_groups[value], { login = account.name, value = sum } )

								break

							end

						end

					end

				end

				for _, value in pairs( donation_groups_template ) do

					if donation_groups[value] then
						table.sort( donation_groups[value], function(a,b)
							return a.value > b.value
						end )
					end

				end

				report[data.name] = {

					total = total,
					sum = sum,
					average = average,

					accounts = accounts,

					groups = donation_groups,

				}

			end, { report = report, name = 'donate_stats' })

		---------------------------------


			createProcess(function( data )

				local report = data.report
			
				local jobs_data = getJobData(period)

				local k_jobs = {}

				local total_time = 0
				local total_sum = 0

				for _, row in pairs( jobs_data ) do

					local data = loadstring(('return %s'):format(row.data))()

					if not hasAccountGroups( row.account ) then

						data.money = data.money or 0
						data.money = data.vip and math.floor(data.money/1.5) or data.money

						total_sum = total_sum + data.money
						total_time = total_time + row.session


						k_jobs[ row.job ] = k_jobs[ row.job ] or { total = 0, session = 0 }

						k_jobs[ row.job ].total = k_jobs[ row.job ].total + (data.money or 0)
						k_jobs[ row.job ].session = k_jobs[ row.job ].session + (row.session or 0)

					end

				end

				local session_top = {}
				local money_top = {}

				for job, s_data in pairs( k_jobs ) do
					s_data.session = math.floor( (s_data.session)/3600 )
					table.insert(session_top, { job = job, total = s_data.total, session_hours = s_data.session })
					table.insert(money_top, { job = job, total = s_data.total, session_hours = s_data.session })
				end

				table.sort(session_top, function( a,b )
					return a.session_hours > b.session_hours
				end)

				table.sort(money_top, function( a,b )
					return a.total > b.total
				end)


				report[data.name] = {

					total_time_hours = math.floor( (total_time)/3600 ),
					total_sum = total_sum,

					session_top = session_top,
					money_top = money_top,

				}

			end, { report = report, name = 'jobs' })

		---------------------------------


			createProcess(function( data )

				local report = data.report

				local buy_data = getTagData('[CASINO][BUY]', period)
				local sell_data = getTagData('[CASINO][SELL]', period)

				local serverSum = { bought = 0, sold = 0, delta = 0 }
				local bought = {}
				local sold = {}
				local delta = {}

				for _, row in pairs( buy_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						serverSum.bought = serverSum.bought + data.cost
						serverSum.delta = serverSum.delta + data.cost

						bought[data.player] = bought[data.player] or { total = 0 }
						delta[data.player] = delta[data.player] or { total = 0 }

						bought[data.player].total = bought[data.player].total + data.cost
						delta[data.player].total = delta[data.player].total + data.cost


					end

				end

				for _, row in pairs( sell_data ) do

					local data = loadstring(('return %s'):format(row.data))().data

					if not hasAccountGroups( data.player ) then

						serverSum.sold = serverSum.sold + data.cost
						serverSum.delta = serverSum.delta - data.cost

						sold[data.player] = sold[data.player] or { total = 0 }
						delta[data.player] = delta[data.player] or { total = 0 }

						sold[data.player].total = sold[data.player].total + data.cost
						delta[data.player].total = delta[data.player].total - data.cost


					end

				end

				local t_bought = {}
				local t_sold = {}
				local t_delta = {}

				for name, s_data in pairs( delta ) do
					table.insert(t_delta, { name = name, total = s_data.total })
				end

				for name, s_data in pairs( sold ) do
					table.insert(t_sold, { name = name, total = s_data.total })
				end

				for name, s_data in pairs( bought ) do
					table.insert(t_bought, { name = name, total = s_data.total })
				end

				table.sort(t_delta, function( a,b )
					return a.total > b.total
				end)

				table.sort(t_bought, function( a,b )
					return a.total > b.total
				end)

				table.sort(t_sold, function( a,b )
					return a.total > b.total
				end)

				report[data.name] = {

					bought = table.slice( t_bought, 0, 100 ),
					sold = table.slice( t_sold, 0, 100 ),
					delta = table.slice( t_delta, 0, 100 ),
					sum = serverSum,

				}
				

			end, { report = report, name = 'casino' })

		---------------------------------

		createProcess(function( data )

			local report = data.report

			for section, data in pairs( report ) do

				local filepath = ':databases/report/' .. out_file .. '/' .. section .. '.report'
				if fileExists( filepath ) then fileDelete( filepath ) end

				local file = fileCreate( filepath )
				fileWrite( file, inspect(data):gsub('  ', '	') )

				fileClose( file )

			end

			local execution_time = getTickCount(  ) - tick_start
			print(getTickCount(  ), 'Report Succesfully Created', ('Time %sms'):format( execution_time ))

			if data.callback then
				data.callback( execution_time )
			end
			
		end, { report = report, callback = callback, name = 'writing file' })

		return true

	end

---------------------------------------------------------------------------

	function createCustomReport( time_from, time_to, callback )

		local report_name

		if time_from and time_to then

			report_name = ('%s_|_%s'):format(
				time_from, time_to
			)

		elseif time_from then

			report_name = ('%s'):format(
				time_from
			)

		end

		local timestamp_from = getTimestampFromString( time_from )
		local timestamp_to = time_to and (getTimestampFromString( time_to ) + 86400) or timestamp_from + 86400

		if not time_to then
			local time = getRealTime( timestamp_to )
			time_to = ('%02d-%02d-%02d'):format( time.monthday, time.month+1, time.year-100 )
		end
		
		return createReport( { start = timestamp_from, finish = timestamp_to }, report_name, callback)

	end

---------------------------------------------------------------------------

	addEventHandler('onServerDayCycle', root, function()

		local time = getRealTime()
		local prev_day = getRealTime( time.timestamp - 86400 - time.second - time.minute*60 - time.hour*3600 )

		createCustomReport( getStringFromTimestamp(prev_day.timestamp), nil, function()

			if time.weekday == 1 then

				createCustomReport(
					getStringFromTimestamp(prev_day.timestamp - 86400*6),
					getStringFromTimestamp(prev_day.timestamp + 86400)
				)

			end

		end )


	end)

---------------------------------------------------------------------------

	addCommandHandler('create_custom_report', function( player, _, time_from, time_to )

		if not exports.acl:isAdmin(player) then return end

		if not isProcessQueueFree() then
			return exports.chat_main:displayInfo( player, 'error, other reporting is being created now', {255,0,0} )
		end

		exports.chat_main:displayInfo( player, 'creating report...', {255,255,255} )

		createCustomReport( time_from, time_to, function(execution_time)
			exports.chat_main:displayInfo( player, ('create_custom_report succesfully, time %sms'):format( execution_time ), {255,255,255} )
		end )


	end)

---------------------------------------------------------------------------

	addCommandHandler('output_total_money', function( player )

		if not exports.acl:isAdmin(player) then return end

		createProcess(function( data )

			local sum_config = {
				['bank.rub'] = true,
				['money'] = true,
				['casino.chips'] = { mul = 90 },
				['bank.deposits'] = true,
			}

			local sum = {}
			local total = 0

			local accounts = {}

			for _, account in pairs( getAccounts() ) do

				if not hasAccountGroups( account.name ) then

					local account_data = {

						name = account.name,
						level = account:getData('level') or 0,

						total = 0,
					}

					for key, data in pairs( sum_config ) do

						local amount = (account:getData(key) or 0)

						if type(data) == 'table' then
							amount = amount * data.mul
						end

						total = total + amount
						sum[key] = (sum[key] or 0) + amount

						account_data[key] = (account_data[key] or 0) + amount
						account_data.total = (account_data.total or 0) + amount

					end

					table.insert( accounts, account_data )

				end


			end

			table.sort(accounts, function(a,b)
				return a.total > b.total
			end)

			local average = math.floor( total / #accounts )

			accounts = table.slice( accounts, 0, 100 )

			exports.chat_main:displayInfo( data.player, ('ТЕКУЩАЯ СУММА ДЕНЕГ НА СЕРВЕРЕ: %s'):format( splitWithPoints( total, '.' ) ), {0,255,0} )

		end, { player = player, name = 'money_output' })


	end)

---------------------------------------------------------------------------