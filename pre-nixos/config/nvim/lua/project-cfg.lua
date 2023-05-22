require('project_nvim').setup({
	manual_mode = false,
	detection_methods = { "pattern" },
	-- patterns used to detect root dir, when **"pattern"** is in detection_methods
	patterns = { "=src/*", ".git", "Cargo.toml", "Makefile" },
	-- Show hidden files in telescope when searching for files in a project
	show_hidden = true,
	silent_chdir = true,
	-- path to store the project history for use in telescope
	datapath = vim.fn.stdpath("data"),
})

require('telescope').load_extension("projects")
