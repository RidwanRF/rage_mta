function around(number, decimals)
  return tonumber(string.format("%."..(tonumber(decimals) or 0).."f", tostring(number)))
end

addCommandHandler('takecoords', function(_, onlyPos)
	local x,y,z = getElementPosition(localPlayer.vehicle or localPlayer)
	local rx,ry,rz = getElementRotation(localPlayer.vehicle or localPlayer)

	if onlyPos == 'true' then
		setClipboard( inspect( {
			around(x, 2),
			around(y, 2),
			around(z, 2),
		} ) )
	else
		setClipboard( inspect( {
			around(x, 2),
			around(y, 2),
			around(z, 2),
			around(rx, 2),
			around(ry, 2),
			around(rz, 2)
		} ) )
	end
	outputChatBox('coords set to clipboard')
end)

addCommandHandler('takematrix', function()
	local x,y,z, tx,ty,tz, r, fov = getCameraMatrix()


	setClipboard( inspect( {
		around(x, 2),
		around(y, 2),
		around(z, 2),
		around(tx, 2),
		around(ty, 2),
		around(tz, 2),
		around(r, 2),
		around(fov, 2)
	} ) )

	outputChatBox('matrix set to clipboard')
end)

addCommandHandler('dotp', function(_, x,y,z)

	if not exports.acl:isAdmin(localPlayer) then return end

	setElementPosition(localPlayer.vehicle or localPlayer, 
		tonumber(x),
		tonumber(y),
		tonumber(z)
	)

	outputChatBox('tp succesfully')
end)

addCommandHandler('cbdn', function(_, dn)

	setClipboard(inspect(localPlayer:getData(dn)))

	outputChatBox('cbdn succesfully')
end)

addCommandHandler('vcbdn', function(_, dn)

	setClipboard(inspect(localPlayer.vehicle:getData(dn)))

	outputChatBox('vcbdn succesfully')
end)

addCommandHandler('tcbdn', function(_, dn)

	setClipboard(inspect(localPlayer.team:getData(dn)))

	outputChatBox('tcbdn succesfully')
end)

addCommandHandler('cbhd', function(_, dn)

	setClipboard(inspect(localPlayer.vehicle:getHandling()))

	outputChatBox('cbhd succesfully')
end)

addCommandHandler('cbrt', function(_, ts)

	setClipboard(inspect(getRealTime(tonumber(ts) or nil)))

	outputChatBox('cbrt succesfully ' .. tostring(tonumber(ts) or nil))
end)

addCommandHandler('cbpos', function(_, ts)

	setClipboard(inspect({
		pos = { getElementPosition( localPlayer ) },	
		rot = { getElementRotation( localPlayer ) },	
		dim = localPlayer.dimension,
		int = localPlayer.interior,
	}))
	outputChatBox('cbpos succesfully')

end)

addCommandHandler('cbvc', function(_, dn, ts)

	local list = {}

	for component in pairs( getVehicleComponents(localPlayer.vehicle) ) do
		list[component] = {
			pos = { getVehicleComponentPosition( localPlayer.vehicle, component ) },
			rot = { getVehicleComponentRotation( localPlayer.vehicle, component ) },
		}
	end

	setClipboard(inspect( list ))

	outputChatBox('cbvc succesfully')
end)

addCommandHandler('devmode', function()
	if not exports.acl:isAdmin(localPlayer) then return end
	outputChatBox('devmode succesfully')
	setDevelopmentMode(true)
end)


addCommandHandler('randanim', function(_, group, name)

	local group = animationsList[math.random(#animationsList)]
	local name = group.anims[math.random(#group.anims)]

	setClipboard(inspect({group.name, name}))

	triggerServerEvent('useful.anim', resourceRoot, localPlayer, group.name, name, 1, false, true)

	outputChatBox('randanim succesfully')
end)

addCommandHandler('anim', function(_, group, name)

	triggerServerEvent('useful.anim', resourceRoot, localPlayer, group, name, 1, false, true)

	outputChatBox('anim succesfully')
end)

addCommandHandler('fc', function(_)
	fadeCamera(true, 0.1)
	outputChatBox('fc succesfully')
end)

addCommandHandler('colrect', function(_,x,y,w,h)

	if exports.acl:isAdmin( localPlayer ) then

		x = tonumber(x); y = tonumber(y);
		w = tonumber(w); h = tonumber(h);

		if isElement(current_rect) then
			destroyElement( current_rect )
		end

		if x and y and w and h then
			current_rect = createColRectangle( x,y,w,h )
			current_rect:setData('render', true)
			outputChatBox('colrect succesfully')
		end

	end

end)

addCommandHandler('colpol', function(_,...)

	if exports.acl:isAdmin( localPlayer ) then

		local args = {...}

		for index, arg in pairs( args ) do
			args[index] = tonumber(args[index])
		end

		if isElement(current_rect) then
			destroyElement( current_rect )
		end

		current_rect = createColPolygon( unpack(args) )
		outputChatBox('colpol succesfully')

	end

end)

addEventHandler('onClientColShapeHit', resourceRoot, function( element )

	if source == current_rect and element == localPlayer then
		print(getTickCount(  ), 'TEST SHAPE HIT')
	end

end)

------------------------------------------------------

	addCommandHandler('texstat', function(_)

		if not exports.acl:isAdmin(localPlayer) then return end

		triggerServerEvent('useful.returnResources', resourceRoot)


	end)

	addEvent('useful.receiveResources', true)
	addEventHandler('useful.receiveResources', resourceRoot, function(resources)

		setClipboard(inspect(resources))
		local stat = {}

		for _, res_name in pairs( resources ) do

			local resource = getResourceFromName(res_name)

			stat[res_name] = {}

			for _, texture in pairs( getElementsByType('texture', getResourceRootElement(resource)) ) do

				local res = texture.parent.parent
				table.insert(stat[res_name], {
					size = { dxGetMaterialSize(texture) },
					texture = texture,
				})

			end

		end

		setClipboard( inspect(stat) )
		outputChatBox('texstat succesfully')

	end)

------------------------------------------------------


local bindex, nindex = 1,1
addCommandHandler('nextanim', function()

	if not animationsList[bindex].anims[nindex] then
		bindex = bindex + 1
		nindex = 1
	end

	local group_ = animationsList[bindex]
	local group = group_.name
	local name = group_.anims[nindex]

	nindex = nindex + 1

	setClipboard(inspect({group, name}))

	triggerServerEvent('useful.anim', resourceRoot, localPlayer, group, name, 1, false, true)

	outputChatBox('nextanim succesfully')
end)

addCommandHandler('setlocalplate', function(_, plate)
	if exports.acl:isAdmin(localPlayer) or exports.acl:isPlayerInGroup(localPlayer, 'press') then
		localPlayer.vehicle:setData('plate', plate, false)
	end
end)



addCommandHandler('fpslimit', function(_, limit)

	if exports.acl:isAdmin(localPlayer) then

		setFPSLimit( tonumber(limit) or 100 )
		outputChatBox('fpslimit succesfully')

	end

end)