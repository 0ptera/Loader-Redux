--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

require("prototypes.make_loader")
require("prototypes.recipe")

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

-- create loaders
local belt_prototypes = data.raw["transport-belt"]

if mods["boblogistics"] then
  data:extend({
    make_loader_item("loader", "bob-logistic-tier-1", "d-a", tints["loader"]),
    make_loader_item("fast-loader", "bob-logistic-tier-2", "d-b", tints["fast-loader"]),
    make_loader_item("express-loader", "bob-logistic-tier-3", "d-c", tints["express-loader"]),
    make_loader_item("purple-loader", "bob-logistic-tier-4", "d-d", tints["purple-loader"]),
    make_loader_item("green-loader", "bob-logistic-tier-5", "d-f", tints["green-loader"]),

    make_loader_entity("loader", belt_prototypes["transport-belt"], tints["loader"], "fast-loader"),
    make_loader_entity("fast-loader", belt_prototypes["fast-transport-belt"], tints["fast-loader"], "express-loader"),
    make_loader_entity("express-loader", belt_prototypes["express-transport-belt"], tints["express-loader"], "purple-loader"),
    make_loader_entity("purple-loader", belt_prototypes["turbo-transport-belt"], tints["purple-loader"], "green-loader"),
    make_loader_entity("green-loader", belt_prototypes["ultimate-transport-belt"], tints["green-loader"], nil),
  })
else
  data:extend({
    make_loader_item("loader", "belt", "d-a", tints["loader"]),
    make_loader_item("fast-loader", "belt", "d-b", tints["fast-loader"]),
    make_loader_item("express-loader", "belt", "d-c", tints["express-loader"]),

    make_loader_entity("loader", belt_prototypes["transport-belt"], tints["loader"], "fast-loader"),
    make_loader_entity("fast-loader", belt_prototypes["fast-transport-belt"], tints["fast-loader"], "express-loader"),
    make_loader_entity("express-loader", belt_prototypes["express-transport-belt"], tints["express-loader"], nil),
  })
end

-- add loader to existing techs
local loader_techs = {
  ["logistics"] = "loader",
  ["logistics-2"] = "fast-loader",
  ["logistics-3"] = "express-loader",
}

if mods["boblogistics"] then
  loader_techs["logistics-4"] = "purple-loader"
  loader_techs["logistics-5"] = "green-loader"
end

for tech, recipe in pairs(loader_techs) do
  if data.raw.technology[tech] then
    table.insert(data.raw.technology[tech].effects, {type = "unlock-recipe", recipe = recipe} )
  end
end