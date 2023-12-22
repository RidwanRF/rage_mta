
dialogsSctructure = {
	
	start = {

		sections = {

			main = {

				text = function()
					return {
						string.format('Привет, %s!', localPlayer.name),
						'Ты попал на Рейдж, здесь много всего интересного!',
						'Меня зовут Джуди Альварес, я помогаю новичкам.',
						'',
						'Ты, как я вижу, только зарегистрировался.',
						'У меня есть для тебя подарок...',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							triggerServerEvent('npc_start.takeBonus', resourceRoot)
							return 'give_bonus'
						end,
					},

				},

			},

			give_bonus = {

				text = function()
					return {
						string.format('Вот! Держи %s', Config.startBonus.name),
						'Я уверена, тебе это пригодится.',
						'',
						'Ах да, ты же ничего еще не знаешь!',
						'Давай немного расскажу тебе о сервере?',
					}
				end,

				actions = {

					{
						name = 'Давай',
						action = function()
							return 'info_1'
						end,
					},
					{
						name = 'Сам разберусь',
						action = function()

							triggerServerEvent('npc_start.completeStart', resourceRoot)
							triggerServerEvent('tutorial.cancel', resourceRoot)

							return false

						end,
					},

				},


			},

			info_1 = {

				text = function()
					return {
						'Отлично, давай приступим!',
						'',
						'Сейчас ты находишься на острове Лакшери,',
						'здесь одни из самых дорогих домов в Сан-Андреас!',
						'Новички стараются побыстрее уплыть отсюда,',
						'но со временем возвращаются и становятся элитой.',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'info_2'
						end,
					},

				},

			},

			info_2 = {

				text = function()
					return {
						'Сейчас отправляйся на переправу <img>:hud_radar/assets/images/blip_icons/transfer.png</img> в Сан-Фиерро,',
						'',
						'Неподалеку отсюда находится автошкола <img>:hud_radar/assets/images/blip_icons/autoschool.png</img>,',
						'все стремятся первым делом попасть в нее...',
						'',
						'В общем, права откроют первые возможности!',
					}
				end,

				actions = {

					{
						name = 'Что дальше?',
						action = function()
							return 'info_3'
						end,
					},

				},

			},

			info_3 = {

				text = function()
					return {
						'А дальше - время искать работу!',
						'',
						'Берись за все возможные предложения.',
						'К слову, в ближайшем городе, Сан-Фиерро, есть работа',
						'почтальона <img>:hud_radar/assets/images/blip_icons/job_post.png</img>, водителя автобуса <img>:hud_radar/assets/images/blip_icons/job_bus.png</img>',
						'и грузчика <img>:hud_radar/assets/images/blip_icons/job_cargo.png</img>.',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'info_4'
						end,
					},

				},

			},

			info_4 = {

				text = function()
					return {
						'С первыми деньгами сможешь купить машину <img>:hud_radar/assets/images/blip_icons/carshop.png</img>.',
						'Выберии ее мудро, и она даст тебе большие деньги.',
						'',
						'А с капиталом время открыть свой бизнес или купить дом.',
						'Ты и не заметишь, как дойдешь до верхов общества...',
						'Как же это круто - иметь собственную нефтевышку! <img>:hud_radar/assets/images/blip_icons/player_derrick.png</img>',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							return 'info_5'
						end,
					},

				},

			},

			info_5 = {

				text = function()
					return {
						'Тогда и вспомни об этом острове - ',
						'здесь ты найдешь себе домик по вкусу.',
						'',
						'Настанет время Лакшери! Гонки, тюнинг, дорогие тачки...',
						'Скажешь себе смело - жизнь прожита не зря!',
						'',
						'А сейчас - вперед к приключениям!',
					}
				end,

				actions = {

					{
						name = 'Вперед!',
						action = function()
							return 'info_6'
						end,
					},

				},

			},

			info_6 = {

				text = function()
					return {
						'Кстати, на сервере есть множество бонусов!',
						'Заходи каждый день и получай ежедневную награду.',
						'',
						'Также выполняй ежедневные задания,',
						'таким образом разбогатеть ты сможешь куда быстрее...',
						'',
						'Подробнее - F1 > Награды',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()
							exports.main_freeroam:highlightMainTab('rewards')
							return 'info_7'
						end,
					},

				},

			},

			info_7 = {

				text = function()
					return {
						'По поводу графики, ее ты можешь настроить',
						'в окне F1 > Настройки > Графика',
						'',
						'Но от максимальных настроек',
						'игра может тормозить на слабом компьютере.',
						'Выбери, на каких настройках будешь играть:',
					}
				end,

				actions = {

					{
						name = 'Низкие',
						action = function()

							exports.main_freeroam:highlightMainTab('options')
							localPlayer:setData('settings.farclip', 500, false)
							exports.main_freeroam:toggleAllSettings('graphics', false)

							triggerServerEvent('npc_start.trackGraphicsChoice', resourceRoot, 'low')

							return 'info_8'
						end,
					},

					{
						name = 'Высокие',
						action = function()

							exports.main_freeroam:highlightMainTab('options')
							localPlayer:setData('settings.farclip', 1500, false)
							exports.main_freeroam:toggleAllSettings('graphics', true)

							triggerServerEvent('npc_start.trackGraphicsChoice', resourceRoot, 'high')

							return 'info_8'
						end,
					},

				},

			},

			info_8 = {

				text = function()
					return {
						'Я желаю тебе удачи.',
						'И помни - денег много не бывает!',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()

							exports.hud_notify:actionNotify('F1', 'Открыть меню игрока', 10000)

							triggerServerEvent('npc_start.completeStart', resourceRoot)
							triggerServerEvent('tutorial.start', root)

							return false

						end,
					},

				},

			},

		},

	},

}

