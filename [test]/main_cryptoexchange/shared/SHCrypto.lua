Config = {
	max_bet_time = 20, -- макс. длительность ставки
	min_bet_time = 1, -- мин. длительность ставки

	course_update_time = { 1, 10 }, -- время обновления рандомно от 1 до 10 мин.
}

Config.currencies = {
	{
		name = 'Bitcoin', -- название
		short_name = 'Btc', -- короткое название
		russian = 'Биткоин', -- руское названиц
		icon = 'btc', -- иконка
		course = 0, -- стартовый курс после первого старта ресурса
	},

	{
		name = 'Ethereum',
		short_name = 'ETH',
		russian = 'Эфириум',
		icon = 'ethereum',
		course = 0,
	},

	{
		name = 'Dash',
		short_name = 'DSH',
		russian = 'Dash',
		icon = 'dash',
		course = 0,
	},

	{
		name = 'Litecoin',
		short_name = 'LTC',
		russian = 'Лайткоин',
		icon = 'litcoin',
		course = 0,
	},

	{
		name = 'Monero',
		short_name = 'XMR',
		russian = 'Монеро',
		icon = 'monero',
		course = 0,
	},
}

strings = {

	months = {

		'Января',
		'Февраля',
		'Марта',
		'Апреля',
		'Мая',
		'Июня',
		'Июля',
		'Августа',
		'Сентября',
		'Октября',
		'Ноября',
		'Декабря',
	},
}

function splitWithPoints ( number, splstr )
    number = tostring ( number )
    local k
    repeat
        number, k = string.gsub ( number, "^(-?%d+)(%d%d%d)", '%1'.. ( splstr or '.' )..'%2' )
    until ( k == 0 )    -- true - выход из цикла
    return number
end

function GetTableFromName ( name )
	for i, v in pairs ( Config.currencies ) do
		if v.short_name == name then
			return v
		end
	end
	return false
end

function GetRandomCrypt ( tbl )
	return tbl [ math.random ( 1, #tbl ) ]
end

Player.GetCrypts = function ( self )
	return self:getData ( 'crypto_currencies' ) or { }
end

Player.GetCryptValue = function ( self, id )
	local crypts = self:GetCrypts ( ) or { }
	if crypts [ id ] then return tonumber ( crypts [ id ].value ) end
	return 0
end