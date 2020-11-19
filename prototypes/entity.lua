--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

local flib = require('__flib__.data-util')

local tints = {
	["loader"] = util.color("ffc340d9"),
	["fast-loader"] = util.color("e31717d9"),
	["express-loader"] = util.color("43c0fad9"),
	["purple-loader"] = util.color("a510e5d9"),
	["green-loader"] = util.color("16f263d9"),
}

-- Compatibility with Bob's Logistics Belt Reskin's color
if mods["boblogistics-belt-reskin"] then
	tints["purple-loader"] = util.color("df1ee5d9")
end

local function make_loader_entity(name, belt, loader_tint)
  local loader = data.raw["loader"][name] or flib.copy_prototype(data.raw["loader"]["loader"], name)
  loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
  loader.icons = {
    -- Base
    {
      icon = "__LoaderRedux__/graphics/icon/icon-loader-base.png",
      icon_size = 64,
      icon_mipmaps = 4,
    },
    -- Mask
    {
      icon = "__LoaderRedux__/graphics/icon/icon-loader-mask.png",
      icon_size = 64,
      icon_mipmaps = 4,
      tint = loader_tint,
    },
  }

  loader.structure.front_patch = {
    sheet = {
      filename= "__LoaderRedux__/graphics/entity/loader-front-patch.png",
      priority = "extra-high",
      width = 94,
      height = 79,
      shift = util.by_pixel(10, 2),
      hr_version = {
        filename= "__LoaderRedux__/graphics/entity/hr-loader-front-patch.png",
        priority = "extra-high",
        width = 186,
        height = 155,
        shift = util.by_pixel(9.5, 1.5),
        scale = 0.5,
      }
    }

  }
  loader.structure.direction_in = {
    sheets = {
      -- Base
      {
        filename= "__LoaderRedux__/graphics/entity/loader-base.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-base.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          scale = 0.5,
        }
      },
      -- Mask
      {
        filename= "__LoaderRedux__/graphics/entity/loader-mask.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        tint = loader_tint,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-mask.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          tint = loader_tint,
          scale = 0.5,
        }
      },
      -- Shadow
      {
        filename= "__LoaderRedux__/graphics/entity/loader-shadow.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        draw_as_shadow = true,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-shadow.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          draw_as_shadow = true,
          scale = 0.5,
        }
      },
      -- Lights (Implemented in 1.1, subject to some adjustments)
      -- {
      --   filename= "__LoaderRedux__/graphics/entity/loader-light.png",
      --   priority = "extra-high",
      --   width = 94,
      --   height = 79,
      --   shift = util.by_pixel(10, 2),
      --   draw_as_light = true,
      --   hr_version = {
      --     filename= "__LoaderRedux__/graphics/entity/hr-loader-light.png",
      --     priority = "extra-high",
      --     width = 186,
      --     height = 155,
      --     shift = util.by_pixel(9.5, 1.5),
      --     draw_as_light = true,
      --     scale = 0.5,
      --   }
      -- },
    }
  }
  loader.structure.direction_out = {
    sheets = {
      -- Base
      {
        filename= "__LoaderRedux__/graphics/entity/loader-base.png",
        priority = "extra-high",
        y = 79,
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-base.png",
          priority = "extra-high",
          y = 155,
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          scale = 0.5,
        }
      },
      -- Mask
      {
        filename= "__LoaderRedux__/graphics/entity/loader-mask.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        tint = loader_tint,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-mask.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          tint = loader_tint,
          scale = 0.5,
        }
      },
      -- Shadow
      {
        filename= "__LoaderRedux__/graphics/entity/loader-shadow.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        draw_as_shadow = true,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-shadow.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          draw_as_shadow = true,
          scale = 0.5,
        }
      },
      -- Lights (Implemented in 1.1, subject to some adjustments)
      -- {
      --   filename= "__LoaderRedux__/graphics/entity/loader-light.png",
      --   priority = "extra-high",
      --   y = 79,
      --   width = 94,
      --   height = 79,
      --   shift = util.by_pixel(10, 2),
      --   draw_as_light = true,
      --   hr_version = {
      --     filename= "__LoaderRedux__/graphics/entity/hr-loader-light.png",
      --     priority = "extra-high",
      --     y = 155,
      --     width = 186,
      --     height = 155,
      --     shift = util.by_pixel(9.5, 1.5),
      --     draw_as_light = true,
      --     scale = 0.5,
      --   }
      -- },
    }
  }
  loader.speed = belt.speed

  -- 0.17 animations
  loader.belt_animation_set = belt.belt_animation_set
  loader.structure_render_layer = "object"

  return loader
end


data:extend({
  make_loader_entity("loader", data.raw["transport-belt"]["transport-belt"], tints["loader"]),
  make_loader_entity("fast-loader", data.raw["transport-belt"]["fast-transport-belt"], tints["fast-loader"]),
  make_loader_entity("express-loader", data.raw["transport-belt"]["express-transport-belt"], tints["express-loader"]),
})
data.raw["loader"]["loader"].next_upgrade = "fast-loader"
data.raw["loader"]["fast-loader"].next_upgrade = "express-loader"
data.raw["loader"]["express-loader"].next_upgrade = nil


if mods["boblogistics"] then
  data:extend({
    make_loader_entity("purple-loader", data.raw["transport-belt"]["turbo-transport-belt"], tints["purple-loader"]),
    make_loader_entity("green-loader", data.raw["transport-belt"]["ultimate-transport-belt"], tints["green-loader"]),
  })
  data.raw["loader"]["express-loader"].next_upgrade = "purple-loader"
  data.raw["loader"]["purple-loader"].next_upgrade = "green-loader"
  data.raw["loader"]["green-loader"].next_upgrade = nil
end