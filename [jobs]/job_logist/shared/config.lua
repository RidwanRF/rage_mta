
Config = {}

Config.resourceName = getThisResource().name

Config.stations = {
	
	{ marker = { 2507.08, 2781.37, 10.82 }, start = {
		{ 2520.82, 2769.79, 10.6, 0.56 },
		{ 2507.02, 2748.25, 10.6, 271.76 },
		{ 2520.47, 2729.56, 10.6, 1.57 },
	},
	},

}


Config.vehicle = 499

Config.routes = {
	
	{

		name = 'Пищевая продукция',
		icon = 'assets/images/r1.png',

		source = { 2524.01, 2819.98, 10.82 },
		
		money = 7250,

		destinations = {
			{ 195.79, -176.79, 0.58, 0, },
			{ 1356.77, -1751.21, 12.37, 0, },
			{ -2506.8, 1215.98, 36.43, 0, },
			{ -203.25, 2730.6, 61.69, 0, },
			{ 2275.05, 2539, 9.82, 0, },
		},

	},
	
	{

		name = 'Промышленное сырье',
		icon = 'assets/images/r2.png',

		source = { 2524.01, 2819.98, 10.82 },
		
		money = 7400,

		destinations = {
			{ 1051.17, 1317.58, 9.82, 0, },
			{ -1894.56, -1707.65, 20.75, 0, },
			{ 43.95, -228.01, 1.25, 0, },
			{ -1024.41, -608.01, 31.01, 0, },
			{ 391.33, 2537.87, 15.54, 0, },
		},

	},
	
	{

		name = 'Стройматериалы',
		icon = 'assets/images/r3.png',

		source = { 2524.01, 2819.98, 10.82 },
		
		money = 7200,

		destinations = {
			{ 1051.17, 1317.58, 9.82, 0, },
			{ -1894.56, -1707.65, 20.75, 0, },
			{ -1024.41, -608.01, 31.01, 0, },
			{ 391.33, 2537.87, 15.54, 0, },
			{ -482.12, -534.71, 25.09 },
		},

	},

}

Config.handling = {
	ABS = false,
	animGroup = 16,
	brakeBias = 0.80000001192093,
	brakeDeceleration = 8,
	centerOfMass = { 0, 0.5, 0 },
	collisionDamageMultiplier = 0.5,
	dragCoeff = 1.7000000476837,
	driveType = "awd",
	engineAcceleration = 4,
	engineInertia = 10,
	engineType = "petrol",
	handlingFlags = 524289,
	headLight = "small",
	mass = 1300,
	maxVelocity = 120,
	modelFlags = 1,
	monetary = 15000,
	numberOfGears = 5,
	percentSubmerged = 70,
	seatOffsetDistance = 0.20000000298023,
	steeringLock = 30,
	suspensionAntiDiveMultiplier = 0,
	suspensionDamping = 0.079999998211861,
	suspensionForceLevel = 1,
	suspensionFrontRearBias = 0.5,
	suspensionHighSpeedDamping = 0,
	suspensionLowerLimit = -0.15000000596046,
	suspensionUpperLimit = 0.44999998807907,
	tailLight = "small",
	tractionBias = 0.40000000596046,
	tractionLoss = 0.60000002384186,
	tractionMultiplier = 0.75,
	turnMass = 2200
}


function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
