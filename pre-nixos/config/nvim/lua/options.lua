local options = {
	tabstop = 4, -- how many spaces for a tab
	shiftwidth = 4, -- the number of spaces inserted for each indentation
	expandtab = true, -- convert tabs to spaces
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	completeopt = { "menuone" }, -- mostly just for cmp
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- linux~!
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we use a separate plugin for this
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set 24-bit color
	timeoutlen = 200, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 100, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 3, -- set number column width to 2 {default 4}

	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = true,
	linebreak = true, -- companion to wrap, don't split words
	scrolloff = 5, -- minimal number of screen lines to keep above and below the cursor
	sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
	-- guifont = "JetBrainsMono Medium Nerd Font Complete", -- the font used in graphical neovim applications
    guifont = "#e-subpixelantialias:#h-none",
	whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches

vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- don't put nvim plugins in vim dirs

vim.g.neovide_transparency = 0.92

vim.g.neovide_scale_factor = 1
vim.keymap.set("n", "<C-=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.15
end)
vim.keymap.set("n", "<C-->", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.15
end)
vim.keymap.set("i", "<C-=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.15
end)
vim.keymap.set("i", "<C-->", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.15
end)


