--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

-- match loader speed to their respective belts
data.raw["loader"]["loader"].speed = data.raw["transport-belt"]["transport-belt"].speed
data.raw["loader"]["fast-loader"].speed = data.raw["transport-belt"]["fast-transport-belt"].speed
data.raw["loader"]["express-loader"].speed = data.raw["transport-belt"]["express-transport-belt"].speed
