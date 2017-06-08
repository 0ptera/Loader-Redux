local yellowLoader = data.raw.recipe["loader"]
yellowLoader.energy_required = 5
yellowLoader.ingredients =
{
  {"inserter", 5},
  {"transport-belt", 5},
  {"electronic-circuit", 10},
  {"iron-plate", 10},
}

local redLoader = data.raw.recipe["fast-loader"]
redLoader.energy_required = 5
redLoader.ingredients =
{
  {"loader", 1},
  {"iron-gear-wheel", 20},
  {"electronic-circuit", 20},
  {"advanced-circuit", 1},
}

local blueLoader = data.raw.recipe["express-loader"]
blueLoader.category = "crafting-with-fluid"
blueLoader.energy_required = 5
blueLoader.ingredients =
{
  {"fast-loader", 1},
  {"iron-gear-wheel", 20},
  {"advanced-circuit", 20},
  {type="fluid", name="lubricant", amount=40},
}

if data.raw.item["green-transport-belt"] then
  local greenLoader =
  {
    type = "recipe",
    name = "green-loader",
    enabled = "false",
    energy_required = 5,
    ingredients =
    {
      {"express-loader", 1},
      {"advanced-circuit", 20},
      {"processing-unit", 1},
    },
    result = "green-loader"
 }

  -- extend recipe for bobplates
  if data.raw.item["titanium-bearing"] then
    table.insert(greenLoader.ingredients, {"titanium-bearing", 10})
  end
  if data.raw.item["titanium-gear-wheel"] then
    table.insert(greenLoader.ingredients, {"titanium-gear-wheel", 20})
  else
    table.insert(greenLoader.ingredients, {"iron-gear-wheel", 20})
  end

  data:extend({greenLoader})
end

if data.raw.item["purple-transport-belt"] then
  local purpleLoader =
  {
    type = "recipe",
    name = "purple-loader",
    enabled = "false",
    energy_required = 5,
    ingredients =
    {
      {"green-loader", 1},
      {"processing-unit", 20},
    },
    result = "purple-loader"
 }

  -- extend recipe for bobplates
  if data.raw.item["nitinol-bearing"] then
    table.insert(purpleLoader.ingredients, {"nitinol-bearing", 10})
  end
  if data.raw.item["nitinol-gear-wheel"] then
    table.insert(purpleLoader.ingredients, {"nitinol-gear-wheel", 20})
  else
    table.insert(purpleLoader.ingredients, {"iron-gear-wheel", 20})
  end

  data:extend({purpleLoader})
end




