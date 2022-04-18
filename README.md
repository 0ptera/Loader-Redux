# Loader-Redux
Adds Loaders.
Rewritten add-loader with new loader snapping logic.
Graphics from Arch666Angel and Kirazy.


# API Data Stage
local loader_redux = require("__LoaderRedux__.make_loader")

loader_redux.make_loader_item(name, subgroup, order, tint)
--- create loader item
-- @tparam String name
-- @tparam String subgroup
-- @tparam String order
-- @tparam Types.Color[] tint

loader_redux.make_loader_entity(name, belt, tint, next_upgrade)
--- create loader entity
-- @tparam String name
-- @tparam Prototype.TransportBelt[] belt
-- @tparam Types.Color[] tint
-- @tparam String|nil next_upgrade


# API Control Stage
remote.call("loader-redux", "add_loader", name)
--- register loader for snapping and train interaction
-- @tparam String name

remote.call("loader-redux", "remove_loader", name)
--- unregister loader for snapping and train interaction
-- @tparam String name