local servers = {
	"lua_ls",
	"clangd",
	"pyright",
	"marksman",
	"bashls",
	"yamlls",
	-- "rust_analyzer",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = {exclude = {"rust_analyzer", }},
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig["lua_ls"].setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig["rust_analyzer"].setup({
	cmd = {"rust-analyzer"},
	cargo = {
		allFeatures = true,
	},
	procMacro = { enable = true },
	diagnostics = {
		experimental = { enable = true },
	},
	inlayHints = {
		bindingModeHints = { enable = true },
	},
})
