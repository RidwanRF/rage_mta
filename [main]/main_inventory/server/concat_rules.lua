

concatRules = {}


concatRules['ammo-weapon'] = function(from, to)

	local from_config, to_config = getItemConfig(from), getItemConfig(to)

	if to_config.ammo_access ~= from.item then
		return from, to
	end

	to.data = to.data or {}

	local prev_ammo = to.data.ammo or 0
	to.data.ammo = math.clamp( (to.data.ammo or 0) + from.count, 0, to_config.max_ammo or 0 )

	from.count = from.count - ( to.data.ammo - prev_ammo )

	if from.count == 0 then
		from = nil
	end

	return from, to

end

concatRules.general_equal_types = function(from, to)

	local config = getItemConfig(from)
	if not config then return end
	local max_stack = config.max_stack or 1

	local add = from.count

	if (to.count + add) > max_stack then
		add = max_stack - to.count
	end

	if add <= 0 then return from, to end

	to.count = to.count + add
	from.count = from.count - add

	if from.count <= 0 then
		from = nil
	end

	return from, to

end