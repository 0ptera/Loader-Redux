--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

data:extend({
  {
    type = "recipe",
    name = "loader",
    enabled = false,
    hidden = false,
    energy_required = 5,
    ingredients = {
      {"iron-plate", 10},
      {"electronic-circuit", 10},
      {"inserter", 5},
      {"transport-belt", 5},
    },
    result = "loader"
  },
  {
    type = "recipe",
    name = "fast-loader",
    enabled = false,
    hidden = false,
    energy_required = 5,
    ingredients = {
      {"iron-gear-wheel", 20},
      {"electronic-circuit", 20},
      {"advanced-circuit", 1},
      {"loader", 1},
    },
    result = "fast-loader"
  },
  {
    type = "recipe",
    name = "express-loader",
    category = "crafting-with-fluid",
    enabled = false,
    hidden = false,
    energy_required = 5,
    ingredients = {
      {"iron-gear-wheel", 20},
      {"advanced-circuit", 20},
      {"fast-loader", 1},
      {type="fluid", name="lubricant", amount=80},
    },
    result = "express-loader"
  },
})
