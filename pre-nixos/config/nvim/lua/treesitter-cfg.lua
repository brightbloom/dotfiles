local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
		"bash",
		"c",
		"json",
		"lua",
		"python",
		"rust",
		"yaml",
		"make",
		"cmake",
		"markdown",
		"markdown_inline",
		"toml",
		"llvm",
		"latex",
	}, -- one of "all" or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python" } },
})

local context_status_ok, context = pcall(require, "treesitter-context")
if not context_status_ok then
	return
end

context.setup({
	enable = true,
	max_lines = -1, -- How many lines the window should span. Values <= 0 mean no limit.
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
})
