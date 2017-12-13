-- http://lua-api.factorio.com/latest/events.html#on_entity_settings_pasted
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.filter_slot_count
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.get_filter

local snapping = require("snapping")

local use_train = settings.global["loader-use-trains"].value
local use_snapping = settings.global["loader-snapping"].value

local wagon_valid
local wagon_validators = {
	["disabled"] = function (wagon)
		return false
	end,
	["auto-only"] = function (wagon)
		local train = wagon and wagon.valid and wagon.train
		return train and train.state == defines.train_state.wait_station
	end,
	["all trains"] = function (wagon)
		local train = wagon and wagon.valid and wagon.train
		local train_state = train and train.state
		return train_state == defines.train_state.wait_station or train_state == defines.train_state.manual_control and train.speed == 0
	end
}

local function select_validator()
	wagon_valid = wagon_validators[use_train]
end

local function get_filters(entity)
	local filters = {}
	local filtered = false
	for n = 1, entity.filter_slot_count do
		local filter = entity.get_filter(n)
		if filter then
			filters[filter] = true
			filtered = true
		end
	end
	return filtered and filters
end

local function wagon_transfer(wagon_data)
	local wagon = wagon_data.wagon_inv
	for _, loader_data in pairs(wagon_data.loaders) do
		local loader = loader_data.loader
		local line1, line2 = loader_data[1], loader_data[2]

		if loader.loader_type == "output" then
			local filters = get_filters(loader)
			if filters then
				if not wagon.is_empty() and line1.can_insert_at_back() then
					for name in pairs(filters) do
						if wagon.remove({ name = name }) == 1 then
							line1.insert_at_back({ name = name })
							break
						end
					end
				end
				if not wagon.is_empty() and line2.can_insert_at_back() then
					for name in pairs(filters) do
						if wagon.remove({ name = name }) == 1 then
							line2.insert_at_back({ name = name })
							break
						end
					end
				end
			else
				local name = next(wagon.get_contents())
				if name and line1.insert_at_back({ name = name }) then
					wagon.remove({ name = name })
				end
				name = next(wagon.get_contents())
				if name and line2.insert_at_back({ name = name }) then
					wagon.remove({ name = name })
				end
			end
		elseif loader.loader_type == "input" then
			for name in pairs(line1.get_contents()) do
				if wagon.insert({ name = name }) == 1 then
					line1.remove_item({ name = name })
					break
				end
			end
			for name in pairs(line2.get_contents()) do
				if wagon.insert({ name = name }) == 1 then
					line2.remove_item({ name = name })
					break
				end
			end
		end
	end
end

--Find loaders based on train orientation and state
local function find_loader(wagon, ent)
	if wagon_valid(wagon) then
		w_num = wagon.unit_number
		if wagon.orientation == 0 or wagon.orientation == 0.5 then
			local west = {type = "loader", area = {{wagon.position.x-1.5, wagon.position.y-2.2}, {wagon.position.x-0.5, wagon.position.y+2.2}}}
			for _, loader in pairs(wagon.surface.find_entities_filtered(west)) do
				if (ent and loader == ent) or not ent then
				local l_num = loader.unit_number
				global.loader_wagon_map[l_num] = w_num
				global.wagons[w_num] = global.wagons[w_num] or {
					wagon = wagon,
					wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
					loaders = {}
				}
				global.wagons[w_num].loaders[l_num] = {
					loader = loader,
					direction = 6,
					[1] = loader.get_transport_line(1),
					[2] = loader.get_transport_line(2)
				}
				end
			end
			local east = {type = "loader",area = {{wagon.position.x+0.5, wagon.position.y-2.2}, {wagon.position.x+1.5, wagon.position.y+2.2}}}
			for _, loader in pairs(wagon.surface.find_entities_filtered(east)) do
				if (ent and loader == ent) or not ent then
				local l_num = loader.unit_number
				global.loader_wagon_map[l_num] = w_num
				global.wagons[w_num] = global.wagons[w_num] or {
					wagon = wagon,
					wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
					loaders = {}
				}
				global.wagons[w_num].loaders[l_num] = {
					loader = loader,
					direction = 2,
					[1] = loader.get_transport_line(1),
					[2] = loader.get_transport_line(2)
				}
				end
			end
		elseif wagon.orientation==0.25 or wagon.orientation==0.75 then
			local north = {type = "loader", area = {{wagon.position.x-2.2, wagon.position.y-1.5}, {wagon.position.x+2.2, wagon.position.y-0.5}}}
			for _, loader in pairs(wagon.surface.find_entities_filtered(north)) do
				if (ent and loader == ent) or not ent then
				local l_num = loader.unit_number
				global.loader_wagon_map[l_num] = w_num
				global.wagons[w_num] = global.wagons[w_num] or {
					wagon = wagon,
					wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
					loaders = {}
				}
				global.wagons[w_num].loaders[l_num] = {
					loader = loader,
					direction = 0,
					[1] = loader.get_transport_line(1),
					[2] = loader.get_transport_line(2)
				}
				end
			end
			local south = {type = "loader", area = {{wagon.position.x-2.2, wagon.position.y+0.5}, {wagon.position.x+2.2, wagon.position.y+1.5}}}
			for _, loader in pairs(wagon.surface.find_entities_filtered(south)) do
				if (ent and loader == ent) or not ent then
				local l_num = loader.unit_number
				global.loader_wagon_map[l_num] = w_num
				global.wagons[w_num] = global.wagons[w_num] or {
					wagon = wagon,
					wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
					loaders = {}
				}
				global.wagons[w_num].loaders[l_num] = {
					loader = loader,
					direction = 4,
					[1] = loader.get_transport_line(1),
					[2] = loader.get_transport_line(2)
				}
				end
			end
		end
	end
end

local active_directions = {
	output = {
		[0] = 0,
		[2] = 2,
		[4] = 4,
		[6] = 6
	},
	input = {
		[0] = 4,
		[2] = 6,
		[4] = 0,
		[6] = 2
	}
}
local function loader_active(loader_data)
	local loader = loader_data.loader
	return loader and loader.valid and active_directions[loader.loader_type][loader.direction] == loader_data.direction
end

local function check_wagon_loaders(wagon_data)
	local active_loader = false
	if wagon_valid(wagon_data.wagon) then
		for num, loader_data in pairs(wagon_data.loaders) do
			if loader_active(loader_data) then
				active_loader = true
			else
				global.loader_wagon_map[num] = nil
				wagon_data.loaders[num] = nil
			end
		end
	else
		for num in pairs(wagon_data.loaders) do
			global.loader_wagon_map[num] = nil
		end
	end
	return active_loader
end

function OnTick(event)
	for num, wagon_data in pairs(global.wagons) do
		if check_wagon_loaders(wagon_data) then
			wagon_transfer(wagon_data)
		else
			global.wagons[num] = nil
		end
	end
end

--When trains are enabled update on train state changes.
--If it moves or switches to manual then stop all loaders and clear.
function OnTrainUpdate(event)
	for _, wagon in pairs(event.train.cargo_wagons) do
		find_loader(wagon, nil)
	end
	if next(global.wagons) then
		script.on_event(defines.events.on_tick, OnTick)
	else
		script.on_event(defines.events.on_tick, nil)
	end
end


--Check for loaders around rotated entities that may need snapping
script.on_event(defines.events.on_player_rotated_entity, function(event)
	if use_snapping then
		snapping.check_for_loaders(event)
	end
end)

--When bulding, if its a loader check for snapping and snap, if snapped or not snapping then add to list
--Check anything else built and check for loaders around it they may need correcting.
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
	local entity = event.created_entity
	if entity.type == "loader" then
		if use_snapping then
			snapping.snap_loader(entity, event)
		end
		local wagons = {
			type = "cargo-wagon",
			area = {
				{entity.position.x - 2, entity.position.y - 2},
				{entity.position.x + 2, entity.position.y + 2}
			}
		}
		for _, wagon in pairs(entity.surface.find_entities_filtered(wagons)) do
			find_loader(wagon, entity)
		end
		if next(global.wagons) then
			script.on_event(defines.events.on_tick, OnTick)
		else
			script.on_event(defines.events.on_tick, nil)
		end
	elseif use_snapping then
		snapping.check_for_loaders(event)
	end
end)

--Remove loader/wagon connections when they die/get mined
function OnEntityRemoved(event)
-- script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, function(event)
	local entity = event.entity
	if entity.type == "cargo-wagon" then
		local wagon = global.wagons[entity.unit_number]
		if wagon then
			for l_num in pairs(wagon.loaders) do
				global.loader_wagon_map[l_num] = nil
			end
			global.wagons[entity.unit_number] = nil
		end
	elseif entity.type == "loader" then
		local w_num = global.loader_wagon_map[entity.unit_number]
		if w_num then
			wagon = global.wagons[w_num]
			if wagon and not check_wagon_loaders(wagon) then
				global.wagons[w_num] = nil
			end
		end
	end
end


-- update mod runtime settings
-- change event subsciptions and initialize wagon-loader pairs as needed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	if event.setting == "loader-snapping" then
		use_snapping = settings.global["loader-snapping"].value
	end
	if event.setting == "loader-use-trains" then	--Check to make sure our setting has changed
		use_train = settings.global["loader-use-trains"].value
		select_validator()
		global.wagons = {}
		global.loader_wagon_map = {}
		if use_train == "disabled" then
			script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, nil)
			script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, nil)
			script.on_event(defines.events.on_tick, nil)
		else
			script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, OnTrainUpdate)
			script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, OnEntityRemoved)
			for _, surface in pairs(game.surfaces) do
				for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
					find_loader(wagon)
				end
			end
			if next(global.wagons) then
				script.on_event(defines.events.on_tick, OnTick)
			else
				script.on_event(defines.events.on_tick, nil)
			end 
		end
	end
end)


---- Bootstrap ----
do
function init_events()
	if use_train == "disabled" then
		script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, nil)
		script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, nil)
		script.on_event(defines.events.on_tick, nil)
	else
		script.on_event({defines.events.on_train_changed_state, defines.events.on_train_created}, OnTrainUpdate)
		script.on_event({defines.events.on_entity_died, defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, OnEntityRemoved)
		if global.wagons and next(global.wagons) then
			script.on_event(defines.events.on_tick, OnTick)
		else
			script.on_event(defines.events.on_tick, nil)
		end
	end
end

script.on_load(function()
	select_validator()
	init_events()
end)

-- On first install scan the map and find any loaders that might need work!
script.on_init(function()
	select_validator()
	global.wagons = {}
	global.loader_wagon_map = {}
	if use_train ~= "disabled" then
		for _, surface in pairs(game.surfaces) do
			for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
				find_loader(wagon)
			end
		end
	end
	init_events()
end)

-- rescan all loader-wagon connections in case changing mods removed some wagons
script.on_configuration_changed(function(data)
	select_validator()
	global.wagons = {}
	global.loader_wagon_map = {}
	if use_train ~= "disabled" then
		for _, surface in pairs(game.surfaces) do
			for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
				find_loader(wagon)
			end
		end
	end
	init_events()
end)
end