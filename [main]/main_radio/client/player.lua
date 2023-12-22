
----------------------------------------------------------------------

	function cacheURL( path, url )

		local cached = localPlayer:getData('radio.cachedURLs') or {}
		cached[path] = url

		localPlayer:setData('radio.cachedURLs', cached, false)

	end

	function getCachedURL( path )

		local cached = localPlayer:getData('radio.cachedURLs') or {}
		return cached[path]

	end

----------------------------------------------------------------------

	function toggleTrack( data )

		data.creator = localPlayer
		setLocalSoundData('data', data)

		if isCurrentTrack( data ) then
			local paused = getLocalElementSoundData('paused')
			return setLocalSoundData('paused', not paused)
		end

		-- data.url = data.url or getCachedURL( data.path )
		-- if data.url then
		-- 	return playTrack( data.url )
		-- end

		setLocalSoundData('url', false)

		if data.path and data.path:find('.mp3') then
			loadTrack_callback( data.path, data.path )
		else
			triggerServerEvent('radio.playMusic', resourceRoot, data.path)
		end

	end

	function loadTrack_callback( path, url )

		local ssound = { pcall( loadstring( "return playSound3D( " .. tostring( path ) .. ", 5000, 5000, 5000, false, true )" ) ) }
		local sound = ssound[ 2 ]
		setSoundVolume(sound, 0)

		if isTimer(checkMusicTimer) then killTimer(checkMusicTimer) end

		checkMusicTimer = setTimer(function(sound, path, url)

			local length = getSoundLength(sound)
			local _, _, count = getTimerDetails(checkMusicTimer)

			if length == 0 and count == 1 then
				return outputDebugString(getTickCount(  ), '[PLAYER] ERROR LOADING TRACK')
			else

				if path and url then cacheURL(path, url) end
				playTrack( url )
				return killTimer(checkMusicTimer)

			end

			-- stopSound(sound)

		end, 100, 10, sound, path, url)

	end

	addEvent('radio.playMusic_callback', true)
	addEventHandler('radio.playMusic_callback', root, loadTrack_callback)


----------------------------------------------------------------------

	function playTrack( url )

		setLocalSoundData('url', url)
		setLocalSoundData('position', 0)
		setLocalSoundData('volume', soundSlider.value)
		setLocalSoundData('paused', false)

	end

----------------------------------------------------------------------

	function setTrackPosition( position )
		setLocalSoundData('position', position)
	end

	function setTrackVolume( volume )
		setLocalSoundData('volume', volume)
	end

	function isCurrentTrack( data, isPlaying )

		local url = data.url or getCachedURL( data.path )
		local current_url = getLocalElementSoundData('url') or ''

		local playing_bool = true
		if isPlaying then playing_bool = not getLocalElementSoundData('paused') end

		return current_url == url and playing_bool

	end

----------------------------------------------------------------------

	function getCurrentTrack()

	end

	function moveCurrentSound( delta )

		local selected = 0

		for index, lElement in pairs( musicList.elements ) do
			if isCurrentTrack( lElement.data ) then
				selected = index
				break
			end
		end

		local item = musicList.elements[ selected + delta ]
		if not item then
			item = delta >= 0 and musicList.elements[1] or musicList.elements[#musicList.elements]
		end

		if item then
			toggleTrack(item.data)
		end

	end

	function playNextSound()
		moveCurrentSound(1)
	end

	function playPreviousSound()
		moveCurrentSound(-1)
	end

----------------------------------------------------------------------

	setTimer(function()

		local element = getLocalSoundElement()

		if isElement(element) then

			local soundData = elementSounds[element] or {}

			if soundData.path and not isElement( soundData.sound ) then

				if musicList.repeatCurrent then
					-- moveCurrentSound(0)

					local url = getLocalElementSoundData('url')

					destroyElementSound( element )
					setLocalSoundData( 'url', false )

					setTimer(playTrack, 300, 1, url)
				else
					playNextSound()
				end

				soundData.path = nil

			end


		end

	end, 1000, 0)

----------------------------------------------------------------------