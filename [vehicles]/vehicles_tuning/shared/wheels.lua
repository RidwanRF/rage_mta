Config.saveWheelsConfigCost = 10000

Config.wheelPropertiesLimits = {
    offset = {-0.13, 0.22},
    razval = {0, 30},
    radius = {0.7, 1.3},
    width  = {0.8, 1.6},
    height  = {-0.3, 0.3},
}

Config.wheelsConfigParameters = {
    'wheels_radius',
    'wheels_radius_f',
    'wheels_radius_r',
    'wheels_offset_f',
    'wheels_offset_r',
    'wheels_razval_f',
    'wheels_razval_r',
    'wheels_width_f',
    'wheels_width_r',
    'wheels_height',
}

function getWheelPropertyLimit(property, limit)
    local index = 1

    if limit == "max" then
        index = 2
    end

    property = property:gsub('wheels_', '')
    property = property:gsub('_f', '')
    property = property:gsub('_r', '')

    local value = Config.wheelPropertiesLimits[property][index]

    if property == "radius" and localPlayer.vehicle then
        value = value * getVehicleDefaultWheelsRadius(localPlayer.vehicle)
    end

    return value
end

function getDefaultWheelProperty(property)

    if property == 'wheels_height' then return 0 end

end

function getWheelProperties()

	local properties = {}

	for _, name in pairs( Config.wheelsConfigParameters ) do
		properties[name] = localPlayer.vehicle:getData(name) or 0
	end
	return properties
end


local wheels_tuning_config = {

    value_type = 'float',
    -- prerequisities = {'wheels'},

    components = {
        { name = 'Размер передних колес', price = 2000, dataName = 'wheels_radius_f', },
        { name = 'Размер задних колес', price = 2000, dataName = 'wheels_radius_r', },
        { name = 'Ширина передних колес', price = 2000, dataName = 'wheels_width_f' },
        { name = 'Ширина задних колес', price = 2000, dataName = 'wheels_width_r' },
        { name = 'Вылет передних колес', price = 2000, dataName = 'wheels_offset_f' },
        { name = 'Вылет задних колес', price = 2000, dataName = 'wheels_offset_r' },
        { name = 'Развал передних колес', price = 2000, dataName = 'wheels_razval_f' },
        { name = 'Развал задних колес', price = 2000, dataName = 'wheels_razval_r' },
        { name = 'Высота колес', price = 10000, dataName = 'wheels_height', default_value = 0 },
    },

}

for _, component in pairs( wheels_tuning_config.components ) do
    component.slider = { divide = 100, component = component }
    component.slider.range = function( self )
        return { getWheelPropertyLimit(self.component.dataName, 'min')*100, getWheelPropertyLimit(self.component.dataName, 'max')*100 }
    end
end

Config.defaultTuning.wheels_config = wheels_tuning_config
