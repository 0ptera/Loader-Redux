--[[ Copyright (c) 2017 Optera
* Part of Loader Redux
*
* See LICENSE.md in the project directory for license information.
--]]

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

local function make_loader_item(name, subgroup, order, loader_tint)
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
        tint = loader_tint,
      },
    },
    subgroup = subgroup,
    order = order,
    place_result = name,
    stack_size = 50
  }
end

if mods["boblogistics"] then
  data:extend({
    make_loader_item("loader","bob-logistic-tier-1","d-a", tints["loader"]),
    make_loader_item("fast-loader","bob-logistic-tier-2","d-b", tints["fast-loader"]),
    make_loader_item("express-loader","bob-logistic-tier-3","d-c", tints["express-loader"]),
    make_loader_item("purple-loader","bob-logistic-tier-4","d-d", tints["purple-loader"]),
    make_loader_item("green-loader","bob-logistic-tier-5","d-f", tints["green-loader"]),
  })
else
  data:extend({
    make_loader_item("loader","belt","d-a", tints["loader"]),
    make_loader_item("fast-loader","belt","d-b", tints["fast-loader"]),
    make_loader_item("express-loader","belt","d-c", tints["express-loader"]),
  })
end