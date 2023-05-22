local lualine = require("lualine")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		if str == "INSERT" then
			return "🌷 " .. str .. " 🌷"
		elseif str == "NORMAL" then
			return "🪷 " .. str .. " 🪷"
		elseif str == "COMMAND" then
			return "🍁 " .. str .. " 🍁"

		end
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = {
		"▍  ▏🥚",
		"▌  ▏🥚",
		"▋  ▏🥚",
		"▊  ▏🥚",
		"▉  ▏🥚",
		"█  ▏🥚",
		"█▏ ▏🐣",
		"█▎ ▏🐣",
		"█▍ ▏🐣",
		"█▌ ▏🐣",
		"█▋ ▏🐣",
		"█▊ ▏🐣",
		"█▉ ▏🐣",
		"██ ▏🐤",
		"██ ▏🐤",
		"██▏▏🐤",
		"██▎▏🐤",
		"██▍▏🐤",
		"██▌▏🐐",
		"██▋▏🐐",
		"██▊▏🐐",
		"██▉▏🐐",
		"███▏🐐",
	}
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local coffee = function()
	return " "
end

local filename = {
	'filename',
	symbols = {
		modified = '🍌',
	}
}

local beans = function()
	return " "
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
	},
	sections = {
		lualine_a = { branch, diagnostics },
		lualine_b = { mode },
		lualine_c = { filename, diff },
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { "encoding", spaces },
		lualine_y = { filetype },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {},
	tabline = {},
	extensions = {},
})
