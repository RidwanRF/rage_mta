loadstring( exports.core:include('animations'))()
loadstring( exports.core:include('common'))()
loadstring( exports.core:include('gui.module.utils'))()
loadstring( exports.core:include('gui.module'))()
loadstring( exports.core:include('gui.fonts'))()
loadstring( exports.core:include('gui.dialog'))()
loadstring( exports.core:include('gui.graphics'))()
loadstring( exports.core:include('binds'))()


local players_login_cache = {}

function getPlayerFromLogin( login )

	if isElement(players_login_cache[login]) then
		return players_login_cache[login]
	else

		for _, player in pairs( getElementsByType('player') ) do
			if player:getData('unique.login') == login then
				players_login_cache[login] = player
				return player
			end
		end

	end

end