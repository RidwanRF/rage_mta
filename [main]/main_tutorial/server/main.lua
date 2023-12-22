
----------------------------------------------------------------

	exports.save:addParameter('tutorial.step', nil, true)

----------------------------------------------------------------

	function startTutorial()
		client:setData('tutorial.step', 1)
	end
	addEvent('tutorial.start', true)
	addEventHandler('tutorial.start', resourceRoot, startTutorial)

----------------------------------------------------------------

	function completeTutorialStep()

		local step = client:getData('tutorial.step') or 0
		step = step + 1

		if Config.tutorial[step] then
			client:setData('tutorial.step', step)
		else

			client:setData('tutorial.step', false)

			exports.logs:addLog(
				'[TUTORIAL][COMPLETE]',
				{
					data = {
						player = client.account.name,
					},	
				}
			)

		end

	end
	addEvent('tutorial.complete_step', true)
	addEventHandler('tutorial.complete_step', resourceRoot, completeTutorialStep)

----------------------------------------------------------------

	function cancelTutorial()

		exports.logs:addLog(
			'[TUTORIAL][CANCEL]',
			{
				data = {
					player = client.account.name,
				},	
			}
		)

	end
	addEvent('tutorial.cancel', true)
	addEventHandler('tutorial.cancel', resourceRoot, cancelTutorial)

----------------------------------------------------------------