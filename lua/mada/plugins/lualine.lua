local setup, lualine = pcall(require, "lualine")
if not setup then
	return
end


local ready, gps = pcall(require, "nvim-gps")
if not ready then
	return
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = {left = "", right = ""},
		section_separators = {left = "", right = ""},
		globalstatus = true
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str)
					return string.lower(str)
				end
			}
		},
		lualine_b = {"branch", "diff", "diagnostics"},
		lualine_c = { {"filename", file_status = true} },
		lualine_x = {
		 	{gps.get_location, cond = gps.is_available},
		},
		lualine_y = {"filetype"},
		lualine_z = {"location"}
	}
})
