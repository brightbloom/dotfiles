local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true, -- disable virtual text (inline diagnostics)
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	-- LSP available handlers:
	--  ["textDocument/codeLens"]
	--  ["textDocument/completion"]
	--  ["textDocument/declaration"]
	--  ["textDocument/definition"]
	--  ["textDocument/documentHighlight"]
	--  ["textDocument/documentSymbol"]
	--  ["textDocument/formatting"]
	--  ["textDocument/hover"]
	--  ["textDocument/implementation"]
	--  ["textDocument/publishDiagnostics"]
	--  ["textDocument/rangeFormatting"]
	--  ["textDocument/references"]
	--  ["textDocument/rename"]
	--  ["textDocument/signatureHelp"]
	--  ["textDocument/typeDefinition"]

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

end

M.on_attach = function(client, _)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "lua_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.configure({
		providers = {
			"lsp",
			"treesitter",
		},
	})
	illuminate.on_attach(client)
end

return M
