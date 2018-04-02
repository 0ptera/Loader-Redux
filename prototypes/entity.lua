function make_loader_entity(name,speed)
  local loader = data.raw["loader"][name] or copyPrototype("loader", "loader", name)
  loader.structure.direction_in.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
  loader.structure.direction_in.sheet.width = 128
  loader.structure.direction_in.sheet.height = 128
  loader.structure.direction_out.sheet.filename="__LoaderRedux__/graphics/entity/"..name..".png"
  loader.structure.direction_out.sheet.width = 128
  loader.structure.direction_out.sheet.height = 128
  loader.structure.direction_out.sheet.y = 128
  loader.icon = "__LoaderRedux__/graphics/icon/"..name..".png"
  loader.icon_size = 32
  loader.speed = speed
  loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
  return loader
end


data:extend({
  make_loader_entity("loader", data.raw["transport-belt"]["transport-belt"].speed),
  make_loader_entity("fast-loader", data.raw["transport-belt"]["fast-transport-belt"].speed),
  make_loader_entity("express-loader", data.raw["transport-belt"]["express-transport-belt"].speed),
})

if data.raw.technology["bob-logistics-4"] then
  data:extend({
    make_loader_entity("purple-loader", data.raw["transport-belt"]["turbo-transport-belt"].speed),
    make_loader_entity("green-loader", data.raw["transport-belt"]["ultimate-transport-belt"].speed),
  })
end
