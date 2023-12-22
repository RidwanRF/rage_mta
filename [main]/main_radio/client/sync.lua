
-----------------------------------------------------------------

	function getLocalSoundElement()

		if localPlayer.vehicleSeat == 0 then
			return localPlayer.vehicle
		end

	end

	function setLocalSoundData(key, value, sync)

		local element = getLocalSoundElement()
		if not isElement(element) then return end

		element:setData('sound.'..key, value, sync)

	end

	function getLocalElementSoundData(key)
		local element = getLocalSoundElement()
		if not isElement(element) then return end

		return element:getData('sound.'..key)
	end

	function getElementSoundData(element, key)
		return element:getData('sound.'..key)
	end

-----------------------------------------------------------------

	elementSounds = {}

	function createElementSound( element, path )

		local x,y,z = getElementPosition(element)

		local s = { pcall( loadstring( "return playSound3D( " .. tostring( path ) .. ", 5000, 5000, 5000, false, true )" ) ) }
		elementSounds[element] = {
			sound = s [ 2 ],
			path = path,
		}

		elementSounds[element].sound:setData('url', path)

		setSoundMaxDistance(elementSounds[element].sound, 50)
		attachElements(elementSounds[element].sound, element)

		return elementSounds[element]

	end

	function destroyElementSound( _element )

		local element = _element or source

		for _, s_element in pairs( elementSounds[element] or {} ) do
			if isElement(s_element) then
				destroyElement(s_element)
			end
		end

		elementSounds[element] = nil

	end

	function updateElementSound( element )

		local url, position, volume, paused, data = 
			getElementSoundData( element, 'url' ),
			getElementSoundData( element, 'position' ) or 0,
			getElementSoundData( element, 'volume' ) or 0.5,
			getElementSoundData( element, 'paused' ),
			getElementSoundData( element, 'data' ) or {}

		local syncRadio = localPlayer:getData('settings.sync_radio')
		if not syncRadio and data.creator ~= localPlayer then return destroyElementSound( element ) end

		if not url then return destroyElementSound( element ) end

		local soundData = elementSounds[element] or {}
		local currentUrl = soundData.path

		if currentUrl ~= url then
			destroyElementSound( element )
		end

		soundData = elementSounds[element] or createElementSound( element, url, position )

		if isElement(soundData.sound) then
			soundData.sound:setVolume(volume/100)
			-- soundData.sound:setPlaybackPosition(position)
			soundData.sound:setPaused(paused)
		end

	end

-----------------------------------------------------------------


	addEventHandler('onClientElementDataChange', root, function(dn, old, new)
		if dn:find('sound.') and isElementStreamedIn(source) then
			updateElementSound( source )
		end
	end)

	addEventHandler('onClientElementStreamIn', root, function(dn, old, new)
		if source:getData('sound.url') then
			updateElementSound( source )
		end
	end)

	function updateVehiclesRadio()

		for _, element in pairs( getElementsByType('vehicle', root, true) ) do

			if element:getData('sound.url') then
				updateElementSound( element )
			end

		end

	end

	addEventHandler('onClientResourceStart', resourceRoot, updateVehiclesRadio)

	addEventHandler('onClientElementStreamOut', root, destroyElementSound)
	addEventHandler('onClientElementDestroy', root, destroyElementSound)

-----------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)
		if dn == 'settings.sync_radio' then
			updateVehiclesRadio()
		end
	end)

-----------------------------------------------------------------