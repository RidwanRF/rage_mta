
local debug_modules = {
	
	covers = false,
	wheels = false,

}

function toggleDebugModule( module_name )
	debug_modules[ module_name ] = not debug_modules[ module_name ]
end

function isDebugModuleEnabled( module_name )
	return debug_modules[ module_name ]
end

addCommandHandler('tuning_toggle_debug', function( _, module_name )

	if exports.acl:isAdmin( localPlayer ) then
		toggleDebugModule( module_name )
	end

end)