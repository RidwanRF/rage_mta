

----------------------------
	
	Springboard_class = {

		init = function( self, data )

			self.vehicle = data.vehicle

			local x,y,z = getElementPosition( self.vehicle )

			local distance = 10
			local speed = getElementSpeed( self.vehicle, 'kmh' )

			distance = distance + (math.clamp( speed-150, 0, 500 )/100*15)

			local ox,oy,oz = getPositionFromElementOffset( self.vehicle, 0, distance, 0 )

			local r = findRotation( ox,oy, x,y )

			self.object = createObject( 5844, ox,oy,oz, -30, 0, r )

			self.object.dimension = self.vehicle.dimension
			self.object.interior = self.vehicle.interior

			self:start()

		end,

		destroy = function( self )

			resetVehicleAbility( self.vehicle, 'springboard' )

			self.vehicle = nil
			clearTableElements( self )

		end,

		start = function( self )

			self.timer = setTimer(function()
				self:finish()
			end, 1500, 1)

		end,

		finish = function( self )

			local x,y,z = getElementPosition( self.object )
			moveObject( self.object, 500, x,y,z-2, 0, 0, 0, 'InOutQuad' )

			self.finish_timer = setTimer(function()
				self:destroy()
			end, 500, 1)


		end,

	}

	initClasses()
	
----------------------------