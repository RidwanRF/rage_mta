CURRENT_TAB = 1
GET_TABS = {
	{ name = "Главная", key = "main" },
	{ name = "Сотрудники", key = "members" },
	{ name = "Управление", key = "manage" },
	{ name = "Ранги", key = "rangs" },
}

TABS_CONTENT = {}
FACTION_CACHE = { }

function Button( conf )
	local self = conf or { }

	--exports.main_sounds:playSound( 'checkbox' )
end

if localPlayer:IsAdmin( ) then
	table.insert( GET_TABS, {
		name = "Admin",
		key = "admin"
	} )
end