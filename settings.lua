data:extend{
	{
		type = "bool-setting",
		name = "loader-snapping",
		setting_type = "runtime-global",
		default_value = true,
		order = "loader-snapping",
	},
	{
		type = "string-setting",
		name = "loader-use-trains",
		setting_type = "runtime-global",
		default_value = "disabled",
		allowed_values = {"disabled", "auto-only", "all trains"},
		order = "loader-automatic",
	}
}
