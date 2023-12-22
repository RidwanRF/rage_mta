
local interface = true

function toggleInterface()

	if ( localPlayer:getData('prison.time') or 0 ) > 0 then
		return
	end

	interface = not interface

	localPlayer:setData('hud.hidden', not interface, false)
	localPlayer:setData('players.hidden', not interface, false)
	localPlayer:setData('weapon.hidden', not interface, false)
	localPlayer:setData('speed.hidden', not interface, false)
	localPlayer:setData('radar.hidden', not interface, false)
	localPlayer:setData('drift.hidden', not interface, false)
	showChat( interface )

end

bindKey('j', 'down', toggleInterface)