function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey('f11', 'down', function()
	if windowOpened then
		if currentWindowSection ~= 'main' then return end
		closeWindow()
	else
		openWindow('main')
	end
end)

setPlayerHudComponentVisible('radar', false)
showPlayerHudComponent("radar", false)
toggleControl("radar", false)

addCommandHandler('inputcoords', function(_, section)
	if exports.acl:isAdmin(localPlayer) then
		openWindow('input_mode')
	end
end)

addCommandHandler('showcoords', function(_, section)
	if exports.acl:isAdmin(localPlayer) then

		local x,y = getElementPosition( localPlayer )

		showCoords({
			{ pos = {-1000, 1000}, text = 'Вы' },
			{ pos = {1000, -1000}, text = '?' },
			{ pos = {0, 2000}, text = 'ЭЙ!' },
		})
	end
end)

function inputCoords(text, key, display_list)

	if windowOpened and currentWindowSection == 'input_mode' then
		return false
	end

	currentInputModeText = text
	currentInputModeKey = key
	currentInputModeBlips = display_list

	openWindow('input_mode')

	return true

end

function showCoords(list)
	openWindow('show_coords_mode')
	coordsElement:showCoords(list)
end