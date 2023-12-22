

function createPlayerWithdraw(player, cameraMarker, speed, maxSpeed)

	if not player.account then return end

	local withdraw = 0
	local isNoPlate = false

	local x,y,z = getElementPosition(cameraMarker)

	if speed > maxSpeed then
		for _, data in pairs( Config.withdrawSums ) do
			if speed < data.speed then
				withdraw = withdraw + data.withdraw
				break
			end
		end
	end

	if (player.vehicle:getData('plate') or '') == '' and player.vehicle:getData('id') then
		withdraw = withdraw + Config.noPlateWithdraw
		isNoPlate = true
	end

	if withdraw == 0 then return end

	increaseElementData(player, 'police.withdraws', withdraw)
	triggerClientEvent(player, 'police_cameras.displayWindow', resourceRoot, withdraw, maxSpeed, isNoPlate)

	exports.logs:addLog(
		'[POLICE][WITHDRAW][ADD]',
		{
			data = {
				player = player.account.name,
				withdraw = withdraw,
			},	
		}
	)


end

addEventHandler('onMarkerHit', resourceRoot, function(player, mDim)
	if mDim and player.interior == source.interior and player.vehicle and player.vehicleSeat == 0 then

		-- if exports.main_vip:isVip(player) then return end
		if player.vehicle:getData('sirens.state') then return end
		if player.vehicle:getData('fso.state') then return end
		if player.vehicle:getData('number.curtain.state') then return end

		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'j' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'h' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'n' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'm' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'o' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'p' then return end
		if exports.vehicles_numbers:getNumberType(player.vehicle) == 'q' then return end

		local markerData = source:getData('speedcamera.data') or {}
		local speed = getElementSpeed(player.vehicle, 'kmh')

		createPlayerWithdraw(player, source, speed, markerData.speed)

	end
end)

addEventHandler('onResourceStart', resourceRoot, function()
	for _, cameraData in pairs( Config.cameras ) do

		local x,y,z = unpack(cameraData)

		local marker = createMarker(x,y,z, 'corona', cameraData.size, 255, 0, 0, 0)
		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'camera')

		marker:setData('speedcamera.data', {
			speed = cameraData.speed,
		})

	end
end)