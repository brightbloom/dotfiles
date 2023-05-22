local alpha = require("alpha")

local dashboard = require("alpha.themes.dashboard")

local header = {
	[[                                                                   ]],
	[[      ████ ██████           █████      ██                    ]],
	[[     ███████████             █████                            ]],
	[[     █████████ ███████████████████ ███   ███████████  ]],
	[[    █████████  ███    █████████████ █████ ██████████████  ]],
	[[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
	[[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
	[[██████  █████████████████████ ████ █████ █████ ████ ██████]],
}

local function colorize_header()
	local catppuccin = require("catppuccin.palettes").get_palette()
	local colors = {
		catppuccin.red,
		catppuccin.red,
		catppuccin.peach,
		catppuccin.yellow,
		catppuccin.green,
		catppuccin.sky,
		catppuccin.blue,
		catppuccin.mauve,
		catppuccin.overlay0,
	}
	for i, color in pairs(colors) do
		local cmd = "hi StartLogo" .. i .. " guifg=" .. color
		vim.cmd(cmd)
	end

	local lines = {}

	for i, chars in pairs(header) do
		local line = {
			type = "text",
			val = chars,
			opts = {
				hl = "StartLogo" .. i,
				shrink_margin = false,
				position = "center",
			},
		}

		table.insert(lines, line)
	end

	return lines
end

dashboard.section.header.val = colorize_header()

dashboard.section.buttons.val = {
	dashboard.button("v", "  ~/.config/nvim", ":lua require('project_nvim.project').set_pwd('~/.config/nvim') <CR> :Telescope find_files <CR>"),
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
	dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
}

dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup({
  layout = {
    { type = "padding", val = 8 },
    { type = "group", val = colorize_header() },
    { type = "padding", val = 3 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
  },
  opts = {margin = 5},
})

