function displayHitEffect()
	setAnimData('hiteffect', 0.01, 1)
	animate('hiteffect', 0)
end

addCommandHandler('hiteffect', function(_, ...)
	if exports.acl:isAdmin(localPlayer) then
		displayHitEffect()
	end
end)

setAnimData('hiteffect', 0.1)

