
function changeWindowSection(section, noAnim, onOpen)

	onChangeWindow = onOpen

	onChangeSection = true
	if not noAnim then
		animate('dxGui.window-alpha', 0)

		setTimer(function()
			if currentWindowSection then
				closeWindow()
				openWindow(section)

				if onChangeWindow then
					onChangeWindow()
					onChangeWindow = nil
				end

			end
		end, 500, 1)
	else
		closeWindow()
		openWindow(section)
	end


end

function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('tuningopen', function()
	if exports['acl']:isAdmin(localPlayer) then
		openWindow('main')
		initializeTuning(true)
	end
end)

addCommandHandler('vinilopen', function()
	if exports['acl']:isAdmin(localPlayer) then
		openWindow('vinils')
	end
end)