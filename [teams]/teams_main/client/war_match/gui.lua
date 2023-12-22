

---------------------------------------------

	local warMatch_anim = {}
	setAnimData(warMatch_anim, 0.1, 0)

---------------------------------------------

	function renderWarMatch()

		local animData, target = getAnimData( warMatch_anim )
		if target == 0 and animData < 0.01 then
			return removeEventHandler('onClientRender', root, renderWarMatch)
		end


		local match_data = localPlayer:getData('team.match.data')
		if not match_data then return end

		local timestamp = getServerTimestamp()

		local match_time = Config.war_maps[ match_data.map_id ].time

		local t_balance = (match_time/1000) - (timestamp.timestamp - match_data.started)
		t_balance = math.max( 0, t_balance )

		local m = math.floor( t_balance/60 )
		local s = math.floor( t_balance - m*60 )

		dxDrawTextShadow(('%02d:%02d'):format(m,s),
			0, 10, sx, 10,
			tocolor(255,255,255,255*animData),
			0.5, getFont('montserrat_semibold', 34, 'light'),
			'center', 'top', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
		)

		local local_count = match_data[ match_data.match_team..'_count' ]
		local opponents_count = match_data[ ( match_data.match_team == 'attackers' and 'defenders' or 'attackers' )..'_count' ]

		if match_data.mode == 2 then

			dxDrawTextShadow('Захват базы',
				0, 45, sx, 45,
				tocolor(255,255,255,255*animData),
				0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'center', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
			)

			local progress = match_data.base:getData('capture.progress') or 0

			local rw,rh = 150, 5
			local rx,ry = sx/2 - rw/2, 60

			dxDrawRectangle(
				rx,ry,rw,rh, tocolor(21,21,33,255*animData)
			)

			dxDrawRectangle(
				rx,ry,rw*( progress/100 ),rh, tocolor(180,70,70,255*animData)
			)

		else

			dxDrawTextShadow(match_data.mode == 1 and 'Счёт' or 'Игроки',
				0, 45, sx, 45,
				tocolor(255,255,255,255*animData),
				0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'center', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
			)

			dxDrawTextShadow(local_count,
				sx/2 - 20, 70, sx/2 - 20, 70,
				tocolor(255,255,255,255*animData),
				0.5, getFont('montserrat_semibold', 50, 'light'),
				'right', 'center', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
			)

			dxDrawTextShadow(opponents_count,
				sx/2 + 20, 70, sx/2 + 20, 70,
				tocolor(255,255,255,255*animData),
				0.5, getFont('montserrat_semibold', 50, 'light'),
				'left', 'center', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
			)

			if opponents_count ~= local_count then

				local add = 2

				local w,h = 15,15
				dxDrawImage(
					sx/2-w/2, 70 - h/2+add,
					w,h, 'assets/images/arrown.png',
					opponents_count > local_count and 0 or 180, 0, 0, tocolor(255,255,255,255*animData)
				)

			else

				dxDrawTextShadow('=',
					0, 70, sx, 70,
					tocolor(255,255,255,255*animData),
					0.5, getFont('montserrat_semibold', 40, 'light'),
					'center', 'center', 1, tocolor(0, 0, 0, 20*animData), _, dxDrawText
				)

			end

		end

		renderWarTab( animData )


	end

	function convertBlipPosition(x,y, mapSize)
		return (x+3000)/6000*mapSize, (-y+3000)/6000*mapSize
	end

	-- function renderWarMap( animData )

	-- 	local match_data = localPlayer:getData('team.match.data')
	-- 	if not match_data then return end

	-- 	local map = Config.war_maps[ match_data.map_id ]
	-- 	local cx,cy,cw,ch = unpack( map.colshape )

	-- 	cw,ch = cw/2,ch/2

	-- 	local w,h = cw,ch
	-- 	local x,y = 20, ( real_sy - px(h) - px(20) ) * sx/real_sx

	-- 	mta_dxDrawRectangle(
	-- 		px(x)-1, px(y)-1, px(w)+2, px(h)+2,
	-- 		tocolor(0,0,0,255*animData)
	-- 	)


	-- 	radarTexture = isElement(radarTexture) and radarTexture or exports.hud_radar:getRadarTexture()
	-- 	roundTexture = isElement(roundTexture) and roundTexture or exports.core:getTexture('round')

	-- 	local ox,oy = convertBlipPosition( cx,cy+ch*2, 3000 )

	-- 	dxDrawImageSection(
	-- 		x,y,w,h,
	-- 		ox,oy, w,h,
	-- 		radarTexture,
	-- 		0, 0, 0, tocolor( 255,255,255,255*animData )
	-- 	)

	-- 	local bw,bh = 15,15

	-- 	for team_name, team in pairs( match_data.players ) do

	-- 		local r,g,b = 230,90,90

	-- 		if team_name == match_data.match_team then
	-- 			r,g,b = 90,230,90
	-- 		end

	-- 		for player in pairs( team ) do

	-- 			if player == localPlayer then
	-- 				r,g,b = 50,150,250
	-- 			end

	-- 			local plx,ply = getElementPosition( player )
	-- 			local pbx,pby = convertBlipPosition( plx,ply, 3000 )
	-- 			pbx,pby = pbx - ox, pby - oy

	-- 			dxDrawImage(
	-- 				x + pbx - bw/2, y + pby - bh/2,
	-- 				bw,bh, roundTexture,
	-- 				0, 0, 0, tocolor(r,g,b, 255*animData)
	-- 			)



	-- 		end

	-- 	end

	-- end

---------------------------------------------

	function renderWarTab( animData )

		if getKeyState('tab') then

			local match_data = localPlayer:getData('team.match.data')
			if not match_data then return end

			local w,h = 800, 470
			local x,y = sx/2 - w/2, (( real_sy ) * sx/real_sx)/2 - h/2

			dxDrawRectangle(
				x,y,w,h, tocolor( 25,24,38,255*animData )
			)

			local th = 70

			dxDrawRectangle(
				x,y,w/2,th, tocolor( 50,80,50,255*animData )
			)

			dxDrawRectangle(
				x+w/2,y,w/2,th, tocolor( 80,50,50,255*animData )
			)

			dxDrawText('Союзники',
				x, y, x+w/2, y+th,
				tocolor(255,255,255,255*animData),
				0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'center'
			)

			dxDrawText('Противники',
				x+w/2, y, x+w, y+th,
				tocolor(255,255,255,255*animData),
				0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'center'
			)

			local players = { attackers = {}, defenders = {} }

			for team_name, team in pairs( match_data.players ) do

				for player in pairs( team ) do

					if isElement(player) then
						table.insert( players[team_name], { player = player, kills = getPlayerMatchKills( player ) } )
					end

				end

				table.sort( players[team_name], function(a,b)

					return a.kills.kills > b.kills.kills

				end )

			end

			local ry = y+th

			local rw,rh = w/2,40

			for index = 1, 10 do

				for team_name, team in pairs( players ) do

					local data = team[index]

					local rr,rg,rb = 21,21,33
					local rx = x+(team_name == match_data.match_team and 0 or w/2)

					if (index % 2) == 0 then
						rr,rg,rb = 25,25,38
					end

					dxDrawRectangle(
						rx,ry,rw, rh, tocolor(rr,rg,rb,255*animData)
					)


					if data and isElement(data.player) then

						dxDrawText(data.player.name,
							rx + 20, ry,
							rx + 20, ry+rh,
							tocolor(255,255,255,255*animData),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'center'
						)

						dxDrawText(('%s уб. / %s см.'):format(data.kills.kills, data.kills.deaths),
							rx + rw - 20, ry,
							rx + rw - 20, ry+rh,
							tocolor(255,255,255,255*animData),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'right', 'center'
						)

					end


				end

				ry = ry + rh

			end

			dxDrawRectangle(
				x+w/2-1, y+th, 2, h-th, tocolor(100,100,100,255*animData)
			)



		end

	end

---------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn,old,new)

		if dn == 'team.match.data' then

			if new then

				addEventHandler('onClientRender', root, renderWarMatch)
				animate(warMatch_anim, 1)
				-- showChat( false )

			else

				animate(warMatch_anim, 0)
				-- showChat( true )

			end

		end

	end)

---------------------------------------------