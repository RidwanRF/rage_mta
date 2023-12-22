
----------------------------------------

	function openWindow(section)
		currentWindowSection = section
		setWindowOpened(true)
	end

	function closeWindow()
		setWindowOpened(false)
	end

----------------------------------------

	addEvent('teams.displayInvite', true)
	addEventHandler('teams.displayInvite', resourceRoot, function( data )
		current_invite = data
	end)

----------------------------------------
	
	bindKey('f4', 'down', function()

		if isTimer(queryTimer) then return end

		if windowOpened then
			closeWindow()
		else

			if current_invite then

				openWindow('invite_window')

			else

				if localPlayer.dimension == 0 then

					if localPlayer.team and not localPlayer.team:getData('team.data') then

						triggerServerEvent('teams.sync_query', resourceRoot)
						queryTimer = setTimer( openWindow, 1000, 1, 'main' )

					else

						local section = (
							localPlayer:getData('team.id')
							and
							localPlayer.team
						) and 'main' or 'creation'

						if section == 'creation' and exports.acl:isPlayerInGroup(localPlayer, 'youtube_plus') then
							return exports.hud_notify:notify('Вам нельзя создать клан', 'Согласуйте с администрацией')
						end

						openWindow( section )
					end

				end

			end


		end

	end)

----------------------------------------

