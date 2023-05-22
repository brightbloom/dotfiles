local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

vim.g.indent_blankline_char = "▏"

vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_filetype_exclude = {
	"help",
	"startify",
	"dashboard",
	"packer",
	"neogitstatus",
	"NvimTree",
	"Trouble",
}
vim.g.indent_blankline_context_patterns = {
	"class",
	"return",
	"function",
	"method",
	"^if",
	"^while",
	"jsx_element",
	"^for",
	"^object",
	"^table",
	"block",
	"arguments",
	"if_statement",
	"else_clause",
	"jsx_element",
	"jsx_self_closing_element",
	"try_statement",
	"catch_clause",
	"import_statement",
	"operation_type",
}

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#EED49F gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#A6DA95 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#8BD5CA gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#91D7E3 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#7DC4E4 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#8AADF4 gui=nocombine]])

indent_blankline.setup({
	-- show_end_of_line = true,
	show_first_indent_level = true,
	use_treesitter = true,
	show_current_context = true,
	show_current_context_start = true,
	-- show_trailing_blankline_indent = false,
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
})
