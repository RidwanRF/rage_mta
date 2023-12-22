
---------------------------------------------

	d_openDialog = openDialog
	openDialog = function( structure, section )

		if isTimer(waitTimer) then killTimer(waitTimer) end

		waitTimer = setTimer(function()

			if not isCursorShowing() then

				if isTimer(waitTimer) then killTimer(waitTimer) end
				d_openDialog( structure, section )

			end

		end, 5000, 0)

	end

	addEvent('tutorial.onFinish')

---------------------------------------------

dialogsSctructure = {
	
	autoschool = {

		sections = {

			main = {

				text = function()
					return {
						'Ты приплыл в город Сан-Фиерро...',
						'',
						'Недалеко от тебя находится автошкола,',
						'чтобы получить права - отправляйся туда.',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'text_2'
						end,
					},

				},

			},

			text_2 = {

				text = function()
					return {
						'Ты же помнишь, у тебя есть скутер!',
						'',
						'Нажми F3, выбери Скутер и нажми Респавн.',
						'После нажми клавишу F, чтобы сесть в него.',
						'',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							exports.hud_notify:actionNotify('F3', 'открыть транспорт')
							return false
						end,
					},

				},

			},

		},

	},
	
	carshop = {

		sections = {

			main = {

				text = function()
					return {
						'Теперь отправляйся в автосалон.',
						'',
						'Скутер это, конечно, хорошо,',
						'но уже можно выбрать и полноценный автомобиль.',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return false
						end,
					},

				},

			},

		},

	},

	
	job = {

		sections = {

			main = {

				text = function()
					return {
						'Настало время для первой работы!',
						'',
						'В Сан-Фиерро есть отличная работа для',
						'новичков - грузчик!',
						'',
						'Тебе нужно устроиться на нее...',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return false
						end,
					},

				},

			},

		},

	},

	finish = {

		sections = {

			main = {

				text = function()
					return {
						'Отлично!',
						'Ты добрался до работы...',
						'',
						'Удели работе время - здесь можно',
						'заработать первые деньги!',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'text_2'
						end,
					},

				},

			},

			text_2 = {

				text = function()
					return {
						'Скоро ты сможешь позволить себе собственное',
						'имущество, главное - не останавливайся!',
						'',
						'Прочувствуй деньги - и ты начнешь',
						'притягивать их к себе!',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'text_3'
						end,
					},

				},

			},

			text_3 = {

				text = function()
					return {
						'Но сейчас, к сожалению, мне пора идти.',
						'Новичков много - а помочь нужно всем...',
						'',
						( 'Приятно было познакомиться, %s!' ):format( localPlayer.name ),
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()

							setTimer(function()
								triggerEvent('tutorial.onFinish', root)
							end, 1000, 1)

							return false
						end,
					},

				},

			},

		},

	},

}

