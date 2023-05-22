
vim.o.guifont = "#e-subpixelantialias:#h-none"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require "options"
require "keymaps"

require "plugins"
require "telescope-cfg"

require "treesitter-cfg"
require "lsp"
require "gitsigns-cfg"
require "comment-cfg"
require "nvim-tree-cfg"
-- require "bufferline-cfg"
require "colorscheme-cfg"
require "cmp-cfg"
require "lualine-cfg"
require "toggleterm-cfg"
require "project-cfg"
require "indentline-cfg"
require "alpha-cfg"
require "whichkey-cfg"
require "autocommands"
require "rust-tools-cfg"
