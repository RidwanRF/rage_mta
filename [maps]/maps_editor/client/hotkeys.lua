
------------------------------------------------------------

	hotkeys = {

		{

			hotkey = 'num_add',

			action = function()
				createObjectFromCursor()
			end,

		},

		{

			hotkey = 'lshift+lctrl+d',

			action = function()
			end,

		},

		{

			hotkey = 'lalt+c',

			action = function()
				if selectedInput then return end
				showCursor( not isCursorShowing() )
			end,

		},
		
		{

			hotkey = 'lalt+e',
			requirement = false,

			action = function()
				toggleMapEditor()
			end,

		},
		
		{

			hotkey = 'ralt+x',

			action = function()

				if currentWorldInfo then

					local x,y,z = unpack( currentWorldInfo.pos )

					local str = string.format([=[
removeWorldModel( %s, 10, %s,%s,%s )
removeWorldModel( %s, 10, %s,%s,%s )
					]=],
						currentWorldInfo.model, x,y,z,
						currentWorldInfo.lod, x,y,z
					)

					local historyStr = string.format([=[
restoreWorldModel( %s, 10, %s,%s,%s )
restoreWorldModel( %s, 10, %s,%s,%s )
					]=],
						currentWorldInfo.model, x,y,z,
						currentWorldInfo.lod, x,y,z
					)

					loadstring(str)()
					setClipboard( str )

					table.insert(history, historyStr)

				end

			end,

		},

		{

			hotkey = 'lctrl+z',

			action = function()

				if history and history[#history] then
					
					local str = history[#history]

					loadstring(str)()
					setClipboard( str )

					history[#history] = nil

				end

			end,

		},
		
		{

			hotkey = 'enter',

			action = function()
				if selectedMoveObject then
					selectedMoveObject:finishFreeMove(true)
				end
			end,

		},
		
		{

			hotkey = 'num_enter',

			action = function()
				if selectedMoveObject then
					selectedMoveObject:finishFreeMove(true)
				end
			end,

		},
		
		{

			hotkey = 'enter',

			action = function()
				selectedInput = false
			end,

		},

		{

			hotkey = 'num_enter',

			action = function()
				selectedInput = false
			end,

		},
		
		{

			hotkey = 'backspace',

			action = function()
				if selectedMoveObject then
					selectedMoveObject:finishFreeMove(false)
				end
			end,

		},
		
		{

			hotkey = 'delete',

			action = function()
				if selectedEditObject then
					selectedEditObject:destroy()
				end
			end,

		},
		
		-- {

		-- 	hotkey = 'lctrl+z',
		-- 	repeatTimeout = 50,

		-- 	action = function()
		-- 		undo()
		-- 	end,

		-- },
		
		-- {

		-- 	hotkey = 'lctrl+y',
		-- 	repeatTimeout = 50,

		-- 	action = function()
		-- 		redo()
		-- 	end,

		-- },
		
		{

			hotkey = 'lctcl+lalt+s',

			action = function()
				gui_saveMap( GUI.input.map_file[6] )
			end,

		},
		
		{

			hotkey = 'f2',

			action = function()
				focusInput( GUI.input.object_name )
			end,

		},
		
		{

			hotkey = 'lctrl+lalt+d',

			action = function()
				if selectedEditObject then
					selectedEditObject:copy()
				end
			end,

		},
		
		{

			hotkey = 'lshift+o',

			action = function()
				if selectedEditObject then

					local x,y,z = getElementPosition( selectedEditObject.object )

					local hit, hx,hy,hz = processLineOfSight(
						x,y,z + 6, x,y,z-30,
						true, true, false, true,
						false, false, false, false,
						selectedEditObject.object
					)

					if not hit then return end

					setModelAxisOffset( selectedEditObject.object, hz-z )
					selectedEditObject:loadToGUI()

				end
			end,

		},
		

		---------------------------------------------------------

			{ hotkey = 'lalt+num_1', action = function() GUI.input.camspd:applyValue(0.05) end, },
			{ hotkey = 'lalt+num_2', action = function() GUI.input.camspd:applyValue(0.2) end, },
			{ hotkey = 'lalt+num_3', action = function() GUI.input.camspd:applyValue(0.8) end, },

		---------------------------------------------------------

			{ hotkey = 'lalt+num_4', action = function() GUI.input.edit_step:applyValue(1) end, },
			{ hotkey = 'lalt+num_5', action = function() GUI.input.edit_step:applyValue(10) end, },
			{ hotkey = 'lalt+num_6', action = function() GUI.input.edit_step:applyValue(100) end, },

		---------------------------------------------------------

	}

	local function hotkeys_defaultRequirement()
		return windowOpened
	end

------------------------------------------------------------

	pressed = {}

	addEventHandler('onClientKey', root, function( button, state )

		pressed[button] = state and getTickCount() or false

		for _, hotkeyData in pairs( hotkeys ) do

			if hotkeyData.requirement == false or ( hotkeyData.requirement or hotkeys_defaultRequirement )() then
					
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

	end)

	addEventHandler('onClientRestore', root, function()
		pressed = {}
	end)

------------------------------------------------------------
	
	function getKeyState( key )
		return pressed[key]
	end

------------------------------------------------------------