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

function startNPCDialog()

	if isTimer(openTimer) then
		killTimer(openTimer)
	end

	openTimer = setTimer(function()

		if isCursorShowing() then return end

		openDialog(dialogsSctructure, 'start')

		if isTimer(openTimer) then
			killTimer(openTimer)
		end

	end, 2000, 0)

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'unique.login' and new then

		setTimer(function()

			if localPlayer:getData('start_dialog') ~= 1 then
				startNPCDialog()
			end

		end, 1000, 1)

	end

end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('unique.login') then

		if localPlayer:getData('start_dialog') ~= 1 then
			startNPCDialog()
		end
		
	end

end)

addCommandHandler('start_dialog', function()
	openDialog(dialogsSctructure, 'start')
end)