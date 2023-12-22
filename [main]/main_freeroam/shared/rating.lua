

Config.ratingKeys = {

	{

		id = 'kills',
		name = 'Бойцы сервера',
		title = 'Суммарное число убийств',

		calculate = function( account )
			return account:getData('kills') or 0
		end,

		toString = function( value )
			return ('%s уб.'):format( splitWithPoints( math.floor(value), '.' ) )
		end,

	},

	{

		id = 'car',
		name = 'Автолюбители',
		title = 'Величина автопарка',

		calculate = function( account )
			return account:getData('cars.total') or 0
		end,

		toString = function( value )
			return ('%s ед.'):format( splitWithPoints( math.floor(value), '.' ) )
		end,

	},

	{

		id = 'drift',
		name = 'Дрифтеры сервера',
		title = 'Суммарный дрифт',

		calculate = function( account )
			return account:getData('drift.total') or 0
		end,

		toString = function( value )
			return ('%s'):format( splitWithPoints( math.floor(value), '.' ) )
		end,

	},

	{

		id = 'money',
		name = 'Богачи сервера',
		title = 'Сумма всех денег',

		calculate = function( account )

			local money = account:getData('money') or 0
			local bank = account:getData('bank.rub') or 0
			local deposits = account:getData('bank.deposits') or 0

			return ( deposits + bank + money )

		end,

		toString = function( value )
			return ('$%s'):format( splitWithPoints( math.floor(value), '.' ) )
		end,

	},

	{

		id = 'jobs',
		name = 'Работяги сервера',
		title = 'Суммарная зарплата со всех работ',

		calculate = function( account )

			local stats = fromJSON(account:getData('jobs.stats') or '[[]]') or {}
			local sum = 0

			for job, data in pairs( stats ) do
				sum = sum + ( data.raised_money or 0 )
			end

			return sum

		end,

		toString = function( value )
			return ('$%s'):format( splitWithPoints( math.floor(value), '.' ) )
		end,

	},

	{

		id = 'level',
		name = 'Олды сервера',
		title = 'Игровой стаж',

		calculate = function( account )
			return account:getData('level') or 0
		end,

		toString = function( value )
			return ('%s %s'):format( value, getWordCase( value, 'час', 'часа', 'часов' ) )
		end,

	},

}

Config.k_ratingKeys = {}

for _, section in pairs( Config.ratingKeys ) do
	Config.k_ratingKeys[section.id] = section
end

function getRatingSection( id )
	return Config.k_ratingKeys[id]
end