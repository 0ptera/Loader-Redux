-- http://lua-api.factorio.com/latest/events.html#on_entity_settings_pasted
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.filter_slot_count
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.get_filter

local snapping = require("snapping")

local use_train = settings.global["loader-use-trains"].value
local use_snapping = settings.global["loader-snapping"].value

local TRAIN_AUTO = defines.train_state.wait_station
local TRAIN_MANUAL = defines.train_state.manual_control

local wagon_valid
local wagon_validators = {
   ["disabled"] = function (wagon)
      return false
   end,
   ["auto-only"] = function (wagon)
      local train = wagon and wagon.valid and wagon.train
      return train and train.state == TRAIN_AUTO
   end,
   ["all trains"] = function (wagon)
      local train = wagon and wagon.valid and wagon.train
      local train_state = train and train.state
      return train_state == TRAIN_AUTO or train_state == TRAIN_MANUAL and train.speed == 0
   end
}

local function select_validator()
   wagon_valid = wagon_validators[use_train]
end

select_validator()

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
  if next(global.wagons) then
    script.on_event(defines.events.on_tick, ticker)
  end
end

--Run on_tick only when there's something to do.
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

function ticker(event)
  if not global.wagons or not next(global.wagons) then
    script.on_event(defines.events.on_tick, nil)
  end

  for num, data in pairs(global.wagons) do
    if check_wagon_loaders(data) then
      wagon_transfer(data)
    else
      global.wagons[num] = nil
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
  if event.setting == "loader-snapping" then
    use_snapping = settings.global["loader-snapping"].value
  end
  if event.setting == "loader-use-trains" then  --Check to make sure our setting has changed
    use_train = settings.global["loader-use-trains"].value
    select_validator()
    global.wagons = {}
    global.loader_wagon_map = {}
    if use_train == "disabled" then
      script.on_event(defines.events.on_train_changed_state, nil)
      script.on_event(defines.events.on_train_created, nil)
    else
      script.on_event(defines.events.on_train_changed_state, train_update)
      script.on_event(defines.events.on_train_created, train_update)
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
  if use_snapping then
    snapping.check_for_loaders(event)
  end
end)

--When bulding, if its a loader check for snapping and snap, if snapped or not snapping then add to list
--Check anything else built and check for loaders around it they may need correcting.
function EntityBuilt(event)
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
  elseif use_snapping then
    snapping.check_for_loaders(event)
  end
end
script.on_event(defines.events.on_built_entity, EntityBuilt)
script.on_event(defines.events.on_robot_built_entity, EntityBuilt)

--Remove loader/wagon connections when they die/get mined
script.on_event({defines.events.on_entity_died, defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined}, function(event)
  local num = event.entity.unit_number
  if num then
    local wagon = global.wagons[num]
    if wagon then
      for l_num in pairs(wagon.loaders) do
         global.loader_wagon_map[l_num] = nil
      end
      global.wagons[num] = nil
    else
      local w_num = global.loader_wagon_map[num]
      if w_num then
         wagon = global.wagons[w_num]
         if wagon and not check_wagon_loaders(wagon) then
            global.wagons[w_num] = nil
         end
      end
    end
  end
end)

---- Bootstrap ----
do
local function init_events()
   global.wagons = global.wagons or {}
   global.loader_wagon_map = global.loader_wagon_map or {}
  if next(global.wagons) then
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
    if global.loaders then
       for num, loader_data in pairs(global.loaders) do
         local loader, wagon = loader_data.loader, loader_data.wagon
         if wagon and wagon.valid and loader and loader.valid then
             w_num = wagon.unit_number
             global.loader_wagon_map[num] = w_num
             global.wagons[w_num] = global.wagons[w_num] or {
               wagon = wagon,
               wagon_inv = wagon.get_inventory(defines.inventory.cargo_wagon),
               loaders = {}
             }
             global.wagons[w_num].loaders[num] = {
               loader = loader,
               direction = loader_data.direction,
               [1] = loader.get_transport_line(1),
               [2] = loader.get_transport_line(2)
             }
         end
       end
    end
    init_events()
  end
end)
end