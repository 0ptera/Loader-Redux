local yellowLoader = data.raw.recipe["loader"]
yellowLoader.energy_required = 5
yellowLoader.ingredients =
{
  {"inserter", 5},
  {"transport-belt", 5},
  {"electronic-circuit", 10},  
}
-- change recipe for bobplates
if data.raw.item["tin-plate"] then
  table.insert(yellowLoader.ingredients, {"tin-plate", 10})
else
  table.insert(yellowLoader.ingredients, {"iron-plate", 10})
end


local redLoader = data.raw.recipe["fast-loader"]
redLoader.energy_required = 5
redLoader.ingredients =
{
  {"loader", 1},  
  {"electronic-circuit", 20},
}
-- change recipe for bobplates
if data.raw.item["bronze-alloy"] then
  table.insert(redLoader.ingredients, {"bronze-alloy", 10})
else
  table.insert(redLoader.ingredients, {"advanced-circuit", 1})
end
if data.raw.item["steel-gear-wheel"] then
  table.insert(redLoader.ingredients, {"steel-gear-wheel", 14})
else
  table.insert(redLoader.ingredients, {"iron-gear-wheel", 20})
end


local blueLoader = data.raw.recipe["express-loader"]
blueLoader.energy_required = 5
blueLoader.ingredients =
{
  {"fast-loader", 1},
  {"advanced-circuit", 20},  
}
-- change recipe for bobplates
if data.raw.item["aluminium-plate"] then
  table.insert(blueLoader.ingredients, {"aluminium-plate", 10})
else
  blueLoader.category = "crafting-with-fluid"
  table.insert(blueLoader.ingredients, {type="fluid", name="lubricant", amount=40})
end
if data.raw.item["cobalt-steel-bearing"] then
  table.insert(blueLoader.ingredients, {"cobalt-steel-bearing", 14})
end
if data.raw.item["cobalt-steel-gear-wheel"] then
  table.insert(blueLoader.ingredients, {"cobalt-steel-gear-wheel", 14})
else
  table.insert(blueLoader.ingredients, {"iron-gear-wheel", 20})
end

-- if boblogistics
if data.raw.technology["bob-logistics-4"] then
  local purpleLoader =
  {
    type = "recipe",
    name = "purple-loader",
    enabled = "false",
    energy_required = 5,
    ingredients =
    {
      {"express-loader", 1}
    },
    result = "purple-loader"
 }

  -- change recipe for bobplates
  if data.raw.item["advanced-processing-unit"] then
    table.insert(purpleLoader.ingredients, {"processing-unit", 10})
  else
    table.insert(purpleLoader.ingredients, {"advanced-circuit", 20})
    table.insert(purpleLoader.ingredients, {"processing-unit", 1})
  end
  if data.raw.item["titanium-plate"] then
    table.insert(purpleLoader.ingredients, {"titanium-plate", 10})
  end
  if data.raw.item["titanium-bearing"] then
    table.insert(purpleLoader.ingredients, {"titanium-bearing", 14})
  end
  if data.raw.item["titanium-gear-wheel"] then
    table.insert(purpleLoader.ingredients, {"titanium-gear-wheel", 14})
  else
    table.insert(purpleLoader.ingredients, {"iron-gear-wheel", 20})
  end

  local greenLoader =
  {
    type = "recipe",
    name = "green-loader",
    enabled = "false",
    energy_required = 5,
    ingredients =
    {
      {"purple-loader", 1}
    },
    result = "green-loader"
 }

  -- change recipe for bobplates
  if data.raw.item["advanced-processing-unit"] then
    table.insert(greenLoader.ingredients, {"advanced-processing-unit", 10})
  else
    table.insert(greenLoader.ingredients, {"processing-unit", 20})
  end
  if data.raw.item["nitinol-alloy"] then
    table.insert(greenLoader.ingredients, {"nitinol-alloy", 10})
  end
  if data.raw.item["nitinol-bearing"] then
    table.insert(greenLoader.ingredients, {"nitinol-bearing", 14})
  end
  if data.raw.item["nitinol-gear-wheel"] then
    table.insert(greenLoader.ingredients, {"nitinol-gear-wheel", 14})
  else
    table.insert(greenLoader.ingredients, {"iron-gear-wheel", 20})
  end

  data:extend({purpleLoader, greenLoader})
end

