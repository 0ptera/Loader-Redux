-- http://lua-api.factorio.com/latest/events.html#on_entity_settings_pasted
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.filter_slot_count
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.get_filter

local snapping = require("snapping")

local use_train = settings.global["loader-use-trains"].value


local function wagon_valid(wagon)
  if use_train == "disabled" or not (wagon and wagon.valid) then
    return false
  end
  if wagon.train.state == defines.train_state.wait_station then
    return true
  elseif use_train == "all trains" and wagon.train.state == defines.train_state.manual_control and wagon.train.speed == 0 then
    return true
  end
  return false
end


local function loader_active(loader_data)
  local loader, dir = loader_data.loader, loader_data.direction
  return ((loader.loader_type == "output" and loader.direction == dir) or (loader.loader_type == "input" and loader.direction == (dir + 4 ) % 8))
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

--loader work
local function loader_work(loader_data)
  local loader, wagon = loader_data.loader, loader_data.wagon_inv
  local filters
  for i=1, 2 do
    local line = loader_data[i]
    if loader.loader_type == "output" then
      if not wagon.is_empty() and line.can_insert_at_back() then
        filters = filters or get_filters(loader)
        if filters then
          for filter in pairs(filters) do
            if wagon.remove({name = filter, count = 1}) == 1 then
              line.insert_at_back({name = filter, count = 1})
              break
            end
          end
        else
          local name = next(wagon.get_contents())
          if name then
            wagon.remove({name = name, count = 1})
            line.insert_at_back({name = name, count = 1})
          end
        end
      end
    elseif loader.loader_type=="input" then
      for name in pairs(line.get_contents()) do
        if wagon.insert({name = name, count = 1}) == 1 then
          line.remove_item({name = name, count = 1})
          break
        end
      end
    end
  end
end

--Find loaders based on train orientation and state
local function find_loader(wagon, ent)
  global.loaders = global.loaders or {}
  if wagon_valid(wagon) then
    if wagon.orientation == 0 or wagon.orientation == 0.5 then
      local west = {type = "loader", area = {{wagon.position.x-1.5, wagon.position.y-2.2}, {wagon.position.x-0.5, wagon.position.y+2.2}}}
      for _, loader in pairs(wagon.surface.find_entities_filtered(west)) do
        if (ent and loader == ent) or not ent then
          global.loaders[loader.unit_number] = {
            loader = loader,
            wagon = wagon,
            wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
            direction = 6,
            [1] = loader.get_transport_line(1),
            [2] = loader.get_transport_line(2)
          }
        end
      end
      local east = {type = "loader",area = {{wagon.position.x+0.5, wagon.position.y-2.2}, {wagon.position.x+1.5, wagon.position.y+2.2}}}
      for _, loader in pairs(wagon.surface.find_entities_filtered(east)) do
        if (ent and loader == ent) or not ent then
          global.loaders[loader.unit_number] = {
            loader = loader,
            wagon = wagon,
            wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
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
          global.loaders[loader.unit_number] = {
            loader = loader,
            wagon = wagon,
            wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
            direction = 0,
            [1] = loader.get_transport_line(1),
            [2] = loader.get_transport_line(2)
          }
        end
      end
      local south = {type = "loader", area = {{wagon.position.x-2.2, wagon.position.y+0.5}, {wagon.position.x+2.2, wagon.position.y+1.5}}}
      for _, loader in pairs(wagon.surface.find_entities_filtered(south)) do
        if (ent and loader == ent) or not ent then
          global.loaders[loader.unit_number] = {
            loader = loader,
            wagon = wagon,
            wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
            direction = 4,
            [1] = loader.get_transport_line(1),
            [2] = loader.get_transport_line(2)
          }
        end
      end
    end
  end
  if next(global.loaders) then
    script.on_event(defines.events.on_tick, ticker)
  end
end

--Run on_tick only when there's something to do.
function ticker(event)
  if global.loaders == nil or next(global.loaders) == nil then
    script.on_event(defines.events.on_tick, nil)
  end

  for num, data in pairs(global.loaders) do
    if data.loader and data.loader.valid and wagon_valid(data.wagon) and loader_active(data) then
      loader_work(data)
    else
      global.loaders[num] = nil
    end
  end
end


--When trains are enabled update on train state changes.
--If it moves or switches to manual then stop all loaders and clear.
function train_update(event)
  for _, wagon in pairs(event.train.cargo_wagons) do
    find_loader(wagon, nil)
  end
end


-- update mod runtime settings
-- subscribe and initialize wagon-loader pairs if needed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting == "loader-use-trains" then  --Check to make sure our setting has changed
    use_train = settings.global["loader-use-trains"].value
    if use_train == "disabled" then
      script.on_event(defines.events.on_train_changed_state, nil)
      script.on_event(defines.events.on_train_created, nil)
      global.loaders = {}
    else
      script.on_event(defines.events.on_train_changed_state, train_update)
      script.on_event(defines.events.on_train_created, train_update)
      global.loaders = {}
      for _, surface in pairs(game.surfaces) do
        for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
          find_loader(wagon)
        end
      end
    end
  end
end)


--Check for loaders around rotated entities that may need snapping
script.on_event(defines.events.on_player_rotated_entity, function(event)
  if settings.get_player_settings(event.player_index)["loader-snapping"].value then
    snapping.check_for_loaders(event)
  end
end)

--When bulding, if its a loader check for snapping and snap, if snapped or not snapping then add to list
--Check anything else built and check for loaders around it they may need correcting.
script.on_event(defines.events.on_built_entity, function(event)
  local entity = event.created_entity
  local can_snap = settings.get_player_settings(event.player_index)["loader-snapping"].value
  if entity.type == "loader" then
    if can_snap then
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
  elseif can_snap then
    snapping.check_for_loaders(event)
  end
end)

--Remove saved loaders when they die/get mined
script.on_event({defines.events.on_entity_died, defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined}, function(event)
  if event.entity.unit_number then
    global.loaders[event.entity.unit_number] = nil
  end
end)

---- Bootstrap ----
do
local function init_events()
  if global.loaders and next(global.loaders) then
    script.on_event(defines.events.on_tick, ticker)
  end
  if use_train == "disabled" then
    script.on_event(defines.events.on_train_changed_state, nil)
    script.on_event(defines.events.on_train_created, nil)
  else
    script.on_event(defines.events.on_train_changed_state, train_update)
    script.on_event(defines.events.on_train_created, train_update)
  end
end

--On first install scan the map and find any loaders that might need work!
script.on_init(function()
  global.loaders = {}
  init_events()
  if use_train ~= "disabled" then
    for _, surface in pairs(game.surfaces) do
      for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
        find_loader(wagon)
      end
    end
  end
end)

script.on_load(function()
  init_events()
end)

script.on_configuration_changed(function(data)
  if data and data.mod_changes["LoaderRedux"] then
    for num, loader in pairs(global.loaders) do
      if loader.wagon and loader.wagon.valid and loader.loader and loader.loader.valid then
        global.loaders[num][1] = loader.loader.get_transport_line(1)
        global.loaders[num][2] = loader.loader.get_transport_line(2)
        global.loaders[num].wagon_inv = loader.wagon.get_inventory(defines.inventory.cargo_wagon)
      else
        global.loaders[num] = nil
      end
    end
    init_events()
  end
end)
end

-- remote.add_interface("loaders",
  -- {
    -- write_global = function()
      -- game.write_file("Loaders/global.lua", serpent.block(global, {nocode=true, comment=false, sparse=false}))
    -- end
  -- }
-- )
