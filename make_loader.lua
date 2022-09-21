--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

local flib = require('__flib__.data-util')
local lr_make_loader = {}

--- create loader item
-- @tparam String name
-- @tparam String subgroup
-- @tparam String order
-- @tparam Types.Color[] tint
function lr_make_loader.make_loader_item(name, subgroup, order, tint)
  return{
    type = "item",
    name = name,
    icons = {
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
        tint = tint,
      },
    },
    subgroup = subgroup,
    order = order,
    place_result = name,
    stack_size = 50
  }
end

--- create loader entity
-- @tparam String name
-- @tparam Prototype.TransportBelt[] belt
-- @tparam Types.Color[] tint
-- @tparam String|nil next_upgrade
function lr_make_loader.make_loader_entity(name, belt, tint, next_upgrade)
  local loader = data.raw["loader"][name] or flib.copy_prototype(data.raw["loader"]["loader"], name)
  loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
  loader.collision_mask = {"floor-layer", "object-layer", "transport-belt-layer", "water-tile"} -- match belt collision layers
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
      tint = tint,
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
        tint = tint,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-mask.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          tint = tint,
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
      -- Lights
      {
        filename= "__LoaderRedux__/graphics/entity/loader-lights.png",
        priority = "extra-high",
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        draw_as_light = true,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-lights.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          draw_as_light = true,
          scale = 0.5,
        }
      },
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
        tint = tint,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-mask.png",
          priority = "extra-high",
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          tint = tint,
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
      -- Lights
      {
        filename= "__LoaderRedux__/graphics/entity/loader-lights.png",
        priority = "extra-high",
        y = 79,
        width = 94,
        height = 79,
        shift = util.by_pixel(10, 2),
        draw_as_light = true,
        hr_version = {
          filename= "__LoaderRedux__/graphics/entity/hr-loader-lights.png",
          priority = "extra-high",
          y = 155,
          width = 186,
          height = 155,
          shift = util.by_pixel(9.5, 1.5),
          draw_as_light = true,
          scale = 0.5,
        }
      },
    }
  }

  loader.speed = belt.speed
  loader.next_upgrade = next_upgrade

  -- 0.17 animations
  loader.belt_animation_set = belt.belt_animation_set
  loader.structure_render_layer = "object"

  return loader
end

return lr_make_loader