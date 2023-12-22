Config = {}

Config.disableCollision = {
	['vehicles_autoschool'] = true,
	['job_bus'] = true,
	['job_logist'] = true,
	['job_green'] = true,
	['job_diver'] = true,
	['job_rubbisher'] = true,
	['job_lumberjack'] = true,
	['job_incassator'] = true,
}

Config.vehicleRemoveTimers = {
	['job_bus'] = true,
	['job_green'] = true,
	['job_logist'] = true,
	['job_taxi'] = true,
	['job_rubbisher'] = true,
	['job_incassator'] = true,
	['job_lumberjack'] = { time = 5*60 },
}

Config.jobNames = {
	['job_bus'] = 'Водитель автобуса',
	['job_taxi'] = 'Таксист',
	['job_post'] = 'Почтальон',
	['job_green'] = 'Газонокосильщик',
	['job_miner'] = 'Шахтёр',
	['job_logist'] = 'Логист',
	['job_diver'] = 'Водолаз',
	['job_rubbisher'] = 'Уборщик отходов',
	['job_incassator'] = 'Инкассатор',
	['job_lumberjack'] = 'Лесоруб',
}

Config.levelRequirement = {
	job_miner = 0,
	job_post = 0,
	job_diver = 25,
	job_logist = 40,
	job_taxi = 10,
	job_bus = 15,
	job_green = 5,
	job_rubbisher = 70,
	job_lumberjack = 25,
	job_incassator = 55,
}