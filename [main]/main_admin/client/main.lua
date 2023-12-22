
--------------------------------------------------------

	admin = {}

	admin.call = function(self, eventName, ...)
		triggerServerEvent('admin.'..eventName, resourceRoot, ...)
	end

	admin.addCallback = function(self, eventName, func)

		local _eventName = 'admin.'..eventName

		addEvent(_eventName, true)
		addEventHandler(_eventName, resourceRoot, func)

	end

--------------------------------------------------------

	function changeWindowSection(section)
		currentWindowSection = section
	end

	function openWindow(section)
		currentWindowSection = section
		setWindowOpened(true)
	end

	function closeWindow()
		setWindowOpened(false)
	end

	bindKey(Config.key, 'down', function()
		if windowOpened then
			closeWindow()
		else
			if exports.acl:isModerator(localPlayer) then
				openWindow('main')
			end
		end
	end)

--------------------------------------------------------

	local players_login_cache = {}

	function getPlayerFromLogin( login )

		if isElement(players_login_cache[login]) then
			return players_login_cache[login]
		else

			for _, player in pairs( getElementsByType('player') ) do
				if player:getData('unique.login') == login then
					players_login_cache[login] = player
					return player
				end
			end

		end

	end

--------------------------------------------------------