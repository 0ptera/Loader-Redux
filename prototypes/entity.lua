--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

function make_loader_entity(name, belt)
  local loader = data.raw["loader"][name] or optera_lib.copy_prototype(data.raw["loader"]["loader"], name)
  loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
  loader.icon = "__LoaderRedux__/graphics/icon/"..name..".png"
  loader.icon_size = 32
  loader.icon_mipmaps = nil

  loader.structure.direction_in.sheet = {
    filename="__LoaderRedux__/graphics/entity/"..name..".png",
    priority = "extra-high",
    width = 128,
    height = 128,
    hr_version = {
      filename="__LoaderRedux__/graphics/entity/hr-"..name..".png",
      priority = "extra-high",
      width = 256,
      height = 256,
      scale = 0.5,
    }
  }
  loader.structure.direction_out.sheet ={
    filename="__LoaderRedux__/graphics/entity/"..name..".png",
    priority = "extra-high",
    width = 128,
    height = 128,
    y = 128,
    hr_version = {
      filename="__LoaderRedux__/graphics/entity/hr-"..name..".png",
      priority = "extra-high",
      width = 256,
      height = 256,
      y = 256,
      scale = 0.5,
    }
  }
  loader.speed = belt.speed

  -- 0.17 animations
  loader.belt_animation_set = belt.belt_animation_set
  loader.structure_render_layer = "object"

  return loader
end


data:extend({
  make_loader_entity("loader", data.raw["transport-belt"]["transport-belt"]),
  make_loader_entity("fast-loader", data.raw["transport-belt"]["fast-transport-belt"]),
  make_loader_entity("express-loader", data.raw["transport-belt"]["express-transport-belt"]),
})
data.raw["loader"]["loader"].next_upgrade = "fast-loader"
data.raw["loader"]["fast-loader"].next_upgrade = "express-loader"
data.raw["loader"]["express-loader"].next_upgrade = nil


if mods["boblogistics"] then
  data:extend({
    make_loader_entity("purple-loader", data.raw["transport-belt"]["turbo-transport-belt"]),
    make_loader_entity("green-loader", data.raw["transport-belt"]["ultimate-transport-belt"]),
  })
  data.raw["loader"]["express-loader"].next_upgrade = "purple-loader"
  data.raw["loader"]["purple-loader"].next_upgrade = "green-loader"
  data.raw["loader"]["green-loader"].next_upgrade = nil
end
