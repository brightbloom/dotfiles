-- Lazy boilerplate --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/neodev.nvim", config = true },
	"folke/which-key.nvim",
	"akinsho/toggleterm.nvim",
	-- Auto-pairing
	{
		"steelsojka/pears.nvim",
		enabled = false,
		config = function()
			require("pears").setup(function(conf)
				conf.remove_pair_on_outer_backspace(false)
			end)
		end,
	},

	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				layout = {
					max_width = { 60, 0.45 },
				},
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
	},

	"numToStr/Comment.nvim",
	{ "nmac427/guess-indent.nvim", config = true },
	"kyazdani42/nvim-web-devicons",
	"famiu/bufdelete.nvim",
	"nvim-lualine/lualine.nvim",
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				text = {
					spinner = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
				},
				timer = {
					spinner_rate = 80,
				},
			})
		end,
	},

	{
		"abecodes/tabout.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
		},
		config = true,
	},
	{ "ahmedkhalf/project.nvim", lazy = false },
	"lukas-reineke/indent-blankline.nvim",
	"goolord/alpha-nvim",

	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("hop").setup({
				keys = "tnseriao",
			})
		end,
	},

	-- Colorschemes (inactive ones can always be lazy loaded)
	{ "catppuccin/nvim", name = "catppuccin", lazy = false },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "lunarvim/darkplus.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true },
	{ "neanias/everforest-nvim", lazy = true },
	{ "arcticicestudio/nord-vim", lazy = true },

	{
		"hrsh7th/nvim-cmp", -- The completion plugin
		version = false, -- last release is so old!
		event = "InsertEnter",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- lsp completions
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			-- "saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
	},
	{ "L3MON4D3/LuaSnip", dependencies = "nvim-cmp" },
	{
		"folke/trouble.nvim",
		enabled = false,
		config = function()
			require("trouble").setup({
				use_diagnostic_signs = false,
			})
		end,
	},

	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
	"RRethy/vim-illuminate",
	{ "nvim-telescope/telescope.nvim", tag = "0.1.1", dependencies = "nvim-lua/plenary.nvim" },

	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old
	},

	{ "nvim-treesitter/nvim-treesitter-context", lazy = true },

	-- change inside argument (cia) with treesitter :)
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["ia"] = "@parameter.inner",
						},
					},
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- Git
	"lewis6991/gitsigns.nvim",

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
			require("neoscroll.config").set_mappings({
				["<C-Up>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } },
				["<C-Down>"] = { "scroll", { "vim.wo.scroll", "true", "100" } },
            })
		end,
	},

	-- Undo tree
	{ "simnalamburt/vim-mundo", lazy = false },

	-- Rust tools
	{ "simrat39/rust-tools.nvim", lazy = true },
})
-- }, opts)
