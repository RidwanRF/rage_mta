function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('createderrick', function(_, cost, override_income)
	if exports.acl:isAdmin(localPlayer) then

		local cost = tonumber(cost)
		local override_income = tonumber(override_income)
		
		if not cost then
			return exports.hud_notify:notify('Использование', 'createderrick ЦЕНА')
		end

		dialog('Нефтевышка', 'Создать здесь нефтевышку?', function(result)
			if result then

				local x,y,z = getElementPosition(localPlayer)
				triggerServerEvent('derrick.add', resourceRoot, x,y,z, cost, override_income)
				
			end
		end)
	end
end)

