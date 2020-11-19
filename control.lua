--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- http://lua-api.factorio.com/latest/events.html#on_entity_settings_pasted
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.filter_slot_count
-- http://lua-api.factorio.com/0.15.2/LuaEntity.html#LuaEntity.get_filter

local snapping = require("script.snapping")
local wagon_handler = require("script.wagon_handler")


local use_train = settings.global["loader-use-trains"].value
local use_snapping = settings.global["loader-snapping"].value

local supported_loaders = {} -- dictionary indexed by supported entity name
local supported_loader_names = {}  -- list of loader names for find_entities_filtered

-- remote interface to add and remove loaders from whitelist
remote.add_interface("loader-redux",  {
  -- add loader name if it doesn't already exist
  add_loader = function(name)
    if name then
      supported_loaders[name] = true
      supported_loader_names = {}
      for k, v in pairs(supported_loaders) do
        table.insert(supported_loader_names, k)
      end
      -- log("supported_loaders: "..serpent.block(supported_loaders) )
    end
  end,

  -- remove loader name
  remove_loader = function(name)
    if name then
      supported_loaders[name] = nil
      supported_loader_names = {}
      for k, v in pairs(supported_loaders) do
        table.insert(supported_loader_names, k)
      end
      -- log("supported_loaders: "..serpent.block(supported_loaders) )
    end
  end
})

function OnTick(event)
  for num, wagon_data in pairs(global.wagons) do
    if wagon_handler.loader_check(wagon_data) then
      wagon_handler.transfer(wagon_data)
    else
      global.wagons[num] = nil
    end
  end
end

--When trains are enabled update on train state changes.
--If it moves or switches to manual then stop all loaders and clear.
function OnTrainUpdate(event)
  for _, wagon in pairs(event.train.cargo_wagons) do
    wagon_handler.find_loader(wagon, nil)
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
    snapping.check_for_loaders(event, supported_loader_names)
  end
end)

--When building, if its a loader check for snapping and snap, if snapped or not snapping then add to list
--Check anything else built and check for loaders around it they may need correcting.
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
  local entity = event.created_entity
  if entity.type == "loader" and supported_loaders[entity.name] then
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
      wagon_handler.find_loader(wagon, entity)
    end
    if next(global.wagons) then
      script.on_event(defines.events.on_tick, OnTick)
    else
      script.on_event(defines.events.on_tick, nil)
    end
  elseif use_snapping then
    snapping.check_for_loaders(event, supported_loader_names)
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
      if wagon and not wagon_handler.loader_check(wagon) then
        global.wagons[w_num] = nil
      end
    end
  end
end


-- update mod runtime settings
-- change event subscriptions and initialize wagon-loader pairs as needed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting == "loader-snapping" then
    use_snapping = settings.global["loader-snapping"].value
  end
  if event.setting == "loader-use-trains" then  --Check to make sure our setting has changed
    use_train = settings.global["loader-use-trains"].value
    wagon_handler.create_wagon_validators(use_train)
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
          wagon_handler.find_loader(wagon)
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

function init_supported_loaders()
  supported_loaders = {} -- loader name dictionary for fast access on name base

  -- use interface to fill whitelist as test
  remote.call("loader-redux", "add_loader", "loader")
  remote.call("loader-redux", "add_loader", "fast-loader")
  remote.call("loader-redux", "add_loader", "express-loader")
  remote.call("loader-redux", "add_loader", "purple-loader")
  remote.call("loader-redux", "add_loader", "green-loader")
end

script.on_load(function()
  init_supported_loaders()
  wagon_handler.create_wagon_validators(use_train)
  init_events()
end)

-- On first install scan the map and find any loaders that might need work!
script.on_init(function()
  init_supported_loaders()
  wagon_handler.create_wagon_validators(use_train)
  global.wagons = {}
  global.loader_wagon_map = {}
  if use_train ~= "disabled" then
    for _, surface in pairs(game.surfaces) do
      for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
        wagon_handler.find_loader(wagon)
      end
    end
  end
  init_events()
end)

-- rescan all loader-wagon connections in case changing mods removed some wagons
script.on_configuration_changed(function(data)
  wagon_handler.create_wagon_validators(use_train)
  global.wagons = {}
  global.loader_wagon_map = {}
  if use_train ~= "disabled" then
    for _, surface in pairs(game.surfaces) do
      for _, wagon in pairs(surface.find_entities_filtered{type = "cargo-wagon"}) do
        wagon_handler.find_loader(wagon)
      end
    end
  end
  init_events()
end)
end
