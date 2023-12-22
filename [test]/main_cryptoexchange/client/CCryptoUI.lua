local hover = { bet = { } }
hover.left = { }
hover.right = { }


function ShowUI ( state )
	if state then
		ShowUI ( false );
		showCursor ( true );
		showChat ( false );


		ui.bg = ibCreateImage ( 0, -110, scx, scy, nil, false, tocolor ( 25, 23, 38 ) ):ibData ( 'alpha', 0 ):ibAlphaTo ( 255, 1000 ):ibMoveTo ( _, 0, 1000 )

		local header = ibCreateImage ( 0, 0, scx, px(309), 'img/header.png', ui.bg )

		local balance_icon = ibCreateImage ( scx - px(100), px(13), px(86), px(86), 'img/money.png', header )
		local money = ibCreateLabel ( balance_icon:ibGetBeforeX (  ), px(40), 0, 0, splitWithPoints ( localPlayer:getData ( 'money' ) or 0, '.' )..' $', header, COLOR_WHITE, 1, 1, 'right', _, Font ( ) )
		:ibTimer ( function ( self ) 
			self:ibData ( 'text', splitWithPoints ( localPlayer:getData ( 'money' ) or 0, '.' )..' $' )
		end, 500, 0)

		local left_bg = ibCreateImage ( 0, px(110), px(300), scy-px(110), 'img/left_bg.png', ui.bg )
		ibCreateLabel ( px(45), 5, 0, 0, 'Курс', left_bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 14 ) )
		ibCreateLabel ( px(45), px(33), 0, 0, day..' '..month, left_bg, ibApplyAlpha ( COLOR_WHITE, 20 ), 1, 1, _, _, Font ( 'Regular', 9.9 ) )

		ui.selected_crypt = ibCreateImage ( 0, px(150), px(55), px(55), 'img/icons/btc.png', ui.bg ):center_x ( -px(70) )
		ui.selected_crypt_label = ibCreateLabel ( ui.selected_crypt:ibGetAfterX ( 10 ), px(160), 0, 0, 'BITCOIN', ui.bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 20 ) )


		-- cryptocurrencies
		hover.left.selected_item = 1
		hover.left.data = DATA [ Config.currencies[hover.left.selected_item].short_name ]
		hover.selected_crypt = 'Btc'

		local num = px(60)
		for i, v in pairs ( DATA ) do
			local name = v.name
			local id_data = GetTableFromName ( v.id ) or { }
			local short_name = id_data.short_name
			local russian_name = id_data.russian or ''

			ui [ 'hover_'..i ] = ibCreateImage ( 0, num + px(2), px(300), px(100), 'img/item_hover.png', left_bg ):ibData ( 'disabled', true ):ibData ( 'alpha', i == 'Btc' and 255 or 0 )
			ui.current_hover_image = ui [ 'hover_'..hover.left.selected_item ]
			local area = ibCreateArea ( 0, num, px(300), px(100), left_bg )
			local line = ibCreateImage ( 0, num, px(300), 2, 'img/item_line.png', left_bg ):ibData ( 'disabled', true )

			local icon = ibCreateImage ( px(35), px(20), px(45), px(45), 'img/icons/'..id_data.icon..'.png', area ):ibData ( 'disabled', true )

			local name_area = ibCreateArea ( px(25), px(70), px(80), px(20), area ):ibData ( 'disabled', true )
			ibCreateLabel ( 0, 0, px(70), px(20), utf8.upper ( name ), name_area, COLOR_WHITE, 1, 1, 'center', 'center', Font ( 'Bold', 10 ) ):ibData ( 'disabled', true )

			local course = ibCreateLabel ( px(280), px(70), 0, 0, ( '1 %s = %s' ):format ( utf8.upper ( short_name ), splitWithPoints ( math.ceil ( v.course ), '.' )..'$' ), area, COLOR_WHITE, 1, 1, 'right', _, Font ( 'Regular', 11 ) )

			area:ibOnHover ( function (  ) 
				if hover.left.selected_item ~= i then
					ui [ 'hover_'..i ]:ibAlphaTo ( 255, 500 )
				end
			end)
			:ibOnLeave ( function (  )
				if hover.left.selected_item ~= i then
					ui [ 'hover_'..i ]:ibAlphaTo ( 0, 500 )
				end
			end)

			:ibOnClick ( function ( key, state ) 
				if key == 'left' and state == 'down' then
					if ui [ 'hover_'..hover.left.selected_item ] then
						ui [ 'hover_'..hover.left.selected_item ]:ibAlphaTo ( 0, 500 )
					end
					hover.left.selected_item = i
					ui [ 'hover_'..hover.left.selected_item ]:ibAlphaTo ( 255, 500 )
					ui.selected_crypt:ibData ( 'texture', 'img/icons/'..id_data.icon..'.png' )
					ui.selected_crypt_label:ibData ( 'text', utf8.upper ( name ) )
					hover.left.data = v
				end
			end)

			num = num + px(100)
		end

		ibCreateImage ( 0, num, px(300), 2, 'img/item_line.png', left_bg ) -- последняя линия

		ibCreateLabel ( px(25), num + px(22), 0, 0, 'Обменник криптовалюты', left_bg, COLOR_WHITE, 1, 1, _, _, Font ( ) )
		ibCreateImage ( 0, num + px(70), px(300), 2, 'img/item_line.png', left_bg )

		local btn_get_sale = ibCreateCustomButton ( px(25), num + px(90), px(115), px(30), 'ПРОДАЖА', left_bg, 'img/exc_btn.png', 'img/exc_btn_h.png', _, Font ( 'Bold', 9 ) )
		local btn_get_buy = ibCreateCustomButton ( px(150), num + px(90), px(115), px(30), 'ПОКУПКА', left_bg, 'img/exc_btn.png', 'img/exc_btn_h.png', _, Font ( 'Bold', 9 ) )
		local selected_type = 2
		btn_get_buy:ibData ( 'texture', 'img/exc_btn_h.png' )

		btn_get_sale:ibOnClick ( function ( key, state ) 
			if key == 'left' and state == 'up' then
				local texture = btn_get_buy:ibData('texture')
				if texture == 'img/exc_btn_h.png' then
					btn_get_buy:ibData ( 'texture', 'img/exc_btn.png' )
				end
				btn_get_sale:ibData ( 'texture', 'img/exc_btn_h.png' )
				selected_type = 1
			end
		end)

		btn_get_buy:ibOnClick ( function ( key, state ) 
			if key == 'left' and state == 'up' then
				local texture = btn_get_sale:ibData('texture')
				if texture == 'img/exc_btn_h.png' then
					btn_get_sale:ibData ( 'texture', 'img/exc_btn.png' )
				end
				btn_get_buy:ibData ( 'texture', 'img/exc_btn_h.png' )
				selected_type = 2
			end
		end)

		ibCreateLabel ( px(30), num + px(135), 0, 0, 'Выберите счет пополнения:', left_bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 10 ) )

		local active_line = ibCreateImage ( px(250), num + px(175), px(23), px(23), 'img/selected.png', left_bg )

		hover.left.s_crypt = 'Btc'
		for i, v in pairs ( Config.currencies ) do
			local icon = 'img/icons/'..v.icon..'_round.png'

			ibCreateImage ( px(30), px(40) * ( i - 1 ) + num + px(170), px(218), px(30), 'img/exc_item_i.png', left_bg ):ibData ( 'disabled', true )
			local item = ibCreateImage ( px(30), px(40) * ( i - 1 ) + num + px(170), px(218), px(30), 'img/exc_item.png', left_bg )
			ibCreateImage ( 0, 0, px(30), px(30), icon, item ):ibData ( 'disabled', true )

			local value = localPlayer:GetCryptValue ( v.short_name ) or 0
			ibCreateLabel ( px(200), 7, 0, 0, splitWithPoints ( value )..' '..utf8.upper ( v.short_name ), item, COLOR_WHITE, 1, 1, 'right', _, Font ( 'Semibold', 10 ) ):ibData ( 'disabled', true )
			:ibTimer ( function ( self ) 
				local value = localPlayer:GetCryptValue ( v.short_name ) or 0
				self:ibData ( 'text', splitWithPoints ( value )..' '..utf8.upper ( v.short_name ) )
			end, 500, 0)

			item:ibOnHover ( function ( ) source:ibAlphaTo ( 155, 500 ) end )
			item:ibOnLeave ( function ( ) source:ibAlphaTo ( 255, 500 ) end )
			item:ibOnClick ( function ( key, state ) 
				if key == 'left' and state == 'up' then
					if v.short_name ~= hover.left.s_crypt then
						hover.left.s_crypt = v.short_name
						active_line:ibMoveTo ( _, item:ibData ( 'py' ) + 5 )
					end
				end
			end)
		end

		local edit_bg = ibCreateImage ( px(25), num + px(400), px(184), px(40), 'img/edit_bg.png', left_bg )
		local edit = ibCreateEdit ( 10, 0, px(edit_bg:width ( ) - 20), px(40), '', edit_bg, COLOR_WHITE, 0, COLOR_WHITE )
		:ibBatchData ( {
			font = Font ( 'Regular', 10 ),
			pretext = 'Кол-во крипты',
			only_number = true,
		} )

		local exchange_btn = ibCreateCustomButton ( px(220), num + px(400), px(40), px(40), '', left_bg, 'img/exchange.png' )
		:ibOnClick ( function ( key, state ) 
			if key == 'left' and state == 'up' then
	
				if not DATA [ hover.left.s_crypt ] then
					return iprint('not data')
				end
				local text = edit:ibData ( 'text' )
				if utf8.len ( text ) <= 0 or text == '' or text == 'Кол-во крипты' then return localPlayer:ShowError ( 'Введи количество\nкриптовалюты', 255, 0, 0 ) end
				text = tonumber(text)
				ibConfirm ( {
					text = ( 'Вы собираетесь %s %s %s\nза %s' ):format ( selected_type == 1 and 'Продать' or 'Купить', splitWithPoints ( tonumber ( text ) ), 
						DATA [ hover.left.s_crypt ].name or hover.left.s_crypt, splitWithPoints (  text *  DATA [ hover.left.s_crypt ].course or 123, ' ' )..' $' ),
					fn = function ( self )
						self:destroy ( )
						triggerServerEvent ( 'TransferCrypt', resourceRoot, selected_type, {
							id = hover.left.s_crypt or 'BTC',
							cost = tonumber ( text ),
							course = DATA [ hover.left.s_crypt ].value,
						} )
					end
				} )
			end
		end)

		local right_bg = ibCreateImage ( scx-px(300), px(110), px(300), scy-px(110), 'img/left_bg.png', ui.bg )

		do
			local selected_item = 1
			local num = px(60)
			for i, v in pairs ( Config.currencies ) do
				local name = v.name
				local short_name = v.short_name
				local russian_name = v.russian or ''

				local area = ibCreateArea ( 0, num, px(300), px(100), right_bg )
				local line = ibCreateImage ( 0, num, px(300), 2, 'img/item_line.png', right_bg ):ibData ( 'disabled', true )

				local icon = ibCreateImage ( px(35), px(20), px(45), px(45), 'img/icons/'..v.icon..'.png', area ):ibData ( 'disabled', true )

				local name_area = ibCreateArea ( px(25), px(70), px(80), px(20), area ):ibData ( 'disabled', true )
				ibCreateLabel ( 0, 0, px(70), px(20), utf8.upper ( name ), name_area, COLOR_WHITE, 1, 1, 'center', 'center', Font ( 'Bold', 10 ) ):ibData ( 'disabled', true )
				ibCreateLabel ( px(215), px(5), 0, 0, 'На балансе', area, tocolor ( 255, 255, 255, 55 ), 1, 1, _, _, Font ( 'Regular', 8 ) )
				ibCreateLabel ( px(215), px(50), 0, 0, 'В долларах', area, tocolor ( 255, 255, 255, 55 ), 1, 1, _, _, Font ( 'Regular', 8 ) )

				local balance = ibCreateLabel ( px(270), px(25), 0, 0, splitWithPoints ( localPlayer:GetCryptValue ( short_name ) )..' '..utf8.upper ( short_name ), area, COLOR_WHITE, 1, 1, 'right', _, Font ( 'Regular', 10 ) )

				local dollars_explode = ibCreateLabel ( px(270), px(67), 0, 0, splitWithPoints ( ExplodeValue ( short_name ) )..' $', area, tocolor ( 0, 255, 0 ), 1, 1, 'right', _, Font ( 'Regular', 10 ) )

				local function update ( )
					if not isElement ( ui.bg ) or not isElement ( right_bg ) then return end
					balance:ibData ( 'text', splitWithPoints ( localPlayer:GetCryptValue ( short_name ) )..' '..utf8.upper ( short_name ) )
					dollars_explode:ibData ( 'text', splitWithPoints ( ExplodeValue ( short_name ) )..' $' )
				end
				ui.BalanceUpdateTimer = Timer ( update, 500, 0 )

				num = num + px(100)
			end
			ibCreateImage ( 0, num, px(300), 2, 'img/item_line.png', right_bg ) -- последняя линия
			ibCreateLabel ( px(40), px(10), 0, 0, 'Ваш криптокошелёк:', right_bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 12.5 ) )

			--ui.get_plus_money = ibCreateLabel ( px(40), px(35), 0, 0, '(+0 $ за сутки)', right_bg, tocolor ( 0, 255, 0 ), 1, 1, _, _, Font ( 'Regular', 8 ) )

			ibCreateImage ( 0, num + px(70), px(300), 2, 'img/item_line.png', right_bg )
			ibCreateLabel ( px(25), num + px(22), 0, 0, 'Сумма ставки', right_bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 14 ) )

			ibCreateImage ( 0, num + px(145), px(300), 2, 'img/item_line.png', right_bg )

			local edit__bg = ibCreateImage ( px(40), num + px(90), px(222), px(40), 'img/edit_bg1.png', right_bg )
			ui.edit_get_bet = ibCreateEdit ( px(10), 0, px(200), px(40), '', edit__bg, COLOR_WHITE, 0, COLOR_WHITE )
			:ibBatchData ( {
				font = Font ( 'Regular', 10 ),
				pretext = 'Сумма ставки',
				only_number = true,
			} )

			ibCreateImage ( 0, num + px(200), px(300), 2, 'img/item_line.png', right_bg )
			ibCreateLabel ( px(25), num + px(161), 0, 0, 'Длительность ставки', right_bg, COLOR_WHITE, 1, 1, _, _, Font ( 'Semibold', 14 ) )
			ibCreateImage ( 0, num + px(265), px(300), 2, 'img/item_line.png', right_bg )

			
			hover.bet.bet_time = 1
			local bet_bg = ibCreateImage ( px(30), num + px(215), px(221), px(40), 'img/bet_bg.png', right_bg )

			local current_bet_time = ibCreateLabel ( 0, 0, px(221), px(40), hover.bet.bet_time..' мин.', bet_bg, COLOR_WHITE, 1, 1, 'center', 'center', Font ( 'Regular', 10 ) ):ibData ( 'disabled', true )

			local minus = ibCreateButton ( 0, 0, px(40), px(40), bet_bg, 'img/minus.png', _, _, _, tocolor ( 200, 200, 200 ) )

			local plus = ibCreateButton ( px(200), 0, px(40), px(40), bet_bg, 'img/plus.png', _, _, _, tocolor ( 200, 200, 200 ) )

			minus:ibOnClick ( function ( key, state ) 
				if key == 'left' and state == 'up' then
					if hover.bet.bet_time <= Config.min_bet_time then
						hover.bet.bet_time = Config.max_bet_time
					else
						hover.bet.bet_time = hover.bet.bet_time - 1
					end
					current_bet_time:ibData ( 'text', hover.bet.bet_time..' мин.' )
				end
			end)

			plus:ibOnClick ( function ( key, state ) 
				if key == 'left' and state == 'up' then
					if hover.bet.bet_time >= Config.max_bet_time then
						hover.bet.bet_time = Config.min_bet_time
					else
						hover.bet.bet_time = hover.bet.bet_time + 1
					end
					current_bet_time:ibData ( 'text', hover.bet.bet_time..' мин.' )
				end
			end)

			ibCreateCustomButton ( 0, num + px(330), px(222), px(56), '', right_bg, 'img/exit.png' ):center_x ( )
			:ibOnClick ( function ( key, state ) 
				if key == 'left' and state == 'up' then
					ShowUI ( false )
				end
			end)

		end

		local graphic_area = ibCreateArea ( left_bg:ibGetAfterX ( 5 ), px(110), scx - px(610), scy - px(330), ui.bg )

		local btn_down = ibCreateCustomButton ( 0, scy - px(200), px(275), px(80), '', ui.bg, 'img/down.png' ):center_x ( -px(185) )
		:ibOnClick ( function ( key, state ) 
			if key == 'left' and state == 'up' then
				local time = tonumber ( hover.bet.bet_time )
				local bet = ui.edit_get_bet:ibData ( 'text' )
				if bet == '' or bet == 'Сумма ставки' or utf8.len ( bet ) < 0 then
					localPlayer:ShowError ( 'Введи сумму ставки' )
					return
				end
				ibConfirm ( {
					text = ( 'Вы собираетесь поставить %s$ на %s, длительность ставки составит: %s'):format ( splitWithPoints ( tonumber ( bet ), ' ' ), hover.left.data.name, time..' мин.' ),
					fn = function ( self )
						self:destroy ( )
						triggerServerEvent ( 'StartBetTimer', resourceRoot, {
							time = time,
							bet = bet,
							crypt = hover.left.data.id,
							type = 2
						} )
					end
				} )
			end
		end)

		local btn_up = ibCreateCustomButton ( 0, scy - px(200), px(275), px(80), '', ui.bg, 'img/up.png' ):center_x ( px(150)  )
		:ibOnClick ( function ( key, state ) 
			if key == 'left' and state == 'up' then
				local time = tonumber ( hover.bet.bet_time )
				local bet = ui.edit_get_bet:ibData ( 'text' )
				if bet == '' or bet == 'Сумма ставки' or utf8.len ( bet ) < 0 then
					localPlayer:ShowError ( 'Введи сумму ставки' )
					return
				end
				ibConfirm ( {
					text = ( 'Вы собираетесь поставить %s$ на %s, длительность ставки составит: %s'):format ( splitWithPoints ( tonumber ( bet ), ' ' ), hover.left.data.name, time..' мин.' ),
					fn = function ( self )
						self:destroy ( )
						triggerServerEvent ( 'StartBetTimer', resourceRoot, {
							time = time,
							bet = bet,
							crypt = hover.left.data.id,
							type = 1
						} )
					end
				} )
			end
		end)

		ibCreateImage ( 0, 0, px(982), px(527), 'img/graphic_s.png', graphic_area ):center (  )
		local ____y = ibCreateImage ( px(160), 0, px(4), px(530), 'img/graphic_line.png', graphic_area ):center_y()
		ibCreateImage ( px(160), 0, px(982), px(4), 'img/graphic_line1.png', graphic_area ):center_y(px(527/2))

		local dollars = {
			500000000,
			5500,
			5000,
			4500,
			4000,
			3500,
			3000,
			2500,
			2000,
			1500,
			1000,
			500,
		}
		for i, v in pairs ( dollars ) do
			if i ~= 1 then
				ui ['lbl_course_'..i] = ibCreateLabel ( px(100), px(44) * ( i - 2 ) + ____y:ibData('py')+px(45), 0, 0, v..' $', graphic_area, tocolor ( 255, 255, 255 ), 1, 1, _, _, Font ( 'Semibold', 8 ) )

				:ibData ( 'alpha', 55 )
			end
		end

		local graphic_line_area = ibCreateArea ( 0, 0, px(975), px(515), graphic_area ):center ( )
		ui.graphic = ibCreateImage ( px(165), 0, px(975), 3, nil, graphic_area, tocolor ( 198, 85, 88 ) ):center_y ( px ( 450 / 2 ) )

		local function ChangeGaphicInformation ( )
			if not isElement ( ui.bg ) then return end
			for _ , dl in pairs ( dollars ) do
				if ui [ 'lbl_course_'.._ ] then
					local v_course = dl
					local c_course = hover.left.data.course or 500
					if c_course >= v_course and c_course < dollars[_-1] then
						if ( ui [ 'lbl_course_'.._ ]:ibData ( 'py' ) + px(5)) ~= ui.graphic:ibData ( 'py' ) then
							ui [ 'lbl_course_'.._ ]:ibAlphaTo ( 255, 500 )
							ui.graphic:ibMoveTo ( px(165), ui [ 'lbl_course_'.._ ]:ibData ( 'py' ) + px(5), 300 )
						end
					else
						ui [ 'lbl_course_'.._ ]:ibAlphaTo ( 55, 500 )
					end
				end
			end
		end
		Timer(ChangeGaphicInformation, 150, 1)
		ui.ghdgfgdfgdfg = Timer ( ChangeGaphicInformation, 350, 0 )

		ui.ChangeGraphic = function ( )
			if not isElement ( graphic_line_area ) then return end
			local data = DATA [ 'ETH' ]
			if not data then return end
			local history = data.history or { }

		end
		ui.ChangeGraphic ( )

		localPlayer:setData ( 'hud.hidden', true, false );

	else
		if isElement ( ui.bg ) then
			ui.bg:ibAlphaTo ( 0, 500 )
			ui.bg:ibMoveTo ( _, -100, 500 )
			ui.destroyTimer = Timer ( DestroyTableElements, 470, 1, ui )
		else
			DestroyTableElements ( ui );
		end
		showCursor ( false );
		showChat ( true );
		localPlayer:setData('hud.hidden', false, false)
		hover.left.selected_item = 1
	end
end

addCommandHandler ( 'pos', function ( ) 
	local x, y, z = getElementPosition ( localPlayer )
	setClipboard ( x..', '..y..', '..z )
end)