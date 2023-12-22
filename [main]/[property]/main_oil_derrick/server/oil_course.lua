
-----------------------------------------------------------------

	OilCourse = {}

-----------------------------------------------------------------

	function updateOilCourse()

		local course = dbPoll( dbQuery(db, 'SELECT * FROM oil_course ORDER BY id DESC LIMIT 24;'), -1)

		if not (course and course[1]) then

			OilCourse.current = Config.derrick.course.default
			OilCourse.history = {}

			return

		end

		OilCourse.current = course[1].cost
		OilCourse.history = table.reverse(course)

		resourceRoot:setData('oil.course', OilCourse)

	end

	function getCurrentCourse()
		return OilCourse.current or 0
	end

-----------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(db, string.format('DROP TABLE oil_course;'))
		dbExec(db, string.format('CREATE TABLE IF NOT EXISTS oil_course(id INTEGER PRIMARY KEY, timestamp INTEGER, cost INTEGER);'))

		updateOilCourse()

	end)

-----------------------------------------------------------------

	function oilCourseCycle(_course)

		local course = getCurrentCourse()

		local default = Config.derrick.course.default
		local step = Config.derrick.course.change_step

		course = _course or math.clamp(
			course + math.random( -default/100*step, default/100*step ),
			default + default/100*Config.derrick.course.change_range[1],
			default + default/100*Config.derrick.course.change_range[2]
		)

		dbExec(db, string.format('INSERT INTO oil_course(timestamp, cost) VALUES (%s, %s);',
			getRealTime().timestamp, course
		))

		updateOilCourse()

	end

	addEventHandler('onServerHourCycle', root, oilCourseCycle)

-----------------------------------------------------------------

	addCommandHandler('oil_course_cycle', function(player, _, course)

		if exports.acl:isAdmin(player) then
			oilCourseCycle( tonumber(course) )
		end

	end)

-----------------------------------------------------------------