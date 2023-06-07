--[[ Copyright (c) 2017 Optera
 * Part of Loader Redux
 *
 * See LICENSE.md in the project directory for license information.
--]]

data:extend{
  {
    type = "bool-setting",
    name = "loader-snapping",
    order = "aa",
    setting_type = "runtime-global",
    default_value = true,
    order = "loader-snapping",
  },
  {
    type = "bool-setting",
    name = "loader-rail-interaction",
    order = "ba",
    setting_type = "startup",
    default_value = true,
  },
}
