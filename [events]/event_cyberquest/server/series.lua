

--------------------------------------------------

	playersSeries = {}

--------------------------------------------------

	function addPlayerSeries( player, series_str, id )

		playersSeries[ player ] = playersSeries[ player ] or {}
		playersSeries[ player ][ series_str ] = playersSeries[ player ][ series_str ] or {}

		local series = playersSeries[ player ][ series_str ]

		if series.current ~= id  then

			if series.current then
				local reset_dataName = ('cyberquest.series.%s.%s'):format( series_str, series.current )
				resetQuestProgress( player, reset_dataName )
			end

			series.score = 1

		else
			series.score = ( series.score or 0 ) + 1
		end

		series.current = id

		increaseElementData( player, ('cyberquest.series.%s.%s'):format( series_str, id ), 1, false )

	end

--------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if playersSeries[ source ] then

			for key, series in pairs( playersSeries[ source ] ) do

				if series.current then
					resetQuestProgress( source, ('cyberquest.series.%s.%s'):format( key, series.current ) )
				end

			end

			playersSeries[ source ] = nil

		end

	end)

--------------------------------------------------