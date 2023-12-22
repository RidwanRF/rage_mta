Config = {
	window_text = 'Панель мероприятий';
	tabs = {
		{ name = 'Main' };
		{ name = 'Выдача' };
		{ name = 'Машины' };
	};
	accepted_weapons = {
		{ "Кастет", 1 },
		{ "Клюшка", 2 },
		{ "Дубинка", 3 },
		{ "Нож", 4 },
		{ "Бита", 5 },
		{ "Лопата", 6 },
		{ "Кий", 7 },
		{ "Катана", 8 },
		{ "Бензопила", 9 },
		{ "Кольт 45", 22 },
		{ "Тайзер", 23 },
		{ "Дигл", 24 },
		{ "Дробовик", 25 },
		{ "Обрез", 26 },
		{ "Помповый дробовик", 27 },
		{ "Узи", 28 },
		{ "МП5", 29 },
		{ "Тек-9", 32 },
		{ "АК-47", 30 },
		{ "М4", 31 },
		{ "Ружье", 33 },
		{ "Снайп.винтовка", 34 },
		{ "РПГ", 35 },
		{ "Ракетница", 36 },
		{ "Миниган", 38 },
		{ "Граната", 16 },
		{ "Граната слезоточивая", 17 },
		{ "Граната ранец", 39 },
		{ "Детонатор г. ранец", 40 },
		{ "Дефибриллятор", 10 },
		{ "Дилдо 2", 11 },
		{ "Жезл", 12 },
		{ "Цветы", 14 },
		{ "Топор", 15 },
		{ "Ночное виденье", 44 },
		{ "Инфракрасное", 45 },
		{ "Парашют", 46 },
		{ "Камера", 43 },
		{ "Баллончик", 41 },
		{ "Огнетушитель", 42 },
	},

	accepted_colors = {
		{ "Aqua", { 000, 255, 255 } },
		{ "Black", { 000, 000, 000 } },
		{ "Blue", { 000, 000, 255 } },
		{ "Fuchsia", { 255, 000, 255 } },
		{ "Gray", { 128, 128, 128 } },
		{ "Green", { 000, 128, 000 } },
		{ "Lime", { 000, 255, 000 } },
		{ "Maroon", { 128, 000, 000 } },
		{ "Navy", { 000, 000, 128 } },
		{ "Olive", { 128, 128, 000 } },
		{ "Purple", { 128, 000, 128 } },
		{ "Red", { 255, 000, 000 } },
		{ "Silver", { 192, 192, 192 } },
		{ "Teal", { 000, 128, 128 } },
		{ "White", { 255, 255, 255 } },
		{ "Yellow", { 255, 255, 000 } },
	},

	max_winners = 3; -- макс. кол-во победителей
	max_prize = 50000; -- макс.  приз

	bind_key = 'Z', -- клавища открытия
	max_event_vehicles = 20, -- макс. кол-во авто которое можно создать
}

function table.copy( obj, seen )
    if type( obj ) ~= 'table' then
        return obj;
    end;

    if seen and seen[ obj ] then
        return seen[ obj ];
    end;

    local s         = seen or {};
    local res       = setmetatable( { }, getmetatable( obj ) );
    s[ obj ]        = res;

    for k, v in pairs( obj ) do
        res[ table.copy(k, s) ] = table.copy( v, s );
    end

    return res;
end

VEHICLES_LIST, VEHICLES_PROPERTYES = exports.vehicles_main:getVehiclesList ( )

Vector3.AddRandomRange = function( self, range )
    local range = range or 2
    return self + Vector3( 
		math.random( -10 * range, 10 * range ) / 10,
		math.random( -10 * range, 10 * range ) / 10,
		0
    )
end

function table.size(data)
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end

    return count;
end