
Config = {}

Config.tutorial = {
	
	{

		point = {
			coords = { -2354.84, 1643.38, 5.38 },
			text = 'Плывите в город',
		},

		complete_event = 'transfer_system.onTransfer',

	},

	{

		point = {
			coords = { -1928.94, 1379.6, 7.19 },
			text = 'Посетите автошколу',
		},

		onInit = function()
			openDialog(dialogsSctructure, 'autoschool')
		end,

		complete_event = 'vehicles_autoschool.onLicenseBuy',

	},

	{

		point = {
			coords = { -2625.23, 1420.5, 7.14 },
			text = 'Посетите автосалон',
		},

		onInit = function()
			openDialog(dialogsSctructure, 'carshop')
		end,

		complete_event = 'vehicles_shop.onExit',

	},

	{

		point = {
			coords = { -2037.02, -123.65, 35.21 },
			text = 'Посетите работу',
		},

		onInit = function()
			openDialog(dialogsSctructure, 'job')
		end,

		complete_event = 'jobs.onJobStart',

	},

	{

		onInit = function()
			openDialog(dialogsSctructure, 'finish')
		end,

		complete_event = 'tutorial.onFinish',

	},

}