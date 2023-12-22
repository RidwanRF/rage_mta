
function enterShop( exitPos )

	if localPlayer:getData('clothes.savedPos') then return end

	fadeCamera(false, 0.5)

	setTimer(function()
		fadeCamera(true, 0.5)

		localPlayer:setData('clothes.savedPos', {
			pos = exitPos and exitPos or { getElementPosition(localPlayer) },
			r = ({ getElementRotation(localPlayer) })[3],
			interior = localPlayer.interior,
			dimension = localPlayer.dimension,
		})

		localPlayer:setData('speed.hidden', true, false)
		localPlayer:setData('radar.hidden', true, false)
		-- localPlayer:setData('notify.hidden', true, false)

		createPreview()
		openWindow('main')

	end, 1000, 1)
end

function exitShop()
	fadeCamera(false, 0.5)

	setTimer(function()
		fadeCamera(true, 0.5)

		finishPreview()

		local data = localPlayer:getData('clothes.savedPos') or {}
		setElementPosition(localPlayer, unpack(data.pos))
		setElementRotation(localPlayer, 0, 0, data.r or 0)
		setCameraTarget(localPlayer, localPlayer)

		localPlayer:setData('clothes.savedPos', false)

		localPlayer:setData('speed.hidden', false, false)
		localPlayer:setData('radar.hidden', false, false)
		-- localPlayer:setData('notify.hidden', false, false)

		stopCamera()


	end, 1000, 1)

end
