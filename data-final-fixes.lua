--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- set loader speed to match their respective belts in case mods changed belt speeds
data.raw["loader"]["loader"].speed = data.raw["transport-belt"]["transport-belt"].speed
data.raw["loader"]["fast-loader"].speed = data.raw["transport-belt"]["fast-transport-belt"].speed
data.raw["loader"]["express-loader"].speed = data.raw["transport-belt"]["express-transport-belt"].speed

if mods["boblogistics"] then
  data.raw["loader"]["purple-loader"].speed = data.raw["transport-belt"]["turbo-transport-belt"].speed
  data.raw["loader"]["green-loader"].speed = data.raw["transport-belt"]["ultimate-transport-belt"].speed
end