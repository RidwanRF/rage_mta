

------------------------------------------------------------

	function loadTutorialStep( step )

		local config = Config.tutorial[step]
		if not config then return end

		if config.onInit then
			config:onInit()
		end

		if config.point then

			exports.main_navigation:createGPSPoint(
				'tutorial',
				config.point.coords,
				config.point.text, false
			)

		end

		if config.complete_event then
			addEventHandler(config.complete_event, root, completeTutorialStep)
		end

	end

------------------------------------------------------------

	function completeTutorialStep()

		local step = localPlayer:getData('tutorial.step')
		local config = Config.tutorial[step]

		if config and config.complete_event then
			removeEventHandler(config.complete_event, root, completeTutorialStep)
		end

		triggerServerEvent('tutorial.complete_step', resourceRoot)

	end

------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'tutorial.step' and new then
			loadTutorialStep(new)
		end

	end)

------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		local step = localPlayer:getData('tutorial.step')
		if step then loadTutorialStep(step) end

	end)

------------------------------------------------------------