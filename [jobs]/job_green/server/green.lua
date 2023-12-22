
--------------------------------------------------------------------

	greenSpace = { objects = {}, }

	function createGreenSpace(section)

		local config = Config.space[section]

		greenSpace.section = section
		greenSpace.position = config.point or {getMiddlePoint(Config.space[section])}

		index = 1

		if isTimer(createGreenTimer) then
			killTimer(createGreenTimer)
		end

		createGreenTimer = setTimer(function()

			for i = index, index+20 do

				if not config[i] then

					if isTimer(createGreenTimer) then
						killTimer(createGreenTimer)
					end
					
					return
				end

				if not greenSpace.objects[i] then
					greenSpace.objects[i] = createGreenObject( i )
				end
				
			end

			index = index + 20

		end, 500, 0)

	end

	function updateGreenSpace()

		clearTableElements( greenSpace )
		greenSpace = { objects = {} }

		local section = math.random( #Config.space )

		while (section == greenSpace.section and #Config.space > 1) do
			section = math.random( #Config.space )
		end

		createGreenSpace( section )

	end

	addEventHandler('onResourceStart', resourceRoot, function()
		updateGreenSpace()
	end)

--------------------------------------------------------------------

	function createGreenObject( index )

		if not Config.space[ greenSpace.section ][index] then return end

		local x,y,z = unpack( Config.space[ greenSpace.section ][index] )

		local object = createObject( 866, x,y,z )
		local marker = createMarker( x,y,z, 'corona', 2, 0, 0, 0, 0 )

		marker:setData('green.index', index)

		return { object = object, marker = marker }

	end

--------------------------------------------------------------------

	local queue = {}

	setTimer(function()

		for player, count in pairs( queue ) do
			exports.jobs_main:addPlayerSessionMoney(player, Config.money*count, false)
			exports.jobs_main:addPlayerStats(player, 'markers_passed', count)
		end

		queue = {}

	end, 2000, 0)

	function checkGreenEmpty()

		if getTableLength(greenSpace.objects) <= 0 then
			
			updateGreenSpace()

			for _, player in pairs( getElementsByType('player') ) do

				if exports.jobs_main:getPlayerWork(player) == Config.resourceName then

					createHelpMarker(player)

					exports.hud_notify:notify(player, 'Газон выкошен', 'Новый отмечен на карте')

				end

			end

		end

	end

	function mowGreenObject( index )

		if greenSpace.objects[index] then

			queue[client] = (queue[client] or 0) + 1

			clearTableElements(greenSpace.objects[index])
			destroyHelpMarkers(client, false)

			greenSpace.objects[index] = nil

			checkGreenEmpty()

		else

			checkGreenEmpty()

		end
		
	end
	addEvent('green.mowObject', true)
	addEventHandler('green.mowObject', resourceRoot, mowGreenObject)

--------------------------------------------------------------------