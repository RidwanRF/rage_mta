

------------------------------------------------------

	local log_load = {}

	function orderLogLoad( callback )

		log_load.callback = callback

		if isTimer( log_load.timer ) then killTimer( log_load.timer ) end 

		log_load.timer = setTimer(function()

			if localPlayer:getData('work.current') ~= Config.resourceName then return end

			local _, _, z1 = getPedBonePosition( localPlayer, 24 )
			local _, _, z2 = getPedBonePosition( localPlayer, 2 )

			if z1 < z2 then
				setPedAnimation(localPlayer, "CARRY", "crry_prtial", 1, true, true, false)
			end


		end, 300, 0)

		exports.hud_notify:notify('Вы разрубили бревно', 'Погрузите его в пикап')

		triggerServerEvent('lumberjack.orderLogLoad', resourceRoot)

	end	

------------------------------------------------------

	addEvent('lumberjack.createLogHandler', true)
	addEventHandler('lumberjack.createLogHandler', resourceRoot, function( marker )

		createBindHandler( marker, 'f', 'положить бревно', function( marker )

			clearTableElements( log_load )

			if log_load.callback then
				
				log_load.callback()
				log_load.callback = nil

			end

			triggerServerEvent('lumberjack.putLog', resourceRoot, marker)

		end )

	end)

------------------------------------------------------