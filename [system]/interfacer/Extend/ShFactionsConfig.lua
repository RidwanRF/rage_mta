enum "FACTIONS_LIST" {
	"F_DPS",
	"F_PPS",
	"F_FSB",
	"F_GOVERNMENT"
}

FACTIONS_NAMES = {
	[ F_DPS ] 		 = "ГИБДД",
	[ F_PPS ]		 = "МВД",
	[ F_FSB ]		 = "ФСБ",
	[ F_GOVERNMENT ] = "Мэрия",
}

FACTIONS_ENG_NAMES = {
	[ F_DPS ] 		 = "dps",
	[ F_PPS ]		 = "pps",
	[ F_FSB ]		 = "fsb",
	[ F_GOVERNMENT ] = "government"
}

POLICED_FACTIONS = {
	[ F_DPS ] = true,
	[ F_PPS ] = true,
	[ F_FSB ] = true,
}

FACTIONS_LEVEL_NAMES = {
	[ F_DPS ] = {
		[ 1 ] = "Рядовой",
		[ 2 ] = "Сержант",
		[ 3 ] = "Старшина",
		[ 4 ] = "Прапорщик",
		[ 5 ] = "Лейтенант",
		[ 6 ] = "Капитан",
		[ 7 ] = "Майор",
		[ 8 ] = "Подполковник",
		[ 9 ] = "Полковник",
		[ 10 ] = "Генерал ГИБДД",
	},

	[ F_PPS ] = {
		[ 1 ] = "Рядовой",
		[ 2 ] = "Сержант",
		[ 3 ] = "Старшина",
		[ 4 ] = "Прапорщик",
		[ 5 ] = "Лейтенант",
		[ 6 ] = "Капитан",
		[ 7 ] = "Майор",
		[ 8 ] = "Подполковник",
		[ 9 ] = "Полковник",
		[ 10 ] = "Генерал МВД",
	},

	[ F_FSB ] = {
		[ 1 ] = "Рядовой",
		[ 2 ] = "Сержант",
		[ 3 ] = "Старшина",
		[ 4 ] = "Прапорщик",
		[ 5 ] = "Лейтенант",
		[ 6 ] = "Капитан",
		[ 7 ] = "Майор",
		[ 8 ] = "Подполковник",
		[ 9 ] = "Полковник",
		[ 10 ] = "Генерал ФСБ",
	},

	[ F_GOVERNMENT ] = {
		[ 1 ] = "Волонтер",
		[ 2 ] = "Работник Мэрии",
		[ 3 ] = "Охранник",
		[ 4 ] = "Начальник охраны",
		[ 5 ] = "Генеральный прокурор",
		[ 6 ] = "Министр финансов",
		[ 7 ] = "Министр транспорта",
		[ 8 ] = "Министр культуры",
		[ 9 ] = "Заместитель Мэра",
		[ 10 ] = "Мэр",
	},
}

FACTION_EXPERIENCE = {
	[0] = 0,
	[1] = 7000,
	[2] = 9000,
	[3] = 12000,
	[4] = 20000,
	[5] = 30000,
	[6] = 36000,
	[7] = 50000,
	[8] = 60000,
	[9] = 70000,
	[10] = 100000,
}

function GetFactionRankName( faction, rank )
	return FACTIONS_LEVEL_NAMES[ faction ] and FACTIONS_LEVEL_NAMES[ faction ][ rank or 1 ]
end

function GetFactionName( faction )
	return FACTIONS_NAMES[ faction ] or false
end

function GetFactionEngName( faction )
	return FACTIONS_ENG_NAMES[ faction ] or false
end

function GetFactionMaxLevel( faction )
	if FACTIONS_LEVEL_NAMES[ faction ] then
		return #FACTIONS_LEVEL_NAMES[ faction ]
	end
	return 10
end