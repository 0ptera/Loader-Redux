function make_loader_entity(name, belt)
  local loader = data.raw["loader"][name] or copyPrototype("loader", "loader", name)
  loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
  loader.icon = "__LoaderRedux__/graphics/icon/"..name..".png"
  loader.icon_size = 32

  loader.structure.direction_in.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
  loader.structure.direction_in.sheet.width = 128
  loader.structure.direction_in.sheet.height = 128
  loader.structure.direction_out.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
  loader.structure.direction_out.sheet.width = 128
  loader.structure.direction_out.sheet.height = 128
  loader.structure.direction_out.sheet.y = 128

  loader.speed = belt.speed

  -- 0.17 animations
  loader.belt_animation_set = belt.belt_animation_set
  loader.structure_render_layer = "transport-belt-circuit-connector"  

  -- 0.16 legacy
  -- loader.belt_horizontal = belt.belt_horizontal or basic_belt_horizontal
  -- loader.belt_vertical   = belt.belt_vertical or basic_belt_vertical
  -- loader.ending_top      = belt.ending_top or basic_belt_ending_top
  -- loader.ending_bottom   = belt.ending_bottom or basic_belt_ending_bottom
  -- loader.ending_side     = belt.ending_side or basic_belt_ending_side
  -- loader.starting_top    = belt.starting_top or basic_belt_starting_top
  -- loader.starting_bottom = belt.starting_bottom or basic_belt_starting_bottom
  -- loader.starting_side   = belt.starting_side or basic_belt_starting_side  

  return loader
end


data:extend({
  make_loader_entity("loader", data.raw["transport-belt"]["transport-belt"]),
  make_loader_entity("fast-loader", data.raw["transport-belt"]["fast-transport-belt"]),
  make_loader_entity("express-loader", data.raw["transport-belt"]["express-transport-belt"]),
})

if mods["boblogistics"] then
  data:extend({
    make_loader_entity("purple-loader", data.raw["transport-belt"]["turbo-transport-belt"]),
    make_loader_entity("green-loader", data.raw["transport-belt"]["ultimate-transport-belt"]),
  })
end
