--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchfxAA", root, 4 )
--
--	To switch off:
--			triggerEvent( "switchfxAA", root, 0 )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()

		if localPlayer:getData('settings.fxaa') then
			enablefxAA(4)
		else
			disablefxAA()
		end

	end
)


addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.fxaa' then
		if new then
			enablefxAA(4)
		else
			disablefxAA()
		end
	end


end)