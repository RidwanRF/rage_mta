

------------------------------

	Quadra_abilities = {}

------------------------------

	function syncAbilities( abilities )

		
		Quadra_abilities = abilities

	end
	addEvent('quadra.syncAbilities', true)
	addEventHandler('quadra.syncAbilities', resourceRoot, syncAbilities)

------------------------------

	function useAbility( ability )

		if localPlayer.vehicle and localPlayer.vehicleSeat == 0 and localPlayer.vehicle.model == 587 then


			local fuel = localPlayer.vehicle:getData('fuel') or 0

			local config = Config.abilities[ ability ]
			if not config then return end

			if fuel < config.fuel then
				return exports.hud_notify:notify('Ошибка', 'Недостаточно бензина')
			end

			triggerServerEvent('quadra.useAbility', resourceRoot, ability)

		end

	end

------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for index, ability in pairs( Config.abilities ) do

			bindKey( ability.key, 'down', function( _, _, ability_id )

				if not isCursorShowing() then
					useAbility( ability_id )
				end

			end, index )

		end

	end)

------------------------------