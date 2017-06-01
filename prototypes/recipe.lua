if data.raw["item"]["green-transport-belt"] then
data:extend({
  {
    type = "recipe",
    name = "green-loader",
    enabled = "false",
    energy_required = 15,
    ingredients =
    {
      {"green-transport-belt", 5},
      {"express-loader", 1}
    },
    result = "green-loader"
   },
   {
    type = "recipe",
    name = "purple-loader",
    enabled = "false",
    energy_required = 20,
    ingredients =
    {
      {"purple-transport-belt", 5},
      {"green-loader", 1}
    },
    result = "purple-loader"
   },
})
end