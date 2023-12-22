
------------------------------------

	CaptureMatch_class = {

		init = function( self )

			local x,y,z = unpack( self.map.base )

			self.base = createMarker( x,y,z, 'cylinder', 4, 255, 0, 0, 150 )
			self.base_blip = createBlipAttachedTo( self.base, 0 )

			self.base:setData('controlpoint.3dtext', '[База]')
			self.base:setData('capture.progress', 0)

			self.base_blip:setData('icon', 'target')

			self.base.dimension = self.dimension
			self.base_blip.dimension = self.dimension
			
			self.captureTimer = setTimer(function()
				if self.started then
					self:updateBaseCapture()
				end
			end, 1000, 0)

		end,

		updateBaseCapture = function( self )

			if not isElement(self.base) then
				return
			end

			local add = 0
			local progress = self.base:getData('capture.progress') or 0

			for player in pairs( self.players.attackers or {} ) do

				if isElementWithinMarker( player, self.base ) and not isPedDead(player) then
					add = add + 1
				end

			end

			add = math.clamp( add, 0, 3 )
			if add == 0 then add = -4 end

			if ( progress + add ) >= 100 then
				self:finish( 'attackers' )
			else
				self.base:setData('capture.progress', math.clamp( progress + add, 0, 100 ))
			end


		end,

	}

	extendClass(CaptureMatch_class, Match_class)

------------------------------------

	addEventHandler('onPlayerDamage', root, function()

		if source.dimension > 0 then

			local match = getPlayerMatch( source )

			if match and match.mode == 2
				and match.players.attackers and match.players.attackers[source]
				and isElementWithinMarker( source, match.base )
			then

				if not isElement(match.base) then
					return
				end

				local progress = match.base:getData('capture.progress') or 0
				match.base:setData('capture.progress', math.clamp( progress - 1, 0, 100 ))
				
			end

		end

	end)

------------------------------------
