data:extend({
	{
    type = "technology",
    name = "loader",
    icon = "__LoaderRedux__/graphics/tech/yellow-loader-tech.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "loader"
      },
	 },
    prerequisites = {"logistics"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 15
    },
    order = "a-f-a",
	},
	{
    type = "technology",
    name = "fast-loader",
    icon = "__LoaderRedux__/graphics/tech/red-loader-tech.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fast-loader"
      },
	 },
    prerequisites = {"logistics-2"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 15
    },
    order = "a-f-b",
	},
	{
    type = "technology",
    name = "express-loader",
    icon = "__LoaderRedux__/graphics/tech/blue-loader-tech.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "express-loader"
      },
	 },
    prerequisites = {"logistics-3"},
    unit =
    {
      count = 400,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"production-science-pack", 1}
      },
      time = 15
    },
    order = "a-f-c",
	},
})

local bobLogistic4 = data.raw.technology["bob-logistics-4"]
if bobLogistic4 then
data:extend({
   {
    type = "technology",
    name = "green-loader",
    icon = "__LoaderRedux__/graphics/tech/green-loader-tech.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "green-loader"
      }
    },
    prerequisites = {"bob-logistics-4"},
    unit = bobLogistic4.unit,
    order = "a-f-d",
  }
})
end

local bobLogistic5 = data.raw.technology["bob-logistics-5"]
if bobLogistic5 then
data:extend({
  {
    type = "technology",
    name = "purple-loader",
    icon = "__LoaderRedux__/graphics/tech/purple-loader-tech.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "purple-loader"
      }
    },
    prerequisites = {"bob-logistics-5"},
    unit = bobLogistic5.unit,
    order = "a-f-e",
  }
})
end