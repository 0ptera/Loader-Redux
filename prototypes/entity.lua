local loaders = {
  ["loader"] = 0.038,
  ["fast-loader"] = 0.0704,
  ["express-loader"] = 0.106
}

for name,speed in pairs(loaders) do
	if data.raw["loader"][name] then
		data.raw["loader"][name].structure.direction_in.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
    data.raw["loader"][name].structure.direction_in.sheet.width = 128
    data.raw["loader"][name].structure.direction_in.sheet.height = 128
    data.raw["loader"][name].structure.direction_out.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
    data.raw["loader"][name].structure.direction_out.sheet.width = 128
    data.raw["loader"][name].structure.direction_out.sheet.height = 128
    data.raw["loader"][name].structure.direction_out.sheet.y = 128
		data.raw["loader"][name].icon = "__LoaderRedux__/graphics/icon/"..name..".png"
    data.raw["loader"][name].speed = speed
		data.raw["loader"][name].flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
	end
end

if data.raw["item"]["green-transport-belt"] then
data:extend({
	{
    type = "loader",
    name = "green-loader",
    icon = "__LoaderRedux__/graphics/icon/green-loader.png",
    flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "green-loader"},
    max_health = 170,
    filter_count = 5,
    corpse = "small-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 60
      }
    },
    collision_box = {{-0.4, -0.9}, {0.4, 0.9}},
    selection_box = {{-0.5, -1}, {0.5, 1}},
    animation_speed_coefficient = 32,
    belt_horizontal = green_belt_horizontal,
    belt_vertical = green_belt_vertical,
    ending_top = green_belt_ending_top,
    ending_bottom = green_belt_ending_bottom,
    ending_side = green_belt_ending_side,
    starting_top = green_belt_starting_top,
    starting_bottom = green_belt_starting_bottom,
    starting_side = green_belt_starting_side,
    fast_replaceable_group = "loader",
    speed = 0.125,
    structure =
    {
      direction_in =
      {
        sheet =
        {
          filename = "__LoaderRedux__/graphics/entity/green-loader.png",
          priority = "extra-high",
          width = 128,
          height = 128
        }
      },
      direction_out =
      {
        sheet =
        {
          filename = "__LoaderRedux__/graphics/entity/green-loader.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          y = 128
        }
      }
    },
    ending_patch = ending_patch_prototype
  },
  {
    type = "loader",
    name = "purple-loader",
    icon = "__LoaderRedux__/graphics/icon/purple-loader.png",
    flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "purple-loader"},
    max_health = 170,
    filter_count = 5,
    corpse = "small-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 60
      }
    },
    collision_box = {{-0.4, -0.9}, {0.4, 0.9}},
    selection_box = {{-0.5, -1}, {0.5, 1}},
    animation_speed_coefficient = 32,
    belt_horizontal = purple_belt_horizontal,
    belt_vertical = purple_belt_vertical,
    ending_top = purple_belt_ending_top,
    ending_bottom = purple_belt_ending_bottom,
    ending_side = purple_belt_ending_side,
    starting_top = purple_belt_starting_top,
    starting_bottom = purple_belt_starting_bottom,
    starting_side = purple_belt_starting_side,
    fast_replaceable_group = "loader",
    speed = 0.17,
    structure =
    {
      direction_in =
      {
        sheet =
        {
          filename = "__LoaderRedux__/graphics/entity/purple-loader.png",
          priority = "extra-high",
          width = 128,
          height = 128
        }
      },
      direction_out =
      {
        sheet =
        {
          filename = "__LoaderRedux__/graphics/entity/purple-loader.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          y = 128
        }
      }
    },
    ending_patch = ending_patch_prototype
  },
})
end