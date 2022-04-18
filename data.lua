--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- require("prototypes.make_loader")
local lr = require("__LoaderRedux__.make_loader")
require("prototypes.recipe")

local tints = {
  ["loader"] = util.color("ffc340d9"),
  ["fast-loader"] = util.color("e31717d9"),
  ["express-loader"] = util.color("43c0fad9"),
}

-- Create loaders
local belt_prototypes = data.raw["transport-belt"]

data:extend({
  lr.make_loader_item("loader", "belt", "d-a", tints["loader"]),
  lr.make_loader_item("fast-loader", "belt", "d-b", tints["fast-loader"]),
  lr.make_loader_item("express-loader", "belt", "d-c", tints["express-loader"]),

  lr.make_loader_entity("loader", belt_prototypes["transport-belt"], tints["loader"], "fast-loader"),
  lr.make_loader_entity("fast-loader", belt_prototypes["fast-transport-belt"], tints["fast-loader"], "express-loader"),
  lr.make_loader_entity("express-loader", belt_prototypes["express-transport-belt"], tints["express-loader"], nil),
})

-- Add loader to existing techs
local loader_techs = {
  ["logistics"] = "loader",
  ["logistics-2"] = "fast-loader",
  ["logistics-3"] = "express-loader",
}

for tech, recipe in pairs(loader_techs) do
  if data.raw.technology[tech] then
    table.insert(data.raw.technology[tech].effects, {type = "unlock-recipe", recipe = recipe} )
  end
end