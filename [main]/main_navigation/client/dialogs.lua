
dialogsSctructure = {
	
	start = {

		sections = {

			main = {

				text = function()
					return {
						string.format('Привет, %s!', localPlayer.name),
						string.format('На сервере вышло обновление %s!', Config.currentVersion),
						'',
						'Рекомендую ознакомиться со списком изменений!',
					}
				end,

				actions = {

					{
						name = 'Далее',
						action = function()

							setTimer(function()
								openWindow('main')

								local index = 1
								local lElement = updatesVersionsList.listElements[index]

								updatesVersionsList.selectedItem = index
								updatesVersionsList.lastSelected = lElement

								updatesVersionsList:onListElementClick( lElement )

							end, 1000, 1)

							return false

						end,
					},

				},

			},

		},

	},

}

