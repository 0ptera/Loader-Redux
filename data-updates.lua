--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- fix bobs belt speed changes in data-updates
if settings.startup["bobmods-logistics-beltoverhaul"] and settings.startup["bobmods-logistics-beltoverhaul"].value == true then
  data.raw["loader"]["loader"].speed = data.raw["transport-belt"]["transport-belt"].speed
  data.raw["loader"]["fast-loader"].speed = data.raw["transport-belt"]["fast-transport-belt"].speed
  data.raw["loader"]["express-loader"].speed = data.raw["transport-belt"]["express-transport-belt"].speed
  data.raw["loader"]["purple-loader"].speed = data.raw["transport-belt"]["turbo-transport-belt"].speed
  data.raw["loader"]["green-loader"].speed = data.raw["transport-belt"]["ultimate-transport-belt"].speed
end