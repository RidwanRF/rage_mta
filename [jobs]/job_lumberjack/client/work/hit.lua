
------------------------------------------------------------

	local hitForce = { force = 0, step = 0.02, direction = 1 }

	local hit_force_anim = {}
	setAnimData( hit_force_anim, 0.3 )
	
	function renderTreeHit()

		if localPlayer:getData('work.current') == Config.resourceName then

			local draw_cond = (
				getKeyState('mouse2')
				and isElement( workMarker.marker )
				and isElementWithinMarker( localPlayer, workMarker.marker )
				and not localPlayer.vehicle
			)

			if draw_cond then
				hitForce.force = math.clamp( hitForce.force + hitForce.step * hitForce.direction, 0, 1 )
			end

			animate( hit_force_anim, draw_cond and 1 or 0 )
			local anim = getAnimData( hit_force_anim )

			if hitForce.force == 1 or hitForce.force == 0 then
				hitForce.direction = -hitForce.direction
			end

			local w,h = 452, 52

			local x,y = sx/2 - w/2, ( real_sy - px(h) - px(200) ) * sx/real_sx

			dxDrawImage(
				x,y,w,h, 'assets/images/work/bg.png',
				0, 0, 0, tocolor( 255,255,255,255*anim )
			)

			local rw,rh = 31, 81
			local rx,ry = x + 40 + (w-80)*hitForce.force - rw/2, y+h/2-rh/2
			-- local rx,ry = x+w*hitForce.force - rw/2, y+h/2-rh/2

			dxDrawImage(
				rx,ry,rw,rh, 'assets/images/work/del.png',
				0, 0, 0, tocolor( 180,70,70,255*anim )
			)


			if isElement(workMarker.marker) and isElementWithinMarker( localPlayer, workMarker.marker ) then

				local health = 0

				if workMarker.stage == 'cut' then health = workMarker.health
				elseif workMarker.stage == 'slice' then health = getCurrentSliceMarker().health end

				animate( workMarker.tree_health_anim, health )

				if health > 0 then

					local health_anim = getAnimData( workMarker.tree_health_anim )

					local tx,ty,tz = getElementPosition( workMarker.marker )
					local dx,dy = getScreenFromWorldPosition( tx,ty,tz + 1.3 )

					if dx and dy then

						local alpha = 1

						local mask = getRoundMask( roundTexture, {

							color = { 230,90,90, 255 },
							alpha = alpha,

							angle = { 0, 360 * health_anim / 1000 },

						} )

						local w,h = 80, 80
						local x,y = dx - w/2, dy - h/2

						dxDrawImage(
							x,y,w,h, roundTexture,
							0, 0, 0, tocolor( 25,24,38,255*alpha )
						)

						dxDrawImage(
							x,y,w,h, mask
						)

						dxDrawImage(
							x,y,w,h, 'assets/images/work/axe.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end


				end


			end


		end

	end

	addEventHandler('onClientRender', root, renderTreeHit)

------------------------------------------------------------

	function handleTreeHit()

		local force = math.random( 200, 300 ) * ( 0.5 + hitForce.force )

		if workMarker.stage == 'cut' then


			workMarker.health = math.clamp( workMarker.health - force, 0, 1000 )

			if workMarker.health <= 0 then

				handleTreeFall()
				workMarker.stage = false

			end

		elseif workMarker.stage == 'slice' then

			local marker = getCurrentSliceMarker()
			marker.health = math.clamp( marker.health - force, 0, 1000 )

			if marker.health <= 0 then

				sliceCurrentMarker()

				orderLogLoad( function()

					if not createSliceMarker() then
						completeWorkMarker()
					end

				end )


			end

		end

	end

------------------------------------------------------------

	addEventHandler('onClientKey', root, function( button, state )

		if

			(
				localPlayer:getData('work.current') == Config.resourceName
				and not localPlayer.vehicle
			)

		then

			if not isCursorShowing() and button:find('mouse_wheel') then
				return cancelEvent()
			end

			if (
				button == 'mouse2'
				and isElement( workMarker.marker )
				and isElementWithinMarker( localPlayer, workMarker.marker )
			) then

				if isTimer( treeHit_timer ) then return end


				local x,y,z = getElementPosition( localPlayer )
				local tx,ty,tz = getElementPosition( workMarker.marker )

				local r = findRotation( x,y, tx,ty )

				setElementRotation( localPlayer, 0, 0, r )

				if state then
					
					setPedAnimation( localPlayer, 'baseball', 'bat_idle', -1 )
					hitForce = { force = 0, step = 0.02, direction = 1 }
					workMarker.last_hit = getTickCount(  )

				else

					local oftenHit = workMarker.last_hit and ( getTickCount() - workMarker.last_hit ) < 300
					if oftenHit then return setPedAnimation( localPlayer, false ) end

					local anim_group, anim_name

					if workMarker.stage == 'cut' then
						anim_group, anim_name = 'baseball', 'bat_' .. math.random( 1,3 )
					elseif workMarker.stage == 'slice' then
						anim_group, anim_name = 'sword', 'sword_3'
					end

					setPedAnimation( localPlayer, anim_group, anim_name, -1, false, true, true, false )
					treeHit_timer = setTimer(handleTreeHit, 500, 1)

				end

			end


		end

	end)


------------------------------------------------------------