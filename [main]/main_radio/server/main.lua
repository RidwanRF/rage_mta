
--------------------------------------------------------

	function saveItem(data)
		local items = client:getData('radio.saved') or {}
		data.saveTime = getRealTime().timestamp
		data.creator = nil
		items[data.path] = data
		client:setData('radio.saved', items)
	end
	addEvent('radio.saveItem', true)
	addEventHandler('radio.saveItem', root, saveItem)

	function removeItem(path)
		local items = client:getData('radio.saved') or {}
		items[path] = nil
		client:setData('radio.saved', items)
	end
	addEvent('radio.removeItem', true)
	addEventHandler('radio.removeItem', root, removeItem)

--------------------------------------------------------

	function doSearch(text)
		if text == '' then
			fetchRemote("https://savemusic.me/",
			-- fetchRemote("https://hotmo.org/",
				doSearch_callback, "", false, client )
		else
			fetchRemote("https://savemusic.me/search/"..URLEncode( text ).."/",
			--fetchRemote("https://savemusic.me/"..(utf8.gsub( URLEncode(text) ," ","+")),
				doSearch_callback, "", false, client )
		end
	end
	addEvent('radio.doSearch', true)
	addEventHandler('radio.doSearch', resourceRoot, doSearch)


	function doSearch_callback( data, err, player )

		local music = {}
		local lastPos = 0
		local _, preStart = utf8.find( data, '<body>' )
	    local _, startS = utf8.find( data, 'c-section', preStart )
	    local endS = utf8.find( data, 'l-side', startS )

	    data = utf8.sub( data, startS, endS )

		
		for i = 1, 100 do
	        local _, startArtist = utf8.find( data, 'c-artist">', lastPos )
	        local stopArtist = utf8.find( data, '</s', startArtist )
	        local _, startName = utf8.find( data, 'c-title">', lastPos )
	        local stopName = utf8.find( data, '</s', startName )
	        local preStartSUrl, startSUrl = utf8.find( data, 'url":"', lastPos )
	        local _, endSUrl = utf8.find( data, '.mp3"', startSUrl )
	
	        if startSUrl and endSUrl and startArtist then
	            if i > 0 then
	                local url = utf8.sub( data, startSUrl, endSUrl )
	                local author = utf8.sub( data, startArtist + 1, stopArtist - 1)
	                local name = utf8.sub( data, startName + 1, stopName - 1 )

	                local s = utf8.find ( url, ':"' )
					if s then
						url = tostring ( utf8.sub ( url, s + 1 ) )
					end
	
	                table.insert( music, {
					    	artist = author,
					    	name = name,
					    	duration = '25',
					    	path = url,
				    	} )
	                lastPos = stopName
	            else
	                lastPos = preStartSUrl
	            end
	        end
	    end
		triggerClientEvent(player, 'radio.doSearch_callback', player, music)
	end


	function playMusic_callback(data, err, player, _path)
		
		local musicData = fromJSON(data)

	    local pos_start, pos_e = utf8.find( data, "\"url\":\"" ) 
		local pos_end = utf8.find( data, "\"}", pos_e )
		if not pos_e or not pos_end then return end

		local url = utf8.sub( data, pos_e or 0, pos_end )
		url = utf8.gsub( url, "\"", "")

		triggerClientEvent(player, 'radio.playMusic_callback', player, _path, url)
	end

	function playMusic(json_url)
		fetchRemote("https://zaycev.net" ..utf8.gsub(json_url, " ", "" ), playMusic_callback, "", false, client, json_url)
	end
	addEvent('radio.playMusic', true)
	addEventHandler('radio.playMusic', resourceRoot, playMusic)

	function getMusicData( data, startS )
		
		local pos_start, pos_e = utf8.find( data, '<div class="track__title">', pos_end )
		local pos_end  = utf8.find( data, '</div>', pos_e )

		-- local file = fileCreate('a.txt')
		-- fileWrite(file, data)
		-- fileClose(file)

		local text_music = utf8.sub( data, pos_e, pos_end-1 )
		text_music = utf8.gsub( text_music, "\"", "")
		text_music = utf8.gsub( text_music, "\n", "")
		text_music = utf8.gsub( text_music, "  ", "")
		text_music = utf8.sub(text_music, 2)

	    local pos_start, pos_e = utf8.find( data, '<div class="track__desc">', startS )
		local pos_end  = utf8.find( data, '</div>', pos_e )
		local text_artist = utf8.sub( data, pos_e + 2, pos_end-1 )

	    local pos_start, pos_e = utf8.find( data, '<div class="track__fulltime">', startS )
		local pos_end  = utf8.find( data, '</div>' )
		local duration = utf8.sub(data, pos_e, pos_end)

	    local pos_start, pos_e = utf8.find( data, 'https://rum.hotmo.org/' )
		local pos_end  = utf8.find( data, '.mp3', pos_e )

		local url = utf8.sub( data, pos_start, pos_end+3 )

		return text_artist, text_music, duration, url
	end

--------------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()
		for _, vehicle in pairs( getElementsByType('vehicle') ) do
			vehicle:setData('sound.url', nil)
		end
	end)

--------------------------------------------------------
