
----------------------------------------------------

	ACdisplay = {

		anim = {},

		start = function(self)

			setAnimData(self.anim, 0.02)
			animate(self.anim, 1)

			addEventHandler('onClientRender', root, self.render, true, 'low-8')

		end,

		fadeOut = function(self)
			animate(self.anim, 0)
		end,

		finish = function(self)

			removeEventHandler('onClientRender', root, self.render)
			removeAnimData(self.anim)
			self.achievment_id = nil

		end,


		render = function()

			local self = ACdisplay

			local animData, target = getAnimData(self.anim)

			if target == 0 and animData < 0.01 then
				self:finish()
			end

			local anim_1, anim_2 = unpack( divideAnim(animData, 2) )
			anim_1 = getEasingValue(anim_1, 'InOutQuad')
			anim_2 = getEasingValue(anim_2, 'InOutQuad')

			local hw,hh = 525,84
			local hx,hy = sx/2 - hw/2, 30

			local aw,ah = 100,100

			dxDrawImage(
				hx + hw*anim_1, hy+hh/2 - ah/2,
				aw,ah, 'assets/images/ac_reward/ac_active.png',
				0, 0, 0, tocolor(180,70,70,255*anim_1*(1-anim_2))
			)

			dxDrawImage(
				sx/2 - 1302/2, 0,
				1302, 604, 'assets/images/ac_reward/ac_light.png',
				0, 0, 0, tocolor(180,70,70,200*anim_2)
			)

			dxDrawImage(
				hx,hy,hw,hh, 'assets/images/ac_reward/ac_head.png',
				0, 0, 0, tocolor( 25,24,38,200*anim_2 )
			)

			local scale, font = 0.5, getFont('montserrat_bold', 30, 'light')

			if not self.achievment_id then return end
			local a_id = self.achievment_id.id
			local a_section = self.achievment_id.section

			local achievment = Config[a_section][a_id]
			if not achievment then return end
			if not achievment.name then return end

			local ac_name = a_section == 'achievments' and achievment.name or 'Задание'
			local ac_title = a_section == 'achievments' and achievment.title or achievment.name

			local textWidth = dxGetTextWidth(ac_name, scale, font)

			dxDrawText(ac_name,
				hx + 40, hy,
				hx + 40, hy+hh,
				tocolor(255,255,255,255*anim_2),
				scale, scale, font,
				'left', 'center'
			)

			dxDrawImage(
				hx + 40 + textWidth + 10, hy + hh/2 - 67/2,
				44, 67, 'assets/images/ac_reward/ac_line.png',
				0, 0, 0, tocolor(180, 70, 70, 255*anim_2)
			)

			local scale, font = 0.5, getFont('montserrat_semibold', 23, 'light')
			local fontHeight = dxGetFontHeight(scale, font)

			local tbl = splitString(ac_title, '\n')
			local sCount = #tbl/2
			local padding = -3

			local startY = hy+hh/2 - sCount*fontHeight - padding*(sCount-0.5)


			for _, row in pairs(tbl) do

				dxDrawText(row,
					hx + 40 + textWidth + 54, startY,
					hx + 40 + textWidth + 54, startY,
					tocolor(255,255,255,255*anim_2),
					scale, scale, font,
					'left', 'top'
				)

				startY = startY + fontHeight + padding

			end

			local rw,rh = 66,66

			dxDrawImage(
				hx + hw - 85, hy + hh - rh/2,
				rw,rh, 'assets/images/ac_reward/ac_round.png',
				0, 0, 0, tocolor(116,182,95,255*anim_2)
			)

			dxDrawImage(
				hx + hw - 85, hy + hh - rh/2,
				rw,rh, 'assets/images/ac_reward/ac_round1.png',
				0, 0, 0, tocolor(255,255,255,255*anim_2)
			)

			local rw,rh = 300,152
			local rx,ry = sx/2 - 300/2, hy+hh+30

			dxDrawImage(
				rx,ry,rw,rh, 'assets/images/ac_reward/ac_reward.png',
				0, 0, 0, tocolor(25,24,38,200*anim_2)
			)

			dxDrawText('Награда',
				rx,ry+10,rx+rw,ry+10,
				tocolor(255,255,255,255*anim_2),
				0.5, 0.5, getFont('montserrat_bold', 27, 'light'),
				'center', 'top'
			)

			dxDrawText(a_section == 'achievments' and 'за достижение' or 'за ежедевное задание',
				rx,ry+32,rx+rw,ry+32,
				tocolor(255,255,255,255*anim_2),
				0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
				'center', 'top'
			)

			local rw1, rh1 = 267,84
			local rx1, ry1 = rx+rw/2 - rw1/2, ry + rh - rh1 - 10

			dxDrawImage(
				rx1,ry1,rw1,rh1, 'assets/images/ac_reward/ac_reward1.png',
				0, 0, 0, tocolor(21,21,33,255*anim_2)
			)

			local rewards = a_section == 'achievments' and achievment.reward or achievment.reward.items

			local rewardH = 30
			local padding = 3

			local sCount = #rewards/2

			local startY = ry1 + rh1/2 - sCount*rewardH - padding*(sCount-0.5)

			for _, reward in pairs( rewards ) do

				dxDrawText(reward.text,
					rx1, startY,
					rx1+rw1, startY,
					tocolor(255,255,255,255*anim_2),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'top'
				)

				dxDrawRectangle(
					rx1 + rw1/2 - 30/2, startY + 25,
					30, 2,
					tocolor(180,70,70,255*anim_2)
				)

				startY = startY + rewardH + padding

			end

			dxDrawImage(
				rx+rw-80,ry+rh-70/2,70,70, 'assets/images/ac_reward/ac_gift.png',
				0, 0, 0, tocolor(255,255,255,255*anim_2)
			)

		end,

	}

----------------------------------------------------
	
	function hasAchievmentDisplay()
		return ACdisplay.achievment_id
	end

----------------------------------------------------

	function displayAchievmentReward(ac_id, section)

		if ACdisplay.achievment_id then
			return false
		end

		ACdisplay.achievment_id = { id = ac_id, section = section }
		ACdisplay:start()

		setTimer(function()

			ACdisplay:fadeOut()

		end, 7000, 1)

	end

	addEvent('achievments.displayReward', true)
	addEventHandler('achievments.displayReward', resourceRoot, displayAchievmentReward)

----------------------------------------------------

	addCommandHandler('ac_display_test', function(_, _section)
		local section = _section or 'dailyQuests'
		displayAchievmentReward(math.random(#Config[section]), section)
	end)

----------------------------------------------------