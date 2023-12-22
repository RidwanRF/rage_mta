
function setPremiumFlag(player, premiumFinish)
	local realTime = getRealTime().timestamp
	player:setData('vip', realTime < premiumFinish)
end

function isAccountVip(account)

	local premiumFinish = account:getData('vip.finishTime')
	if not premiumFinish then return false end

	local realTime = getRealTime().timestamp

	return premiumFinish > realTime
end

function giveVip(login, time)
	local account = getAccount(login)
	if not account then return end

	local realTime = getRealTime().timestamp
	local premiumFinish = account:getData('vip.finishTime') or realTime

	local newPremiumFinish

	if premiumFinish > realTime then
		newPremiumFinish = premiumFinish + time
	else
		newPremiumFinish = realTime + time
	end

	account:setData('vip.finishTime', newPremiumFinish)

	if isElement(account.player) then
		setPremiumFlag(account.player, newPremiumFinish)
		exports.chat_main:displayInfo(account.player,
			string.format('[VIP] Срок действия VIP-аккаунта продлен на %s ч',
			math.floor(time / 3600)
		), {50, 255, 50})
	end
end

function setVip(login, time)
	local account = getAccount(login)
	if not account then return end

	local realTime = getRealTime().timestamp
	local premiumFinish = account:getData('vip.finishTime') or realTime

	local cTime = premiumFinish - realTime
	
	giveVip(login, time-cTime)

end

function updatePlayerPremium(player)
	if not player.account then return end

	local premiumFinish = player.account:getData('vip.finishTime')
	if not premiumFinish then return end

	local realTime = getRealTime().timestamp

	if premiumFinish < realTime and isVip(player) then

		exports.chat_main:displayInfo(player,
			string.format('[VIP] Срок действия VIP-аккаунта истек'),
			{255, 20, 20}
		)

		player.account:setData('vip.finishTime', 0)
		player:setData('vip', false)
	else
		setPremiumFlag(player, premiumFinish)
	end
end

addEventHandler('onPlayerLogin', root, function()
	updatePlayerPremium(source)
end, true, 'low-2')

function updatePremium()
	for _, player in pairs( getElementsByType('player') ) do
		updatePlayerPremium(player)
	end
end
setTimer(updatePremium, 20000, 0)

addCommandHandler('givevip', function(player, _, login, time)
	if exports.acl:isAdmin(player) then
		giveVip(login, tonumber(time))
	end
end)

addEventHandler('onElementDataChange', root, function(dn, old, new)

	if dn == 'vip' then
		exports.hud_main:togglePlayerHUDIcon( source, 'vip', new )
	end

end)