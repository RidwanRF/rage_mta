
------------------------------------------------------------------------------------------

	crans = {}

------------------------------------------------------------------------------------------

	Cran_class = {

		init = function( self, data )

			local bx,by,bz, brz = unpack( data.base )
			local tx,ty,tz, trz = unpack( data.tower )

			self.base = createObject( 1188, bx,by,bz, 0, 0, brz )
			self.tower = createObject( 1189, tx,ty,tz, 0, 0, trz )

			crans[ self.base ] = self

		end,

		displayMovie = function( self, from, to )

			local tx,ty,tz = getElementPosition(self.tower)
			local radius = 28.58

			local fx,fy = getPointFromDistanceRotation( tx,ty, radius-1.35, -from+180+1.05 )
			-- fx = fx - 1
			local fz = getGroundPosition(fx,fy, 20)+1

			self.lineHeight = 0

			local rot1 = findRotation( self.tower.position.x, self.tower.position.y, fx,fy )-180

			local rx,ry = getPointFromDistanceRotation( tx,ty, radius-1.35, -to+180+1.05 )
			-- rx = rx - 1

			self.movie_object = createObject( 5844, fx,fy,fz )
			self.movie_object.scale = Vector3(1.27, 1.44, 22.34)

			self.containers = {}

			local y = -4
			for i = 1,3 do

				self.containers[i] = createObject( 1187, fx,fy,fz )
				attachElements( self.containers[i], self.movie_object, 0, y, 1.5 )
				y = y + 4

			end

			-- self.movie_object = createObject( 1187, fx,fy,fz )

			self.movie = {

				rotation = {
					self.tower.rotation.z,
					rot1, to,
				},

				position = {

					{ fx,fy,fz },
					{ fx,fy,tz+10 },
					{ rx,ry,tz+10 },
					{ rx,ry,getGroundPosition(rx,ry,tz+10)-0.1 },

				},

				radius = radius,

			}

			self.animation = {}
			timed_setAnimData( self.animation, Config.cranMovieTime )

			timed_animate(self.animation, true, function()


			end)


		end,

		render = function( self )

			if not self.animation then return end
			if not isElement(self.movie_object) then return end

			local progress = getEasingValue( timed_getAnimData( self.animation ), 'InOutQuad' )
			local animState = divideAnim( progress, 4 )
			for index in pairs(animState) do
				animState[index] = getEasingValue( animState[index], 'InOutQuad' )
			end

			if animState[1] < 1 then

				local rotation = massInterpolate( { self.movie.rotation[1] }, { self.movie.rotation[2] }, animState[1], 'Linear' )
				setElementRotation( self.tower, 0, 0, rotation )

			elseif animState[2] < 1 then

				local anims = divideAnim( animState[2], 2 )

				for index in pairs(anims) do
					anims[index] = getEasingValue( anims[index], 'InOutQuad' )
				end

				self.lineHeight = anims[1]

				local fx,fy,fz = massInterpolate( self.movie.position[1], self.movie.position[2], anims[2], 'Linear' )
				setElementPosition( self.movie_object, fx,fy,fz )

			elseif animState[3] < 1 then

				local rotation = massInterpolate( { self.movie.rotation[2] }, { self.movie.rotation[3] }, animState[3], 'Linear' )
				setElementRotation( self.tower, 0, 0, rotation )

				local tx,ty = getElementPosition( self.tower )
				local _, _, fz = getElementPosition( self.movie_object )

				local rx,ry = getPointFromDistanceRotation( tx,ty, self.movie.radius, -rotation+180 )
				setElementPosition( self.movie_object, rx,ry,fz )

			elseif animState[4] < 1 then

				local anims = divideAnim( animState[4], 2 )

				for index in pairs(anims) do
					anims[index] = getEasingValue( anims[index], 'InOutQuad' )
				end

				local fx,fy,fz = massInterpolate( self.movie.position[3], self.movie.position[4], anims[1], 'Linear' )
				setElementPosition( self.movie_object, fx,fy,fz )

				self.lineHeight = (1-anims[2])

			end

			-- self.lineHeight = 1

			local _,_,trz = getElementRotation( self.tower )

			local tx,ty,tz = getElementPosition( self.tower )
			local fx,fy,fz = getElementPosition( self.movie_object )

			local rx,ry = getPointFromDistanceRotation( tx,ty, self.movie.radius-1.35, -trz+180+1.05 )

			local rz = tz+18

			local endZ = rz + ( fz - rz )*self.lineHeight

			dxDrawLine3D( rx,ry,rz, rx,ry,endZ, tocolor(0,0,0,255), 20 )

		end,
	
	}

	initClasses()

------------------------------------------------------------------------------------------

	addEventHandler('onClientRender', root, function()

		for base, cran in pairs( crans ) do
			cran:render()
		end

	end)

------------------------------------------------------------------------------------------


	addEventHandler('onClientResourceStart', resourceRoot, function()
		auctionContainerCran = Cran( Config.cran )
	end)

	addEvent('auction.displayCranMovie', true)
	addEventHandler('auction.displayCranMovie', resourceRoot, function()

		if isElement(auctionContainerCran.movie_object) then 
			destroyElement(auctionContainerCran.movie_object)
		end

		setTimer(function()
			auctionContainerCran:displayMovie( Config.movie.from, Config.movie.to )
		end, 100, 1)

	end)

	addEvent('auction.blowCranMovie', true)
	addEventHandler('auction.blowCranMovie', resourceRoot, function(ctr_id)

		if auctionContainerCran.containers and isElement(auctionContainerCran.containers[ctr_id]) then 

			local x,y,z = getElementPosition( auctionContainerCran.containers[ctr_id] )
			createExplosion(x,y,z, 10, false, -3, false)

			destroyElement(auctionContainerCran.containers[ctr_id])
			auctionContainerCran.containers[ctr_id] = nil

			if getTableLength( auctionContainerCran.containers ) == 0 then

				if isElement(auctionContainerCran.movie_object) then
					destroyElement(auctionContainerCran.movie_object)
				end
				auctionContainerCran.movie_object = nil

			end

		end

	end)

------------------------------------------------------------------------------------------