

local tipText = string.format('завершить тест-драйв')

function startTestDrive()
	testDriveTimer = setTimer(function()
		finishTestDrive()
	end, Config.testDriveTime, 1)

	exports['hud_notify']:actionNotify(Config.finishTestDrive:upper(), tipText, Config.testDriveTime)
end
addEvent('vehicles.testdrive.start', true)
addEventHandler('vehicles.testdrive.start', root, startTestDrive)

function finishTestDrive()
	if isTimer(testDriveTimer) then killTimer(testDriveTimer) end

	exports['hud_notify']:actionNotify(Config.finishTestDrive:upper(), tipText, 50)

	triggerServerEvent('vehicles.shop.finishTestDrive', resourceRoot)
end

addEvent('testdrive.finish', true)
addEventHandler('testdrive.finish', resourceRoot, finishTestDrive)

bindKey(Config.finishTestDrive, 'down', function()
	if localPlayer:getData('testdrive') then
		finishTestDrive()
	end
end)