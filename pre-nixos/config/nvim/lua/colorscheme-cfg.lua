local colorscheme = "catppuccin-mocha"

if string.match(colorscheme, "catppuccin") then
	require("catppuccin").setup({
		-- color_overrides = {
		-- 	mocha = { base = "#000000", mantle = "#000000", crust = "#000000" },
		-- 	macchiato = { base = "#000000", mantle = "#000000", crust = "#000000" },
		-- },
		transparent_background = false,
		integrations = {
			notify = true,
			which_key = true,
			bufferline = true,
			treesitter_context = true,
			mason = true,
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			telescope = true,
			hop = true,
			markdown = true,
			treesitter = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
		},
	})
end

vim.cmd.colorscheme(colorscheme)
