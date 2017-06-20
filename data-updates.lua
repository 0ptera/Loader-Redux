function makeChest(name, size, bbox)
  log("[LR] creating fake chest "..name.." with bbox {"..tostring(bbox[1][1])..","..tostring(bbox[1][2]).."} {"..tostring(bbox[2][1])..","..tostring(bbox[2][2]).."}")
  return {
    type = "container",
    name = name,
    order = "x",
    icon = "__base__/graphics/icons/wooden-chest.png",
    flags = {"player-creation", "not-blueprintable", "not-deconstructable"}, --loader only connect to chests with "player-creation" flag set
    -- minable = {mining_time = 1, result = "LR-chest-"..wagon.name},
    max_health = 100,
    corpse = "small-remnants",
		-- collision_box = {{-0.6, -2.6}, {0.6, 2.6}},
		-- selection_box = {{-1.0, -3.0}, {1.0, 3.0}},
    collision_box = {{bbox[1][1]+0.4, bbox[1][2]+0.4},{bbox[2][1]-0.4, bbox[2][2]-0.4}},
    selection_box = bbox,
    inventory_size = size,
    fast_replaceable_group = "container",
    open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" },
    close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" },
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
    picture =
    {
      filename = "__base__/graphics/entity/wooden-chest/wooden-chest.png",
      priority = "extra-high",
      width = 46,
      height = 33,
      shift = {0.25, 0.015625}
    },
  }
end

for _, wagon in pairs(data.raw["cargo-wagon"]) do
  local vertical_shift = wagon.vertical_selection_shift or 0
  local floor = math.floor

  local vchest = makeChest(
    "LR-vchest-"..wagon.name,
    wagon.inventory_size,
    {
      {
        floor(wagon.selection_box[1][1]+0.5),
        floor(wagon.selection_box[1][2]+0.5)
      },
      {
        floor(wagon.selection_box[2][1]+0.5),
        floor(wagon.selection_box[2][2]+0.5)
      }
    }
  )

  local hchest = makeChest(
    "LR-hchest-"..wagon.name,
    wagon.inventory_size,
    {
      {
        floor(wagon.selection_box[1][2]+0.5),
        floor(wagon.selection_box[1][1]+0.5)
      },
      {
        floor(wagon.selection_box[2][2]+0.5),
        floor(wagon.selection_box[2][1]+0.5)
      }
    }
  )
  data:extend({vchest, hchest})
end