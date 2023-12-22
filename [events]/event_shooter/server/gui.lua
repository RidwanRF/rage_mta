
----------------------------------------

	function openPlayerWindow( player, section, ... )
		triggerClientEvent( player, 'event_shooter.openWindow', resourceRoot, section, ... )
	end
	
----------------------------------------

	function closePlayerWindow( player, section )
		triggerClientEvent( player, 'event_shooter.closeWindow', resourceRoot, section )
	end

----------------------------------------