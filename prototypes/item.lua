function make_loader_item(name,order)
	local subgroup="belt"
	if name == "green-loader" or name == "purple-loader" then subgroup="bob-belt" end
	return{
		type="item",
		name=name,
		icon="__LoaderRedux__/graphics/icon/"..name..".png",
		flags={"goes-to-quickbar"},
		subgroup=subgroup,
		order=order,
		place_result=name,
		stack_size=50
	}
end

data:extend({
  make_loader_item("loader","d-a"),
  make_loader_item("fast-loader","d-b"),
  make_loader_item("express-loader","d-c"),
})

if data.raw.item["green-transport-belt"] then
  data:extend({
    make_loader_item("green-loader","d-d"),
  })
end

if data.raw.item["purple-transport-belt"] then
  data:extend({  
    make_loader_item("purple-loader","d-e"),
  })
end