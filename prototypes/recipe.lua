--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

local yellowLoader = data.raw.recipe["loader"]
yellowLoader.energy_required = 5
yellowLoader.ingredients = {
  {"iron-plate", 10},
  {"electronic-circuit", 10},
  {"inserter", 5},
  {"transport-belt", 5},
}

local redLoader = data.raw.recipe["fast-loader"]
redLoader.energy_required = 5
redLoader.ingredients = {
  {"iron-gear-wheel", 20},
  {"electronic-circuit", 20},
  {"advanced-circuit", 1},
  {"loader", 1},
}

local blueLoader = data.raw.recipe["express-loader"]
blueLoader.energy_required = 5
blueLoader.category = "crafting-with-fluid"
blueLoader.ingredients = {
  {"iron-gear-wheel", 20},
  {"advanced-circuit", 20},
  {"fast-loader", 1},
  {type="fluid", name="lubricant", amount=80},
}


-- add turbo and ultimate loader
if mods["boblogistics"] then
  data:extend({
    {
      type = "recipe",
      name = "purple-loader",
      enabled = "false",
      energy_required = 5,
      ingredients = {
        {"iron-gear-wheel", 20},
        {"advanced-circuit", 20},
        {"processing-unit", 1},
        {"express-loader", 1},
      },
      result = "purple-loader"
    },
    {
      type = "recipe",
      name = "green-loader",
      enabled = "false",
      energy_required = 5,
      ingredients = {
        {"iron-gear-wheel", 20},
        {"processing-unit", 20},
        {"purple-loader", 1},
      },
      result = "green-loader"
    },
  })

  -- change recipes when bobplates is also present
  if mods["bobplates"] then
    data.raw.recipe["purple-loader"].ingredients = {
      {"processing-unit", 10},
      {"titanium-bearing", 14},
      {"titanium-gear-wheel", 14},
      {"express-loader", 1},
    }
    data.raw.recipe["green-loader"].ingredients = {
      {"advanced-processing-unit", 10},
      {"nitinol-bearing", 14},
      {"nitinol-gear-wheel", 14},
      {"purple-loader", 1},
    }
  end
end
