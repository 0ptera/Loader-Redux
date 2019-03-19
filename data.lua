--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

optera_lib = optera_lib or {}

require("prototypes.item")
require("prototypes.recipe")
require("prototypes.entity")

-- add loader to existing techs
local loader_techs = {
  ["logistics"] = "loader",
  ["logistics-2"] = "fast-loader",
  ["logistics-3"] = "express-loader",
  ["bob-logistics-4"] = "purple-loader",
  ["bob-logistics-5"] = "green-loader",
}

for tech, recipe in pairs(loader_techs) do
  if data.raw.technology[tech] then
    table.insert(data.raw.technology[tech].effects, {type = "unlock-recipe", recipe = recipe} )
  end
end
