Config = {}

Config.markers = {
	{ 1097.89, 1445.17, 11.65 },
}

Config.bet_range = { 5000, 100000 }

Config.match_types = {
	
	{ name = 'Командный 1х1', type = 'team', players = 2, },
	{ name = 'Командный 2х2', type = 'team', players = 4, },
	{ name = 'Командный 4х4', type = 'team', players = 8, },
	{ name = 'Командный 8х8', type = 'team', players = 16, },

	{ name = 'Сам за себя | 8 игроков', type = 'mincer', players = 8, },
	{ name = 'Сам за себя | 6 игроков', type = 'mincer', players = 6, },
	{ name = 'Сам за себя | 4 игрока', type = 'mincer', players = 4, },

}

Config.match_queue_time = 5*60
Config.comission = 10

Config.match = {
	
	time = 6*60,


}