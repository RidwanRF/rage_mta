Config = {}

Config.maxBusiness = 2

Config.businessNames = {
	{
		payment_sum = {0, 3000000},
		name = 'Магазин',
	},
	{
		payment_sum = {3000000, 100000000},
		name = 'Магазин',
	},
}



Config.donateConvertMul = exports.core:getDonateConvertMul()
Config.sellMul = 0.5


function getConfigSetting(name)
	return Config[name]
end