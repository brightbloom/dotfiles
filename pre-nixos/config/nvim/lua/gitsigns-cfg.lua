local gitsigns = require("gitsigns")

local function get_all_commits_of_this_file()
	local scripts = vim.api.nvim_exec("!git log --pretty=oneline --abbrev-commit --follow %", true)
	local res = vim.split(scripts, "\n")
	local output = {}
	for index = 3, #res - 1 do
		local item = res[index]
		local hash_id = string.sub(item, 1, 7)
		local message = string.sub(item, 8)
		output[index - 2] = { hash_id = hash_id, message = message }
	end
	return output
end

function _DiffWith()
	local commits = get_all_commits_of_this_file()

	vim.ui.select(commits, {
		prompt = "Select commit to compare with current file",
		format_item = function(item)
			return item.hash_id .. " > " .. item.message
		end,
	}, function(choice)
		if choice ~= nil then
			gitsigns.diffthis(choice.hash_id)
		end
	end)
end

gitsigns.setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
})
