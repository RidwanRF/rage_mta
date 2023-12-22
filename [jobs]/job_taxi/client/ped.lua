
addEvent('job_taxi.create_work_ped', true)
addEventHandler('job_taxi.create_work_ped', resourceRoot, function( data )

	local ped = exports.main_peds:createWorldPed({

		position = {
			coords = data.pos,
			int = 0,
			dim = 0,
		},

		attachToLocalPlayer = true,

		model = data.model,

	})

	ped.parent = data.element
	data.element:setData('ped', ped)

	addEventHandler('onClientElementDestroy', data.element, function()

		if isElement(source:getData('ped')) then
			setTimer(function(element)
				if isElement(element) then
					destroyElement(element)
				end
			end, 100, 1, source:getData('ped'))
		end

	end)

end)
