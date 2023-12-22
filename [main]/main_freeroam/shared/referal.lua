
Config.referal = {

	invited = {
		{
			level = 2,
			reward = { type = 'vip', amount = 2, name = 'VIP 2 дня' }
		},
		{
			level = 5,
			reward = { type = 'money', amount = 10000, name = '$10.000' },
		},
		{
			level = 10,
			reward = { type = 'money', amount = 30000, name = '$30.000' },
		},
		{
			level = 50,
			reward = { type = 'money', amount = 70000, name = '$70.000' },
		},
		{
			level = 100,
			reward = { type = 'car', amount = 1, name = 'BMW E60' },
		},
	},

	inviter = {
		{
			level = 5,
			reward = { type = 'money', amount = 10000, name = '$10.000' },
		},
	},

}

Config.defaultReferalPercent = 10
Config.minReferalTakeSum = 300

Config.uniqueCodes = {

	--[[['MISHANYA'] = { give = function(player) end, owner = 'MishanyaChannel' },
	['BFIRE'] = { give = function(player) end, owner = 'Fadeev1717' },
	['BADMAN'] = { give = function(player) end, owner = 'BADMAN' },
	['CACAOCHANNEL'] = { give = function(player) end, owner = 'CacaoChannel' },
	['DEL'] = { give = function(player) end, owner = 'de1yt' },
	['PROVAIDER'] = { give = function(player) end, },
	['DEVO'] = { give = function(player) end, owner = 'Devonabrr', percent = 20 },
	['MARNET'] = { give = function(player) end, owner = 'Marnet' },
	['TITAN'] = { give = function(player) end, },
	['REBORN'] = { give = function(player) end, },
	['DAILY'] = { give = function(player) end, },
	['SMOTRA'] = { give = function(player) end, },
	['CCD'] = { give = function(player) end, },
	['NATIONAL'] = { give = function(player) end, },
	['RAGE'] = { give = function(player) end, },
	['ASKELA'] = { give = function(player) end, owner = 'owenmansell' },
	['KANTIK'] = { give = function(player) end, owner = 'KANTIK' },
	['HENTER'] = { give = function(player) end, owner = 'Henter' },
	['RoyalHell'] = { give = function(player) end, owner = 'FOMA' },
	['GLADIOLUS'] = { give = function(player) end, owner = 'Zombi22' },
	['PODDONOK'] = { give = function(player) end, owner = 'poddonokgame' },
	['HANDET'] = { give = function(player) end, owner = 'Handet' },
	['DEFAULT'] = { give = function(player) end, owner = 'Default' },
	['ARTEM4IK'] = { give = function(player) end, owner = 'Artem4ik1071' },
	['BLKGDS'] = { give = function(player) end, owner = 'Zhora' },
	['Savelyon'] = { give = function(player) end, owner = 'Savelyon' },
	['USA'] = { give = function(player) end, owner = 'TheSmoke' },
	['NIGHT'] = { give = function(player) end, owner = 'NighT' },
	['TER'] = { give = function(player) end, owner = 'TerChannel' },
	['COOPER'] = { give = function(player) end, owner = 'Cooper' },
	['PLUT'] = { give = function(player) end, owner = 'Plut' },
	['DISCIPLE'] = { give = function(player) end, owner = 'Disciple' },
	['NISHIY'] = { give = function(player) end, owner = 'avramenk077' },
	['MAGIC'] = { give = function(player) end, owner = 'ArtemMagic' },
	['SUZUKI'] = { give = function(player) end, owner = 'sashasiniy' },
	['QEEW'] = { give = function(player) end, owner = 'latif2003' },
	['PREMIUM'] = { give = function(player) end, owner = 'Dinar' },
	['DRAKEN'] = { give = function(player) end, owner = 'NikitaDraken' },
	['GVR'] = { give = function(player) end, },
	['TIKTOK'] = { give = function(player) end, },
	['DEMETRIO'] = { give = function(player) end, },
	['LITVINENKO'] = { give = function(player) end, owner = 'Maybach' },
	['TVERSKOY'] = { give = function(player) end, owner = 'Tverskoy' },
	['STAT'] = { give = function(player) end, owner = 'STAT' },
	['FLUPEKZ'] = { give = function(player) end, owner = 'flupekz' },
	['ZERO'] = { give = function(player) end, owner = 'booster' },
	['STUK'] = { give = function(player) end, owner = 'STUK' },
	['SEMSHOW'] = { give = function(player) end, owner = 'semshow' },
	['ZENLIX'] = { give = function(player) end, owner = 'Zenlix' },
	['ZAICHOS'] = { give = function(player) end, owner = 'Zaichos' },
	['ALEXFIT'] = { give = function(player) end, owner = 'AlexFit' },
	['BORIS'] = { give = function(player) end, owner = 'ZloyBoris' },
	['MARTIK'] = { give = function(player) end },
	['TIKTOK2'] = { give = function(player) end },
	['CUSTOMS'] = { give = function(player) end, owner = 'LITEROMA' },]]
	['Kingsman'] = { give = function(player) end, owner = 'Kingsman' },
	['SENDOR'] = { give = function(player) end, owner = 'sendor' },
	['ILANS'] = { give = function(player) end, owner = ' iLans' },

}

Config.overrideReferalCodes = {}

for code, data in pairs( Config.uniqueCodes ) do
	if data.include then
		for _, login in pairs( data.include ) do
			Config.overrideReferalCodes[login] = code
		end
	end
end

function getPlayerPromo(player)

	local accountName = player:getData('unique.login')

	for code, data in pairs( Config.uniqueCodes ) do
		if data.owner == accountName then
			return code
		end
	end

end


function getLoginReferalPercent( login )

	local unique = Config.uniqueCodes[login] or {}

	if unique[login] and unique[login].percent then
		return unique[login].percent
	end

	return Config.defaultReferalPercent

end