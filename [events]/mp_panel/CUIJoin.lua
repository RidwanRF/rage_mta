local sx, sy = 500, 300
local px, py = ( scx / 2 - sx / 2 ), ( scy / 2 - sy / 2 );
local text = [[
	Администратор %s проводит мероприятие %s
	Хотите принять участие?
]]
local font = DxFont ( 'manrope_semibold.ttf', 13.5 );
local tick = getTickCount ( );
local config = { };

function render ( )
	local alpha, py = interpolateBetween ( 0, py - 200, 0, 1, py, 0, ( getTickCount ( ) - tick ) / 1100, 'OutQuad' );
	alpha = alpha * 255

	dxDrawImage ( px, py, sx, sy, 'img/bg.png', 0, 0, 0, tocolor ( 21, 21, 33, alpha ) );
	dxDrawText ( text, px, py, sx + px, ( sy - 100 ) + py, tocolor ( 255, 255, 255, alpha ), 1, font, 'center', 'center', false, true );

	dxCreateButton ( px + 90, py + sy - 90, 153, 41, 'img/btn_empty.png', 'img/btn.png', alpha, 'accept', 'Принять' );
	dxCreateButton ( px + 270, py + sy - 90, 153, 41, 'img/btn_empty.png', 'img/btn.png', alpha, 'close', 'Закрыть' );
end

function onClick ( key, state )
	if key == 'left' and state == 'up' then
		if isMouseInPosition ( px + 270, py + sy - 90, 153, 41 ) then
			hide ( );
		elseif isMouseInPosition ( px + 90, py + sy - 90, 153, 41  ) then
			triggerServerEvent ( 'MP::OnPlayerJoinToEvent', resourceRoot, config.id );
			hide ( );
			config = { };
		end
	end
end

function show ( conf )
	text = [[
		Администратор «]]..conf.creator.name..[[» проводит мероприятие «]]..conf.name..[[»
		Хотите принять участие?
	]];

	config = conf;

	removeEventHandler ( 'onClientRender', root, render );
	removeEventHandler ( 'onClientClick', root, onClick );
	addEventHandler ( 'onClientClick', root, onClick );
	addEventHandler ( 'onClientRender', root, render );
	showCursor ( true );
	tick = getTickCount ( );
end
addEvent ( 'MP::ShowJoinUIPanel', true )
addEventHandler ( 'MP::ShowJoinUIPanel', resourceRoot, show )

function hide ( )
	removeEventHandler ( 'onClientRender', root, render );
	removeEventHandler ( 'onClientClick', root, onClick );
	showCursor ( false );
end