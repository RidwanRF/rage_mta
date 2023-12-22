

----------------------------
	
	Impulse_class = {

		init = function( self, data )

			self.vehicle = data.vehicle

			self.handling = getVehicleHandling( self.vehicle )

			setVehicleHandling( self.vehicle, 'maxVelocity', 1000 )
			setVehicleHandling( self.vehicle, 'engineAcceleration', 300 )
			setVehicleHandling( self.vehicle, 'tractionMultiplier', 10 )

			setTimer(function()
				self:finish()
			end, 2000, 1)

		end,

		destroy = function( self )

			resetVehicleAbility( self.vehicle, 'impulse' )

			self.vehicle = nil
			clearTableElements( self )

		end,

		finish = function( self )

			self.vehicle:setHandling( 'maxVelocity', self.handling.maxVelocity )
			self.vehicle:setHandling( 'engineAcceleration', self.handling.engineAcceleration )
			self.vehicle:setHandling( 'tractionMultiplier', self.handling.tractionMultiplier )

			self.finish_timer = setTimer(function()
				self:destroy()
			end, 500, 1)


		end,

	}

	initClasses()
	
----------------------------