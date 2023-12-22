
Config.donateConvert = exports.core:getDonateConvertMul()

function getConvertPromo( player, promo )

	local promocodes = player:getData('convert_promocodes') or {}
	return promocodes[promo]

end

Config.vipItems = {
	
	{
		days = 1,
		cost = 100,
	},

	
	{
		days = 3,
		cost = 250,
	},

	
	{
		days = 7,
		cost = 500,
		hit = true,
	},

	
	{
		days = 14,
		cost = 850,
	},

}