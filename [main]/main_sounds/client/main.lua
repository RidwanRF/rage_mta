
mta_playSound = playSound

function playSound(path, ...)
	local _path = string.format('assets/sounds/%s.mp3', path)
	local sound = mta_playSound(_path, ...)

	if sound then
		setSoundVolume(sound, 0.5)
	end

	return sound
end

addEvent('sound.play', true)
addEventHandler('sound.play', root, playSound)