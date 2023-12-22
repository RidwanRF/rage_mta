
------------------------------------------------------------

	hotkeys = {

		{

			hotkey = 'arrow_d',
			section = 'main',

			action = function()
				tuningComponentsList:move(1)
			end,

		},

		{

			hotkey = 'arrow_u',
			section = 'main',

			action = function()
				tuningComponentsList:move(-1)
			end,

		},

		{

			hotkey = 'tab',
			section = 'main',

			action = function()
				tuningSectionsList:move(1)
			end,

		},

	}

	local function hotkeys_defaultRequirement()
		return windowOpened
	end

------------------------------------------------------------

	pressed = {}

	function callHotKey( button )

		for _, hotkeyData in pairs( hotkeys ) do

			if hotkeyData.requirement == false or ( hotkeyData.requirement or hotkeys_defaultRequirement )()
				and currentWindowSection == hotkeyData.section
			then
					
				local keys = splitString( hotkeyData.hotkey, '+' )
				local handle = true

				for _, key in pairs( keys ) do

					if not pressed[key] then
						handle = false
						break
					end

				end

				if handle then
					hotkeyData.action()
				end

			end


		end

	end

	addEventHandler('onClientKey', root, function( button, state )

		pressed[button] = state and getTickCount() or false

		callHotKey( button )

	end)

	addEventHandler('onClientRestore', root, function()
		pressed = {}
	end)

	-- setTimer(function()

	-- 	if not windowOpened then return end

	-- 	local tick = getTickCount()

	-- 	for key, k_tick in pairs( pressed ) do

	-- 		if k_tick and ( tick - k_tick ) > 500 then

	-- 			callHotKey(key)

	-- 		end

	-- 	end		

	-- end, 100, 0)

------------------------------------------------------------
	
	function getKeyState( key )
		return pressed[key]
	end

------------------------------------------------------------