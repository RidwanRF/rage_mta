
------------------------------------------------------

	function requireSync(map)
		triggerServerEvent('map.editor.synchronize', resourceRoot, map)
	end

	addEventHandler('onClientResourceStart', resourceRoot, requireSync)

------------------------------------------------------

	addEvent('map.editor.synchronize', true)
	addEventHandler('map.editor.synchronize', root, function(map)
		
	end)

------------------------------------------------------